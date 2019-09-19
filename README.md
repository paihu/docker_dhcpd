isc dhcpd docker image with alpine

##  build
```
docker build -t dhcpd:version .
```

## run example
if dhcpd.conf is not mount, then require bellow env
* DNS_SERVERS
* RANGE subnet/mask/start/end/routers/subnet2/mask2/start2/end2/routers2 ... 
### command
```
docker run --rm -d -p 67:67/udp -e DNS_SERVERS=192.168.0.1,192.168.0.2 -e RANGE=10.21.0.0/255.255.0.0/10.21.0.100/10.21.2.255/10.21.0.1/10.21.200.0/255.255.255.0/10.21.200.100/10.21.200.200/10.21.200.1 dhcpd:version
```

### generated config
```
option domain-name-servers 192.168.0.1,192.168.0.2;
default-lease-time 600;
max-lease-time 1800;
subnet xx.xx.xx.xx netmask 255.255.255.{
}

subnet 10.21.0.0 netmask 255.255.0.0 {
range 10.21.0.100 10.21.2.255;
option routers 10.21.0.1
}

subnet 10.21.200.0 netmask 255.255.255.0 {
range 10.21.200.100 10.21.200.200;
option routers 10.21.200.1
}
```

## other
* if you want to save leasedb, mount /var/db/ or /var/db/dhcp.leases
* if you want existing config, mount /etc/dhcpd.conf 

