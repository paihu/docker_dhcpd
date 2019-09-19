#!/bin/sh


print_range() {
    while read subnet
    do
        read netmask
        read start
        read end
        read router
        echo "subnet ${subnet} netmask ${netmask} {
        range ${start} ${end};
        option routers ${router};
        }
        "
    done
}

generate_conf() {
	        local_range=`ip addr | grep inet | grep global | head -1 | awk '{print $2}' | cut -d"/" -f1 | cut -d"." -f1-3`
		        cat <<EOF > /etc/dhcpd.conf
option domain-name-servers $DNS_SERVERS ;
default-lease-time ${LEASE_DEFAULT:-600};
max-lease-time ${LEASE_MAX:-1800};
subnet ${local_range}.0 netmask 255.255.255.0 {
}
EOF
echo $RANGE | tr "/" "\n" | print_range >> /etc/dhcpd.conf
}

ls /etc/dhcpd.conf
if [ $? != 0 ] ; then generate_conf; fi

ls /var/db/dhcpd.leases
if [ $? != 0 ] ; then touch /var/db/dhcpd.leases; fi

exec /usr/local/sbin/dhcpd -f

