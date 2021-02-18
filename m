Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFE631EAA8
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 15:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhBRN7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:59:04 -0500
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:14817
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230148AbhBRNoB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 08:44:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rv37PnvCpFCrIYwD40EK3Z+UWpLOdkuLhLR5pr5byTwUv7rqx17Yo7nVE7oROQ3kBOquGs8d9hUF5hL02MmJo7Aoi/e0gpGKigzj1NUw0sLf7+ipCcZ0e87ZuSd74Zwlsd+n2W0xn9VpcRjktNCxzBj8ILqVjGb4qh+tTpWzZtszJOF+CUKpXHsrD8fVMVK2YDrVaEzgYbtejGjzd1qVcA/FUYGTVzp2M6pywIcvJZe3HBdjqry31adb3Gr3z9PmvdMGF2mF0hghdqWHOX6fnmAgAqC585wxITjbCkM0rtbltsDqfMDI3U92knr4Sm2N5MDW2uYUl5B4b2w65Rj31w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHG4fZY97ODMjxpNVbbou443N881d9if3V7o8xx8qxs=;
 b=iWtjus18tX4c37UnSKotbpWAXXhs14BpkFRrwg3Xp8X4ChuWnoWP4HavGJ49BRVJX8DkLIVzeSVTcHpkYVGMX5zcHF8ZBw0T5s7noHihLTxRJC0louRha4I/RjT+qdit+pzc8xhicoZxflwgF5pSD//9+xwSgIDDa8jwP1JzrbXrYHqpiVvBjm+sFXfPLyxJOtPH9Hkk25KwaNyIrySap6+XFdVVQJDsFrW4T/kiB0kBzBratoS/BKzFTa/1t+sywihwBgjf5i4jYDoy6KUcHOTWDtgqsklf5HNKNRIAsofplhRHpGJ+7gIbLqa1yrHnEuhJgK+XRFburyEmnDnjKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHG4fZY97ODMjxpNVbbou443N881d9if3V7o8xx8qxs=;
 b=XjswHFBQvn+d0uSpf6PU/sarnz7a7d3qOAPkv3La4gzeZUIwzCTvClJpJuhlJ1b52I1pD21IQRmdPZLzIgp8fmQ+qP42f66o8yPdhxXyzH1Be7TxeF2kNW8W1Lj/44vnj1udE+44c+5zliow+HOlZMgk1uavdYCggmgyjRa5fNo=
Received: from AM6PR04MB5799.eurprd04.prod.outlook.com (2603:10a6:20b:a9::20)
 by AS8PR04MB7880.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Thu, 18 Feb
 2021 13:43:03 +0000
Received: from AM6PR04MB5799.eurprd04.prod.outlook.com
 ([fe80::b0f6:6642:8a2f:138]) by AM6PR04MB5799.eurprd04.prod.outlook.com
 ([fe80::b0f6:6642:8a2f:138%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 13:43:03 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: RE: [PATCH] Revert "dpaa_eth: add XDP_REDIRECT support"
Thread-Topic: [PATCH] Revert "dpaa_eth: add XDP_REDIRECT support"
Thread-Index: AQHXBUAdmLV9bIqIgUW/fpWKayVTSKpdy9IAgAAe/jA=
Date:   Thu, 18 Feb 2021 13:43:03 +0000
Message-ID: <AM6PR04MB5799205495B096E48E09536EF2859@AM6PR04MB5799.eurprd04.prod.outlook.com>
References: <20210217151758.5622-1-s.hauer@pengutronix.de>
 <20210218124240.5198dcda@carbon>
In-Reply-To: <20210218124240.5198dcda@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9d6dde96-d420-4606-b052-08d8d4131d9b
x-ms-traffictypediagnostic: AS8PR04MB7880:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AS8PR04MB788060A0F05219BB4F5D1E2AF2859@AS8PR04MB7880.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bdb+r20OiZEcn7i3iJ0Jw+/BRhvdnpWfqH0TmHreAZhXlqjWkccqou+o6kp4hUgTRnF45aiw1YEdVEuuFRuXTxvaE+ickcOOnzU4WZa/vr5lAXviVWHtpKHvvpWiGtCVAIOa9ICKl+MFewgM58sIinKd/fQaqvdGdba7sKsPmf7Ng7uP026IdFfTPEAiLVcOuzA+/IXMO33IZagrj9JoDdbwxd1PvhEr8NsTT3JzSKvx1JdEHiTLs7yzo+RcAUNzISBSf1oyg+XAHQIyOR1kuIi5xhx6N8HTQz8GxCYVTn58V9CsLNa66DnA5UPG8A7kWG5JqGqRYy/opSiNAheUvTFPuLDeysBW52va27cm9qoy9ZMvK20RsbsIDE4HSmjTARB2EmN7m96dQKMSxNmSidUQMdc7/YmJyqTOR5KQFUi7JnMS/UHsPqeMeeOf2/Hjsn8zeUUI707TNbboCqdvJ1906eYlaU6l1ZjQ+UkSVegOqU7hdbjSkP7jN4q1/hBPm8PV7CQ7tWumUdNKGxvtmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(346002)(39860400002)(53546011)(55016002)(478600001)(26005)(71200400001)(2906002)(5660300002)(6506007)(33656002)(186003)(4326008)(9686003)(316002)(83380400001)(54906003)(110136005)(7696005)(52536014)(8936002)(66556008)(8676002)(64756008)(86362001)(66476007)(66946007)(66446008)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pskXdcj1amqpRr73IgWWzLRaGYKqFJkUZU/iw5/ZsTRq6DS+S7xWFnPFfksM?=
 =?us-ascii?Q?x2dZ/zVjc1qcmK1PbrJBsJlpkOAlUQlUEchJwpl964dapzNQHlr8a1H/Oq8r?=
 =?us-ascii?Q?USu/Ng2z8mPkWwYObTzgMhpNOK7/s/l/6KlwhqOZPTv1HhMayqWJSsyCbSOx?=
 =?us-ascii?Q?o/Ti1ywHi2TdT6KFES7TklWI/lqTSkO2aWZ8Gru8F+tpuUQ52ao/V3qm6QM8?=
 =?us-ascii?Q?qvlhYMfjLSY7uzw19vKy9zeFAdcc3msAb7duwR2HunmDcE1/PPQCJAE50AoG?=
 =?us-ascii?Q?wUfUkTyISDfLkFM6ANXGNIfazXVWtROUycvgYvqP6/xIP6uNflJDLnfj58lE?=
 =?us-ascii?Q?nlo+2BrorpmFilqdCMWJuhSCZ2YYzIs6kV4Y/Z7zeShjiFzcCCWaK3pzTQND?=
 =?us-ascii?Q?0rMqUnX/xWUOs2Hn761IYpk1DD/eEEwOmhu/Mr7xXF3dGPNeimGHIC4iPAPd?=
 =?us-ascii?Q?Fdky5a7tlnuHuB/lWkXCszhqGiija05bnfZoCWoJ5iFqau/yeHdJKGxX2ILp?=
 =?us-ascii?Q?gTJnZlV1dMK1/nUI751q+0RTNpOs8qS51wV4cAfz6EGdIcsfJFCBIYgtuGCU?=
 =?us-ascii?Q?BYwL4ocMNOr0B6lqntE7goL9vdjhwe3WnRZOH7Vjesl3IU3JC7QcCJMQneJV?=
 =?us-ascii?Q?Smwt4BveKAZoyc6J8Ovay3dVa/xVBecHqeOwFcJ0iSP/36ORKW+pVmd7nzLM?=
 =?us-ascii?Q?EZemzWlLREoEcOkk+szbzB/PyM7Qizhjarshy8XLLEE/9mLnQYERWeN1qsjD?=
 =?us-ascii?Q?lWn1RAhwo4vFRU7/UBQ24yH7UeHRnSqEuVaPO2Nl2O9Rj1WaccEWhWGoJKRt?=
 =?us-ascii?Q?P7emiyvZeBqAmWX69CEWP5M1be10F5o172aeKlvOqOkdlnFzBMIcLjhT6fi/?=
 =?us-ascii?Q?OG7STZS5Q7pJNfj9kswP7Zo9hpijH5pGdvVp9dePKpOpgvG0L5+nXm/s2qu8?=
 =?us-ascii?Q?IxrvnSnPxUZFmv+Q/VrgYq9F64L+yFv200ifAKuaf6JWvgWMYsCyEJtMqQHz?=
 =?us-ascii?Q?w9Zv5yIR71/TbOmkN67jUMU/m17L4ACm5ATCmwDC/N2/8fsbN8iFLfdnK+z/?=
 =?us-ascii?Q?jcO3roaMxJy7uDdb2N+qNtx9v5TCK4ff3JJ5GcKAPSAfS7GXyrNgbNdCDDfq?=
 =?us-ascii?Q?+4YAPKJ8zSzvD2Y7ZkbDHEC8MC9GJ1kyMRPWpD6DLoT3Kjst1l/a4dC5/wV/?=
 =?us-ascii?Q?TIBu4b9gQCuXShQ17OiP8C4XwG7+xwxA+K1pmUyO1GE5QxA5XXUcVJbAQ/kM?=
 =?us-ascii?Q?epa4o+TdV4BRf7q3jt9IfJjDB/ywGfqLpK4jwWIS/D52iokDbnp3m5L4PyCM?=
 =?us-ascii?Q?I5c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6dde96-d420-4606-b052-08d8d4131d9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2021 13:43:03.8435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tRySWUkw+Tw6H2qoA4jMG7uG84ajPCmfq3U9FtFOjNJOPXIA6rk5oFtnumG59omS3YghxCx1eeoG3rqCXtKcEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7880
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Sent: Thursday, February 18, 2021 13:43
> To: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: brouer@redhat.com; netdev@vger.kernel.org; Camelia Alexandra Groza
> <camelia.groza@nxp.com>; Madalin Bucur <madalin.bucur@nxp.com>;
> Jakub Kicinski <kuba@kernel.org>; kernel@pengutronix.de; Ioana Ciornei
> <ioana.ciornei@nxp.com>; Ioana Ciocoi Radulescu
> <ruxandra.radulescu@nxp.com>; Ilias Apalodimas
> <ilias.apalodimas@linaro.org>
> Subject: Re: [PATCH] Revert "dpaa_eth: add XDP_REDIRECT support"
>=20
> On Wed, 17 Feb 2021 16:17:58 +0100
> Sascha Hauer <s.hauer@pengutronix.de> wrote:
>=20
> > This reverts commit a1e031ffb422bb89df9ad9c018420d0deff7f2e3.
> >
> > This commit introduces a:
> >
> > 	np =3D container_of(&portal, struct dpaa_napi_portal, p);
> >
> > Using container_of() on the address of a pointer doesn't make sense as
> > the pointer is not embedded into the desired struct.
> >
> > KASAN complains about it like this:
> >
> > [   17.703277]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D
> > [   17.710517] BUG: KASAN: stack-out-of-bounds in
> rx_default_dqrr+0x994/0x14a0
> > [   17.717504] Read of size 4 at addr ffff0009336495fc by task systemd/=
1
> > [   17.723955]
> > [   17.725447] CPU: 0 PID: 1 Comm: systemd Not tainted 5.11.0-rc6-
> 20210204-2-00033-gfd6caa9c7514-dirty #63
> > [   17.734857] Hardware name: TQ TQMLS1046A SoM
> > [   17.742176] Call trace:
> > [   17.744621]  dump_backtrace+0x0/0x2e8
> > [   17.748298]  show_stack+0x1c/0x68
> > [   17.751622]  dump_stack+0xe8/0x14c
> > [   17.755033]  print_address_description.constprop.0+0x68/0x304
> > [   17.760794]  kasan_report+0x1d4/0x238
> > [   17.764466]  __asan_load4+0x88/0xc0
> > [   17.767962]  rx_default_dqrr+0x994/0x14a0
> > [   17.771980]  qman_p_poll_dqrr+0x254/0x278
> > [   17.776000]  dpaa_eth_poll+0x4c/0xe0
> > ...
> >
> > It's not clear to me how a the struct dpaa_napi_portal * should be
> > derived from the struct qman_portal *, so revert the patch for now.
>=20
> Can we please get a response from NXP people?
>=20
> Are you saying XDP_REDIRECT feature is completely broken on dpaa driver?
>=20
> (I only have access to dpaa2 hardware)

Hi,

Thank you for pointing out this issue. The correct fix is the following. I'=
ll send the patch for review.

As for the impact, the xdp_do_flush() call might be skipped due to this bug=
. This doesn't impact dpaa2 since the drivers are different.

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/e=
thernet/freescale/dpaa/dpaa_eth.c
index 6faa20bed488..9905caeaeee3 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2672,7 +2672,6 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struc=
t qman_portal *portal,
        u32 hash;
        u64 ns;

-       np =3D container_of(&portal, struct dpaa_napi_portal, p);
        dpaa_fq =3D container_of(fq, struct dpaa_fq, fq_base);
        fd_status =3D be32_to_cpu(fd->status);
        fd_format =3D qm_fd_get_format(fd);
@@ -2687,6 +2686,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struc=
t qman_portal *portal,

        percpu_priv =3D this_cpu_ptr(priv->percpu_priv);
        percpu_stats =3D &percpu_priv->stats;
+       np =3D &percpu_priv->np;

        if (unlikely(dpaa_eth_napi_schedule(percpu_priv, portal, sched_napi=
)))
                return qman_cb_dqrr_stop;

Regards,
Camelia
