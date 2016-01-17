import sys
from netaddr import IPNetwork, IPAddress, cidr_merge

ip_network_cidr = []
fh     = open (sys.argv[1], 'r')
iplist = list()
for addr in fh:
    addr = (addr.strip())
    iplist.append (addr)

fh.close()
ip_range =  cidr_merge(iplist)

for ip_object in ip_range:
	ip_network_cidr.append(str(ip_object))

print "\n".join(ip_network_cidr)
