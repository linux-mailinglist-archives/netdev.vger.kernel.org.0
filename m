Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D5733DA1
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFDDzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:55:10 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:2654
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726136AbfFDDzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 23:55:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpP388YuLV7gu3A5NPVXe61z889jcmX5W5rGMVGl6A0=;
 b=KBDD0avJYLPJ+VG+6nVR8ynKPoKLZ1OFCvTlvrc9qZPSAYoi0+ZSLTF7OMuHWpbkQIL2/O/Px+J1Jv1auVdNgbrL9BmjGx9WbjA+Bu0cc/qs7zm0Y46pW+agOlgwbrEyukpgBWyhsQY6BVNySHN2baJF3f5IJH48sXwQvjsN6C0=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3550.eurprd04.prod.outlook.com (52.134.4.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.21; Tue, 4 Jun 2019 03:55:07 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 03:55:07 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH net-next v2 1/2] net: fec_main: Use netdev_err()
 instead of pr_err()
Thread-Topic: [EXT] [PATCH net-next v2 1/2] net: fec_main: Use netdev_err()
 instead of pr_err()
Thread-Index: AQHVGoJNph8/XB2twEuE/oTywEUc+KaK3QkA
Date:   Tue, 4 Jun 2019 03:55:07 +0000
Message-ID: <VI1PR0402MB36004F96D79358F7EFFE0EB6FF150@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20190604030445.21994-1-festevam@gmail.com>
In-Reply-To: <20190604030445.21994-1-festevam@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bd3e067-3078-4484-4a16-08d6e8a06ee4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3550;
x-ms-traffictypediagnostic: VI1PR0402MB3550:
x-microsoft-antispam-prvs: <VI1PR0402MB355095417A44A5182093BDA3FF150@VI1PR0402MB3550.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(136003)(39860400002)(366004)(346002)(199004)(189003)(316002)(102836004)(6246003)(446003)(33656002)(14444005)(8936002)(7696005)(66446008)(66476007)(99286004)(66556008)(68736007)(81166006)(86362001)(4326008)(66946007)(6506007)(81156014)(25786009)(76176011)(52536014)(53936002)(66066001)(256004)(64756008)(2501003)(8676002)(5660300002)(478600001)(14454004)(71200400001)(71190400001)(9686003)(11346002)(55016002)(2906002)(305945005)(476003)(26005)(3846002)(486006)(110136005)(6116002)(74316002)(7736002)(186003)(76116006)(73956011)(6436002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3550;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UoAHoEYkmXd63RGiKmoitPPVcBHWsYiV3iqoz7Xjpk7xmDtnfDmgOk4SImRifWqnG1uQP0gGLlU51Agf/txx1xCoqDwTowSTe0Dc5/aebwVw7eRDa1Riw9zIPzx9QQOE6XHS+LzsgGryiToX9YrZJlFufLa1H6TRaHZ9VY5FQ8LcOkXWqDXuPh2Ar5V/Wp6E7pOtqgSz0cvB9zzY1CiNLmMTCuyKeTsG3nOrOZJB0d2XuIbE90OCn4pnWoTCAsR76340GrhnIeGxQdPfWd8LaqNzGuL/4J5cXz9h2tit7uY7N15p+ZJPCBl4Kxgp/Ifgt6Z+0BkZ/mYJpM20hwfzU7kyWW3yE3RaaesldX64Wrcsd3T+Mq+SEcLxw24TN40iVML3EdzDNO+xXB2toFTaLkiJJz9X+Ik4/8OApDMk97o=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd3e067-3078-4484-4a16-08d6e8a06ee4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 03:55:07.1260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fugang.duan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com> Sent: Tuesday, June 4, 2019 11:05 =
AM
> netdev_err() is more appropriate for printing error messages inside netwo=
rk
> drivers, so switch to netdev_err().
>=20
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
> Changes since v1:
> - Split the changes from fec_main and fec_ptp in two different patches
>=20
>  drivers/net/ethernet/freescale/fec_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 848defa33d3a..4ec9733a88d5 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2452,24 +2452,24 @@ fec_enet_set_coalesce(struct net_device *ndev,
> struct ethtool_coalesce *ec)
>                 return -EOPNOTSUPP;
>=20
>         if (ec->rx_max_coalesced_frames > 255) {
> -               pr_err("Rx coalesced frames exceed hardware
> limitation\n");
> +               netdev_err(ndev, "Rx coalesced frames exceed hardware
> + limitation\n");

The API still can be called before .register_netdev(), which means ndev is =
uninitialized.
>                 return -EINVAL;
>         }
>=20
>         if (ec->tx_max_coalesced_frames > 255) {
> -               pr_err("Tx coalesced frame exceed hardware
> limitation\n");
> +               netdev_err(ndev, "Tx coalesced frame exceed hardware
> + limitation\n");
>                 return -EINVAL;
>         }
>=20
>         cycle =3D fec_enet_us_to_itr_clock(ndev, fep->rx_time_itr);
>         if (cycle > 0xFFFF) {
> -               pr_err("Rx coalesced usec exceed hardware
> limitation\n");
> +               netdev_err(ndev, "Rx coalesced usec exceed hardware
> + limitation\n");
>                 return -EINVAL;
>         }
>=20
>         cycle =3D fec_enet_us_to_itr_clock(ndev, fep->tx_time_itr);
>         if (cycle > 0xFFFF) {
> -               pr_err("Rx coalesced usec exceed hardware
> limitation\n");
> +               netdev_err(ndev, "Rx coalesced usec exceed hardware
> + limitation\n");
>                 return -EINVAL;
>         }
>=20
> --
> 2.17.1

