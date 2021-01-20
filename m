Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3BC2FDF58
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733021AbhATXvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:51:37 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:47748
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391317AbhATWUC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 17:20:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oF+xhxWCyfQfD/HB/4ySooIH2tSNIAye2n00S3iLxwLVzzowRijPwRSFXJWhHO8pjTWJHUXEBIcN4LgFzoA26bJatoRsvUYBCp4a6OptkHvE6UcLTBneTj7Xd/NpcS00r8h6DeKezuHw7//RddRZX4SqqVq8fCzJTvBFuCygdElgJB1VU6clmVCEIEvLFgBzq/3XObsIWbh2+sFrKw1jNd1eH9T96Cv5KcXtyTgLK+DeNyj80tj9kqTdzmcL4oPMICczTvlgI3lTm/mPaVZUKZE6p6AG+iNWQYhR84o5UmbMcA5twDw+RihdlfcBJDV+JpCxEfoNXbzidprAS/yybQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SI8eGUlFwocnsS50J77u8St1QTAHOHaqN8ykDkiVFAo=;
 b=F1agQE71gQfCILR5HmQh/umAYdzICEMX6pmjqpR2Mw5cw10UmzBDTq9XAzjLsCVQ+gGyhYz8+DFCcK/lLNUn2GU3pTOgmwJ2Ygcjv9Y2U4LUkKMGQKBxigwIsThXeBdZRKaAstC+AwkH3xfmdlPl+MJ7FHKHx1K97b/F71nloJ2MG2s3h2gwpJJArbq8oqS7Cdsyk0dx6vePFc3yWrRdkA1ldVJl7gKeu7EtgDD3CmtRdxOav0CN2Vj5+SL5bWcwECP6OnyAXTpD7Em5vOxUwGBjbNXN5hTEqBw+qR7/FUclgDJ7BG+M9QLjKqqEZNcY4Lbdi/Vq7jkTr4Pivde00A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SI8eGUlFwocnsS50J77u8St1QTAHOHaqN8ykDkiVFAo=;
 b=RIDvyTlsnQz38PplXhYwgbG/wX4D7tx5SCH9DpBOGC+de7r2hhy25JOe11ZOGzpsjFF6prwac6pLxVTCiFNcsC8gUnyXucbxca5hp3RNwGqqcEnTGoBJLxx20ZHTrUwilflJkh+t+wexxvgqYSJ/NBlAg4Lqn/cQWTEicuwh9Zk=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VE1PR04MB6591.eurprd04.prod.outlook.com
 (2603:10a6:803:123::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Wed, 20 Jan
 2021 22:19:01 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88%3]) with mapi id 15.20.3763.013; Wed, 20 Jan 2021
 22:19:01 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dpaa2-mac: add backplane link mode
 support
Thread-Topic: [PATCH net-next 3/3] net: dpaa2-mac: add backplane link mode
 support
Thread-Index: AQHW7njS/2CbT1uvRk+Ml5k8hJE4TqoxF48A
Date:   Wed, 20 Jan 2021 22:19:01 +0000
Message-ID: <20210120221900.i6esmk6uadgqpdtu@skbuf>
References: <20210119153545.GK1551@shell.armlinux.org.uk>
 <E1l1t3B-0005Vn-2N@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1l1t3B-0005Vn-2N@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4265648d-166d-4127-1bc9-08d8bd9163f7
x-ms-traffictypediagnostic: VE1PR04MB6591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB659165875129DD3A44E72489E0A20@VE1PR04MB6591.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mY23azfShrzqUGmlWg4eOaL3qEeVy9Oc1j+cMFNvkChF2K000+qkAL7T1NDgbEwenuLod8Mhrh0gotjGKEELYgZ8TsdQy2O7lQ3DRXyuJSUKbR/lTWijC6r5zf8dt/ARiBpY1Y51rGQey6K40nrBF1wA1tDYLsEFo81GzXObp9f4zuK/xA86PWaW3pl3nwwvlIKeYbqBiD6VXdtGzMqC0dk8wrIzeJwH/5w3pvTqdtnpPioJCEuPvu8XgMew8R3VNuIiUdLMm1gnCI343awoR1t2+uamUj7O0vHUNW59HPJNJZ0eBR0cOevPQkZyKqIaoTIfNB11Q3YtAOuTiEfL2IsXkl1TH2tnUt8c/UhOy/olfufzvJR06JHrQBKdzHBKitz9YKuHrruVS9mW7uaFIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(376002)(396003)(366004)(136003)(39860400002)(2906002)(8676002)(6486002)(71200400001)(66446008)(66556008)(5660300002)(9686003)(64756008)(6506007)(26005)(478600001)(4326008)(6512007)(33716001)(316002)(54906003)(66476007)(66946007)(86362001)(76116006)(91956017)(83380400001)(186003)(1076003)(8936002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qs/2x17a1qv1u9kWbWDnf7bwN34ISmCzDKq0UAW19FbVgEyUJK9urdg22Tde?=
 =?us-ascii?Q?Mwbz2ioa5qkw2JNNGCb0q+3cywEzUj+Xz9nBy0KzVZlqJk7pweftJqZYR/Dc?=
 =?us-ascii?Q?3Dptqkc0QS/u3Kqrr4ALigEP/+XBXPIb3Q7xTANDFYmHSPv9mTpRR5tuU776?=
 =?us-ascii?Q?nB0JMMIlqchFPotMuYS58C1ryfqzN4pjY1hgkvTYQmMerV+PiYaFm/Ak8YsW?=
 =?us-ascii?Q?Tx/xzLO4yz21rZ/FI+61dn8/IEsoY1/YDPtEN9TdruW94LIRwdH7hFHVu2VK?=
 =?us-ascii?Q?ZiVC5e6iNSjWap4R2FiE98ytnkvn+bOQOM+jadyHrAFobiCohG9beRdxUYYt?=
 =?us-ascii?Q?omqqDsyton/gHKLrHfm7bbLl8mOnD8EPQvcwNLXURIdvdvG4SGiGAsYUkAsb?=
 =?us-ascii?Q?wzes4kZFN6+gRTBICECO9IpjNzVkeRC7WvEmaJpAPcfm5MopL3impydZI8YB?=
 =?us-ascii?Q?t8lQlAAMkyWBITfTRYIuZNomo7VK/R9MXAGPTf5A8GIJCGkfyjN3BOmJzicv?=
 =?us-ascii?Q?PpLn2nkYlyZaQMCTs3cPTVqZyNC0lMsw2t4V2lF3rSYf8RQ0jECN0uWF2ZVZ?=
 =?us-ascii?Q?w9xA91gqEAm5YSkxrCi1K4x0/xkMW0okg6QXE8F3XL1AyCO9OodBxUF4e2uE?=
 =?us-ascii?Q?qskzuttgeca2d/jTdaXVNf5YBSoe/sbJ0sM0wpIZDanTT5ojsVTMt5TLECTj?=
 =?us-ascii?Q?u8pR8b2VNeEW/hP0Ze+MX4MvFbz8NuPy8RLGq/61jjubrWWxxyeeizTQC9du?=
 =?us-ascii?Q?eWG8EPRSDkn947gChBA1waqv3hVmCZ+QwdW+G8DIa7EOBhBOPHwCZzTxrcKe?=
 =?us-ascii?Q?yDmMqtmUI6StyiNvpKoHQGm2WQGIEHY5BD4n3fWnWpkAn7wsBTbZ57OKrEpS?=
 =?us-ascii?Q?8z19SOl+zAlo+AJXZQAK69oDyKVBnM5P2AQZxXkumLJgjtGurzttYZtfD6fI?=
 =?us-ascii?Q?/ReyuOVA/nh7h11Aac/H2dEQMnJnUCo/XLoaMA1d7AJ3b0mxzMgj/HkZXk70?=
 =?us-ascii?Q?MhDuyoxAPsCqfSWUhsmfhfNF+ZEL2H6gOaNwIlV7U79CDZlovj6WQDIMOzSc?=
 =?us-ascii?Q?X+Los8RB?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18EC8076B7D1794791C411C562F06CB1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4265648d-166d-4127-1bc9-08d8bd9163f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 22:19:01.7391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I5W479kftqC6JqdQpHaw3eXBWySn294XapP+P61x8qaEHrGi89z2H4OiChvPD9n6ex/vXMmNaZDDHxox1AalVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6591
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 03:36:09PM +0000, Russell King wrote:
> Add support for backplane link mode, which is, according to discussions
> with NXP earlier in the year, is a mode where the OS (Linux) is able to
> manage the PCS and Serdes itself.

Indeed, DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
by Linux (since the firmware is not touching these).
That being said, DPMACs in TYPE_PHY (the type that is already supported
in dpaa2-mac) can also have their PCS managed by Linux (no interraction
from the firmware's part with the PCS, just the SerDes).

All in all, this patch is not needed for this particular usecase, where
the switch between 1000Base-X and SGMII is done by just a minor
reconfiguration in the PCS, without the need for SerDes changes.

Also, with just the changes from this patch, a interface connected to a
DPMAC in TYPE_BACKPLANE is not even creating a phylink instance. It's
mainly because of this check from dpaa2-eth:

	if (dpaa2_eth_is_type_phy(priv)) {
		err =3D dpaa2_mac_connect(mac);


I would suggest just dropping this patch.

Ioana

>=20
> This commit prepares the ground work for allowing 1G fiber connections
> to be used with DPAA2 on the SolidRun CEX7 platforms.
>=20
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 3ddfb40eb5e4..ccaf7e35abeb 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -315,8 +315,9 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  		goto err_put_node;
>  	}
> =20
> -	if (mac->attr.link_type =3D=3D DPMAC_LINK_TYPE_PHY &&
> -	    mac->attr.eth_if !=3D DPMAC_ETH_IF_RGMII) {
> +	if ((mac->attr.link_type =3D=3D DPMAC_LINK_TYPE_PHY &&
> +	     mac->attr.eth_if !=3D DPMAC_ETH_IF_RGMII) ||
> +	    mac->attr.link_type =3D=3D DPMAC_LINK_TYPE_BACKPLANE) {
>  		err =3D dpaa2_pcs_create(mac, dpmac_node, mac->attr.id);
>  		if (err)
>  			goto err_put_node;
> --=20
> 2.20.1
> =
