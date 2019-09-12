Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F583B0904
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 08:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfILGum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 02:50:42 -0400
Received: from mail-eopbgr100103.outbound.protection.outlook.com ([40.107.10.103]:25529
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725765AbfILGul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 02:50:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKi7jTQJ5FpGFh8mvaphUnKgHrJSCYU3FK/SM2vpxIBd67oPO+o4yOemCLVnK8aost43XpJNFmlkKSW4cJdWGNxPV0iwN3lEFZOMEBdz+HQHIbkc+L6WJzUEUPXL1ps3SBJneHPlBHy9xeGJtMqSSfvLdNg2BpG8kD0NS18yVhQ71hi9qMy1cXIZdyReRfx40sL5KB96fP119D7ullBM6iRlaTFzv/xXBALgV7/tsNEHBcaVDsabDF9eJVTBgoHGaFK3OSzJpL6bnSRv7R+2pyGfWb8WXaQRZFTEsMQF8cLRQ42TdSrvIQ3XM9G5pxcZlqG+vD1GMYhtD0S00kgXOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8mOnEisa2A1ldwvEYflZmqPryPzn+W+cZCf6du5i7Y=;
 b=cKrFFk+Z+eqPYlP+9eCz3vSMqnjPMFxx33W2j4KSaf+iX5hacxctmBU/cpR6B0KPipBjxwgpN0rxcsNjnOyRPtNFbpugllMAmU7bnEYJL1LLn4wjWGBNv97Bd5foi/7rO3t8LUL2ZD3PTmz/WEGe01TFCHUKpvBLugCIb/6uNpIm6m2mtAX4tbCYI8juLarIR5HM+aJAvy2ifM8KvlUoExIlU0xwKcoRi5fVWigukIMn7iGHK/tFgwCdDFIMQIWxiptSWmWwqy+dDC6/Uua4s+Z+GJWeIZR4XPRVdL6RK4D1E06TcZ77/5xAw08yey8s7OkTGaeyicFGmycxjgx/eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=potatocomputing.co.uk; dmarc=pass action=none
 header.from=potatocomputing.co.uk; dkim=pass header.d=potatocomputing.co.uk;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT4492442.onmicrosoft.com;
 s=selector2-NETORGFT4492442-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8mOnEisa2A1ldwvEYflZmqPryPzn+W+cZCf6du5i7Y=;
 b=ZZXgHnr5CBTE+/LB9GUtK/zmbRVuyWiGXHbyTeR78v+sqUJwSP5vbE8FzIUpH0//AwL1pbfTwlNPOV5DveJ0AzW7I6wz8j2zCVRyXiDKiClEOnrEEMvo5UZPVxNACSG40vhBnvckm5WkqXk0BpxSnOsLHuTT4DvUxDh7d4xqebQ=
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM (20.176.38.150) by
 CWLP265MB1793.GBRP265.PROD.OUTLOOK.COM (20.180.138.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.14; Thu, 12 Sep 2019 06:50:38 +0000
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547]) by CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547%7]) with mapi id 15.20.2263.016; Thu, 12 Sep 2019
 06:50:38 +0000
From:   Gowen <gowen@potatocomputing.co.uk>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: VRF Issue Since kernel 5
Thread-Topic: VRF Issue Since kernel 5
Thread-Index: AQHVZuKrrHmXIhazUku6D0pNIn18H6cmt3yAgADh58o=
Date:   Thu, 12 Sep 2019 06:50:37 +0000
Message-ID: <CWLP265MB15547011D9510DEA6475B469FDB00@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>,<b300235a-00f8-0689-8544-9db07cbd1e21@gmail.com>
In-Reply-To: <b300235a-00f8-0689-8544-9db07cbd1e21@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gowen@potatocomputing.co.uk; 
x-originating-ip: [51.141.26.231]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d403775-1fd0-4a7a-1743-08d7374d850d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CWLP265MB1793;
x-ms-traffictypediagnostic: CWLP265MB1793:
x-microsoft-antispam-prvs: <CWLP265MB179327D79DAFBA835C78ED55FDB00@CWLP265MB1793.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(136003)(376002)(39830400003)(346002)(189003)(199004)(508600001)(55016002)(14454004)(8936002)(66066001)(256004)(186003)(14444005)(9686003)(6436002)(53936002)(2501003)(6246003)(3846002)(81156014)(81166006)(6116002)(486006)(446003)(33656002)(476003)(11346002)(7736002)(305945005)(25786009)(74316002)(8676002)(86362001)(7696005)(76176011)(2906002)(229853002)(316002)(110136005)(5660300002)(66946007)(91956017)(76116006)(99286004)(55236004)(66476007)(66556008)(64756008)(66446008)(26005)(102836004)(53546011)(6506007)(52536014)(71190400001)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CWLP265MB1793;H:CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: potatocomputing.co.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /uestpUsICevp0AswTyXT0xyqFDANtIht2/zcQACB6iMYElBEBFmAf1FFjRwhQzWXm5WfYpRy/AHftf3KjE73gIqYIisDb3Qt/9X3O43pNnUvvjPaTx6UQNF28PK5sFHpB9MIzO2RqhzkVTmH6DFrDM3UeMIxUNt9MqKaHVao/lyLletZjqCEbs6FtBGy9pLEN9LqJdBPVObH631ZLoXE2u2P811Km+tNqmhr1pUUz6zLod1o73faEa8BR6VwrU3TvVFDZoValSHXVnqMQm7uXMY+p8OGA6vBMEMIgWcQowzjda8nfVsQxQMFd9uOe28daMFBqjyNvNL8p9JORGczuott9Sjr2J5d2kW15fU1LD9MPbnCStjzugosPJ2ism57lz+rC3CCsiFg0myayJBfFX9HknNSn2vRBuDRUHg8Bg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: potatocomputing.co.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d403775-1fd0-4a7a-1743-08d7374d850d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 06:50:37.9572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b0e486ce-86f8-410c-aa6d-e814c15cfeb8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oCrP5FD3Z7Ihkh1tq1T7IGRl66DHQAfgFt9slMk9ziXWnMJOWUWVDvarJxJ73T9cZ2QY8eQvlCN45FZzAJLG7DTSLOvueUlJ4PVm0LKCbVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB1793
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
Hi David -thanks for getting back to me=0A=
=0A=
=0A=
=0A=
The DNS servers are 10.24.65.203 or 10.24.64.203 which you want to go=0A=
=0A=
out mgmt-vrf. correct? No - 10.24.65.203 10.25.65.203, so should hit the ro=
ute leak rule as below (if I've put the 10.24.64.0/24 subnet anywhere it is=
 a typo)=0A=
=0A=
vmAdmin@NETM06:~$ ip ro get 10.24.65.203 fibmatch=0A=
10.24.65.0/24 via 10.24.12.1 dev eth0=0A=
=0A=
=0A=
I've added the 127/8 route - no difference.=0A=
=0A=
The reason for what you might think is an odd design is that I wanted any n=
on-VRF aware users to be able to come in and run all commands in default co=
ntext without issue, while production and mgmt traffic was separated still=
=0A=
=0A=
DNS is now working as long as /etc/resolv.conf is populated with my DNS ser=
vers - a lot of people would be using this on Azure which uses netplan, so =
they'll have the same issue, is there documentation I could update or raise=
 a bug to check the systemd-resolve servers as well?=0A=
=0A=
Gareth=0A=
=0A=
=0A=
From: David Ahern <dsahern@gmail.com>=0A=
=0A=
Sent: 11 September 2019 18:02=0A=
=0A=
To: Gowen <gowen@potatocomputing.co.uk>; netdev@vger.kernel.org <netdev@vge=
r.kernel.org>=0A=
=0A=
Subject: Re: VRF Issue Since kernel 5=0A=
=0A=
=A0=0A=
=0A=
=0A=
At LPC this week and just now getting a chance to process the data you sent=
.=0A=
=0A=
=0A=
=0A=
On 9/9/19 8:46 AM, Gowen wrote:=0A=
=0A=
> the production traffic is all in the 10.0.0.0/8 network (eth1 global VRF)=
 except for a few subnets (DNS) which are routed out eth0 (mgmt-vrf)=0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> Admin@NETM06:~$ ip route show=0A=
=0A=
> default via 10.24.12.1 dev eth0=0A=
=0A=
> 10.0.0.0/8 via 10.24.12.1 dev eth1=0A=
=0A=
> 10.24.12.0/24 dev eth1 proto kernel scope link src 10.24.12.9=0A=
=0A=
> 10.24.65.0/24 via 10.24.12.1 dev eth0=0A=
=0A=
> 10.25.65.0/24 via 10.24.12.1 dev eth0=0A=
=0A=
> 10.26.0.0/21 via 10.24.12.1 dev eth0=0A=
=0A=
> 10.26.64.0/21 via 10.24.12.1 dev eth0=0A=
=0A=
=0A=
=0A=
interesting route table. This is default VRF but you have route leaking=0A=
=0A=
through eth0 which is in mgmt-vrf.=0A=
=0A=
=0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> Admin@NETM06:~$ ip route show vrf mgmt-vrf=0A=
=0A=
> default via 10.24.12.1 dev eth0=0A=
=0A=
> unreachable default metric 4278198272=0A=
=0A=
> 10.24.12.0/24 dev eth0 proto kernel scope link src 10.24.12.10=0A=
=0A=
> 10.24.65.0/24 via 10.24.12.1 dev eth0=0A=
=0A=
> 10.25.65.0/24 via 10.24.12.1 dev eth0=0A=
=0A=
> 10.26.0.0/21 via 10.24.12.1 dev eth0=0A=
=0A=
> 10.26.64.0/21 via 10.24.12.1 dev eth0=0A=
=0A=
=0A=
=0A=
The DNS servers are 10.24.65.203 or 10.24.64.203 which you want to go=0A=
=0A=
out mgmt-vrf. correct?=0A=
=0A=
=0A=
=0A=
10.24.65.203 should hit the route "10.24.65.0/24 via 10.24.12.1 dev=0A=
=0A=
eth0" for both default VRF and mgmt-vrf.=0A=
=0A=
=0A=
=0A=
10.24.64.203 will NOT hit a route leak entry so traverse the VRF=0A=
=0A=
associated with the context of the command (mgmt-vrf or default). Is=0A=
=0A=
that intentional? (verify with: `ip ro get 10.24.64.203 fibmatch` and=0A=
=0A=
`ip ro get 10.24.64.203 vrf mgmt-vrf fibmatch`)=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> The strange activity occurs when I enter the command =93sudo apt update=
=94 as I can resolve the DNS request (10.24.65.203 or 10.24.64.203, verifie=
d with tcpdump) out eth0 but for the actual update traffic there is no acti=
vity:=0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> sudo tcpdump -i eth0 '(host 10.24.65.203 or host 10.25.65.203) and port 5=
3' -n=0A=
=0A=
> <OUTPUT OMITTED FOR BREVITY>=0A=
=0A=
> 10:06:05.268735 IP 10.24.12.10.39963 > 10.24.65.203.53: 48798+ [1au] A? s=
ecurity.ubuntu.com. (48)=0A=
=0A=
> <OUTPUT OMITTED FOR BREVITY>=0A=
=0A=
> 10:06:05.284403 IP 10.24.65.203.53 > 10.24.12.10.39963: 48798 13/0/1 A 91=
.189.91.23, A 91.189.88.24, A 91.189.91.26, A 91.189.88.162, A 91.189.88.14=
9, A 91.189.91.24, A 91.189.88.173, A 91.189.88.177, A 91.189.88.31, A 91.1=
89.91.14, A 91.189.88.176, A 91.189.88.175,=0A=
 A 91.189.88.174 (256)=0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> You can see that the update traffic is returned but is not accepted by th=
e stack and a RST is sent=0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> Admin@NETM06:~$ sudo tcpdump -i eth0 '(not host 168.63.129.16 and port 80=
)' -n=0A=
=0A=
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decod=
e=0A=
=0A=
> listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes=
=0A=
=0A=
> 10:17:12.690658 IP 10.24.12.10.40216 > 91.189.88.175.80: Flags [S], seq 2=
279624826, win 64240, options [mss 1460,sackOK,TS val 2029365856 ecr 0,nop,=
wscale 7], length 0=0A=
=0A=
> 10:17:12.691929 IP 10.24.12.10.52362 > 91.189.95.83.80: Flags [S], seq 14=
65797256, win 64240, options [mss 1460,sackOK,TS val 3833463674 ecr 0,nop,w=
scale 7], length 0=0A=
=0A=
> 10:17:12.696270 IP 91.189.88.175.80 > 10.24.12.10.40216: Flags [S.], seq =
968450722, ack 2279624827, win 28960, options [mss 1418,sackOK,TS val 81957=
103 ecr 2029365856,nop,wscale 7], length 0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=0A=
 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=0A=
=0A=
> 10:17:12.696301 IP 10.24.12.10.40216 > 91.189.88.175.80: Flags [R], seq 2=
279624827, win 0, length 0=0A=
=0A=
> 10:17:12.697884 IP 91.189.95.83.80 > 10.24.12.10.52362: Flags [S.], seq 4=
148330738, ack 1465797257, win 28960, options [mss 1418,sackOK,TS val 22576=
24414 ecr 3833463674,nop,wscale 8], length 0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=0A=
=0A=
> 10:17:12.697909 IP 10.24.12.10.52362 > 91.189.95.83.80: Flags [R], seq 14=
65797257, win 0, length 0=0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> I can emulate the DNS lookup using netcat in the vrf:=0A=
=0A=
> =0A=
=0A=
> =0A=
=0A=
> sudo ip vrf exec mgmt-vrf nc -u 10.24.65.203 53=0A=
=0A=
> =0A=
=0A=
=0A=
=0A=
`ip vrf exec mgmt-vrf <COMMAND>` means that every IPv4 and IPv6 socket=0A=
=0A=
opened by <COMMAND> is automatically bound to mgmt-vrf which causes=0A=
=0A=
route lookups to hit the mgmt-vrf table.=0A=
=0A=
=0A=
=0A=
Just running <COMMAND> (without binding to any vrf) means no socket is=0A=
=0A=
bound to anything unless the command does a bind. In that case the=0A=
=0A=
routing lookups determine which egress device is used.=0A=
=0A=
=0A=
=0A=
Now the response comes back, if the ingress interface is a VRF then the=0A=
=0A=
socket lookup wants to match on a device.=0A=
=0A=
=0A=
=0A=
Now, a later response shows this for DNS lookups:=0A=
=0A=
=0A=
=0A=
=A0 isc-worker0000 20261 [000]=A0 2215.013849: fib:fib_table_lookup: table=
=0A=
=0A=
10 oif 0 iif 0 proto 0 0.0.0.0/0 -> 127.0.0.1/0 tos 0 scope 0 flags 0=0A=
=0A=
=3D=3D> dev eth0 gw 10.24.12.1 src 10.24.12.10 err 0=0A=
=0A=
=A0 isc-worker0000 20261 [000]=A0 2215.013915: fib:fib_table_lookup: table=
=0A=
=0A=
10 oif 4 iif 1 proto 17 0.0.0.0/52138 -> 127.0.0.53/53 tos 0 scope 0=0A=
=0A=
flags 4 =3D=3D> dev eth0 gw 10.24.12.1 src 10.24.12.10 err 0=0A=
=0A=
=A0 isc-worker0000 20261 [000]=A0 2220.014006: fib:fib_table_lookup: table=
=0A=
=0A=
10 oif 4 iif 1 proto 17 0.0.0.0/52138 -> 127.0.0.53/53 tos 0 scope 0=0A=
=0A=
flags 4 =3D=3D> dev eth0 gw 10.24.12.1 src 10.24.12.10 err 0=0A=
=0A=
=0A=
=0A=
which suggests your process is passing off the DNS lookup to a local=0A=
=0A=
process (isc-worker) and it hits the default route for mgmt-vrf when it=0A=
=0A=
is trying to connect to a localhost address.=0A=
=0A=
=0A=
=0A=
For mgmt-vrf I suggest always adding 127.0.0.1/8 to the mgmt vrf device=0A=
=0A=
(and ::1/128 for IPv6 starting with 5.x kernels - I forget the exact=0A=
=0A=
kernel version).=0A=
=0A=
=0A=
=0A=
That might solve your problem; it might not.=0A=
=0A=
=0A=
=0A=
(BTW: Cumulus uses fib rules for DNS servers to force DNS packets out=0A=
=0A=
the mgmt-vrf interface.)=0A=
=0A=
