Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03FE917A685
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgCENiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:38:06 -0500
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:52659
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725880AbgCENiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 08:38:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gU9satpE0NjdiPGr8CW4iY4gmKAyGOIakucWkqYJVYV8O80TNueh4N3OmvxTeTaw4khdXG2xG0l0xSG1tLlVWKHFOLP/e7zMaA5HDY8WoiRhvsfLuf0jAz0FKL1H4L5bJUILOhyA8UNwZ7oIEA8DXrUIHil7dkSaDqL2nnBaM/Ke2/KfCk6+hftdgp7TWwHWI/Q09LdIJSq3TYVclTh+NdPSIBUggsFlpertyHlZRdiu6k7Dknk0Kk/dgfEm+lCGJQyx2GftkO3GMorskLdySm4ai+A5fcwNuBNDz9GSxmojD4RbH0+EDqLBqdOuZ9J7Es0atAH/Zebox5iQKQdrBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=It/6RRFXpWBqe2dHLJ7zHwBSO7cBmFAT5xGbq8iJVw8=;
 b=k91k35EEheLty4jLiWnA9PjauDsg//4sYa5ruCfHALX0FT0OjPn95fNyWyhAyJukCA69OVbuwTNX1vPHORzsTtfrIEKvXQw6KhxTThLQjtBy/AN77kMbd524MNaq4oSjUgaTbz/ABpsQVEu+OQTiUcUUmx0dCWL55CkBsw8Xi44FTDRwRnr7xkRcimqlosVBpjhRo2a1n1bFbfCl06byF4y+oZw0GWoHIDpVjZGZLqQPoBeohEfESatz321NYKdCc6gMo0aUfJbjyPtAWkD2WIZKXXAE6xWHmrHOeOhHJOLUqSey9nZ91v/cnfJdIg7gGPfCNk9fIROxXXOSZWHk3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=It/6RRFXpWBqe2dHLJ7zHwBSO7cBmFAT5xGbq8iJVw8=;
 b=KtHu55SPbSX/N2Z5pEe4Tb9BNYn9ZOJ3TWVhrOnUiCziRhM/Wj5vtczE/SyJ4a+9jZOtP0nezJuxeK3ri5SKNd3Vn7hB9GlFxxTnVMqLnwH264Mn6w9CP49AMBqUwkEc/uIp/ZBOBpPJa+uOE446W0e0rcamo4DvrVen9JOeyC8=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB5772.eurprd04.prod.outlook.com (20.179.9.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Thu, 5 Mar 2020 13:38:02 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2793.013; Thu, 5 Mar 2020
 13:38:01 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] fsl/fman: Use random MAC address when none is given
Thread-Topic: [PATCH v2] fsl/fman: Use random MAC address when none is given
Thread-Index: AQHV8upqMdASorYsmEyNbtgVJDAXMKg5/8gw
Date:   Thu, 5 Mar 2020 13:38:01 +0000
Message-ID: <DB8PR04MB6985F8A2EB05F426F2CF8C0AECE20@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <20200305123414.5010-1-s.hauer@pengutronix.de>
In-Reply-To: <20200305123414.5010-1-s.hauer@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ee4cf772-17da-42f3-6f07-08d7c10a6d09
x-ms-traffictypediagnostic: DB8PR04MB5772:
x-microsoft-antispam-prvs: <DB8PR04MB5772A9A9927BBFDC5D1A5AF3ECE20@DB8PR04MB5772.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:112;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(199004)(189003)(33656002)(316002)(478600001)(44832011)(110136005)(53546011)(6506007)(55016002)(71200400001)(8676002)(9686003)(81166006)(7696005)(81156014)(2906002)(26005)(186003)(64756008)(66556008)(86362001)(76116006)(66476007)(66946007)(66446008)(52536014)(5660300002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5772;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mktH4tUdvzl6a9UdJkgbfEcJsIlku83vRyaRUVdrPI28z41nEC5o2gqraokALwY6HKXZJ/gAf5kbC2oCwJHR+sdiRqQg3E0Tw993QjYzffYitmaVkK6CI9snL+3b5BgZHRNit5l8LGM4pufwnASdmY7eIff+e+C/Cd4MfmMKxL3N3aozQ6hwy69+yhcvOwRrFOBkfSm0LlUsj0sBy/h4WqyuBHV+yPUgvx7/JMtkm+nDfHMrEV09jdq9izeDbkv6q3oLc+2O9kM3l98PrL+nBnVNOSXF2xlOqyJrf9X8Wet1Uoq9W2RSta9CufDxNxN5rWamyY7uUUrnl7Ssf45/niDLSHHoLEkusk8D/n3F68fQCkFEp8Eib+py+u0FEmBnVAYOb0ipXPakfL848P3Fi5j+kmvYyFM4gP1xz00jSwZnqRmudrllUsa5oZOiNuGr
x-ms-exchange-antispam-messagedata: 4MCv9gwk7X1ReQcP6vhYmt9N5ovQsXycNTtrQEjxwEGppW6iaFrRVpQw6IRZ/mJlh8o9npNxDJ68KJUGUdUvS8icYuxnGalDDpnIYl7TlAW5p1aMDcvQmsG+qd6yvaaqRlZ/4pMdSJt8B8LmbFGS3g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee4cf772-17da-42f3-6f07-08d7c10a6d09
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 13:38:01.8865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: imHGai5e0xitP8mgxGNdKukoRsMWOu4G1liX/PQJ2KE7k473mqkL2qSvVCFb7enLxlOv5P1ymKRLGQ9xEVHnBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5772
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Thursday, March 5, 2020 2:34 PM
> To: netdev@vger.kernel.org
> Cc: Madalin Bucur <madalin.bucur@nxp.com>; Sascha Hauer
> <s.hauer@pengutronix.de>
> Subject: [PATCH v2] fsl/fman: Use random MAC address when none is given
>=20
> There's no need to fail probing when no MAC address is given in the
> device tree, just use a random MAC address.
>=20
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>=20
> Changes since v1:
> - Remove printing of permanent MAC address
>=20
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 11 +++++++++--
>  drivers/net/ethernet/freescale/fman/fman_memac.c |  4 ----
>  drivers/net/ethernet/freescale/fman/mac.c        | 10 ++--------
>  3 files changed, 11 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index fd93d542f497..fc117eab788d 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -233,8 +233,15 @@ static int dpaa_netdev_init(struct net_device
> *net_dev,
>  	net_dev->features |=3D net_dev->hw_features;
>  	net_dev->vlan_features =3D net_dev->features;
>=20
> -	memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
> -	memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
> +	if (is_valid_ether_addr(mac_addr)) {
> +		dev_info(dev, "FMan MAC address: %pM\n", mac_addr);
> +		memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
> +		memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
> +	} else {
> +		eth_hw_addr_random(net_dev);
> +		dev_info(dev, "Using random MAC address: %pM\n",
> +			 net_dev->dev_addr);
> +	}

To make the HW MAC aware of the new random address you set in the dpaa_eth,
you also need to call mac_dev->change_addr() after eth_hw_addr_random(), li=
ke
it's done in dpaa_set_mac_address():

        err =3D mac_dev->change_addr(mac_dev->fman_mac,
                                   (enet_addr_t *)net_dev->dev_addr);

This will write the new MAC address in the MAC HW registers.

>=20
>  	net_dev->ethtool_ops =3D &dpaa_ethtool_ops;
>=20
> diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c
> b/drivers/net/ethernet/freescale/fman/fman_memac.c
> index e1901874c19f..9e2372688405 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> @@ -596,10 +596,6 @@ static void setup_sgmii_internal_phy_base_x(struct
> fman_mac *memac)
>=20
>  static int check_init_parameters(struct fman_mac *memac)
>  {
> -	if (memac->addr =3D=3D 0) {
> -		pr_err("Ethernet MAC must have a valid MAC address\n");
> -		return -EINVAL;
> -	}
>  	if (!memac->exception_cb) {
>  		pr_err("Uninitialized exception handler\n");
>  		return -EINVAL;
> diff --git a/drivers/net/ethernet/freescale/fman/mac.c
> b/drivers/net/ethernet/freescale/fman/mac.c
> index 55f2122c3217..9de76bc4ebde 100644
> --- a/drivers/net/ethernet/freescale/fman/mac.c
> +++ b/drivers/net/ethernet/freescale/fman/mac.c
> @@ -724,12 +724,8 @@ static int mac_probe(struct platform_device
> *_of_dev)
>=20
>  	/* Get the MAC address */
>  	mac_addr =3D of_get_mac_address(mac_node);
> -	if (IS_ERR(mac_addr)) {
> -		dev_err(dev, "of_get_mac_address(%pOF) failed\n", mac_node);
> -		err =3D -EINVAL;
> -		goto _return_of_get_parent;
> -	}
> -	ether_addr_copy(mac_dev->addr, mac_addr);
> +	if (!IS_ERR(mac_addr))
> +		ether_addr_copy(mac_dev->addr, mac_addr);
>=20
>  	/* Get the port handles */
>  	nph =3D of_count_phandle_with_args(mac_node, "fsl,fman-ports", NULL);
> @@ -855,8 +851,6 @@ static int mac_probe(struct platform_device *_of_dev)
>  	if (err < 0)
>  		dev_err(dev, "fman_set_mac_active_pause() =3D %d\n", err);
>=20
> -	dev_info(dev, "FMan MAC address: %pM\n", mac_dev->addr);
> -
>  	priv->eth_dev =3D dpaa_eth_add_device(fman_id, mac_dev);
>  	if (IS_ERR(priv->eth_dev)) {
>  		dev_err(dev, "failed to add Ethernet platform device for MAC
> %d\n",
> --
> 2.25.1

