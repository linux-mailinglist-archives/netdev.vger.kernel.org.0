Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5333F12F827
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 13:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgACMXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 07:23:04 -0500
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:57910
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727457AbgACMXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 07:23:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m07A/lk3KLairb6RyVvpq85PMjfwQmm87sw6y5j2B8oGdj636FC3cBpoEVvS6+DNirRo4wt+xXPm/N2kf6NowH9hfH3IkA+lzV0vae6w9qXPpGKo+eRIRmb4A3ARZmgBNSF/6WIIjNJAdAdT1NsNZi2Z8/7Jwvdj+mAsEguQftezIFt9p02vIVmiNjatnf146O9sj7pDZXZLeElVExrZnkO/KUsp8a+xPr7aTEDwSrhvkc0c+e7oTyRQqZLc92I3Wi7bkm582BKgqeMxqpmjCCDACczjaR6Vu8C4RunjJ7rlqfnLrBmFVyYPZbCIrmLUdu4RjzwHAoGcn3KYyxMMoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGhB9LLhB2C8Hdhm07WQJXfwPIEGyMg7NA1YCas9oqQ=;
 b=UIIAIDU2Y2wY4sd8ybwXwhiDNUtQpMSJZ1yOQsEEdi3wApLyHM6NukvDAeELyaDnKplb1UT3h/G8TMDHIhxHz3g3/j8wgVEdTGoBiP8Zk5749cpJAghp6A0n+LyNyx4GprzIVcPsE8yI5Nuqy9ERIWPh2+0aEdibJcBvdfJLcesh93MY3rt2a72ErlG+aoFpcAHI9TiNR/71X6o72pA4c8st5Hm29shUMfEyj5ESxtL+4sOvRr3AO6aZm73QykPWrjJC8t3a1EJP4/zdUNVL7MctC99A307b2twItbqhc79KCDwucblBmovpqm6gKYPDd37rd03bMq4QWm9zmK6V5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGhB9LLhB2C8Hdhm07WQJXfwPIEGyMg7NA1YCas9oqQ=;
 b=RVb4EpdoemKCcHjnvN3TSpzvDH2JtnuB59s4OdgG3HDnAMIcGh4buBwx9EqIVaGT95+UL6BjUlwVyocyYbSImr//O6CVIv/wjBU9n5jDL/oh+z6QZeTKJBNjy6DX5fV7NaQGzx0y5Qr+B5qrOhoWGO5yBBjvas7j2+XbpC9V3Yg=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6364.eurprd04.prod.outlook.com (20.179.250.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Fri, 3 Jan 2020 12:22:58 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2602.012; Fri, 3 Jan 2020
 12:22:58 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/2] Fix 10G PHY interface types
Thread-Topic: [PATCH net-next 0/2] Fix 10G PHY interface types
Thread-Index: AQHVwiwrxFflOt73iU6BRITH1hAO2KfY2OpQ
Date:   Fri, 3 Jan 2020 12:22:58 +0000
Message-ID: <DB8PR04MB698593C7DB07A82577562348EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <20200103115125.GC25745@shell.armlinux.org.uk>
In-Reply-To: <20200103115125.GC25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6a5f4ee8-3d6d-4ad2-5f60-08d79047ab6c
x-ms-traffictypediagnostic: DB8PR04MB6364:
x-microsoft-antispam-prvs: <DB8PR04MB6364D153C39B5DAC88F0D6EDAD230@DB8PR04MB6364.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(189003)(199004)(13464003)(7696005)(4326008)(33656002)(55016002)(478600001)(52536014)(966005)(8936002)(5660300002)(86362001)(2906002)(66946007)(76116006)(9686003)(81156014)(81166006)(66556008)(66476007)(53546011)(8676002)(66446008)(64756008)(26005)(54906003)(6506007)(316002)(186003)(110136005)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6364;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s4yjd1/xdcP2mq9hvUuam4qIzgFDPg1GPu6XrNaEDFlYGRwmZ8XAdTKxnAQoxggtQaaNf/6TnPmr/W2Cx4umz7xDowyYrGz82MRpyFii9N7XenTbgq7DF74EElDviSBU5GPVpeywzFzBY2m4AhOoK0VFYKS7K9tsWlrUH/dI1DLblbHuQGxegZwJJ1qodrTRk7J1b1KEf63O5obr7qFmxnAdzhzg+L+ScrFQSUBqjbUP4kgtAaWHKaHo6LMOp6FGNBPrQ4Bbm42ZNoQIJpsbhAbz1E8AwUvUdV4XPix7zAji9X9fLfSky4eHqvnDWD6ebcqbtoDH+6RjFHo6Cj6FTC7S4yTu61O87w13m0g6nYqP5xBCAP2wMDQCAxY1ZIqn3i4HpHGk3i8fHSjtC12kEeGOwfh87WiZR/ojPakSZoOob08lzmbebk6Jyi7pyfWGoWT5ox6GBbU5kFTMQCFgFxcT3hrf1AMuP3LqZ/58t/TbDosUGYlikg8wK4R/YxKmYsgHbYjexUGSjjzRCm6QoYxCn29M/Rv6mOAz5bh6swE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a5f4ee8-3d6d-4ad2-5f60-08d79047ab6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 12:22:58.8083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hgJm92pkpKODkaqjjA9wlbKapkcSDu7SINHxzoFzzbngFaVXWJppKo1+dSNcbAZWsEX0RPzFo9zEWvqyvPx8Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6364
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Russell King - ARM Linux admin
> Sent: Friday, January 3, 2020 1:51 PM
> To: Andrew Lunn <andrew@lunn.ch>; Florian Fainelli <f.fainelli@gmail.com>=
;
> Heiner Kallweit <hkallweit1@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>; Jonathan Corbet
> <corbet@lwn.net>; Kishon Vijay Abraham I <kishon@ti.com>; linux-
> doc@vger.kernel.org; netdev@vger.kernel.org
> Subject: [PATCH net-next 0/2] Fix 10G PHY interface types
>=20
> Recent discussion has revealed that our current usage of the 10GKR
> phy_interface_t is not correct. This is based on a misunderstanding
> caused in part by the various specifications being difficult to
> obtain. Now that a better understanding has been reached, we ought
> to correct this.
>=20
> This series introduce PHY_INTERFACE_MODE_10GBASER to replace the
> existing usage of 10GKR mode, and document their differences in the
> phylib documentation. Then switch PHY, SFP/phylink, the Marvell
> PP2 network driver, and its associated comphy driver over to use
> the correct interface mode. None of the existing platform usage
> was actually using 10GBASE-KR.
>=20
> In order to maintain compatibility with existing DT files, arrange
> for the Marvell PP2 driver to rewrite the phy interface mode; this
> allows other drivers to adopt correct behaviour w.r.t whether the
> 10G connection conforms to the backplane 10GBASE-KR protocol vs
> normal 10GBASE-R protocol.
>=20
> After applying these locally to net-next I've validated that the
> only places which mention the old PHY_INTERFACE_MODE_10GKR
> definition are:
>=20
> Documentation/networking/phy.rst:``PHY_INTERFACE_MODE_10GKR``
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:        if (phy_mode =3D=
=3D
> PHY_INTERFACE_MODE_10GKR)
> drivers/net/phy/aquantia_main.c:                phydev->interface =3D
> PHY_INTERFACE_MODE_10GKR;
> drivers/net/phy/aquantia_main.c:            phydev->interface !=3D
> PHY_INTERFACE_MODE_10GKR &&
> include/linux/phy.h:    PHY_INTERFACE_MODE_10GKR,
> include/linux/phy.h:    case PHY_INTERFACE_MODE_10GKR:
>=20
> which is as expected.  The only users of "10gbase-kr" in DT are:
>=20
> arch/arm64/boot/dts/marvell/armada-7040-db.dts: phy-mode =3D "10gbase-kr"=
;
> arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts:     phy-mode =
=3D
> "10gbase-kr";
> arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode =3D "10gbase-kr"=
;
> arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode =3D "10gbase-kr"=
;
> arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode =
=3D
> "10gbase-kr";
> arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode =
=3D
> "10gbase-kr";
> arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-mode =3D
> "10gbase-kr";arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-
> mode =3D "10gbase-kr";arch/arm64/boot/dts/marvell/cn9130-db.dts:      phy=
-
> mode =3D "10gbase-kr";
> arch/arm64/boot/dts/marvell/cn9131-db.dts:      phy-mode =3D "10gbase-kr"=
;
> arch/arm64/boot/dts/marvell/cn9132-db.dts:      phy-mode =3D "10gbase-kr"=
;
>=20
> which all use the mvpp2 driver, and these will be updated in a
> separate patch to be submitted in the following kernel cycle.
>=20
>  Documentation/networking/phy.rst                | 18 ++++++++++++++++++
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 13 ++++++++-----
>  drivers/net/phy/aquantia_main.c                 |  7 +++++--
>  drivers/net/phy/bcm84881.c                      |  4 ++--
>  drivers/net/phy/marvell10g.c                    | 11 ++++++-----
>  drivers/net/phy/phylink.c                       |  1 +
>  drivers/net/phy/sfp-bus.c                       |  2 +-
>  drivers/phy/marvell/phy-mvebu-cp110-comphy.c    | 20 ++++++++++---------=
-
>  include/linux/phy.h                             | 12 ++++++++----
>  9 files changed, 59 insertions(+), 29 deletions(-)
>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbp=
s
> up
> According to speedtest.net: 11.9Mbps down 500kbps up

Hi,

we should conclude our discussions on the initial thread before we do this.
The current use on 10GBASE_KR is not correct, I agree but changing this to
10GBASE-R may not be the way to go. We need to determine if the existing
device tree binding corelated type is the one we need to change or maybe a
more complex solution is required. There are multiple paths forward:

Extending this enum that has a mix of things in it that are barely related.

For 10G Ethernet there is already an XGMII entry that describes the MII, if
this should stick to strict MIIs. This is of little value for chips that
have part of the traditional PHY blocks grouped along with the MAC, the XGM=
II
is not exposed outside the RTL (if it even exists there) and the actual
visible interfaces are completely different.

Describing the actual interface at chip to chip level (RGMII, SGMII, XAUI,
XFI, etc.). This may be incomplete for people trying to configure their HW
that supports multiple modes (reminder - device trees describe HW, they do
not configure SW). More details would be required and the list would be...
eclectic.

Moving to something different altogether, that would not conflict existing
device trees but permit a more thorough classification and less ambiguity.
We need more work on clearing a path towards that.

Regards,
Madalin
