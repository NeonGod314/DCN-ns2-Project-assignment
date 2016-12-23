set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green
$ns color 4 Yellow

set nf [open task2.nam w]
$ns namtrace-all $nf
set tf [open task2.tr w]
$ns trace-all $tf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]

$ns duplex-link $n0 $n4 1Mb 10ms DropTail
$ns duplex-link $n1 $n4 1Mb 10ms DropTail
$ns duplex-link $n2 $n4 1Mb 10ms DropTail  
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
#Link 5
$ns duplex-link $n4 $n5 1Mb 10ms DropTail		
$ns duplex-link $n5 $n6 1Mb 10ms DropTail
$ns duplex-link $n5 $n7 1Mb 10ms DropTail
$ns duplex-link $n5 $n8 1Mb 10ms DropTail
$ns duplex-link $n5 $n9 1Mb 10ms DropTail

# Setting up 2 TCP connections
set tcp_1 [new Agent/TCP]
$ns attach-agent $n0 $tcp_1
$tcp_1 set fid_ 1

set sink_1 [new Agent/TCPSink]
$ns attach-agent $n6 $sink_1
$ns connect $tcp_1 $sink_1

set tcp_2 [new Agent/TCP]
$ns attach-agent $n1 $tcp_2
$tcp_2 set fid_ 2

set sink_2 [new Agent/TCPSink]
$ns attach-agent $n7 $sink_2
$ns connect $tcp_2 $sink_2

# 2 FTP Applications
set ftp_1 [new Application/FTP]
$ftp_1 attach-agent $tcp_1

set ftp_2 [new Application/FTP]
$ftp_2 attach-agent $tcp_2

# 2 UDP conncetions for CBR
set udp_1 [new Agent/UDP]
$ns attach-agent $n2 $udp_1
set null [new Agent/Null]
$ns attach-agent $n9 $null
$ns connect $udp_1 $null
$udp_1 set fid_ 3

set cbr_1 [new Application/Traffic/CBR]
$cbr_1 attach-agent $udp_1
$cbr_1 set type_ CBR
$cbr_1 set packet_size_ 500
$cbr_1 set interval_ 0.005

set udp_2 [new Agent/UDP]
$ns attach-agent $n8 $udp_2
set null [new Agent/Null]
$ns attach-agent $n9 $null
$ns connect $udp_2 $null
$udp_2 set fid_ 4

set cbr_2 [new Application/Traffic/CBR]
$cbr_2 attach-agent $udp_2
$cbr_2 set type_ CBR
$cbr_2 set packet_size_ 500
$cbr_2 set interval_ 0.005

proc finish {} {
  global ns nf tf
  $ns flush-trace
  close $nf
  close $tf
  exec nam task2.nam &
  exit 0
}

$ns at 0.5 "$ftp_1 start"
$ns at 0.5 "$ftp_2 start"
$ns at 1 "$cbr_1 start"
$ns at 2 "$cbr_2 start"
$ns at 8.5 "$ftp_1 stop"
$ns at 8 "$ftp_2 stop"
$ns at 7 "$cbr_1 stop"
$ns at 7 "$cbr_2 stop"
$ns at 10 "finish"
$ns run
