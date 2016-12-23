set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green

set nf [open task1.nam w]
$ns namtrace-all $nf
set tf [open task1.tr w]
$ns trace-all $tf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
#link L3
$ns duplex-link $n2 $n3 1Mb 10ms DropTail  
$ns duplex-link $n3 $n5 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail

#Setting up 2 TCP connections

set tcp_1 [new Agent/TCP]
$ns attach-agent $n0 $tcp_1
$tcp_1 set fid_ 1

set sink_1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink_1
$ns connect $tcp_1 $sink_1

set tcp_2 [new Agent/TCP]
$ns attach-agent $n1 $tcp_2
$tcp_2 set fid_ 2

set sink_2 [new Agent/TCPSink]
$ns attach-agent $n5 $sink_2
$ns connect $tcp_2 $sink_2

# Setting up 2 ftp applications

set ftp_1 [new Application/FTP]
$ftp_1 attach-agent $tcp_1

set ftp_2 [new Application/FTP]
$ftp_2 attach-agent $tcp_2

#Connection 3 UDP

set udp [new Agent/UDP]
$ns attach-agent $n4 $udp
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 3

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packetSize_ 500
$cbr set interval_ 0.005

proc finish {} {
  global ns nf tf
  $ns flush-trace
  close $nf
  close $tf
  exec nam task1.nam &
  exit 0
}

$ns at 1 "$ftp_1 start"
$ns at 1 "$ftp_2 start"
$ns at 2 "$cbr start"
$ns at 8 "$ftp_1 stop"
$ns at 8 "$ftp_2 stop"
$ns at 9 "$cbr stop"
$ns at 10 "finish"
$ns run
