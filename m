Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB182FDD75
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 00:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391557AbhATXww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:52:52 -0500
Received: from mail-am6eur05on2059.outbound.protection.outlook.com ([40.107.22.59]:21792
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731814AbhATWYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 17:24:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhAvHn3fLFjsLXbMHI73Jwg5JQlLzTkjXBHuLJi7T4/noEvHlYaQ12jnudoe9SGFgF4WjeZNvfhaZhLab9vm1mFm1RzXodddsjipCNvZ3YMFKkDczmiqTuhnQT+TjTlA+2mU/gQxbg+fv8+tL2bY1l+Im4MRQiU65EoR0rTsmiCgzyDGAHC8dY6F2oBYx1QmhfWlIXwzN5i/rS0cv/fxxh563pmB4jGQIV0D6FnOSSAeEEFqhC9gRKTgiI9pfHRV413+HsqTJZZoA27t+pAIIzGZHCZyWjTsNic57PQFeD4XextUwHY9CxLcPRtu2wpAxmbNebb5Zi3Qge8GdQe8Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PgyBLEar9txfegs2X4zhHUPL1eOJ+QHM+vxqTHCcwGk=;
 b=Y4vpf/gCq2ftBBbaxS0ZqE9IMLbKElZMYlMECnZgJXhKiRXs0YO5zv/VL+SdmLCsr7FnMOxbZvmS173BUyXCk9EgkpRY9uXu/roGp3pGoLOFL6AwlRYx9rQeZTu9wTZ3JQa5Ie55KOfGbGx7vQj1jFOeNq1T9QDl0NJENdC6I7d/qZVMSRfYxy67cOqTUi8He7A6cQ1RdcWydKGVRBUGbKKprbwfQ+7KeyE98tqlcIHldlUY+1bZkTq9YrbI/Ey0Wjg6XM5w4T6wGGj2vadFJWq0Msohodq4egoJbDjqSNBGYF4NtKQrNiyz0Esub/M+h1EB9VRGFQMKu7VnHdj9EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PgyBLEar9txfegs2X4zhHUPL1eOJ+QHM+vxqTHCcwGk=;
 b=f9LuXZ3JQ8AFTpqrqj26pHdvfImdEG6q69PCYTYAig9nVlI+ej2PIpsN3ui4np7n7IQ9Lrl5HkQZ+iSdIKMIejR8ID4ykX0ll8eQYBCbEY29xy5kpuMormBa2cElGZrEapxmIC8dNABbg7HnjrRjS/g7qnC5RWyrSe7xYKH6YAU=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VE1PR04MB6591.eurprd04.prod.outlook.com
 (2603:10a6:803:123::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Wed, 20 Jan
 2021 22:23:57 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88%3]) with mapi id 15.20.3763.013; Wed, 20 Jan 2021
 22:23:57 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: dpaa2-mac: add 1000BASE-X support
Thread-Topic: [PATCH net-next 2/3] net: dpaa2-mac: add 1000BASE-X support
Thread-Index: AQHW7njPt5Sgd33Uj0+I9nW3owG2jqoxGO6A
Date:   Wed, 20 Jan 2021 22:23:56 +0000
Message-ID: <20210120222355.gnbekhsudjjyar4x@skbuf>
References: <20210119153545.GK1551@shell.armlinux.org.uk>
 <E1l1t35-0005VX-Uj@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1l1t35-0005VX-Uj@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fe5fd2af-14fb-4544-ab05-08d8bd9213ed
x-ms-traffictypediagnostic: VE1PR04MB6591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6591CAD17FACB57D8477678DE0A20@VE1PR04MB6591.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9qtrzVdk+R46mqVmJO2jOllfLB1qYprRF8l4MfffPiMsAx1PLNHbp0fvWXCAvVGTri0DMJDY3cfVWP2g5enRJ2hYc65eJuctidbMxLLknKTUk+vCphSo3TIdfdrX3IclTZvsxdNgg7I6UxngRaSMxxaogfwYzRmHwcJ6twxuRPJRWoq9rPgItBucSEc42UWujxcUWUZz3I3pozf2kfdlhbsRaVojkLOrftFIUC79NrmY4J11wuMdgY4X7L0FcfwSzlxUXfzKWtC6JvkTZQSTrggQAs5i1UUuA4Cz5P0A9sF2ynV+fTu2etrVR/cBbEmMTpHvK4ak951/l6WNhnSaBCVnDY8Zhu8y+enoyRxfRlhh4d9pcYuUnkgxQhS6bDKtPAN8q78ANVq8uwetNIOKew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(376002)(39850400004)(396003)(366004)(136003)(2906002)(8676002)(6486002)(71200400001)(66446008)(66556008)(5660300002)(9686003)(64756008)(6506007)(26005)(478600001)(4326008)(6512007)(33716001)(316002)(54906003)(66476007)(66946007)(86362001)(76116006)(91956017)(83380400001)(186003)(1076003)(8936002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?kRVRSB3JCHCxpQ5d0tZn96XMqqaPi5URPJQTv0Gr6M3ZGpJo47QnSTeu55l3?=
 =?us-ascii?Q?vwAHVXm06kuMzuLdtH8XXt2qGrV0gn+VwlBf9mMfN0KiK4pZJ5e4kGZRCEjo?=
 =?us-ascii?Q?VQVjmMLop3JZTXEjC8goO9Uvq/qs4+UOpxTVyZ0h/ms1ReEtQE6lig3A3YEi?=
 =?us-ascii?Q?yQK6DLye0NQ2gmtLmFBAvP5PEenfyL7eYz/EMS9wcULyQdwm3H+9GQqB0PsC?=
 =?us-ascii?Q?9hbkly2MpFepWvyL9XNB9WDiHVgNedurJ7ngRTv/S8AAMgatN53L8F/f0xVm?=
 =?us-ascii?Q?s9ttGLZoAN4MFAvnal5IeMOvALkIksEJuyvTPnI4NgoCY4F8M8aVLTV8KzaK?=
 =?us-ascii?Q?6q0oLCuZsXyfCsnXI+/pOfaGQZ3V8VYr7ZX4P1OP+ARaPcN6TjOY267JBGhI?=
 =?us-ascii?Q?mli0uF0g57rTlFQEYYwogY+MK84zBc5ipSKyTVVjtoLXyg6QtuaD5y6I0W0D?=
 =?us-ascii?Q?0S+03P0JVDYdvU7Lov3jSVMQfwWibkY3bnBl/63uUmo596VOCJl82m/tPXZj?=
 =?us-ascii?Q?ennzds/DVF5bTeamQ3QgqUG9c+Xl0chVTrLvkeAx87JhXIroLUBZ87KOF4Zu?=
 =?us-ascii?Q?kv88gMwlQ4ZBvvFEuhqPCryb5dMptIPv9YkPxTOwXekXfdLcLdxkXvKjTc+K?=
 =?us-ascii?Q?f8NY9j3AkOKPZ+R0NQF2GwbZcSa4ank0i79LZqM5gLl/wv5VKwKcPqIiVtHZ?=
 =?us-ascii?Q?P4Nc+pBgHuclEKf18x2HKrhZQr0zXZEhz3NOviO9xFL377TxupZnjVxdj4bs?=
 =?us-ascii?Q?m+pU1BQO/GsFaxt1af+fp8OkYqqCzJJbLPEWgPAL6CeiZREJRD+mQR7cDQbK?=
 =?us-ascii?Q?eCnMw39qXzudivkLR8003lVMpmXnI9F1HlTHCFEMfoHApcQ1BqTgRRqxCs1H?=
 =?us-ascii?Q?s/o5zGXqiyv/rBIbumZOrtQj69ya8Z6psDYVGG2ZF2eKYmKGPcjSx5MVl7BZ?=
 =?us-ascii?Q?DcSGe/ajOuccpiLNxpIorEf2uoRIJ7ZKFqxH9zBd5aiwinUAsIDotDE0zy+T?=
 =?us-ascii?Q?Mn9LXI199tuzG+7z8alrq9/cfYPVRLJ5a/2ygAYYY7/WCdw9PiLZiP1/K5GD?=
 =?us-ascii?Q?ICLD1s0y?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9E1D2A8633D7804E90FA1080A79F8708@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5fd2af-14fb-4544-ab05-08d8bd9213ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 22:23:56.9133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UtglQIpx9URAfFW8yk+IQxtUYf6oizCtzzq9+BJJgBJ51EbqU36/w49VjtWKqzwegsKaQy8u9v3iWjkxIn8mWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6591
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 03:36:03PM +0000, Russell King wrote:
> Now that pcs-lynx supports 1000BASE-X, add support for this interface
> mode to dpaa2-mac. pcs-lynx can be switched at runtime between SGMII
> and 1000BASE-X mode, so allow dpaa2-mac to switch between these as
> well.
>=20
> This commit prepares the ground work for allowing 1G fiber connections
> to be used with DPAA2 on the SolidRun CEX7 platforms.
>=20
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>


> ---
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 20 ++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 69ad869446cf..3ddfb40eb5e4 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -79,10 +79,20 @@ static bool dpaa2_mac_phy_mode_mismatch(struct dpaa2_=
mac *mac,
>  					phy_interface_t interface)
>  {
>  	switch (interface) {
> +	/* We can switch between SGMII and 1000BASE-X at runtime with
> +	 * pcs-lynx
> +	 */
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		if (mac->pcs &&
> +		    (mac->if_mode =3D=3D PHY_INTERFACE_MODE_SGMII ||
> +		     mac->if_mode =3D=3D PHY_INTERFACE_MODE_1000BASEX))
> +			return false;
> +		return interface !=3D mac->if_mode;
> +
>  	case PHY_INTERFACE_MODE_10GBASER:
>  	case PHY_INTERFACE_MODE_USXGMII:
>  	case PHY_INTERFACE_MODE_QSGMII:
> -	case PHY_INTERFACE_MODE_SGMII:
>  	case PHY_INTERFACE_MODE_RGMII:
>  	case PHY_INTERFACE_MODE_RGMII_ID:
>  	case PHY_INTERFACE_MODE_RGMII_RXID:
> @@ -122,13 +132,17 @@ static void dpaa2_mac_validate(struct phylink_confi=
g *config,
>  		fallthrough;
>  	case PHY_INTERFACE_MODE_SGMII:
>  	case PHY_INTERFACE_MODE_QSGMII:
> +	case PHY_INTERFACE_MODE_1000BASEX:
>  	case PHY_INTERFACE_MODE_RGMII:
>  	case PHY_INTERFACE_MODE_RGMII_ID:
>  	case PHY_INTERFACE_MODE_RGMII_RXID:
>  	case PHY_INTERFACE_MODE_RGMII_TXID:
> -		phylink_set(mask, 10baseT_Full);
> -		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 1000baseX_Full);
>  		phylink_set(mask, 1000baseT_Full);
> +		if (state->interface =3D=3D PHY_INTERFACE_MODE_1000BASEX)
> +			break;
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 10baseT_Full);
>  		break;
>  	default:
>  		goto empty_set;
> --=20
> 2.20.1
> =
