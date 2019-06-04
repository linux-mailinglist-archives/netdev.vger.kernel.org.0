Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8620A33D9D
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFDDvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:51:39 -0400
Received: from mail-eopbgr40087.outbound.protection.outlook.com ([40.107.4.87]:25161
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726136AbfFDDvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 23:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzhBqUo/9gQFT3b4LHBQs5KscE0wyqiwhkyy2OOluPk=;
 b=W1aejA7DECMizVIDkZ/uyHJCjIWY5VOGpmNXAfexNDbF0Abw9fjz2/pziqxRQMPQ0QHJkidZOuof0mWVnpxNP85RDL+83sx9RzJrD6yTVVkhGT3l4Zz+SHwkCRGcaYx2/2jObdKhslxBsLNjYsoqKl5Rv8TyOjxG6v0kEsOyoxU=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3550.eurprd04.prod.outlook.com (52.134.4.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.21; Tue, 4 Jun 2019 03:51:36 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::4c3e:205:bec9:54ef%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 03:51:36 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH net-next v2 2/2] net: fec_ptp: Use dev_err() instead
 of pr_err()
Thread-Topic: [EXT] [PATCH net-next v2 2/2] net: fec_ptp: Use dev_err()
 instead of pr_err()
Thread-Index: AQHVGoJPpZKhhcZuZ0W5GXLSIKnetqaK3BJw
Date:   Tue, 4 Jun 2019 03:51:36 +0000
Message-ID: <VI1PR0402MB3600D120E0CB743F67063F52FF150@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20190604030445.21994-1-festevam@gmail.com>
 <20190604030445.21994-2-festevam@gmail.com>
In-Reply-To: <20190604030445.21994-2-festevam@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: baaba4c7-6727-4c6b-43ab-08d6e89ff11c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3550;
x-ms-traffictypediagnostic: VI1PR0402MB3550:
x-microsoft-antispam-prvs: <VI1PR0402MB3550C0FA35A2BBD4BC9339A3FF150@VI1PR0402MB3550.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(396003)(346002)(376002)(189003)(199004)(9686003)(11346002)(71190400001)(71200400001)(305945005)(55016002)(2906002)(14454004)(478600001)(76116006)(73956011)(186003)(6436002)(229853002)(26005)(476003)(74316002)(7736002)(3846002)(6116002)(110136005)(486006)(64756008)(66446008)(66556008)(99286004)(66476007)(7696005)(81156014)(6506007)(86362001)(81166006)(68736007)(66946007)(4326008)(33656002)(446003)(14444005)(102836004)(316002)(6246003)(8936002)(25786009)(5660300002)(52536014)(66066001)(53936002)(76176011)(8676002)(2501003)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3550;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5HQ82tR+5JJKotLGeHtkpLAzccERn9/E13sQyqDz9Dhz+qrScfoDDwdvSB+g8hRHYBID3Inf2gKasWhQhChFNoAmgOJsg9y0nbzFn/9pCWOaggQbuKy0TyNcg7sozbTJA4BGu7y0ptjzriZMMcHFGVHXTmxW4fGwA50TEoAfz4TO2icL9S385kQCprmwDW0A3c1bJX9lrXn3DF1HfNhBFKnKCXbzcbCbiPLqD690G0VLDih3k0dqPXDfwLGZ0mkHPCO8+gfXkyWFAS1ATDx7paGiBK3nYR8q4YfAd4bn0t8uuWhNkrzS973dvuPtnadm+wAaJZNk8tQqaSRybhDrTZ6oFrStMTcYFMYh2vkWaPQwFigcPU/LnzUPGBHf0i7QHT7XF6sfYJPF5OLfGI+t/9TrNPdpQt8Tg6+z8hYLGl8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baaba4c7-6727-4c6b-43ab-08d6e89ff11c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 03:51:36.1149
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
> dev_err() is more appropriate for printing error messages inside drivers,=
 so
> switch to dev_err().
>=20
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
> Changes since v1:
> - Use dev_err() instead of netdev_err() - Andy
>=20
>  drivers/net/ethernet/freescale/fec_ptp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
> b/drivers/net/ethernet/freescale/fec_ptp.c
> index 7e892b1cbd3d..19e2365be7d8 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -617,7 +617,7 @@ void fec_ptp_init(struct platform_device *pdev, int
> irq_idx)
>         fep->ptp_clock =3D ptp_clock_register(&fep->ptp_caps, &pdev->dev)=
;
>         if (IS_ERR(fep->ptp_clock)) {
>                 fep->ptp_clock =3D NULL;
> -               pr_err("ptp_clock_register failed\n");
> +               dev_err(&pdev->dev, "ptp_clock_register failed\n");
>         }
>=20
>         schedule_delayed_work(&fep->time_keep, HZ);
> --
> 2.17.1

