Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C772FDC4C
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 23:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390972AbhATWTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 17:19:34 -0500
Received: from mail-eopbgr30045.outbound.protection.outlook.com ([40.107.3.45]:58023
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731757AbhATWE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 17:04:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1wVwaQt51M8JHexLEgsFTJXapI0FoP8IynNKok8n/Wz/HVag7zLKkuZ5cDYwnYb1cTJWLH+S9Et93nDYnSjSOTAVyfd7EfLFZYXskQYYk9U9xRgNX+DYRc3EyrfA3he/eD5v6+uUjs4dGBsMqezXby6vqoHZuS6KOEvZT1XvImJiiHlPff0o22Oi0NUfW/LqKJ02qMcPB5g2x492nGR2juIXfT8Gz3EbObda1QcloY4nwna8O0UePS/PEgGBEhnPLRZq9Kep9DbztRJdMYIABQZ3P0Kh7pkJym12u3bPAEIFU+35OVxNyHL3bq4XcGhPglnIYklYV3gFn/NLkqWJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8bjiegZUqE4XTp5hjlqR8Iu0D5HTjmnmQWwG8CyCqw=;
 b=Ky64FpDR2ZgOAXtASLshmU4ty59Vxt27gyb+hZJ/KpVlhWDG7xwRYGYLDqKFfwwJKjskRGEUOu8LHTh9D770n4ThL6VekTeazmocDhKVWHod68qt2Y/ATXWnDrAjtxd5F708G3+XRRH2wojfVElXexjbkWZsJfx22TLrsFuCmaM6ILz32IzQJCibyIqXTs+vMSZQBKkWKj8zhd4gd0WcLpYc9S4EF8olzdG6FdTmm4HAQUmRwgr5OS3JC4bb7Nw8G5GyMLkZIqgL3h8Pv5OGwlyu0mnLnSMkznzaljg3lhI4+nMguYDMxgzK93O6kg7pUbJhGqSCxUuVCOMKO3W4wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8bjiegZUqE4XTp5hjlqR8Iu0D5HTjmnmQWwG8CyCqw=;
 b=lRXFAQDKbzOL6e+eLdAIa9sPxNU4C/h+3S+WdUi6pS6xRIacuSXcocuZQV/OfgZ9A7n+CtlV9YdEXK/qsBiFxDTovNs3jEYC8nWr/YXc68Y3THd1D+YnQoLmhooDwXNuqcFy0UDcI1M85nWBJIalhOgynd8GKYUA1FRXwwLmPAQ=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5102.eurprd04.prod.outlook.com
 (2603:10a6:803:55::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 20 Jan
 2021 22:03:39 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88%3]) with mapi id 15.20.3763.013; Wed, 20 Jan 2021
 22:03:39 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: pcs: add pcs-lynx 1000BASE-X support
Thread-Topic: [PATCH net-next 1/3] net: pcs: add pcs-lynx 1000BASE-X support
Thread-Index: AQHW7njM3DiFu7tD/EuEzt+LT//dNKoxE0QA
Date:   Wed, 20 Jan 2021 22:03:39 +0000
Message-ID: <20210120220338.3hkom3sv3ljj6yus@skbuf>
References: <20210119153545.GK1551@shell.armlinux.org.uk>
 <E1l1t30-0005VL-Qx@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1l1t30-0005VL-Qx@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 04df06e9-f7ed-422e-0255-08d8bd8f3e60
x-ms-traffictypediagnostic: VI1PR04MB5102:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB51026310BD2D8F8D5B06A3B0E0A20@VI1PR04MB5102.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lhUuzhRLL5ldyqARsom6vi2yUgF8vBVfXUDk4vpSISz3m36f7cPGC1SXLz2iastgUn6IpXULi7ymDZQdSekP+l4LCebK2K4RiRsTfSJUx3HCAn5Vt0d5/OUFb9fjqgOL4C3AIW+FUEfJmSgePjaYfGLl+a+6Bac45dzBrBvO6aTrWyUMVzMIrzZi9vAkx65ARXw8L/cMkZFjlw152HHxn158ueCvmB3A/GTHvb5xUnQpQAdH4PNVc92yPdJecvVd6dwzCvyAOpGBtJw1RogIGGPtT3WlpMIB4dOjO15JovT6a8m78/rLiAe3PHXsOH9jEYvwG5+KB1c9qg+YSJkUQwYu10s7F4v/QMKFpsU7tKQpfCeY1QXNd/9ih2xCS3PfPK8rQUrLdqGblhfowtKCCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(136003)(39850400004)(396003)(376002)(366004)(186003)(1076003)(6506007)(26005)(8936002)(2906002)(8676002)(86362001)(5660300002)(44832011)(316002)(54906003)(83380400001)(9686003)(64756008)(478600001)(66476007)(66946007)(4326008)(66556008)(91956017)(6512007)(66446008)(76116006)(33716001)(71200400001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VjPphouzhC3pdpBc23d0Pf8IOEtsYeHT44cbXtF2Lr96Gla+eWWFRh+TGT/a?=
 =?us-ascii?Q?4UTx6yd2HQqBOzPQpOSEKkj7b47MmoMDtLfQjt9LJtFgvRc06bxe8mo8j1Yb?=
 =?us-ascii?Q?OhsC5GBHweq7Sy4QENrn+0lOwr/bcJDUbKDCYhZ8Nj2n6BGJWsZLN0+7N/SO?=
 =?us-ascii?Q?vvhwFnRAgUvac2C2fhddP5PNSRE7y8baIWyNlqzvRSyAPGyT02kahsZWQev3?=
 =?us-ascii?Q?FWuZVsqiyze3zxpq+mMJi7WvIP1ImXS23iRHxD5FIQ9rq7Kg4/OYZ0yNzYB+?=
 =?us-ascii?Q?1tjBe8fshJm1PQqU5/Jc04KtEOstajII2ch9qdE8FjaBYDqrStKJEuK/WLyQ?=
 =?us-ascii?Q?PaOFQ5ojLSmb7FO5TH24lKrMwKDpAnrn2LWQDia2yXiT1F8GRXxXTbdk+6qg?=
 =?us-ascii?Q?/V+k+Y6XpNvByY28AT0+asKR8SiYVMsi/GNMp/8/uUUlhAqt4JAxcSuaPR7K?=
 =?us-ascii?Q?34MsAzjwPwl8yeXRkk1rgZFfSKhbL6idK4F6lvH2ron5rqkzaZEzOQWT0sv/?=
 =?us-ascii?Q?g/wredz9isIP9ULFjRRj43Kh8in+1YbwSQ2mOocwnpUKKxG4unlMdI6eueD6?=
 =?us-ascii?Q?Ud95KrqWD2GhR/pZvzm8yBKx1lv1oMhZNRK4sQ7TD0fBs8PqpDZY6W0sw/HL?=
 =?us-ascii?Q?HsrVDQlapOnBnenfnUra3siVCnnonILoAmwJtzYB+lxqaRSZSJTCsGYftf3D?=
 =?us-ascii?Q?oH09kgpqYG+w9vtdumlV33zR4oyIhYJAyER2Ii6VFrqb+Z+BpR6pnB+LNs1A?=
 =?us-ascii?Q?rk8QhuMb+oPBJ42L4brrLPHPkfZ8hePdjVI1dgWCtt4AFLkAW52+LUE3/yyc?=
 =?us-ascii?Q?oVxzHed4RjWoZkC6ypN0skN9nsMcKpaTajwzFCS6OEFdDweL72dYyDDsKSE3?=
 =?us-ascii?Q?3o/Go/lDslxL3SVTMIebr4CaLKrBZHSR6+VTmvPDctt4SKW1HTJkw88fhBj1?=
 =?us-ascii?Q?IjzII9N/9ztzt+HPhTyb82GHGzdMSeePm495RpyX+nihWl7yVxsSQLfdw4hG?=
 =?us-ascii?Q?mkJGzhQvfbh0VpjKq2+VhGstA15a8u767xEs//mNrK49zKU/ElOfsvXjXrJ0?=
 =?us-ascii?Q?fjz0S0dQ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0B7C15A0FC35E14A840554191CC0C4A2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04df06e9-f7ed-422e-0255-08d8bd8f3e60
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 22:03:39.6448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zzk3kcT0+XkNRaL/+laKsrQmB1PN4wle7ORsBfrpBmZsV8n2GFGsKVzD7++s9Y9dGn2E8btEcAoIbL9j8KvU5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 03:35:58PM +0000, Russell King wrote:
> Add support for 1000BASE-X to pcs-lynx for the LX2160A.
>=20
> This commit prepares the ground work for allowing 1G fiber connections
> to be used with DPAA2 on the SolidRun CEX7 platforms.
>=20
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Also tested 1000BASEX on a HoneyComb board with a 1G fiber connection.

Thanks!

> ---
>  drivers/net/pcs/pcs-lynx.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>=20
> diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
> index 62bb9272dcb2..af36cd647bf5 100644
> --- a/drivers/net/pcs/pcs-lynx.c
> +++ b/drivers/net/pcs/pcs-lynx.c
> @@ -11,6 +11,7 @@
>  #define LINK_TIMER_VAL(ns)		((u32)((ns) / SGMII_CLOCK_PERIOD_NS))
> =20
>  #define SGMII_AN_LINK_TIMER_NS		1600000 /* defined by SGMII spec */
> +#define IEEE8023_LINK_TIMER_NS		10000000
> =20
>  #define LINK_TIMER_LO			0x12
>  #define LINK_TIMER_HI			0x13
> @@ -83,6 +84,7 @@ static void lynx_pcs_get_state(struct phylink_pcs *pcs,
>  	struct lynx_pcs *lynx =3D phylink_pcs_to_lynx(pcs);
> =20
>  	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_1000BASEX:
>  	case PHY_INTERFACE_MODE_SGMII:
>  	case PHY_INTERFACE_MODE_QSGMII:
>  		phylink_mii_c22_pcs_get_state(lynx->mdio, state);
> @@ -108,6 +110,30 @@ static void lynx_pcs_get_state(struct phylink_pcs *p=
cs,
>  		state->link, state->an_enabled, state->an_complete);
>  }
> =20
> +static int lynx_pcs_config_1000basex(struct mdio_device *pcs,
> +				     unsigned int mode,
> +				     const unsigned long *advertising)
> +{
> +	struct mii_bus *bus =3D pcs->bus;
> +	int addr =3D pcs->addr;
> +	u32 link_timer;
> +	int err;
> +
> +	link_timer =3D LINK_TIMER_VAL(IEEE8023_LINK_TIMER_NS);
> +	mdiobus_write(bus, addr, LINK_TIMER_LO, link_timer & 0xffff);
> +	mdiobus_write(bus, addr, LINK_TIMER_HI, link_timer >> 16);
> +
> +	err =3D mdiobus_modify(bus, addr, IF_MODE,
> +			     IF_MODE_SGMII_EN | IF_MODE_USE_SGMII_AN,
> +			     0);
> +	if (err)
> +		return err;
> +
> +	return phylink_mii_c22_pcs_config(pcs, mode,
> +					  PHY_INTERFACE_MODE_1000BASEX,
> +					  advertising);
> +}
> +
>  static int lynx_pcs_config_sgmii(struct mdio_device *pcs, unsigned int m=
ode,
>  				 const unsigned long *advertising)
>  {
> @@ -163,6 +189,8 @@ static int lynx_pcs_config(struct phylink_pcs *pcs, u=
nsigned int mode,
>  	struct lynx_pcs *lynx =3D phylink_pcs_to_lynx(pcs);
> =20
>  	switch (ifmode) {
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		return lynx_pcs_config_1000basex(lynx->mdio, mode, advertising);
>  	case PHY_INTERFACE_MODE_SGMII:
>  	case PHY_INTERFACE_MODE_QSGMII:
>  		return lynx_pcs_config_sgmii(lynx->mdio, mode, advertising);
> @@ -185,6 +213,13 @@ static int lynx_pcs_config(struct phylink_pcs *pcs, =
unsigned int mode,
>  	return 0;
>  }
> =20
> +static void lynx_pcs_an_restart(struct phylink_pcs *pcs)
> +{
> +	struct lynx_pcs *lynx =3D phylink_pcs_to_lynx(pcs);
> +
> +	phylink_mii_c22_pcs_an_restart(lynx->mdio);
> +}
> +
>  static void lynx_pcs_link_up_sgmii(struct mdio_device *pcs, unsigned int=
 mode,
>  				   int speed, int duplex)
>  {
> @@ -290,6 +325,7 @@ static void lynx_pcs_link_up(struct phylink_pcs *pcs,=
 unsigned int mode,
>  static const struct phylink_pcs_ops lynx_pcs_phylink_ops =3D {
>  	.pcs_get_state =3D lynx_pcs_get_state,
>  	.pcs_config =3D lynx_pcs_config,
> +	.pcs_an_restart =3D lynx_pcs_an_restart,
>  	.pcs_link_up =3D lynx_pcs_link_up,
>  };
> =20
> --=20
> 2.20.1
> =
