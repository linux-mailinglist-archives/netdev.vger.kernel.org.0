Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2178F33D4E
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfFDCv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:51:28 -0400
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:57561
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726136AbfFDCv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 22:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAU5OTn4GozwLvOVebLiaDqdYC3eJbY3yuVR2RapQqc=;
 b=KeynhLb2m/V6O2vUkeMjjhZSrOv1Pj/VAkS3W8gO5CMD2+igoH+t2/DesS/+RTq35QfcQRBkvnsoHoaoaB02DfNNAhO0I5YpqW1bDO5Zf38sqoEr5SYFA1fbDCmrIFF5I6Y9a8UYvQ3y0QYg/MFP0uf5LhitmelzvdQ0h5Evro0=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2799.eurprd04.prod.outlook.com (10.175.20.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Tue, 4 Jun 2019 02:51:24 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 02:51:18 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH net-next] net: fec: Use netdev_err() instead of
 pr_err()
Thread-Topic: [EXT] [PATCH net-next] net: fec: Use netdev_err() instead of
 pr_err()
Thread-Index: AQHVGnvqDsjubSWZ2kqE+fRWm50sHKaKyctg
Date:   Tue, 4 Jun 2019 02:51:18 +0000
Message-ID: <VI1PR0402MB3600514884A873B15ADA4539FF150@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20190604021906.17163-1-festevam@gmail.com>
In-Reply-To: <20190604021906.17163-1-festevam@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c57cba7-d78c-4102-427b-08d6e89784a3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2799;
x-ms-traffictypediagnostic: VI1PR0402MB2799:
x-microsoft-antispam-prvs: <VI1PR0402MB27994DF300780E9465433BE6FF150@VI1PR0402MB2799.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(376002)(346002)(136003)(199004)(189003)(76176011)(6436002)(99286004)(71200400001)(2501003)(71190400001)(86362001)(55016002)(9686003)(53936002)(6506007)(14454004)(478600001)(102836004)(14444005)(229853002)(52536014)(5660300002)(33656002)(26005)(66066001)(7696005)(256004)(25786009)(6246003)(4326008)(73956011)(66476007)(66556008)(64756008)(66446008)(76116006)(66946007)(486006)(110136005)(186003)(68736007)(2906002)(11346002)(446003)(74316002)(476003)(3846002)(6116002)(316002)(305945005)(81156014)(8676002)(81166006)(8936002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2799;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n16GuHKxJeNM7BDPii10NMHLM+tWoFcz74NtVxw7HCx9gWn1niC9xh4A78Y096vIGfL55wQPvZ39lU0RDYnHn1K9+Ac5lN4tv4MFC3ovDUnme0aFsdNyb3fc4ho4wVts6fVPw1jiUwTxYfbjOCdIWFRAtmltt/2W2/Zfge5L2gbNXN7UdiEygiSgZ9VjEAZkVTfioBG9wsKlw1Ot/rk7Wxka3aZF4sSXaaO8l9fUhInF1bEqOet5aGENLy3hH0d+rLLHe9ccO8za/OnxKR0CbvEqoLaw+rTx2poHRu2TgUdHnHd0CS80tuPPbYT5FmenDP2f9LO2yDHGKI0om+X5dAvUdAvbcoEQlyPd1tl+PSWZOChvNJvODAfjKdDE90eip4LK5LX6Bx+dhLafbJHCBAiX8ZUbzS3vLc84fRi+lFk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c57cba7-d78c-4102-427b-08d6e89784a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 02:51:18.1592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fugang.duan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2799
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam [mailto:festevam@gmail.com]
> netdev_err() is more appropriate for printing error messages inside netwo=
rk
> drivers, so switch to netdev_err().
>=20
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 8 ++++----
> drivers/net/ethernet/freescale/fec_ptp.c  | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 848defa33d3a..887c6cde1b88 100644
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
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
> b/drivers/net/ethernet/freescale/fec_ptp.c
> index 7e892b1cbd3d..1d7ea4604b83 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -617,7 +617,7 @@ void fec_ptp_init(struct platform_device *pdev, int
> irq_idx)
>         fep->ptp_clock =3D ptp_clock_register(&fep->ptp_caps, &pdev->dev)=
;
>         if (IS_ERR(fep->ptp_clock)) {
>                 fep->ptp_clock =3D NULL;
> -               pr_err("ptp_clock_register failed\n");
> +               netdev_err(ndev, "ptp_clock_register failed\n");
Here, I suggest to use dev_err() since ndev still is not registered.
>         }
>=20
>         schedule_delayed_work(&fep->time_keep, HZ);
> --
> 2.17.1

