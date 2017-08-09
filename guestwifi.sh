#!/bin/sh
 
# This is supposed to be run on openwrt
 
# Written by Stanislav German-Evtushenko, 2014
# Based on [[:doc:recipes:guest-wlan]]

# Used for creating guest network interface for guest internet access using openwrt
 
# Configure guest network
uci delete network.guest
uci set network.guest=interface
uci set network.guest.proto=static
uci set network.guest.ipaddr=10.0.0.1
uci set network.guest.netmask=255.255.255.0
 
# Configure guest Wi-Fi
uci delete wireless.guest
uci set wireless.guest=wifi-iface
uci set wireless.guest.device=radio0
uci set wireless.guest.mode=ap
uci set wireless.guest.network=guest
uci set wireless.guest.ssid=SomeCoolName
uci set wireless.guest.encryption=psk2
uci set wireless.guest.key=somestupidwords
 
# Configure DHCP for guest network
uci delete dhcp.guest
uci set dhcp.guest=dhcp
uci set dhcp.guest.interface=guest
uci set dhcp.guest.start=50
uci set dhcp.guest.limit=200
uci set dhcp.guest.leasetime=1h
 
# Configure firewall for guest network
## Configure guest zone
uci delete firewall.guest_zone
uci set firewall.guest_zone=zone
uci set firewall.guest_zone.name=guest
uci set firewall.guest_zone.network=guest
uci set firewall.guest_zone.input=REJECT
uci set firewall.guest_zone.forward=REJECT
uci set firewall.guest_zone.output=ACCEPT
## Allow Guest -> Internet
uci delete firewall.guest_forwarding
uci set firewall.guest_forwarding=forwarding
uci set firewall.guest_forwarding.src=guest
uci set firewall.guest_forwarding.dest=wan
## Allow DNS Guest -> Router
uci delete firewall.guest_rule_dns
uci set firewall.guest_rule_dns=rule
uci set firewall.guest_rule_dns.name='Allow DNS Queries'
uci set firewall.guest_rule_dns.src=guest
uci set firewall.guest_rule_dns.dest_port=53
uci set firewall.guest_rule_dns.proto=udp
uci set firewall.guest_rule_dns.target=ACCEPT
## Allow DHCP Guest -> Router
uci delete firewall.guest_rule_dhcp
uci set firewall.guest_rule_dhcp=rule
uci set firewall.guest_rule_dhcp.name='Allow DHCP request'
uci set firewall.guest_rule_dhcp.src=guest
uci set firewall.guest_rule_dhcp.src_port=68
uci set firewall.guest_rule_dhcp.dest_port=67
uci set firewall.guest_rule_dhcp.proto=udp
uci set firewall.guest_rule_dhcp.target=ACCEPT
 
uci commit
 
