Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5241EABA5
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfJaIjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:39:23 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:49064 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbfJaIjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:39:23 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C31FAC09C9;
        Thu, 31 Oct 2019 08:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1572511162; bh=GxC77TOuUejDsQZbf1c262jijOWhb32eAVb1Gi1NwGo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=iZz0P/a3Z2dHRjsCGXbfVjFOQoKa5XxTezGtTuTaynpvQFAZj1KNWEwALa3Vcc1t/
         JWSwscgZq9UGvyfUXqTDtr/6hQx6cG4ZBBBkNh6mwEn+EO+Xg+HITcU9ywVSnjdFPH
         PgcUiOCcwwJgRocNFn1LkXK+s9UjyG8by+d/PkrCp6ZWX1Z3vqd7+UV8AYW667OROH
         WM6rVnFuHjJTUXieRDYGZZ/Q0yXnpBG74Ai0fOCvBp6VT5uOIlxRJVkL01QemTdfyE
         WGIaU8bNC4/x/1VeP9y7uOnMSf9qCK9gJY5yRa+wWQd43WguyDcQk8Wxd9YvRJ0F1p
         Ruz3zjYmDg8qA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id A2A76A006E;
        Thu, 31 Oct 2019 08:39:19 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 31 Oct 2019 01:39:10 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 31 Oct 2019 01:39:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYl6HgCvNt31O71BH3ElMz7DvosKyX4RZ/rUUX2SjP9UpW8jAMQ7IgZYw2BcQ0R/+2xh3JN/H7Ka14JNQLf9h1klKwggaD9r7m4VRzEDnTAA2jw7IxY0RsaTwLmJaZBv2XfHUmoZs2llve66SFgu9+Yeohzgp9YI6G9uHJlzTLyq5WaGPvzmnVWWnz0k1Sg30TQkgPlC8ydlhqc36w46cHvp+GKCDEKqTq9kVGsc3ww3RelifScXFrI0rjB44Q2EPO6oPFES5yY9CAQG2wU5WLdMKuxmfcVqW4Ux3jYV8MI1So91v+H+nlZF7p/BfqKeCSulaq03WFcySzu/LZZT/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2p7iun54m3CUPkGHxp9Pakw+aF3hxaDGFotFX5fTV4=;
 b=ZVurJwe/MAwxPurdHMDVU6oTUmXJP58uV4q18a+LWGSuzE5e51pO1uvqIQsovNDEl8FTsSKYgDj7WAl7fRz3Mw3+7ZyKCWp6so2Pw8IkG55iwTQIkHjrKPrEtZvYA9hK+lu7dL2G1Q5eVd3WjwABiXwqH6XpPks2/Q081hKqqymJ3guhY4j2N6BAEzT3xlxMaOqMHTPp6H6q+Z5dNb9hgtPTdGUqsddtgYH+6xhvL0VI0ITf4pThXmuoB+jpU3i3ZYDichZEEkQp2rRzZhEZBXZMBb+2PiyVVWVoS80I/iIlxq+aoDU3yNVaud62sCHcERxOqiawS1vxXr9FFOuGZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2p7iun54m3CUPkGHxp9Pakw+aF3hxaDGFotFX5fTV4=;
 b=PHwTaW4ewtwey53pooqzroyGhJgiforx1GbVZ5ecYRenkRHc09w/KbHmVIOUhcn5K6eRsu3BbK7MUc/eixenpzhvt6Yl5wKbnLGpJ/WZg6ebq3DtmOi+zD4p4vUFvZbJrHNItlgkw73fnaaPQHH1ugdhrtKXcf6cQ8USMn5BVUg=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2994.namprd12.prod.outlook.com (20.178.210.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 31 Oct 2019 08:39:07 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8%5]) with mapi id 15.20.2408.018; Thu, 31 Oct 2019
 08:39:07 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Priit Laes <plaes@plaes.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "wens@csie.org" <wens@csie.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>
Subject: RE: sun7i-dwmac: link detection failure with 1000Mbit parters
Thread-Topic: sun7i-dwmac: link detection failure with 1000Mbit parters
Thread-Index: AQHVj1+vjIilepi+5E6/tch+UVqsaad0bbLQ
Date:   Thu, 31 Oct 2019 08:39:06 +0000
Message-ID: <BN8PR12MB32660687285D2C76E7CF2FF6D3630@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20191030202117.GA29022@plaes.org>
In-Reply-To: <20191030202117.GA29022@plaes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9b9aa63-4b7b-4e22-1cdd-08d75dddcb2f
x-ms-traffictypediagnostic: BN8PR12MB2994:
x-microsoft-antispam-prvs: <BN8PR12MB2994E92C16D16BA773A578BBD3630@BN8PR12MB2994.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(366004)(376002)(396003)(346002)(189003)(199004)(476003)(66066001)(9686003)(6246003)(6506007)(86362001)(478600001)(52536014)(186003)(99286004)(11346002)(7696005)(26005)(25786009)(5660300002)(110136005)(54906003)(6116002)(76176011)(3846002)(55016002)(6436002)(102836004)(316002)(2501003)(8936002)(5024004)(14444005)(2906002)(229853002)(76116006)(486006)(74316002)(66946007)(7416002)(14454004)(8676002)(81166006)(66446008)(64756008)(71190400001)(305945005)(7736002)(33656002)(71200400001)(66556008)(2201001)(66476007)(81156014)(4326008)(256004)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2994;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kPo7FCDneKIA5RgslfDHyw5/hRN7ukRa1+Vcay8XkXNAL1RD/RVaKLskpIOVSs0YSJBJQsWwW/DnHFnqV36DMSb/MlUheQo6wH6SuJj9QnRIB7N+iyqO4eeHk2itJ89tl85DRBmvaCiQut0ye6kbhjG3XVkeq+Jh+eqwWLD8amgc/tY4j3xlSu+efRWf3O6a29/JS2Vk/WLwwZmikg8vf+YyWCkGxW6p/hCPX97idqhjy48pSYpnL+1av9yB0KfVLO1F61DFUR+cFVjj11N8MRsGdBkBYwzsx9/iAgQ/FLI9qgFctgpPergHd+jWVhr22oHjjh7IBunv2YHAmvP1UK3azlzjHCZ6ybliRcYK1jXEDuBWbE2rCuxIhFqHJy2piEikL+HQMwJodr/ekrdS/+ljREeFNCIVDjijmf4KkC78cZblArA7teaOFjZcju9z
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b9aa63-4b7b-4e22-1cdd-08d75dddcb2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 08:39:07.0084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NTTMu7zizgEkdIhVOHhWRNs2tgKCRMZMHakMHOoaYk7alJJ5K1fji17RhFYg9g/Uy+Nrx9rvUEG8m7YBE6EImQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2994
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

++ Florian, Andrew, Heiner, Russell

Can you please attach your dmesg log ? PHYLINK provides some useful=20
debug logs.

From: Priit Laes <plaes@plaes.org>
Date: Oct/30/2019, 20:21:17 (UTC+00:00)

> Heya!
>=20
> I have noticed that with sun7i-dwmac driver (OLinuxino Lime2 eMMC), link
> detection fails consistently with certain 1000Mbit partners (for example =
Huawei
> B525s-23a 4g modem ethernet outputs and RTL8153-based USB3.0 ethernet don=
gle),
> but the same hardware works properly with certain other link partners (10=
0Mbit GL AR150
> for example).
>=20
> (Just need to test with another 1000Mbit switch at the office).
>=20
> I first thought it could be a regression, but I went from current master =
to as far back
> as 5.2.0-rc6 where it was still broken.
>=20
> Failure is basically following:
>=20
> [   10.971485] sun7i-dwmac 1c50000.ethernet eth0: PHY [stmmac-0:01] drive=
r [Generic PHY]
> [   10.980841] sun7i-dwmac 1c50000.ethernet eth0: No Safety Features supp=
ort found
> [   10.988291] sun7i-dwmac 1c50000.ethernet eth0: RX IPC Checksum Offload=
 disabled
> [   10.995694] sun7i-dwmac 1c50000.ethernet eth0: No MAC Management Count=
ers available
> [   11.003381] sun7i-dwmac 1c50000.ethernet eth0: PTP not supported by HW
> [   11.009927] sun7i-dwmac 1c50000.ethernet eth0: configuring for phy/rgm=
ii link mode
> ... link and activity leds go blank ...
> ... remove and replug and link is detected again ...
> [   19.371894] sun7i-dwmac 1c50000.ethernet eth0: Link is Up - 1Gbps/Full=
 - flow control rx/tx
>=20
> Ethtool output in case link is down:
> [snip]
> 	Supported ports: [ TP MII ]
> 	Supported link modes:   10baseT/Half 10baseT/Full=20
> 	                        100baseT/Half 100baseT/Full=20
> 	                        1000baseT/Half 1000baseT/Full=20
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: Yes
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  10baseT/Half 10baseT/Full=20
> 	                        100baseT/Half 100baseT/Full=20
> 	                        1000baseT/Half 1000baseT/Full=20
> 	Advertised pause frame use: Symmetric Receive-only
> 	Advertised auto-negotiation: Yes
> 	Advertised FEC modes: Not reported
> 	Speed: Unknown!
> 	Duplex: Unknown! (255)
> 	Port: MII
> 	PHYAD: 1
> 	Transceiver: internal
> 	Auto-negotiation: on
> 	Supports Wake-on: d
> 	Wake-on: d
> 	Current message level: 0x0000003f (63)
> 			       drv probe link timer ifdown ifup
> 	Link detected: no
> [/snip]
>=20
> And ethtool output in case cable is removed and replugged:
> [snip]
> ethtool eth0
> Settings for eth0:
> 	...cut...
> 	Advertised pause frame use: Symmetric Receive-only
> 	Advertised auto-negotiation: Yes
> 	Advertised FEC modes: Not reported
> 	Link partner advertised link modes:  10baseT/Half 10baseT/Full=20
> 	                                     100baseT/Half 100baseT/Full=20
> 	                                     1000baseT/Full=20
> 	Link partner advertised pause frame use: Symmetric
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
> [/snip]
>=20
>=20
> With 100Mbit link partner (GL Inet AR150), the link is pulled up almost
> immediately:
> [   15.531754] sun7i-dwmac 1c50000.ethernet eth0: Link is Up - 100Mbps/Fu=
ll - flow control rx/tx
>=20
> [snip]
> Settings for eth0:
> 	... cut ...
> 	Link partner advertised link modes:  10baseT/Half 10baseT/Full=20
> 	                                     100baseT/Half 100baseT/Full=20
> 	Link partner advertised pause frame use: Symmetric Receive-only
> 	Link partner advertised auto-negotiation: Yes
> 	Link partner advertised FEC modes: Not reported
> 	Speed: 100Mb/s
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
> [/snip]


---
Thanks,
Jose Miguel Abreu
