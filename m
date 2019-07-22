Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF52570105
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 15:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfGVN3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 09:29:05 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:39968 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726925AbfGVN3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 09:29:05 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4BBE0C1C1B;
        Mon, 22 Jul 2019 13:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563802143; bh=iGXaHLuX2s3YGcIFdG0DhLqweMpIRjzkJeL2JAahFGc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=P/rwympHqPR05c6ki5kN0aKdFUTdqfWq9ISJ4C7xP9cmySq6lE3o9CqqlUJaOOWgR
         JnznGPwegt1zo5RWRiSvq6/EN2sHCFzziYpfi2jGukeegt4yL1WByQqcYejQFx4T/9
         kNhOK0rQM6BYpeQcmDj+p21+2G4XaFL/WB/GPnS50pmZqy5MwNsenmZfVCUmgsVNb9
         2xM60pD51/GUvQDdlHNBBenb5G4le6pUN9K/SrZ2//HoA267lrczBIiOIVsfP/1wun
         CMkZ59BkZsqSGZNjM7PvaJB1Oxa8AbsqlovyHhF9O33GgpSVROUz8VFiLjTwkReXq7
         uFbjm+3JzZVlQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3ADC5A0067;
        Mon, 22 Jul 2019 13:28:57 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 22 Jul 2019 06:28:57 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 22 Jul 2019 06:28:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MipqSyA++S4BwjWOrZ+lC831qVEIFhE2rWCHWyI7uG99frIZeTMJ2Dnjd5Zcoluls7wZKe+cDQLW/+RG45AtlJlrxr+Qq1VQlhmiu/UxNUD+C+0l1bs/b8t3P3xDvG5mesYMoTp7lzon3WHkTBEFs9jhTCmIDXAShta5DVP2ZT35/kZADPRwJu36HvmqXlPoR52W5ZqTCxOSSv2fOU80c4F7DKra844YMwZgdCNZbNfcMn3+89H1zbFvgdZ+IA//0y11GYxENoNwGudaK2nBcji79SGzHx4O4Lq2lN8+WTWzc5B3CXz3yFO9YcWIeAxDFvWbtSLNOaP2Wvyz7ZvZFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrAYRqQisAyjtbkvCNsMNYw5Qvd9asrRBAS8dXHyt4w=;
 b=dCuddshzBwq1gQJwKdHzgUk6czC+GA2uUdaSeZB9pkoQEILzJvR/M8F/XoHT0mKQP8eyDEfUjcMiapSXDFItNZVzvIkoWWTJfNjVrkJ/bV3gWx6pDUgJ81TvlX/mM126c/HU0w46U9xV8iQcciC7uNt3idXN7qqXkEiHs4kgVdMe0geZXGZTYIbgz/PwhXos65LH/tAIm4d+V68TTKJHOKLmLhRa3cD7bNIXyhcwk4k2WKo4HE+Ov82orcqh18iOmfTYzSEjzNISEQFPfKSdGitMYpChxwd400Ya+w2hw4dl2uu4eMVpxVNc5t1oftCx+sqEx7IsJipOtIJLPijG4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrAYRqQisAyjtbkvCNsMNYw5Qvd9asrRBAS8dXHyt4w=;
 b=dCXEb+69cX+ERfpTOwsvE8siv+hxndbYp2hdzGsYEfQ5HqDGjMWEQO4Cj8bX+sSvsOSaanJemt8t+sIZnSAA+63rvhTfYZkOh4L8GYaGHPZ/rbLq45AmfSej4WMbdOEnaB23iKOIuU4GuVfmpXkvx4br+hOO0w5+/XgpdhL2xfc=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3491.namprd12.prod.outlook.com (20.178.212.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Mon, 22 Jul 2019 13:28:51 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 13:28:51 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     =?iso-8859-2?Q?Ond=F8ej_Jirman?= <megi@xff.cz>,
        Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Thread-Topic: [PATCH net-next 0/3] net: stmmac: Convert to phylink
Thread-Index: AQHVIGkCReoXsI1ev0mBbW+MAvwZAqbW1RMAgAALU8A=
Date:   Mon, 22 Jul 2019 13:28:51 +0000
Message-ID: <BN8PR12MB32660B12F8E2617ED42249BBD3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <20190722124240.464e73losonwb356@core.my.home>
In-Reply-To: <20190722124240.464e73losonwb356@core.my.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ae612e1-96cb-4b1e-8d4f-08d70ea88925
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:BN8PR12MB3491;
x-ms-traffictypediagnostic: BN8PR12MB3491:
x-microsoft-antispam-prvs: <BN8PR12MB34910219A669F48BBF506381D3C40@BN8PR12MB3491.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(346002)(396003)(39860400002)(199004)(189003)(33656002)(2906002)(81156014)(81166006)(66574012)(486006)(68736007)(6506007)(102836004)(52536014)(66616009)(64756008)(66446008)(76116006)(66946007)(7416002)(6116002)(66476007)(66556008)(4326008)(19627235002)(8936002)(5660300002)(5024004)(8676002)(478600001)(256004)(66066001)(7736002)(305945005)(74316002)(14444005)(25786009)(99936001)(476003)(86362001)(110136005)(54906003)(3846002)(71190400001)(71200400001)(7696005)(99286004)(76176011)(6436002)(26005)(6246003)(6636002)(316002)(186003)(53936002)(229853002)(55016002)(446003)(11346002)(9686003)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3491;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KOzY5N6FW4way23hmV67cOtrYTWPkYpFtrnKYDG6svCK43LYQBpIjC4LukAV/A8/79hLKaKpUZtR2bx7XX3hsGL+mFYQaA9uVihww4hSm4Wxi3BboCX03HsnW/2N9GPs18F7fY0WdEiR3XsubRfB/eYeqkG9LKNtyt78fhQRV1qgItXu9E1atMpneH66/nx+abIus+Dbh9o1zA+3MPl/VQ7aW0N5XI50fHbUvcVhVTJlhbhJb1+g35KyKug00vKGdPNzotiTUxd2PwaTs2WA11+mU7J+p1Z4nX9iI14PsF3jjfMNN4MaTCqUSoFWSG32mK/EyNiku/6yU7UryMvva5IdRiy4rR1wp4tS0ELY13MFEPZIlZW6b0Qj6zDonCMvJkF6EPbTgrv0JQtqkhPrbeGxiRiQF5SKyzvC+Xc9Vzk=
Content-Type: multipart/mixed;
        boundary="_002_BN8PR12MB32660B12F8E2617ED42249BBD3C40BN8PR12MB3266namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ae612e1-96cb-4b1e-8d4f-08d70ea88925
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 13:28:51.3169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3491
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_BN8PR12MB32660B12F8E2617ED42249BBD3C40BN8PR12MB3266namp_
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable

From: Ond=F8ej Jirman <megi@xff.cz>
Date: Jul/22/2019, 13:42:40 (UTC+00:00)

> Hello Jose,
>=20
> On Tue, Jun 11, 2019 at 05:18:44PM +0200, Jose Abreu wrote:
> > [ Hope this diff looks better (generated with --minimal) ]
> >=20
> > This converts stmmac to use phylink. Besides the code redution this wil=
l
> > allow to gain more flexibility.
>=20
> I'm testing 5.3-rc1 and on Orange Pi 3 (uses stmmac-sun8i.c glue) compare=
d to
> 5.2 it fails to detect 1000Mbps link and the driver negotiates just a 10M=
bps speed.
>=20
> After going through stmmac patches since 5.2, I think it may be realted t=
o this
> series, but I'm not completely sure. You'll probably have a better unders=
tanding
> of the changes. Do you have an idea what might be wrong? Please, see some=
 logs
> below.

Probably due to:
5b0d7d7da64b ("net: stmmac: Add the missing speeds that XGMAC supports")

Can you try attached patch ?


>=20
> thank you and regards,
> 	Ondrej
>=20
> On 5.3-rc1 I see:
>=20
> [    6.116512] dwmac-sun8i 5020000.ethernet eth0: PHY [stmmac-0:01] drive=
r [RTL8211E Gigabit Ethernet]
> [    6.116522] dwmac-sun8i 5020000.ethernet eth0: phy: setting supported =
00,00000000,000062cf advertising 00,00000000,000062cf
> [    6.118714] dwmac-sun8i 5020000.ethernet eth0: No Safety Features supp=
ort found
> [    6.118725] dwmac-sun8i 5020000.ethernet eth0: No MAC Management Count=
ers available
> [    6.118730] dwmac-sun8i 5020000.ethernet eth0: PTP not supported by HW
> [    6.118738] dwmac-sun8i 5020000.ethernet eth0: configuring for phy/rgm=
ii link mode
> [    6.118747] dwmac-sun8i 5020000.ethernet eth0: phylink_mac_config: mod=
e=3Dphy/rgmii/Unknown/Unknown adv=3D00,00000000,000062cf pause=3D10 link=3D=
0 an=3D1
> [    6.126099] dwmac-sun8i 5020000.ethernet eth0: phy link down rgmii/Unk=
nown/Unknown
> [    6.276325] random: crng init done
> [    6.276338] random: 7 urandom warning(s) missed due to ratelimiting
> [    7.543987] zram0: detected capacity change from 0 to 402653184
> [    7.667702] Adding 393212k swap on /dev/zram0.  Priority:10 extents:1 =
across:393212k SS
>=20
> ... delay due to other causes ...
>=20
> [   28.640234] dwmac-sun8i 5020000.ethernet eth0: phy link up rgmii/10Mbp=
s/Full
> [   28.640295] dwmac-sun8i 5020000.ethernet eth0: phylink_mac_config: mod=
e=3Dphy/rgmii/10Mbps/Full adv=3D00,00000000,00000000 pause=3D0f link=3D1 an=
=3D0
> [   28.640324] dwmac-sun8i 5020000.ethernet eth0: Link is Up - 10Mbps/Ful=
l - flow control rx/tx
>=20
> Settings for eth0:
> 	Supported ports: [ TP MII ]
> 	Supported link modes:   10baseT/Half 10baseT/Full=20
> 	                        100baseT/Half 100baseT/Full=20
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: Yes
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  10baseT/Half 10baseT/Full=20
> 	                        100baseT/Half 100baseT/Full=20
> 	Advertised pause frame use: Symmetric Receive-only
> 	Advertised auto-negotiation: Yes
> 	Advertised FEC modes: Not reported
> 	Link partner advertised link modes:  10baseT/Half 10baseT/Full=20
> 	Link partner advertised pause frame use: Symmetric Receive-only
> 	Link partner advertised auto-negotiation: Yes
> 	Link partner advertised FEC modes: Not reported
> 	Speed: 10Mb/s
> 	Duplex: Full
> 	Port: MII
> 	PHYAD: 1
> 	Transceiver: internal
> 	Auto-negotiation: on
> 	Supports Wake-on: d
> 	Wake-on: d
> 	Current message level: 0x0000003f (63)
> 			       drv probe link timer ifdown ifup
> 	Link detected: yes
>=20
> On 5.2 it looks like this:
>=20
> [    1.153596] dwmac-sun8i 5020000.ethernet: PTP uses main clock
> [    1.416221] dwmac-sun8i 5020000.ethernet: PTP uses main clock
> [    1.522735] dwmac-sun8i 5020000.ethernet: Current syscon value is not =
the default 58000 (expect 50000)
> [    1.522750] dwmac-sun8i 5020000.ethernet: No HW DMA feature register s=
upported
> [    1.522753] dwmac-sun8i 5020000.ethernet: RX Checksum Offload Engine s=
upported
> [    1.522755] dwmac-sun8i 5020000.ethernet: COE Type 2
> [    1.522758] dwmac-sun8i 5020000.ethernet: TX Checksum insertion suppor=
ted
> [    1.522761] dwmac-sun8i 5020000.ethernet: Normal descriptors
> [    1.522763] dwmac-sun8i 5020000.ethernet: Chain mode enabled
> [    5.352833] dwmac-sun8i 5020000.ethernet eth0: No Safety Features supp=
ort found
> [    5.352842] dwmac-sun8i 5020000.ethernet eth0: No MAC Management Count=
ers available
> [    5.352846] dwmac-sun8i 5020000.ethernet eth0: PTP not supported by HW
> [   10.463072] dwmac-sun8i 5020000.ethernet eth0: Link is Up - 1Gbps/Full=
 - flow control off
>=20
> Settings for eth0:
> 	Supported ports: [ TP MII ]
> 	Supported link modes:   10baseT/Half 10baseT/Full
> 	                        100baseT/Half 100baseT/Full
> 	                        1000baseT/Half 1000baseT/Full
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: Yes
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  10baseT/Half 10baseT/Full
> 	                        100baseT/Half 100baseT/Full
> 	                        1000baseT/Half 1000baseT/Full
> 	Advertised pause frame use: No
> 	Advertised auto-negotiation: Yes
> 	Advertised FEC modes: Not reported
> 	Link partner advertised link modes:  10baseT/Half 10baseT/Full
> 	                                     100baseT/Half 100baseT/Full
> 	                                     1000baseT/Full
> 	Link partner advertised pause frame use: Symmetric Receive-only
> 	Link partner advertised auto-negotiation: Yes
> 	Link partner advertised FEC modes: Not reported
> 	Speed: 1000Mb/s
> 	Duplex: Full
> 	Port: MII
> 	PHYAD: 1
> 	Transceiver: internal
> 	Auto-negotiation: on
> 	Supports Wake-on: d
> 	Wake-on: d
> 	Current message level: 0x0000003f (63)
> 			       drv probe link timer ifdown ifup
> 	Link detected: yes
>=20
>=20
> > Cc: Joao Pinto <jpinto@synopsys.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> > Cc: Alexandre Torgue <alexandre.torgue@st.com>
> > Cc: Russell King <linux@armlinux.org.uk>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Florian Fainelli <f.fainelli@gmail.com>
> > Cc: Heiner Kallweit <hkallweit1@gmail.com>
> >=20
> > Jose Abreu (3):
> >   net: stmmac: Prepare to convert to phylink
> >   net: stmmac: Start adding phylink support
> >   net: stmmac: Convert to phylink and remove phylib logic
> >=20
> >  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   3 +-
> >  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   7 +-
> >  .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  81 +---
> >  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 391 ++++++++----------
> >  .../ethernet/stmicro/stmmac/stmmac_platform.c |  21 +-
> >  5 files changed, 190 insertions(+), 313 deletions(-)
> >=20
> > --=20
> > 2.21.0
> >=20


---
Thanks,
Jose Miguel Abreu

--_002_BN8PR12MB32660B12F8E2617ED42249BBD3C40BN8PR12MB3266namp_
Content-Type: application/octet-stream;
	name="0001-net-stmmac-Do-not-cut-down-1G-modes.patch"
Content-Description: 0001-net-stmmac-Do-not-cut-down-1G-modes.patch
Content-Disposition: attachment;
	filename="0001-net-stmmac-Do-not-cut-down-1G-modes.patch"; size=2316;
	creation-date="Mon, 22 Jul 2019 13:28:00 GMT";
	modification-date="Mon, 22 Jul 2019 13:28:00 GMT"
Content-Transfer-Encoding: base64

RnJvbSA2ZTk0Y2FhM2I1MTg3MzVjOGM2MzdkNThlZjc2Y2IxYWFiYWM2ZTA5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NmU5NGNhYTNiNTE4NzM1YzhjNjM3ZDU4ZWY3NmNi
MWFhYmFjNmUwOS4xNTYzODAyMDgwLmdpdC5qb2FicmV1QHN5bm9wc3lzLmNvbT4KRnJvbTogSm9z
ZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+CkRhdGU6IE1vbiwgMjIgSnVsIDIwMTkgMTU6
MjY6MTUgKzAyMDAKU3ViamVjdDogW1BBVENIIG5ldF0gbmV0OiBzdG1tYWM6IERvIG5vdCBjdXQg
ZG93biAxRyBtb2RlcwpNSU1FLVZlcnNpb246IDEuMApDb250ZW50LVR5cGU6IHRleHQvcGxhaW47
IGNoYXJzZXQ9VVRGLTgKQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKU29tZSBnbHVl
IGxvZ2ljIGRyaXZlcnMgc3VwcG9ydCAxRyB3aXRob3V0IGhhdmluZyBHTUFDL0dNQUM0L1hHTUFD
LgoKTGV0J3MgYWxsb3cgdGhpcyBzcGVlZCBieSBkZWZhdWx0LgoKUmVwb3J0ZWQtYnk6IE9uZMWZ
ZWogSmlybWFuIDxtZWdpQHhmZi5jej4KRml4ZXM6IDViMGQ3ZDdkYTY0YiAoIm5ldDogc3RtbWFj
OiBBZGQgdGhlIG1pc3Npbmcgc3BlZWRzIHRoYXQgWEdNQUMgc3VwcG9ydHMiKQpTaWduZWQtb2Zm
LWJ5OiBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lzLmNvbT4KCi0tLQpDYzogR2l1c2VwcGUg
Q2F2YWxsYXJvIDxwZXBwZS5jYXZhbGxhcm9Ac3QuY29tPgpDYzogQWxleGFuZHJlIFRvcmd1ZSA8
YWxleGFuZHJlLnRvcmd1ZUBzdC5jb20+CkNjOiBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lz
LmNvbT4KQ2M6ICJEYXZpZCBTLiBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0PgpDYzogTWF4
aW1lIENvcXVlbGluIDxtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tPgpDYzogbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZwpDYzogbGludXgtc3RtMzJAc3QtbWQtbWFpbG1hbi5zdG9ybXJlcGx5LmNvbQpD
YzogbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCkNjOiBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnCi0tLQogZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMv
c3RtbWFjX21haW4uYyB8IDExICsrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1p
Y3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jCmluZGV4IDIwN2MzNzU1YmNjNS4uYjBkNWU1MzQ2NTk3
IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNf
bWFpbi5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19t
YWluLmMKQEAgLTgxNCwyMCArODE0LDE1IEBAIHN0YXRpYyB2b2lkIHN0bW1hY192YWxpZGF0ZShz
dHJ1Y3QgcGh5bGlua19jb25maWcgKmNvbmZpZywKIAlwaHlsaW5rX3NldChtYWNfc3VwcG9ydGVk
LCAxMGJhc2VUX0Z1bGwpOwogCXBoeWxpbmtfc2V0KG1hY19zdXBwb3J0ZWQsIDEwMGJhc2VUX0hh
bGYpOwogCXBoeWxpbmtfc2V0KG1hY19zdXBwb3J0ZWQsIDEwMGJhc2VUX0Z1bGwpOworCXBoeWxp
bmtfc2V0KG1hY19zdXBwb3J0ZWQsIDEwMDBiYXNlVF9IYWxmKTsKKwlwaHlsaW5rX3NldChtYWNf
c3VwcG9ydGVkLCAxMDAwYmFzZVRfRnVsbCk7CisJcGh5bGlua19zZXQobWFjX3N1cHBvcnRlZCwg
MTAwMGJhc2VLWF9GdWxsKTsKIAogCXBoeWxpbmtfc2V0KG1hY19zdXBwb3J0ZWQsIEF1dG9uZWcp
OwogCXBoeWxpbmtfc2V0KG1hY19zdXBwb3J0ZWQsIFBhdXNlKTsKIAlwaHlsaW5rX3NldChtYWNf
c3VwcG9ydGVkLCBBc3ltX1BhdXNlKTsKIAlwaHlsaW5rX3NldF9wb3J0X21vZGVzKG1hY19zdXBw
b3J0ZWQpOwogCi0JaWYgKHByaXYtPnBsYXQtPmhhc19nbWFjIHx8Ci0JICAgIHByaXYtPnBsYXQt
Pmhhc19nbWFjNCB8fAotCSAgICBwcml2LT5wbGF0LT5oYXNfeGdtYWMpIHsKLQkJcGh5bGlua19z
ZXQobWFjX3N1cHBvcnRlZCwgMTAwMGJhc2VUX0hhbGYpOwotCQlwaHlsaW5rX3NldChtYWNfc3Vw
cG9ydGVkLCAxMDAwYmFzZVRfRnVsbCk7Ci0JCXBoeWxpbmtfc2V0KG1hY19zdXBwb3J0ZWQsIDEw
MDBiYXNlS1hfRnVsbCk7Ci0JfQotCiAJLyogQ3V0IGRvd24gMUcgaWYgYXNrZWQgdG8gKi8KIAlp
ZiAoKG1heF9zcGVlZCA+IDApICYmIChtYXhfc3BlZWQgPCAxMDAwKSkgewogCQlwaHlsaW5rX3Nl
dChtYXNrLCAxMDAwYmFzZVRfRnVsbCk7Ci0tIAoyLjcuNAoK

--_002_BN8PR12MB32660B12F8E2617ED42249BBD3C40BN8PR12MB3266namp_--
