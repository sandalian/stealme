#!/bin/sh

# This shell script is used to send dweet from DietPi to dweet.io,
# passing result from uptime command and current DietPi's temperature.
# Change "someuniquename" an the last line into any name for your "thing".

posdata(){
        cat <<EOF
Last report at `uptime`. Temperature `cat /sys/class/thermal/thermal_zone0/temp` C.
EOF
}
curl --data "$(posdata)" "http://dweet.io/dweet/for/someuniquename"



