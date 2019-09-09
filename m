Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96AAAAD41A
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388313AbfIIHqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:46:45 -0400
Received: from mail-eopbgr110100.outbound.protection.outlook.com ([40.107.11.100]:34112
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388282AbfIIHqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 03:46:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocogF72r9jC1zYk2O0fTkSA7yTHeV3SeyiJXymCvxp/W485gmFDwS5UQZPACx9BJf6JbONXO2jU3MaVA8xuRSgsc6nxI2om3ak0Ob8JGUOxrcyGwoKp0/JMHbKVPNFk2+ENz+QTm4Xjm8cTnrJUDeXJUMNMiKXFwwAgPbMyqbi4ckox3O87nPd4y1lQyMq762jDfjnRur2VJdyNdd3hxFW2qn1i8UE7UjIYf7WrBlNW3+rl367QeRocEd+OT2tGWVcHQFeujaMc1oWUQHjKM0kkBtYBdIWlli5nKKSIw78Z9vYafni3HTT3PwnMlW89zB7HGYOf/SMPiF8wkrAeHhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOqCyBvb5G1pYoCluwIoiU/KB936MD6HC2OLG5nAkQQ=;
 b=BJvWsGiQaU+asoNBKafqzZHeUKrkCYrrlOB6a8uC/yur2tygDFZsNkHz8erKy70Ou6xjunCwY7Pci+skg2xdMuFlEXhd4tLPXais3qYIpBMnyCK4XYkB9pqz3tjgmlTGcWVUQjr6IB/5F5U5SjEDsNy961U7mvtIUVM+xZIbS6jtc6xI28C08v8z/xwBBqdHH9i1pBEPjqgFfRD6+nRPKbiohOatmJ0aHYfeY8VcRSMF4AmVHYkf1l77zNBFzUAf3DAPjAY2dr6ZHymXfdmLgU1eoYeHt9qXBiZR7vuojrrb+rbXFYFj1tS9mvbTf/aB6nxu4CKIRAWDPLIpFrcueA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=potatocomputing.co.uk; dmarc=pass action=none
 header.from=potatocomputing.co.uk; dkim=pass header.d=potatocomputing.co.uk;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT4492442.onmicrosoft.com;
 s=selector2-NETORGFT4492442-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOqCyBvb5G1pYoCluwIoiU/KB936MD6HC2OLG5nAkQQ=;
 b=nR21iXVwPnV6R2poiReCcMR+m/Jjv8Arwx4RqImS2r6VX5H93aqwgLAlhBeXZz8iId8ajj5zmu94rk5qA7Z4AlV9i2ioya4uWi1mdu4hpsXdRxUbBty1dgOA2TtvqRU3z5eigjSwoclx40EW3SXiQNBRctXDDEs5JJQk8iI2sxs=
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM (20.176.38.150) by
 CWLP265MB1716.GBRP265.PROD.OUTLOOK.COM (20.176.38.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 07:46:40 +0000
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547]) by CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547%7]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 07:46:40 +0000
From:   Gowen <gowen@potatocomputing.co.uk>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: VRF Issue Since kernel 5
Thread-Topic: VRF Issue Since kernel 5
Thread-Index: AQHVZuKrrHmXIhazUku6D0pNIn18Hw==
Date:   Mon, 9 Sep 2019 07:46:40 +0000
Message-ID: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gowen@potatocomputing.co.uk; 
x-originating-ip: [51.141.26.231]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91d67ae4-6662-4dbb-d3f2-08d734f9da0d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CWLP265MB1716;
x-ms-traffictypediagnostic: CWLP265MB1716:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CWLP265MB171681DD12AF2FD3AEEC84E4FDB70@CWLP265MB1716.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39830400003)(396003)(366004)(136003)(346002)(189003)(199004)(45904002)(8676002)(53936002)(5640700003)(9686003)(7736002)(81156014)(81166006)(1730700003)(52536014)(6116002)(64756008)(3846002)(102836004)(14444005)(256004)(55236004)(6916009)(486006)(2906002)(66446008)(66476007)(305945005)(15974865002)(66946007)(55016002)(66066001)(476003)(86362001)(74316002)(71190400001)(71200400001)(8936002)(76116006)(316002)(6506007)(91956017)(66556008)(186003)(14454004)(5660300002)(33656002)(25786009)(2351001)(6436002)(508600001)(26005)(99286004)(7696005)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:CWLP265MB1716;H:CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: potatocomputing.co.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uBvWEF32kM5cuh8LcIgVS42yIQKiHSmaH7BzrYCd4Kv+KEKcX2gQurkxsfx9ED8j9U4Rd6ZuEPzJv72o5+ucY2vIKiD3oH1R1uOd0wmBPT2dLnRkYLcllQloJOjQXtZLI5ZjQR48ruLFGMByluyKvu4hEAduV36t26d53+0Azl97hgGvB5GMd9HDKHIPSv52922UT35hDQ0r42bEVMu3dUexmCXoTnSfrB3JDQZrmIAgN8MVh7h607FaWvQdH31vGiPF4hjqRyJxtsaUG6S1V/YYk4vaQz4vPM9/ceHRmDJ+rCgMypCLPYz5hxgc/+w/8eFekasUa877L0Njn6H4UctVzJijEa47igUgdREbn+zZx04PGKm+DDuyW/oaIseO8qq5cHSrqTZb7ecXjwJiASDF3Wdt43HC228Zcvj64vQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: potatocomputing.co.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d67ae4-6662-4dbb-d3f2-08d734f9da0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 07:46:40.4875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b0e486ce-86f8-410c-aa6d-e814c15cfeb8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbAHzXPjXe7/UQpRJVijJAB1m/5gCV06PJC45SZ6dKiEkBITHTBkKC7H+T1Vzk7kNMXd5YvrJAPZeO66AUYJhG3kZFprh95qQipk0j9YZFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB1716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,=0A=
=0A=
Dave A said this was the mailer to send this to:=0A=
=0A=
=0A=
I=92ve been using my management interface in a VRF for several months now a=
nd it=92s worked perfectly =96 I=92ve been able to update/upgrade the packa=
ges just fine and iptables works excellently with it =96 exactly as I neede=
d.=0A=
=0A=
=0A=
Since Kernel 5 though I am no longer able to update =96 but the issue is qu=
ite a curious one as some traffic appears to be fine (DNS lookups use VRF c=
orrectly) but others don=92t (updating/upgrading the packages)=0A=
=0A=
=0A=
I have on this device 2 interfaces:=0A=
Eth0 for management =96 inbound SSH, DNS, updates/upgrades=0A=
Eth1 for managing other boxes (ansible using SSH)=0A=
=0A=
=0A=
Link and addr info shown below:=0A=
=0A=
=0A=
Admin@NETM06:~$ ip link show=0A=
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DE=
FAULT group default qlen 1000=0A=
=A0=A0=A0 link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00=0A=
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mgmt-vr=
f state UP mode DEFAULT group default qlen 1000=0A=
=A0=A0=A0 link/ether 00:22:48:07:cc:ad brd ff:ff:ff:ff:ff:ff=0A=
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode =
DEFAULT group default qlen 1000=0A=
=A0=A0=A0 link/ether 00:22:48:07:c9:6c brd ff:ff:ff:ff:ff:ff=0A=
4: mgmt-vrf: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP mo=
de DEFAULT group default qlen 1000=0A=
=A0=A0=A0 link/ether 8a:f6:26:65:02:5a brd ff:ff:ff:ff:ff:ff=0A=
=0A=
=0A=
Admin@NETM06:~$ ip addr=0A=
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group d=
efault qlen 1000=0A=
=A0=A0=A0 link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00=0A=
=A0=A0=A0 inet 127.0.0.1/8 scope host lo=0A=
=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
=A0=A0=A0 inet6 ::1/128 scope host=0A=
=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mgmt-vr=
f state UP group default qlen 1000=0A=
=A0=A0=A0 link/ether 00:22:48:07:cc:ad brd ff:ff:ff:ff:ff:ff=0A=
=A0=A0=A0 inet 10.24.12.10/24 brd 10.24.12.255 scope global eth0=0A=
=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
=A0=A0=A0 inet6 fe80::222:48ff:fe07:ccad/64 scope link=0A=
=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group=
 default qlen 1000=0A=
=A0=A0=A0 link/ether 00:22:48:07:c9:6c brd ff:ff:ff:ff:ff:ff=0A=
=A0=A0=A0 inet 10.24.12.9/24 brd 10.24.12.255 scope global eth1=0A=
=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
=A0=A0=A0 inet6 fe80::222:48ff:fe07:c96c/64 scope link=0A=
=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
4: mgmt-vrf: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state UP gr=
oup default qlen 1000=0A=
=A0=A0=A0 link/ether 8a:f6:26:65:02:5a brd ff:ff:ff:ff:ff:ff=0A=
=0A=
=0A=
=0A=
the production traffic is all in the 10.0.0.0/8 network (eth1 global VRF) e=
xcept for a few subnets (DNS) which are routed out eth0 (mgmt-vrf)=0A=
=0A=
=0A=
Admin@NETM06:~$ ip route show=0A=
default via 10.24.12.1 dev eth0=0A=
10.0.0.0/8 via 10.24.12.1 dev eth1=0A=
10.24.12.0/24 dev eth1 proto kernel scope link src 10.24.12.9=0A=
10.24.65.0/24 via 10.24.12.1 dev eth0=0A=
10.25.65.0/24 via 10.24.12.1 dev eth0=0A=
10.26.0.0/21 via 10.24.12.1 dev eth0=0A=
10.26.64.0/21 via 10.24.12.1 dev eth0=0A=
=0A=
=0A=
Admin@NETM06:~$ ip route show vrf mgmt-vrf=0A=
default via 10.24.12.1 dev eth0=0A=
unreachable default metric 4278198272=0A=
10.24.12.0/24 dev eth0 proto kernel scope link src 10.24.12.10=0A=
10.24.65.0/24 via 10.24.12.1 dev eth0=0A=
10.25.65.0/24 via 10.24.12.1 dev eth0=0A=
10.26.0.0/21 via 10.24.12.1 dev eth0=0A=
10.26.64.0/21 via 10.24.12.1 dev eth0=0A=
=0A=
=0A=
=0A=
The strange activity occurs when I enter the command =93sudo apt update=94 =
as I can resolve the DNS request (10.24.65.203 or 10.24.64.203, verified wi=
th tcpdump) out eth0 but for the actual update traffic there is no activity=
:=0A=
=0A=
=0A=
sudo tcpdump -i eth0 '(host 10.24.65.203 or host 10.25.65.203) and port 53'=
 -n=0A=
<OUTPUT OMITTED FOR BREVITY>=0A=
10:06:05.268735 IP 10.24.12.10.39963 > 10.24.65.203.53: 48798+ [1au] A? sec=
urity.ubuntu.com. (48)=0A=
<OUTPUT OMITTED FOR BREVITY>=0A=
10:06:05.284403 IP 10.24.65.203.53 > 10.24.12.10.39963: 48798 13/0/1 A 91.1=
89.91.23, A 91.189.88.24, A 91.189.91.26, A 91.189.88.162, A 91.189.88.149,=
 A 91.189.91.24, A 91.189.88.173, A 91.189.88.177, A 91.189.88.31, A 91.189=
.91.14, A 91.189.88.176, A 91.189.88.175, A 91.189.88.174 (256)=0A=
=0A=
=0A=
=0A=
You can see that the update traffic is returned but is not accepted by the =
stack and a RST is sent=0A=
=0A=
=0A=
Admin@NETM06:~$ sudo tcpdump -i eth0 '(not host 168.63.129.16 and port 80)'=
 -n=0A=
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode=
=0A=
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes=
=0A=
10:17:12.690658 IP 10.24.12.10.40216 > 91.189.88.175.80: Flags [S], seq 227=
9624826, win 64240, options [mss 1460,sackOK,TS val 2029365856 ecr 0,nop,ws=
cale 7], length 0=0A=
10:17:12.691929 IP 10.24.12.10.52362 > 91.189.95.83.80: Flags [S], seq 1465=
797256, win 64240, options [mss 1460,sackOK,TS val 3833463674 ecr 0,nop,wsc=
ale 7], length 0=0A=
10:17:12.696270 IP 91.189.88.175.80 > 10.24.12.10.40216: Flags [S.], seq 96=
8450722, ack 2279624827, win 28960, options [mss 1418,sackOK,TS val 8195710=
3 ecr 2029365856,nop,wscale 7], length 0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=0A=
10:17:12.696301 IP 10.24.12.10.40216 > 91.189.88.175.80: Flags [R], seq 227=
9624827, win 0, length 0=0A=
10:17:12.697884 IP 91.189.95.83.80 > 10.24.12.10.52362: Flags [S.], seq 414=
8330738, ack 1465797257, win 28960, options [mss 1418,sackOK,TS val 2257624=
414 ecr 3833463674,nop,wscale 8], length 0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=0A=
10:17:12.697909 IP 10.24.12.10.52362 > 91.189.95.83.80: Flags [R], seq 1465=
797257, win 0, length 0=0A=
=0A=
=0A=
=0A=
=0A=
I can emulate the DNS lookup using netcat in the vrf:=0A=
=0A=
=0A=
sudo ip vrf exec mgmt-vrf nc -u 10.24.65.203 53=0A=
=0A=
=0A=
then interactively enter the binary for a=A0www.google.co.uk=A0request:=0A=
=0A=
=0A=
0035624be394010000010000000000010377777706676f6f676c6502636f02756b000001000=
10000290200000000000000=0A=
=0A=
=0A=
This returns as expected:=0A=
=0A=
=0A=
00624be394010000010000000000010377777706676f6f676c6502636f02756b00000100010=
000290200000000000000=0A=
=0A=
=0A=
I can run:=0A=
=0A=
=0A=
Admin@NETM06:~$ host www.google.co.uk=0A=
www.google.co.uk has address 172.217.169.3=0A=
www.google.co.uk has IPv6 address 2a00:1450:4009:80d::2003=0A=
=0A=
=0A=
but I get a timeout for:=0A=
=0A=
=0A=
sudo ip vrf=A0 exec mgmt-vrf host=A0www.google.co.uk=0A=
;; connection timed out; no servers could be reached=0A=
=0A=
=0A=
=0A=
However I can take a repo address and vrf exec to it on port 80:=0A=
=0A=
=0A=
Admin@NETM06:~$ sudo ip vrf=A0 exec mgmt-vrf nc 91.189.91.23 80=0A=
hello=0A=
HTTP/1.1 400 Bad Request=0A=
<OUTPUT OMITTED>=0A=
=0A=
My iptables rule:=0A=
=0A=
=0A=
sudo iptables -Z=0A=
Admin@NETM06:~$ sudo iptables -L -v=0A=
Chain INPUT (policy DROP 16 packets, 3592 bytes)=0A=
pkts bytes target=A0=A0=A0=A0 prot opt in=A0=A0=A0=A0 out=A0=A0=A0=A0 sourc=
e=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 destination=0A=
=A0=A0 44=A0 2360 ACCEPT=A0=A0=A0=A0 tcp=A0 --=A0 any=A0=A0=A0 any=A0=A0=A0=
=A0 anywhere=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 anywhere=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 tcp spt:http ctstate RELATED,ESTABLISHED=0A=
=A0=A0 83 10243 ACCEPT=A0=A0=A0=A0 udp=A0 --=A0 any=A0=A0=A0 any=A0=A0=A0=
=A0 anywhere=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 anywhere=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 udp spt:domain ctstate RELATED,ESTABLISHED=0A=
=0A=
=0A=
=0A=
I cannot find out why the update isn=92t working. Any help greatly apprecia=
ted=0A=
=0A=
=0A=
Kind Regards,=0A=
=0A=
=0A=
Gareth=0A=
