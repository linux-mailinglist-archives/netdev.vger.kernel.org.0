Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0809C230E33
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbgG1Pm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:42:28 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:26358
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730679AbgG1Pm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 11:42:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8qvST0ClqwRxBfT2khIf1aQfjsQTq2DWZaPRjgBXjrPjBaSD12Ja7aX4doFk56rlUhNNbj/QTIFx3Z5IPhVzxRrio+d6EGy5vh4FsQiXrZQ18NwAIbCBc5wGQc/j+ds2UtO/lKHbBSZNnyJf60jikbuxaBfBmA7HFXkyNFBPYCGv5gdW2ayOgpZaTDztKhkcU1S0hNyR88x8Ou3qyg3/F6BqiM2UX1fj3utVd/RAO8+Q/wm+B0pcS3FOtOy3+iVnRcnnt5MdRjv9jllF489KG1M9cRlLBu6f5YU+p6H1c8sn918VXTpfTelCG/S+EoiHvqe5/RwqpVnxq40HF+JXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXFqDidzh1rspFcPrhQVD9Mwynh+mIeLkiTnrED+zt4=;
 b=CPsGT8x/a+tjC/Js9t7lh+R+GlX+4SKQJQoSfQLN4RynY6su41tOM2QxxW8mR7s66111e+wIggnfFa8gzv1L5mGQWsXSBMr6XlhD7xy58VNFekTNbMnAtwiUWqAFBOW9UtgVOeniNNypHWXGfR4ketnKhSfZk1Wrd/af2lPyaMDAU9oQInkKKE2dILdS79t0oAuyyO64riGYyqrp+KrfWJJVijEB803FJEMLgo1jpxrBMfgCjbHr0MwXJWMN1UFKmoMuQEUp3bYOsHEd5aJ5Zp5fFrUohzMV4mu16nRyOe2mYUXlh8K3fTsV+C8F2ePhGTfqL8VEtufOc3ZAQxiE8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXFqDidzh1rspFcPrhQVD9Mwynh+mIeLkiTnrED+zt4=;
 b=RHxmWDalB9F3SiMWlq9ooItkM4dHTqqCMe6rM3Q17eSYOpz/g093Ss3WcYB552lQ6X0eiyqdNvZSzv0tQ9H3qfSYHc23yR/h4jj1LzakjaTyNbohpYhVNBMhiQUm2dRnTbbdAPK77hP3xBXk1U0CM0WV9BXMtuUQvc0Fc2hzl4w=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5726.eurprd04.prod.outlook.com
 (2603:10a6:803:e5::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Tue, 28 Jul
 2020 15:42:22 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 15:42:22 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
Thread-Topic: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
Thread-Index: AQHWZFcvtAOghcV2G02sokHxIysjYqkdIC3g
Date:   Tue, 28 Jul 2020 15:42:22 +0000
Message-ID: <VI1PR0402MB3871906F6381418258CC7AEBE0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200727204731.1705418-1-andrew@lunn.ch>
In-Reply-To: <20200727204731.1705418-1-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.95.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4228221e-375d-49f1-8ac0-08d8330cd1e4
x-ms-traffictypediagnostic: VI1PR04MB5726:
x-microsoft-antispam-prvs: <VI1PR04MB57265C1F5F448682080E31C0E0730@VI1PR04MB5726.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BGkt2GWF9ml0nj+fFNTtJcvsiPbqcD3/lpTaBaeWWpeapH/BNExjYjS8S9rTc1qcH7k0/AN6Ob9kUFhrB0ljgj3rhepOdSaiL0B7OJK3WGNs2hcToLaIiS9sgWD5hpf9ZQ+xeWY/YSaZMVU1LHMSzoZm78fzxDEHv9dwZcuM62Ge8lyKoPi16Xu29Zzo0xKsFg0D+WOtlIqim+A54EQPOQ+0jYAw/sBcXRqD0dYcgX2pdGEUppTNGKz06P6HWsIl7spb1zvsfnONqupR4XjiDD+VBai2SnhodmAcbr8GCcYrMCZEGn34n6QhOZO+Y7tcGeIUUD5ZcLab5zURdPbs/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(26005)(186003)(8936002)(8676002)(44832011)(4326008)(7696005)(9686003)(71200400001)(55016002)(6506007)(110136005)(54906003)(316002)(478600001)(33656002)(2906002)(66946007)(66476007)(76116006)(66556008)(52536014)(5660300002)(83380400001)(64756008)(66446008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: t+o17puJixYwvZR/TAyLvdz86TZlhZlwG0coB1KdjY5QRsAceAFJ9fQ8sIB/ex3VecA6nD6/OpNzmZM9YHyUec7yzH7Xvw1cJ/ixWKsXIE3dZmqhwS9WYHkkYTozUzuDSKsJ4WGSpd/4XiXPAPvP/DXYmnDDMi4uXGLw17cezvlfQlMj3Xd5C+YgpeSzosl9pxx8NpBiJ2cMfFn18NPL9xS9JApbXgeO1ztDk8FVxGaBbw2bVrsNgZaNZc9+UgAGa5hWsGZ7ZRThhQEyV/oy0yQ6cW4QIMDtSGrIyh8B13sovp8jGJdYmuTV6Pd1FHbXFGWMCJp6gQcJANpewNjrB+egz6h/A4xy5J1assfvcM+xK2MEhddRRCllO+OqY9hK3uZWWn3Qhypd9PWEft7mccM4zmywjB3kqFsH2sSKCkbnYtOBe5WospocA2wz7+O7Hn3nLlCyQ2U2nsi9UMsv2QxfME8VNUG3v+E9UD02maNlNEVYpHWon1DaoGh7daCu27f1//PtxVt4NWDhPiwKxBntphmlVKBtw2ZPJCflB7rb8nut/T5qOG3cLOtNZNvFWJjWE0JGbj8ZbM8wJ4NwA+frb0bI+IB3CDGtY6jCHQUsblNS7Bwwj7pHOWjUFgWWuOBsWYzzabjquhZEd18TOA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4228221e-375d-49f1-8ac0-08d8330cd1e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 15:42:22.5675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BqMDRud0JSu+Xri35Pa7D6EjyKNJ1/nGCa682ePLPDEeO1aZuT2oSfIlmcMayJTZ+KbNnNod/WSy1PtWPtbPpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5726
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
>=20
> RFC Because it needs 0-day build testing
>=20
> The directory drivers/net/phy is getting rather cluttered with the growin=
g
> number of MDIO bus drivers and PHY device drivers. We also have one PCS
> driver and more are expected soon.
>=20
> Restructure the directory, moving MDIO bus drivers into /mdio.  PHY drive=
rs into
> /phy. The one current PCS driver is moved into /pcs and renamed to give i=
t the
> pcs- prefix which we hope will be followed by other PCS drivers.
>=20

I think that the MAINTAINERS file should also be updated to mention the new
path to the drivers. Just did a quick grep after 'drivers/net/phy':
F:      drivers/net/phy/adin.c     =20
F:      drivers/net/phy/mdio-xgene.c
F:      drivers/net/phy/           =20
F:      drivers/net/phy/marvell10g.c
F:      drivers/net/phy/mdio-mvusb.c
F:      drivers/net/phy/dp83640*   =20
F:      drivers/net/phy/phylink.c  =20
F:      drivers/net/phy/sfp*       =20
F:      drivers/net/phy/mdio-xpcs.c

Other than that, the new 'drivers/net/phy/phy/' path is somewhat repetitive=
 but
unfortunately I do not have another better suggestion.

Ioana

> Andrew Lunn (3):
>   net: xgene: Move shared header file into include/linux
>   net: phy: Move into subdirectories
>   net: phy: Move and rename mdio-xpcs
>=20
>  .../net/ethernet/apm/xgene/xgene_enet_main.h  |   2 +-
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   2 +-
>  drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +-
>  drivers/net/phy/Kconfig                       | 489 +-----------------
>  drivers/net/phy/Makefile                      |  79 +--
>  drivers/net/phy/mdio/Kconfig                  | 226 ++++++++
>  drivers/net/phy/mdio/Makefile                 |  26 +
>  drivers/net/phy/{ =3D> mdio}/mdio-aspeed.c      |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-bcm-iproc.c   |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-bcm-unimac.c  |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-bitbang.c     |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-cavium.c      |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-cavium.h      |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-gpio.c        |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-hisi-femac.c  |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-ipq4019.c     |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-ipq8064.c     |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-moxart.c      |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-mscc-miim.c   |   0
>  .../net/phy/{ =3D> mdio}/mdio-mux-bcm-iproc.c   |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-mux-gpio.c    |   0
>  .../net/phy/{ =3D> mdio}/mdio-mux-meson-g12a.c  |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-mux-mmioreg.c |   0
>  .../net/phy/{ =3D> mdio}/mdio-mux-multiplexer.c |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-mux.c         |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-mvusb.c       |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-octeon.c      |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-sun4i.c       |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-thunder.c     |   0
>  drivers/net/phy/{ =3D> mdio}/mdio-xgene.c       |   2 +-
>  drivers/net/phy/pcs/Kconfig                   |  20 +
>  drivers/net/phy/pcs/Makefile                  |   4 +
>  .../net/phy/{mdio-xpcs.c =3D> pcs/pcs-xpcs.c}   |   2 +-
>  drivers/net/phy/phy/Kconfig                   | 243 +++++++++
>  drivers/net/phy/phy/Makefile                  |  50 ++
>  drivers/net/phy/{ =3D> phy}/adin.c              |   0
>  drivers/net/phy/{ =3D> phy}/amd.c               |   0
>  drivers/net/phy/{ =3D> phy}/aquantia.h          |   0
>  drivers/net/phy/{ =3D> phy}/aquantia_hwmon.c    |   0
>  drivers/net/phy/{ =3D> phy}/aquantia_main.c     |   0
>  drivers/net/phy/{ =3D> phy}/at803x.c            |   0
>  drivers/net/phy/{ =3D> phy}/ax88796b.c          |   0
>  drivers/net/phy/{ =3D> phy}/bcm-cygnus.c        |   0
>  drivers/net/phy/{ =3D> phy}/bcm-phy-lib.c       |   0
>  drivers/net/phy/{ =3D> phy}/bcm-phy-lib.h       |   0
>  drivers/net/phy/{ =3D> phy}/bcm54140.c          |   0
>  drivers/net/phy/{ =3D> phy}/bcm63xx.c           |   0
>  drivers/net/phy/{ =3D> phy}/bcm7xxx.c           |   0
>  drivers/net/phy/{ =3D> phy}/bcm84881.c          |   0
>  drivers/net/phy/{ =3D> phy}/bcm87xx.c           |   0
>  drivers/net/phy/{ =3D> phy}/broadcom.c          |   0
>  drivers/net/phy/{ =3D> phy}/cicada.c            |   0
>  drivers/net/phy/{ =3D> phy}/cortina.c           |   0
>  drivers/net/phy/{ =3D> phy}/davicom.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83640.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83640_reg.h       |   0
>  drivers/net/phy/{ =3D> phy}/dp83822.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83848.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83867.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83869.c           |   0
>  drivers/net/phy/{ =3D> phy}/dp83tc811.c         |   0
>  drivers/net/phy/{ =3D> phy}/et1011c.c           |   0
>  drivers/net/phy/{ =3D> phy}/icplus.c            |   0
>  drivers/net/phy/{ =3D> phy}/intel-xway.c        |   0
>  drivers/net/phy/{ =3D> phy}/lxt.c               |   0
>  drivers/net/phy/{ =3D> phy}/marvell.c           |   0
>  drivers/net/phy/{ =3D> phy}/marvell10g.c        |   0
>  drivers/net/phy/{ =3D> phy}/meson-gxl.c         |   0
>  drivers/net/phy/{ =3D> phy}/micrel.c            |   0
>  drivers/net/phy/{ =3D> phy}/microchip.c         |   0
>  drivers/net/phy/{ =3D> phy}/microchip_t1.c      |   0
>  drivers/net/phy/{ =3D> phy}/mscc/Makefile       |   0
>  drivers/net/phy/{ =3D> phy}/mscc/mscc.h         |   0
>  .../net/phy/{ =3D> phy}/mscc/mscc_fc_buffer.h   |   0
>  drivers/net/phy/{ =3D> phy}/mscc/mscc_mac.h     |   0
>  drivers/net/phy/{ =3D> phy}/mscc/mscc_macsec.c  |   0
>  drivers/net/phy/{ =3D> phy}/mscc/mscc_macsec.h  |   0
>  drivers/net/phy/{ =3D> phy}/mscc/mscc_main.c    |   0
>  drivers/net/phy/{ =3D> phy}/national.c          |   0
>  drivers/net/phy/{ =3D> phy}/nxp-tja11xx.c       |   0
>  drivers/net/phy/{ =3D> phy}/qsemi.c             |   0
>  drivers/net/phy/{ =3D> phy}/realtek.c           |   0
>  drivers/net/phy/{ =3D> phy}/rockchip.c          |   0
>  drivers/net/phy/{ =3D> phy}/smsc.c              |   0
>  drivers/net/phy/{ =3D> phy}/ste10Xp.c           |   0
>  drivers/net/phy/{ =3D> phy}/teranetics.c        |   0
>  drivers/net/phy/{ =3D> phy}/uPD60620.c          |   0
>  drivers/net/phy/{ =3D> phy}/vitesse.c           |   0
>  .../net/phy =3D> include/linux}/mdio-xgene.h    |   0
>  include/linux/{mdio-xpcs.h =3D> pcs-xpcs.h}     |   8 +-
>  90 files changed, 594 insertions(+), 561 deletions(-)  create mode 10064=
4

(...)
