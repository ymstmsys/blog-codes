sudo ip netns add router1
sudo ip netns add router2
sudo ip netns add router3
sudo ip netns add server1
sudo ip netns add server2
sudo ip netns add server3

sudo ip netns exec router1 sysctl net.ipv4.conf.all.forwarding=1
sudo ip netns exec router2 sysctl net.ipv4.conf.all.forwarding=1
sudo ip netns exec router3 sysctl net.ipv4.conf.all.forwarding=1

sudo ip netns exec router1 ip link add name tun12 type veth peer name tun12 netns router2
sudo ip netns exec router1 ip link set dev tun12 up
sudo ip netns exec router2 ip link set dev tun12 up
sudo ip netns exec router1 ip addr add 169.254.12.1/30 dev tun12
sudo ip netns exec router2 ip addr add 169.254.12.2/30 dev tun12

sudo ip netns exec router1 ip link add name tun13 type veth peer name tun13 netns router3
sudo ip netns exec router1 ip link set dev tun13 up
sudo ip netns exec router3 ip link set dev tun13 up
sudo ip netns exec router1 ip addr add 169.254.13.1/30 dev tun13
sudo ip netns exec router3 ip addr add 169.254.13.2/30 dev tun13

sudo ip netns exec router2 ip link add name tun23 type veth peer name tun23 netns router3
sudo ip netns exec router2 ip link set dev tun23 up
sudo ip netns exec router3 ip link set dev tun23 up
sudo ip netns exec router2 ip addr add 169.254.23.1/30 dev tun23
sudo ip netns exec router3 ip addr add 169.254.23.2/30 dev tun23

sudo ip netns exec router1 ip link add name eth0 type veth peer name eth0 netns server1
sudo ip netns exec router1 ip link set dev eth0 up
sudo ip netns exec server1 ip link set dev eth0 up
sudo ip netns exec router1 ip add add 10.1.0.1/24 dev eth0
sudo ip netns exec server1 ip add add 10.1.0.2/24 dev eth0
sudo ip netns exec server1 ip route add default dev eth0 via 10.1.0.1

sudo ip netns exec router2 ip link add name eth0 type veth peer name eth0 netns server2
sudo ip netns exec router2 ip link set dev eth0 up
sudo ip netns exec server2 ip link set dev eth0 up
sudo ip netns exec router2 ip add add 10.2.0.1/24 dev eth0
sudo ip netns exec server2 ip add add 10.2.0.2/24 dev eth0
sudo ip netns exec server2 ip route add default dev eth0 via 10.2.0.1

sudo ip netns exec router3 ip link add name eth0 type veth peer name eth0 netns server3
sudo ip netns exec router3 ip link set dev eth0 up
sudo ip netns exec server3 ip link set dev eth0 up
sudo ip netns exec router3 ip add add 10.3.0.1/24 dev eth0
sudo ip netns exec server3 ip add add 10.3.0.2/24 dev eth0
sudo ip netns exec server3 ip route add default dev eth0 via 10.3.0.1
