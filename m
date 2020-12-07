Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762F52D1461
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 16:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgLGPFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 10:05:48 -0500
Received: from mail-eopbgr80040.outbound.protection.outlook.com ([40.107.8.40]:13378
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726137AbgLGPFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 10:05:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YovY+gCEJUkTJ9BOMEqcfnVRNJS5FsRP/B+fz95gvKkw7xHQLiljv84zJqnDIqUgYH5G9JH5qX7SpU8AMtQ+7joXUN8tEOcGhLdKfKIdNWypjEZkv8x0jXQh/ihxVaZ7s/Yvu+JpTjJKuWjI6OsibiBxStqM5JO2vLAF8qfrj4N+DzfMI8y5LUkQip/KsNoQtSY2AKJMTTJR7XMFHg3KZx0DacFrPvfC67GpV5NhHyzlBKjZPGWqb7NT7PVpnBX9YEZz00Uhx40HzQpdk3yGO2rjPMDUg4eT4GTd8gJq+SB9PMdeIHC+bA9XV1WE8oukyF0L6BAuswHTVlDIblHX2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuDCAMjjN2nce9RaiSKTDzQ8Ow8KIe2pAyCuBuDlSis=;
 b=IEutgZuA7VFq0dA/ORubfe4kRepONG4Tw83vr9nAuY1EdWRKISmJwUrtw6MyeCeheGqBROkpGREj4thXKeSVPhhIcbsm5hTkRZi+Tn5H8hcz/lVidNIw5ng0cZYBVY3WITfULjLQ9CzRCrjnPyV2fWNsHE2jfZYyU3qXOSOB3D1DUbEfUk7pqvGDm1SHXkldjUwzk0k+m1Oft6ReRzfEWRJT3gw8qxEk1EK2izdD8iBe8mOY/eXvpeNTEIUGw7S2ljAheClPa6RzUJ2ZZslGeLT8yAl1LkucTehkihkz0sv3bMRaYRWJ44UYohEvGyfI7wHo1yKPlri0PlXikJtSDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuDCAMjjN2nce9RaiSKTDzQ8Ow8KIe2pAyCuBuDlSis=;
 b=EVPqv2ZKCKn+nEmj+1C3a2sHzG4Pq0MkFPh2OmI6w9uWOHHsnrc+27WSj1RK5gQdqHgojp0jR6DTg9h87Iw8ejpYYVeCGXEMiGSxEMwnlCqm6vOZKHBHdBDdJOb4lk+iw03wactBm0TsltCkkvWsOitz5miQB/zwS75PgnwgVGY=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0401MB2416.eurprd04.prod.outlook.com
 (2603:10a6:800:24::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Mon, 7 Dec
 2020 15:04:59 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 15:04:59 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
CC:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] dpaa2-mac: Add a missing of_node_put after
 of_device_is_available
Thread-Topic: [PATCH] dpaa2-mac: Add a missing of_node_put after
 of_device_is_available
Thread-Index: AQHWy+Jn/I5MrlaSLUGeex0+/qP6F6nrvOKA
Date:   Mon, 7 Dec 2020 15:04:58 +0000
Message-ID: <20201207150457.arjw5geu2k6h2h2u@skbuf>
References: <20201206151339.44306-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20201206151339.44306-1-christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f07a9238-741f-466a-b23d-08d89ac17737
x-ms-traffictypediagnostic: VI1PR0401MB2416:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2416253065A47047C8D03471E0CE0@VI1PR0401MB2416.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g0OiKrSkMvV10uZ7LvaaXHR2BO9HqYaIMB84eri0fzBRvVOtab/K7G9szYqVE4i88XApsBh5wvUJHHCkhCTmyf4I+kI3RHaRVLdrVSolhjbl33GzErNrshvvoW1/uTEcIv3qtNESo17Z5lFdCBuUtpcmk0X52uguD/4DwVNF7XdI1Z0z9ryBU2BQLRmJCfY3DVCS9x4Qhdxv+uTVPGhHFN3m9I4xEKfkfru4jvZtlF+TEQLXFQdHeN5W8Yqq91JscTUilQM4tMQIHBtAUrx3M5WDK0Bzj/+U9NSBTIg5D30utiEpVVs+6AqAOKIdlL8J
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(64756008)(6916009)(6506007)(2906002)(33716001)(86362001)(91956017)(316002)(8676002)(8936002)(66446008)(66946007)(66476007)(6486002)(44832011)(54906003)(66556008)(478600001)(186003)(9686003)(6512007)(5660300002)(71200400001)(4744005)(76116006)(1076003)(4326008)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?g2+vYP7hDn4kQCwbCCx9OkBeUEyAv0t3YchrwHy3M7wvexMR0FkUrxt4fRMD?=
 =?us-ascii?Q?b9iTmFHUArLG5o50hExcX0rkL+tQAw0DVpPihqxRV8YITTadXVTr2z/kKFQe?=
 =?us-ascii?Q?N+5CSqtc5MJXN7KD0hZsP+Ib4pZ49OWhZWkLDpvX1Hqm3k7yabefNMTibCPZ?=
 =?us-ascii?Q?Ee8dEucoX0//x57ynw7Gd3TN3FzUXNDmPQrvwYde8kiVqsmfllXpXj56lxx/?=
 =?us-ascii?Q?2cYDR8z9XIYmEd1YHnV+Eo+qhciN1OSrxNJPmbmz2lkrdknqNl8Rcnw8N05g?=
 =?us-ascii?Q?DVZbWgGQVML/GjdndKXbfQC8OTTChNJnUUX+aUCvDGwR+Y+aeMHM9+qj8tBf?=
 =?us-ascii?Q?pN7aDM0OYl+WMT9i1arnKhNinB062zK2Aswg90nXAM1isYJOtyzcuXmy2hkw?=
 =?us-ascii?Q?dPzx1f92eV0OOrLk59ExAHzIwyFVTWUqLZDjQw/lp6WfMU3h3zw72eevGKh0?=
 =?us-ascii?Q?GR3lQFP0drBwzKGlWJXaLUvTM36K0ou6r5jjBmPv9zbyG14WoQHfu12H3EIb?=
 =?us-ascii?Q?gM2MqAAj2gEqWFFwXYvoTqD+6DXXxB7tyFDUBueWpUAXZBKxapWbSjl/aQL1?=
 =?us-ascii?Q?gCNqaMP8DLEO8q+urFOMv3fe6aCbINImqOjxTA4TkVlGpEnumvrdKt6ip89e?=
 =?us-ascii?Q?BIjwe+ZeP4XLUFfqaOrSPiQpcuEtrhLivUI4SCtXtTawNzWzDb/PBLYivDgB?=
 =?us-ascii?Q?8xrS+ssf2d5k4iF+yQXbenwXexT6n5wet2E+gvxmhVhLIixrLINvr9k/AhJs?=
 =?us-ascii?Q?FlrRK9WoetfZaWOo5yCmoU0jDKakA5sVWkM/hFlUyz5OFgIMti0CzXJXBB29?=
 =?us-ascii?Q?sWWudQ4hz/2oqBPvMzqaXMSF9ltfWpDVoy2DH5AO8YESZUk9vdq8iy0a8vOP?=
 =?us-ascii?Q?6pgDINAMgNB/4OQ5c37+dMVs9mBP6CuhE19b6qLoQuSwg0MHSge3N2QoRGVt?=
 =?us-ascii?Q?4LUA/JRu6rGMIKiviuYOpzqkQdHKO0yWZFDIZKOFr07WjA9mYgrbYQm0qh8c?=
 =?us-ascii?Q?dgC6?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <279721FE3A822941851595031090C82F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f07a9238-741f-466a-b23d-08d89ac17737
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 15:04:59.0700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cNX2IcB4SHNO/5C9Mvb+b+R003WEuIWpFcPxz9ArGYQhb5Q300n/KMUaAGCPQmM+uYzbRTw6vJAm6tN0vTHWCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2416
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 06, 2020 at 04:13:39PM +0100, Christophe JAILLET wrote:
> Add an 'of_node_put()' call when a tested device node is not available.
>=20
> Fixes:94ae899b2096 ("dpaa2-mac: add PCS support through the Lynx module")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>


Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Thanks!

> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 90cd243070d7..828c177df03d 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -269,6 +269,7 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
> =20
>  	if (!of_device_is_available(node)) {
>  		netdev_err(mac->net_dev, "pcs-handle node not available\n");
> +		of_node_put(node);
>  		return -ENODEV;
>  	}
> =20
> --=20
> 2.27.0
> =
