Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFDA8AECEF
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 16:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387446AbfIJO0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 10:26:33 -0400
Received: from mail-eopbgr110136.outbound.protection.outlook.com ([40.107.11.136]:22624
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727415AbfIJO0d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 10:26:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMp9wh1Qq1pMRjJliTwZYlF0uZO7JVy5j5FeVFP/YkGUxGrSCv+zv1Ikq1pUVaPHiypMp628yAenrSIb9eMosbiqlcHb1dpegMsdArcpEjUELzvY9LL/jfBb9bxmRWgq+Dx/yx2+kIcrAl7WCk0F67uqDoPR2v0Xxi8+vxPp0+SLSJK1jVLN/T+glIB0YPPagBSFpeaO4sFPs2ygJGKj0o6CGsH507sMGxbB+zXLMzR6duEqPVCj7fmRjAScAEfSbvtcgPhvM7RQCgqTe1OVx0ZiQ2K6wmAFlVsUXxQ3MwLxlqhBTT6WveogLSezB8ZVbl9Ha97ZEalWuWAdaYOOig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=to7H3qyzbQgF076qBEObtHKB0X4XpZAcSz1eKjAXsD0=;
 b=O8X/YxtOfpLfNAQX9f1Xkh6MMHIqt63N5/ZRKuD0/B1edgKZm6pmBzeWuMPRj4c7wEis2BR7Ymc7tav5MOyFpsnwq58RhZPm3YCuIhu9lJ5OdQ1QFmf8WkxmED/oig0LB9k+bsSdusK67LR2OE2N+x32BcckVh+xxAgx8MdnwvY107u3Eo1sjkyB7XAA8hrVboJz2LDUQUvCV1eiSKMw5DNLbb8gat1qxuTMXQ4KfSgnmRKBv7GSSkMWaWL+Mj5i13xGz3TuzvdNq9yzl6LMXj++RM/rBXlIENoft2nIGNrZ8IByC/jdyKOHDHRqbzxApIMPHamkv+Ojyb0QK5qDWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=potatocomputing.co.uk; dmarc=pass action=none
 header.from=potatocomputing.co.uk; dkim=pass header.d=potatocomputing.co.uk;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT4492442.onmicrosoft.com;
 s=selector2-NETORGFT4492442-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=to7H3qyzbQgF076qBEObtHKB0X4XpZAcSz1eKjAXsD0=;
 b=fRcB9hQuuYk4Nd/N7cnBkyAWRvURaTUcUfDQnSeETcL8kqigdx1zCtbEbYEmtP7n8FsESJw+OHyPTcl6qqOkUCiKAKE268/JMYP4pwmQJpKlpqjTI6FJGRbOYcozC17JG0K87a0UO8uun8vnPe4SMli7pA1nxPDdb4yz1UDtoSM=
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM (20.176.38.150) by
 CWLP265MB0450.GBRP265.PROD.OUTLOOK.COM (10.166.19.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 14:22:40 +0000
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547]) by CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547%7]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 14:22:40 +0000
From:   Gowen <gowen@potatocomputing.co.uk>
To:     Alexis Bauvin <abauvin@online.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: VRF Issue Since kernel 5
Thread-Topic: VRF Issue Since kernel 5
Thread-Index: AQHVZuKrrHmXIhazUku6D0pNIn18H6cjFD4AgAAH2kGAACLagIAAgJzggAE4SyY=
Date:   Tue, 10 Sep 2019 14:22:39 +0000
Message-ID: <CWLP265MB1554D3C90B56AB5A6EC23771FDB60@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>,<CWLP265MB1554989CAA2DB59B6862A6A2FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
In-Reply-To: <CWLP265MB1554989CAA2DB59B6862A6A2FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gowen@potatocomputing.co.uk; 
x-originating-ip: [51.141.34.27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a660f59f-466c-4ccf-5149-08d735fa5630
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CWLP265MB0450;
x-ms-traffictypediagnostic: CWLP265MB0450:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CWLP265MB0450A2B50B04D5C12380B906FDB60@CWLP265MB0450.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(376002)(346002)(39830400003)(189003)(199004)(13464003)(52294003)(14454004)(508600001)(76116006)(91956017)(52536014)(5660300002)(66946007)(66476007)(66556008)(64756008)(66446008)(30864003)(66574012)(15974865002)(74316002)(305945005)(7736002)(6506007)(8676002)(81156014)(81166006)(8936002)(55236004)(66066001)(53546011)(102836004)(446003)(11346002)(86362001)(476003)(186003)(26005)(53936002)(55016002)(33656002)(6116002)(3846002)(6246003)(4326008)(486006)(25786009)(9686003)(7696005)(76176011)(99286004)(316002)(71200400001)(6436002)(71190400001)(6916009)(256004)(2906002)(14444005)(229853002)(47845001);DIR:OUT;SFP:1102;SCL:1;SRVR:CWLP265MB0450;H:CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: potatocomputing.co.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2n7dQAOMm7y/IIlo5CsmUokf/g7Gz6Nen8j5846jeAu+tgtkijvMhwEJsGRad0FMF9GXzwymOG6EIj+xpGLrTu+bwwzQ9WMqzKOnu3I2o4+axFGLXnatb5ZYqc5XqKkL3bd2nEIs6e5I4+1tmr2M545z1FB8fyjsQmVAffX9cWEq6aoknfoOzEB5NCU2qoY4LRHxF/PPahe8JvjwmiM6LzOXBEo0IlLFDs8zShjbohrCjrZrgw4LwyCapzXni1sS2OjQf1kGXr0Sp73r/S34Z0JsZl+9UTu/g9RGPCjThzHLPOkKv5Aqo4MxoNmBtFZiZsDOTRORrcjUt3MKiCzH8mfBBB0kS2d2hd04ii/vGXqk6YAwhOt6c4Dyjy091AKOPGO6DFZ02JZ8SVuE31KNyrxEChXOMCZV7wlwwb1atpQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: potatocomputing.co.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: a660f59f-466c-4ccf-5149-08d735fa5630
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 14:22:39.9658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b0e486ce-86f8-410c-aa6d-e814c15cfeb8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B0nEszE9Eoiu/SZGpkO3UsrYrqm6O9hGYkrA0TFV/SmVCAxHas9pooyG4lnqvD4ENqD5eL/GQ8YCQFCX0QMJ/62guTxTtB7c0p+iN4Umg+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB0450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexis,=0A=
=0A=
I enabled the target TRACE and found that the packet is passing through the=
 security table - which I thought was for SELinux only. As far as I can tel=
l the config is working, is being seen by iptables nut for some reason is n=
ot getting accepted by the local process - which isn't right surely. Debugs=
 below from TRACE for the 91.0.0.0/8 subnet for the updates=0A=
=0A=
Sep 10 13:50:37 NETM06 kernel: [442740.425992] TRACE: raw:PREROUTING:policy=
:2 IN=3Dmgmt-vrf OUT=3D MAC=3D00:22:48:07:cc:ad:74:83:ef:a9:ca:c1:08:00 SRC=
=3D91.189.88.24 DST=3D10.24.12.10 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D51 =
ID=3D0 DF PROTO=3DTCP SPT=3D80 DPT=3D40164 SEQ=3D2210516855 ACK=3D395460128=
8 WINDOW=3D28960 RES=3D0x00 ACK SYN URGP=3D0 OPT (0204058A0402080AD62215769=
7AC236D01030307)=0A=
Sep 10 13:50:37 NETM06 kernel: [442740.426045] TRACE: filter:INPUT:rule:1 I=
N=3Dmgmt-vrf OUT=3D MAC=3D00:22:48:07:cc:ad:74:83:ef:a9:ca:c1:08:00 SRC=3D9=
1.189.88.24 DST=3D10.24.12.10 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D51 ID=
=3D0 DF PROTO=3DTCP SPT=3D80 DPT=3D40164 SEQ=3D2210516855 ACK=3D3954601288 =
WINDOW=3D28960 RES=3D0x00 ACK SYN URGP=3D0 OPT (0204058A0402080AD622157697A=
C236D01030307)=0A=
Sep 10 13:50:37 NETM06 kernel: [442740.426060] TRACE: security:INPUT:rule:1=
 IN=3Dmgmt-vrf OUT=3D MAC=3D00:22:48:07:cc:ad:74:83:ef:a9:ca:c1:08:00 SRC=
=3D91.189.88.24 DST=3D10.24.12.10 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D51 =
ID=3D0 DF PROTO=3DTCP SPT=3D80 DPT=3D40164 SEQ=3D2210516855 ACK=3D395460128=
8 WINDOW=3D28960 RES=3D0x00 ACK SYN URGP=3D0 OPT (0204058A0402080AD62215769=
7AC236D01030307)=0A=
Sep 10 13:50:37 NETM06 kernel: [442740.426108] TRACE: security:INPUT:policy=
:2 IN=3Dmgmt-vrf OUT=3D MAC=3D00:22:48:07:cc:ad:74:83:ef:a9:ca:c1:08:00 SRC=
=3D91.189.88.24 DST=3D10.24.12.10 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D51 =
ID=3D0 DF PROTO=3DTCP SPT=3D80 DPT=3D40164 SEQ=3D2210516855 ACK=3D395460128=
8 WINDOW=3D28960 RES=3D0x00 ACK SYN URGP=3D0 OPT (0204058A0402080AD62215769=
7AC236D01030307)=0A=
=0A=
=0A=
Admin@NETM06:~$ sudo iptables -L PREROUTING -t raw  -n -v=0A=
Chain PREROUTING (policy ACCEPT 56061 packets, 5260K bytes)=0A=
 pkts bytes target     prot opt in     out     source               destina=
tion=0A=
  296 16480 TRACE      tcp  --  mgmt-vrf *       91.0.0.0/8           0.0.0=
.0/0            ctstate RELATED,ESTABLISHED tcp spt:80=0A=
=0A=
Chain INPUT (policy DROP 0 packets, 0 bytes)=0A=
num   pkts bytes target     prot opt in     out     source               de=
stination=0A=
1      330 18260 ACCEPT     tcp  --  mgmt-vrf *       91.0.0.0/8           =
0.0.0.0/0            ctstate RELATED,ESTABLISHED tcp spt:80=0A=
=0A=
Admin@NETM06:~$ sudo iptables -L  -t security  -n -v --line-numbers=0A=
Chain INPUT (policy ACCEPT 4190 packets, 371K bytes)=0A=
num   pkts bytes target     prot opt in     out     source               de=
stination=0A=
1      248 13980 LOG        all  --  *      *       91.0.0.0/8           0.=
0.0.0/0            LOG flags 0 level 4 prefix "LOG-SECURITY"=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
From: Gowen=0A=
=0A=
Sent: 09 September 2019 20:43=0A=
=0A=
To: Alexis Bauvin <abauvin@online.net>=0A=
=0A=
Cc: netdev@vger.kernel.org <netdev@vger.kernel.org>=0A=
=0A=
Subject: RE: VRF Issue Since kernel 5=0A=
=0A=
=A0=0A=
=0A=
=0A=
Hi alexis,=0A=
=0A=
=0A=
=0A=
I did this earlier today and no change.=0A=
=0A=
=0A=
=0A=
I=92ll look at trying to see if the return traffic is hitting the INPUT tab=
le tomorrow with some conntrack rules and see if it hits any of those rules=
. If not then do you have any hints/techniques I can use to find the source=
 of the issue?=0A=
=0A=
=0A=
=0A=
Gareth=0A=
=0A=
=0A=
=0A=
-----Original Message-----=0A=
=0A=
From: Alexis Bauvin <abauvin@online.net> =0A=
=0A=
Sent: 09 September 2019 13:02=0A=
=0A=
To: Gowen <gowen@potatocomputing.co.uk>=0A=
=0A=
Cc: netdev@vger.kernel.org=0A=
=0A=
Subject: Re: VRF Issue Since kernel 5=0A=
=0A=
=0A=
=0A=
Hi,=0A=
=0A=
=0A=
=0A=
I guess all routing from the management VRF itself is working correctly (i.=
e. cURLing an IP from this VRF or digging any DNS), and it is your route le=
akage that=92s at fault.=0A=
=0A=
=0A=
=0A=
Could you try swapping the local and l3mdev rules?=0A=
=0A=
=0A=
=0A=
`ip rule del pref 0; ip rule add from all lookup local pref 1001`=0A=
=0A=
=0A=
=0A=
I faced security issues and behavioral weirdnesses from the default kernel =
rule ordering regarding the default vrf.=0A=
=0A=
=0A=
=0A=
Alexis=0A=
=0A=
=0A=
=0A=
> Le 9 sept. 2019 =E0 12:53, Gowen <gowen@potatocomputing.co.uk> a =E9crit =
:=0A=
=0A=
> =0A=
=0A=
> Hi Alexis,=0A=
=0A=
> =0A=
=0A=
> Admin@NETM06:~$ sysctl net.ipv4.tcp_l3mdev_accept =0A=
=0A=
> net.ipv4.tcp_l3mdev_accept =3D 1=0A=
=0A=
> =0A=
=0A=
> Admin@NETM06:~$ sudo ip vrf exec mgmt-vrf curl kernel.org=0A=
=0A=
> curl: (6) Could not resolve host: kernel.org=0A=
=0A=
> =0A=
=0A=
> the failure to resolve is the same with all DNS lookups from any =0A=
=0A=
> process I've run=0A=
=0A=
> =0A=
=0A=
> The route is there from the guide I originally used, I can't remember =0A=
=0A=
> the purpose but I know I don't need it - I've removed it now and no =0A=
=0A=
> change=0A=
=0A=
> =0A=
=0A=
> Admin@NETM06:~$ ip rule show=0A=
=0A=
> 0:=A0=A0=A0=A0=A0 from all lookup local=0A=
=0A=
> 1000:=A0=A0 from all lookup [l3mdev-table]=0A=
=0A=
> 32766:=A0 from all lookup main=0A=
=0A=
> 32767:=A0 from all lookup default=0A=
=0A=
> =0A=
=0A=
> I could switch the VRFs over, but this is a test-box and i have prod boxe=
s on this as well so not so keen on that if I can avoid it.=0A=
=0A=
> =0A=
=0A=
> From what I can speculate, because the TCP return traffic is met with an =
RST, it looks like it may be something to do with iptables - but even if I =
set the policy to ACCEPT and flush all the rules, the behaviour remains the=
 same.=0A=
=0A=
> =0A=
=0A=
> Is it possible that the TCP stack isn't aware of the session (as is mappe=
d to wrong VRF internally or something to that effect) and is therefore sen=
ding the RST?=0A=
=0A=
> =0A=
=0A=
> Gareth=0A=
=0A=
> From: Alexis Bauvin <abauvin@online.net>=0A=
=0A=
> Sent: 09 September 2019 10:28=0A=
=0A=
> To: Gowen <gowen@potatocomputing.co.uk>=0A=
=0A=
> Cc: netdev@vger.kernel.org <netdev@vger.kernel.org>=0A=
=0A=
> Subject: Re: VRF Issue Since kernel 5=0A=
=0A=
>=A0 =0A=
=0A=
> Hi,=0A=
=0A=
> =0A=
=0A=
> There has been some changes regarding VRF isolation in Linux 5 IIRC, =0A=
=0A=
> namely proper isolation of the default VRF.=0A=
=0A=
> =0A=
=0A=
> Some things you may try:=0A=
=0A=
> =0A=
=0A=
> - looking at the l3mdev_accept sysctls (e.g. =0A=
=0A=
> `net.ipv4.tcp_l3mdev_accept`)=0A=
=0A=
> - querying stuff from the management vrf through `ip vrf exec vrf-mgmt <s=
tuff>`=0A=
=0A=
>=A0=A0 e.g. `ip vrf exec vrf-mgmt curl kernel.org`=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0 `ip vrf exec vrf-mgmt dig @1.1.1.1 kernel.org`=0A=
=0A=
> - reversing your logic: default VRF is your management one, the other one=
 is for your=0A=
=0A=
>=A0=A0 other boxes=0A=
=0A=
> =0A=
=0A=
> Also, your `unreachable default metric 4278198272` route looks odd to me.=
=0A=
=0A=
> =0A=
=0A=
> What are your routing rules? (`ip rule`)=0A=
=0A=
> =0A=
=0A=
> Alexis=0A=
=0A=
> =0A=
=0A=
> > Le 9 sept. 2019 =E0 09:46, Gowen <gowen@potatocomputing.co.uk> a =E9cri=
t :=0A=
=0A=
> > =0A=
=0A=
> > Hi there,=0A=
=0A=
> > =0A=
=0A=
> > Dave A said this was the mailer to send this to:=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > I=92ve been using my management interface in a VRF for several months n=
ow and it=92s worked perfectly =96 I=92ve been able to update/upgrade the p=
ackages just fine and iptables works excellently with it =96 exactly as I n=
eeded.=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Since Kernel 5 though I am no longer able to update =96 but the issue =
=0A=
=0A=
> > is quite a curious one as some traffic appears to be fine (DNS =0A=
=0A=
> > lookups use VRF correctly) but others don=92t (updating/upgrading the =
=0A=
=0A=
> > packages)=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > I have on this device 2 interfaces:=0A=
=0A=
> > Eth0 for management =96 inbound SSH, DNS, updates/upgrades=0A=
=0A=
> > Eth1 for managing other boxes (ansible using SSH)=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Link and addr info shown below:=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Admin@NETM06:~$ ip link show=0A=
=0A=
> > 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mod=
e DEFAULT group default qlen 1000=0A=
=0A=
> >=A0=A0=A0=A0 link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00=0A=
=0A=
> > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mgm=
t-vrf state UP mode DEFAULT group default qlen 1000=0A=
=0A=
> >=A0=A0=A0=A0 link/ether 00:22:48:07:cc:ad brd ff:ff:ff:ff:ff:ff=0A=
=0A=
> > 3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP m=
ode DEFAULT group default qlen 1000=0A=
=0A=
> >=A0=A0=A0=A0 link/ether 00:22:48:07:c9:6c brd ff:ff:ff:ff:ff:ff=0A=
=0A=
> > 4: mgmt-vrf: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state U=
P mode DEFAULT group default qlen 1000=0A=
=0A=
> >=A0=A0=A0=A0 link/ether 8a:f6:26:65:02:5a brd ff:ff:ff:ff:ff:ff=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Admin@NETM06:~$ ip addr=0A=
=0A=
> > 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN gro=
up default qlen 1000=0A=
=0A=
> >=A0=A0=A0=A0 link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00=0A=
=0A=
> >=A0=A0=A0=A0 inet 127.0.0.1/8 scope host lo=0A=
=0A=
> >=A0=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
=0A=
> >=A0=A0=A0=A0 inet6 ::1/128 scope host=0A=
=0A=
> >=A0=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
=0A=
> > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mgm=
t-vrf state UP group default qlen 1000=0A=
=0A=
> >=A0=A0=A0=A0 link/ether 00:22:48:07:cc:ad brd ff:ff:ff:ff:ff:ff=0A=
=0A=
> >=A0=A0=A0=A0 inet 10.24.12.10/24 brd 10.24.12.255 scope global eth0=0A=
=0A=
> >=A0=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
=0A=
> >=A0=A0=A0=A0 inet6 fe80::222:48ff:fe07:ccad/64 scope link=0A=
=0A=
> >=A0=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
=0A=
> > 3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP g=
roup default qlen 1000=0A=
=0A=
> >=A0=A0=A0=A0 link/ether 00:22:48:07:c9:6c brd ff:ff:ff:ff:ff:ff=0A=
=0A=
> >=A0=A0=A0=A0 inet 10.24.12.9/24 brd 10.24.12.255 scope global eth1=0A=
=0A=
> >=A0=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
=0A=
> >=A0=A0=A0=A0 inet6 fe80::222:48ff:fe07:c96c/64 scope link=0A=
=0A=
> >=A0=A0=A0=A0=A0=A0=A0 valid_lft forever preferred_lft forever=0A=
=0A=
> > 4: mgmt-vrf: <NOARP,MASTER,UP,LOWER_UP> mtu 65536 qdisc noqueue state U=
P group default qlen 1000=0A=
=0A=
> >=A0=A0=A0=A0 link/ether 8a:f6:26:65:02:5a brd ff:ff:ff:ff:ff:ff=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > the production traffic is all in the 10.0.0.0/8 network (eth1 global =
=0A=
=0A=
> > VRF) except for a few subnets (DNS) which are routed out eth0 =0A=
=0A=
> > (mgmt-vrf)=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Admin@NETM06:~$ ip route show=0A=
=0A=
> > default via 10.24.12.1 dev eth0=0A=
=0A=
> > 10.0.0.0/8 via 10.24.12.1 dev eth1=0A=
=0A=
> > 10.24.12.0/24 dev eth1 proto kernel scope link src 10.24.12.9=0A=
=0A=
> > 10.24.65.0/24 via 10.24.12.1 dev eth0=0A=
=0A=
> > 10.25.65.0/24 via 10.24.12.1 dev eth0=0A=
=0A=
> > 10.26.0.0/21 via 10.24.12.1 dev eth0=0A=
=0A=
> > 10.26.64.0/21 via 10.24.12.1 dev eth0=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Admin@NETM06:~$ ip route show vrf mgmt-vrf default via 10.24.12.1 =0A=
=0A=
> > dev eth0 unreachable default metric 4278198272=0A=
=0A=
> > 10.24.12.0/24 dev eth0 proto kernel scope link src 10.24.12.10=0A=
=0A=
> > 10.24.65.0/24 via 10.24.12.1 dev eth0=0A=
=0A=
> > 10.25.65.0/24 via 10.24.12.1 dev eth0=0A=
=0A=
> > 10.26.0.0/21 via 10.24.12.1 dev eth0=0A=
=0A=
> > 10.26.64.0/21 via 10.24.12.1 dev eth0=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > The strange activity occurs when I enter the command =93sudo apt update=
=94 as I can resolve the DNS request (10.24.65.203 or 10.24.64.203, verifie=
d with tcpdump) out eth0 but for the actual update traffic there is no acti=
vity:=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > sudo tcpdump -i eth0 '(host 10.24.65.203 or host 10.25.65.203) and =0A=
=0A=
> > port 53' -n <OUTPUT OMITTED FOR BREVITY>=0A=
=0A=
> > 10:06:05.268735 IP 10.24.12.10.39963 > 10.24.65.203.53: 48798+ [1au] =
=0A=
=0A=
> > A? security.ubuntu.com. (48) <OUTPUT OMITTED FOR BREVITY>=0A=
=0A=
> > 10:06:05.284403 IP 10.24.65.203.53 > 10.24.12.10.39963: 48798 13/0/1 =
=0A=
=0A=
> > A 91.189.91.23, A 91.189.88.24, A 91.189.91.26, A 91.189.88.162, A =0A=
=0A=
> > 91.189.88.149, A 91.189.91.24, A 91.189.88.173, A 91.189.88.177, A =0A=
=0A=
> > 91.189.88.31, A 91.189.91.14, A 91.189.88.176, A 91.189.88.175, A =0A=
=0A=
> > 91.189.88.174 (256)=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > You can see that the update traffic is returned but is not accepted =0A=
=0A=
> > by the stack and a RST is sent=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Admin@NETM06:~$ sudo tcpdump -i eth0 '(not host 168.63.129.16 and =0A=
=0A=
> > port 80)' -n=0A=
=0A=
> > tcpdump: verbose output suppressed, use -v or -vv for full protocol =0A=
=0A=
> > decode listening on eth0, link-type EN10MB (Ethernet), capture size =0A=
=0A=
> > 262144 bytes=0A=
=0A=
> > 10:17:12.690658 IP 10.24.12.10.40216 > 91.189.88.175.80: Flags [S], =0A=
=0A=
> > seq 2279624826, win 64240, options [mss 1460,sackOK,TS val =0A=
=0A=
> > 2029365856 ecr 0,nop,wscale 7], length 0=0A=
=0A=
> > 10:17:12.691929 IP 10.24.12.10.52362 > 91.189.95.83.80: Flags [S], seq =
1465797256, win 64240, options [mss 1460,sackOK,TS val 3833463674 ecr 0,nop=
,wscale 7], length 0=0A=
=0A=
> > 10:17:12.696270 IP 91.189.88.175.80 > 10.24.12.10.40216: Flags [S.], se=
q 968450722, ack 2279624827, win 28960, options [mss 1418,sackOK,TS val 819=
57103 ecr 2029365856,nop,wscale 7], length 0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=0A=
=0A=
=0A=
> > 10:17:12.696301 IP 10.24.12.10.40216 > 91.189.88.175.80: Flags [R], seq=
 2279624827, win 0, length 0=0A=
=0A=
> > 10:17:12.697884 IP 91.189.95.83.80 > 10.24.12.10.52362: Flags [S.], seq=
 4148330738, ack 1465797257, win 28960, options [mss 1418,sackOK,TS val 225=
7624414 ecr 3833463674,nop,wscale 8], length 0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=0A=
=0A=
=0A=
> > 10:17:12.697909 IP 10.24.12.10.52362 > 91.189.95.83.80: Flags [R], =0A=
=0A=
> > seq 1465797257, win 0, length 0=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > I can emulate the DNS lookup using netcat in the vrf:=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > sudo ip vrf exec mgmt-vrf nc -u 10.24.65.203 53=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > then interactively enter the binary for a www.google.co.uk request:=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > 0035624be394010000010000000000010377777706676f6f676c6502636f02756b00=0A=
=0A=
> > 000100010000290200000000000000=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > This returns as expected:=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > 00624be394010000010000000000010377777706676f6f676c6502636f02756b0000=0A=
=0A=
> > 0100010000290200000000000000=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > I can run:=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Admin@NETM06:~$ host www.google.co.uk =0A=
www.google.co.uk has address =0A=
=0A=
> > 172.217.169.3 www.google.co.uk has IPv6 address=0A=
=0A=
=0A=
> > 2a00:1450:4009:80d::2003=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > but I get a timeout for:=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > sudo ip vrf=A0 exec mgmt-vrf host www.google.co.uk ;; connection timed=
=0A=
=0A=
=0A=
> > out; no servers could be reached=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > However I can take a repo address and vrf exec to it on port 80:=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Admin@NETM06:~$ sudo ip vrf=A0 exec mgmt-vrf nc 91.189.91.23 80 hello=
=0A=
=0A=
> > HTTP/1.1 400 Bad Request=0A=
=0A=
> > <OUTPUT OMITTED>=0A=
=0A=
> > =0A=
=0A=
> > My iptables rule:=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > sudo iptables -Z=0A=
=0A=
> > Admin@NETM06:~$ sudo iptables -L -v=0A=
=0A=
> > Chain INPUT (policy DROP 16 packets, 3592 bytes)=0A=
=0A=
> > pkts bytes target=A0=A0=A0=A0 prot opt in=A0=A0=A0=A0 out=A0=A0=A0=A0 s=
ource=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 destination=0A=
=0A=
> >=A0=A0=A0 44=A0 2360 ACCEPT=A0=A0=A0=A0 tcp=A0 --=A0 any=A0=A0=A0 any=A0=
=A0=A0=A0 anywhere=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 anywhere=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 tcp spt:http ctstate RELATED,ESTABLISHED=0A=
=0A=
> >=A0=A0=A0 83 10243 ACCEPT=A0=A0=A0=A0 udp=A0 --=A0 any=A0=A0=A0 any=A0=
=A0=A0=A0 anywhere=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 anywhere=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 udp spt:domain ctstate RELATED,ESTABLISHED=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > I cannot find out why the update isn=92t working. Any help greatly =0A=
=0A=
> > appreciated=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Kind Regards,=0A=
=0A=
> > =0A=
=0A=
> > =0A=
=0A=
> > Gareth=0A=
=0A=
=0A=
=0A=
