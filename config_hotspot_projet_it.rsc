
/interface bridge
add name=LAN
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no frequency=auto \
    mode=ap-bridge ssid="WIFI ZONE" wireless-protocol=802.11
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip hotspot profile
add dns-name=wifi.wifi hotspot-address=192.168.99.1 http-cookie-lifetime=1w \
    login-by=cookie,http-chap,mac-cookie name=hsprof1
/ip pool
add name=DHCP-POOL ranges=192.168.99.10-192.168.99.200
/ip dhcp-server
add add-arp=yes address-pool=DHCP-POOL always-broadcast=yes disabled=no \
    interface=LAN name=DHCP-LAN
/ip hotspot
add address-pool=DHCP-POOL addresses-per-mac=1 disabled=no interface=LAN \
    name=hotspot1 profile=hsprof1
/interface bridge port
add bridge=LAN interface=ether2
add bridge=LAN interface=ether3
add bridge=LAN interface=ether4
add bridge=LAN interface=ether5
add bridge=LAN interface=wlan1
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/ip address
add address=192.168.99.1/24 interface=LAN network=192.168.99.0
/ip cloud
set ddns-enabled=yes ddns-update-interval=1m
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.99.0/24 dns-server=192.168.99.1,8.8.8.8 gateway=\
    192.168.99.1
/ip dns
set allow-remote-requests=yes servers=192.168.99.1,8.8.8.8
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat out-interface=ether1 src-address=\
    192.168.99.0/24
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.99.0/24
/ip firewall mangle
add action=change-ttl chain=postrouting new-ttl=set:1 out-interface=LAN passthrough=no    
/ip hotspot user
add name=PIT password=PIT
/system identity
set name=LAN_HOT