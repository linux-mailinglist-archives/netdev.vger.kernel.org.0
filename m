Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927A317A4AD
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 12:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgCEL5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 06:57:40 -0500
Received: from mail-am6eur05on2052.outbound.protection.outlook.com ([40.107.22.52]:59168
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbgCEL5k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 06:57:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGewu2tLlu0mjUsjtM1ys95626CbFk3n1UIex83RR9zTh8mk0BXuzIkrkv9t0GmU8rAR28rTwr+cBsfdyUI+R5jhLDFl09OCGWbc2qfP++IeXDz1OrxHbQDG8xxJIrgmE4jBWcthXghLbS1Qp+ZqvdXw2UOwuAqf4ratZLkpiz1r8FHFUj9dlg0ujHrwEP1wXgja+wi1cIlN7SBosyNnmGjk2rFVdDmpZkdHn5EzVPZYsIcrJpqgJpiJN9srbja8CmzNC0BFmG2tWW35Yrd5ciBsSWGzT4OcphiL/UItZPKlngYU/f8j9rPOVEZuMlFAaYdnJrjnEy7tvDvHQQOTGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vK/Ad4qHppnfpqJ6QSNWamaUUw9gb6iXRTXQVWIMOC4=;
 b=Je4QLUOwGb7sJFHnSAAisQTXoDaZCXQGNYiMMutih0TJSTVCR/EQQw7Ie173R+hbJilgbPuLRUbce0x3CYzP6yQyZwzJ1DHFpae/Z8iSRPnmHnv3HX6VG/4uHaOSEHeg9ToZy6dmROo9RWsAE8Z5TzA8Ck6UwUmSxtZ/5rZWI4oWgUtxVM77BtbiOginEvUuBcbDzWqln4fnF1fi05x+YJVLd3XhRBiNQYO5VqvnkXenuAS+evbu8KpN/z8W80D9SgGAiMf6pboa00RsmP/cCe0gKWLTzT2uHn3WWIc+QRNNLWmA/jwTxQxr6pZ9k5uWTKQZHvmv4GST3C3ZnNMh3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vK/Ad4qHppnfpqJ6QSNWamaUUw9gb6iXRTXQVWIMOC4=;
 b=jlOMqmSQHtUHokiVBaHlSaIuEhjMnIgTF5eVMNBZiwD6AftGi65AYipiJZ1Polered/40JkbbaLH166kaJyZG/FIf8WtLvrrnXtIxxjq6UoMcukybwBrH/57HyrRm2SyTAkJ2QFZzMek+8BFbT5gTROpn/0pis/mHoe3LDms5bw=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6844.eurprd04.prod.outlook.com (52.133.240.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Thu, 5 Mar 2020 11:57:37 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2793.013; Thu, 5 Mar 2020
 11:57:37 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] fsl/fman: Use random MAC address when none is given
Thread-Topic: [PATCH] fsl/fman: Use random MAC address when none is given
Thread-Index: AQHV8uSyRdQkC86eTU+/EfbbgCHE7Kg55Hjg
Date:   Thu, 5 Mar 2020 11:57:37 +0000
Message-ID: <DB8PR04MB6985D1FDADE301F4A6C795E3ECE20@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <20200305115330.17433-1-s.hauer@pengutronix.de>
In-Reply-To: <20200305115330.17433-1-s.hauer@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6bace020-f492-4d1f-358c-08d7c0fc660b
x-ms-traffictypediagnostic: DB8PR04MB6844:
x-microsoft-antispam-prvs: <DB8PR04MB6844A88C637F1FFBBB855A19ECE20@DB8PR04MB6844.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:114;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(199004)(189003)(2906002)(110136005)(76116006)(8676002)(55016002)(81166006)(81156014)(52536014)(71200400001)(44832011)(86362001)(6506007)(53546011)(8936002)(7696005)(478600001)(186003)(26005)(9686003)(33656002)(66556008)(66946007)(64756008)(66476007)(5660300002)(66446008)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6844;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FD/LubhKmHwrg8DjiXP2X4s9zr/SF5cctMDdu4fd90TUb4hYkINJpfJx6Mc2qgs9pDGrgheK3tuO3Ian0sIgSBWs4TU7vWwhuj0UU8NnNXwJAYff0gYERAkcNyZUXwyrGedP9gLBvY7VL2Z3Ifc1V5yQGI998g/czGmbSwt/H6821kBvXPg33BZalPZA+T9pljo4JeZq8NGaDwHHD6TXk+fIy/ciDvgd5DDvWuoeT55l82ToM7a3pitgG0Wtt7tDJ8Un7x781Lhk8KFR15ceXKk+pn5I6FfHrVs/DXqS/NkkAG7Wan6eSWBIb3sPeaUYE9CdOcaHtnIH3qRp5uVRWZMlMVQ7SOgG5Oc/nuS2O4kYKm5o2E04an9jKi80An7mGmT2LDAdUrJ1VfOcGHiEVPsJApbUPscsrtbnXyUlCbnkqcCatDREGymtrlRY0G47
x-ms-exchange-antispam-messagedata: kwN1y1v0FUegyklc+jxCFt910FeqL/V+WtIJzN2bHvI/gGIxcSIOkpd731c7XuB2p7P4eAVRI5Vfu1SiXkDjBQLCJyDBuMlF9Wft3Ayz7o/vd13NEKYAaYom2aLgkj3jB3jxvn1H1tcaORsnM0eZ4g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bace020-f492-4d1f-358c-08d7c0fc660b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 11:57:37.1053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LrjHjtR7rzrJyiN3Uqr5EgKlCZVtFM+8sxOnTd79vxUnzAdnCWvPxxfcXHaOFPgg72188psvw8b68D/c7BMsLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6844
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Thursday, March 5, 2020 1:54 PM
> To: netdev@vger.kernel.org
> Cc: Madalin Bucur <madalin.bucur@nxp.com>; Sascha Hauer
> <s.hauer@pengutronix.de>
> Subject: [PATCH] fsl/fman: Use random MAC address when none is given
>=20
> There's no need to fail probing when no MAC address is given in the
> device tree, just use a random MAC address.
>=20
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 13 +++++++++++--
>  drivers/net/ethernet/freescale/fman/fman_memac.c |  4 ----
>  drivers/net/ethernet/freescale/fman/mac.c        | 10 ++--------
>  3 files changed, 13 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index fd93d542f497..18a7235af7c2 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -233,8 +233,17 @@ static int dpaa_netdev_init(struct net_device
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
> +
> +	dev_info(dev, "FMan perm MAC address: %pM\n", net_dev->perm_addr);

Do you need both prints when using a random MAC address? Otherwise, it's ok=
.

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

