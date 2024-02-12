module(..., package.seeall)

require("config")

local mqttc = nil

-- 定义一个异步任务，并在任务内部进行操作
sys.taskInit(function()
    -- 等待网络状态为"NET_OK"，并获取返回值和设备ID
    local ret, device_id = sys.waitUntil("NET_OK")
    -- 如果mqtt对象为空，则进入循环检查固件支持情况
    if mqtt == nil then
        while 1 do
            -- 每隔5000毫秒等待
            sys.wait(5000)
            -- 记录错误日志，提示不支持MQTT库，请检查固件支持情况
            log.error("不支持MQTT库，请检查固件是否支持")
        end
    end
    -- 发布"MQTT_OK"消息和设备ID
    sys.publish("MQTT_OK", device_id)
    -- 记录调试日志，提示MQTT库检查完成
    log.debug("MQTT库检查完成")
end)

-- 初始化MQTT客户端连接
sys.taskInit(function()
    -- 等待MQTT连接成功
    local ret, device_id = sys.waitUntil("MQTT_OK")
    log.debug("网络", ret, device_id)

    -- 创建MQTT客户端
    mqttc = mqtt.create(nil, config_mqtt_host, config_mqtt_port, config_mqtt_isssl)
    log.debug("MQTT客户端创建信息：", config_mqtt_host, config_mqtt_port, "isssl:", config_mqtt_isssl)
    mqttc:debug(config_mqtt_debug)
    log.debug("MQTT_Debug开关", config_mqtt_debug)

    -- 设置保持连接时间
    mqttc:keepalive(300)
    log.debug("MQTT心跳时间设置完成：5分钟")

    -- 设置断线自动重连
    mqttc:autoreconn(true, 3000)
    log.debug("MQTT断线后每3s自动重连设置完成")

    -- 鉴权信息配置
    mqttc:auth(device_id, config_mqtt_username, config_mqtt_password)
    log.debug("MQTT认证信息配置完成：", device_id, config_mqtt_username, config_mqtt_password)

    -- 设置遗愿消息
    mqttc:will(config_topic_will, config_topic_will_msg)
    log.debug("MQTT遗愿信息配置完成：", config_topic_will, config_topic_will_msg)

    -- 注册MQTT事件回调
    mqttc:on(function(mqtt_client, event, data, payload, metas)
        log.debug("MQTT回调信息：", event, mqtt_client, data, payload, metas)

        -- 设置GPIO引脚
        gpio.setup(27, 1, gpio.PULLUP)
        gpio.setup(27, 0, gpio.PULLDOWN)

        if event == "conack" then
            -- 发布MQTT连接成功状态
            sys.publish("MQTT_CONACK")
            log.debug("MQTTC连接成功")

            -- 订阅主题并发布消息
            mqtt_client:subscribe(config_topic_read)
            log.debug("MQTT订阅主题：", config_topic_read)
            mqttc:publish(config_topic_write, "IM_COMING", 1)

        elseif event == "recv" then
            -- 处理收到的消息
            if payload == "close" then
                -- 断开连接
                mqttc:disconnect()
                log.debug("MQTT断开连接")
                mqttc:close()
                mqttc = nil
                log.debug("MQTT连接关闭")
            elseif payload == "hello" then
                mqttc:publish(config_topic_write, "hello,buddy", 1)
            elseif payload == "diss" then
                mobile.flymode(0, true)
                log.debug("飞行模式开启")
                sys.timerStart(function()
                    mobile.flymode(0, false)
                    log.debug("飞行模式关闭")
                end, 10000)
            end

        elseif event == "sent" then
            -- 处理消息发送事件

        elseif event == "disconnect" then
            -- 手机网络和飞行模式状态
            log.debug("手机网络状态：", mobile.status(), "飞行模式状态：", mobile.flymode())
        end
    end)
    -- 发布MQTT配置完成状态
    sys.publish("MQTT_CONFIG_OK")

    log.debug("MQTT事件回调注册完成")
end)

-- 初始化MQTT连接任务
sys.taskInit(function()
    -- 等待MQTT配置完成
    sys.waitUntil("MQTT_CONFIG_OK")
    -- 连接MQTT服务器
    mqttc:connect()
    -- 等待MQTT连接成功状态
    sys.waitUntil("MQTT_CONACK")
end)

sys.taskInit(function()
    local ret, data, payload = sys.waitUntil("MQTT_RECV")

end)

sys.run()
