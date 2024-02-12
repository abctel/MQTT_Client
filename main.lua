
PROJECT = "MQTT_Client"
VERSION = "0.0.1"

log.info("project",PROJECT,"version",VERSION)


sys = require("sys")
sysplus = require("sysplus")

require("net_con")
require("mqtt_client")

--[[
1.功能信息配置
在config.lua中对MQTT Client的功能进行配置，包括MQTT服务器地址、端口、用户名、密码、订阅主题等。

2.MQTT接收消息处理。
在mqtt_client.lua中处理MQTT服务器的消息，包括订阅主题的消息接收、发布主题的消息发送。

3.网络连接管理。
在net_con.lua中管理MQTT Client的网络连接。
]]
sys.run()
