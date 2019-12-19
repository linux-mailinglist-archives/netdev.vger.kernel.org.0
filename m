Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1916A126FC4
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfLSVfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:35:05 -0500
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:15837
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726959AbfLSVfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 16:35:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNxWaUN0ch1aGaaJaDYAKlnwU+LG4U/Oe1eYFQiTyyaaFsjKseL8Sy1D0FfUCIoaaAIFBCIt90TFSVmo5FQegzBZ694pxUPg/KRBT7cvQ+hkHkV4AxtgssVLhmWkbH/Tu3RvKqYPrE0b9OlHWFD4VIJN7TYJJSEeF4CZ9WdI3p9SO/fTFtTAlGAtiOTWhLCdzYCIegcuwRmYEhBCtqQLsaq8AHEAYoYfu3+VF/Nucq3ZoSGcSqMimfzDS2VO/mvh3U0FkIDLcqZzF2/7ulQToh7t5qZDf1r1o5hfZIXmAP1WcoYStVBIRJvV3ogNQTfFFpMcAbLRAV+1WjSdnLJHPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x80zUu1xVgFTooyKCf4/iax/nNkFcz/k8VqP7dv8Nh4=;
 b=gHafL/FCBBgCJmkkzXfk8JZ37Xv19NQeXEHnO06Sn2ZFsLneOY/BptzM4f7fjNanDRCbjfEOyqotrSXKpRHxSpB3CrSiFB64KQvPX1+vUx6snjjQlu5gzQs9J58ve+Mn5cTJhrfI+xNDzG95cYwLEH5lalDUkUKNmAsZIBID63ophCJlIsz2TI0EyfrxL/k28RdA/FPOdo6lQXTnzqG+WalMD0Zf0o7upaRzodA/6HFEXBPCNjScPBpVbvVINrWTBXRm+J8u23aVymlLWT4mV51IVaCJ+dlzNWAP8Cmx24ZYAARMZdFuOEsZ2uwi7ldDVlZts19teZ7A5ZzkawV/Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x80zUu1xVgFTooyKCf4/iax/nNkFcz/k8VqP7dv8Nh4=;
 b=IXIl2AZ6bfxhBm13HPOMFwXnt7Z3V2/sYBMbOgqlYHI3CVONfdEsPX/OR4AJE9jT0XI6jNzR/f6/zFJeuyaiYHWunRrk5SKInFt7SvBLBQfYsivRV6y+DKP1+SjTWks2s8TREkx/aAEPfI4jDjD8xyWF7Il1WrpvgFOUchk6URg=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB4062.eurprd04.prod.outlook.com (52.133.12.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.13; Thu, 19 Dec 2019 21:34:58 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.016; Thu, 19 Dec 2019
 21:34:58 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Topic: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Index: AQHVtn//emqdPRPEmEKC7Ncoej9h46fBtnoAgAAMIfCAAA5LAIAAIOYw
Date:   Thu, 19 Dec 2019 21:34:57 +0000
Message-ID: <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219190308.GE25745@shell.armlinux.org.uk>
In-Reply-To: <20191219190308.GE25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [188.27.188.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 99e87d89-63f2-47d0-d91f-08d784cb4bcd
x-ms-traffictypediagnostic: VI1PR04MB4062:
x-microsoft-antispam-prvs: <VI1PR04MB40626ED801F8D30B8A22F61FAD520@VI1PR04MB4062.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(199004)(189003)(13464003)(6506007)(53546011)(7696005)(86362001)(71200400001)(66446008)(4326008)(66946007)(52536014)(64756008)(66556008)(76116006)(9686003)(66476007)(186003)(6916009)(2906002)(81166006)(81156014)(8676002)(478600001)(5660300002)(33656002)(54906003)(26005)(55016002)(8936002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4062;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4jV6nx2BbBI4EHEK5ni18xnfsc1HDGGPN6A6x6ASW4mQ1pa+EhJ+L6LG6W+qixzo58cdQspf7QSAFS+u12j09lTIrox7R9MV+UNWncR4zasog8MbD7k4tI3+GxvLqqeKxP3cCpFykm3edpvpKo9Gg1k1/OysG4e3bQQpRGsOxcZH+5jwhzvBory77hANnttgtWLqBzqfUOKluPnss6uYAVXZuaW5CMPv2lAu5DtOtDkVQIg0UnbA97QHwc7AmVBzu036JTsKxxiyHmhJsfKXhEIkafSO3DaXYQLGBhi+dfFMOF//NapsGvtpqsDYh1V1/+9uQGCaqJVM7bJ3hfPNVUmKXIzgsI4dTSyFm/m6vg+AHb5gUlzLj8Q7FPH7Tpf2jnHRRGfxeIk0AzWyrWGBdCIO4Y1I5sLlEyxaSSftimxpnRr/hE0k9E73oEqkE0TeqiUHeM5nB5K6DeWCICl8L1FYJiXb1u6hPI0fXJHfGWO1uxRZ0BhRPsFX5hauV3um
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e87d89-63f2-47d0-d91f-08d784cb4bcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 21:34:57.9474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OlN0E+weznj33vKxdN5V0LJboxj6DSvqWKodd55IrrWJgq2XtFSTlTlhHNmsBKR0cLKXugvBVundpaky1LWe5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Thursday, December 19, 2019 9:03 PM
> To: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; andrew@lunn.ch;
> f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
>=20
> On Thu, Dec 19, 2019 at 06:32:51PM +0000, Madalin Bucur wrote:
> > > -----Original Message-----
> > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > Sent: Thursday, December 19, 2019 7:29 PM
> > > To: Madalin Bucur <madalin.bucur@nxp.com>
> > > Cc: davem@davemloft.net; netdev@vger.kernel.org; andrew@lunn.ch;
> > > f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org;
> > > devicetree@vger.kernel.org
> > > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > >
> > > On Thu, Dec 19, 2019 at 05:21:16PM +0200, Madalin Bucur wrote:
> > > > From: Madalin Bucur <madalin.bucur@nxp.com>
> > > >
> > > > Add explicit entries for XFI, SFI to make sure the device
> > > > tree entries for phy-connection-type "xfi" or "sfi" are
> > > > properly parsed and differentiated against the existing
> > > > backplane 10GBASE-KR mode.
> > >
> > > 10GBASE-KR is actually used for XFI and SFI (due to a slight mistake
> on
> > > my part, it should've been just 10GBASE-R).
> > >
> > > Please explain exactly what the difference is between XFI, SFI and
> > > 10GBASE-R. I have not been able to find definitive definitions for
> > > XFI and SFI anywhere, and they appear to be precisely identical to
> > > 10GBASE-R. It seems that it's just a terminology thing, with
> > > different groups wanting to "own" what is essentially exactly the
> > > same interface type.
> >
> > Hi Russell,
> >
> > 10GBase-R could be used as a common nominator but just as well 10G and
> > remove the rest while we're at it. There are/may be differences in
> > features, differences in the way the HW is configured (the most
> > important aspect) and one should be able to determine what interface
> > type is in use to properly configure the HW. SFI does not have the CDR
> > function in the PMD, relying on the PMA signal conditioning vs the XFI
> > that requires this in the PMD. We kept the xgmii compatible for so long
> > without much issues until someone started cleaning up the PHY supported
> > modes. Since we're doing that, let's be rigorous. The 10GBase-KR is
> > important too, we have some backplane code in preparation and having it
> > there could pave the way for a simpler integration.
>=20
> The problem we currently have is:
>=20
> $ grep '10gbase-kr' arch/*/boot/dts -r
>=20
> virtually none of those are actually backplane. For the mcbin matches,
> these are either to a 88x3310 PHY for the doubleshot, which dynamically
> operates between XFI, 5GBASE-R, 2500BASE-X, or SGMII according to the
> datasheet.

Yes, I've seen it's used already in several places:

$ grep PHY_INTERFACE_MODE_10GKR drivers/net -nr
drivers/net/phy/marvell10g.c:219:       if (iface !=3D PHY_INTERFACE_MODE_1=
0GKR) {
drivers/net/phy/marvell10g.c:307:           phydev->interface !=3D PHY_INTE=
RFACE_MODE_10GKR)
drivers/net/phy/marvell10g.c:389:            phydev->interface =3D=3D PHY_I=
NTERFACE_MODE_10GKR) && phydev->link) {
drivers/net/phy/marvell10g.c:398:                       phydev->interface =
=3D PHY_INTERFACE_MODE_10GKR;
drivers/net/phy/phylink.c:296:          case PHY_INTERFACE_MODE_10GKR:
drivers/net/phy/aquantia_main.c:361:            phydev->interface =3D PHY_I=
NTERFACE_MODE_10GKR;
drivers/net/phy/aquantia_main.c:499:        phydev->interface !=3D PHY_INTE=
RFACE_MODE_10GKR)
drivers/net/phy/sfp-bus.c:340:          return PHY_INTERFACE_MODE_10GKR;
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:1117:   return interface =
=3D=3D PHY_INTERFACE_MODE_10GKR ||
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:1203:   case PHY_INTERFACE_=
MODE_10GKR:
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:1652:   case PHY_INTERFACE_=
MODE_10GKR:
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:4761:   case PHY_INTERFACE_=
MODE_10GKR:
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:4783:   case PHY_INTERFACE_=
MODE_10GKR:

We should fix this, if it's incorrect.

> If we add something else, then the problem becomes what to do about
> that lot - one of the problems is, it seems we're going to be breaking
> DT compatibility by redefining 10gbase-kr to be correct.

We need the committer/maintainer to update that to a correct value.
=20
> It's interesting to hear what the difference is between XFI and SFI,
> but it's weird that PHYs such as 88x3310 have no configuration of their
> fiber interface to enable or disable the CDR, yet it supports fiber
> interfaces, and explicitly shows applications involving "XFI/SFI".
> There's no mention of the CDR in the datasheet either.

I understand SFI came later, with the advantage of cheaper and less power
consuming SFP+ modules.
