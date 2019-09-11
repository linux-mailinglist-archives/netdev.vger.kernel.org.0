Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7028AFB43
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfIKLTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:19:10 -0400
Received: from mail-eopbgr100100.outbound.protection.outlook.com ([40.107.10.100]:6122
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbfIKLTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 07:19:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faO+O5tYlj7PGlFJB0HW+fBGuhIdctbJV96KmR+NEoID2NLs8KRVk8ZSNfQaL4jB6WtoTnMZhj4i1r69Zq53FUAwO9qEWMezGrC0dsUNbAPz6fQtqwv614qDIjWtWX0YOMFuS5heEgP8Wx1etDCXqKGPNHn8+5R9s6uhW1116CAoupylHfYcZqd0doRQj2wxIxIpdidqzEwe2dk5E5nHYmq1fvRHNWby+DwovqciQzMdXBwrf6P1nR/57D0jZV/VQ8lyKUdDlZ4vyXx9D3pLEuKB8rJsBkMoYfvdAyju0d5AwnoPb2H4Z6a9q5ydML0G5zQFdqNFt5GGZmaKPJaOoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mS8Er2t7yqbIvPk0I1p8wRJzcjWzvnLYzLCBU8hscAE=;
 b=aHc9R74HynigbYJJICzy78QrdU1Ua198l9xHfZ5fmOYwEtPjnN27rTHjU/UxS03uqlS+JoKnfmvhtFim1AKLE8Wo9EoA5LlW2gLipk1epFJMUjHCDJ0RZa/HiGIODblVNLYkMhZWRNNJ+06ZR+gWqFstliuqX4qq0fOTGlvqELLy9BIEbWWqe/CNmDnkTEMRPme0OWyuvbWZHGuE4pCxG6oTnrVQsah86/e3NRn7HYMMeR6BbfYq4xt0q/f0b1sVZqVCKqnBrBCRZ+D2ud2HIb0fQrOvPTcwp38PXSjdFgvDXtUFmFvYIunIw40Lwfs1HYRK9KuR4DX8/fLCnWhXEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=potatocomputing.co.uk; dmarc=pass action=none
 header.from=potatocomputing.co.uk; dkim=pass header.d=potatocomputing.co.uk;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT4492442.onmicrosoft.com;
 s=selector2-NETORGFT4492442-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mS8Er2t7yqbIvPk0I1p8wRJzcjWzvnLYzLCBU8hscAE=;
 b=m5GqybqnaaXjDiElFcKF1EAcCWCfzNk6Y2wD+vS7TREbslbnG8V0iRzQ7PiOEzn3WnwjD0mH0xpcP8Yqw0FWmtnWdh7QOyvGqNIbo7CBvSXSiPp8xmExqHhNw1jrRJ/bGeg8jhmLFl/0V95Ctnw5x9FSBGFt35hIq0TmM6vRc9c=
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM (20.176.38.150) by
 CWLP265MB1617.GBRP265.PROD.OUTLOOK.COM (20.176.39.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 11:19:06 +0000
Received: from CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547]) by CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f4a6:f11e:4b4d:f547%7]) with mapi id 15.20.2241.022; Wed, 11 Sep 2019
 11:19:06 +0000
From:   Gowen <gowen@potatocomputing.co.uk>
To:     David Ahern <dsahern@gmail.com>, Alexis Bauvin <abauvin@online.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: VRF Issue Since kernel 5
Thread-Topic: VRF Issue Since kernel 5
Thread-Index: AQHVZuKrrHmXIhazUku6D0pNIn18H6cjFD4AgAAH2kGAACLagIAB3vUAgADR7HCAAFhoVg==
Date:   Wed, 11 Sep 2019 11:19:06 +0000
Message-ID: <CWLP265MB15544E2F2303FA2D0F76B7F5FDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
References: <CWLP265MB1554308A1373D9ECE68CB854FDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <9E920DE7-9CC9-493C-A1D2-957FE1AED897@online.net>
 <CWLP265MB1554B902B7F3B43E6E75FD0DFDB70@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
 <7CAF2F23-5D88-4BE7-B703-06B71D1EDD11@online.net>
 <db3f6cd0-aa28-0883-715c-3e1eaeb7fd1e@gmail.com>,<CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
In-Reply-To: <CWLP265MB1554C88316ACF2BDD4692ECAFDB10@CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gowen@potatocomputing.co.uk; 
x-originating-ip: [51.141.26.231]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b668afe-b310-41ab-95f6-08d736a9dbd0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CWLP265MB1617;
x-ms-traffictypediagnostic: CWLP265MB1617:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CWLP265MB16177CE75A0F0525EE603487FDB10@CWLP265MB1617.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39830400003)(366004)(136003)(346002)(199004)(189003)(51914003)(13464003)(316002)(7696005)(229853002)(76176011)(66476007)(53366004)(33656002)(53936002)(6246003)(99286004)(66556008)(66446008)(64756008)(26005)(6306002)(9686003)(6436002)(53376002)(55016002)(4326008)(5660300002)(66946007)(25786009)(3846002)(52536014)(6116002)(446003)(53546011)(11346002)(8936002)(508600001)(14454004)(966005)(8676002)(14444005)(86362001)(256004)(110136005)(81156014)(81166006)(7736002)(2906002)(76116006)(91956017)(2940100002)(102836004)(476003)(486006)(71190400001)(186003)(71200400001)(74316002)(305945005)(55236004)(6506007)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:CWLP265MB1617;H:CWLP265MB1554.GBRP265.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: potatocomputing.co.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eTE8OrpN/LOL6nhsiANseKlgygKkZZ5D/vYxqt1iX3IUgyKoiUn6YgQB/T9vPdiweUOUvkALkfyyLZX+Hz6ZZZOjrzEvu1OLd39I/Lq730SWoZLJaq54G0Xj1n4KVWkNvnx1JyHVnSB+X410rISwmZvcSCe3kmsNg2khkZ7t7OPYbl88sC7dZjAqi6rDGnvRgxjl8ijcPZZNUxUKdjeFeXLFI9ckXh9DW6oBzVoa+rhDW7PgO7XkVLwnLKJuDPrnadQmo1tLVR2+P42vf+EUuW87x8H3beDEerIDhfJXKWTAjFBCuPoJ5hwqd+dlMhF29kBW/Iq5m1jSjp+pdsMOlrRaSOB9Ph22pO2MSIqQLTMvJvszos/V81AKhV3zJMiiLvsY0beCLv6gj7IV/ZgL/e9QyXHtWhxMXJ53OQvH9Ms=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: potatocomputing.co.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b668afe-b310-41ab-95f6-08d736a9dbd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 11:19:06.0808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b0e486ce-86f8-410c-aa6d-e814c15cfeb8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B9EaV15dDCoPuOtOhmi9wxtClGugJl75yXIoeW9n9QvVo59QvvZAcj9gKOqggGE8neDidkGVZd7N9XjAJ57voaBMS2H8baTxvNPKFdYfPk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB1617
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,=0A=
=0A=
Your perf command:=0A=
=0A=
  isc-worker0000 20261 [000]  2215.013849: fib:fib_table_lookup: table 10 o=
if 0 iif 0 proto 0 0.0.0.0/0 -> 127.0.0.1/0 tos 0 scope 0 flags 0 =3D=3D> d=
ev eth0 gw 10.24.12.1 src 10.24.12.10 err 0=0A=
  isc-worker0000 20261 [000]  2215.013915: fib:fib_table_lookup: table 10 o=
if 4 iif 1 proto 17 0.0.0.0/52138 -> 127.0.0.53/53 tos 0 scope 0 flags 4 =
=3D=3D> dev eth0 gw 10.24.12.1 src 10.24.12.10 err 0=0A=
  isc-worker0000 20261 [000]  2220.014006: fib:fib_table_lookup: table 10 o=
if 4 iif 1 proto 17 0.0.0.0/52138 -> 127.0.0.53/53 tos 0 scope 0 flags 4 =
=3D=3D> dev eth0 gw 10.24.12.1 src 10.24.12.10 err 0=0A=
=0A=
Also I set all iptables to policy ACCEPT and flushed the rules, enabled for=
warding, checked the sysctl settings are all '1'. I've looked at tracing DN=
S through the iptables and I see that DNS uses a loopback interface as sour=
ce and destination - this would be odd on a Cisco box but having looked aro=
und this appears to be normal?=0A=
=0A=
I also gathered an strace of updating the package cache as well as a perf o=
f the same command - will send if interested (is more verbose and not sure =
if the spam filter will block it)=0A=
=0A=
Gareth=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
From: Gowen=0A=
=0A=
Sent: 11 September 2019 06:09=0A=
=0A=
To: David Ahern <dsahern@gmail.com>; Alexis Bauvin <abauvin@online.net>=0A=
=0A=
Cc: netdev@vger.kernel.org <netdev@vger.kernel.org>=0A=
=0A=
Subject: RE: VRF Issue Since kernel 5=0A=
=0A=
=A0=0A=
=0A=
=0A=
Thanks for the link - that's really useful. I did re-order ip rules Friday =
(I think) - no change=0A=
=0A=
=0A=
=0A=
-----Original Message-----=0A=
=0A=
From: David Ahern <dsahern@gmail.com> =0A=
=0A=
Sent: 10 September 2019 17:36=0A=
=0A=
To: Alexis Bauvin <abauvin@online.net>; Gowen <gowen@potatocomputing.co.uk>=
=0A=
=0A=
Cc: netdev@vger.kernel.org=0A=
=0A=
Subject: Re: VRF Issue Since kernel 5=0A=
=0A=
=0A=
=0A=
On 9/9/19 1:01 PM, Alexis Bauvin wrote:=0A=
=0A=
> Could you try swapping the local and l3mdev rules?=0A=
=0A=
> =0A=
=0A=
> `ip rule del pref 0; ip rule add from all lookup local pref 1001`=0A=
=0A=
=0A=
=0A=
yes, the rules should be re-ordered so that local rule is after l3mdev rule=
 (VRF is implemented as policy routing). In general, I would reverse the or=
der of those commands to ensure no breakage.=0A=
=0A=
=0A=
=0A=
Also, 5.0 I think it was (too many kernel versions) added a new l3mdev sysc=
tl (raw_l3mdev_accept). Check all 3 of them and nmake sure they are set pro=
perly for your use case.=0A=
=0A=
=0A=
=0A=
These slides do not cover 5.0 changes but are still the best collection of =
notes on VRF:=0A=
=0A=
http://schd.ws/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf=0A=
=0A=
