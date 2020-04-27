Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745D61BAB9E
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgD0RsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:48:16 -0400
Received: from mail-eopbgr50047.outbound.protection.outlook.com ([40.107.5.47]:17472
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbgD0RsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 13:48:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJC5zxi5v4SkXJ1LV/Q1wWdMsyrVkvhcyUBx4C63bUOSUisBB+AOeRXohPZEElT/Ww1HTWdsKmYRrdQL3rgOD6lpZC5zYf2B9sJpPeWXm7zNIY6qqmMVZ7n23gbVVuDca4RqEt/s4nCzUoCGM+lpnXbJ5+vUpiB8MJej+EvE2gblg4zeKw42r4ZlsT4EoOs/vt3zQSp8+NCqdGebQ85bDwuSe+jogo53qXGm2WvrQj5NhCW09Z2R4cK9vBf55H0RDqubb5GlQfavBuoHI3wv2HcQFG0Xq7+fssqxg8100cPeYSvAn+FaRklp2cVX+Ih8VUv+/1kCpMyr/XgTZMqlCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rjQMbzRIx5G7/teVc7uAWZi9HG/rwF1kTdSpw9P0DY=;
 b=WKg+ctUnS+7PTNBaWeAqCRykEZAvMIHLI7F5a/GVoHvT6Alx+04WvBH2kBOdE9XGx/gncUb0eRH4YfBMTklzubhlKV8zCrwQvweQUdkyMD9PQyEi0iwHmy3UNmMe4cGkHVOWFDjXWIzw+8EhgoCb8WoybYElGYFQETDNLvuyeGjNbjHeumW/aZD+HHzjNTV2FCzJY4abxHHmzLUlSkmD3GVlHC0F/lLHxTHvxNoMivC5JAFWBkiVMxdhl5Pn22N3PiC+pC5a3SehhI2R4aeRWJjIG12KUnc1inJNzqE5nATMqVuc6SzmgfaEtAAlaX0b2j51/hVKqClQaQbe/leEsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rjQMbzRIx5G7/teVc7uAWZi9HG/rwF1kTdSpw9P0DY=;
 b=cPOhFaMSKLTkPBjQghhh/m6CbAhp5Z8mMKMMC1NO3XPI5VCZUsAErb8WsDPzkGBdLBjEPVapnmRakbmiZkIxTLKJn13Ikyfc2kvqEWxmibi6zWy229SMohwqWSIzD/D1Zegq7KUkfMlQOmArTUHgTAGMhLDLNhpn2pnwxij5x9E=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB3609.eurprd04.prod.outlook.com (2603:10a6:7:84::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 17:48:11 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d%10]) with mapi id 15.20.2937.020; Mon, 27 Apr
 2020 17:48:11 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Leonard Crestez <leonard.crestez@nxp.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>, Chris Healy <cphealy@gmail.com>
Subject: RE: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Topic: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Thread-Index: AQHWHKdPfuK8So8PpU2iwth6Yyw7gKiNLXIAgAAQscA=
Date:   Mon, 27 Apr 2020 17:48:11 +0000
Message-ID: <HE1PR0402MB27458D83620D96D73F8AE898FFAF0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
 <20200427164620.GD1250287@lunn.ch>
In-Reply-To: <20200427164620.GD1250287@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [101.86.0.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 18175e91-3422-46e9-6dc2-08d7ead3272b
x-ms-traffictypediagnostic: HE1PR0402MB3609:|HE1PR0402MB3609:|HE1PR0402MB3609:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0402MB3609D3CCCCCEC50915F411D0FFAF0@HE1PR0402MB3609.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:353;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(81156014)(8676002)(66556008)(55016002)(2906002)(76116006)(71200400001)(66446008)(66946007)(8936002)(9686003)(66476007)(64756008)(6636002)(7696005)(54906003)(110136005)(5660300002)(4326008)(478600001)(86362001)(26005)(52536014)(6506007)(316002)(33656002)(186003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1VSYWTiSZH517FX8IVX8gFd+bMzscqp/bx/DyW+MgItsBz5zrHH8sgG1r5hdI75pRKgYPre48IXzxmvLEtRe6m2CHcyenQI++8aMVTnUIcsXplZi7xgmd0Cj+PQK+N1oGIhOQrBAiVY47XTD7V/mWCptOoXf0yULuFlSHwHFVVunJrv64gmhAWN4Oty/8OMLFMXnhcHffBuwzVHCMq9YCK7YIg2C7fa6fmfq8TqGfJDCERzgaE3/HHSYZaBRl9zqBe2+KZ3F+VSwxTrqUZNME03ZKEctKf2xQUnnwHQ8AdTaVobdwlFvdh/mNijeaavKckXEwU2ij5EiSy2SaarY7VoEUXbND2OCkk9j1GTggO3Omd6W+A0uL8jUqgGA83NeYKVP9JyL4P+091KSLHG3aJM8rjEFCzxVh6R8Ej5TM/uiucPZ5LTS6I7+kq1QZPqs
x-ms-exchange-antispam-messagedata: O0r+4Ek4KcOBIQ7pDetLbP2ZZnDvMb/DA1P+/xSXK/6wzVbQUzm474FW7fg79YW2zzSlX1J34TJ6qStiZoiIJhaXp1yv0LZDzIz5iHoyyVyQSzZIzoZVUSCu5LI9/XcIRDYnoqm+hC+BH5cCbXo45hBA259gfv9SxMD2tM5WwlHYHRqPeQopck2IeUmjynsaU1uDR7crBRKbB9KlaxYWQEfLPTYNK0MwRhrjHQU8HkSVCQ78GmQesGBKs7hFu5II1GdCG8gLvpgulgUnTk72820Wlu52JIC9/I6RTyofDIDG+NHAi/yCG6IsBFFLRNsP4qnZgpbi2aF708AzaqcON1TQB7ifmyIcMRD3BKQgJ7UzvZNDLqzEb/emiyc82Hi+4Z2cO+3Hf2IZTeg65KzgOM3zeHteqyb88W8HOM+s2PdBsvmvbApFES1rxj6lYi44u51irxlsL6/qBqvuj+NRWqm1YHqvxeqWnEHASkGg4JwsRLMJmQXFvC4aFtYSSWTFqbPbzcOni7grMDLHDos45Jke6o2rlxpC8bMq0Z6pXxFpmY2Arhx1eZY5i3LzWsIbVKbi+R22IQzmSPp8MKq0vbZeQ8Xdxjfa0QJP/dI7d4/X834oPUUZEEMmr/cPBgETtR57gOi9Ok4NLbpX1LUnSiSFu8Y4M8pkYwSQxYy4NLGLWrWAXsIgDx3nauIJsIh9bv5V24Ck8Ubwk5SVGvaHD9VCZwyyJhDkJQ7x0W69rO01VRKL0UP5gfA3aZI3wjW2PDAjs8r7ieB+yiaTafoQRJCP/Z6HbK3I//Q7X1mYAWM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18175e91-3422-46e9-6dc2-08d7ead3272b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 17:48:11.1441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NGE5TEiaxrmwG9jg7a86jiNHLQAJ1Md4L+XS7fJB/iVcHCnwqdsUGSDWu3N93bxO4qjut5PSSCKOOEZvOrpGYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3609
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Tuesday, April 28, 2020 12:46 AM
> On Mon, Apr 27, 2020 at 03:19:54PM +0000, Leonard Crestez wrote:
> > Hello,
> >
> > This patch breaks network boot on at least imx8mm-evk. Boot works if I
> > revert just commit 29ae6bd1b0d8 ("net: ethernet: fec: Replace
> > interrupt driven MDIO with polled IO") on top of next-20200424.
>=20
> Hi Leonard
>=20
> Please could you try this:
>=20
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
> b/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
> index 951e14a3de0e..3c1adaf7affa 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
> @@ -109,6 +109,7 @@ &fec1 {
>         phy-handle =3D <&ethphy0>;
>         phy-reset-gpios =3D <&gpio4 22 GPIO_ACTIVE_LOW>;
>         phy-reset-duration =3D <10>;
> +       phy-reset-post-delay =3D <100>;
>         fsl,magic-packet;
>         status =3D "okay";
>=20
Add the similar change as below on i.MX6SX sdb, it still doesn't work.
As my previous mail, udelay(50) can work.(50us can be optimized)

--- a/arch/arm/boot/dts/imx6sx-sdb.dtsi
+++ b/arch/arm/boot/dts/imx6sx-sdb.dtsi
@@ -194,6 +194,8 @@
        phy-mode =3D "rgmii-id";
        phy-handle =3D <&ethphy1>;
        phy-reset-gpios =3D <&gpio2 7 GPIO_ACTIVE_LOW>;
+       phy-reset-duration =3D <10>;
+       phy-reset-post-delay =3D <100>;
