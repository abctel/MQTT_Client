-- 目标WIFI连接配置
config_wifi_ssid = "your_wifi_ssid"
config_wifi_password = "your_wifi_password"

-- MQTT服务端访问配置信息
-- 返回mqtt主机地址
config_mqtt_host = "broker.emqx.io"
-- 返回mqtt端口
config_mqtt_port = 1883
-- 返回是否使用SSL
config_mqtt_isssl = false
-- 返回是否是IPV6地址
config_mqtt_isipv6 = false
-- 返回MQTT用户名
config_mqtt_username = "XXXXXX"
-- 返回MQTT用户密码
config_mqtt_password = "DDDDDD"
-- 返回DEBUG调试开关
config_mqtt_debug = false


-- MQTT服务端订阅配置信息
-- 订阅读取消息
config_topic_read = "luatos/read/"
-- 订阅发送消息
config_topic_write = "luatos/write/"
-- 订阅遗嘱消息
config_topic_will = "luatios/will/"
-- 遗嘱消息内容
config_topic_will_msg = "IM_DIE"