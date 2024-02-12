module(..., package.seeall)

require "config"

function net_con()
local device_id = mcu.unique_id():toHex()
if wlan and wlan.connect then
local ssid = config_wifi_ssid
local password = config_wifi_password

wlan.init()

wlan.setmode(wlan.STATION)

local device_id = wlan.getMac()

wlan.connect(ssid, password, 1)
log.debug("连接到WIFI网络: ", ssid, password)
elseif mobile then


log.debug("网络灯工作状态设置完成")

local device_id = mobile.imei()
elseif socket or mqtt then
else
while 1 do
sys.wait(1000)
log.debug("bsp", "未适配")
end
end

sys.waitUntil("IP_READY")
log.debug("网络连接状态：", "Hello，IM Wroking")
sys.publish("NET_OK", device_id)
log.debug("IMEI：", device_id, "本地获取的IP地址：", socket.localIP())
end

sys.taskInit(net_con)
