Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9442DC713
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388352AbgLPT03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:26:29 -0500
Received: from mail-eopbgr150081.outbound.protection.outlook.com ([40.107.15.81]:32635
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388351AbgLPT02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:26:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EuQX7Me5btryeEddlCNOClHNK7pWV9e8OC6ZHFl+y6ry1nSiKvDyZE70H5Fj6KxIl0+vXBD8wqB0pwGDB1VtVnCABWc4cuzvCvRaJE8zNUBMQRcKNWRhJSjzOJvNj5C2lNGjPVqs1Jc+41Ba0ut5eINYyWWOkwYVE1TEg7htW2vf/GS+82aqDIe/FJdeKcwZ9tbO6A7pbGF/hfC7njJHOV2vZsUby/KRLEuO3IymUjD8LdiA++VwpGLdm/e50iiMHIyQZ6kr8pWlFmOhOueXY2eNDbDt+jDUqxjp8RxnXCy0wkOCqijXDTTNk/1osKYR8wxq+/Fxh4UEGUG8TUc32A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucf+3WLK0/8z2OeuZKgABbRTvYHgWGkRIWuuEEI20rU=;
 b=cKLKueOm0Tus/FvGyn3vP2YeB1APc+kZcU85qMazAaGHR1lZJcLLcjCkNT62LOWh16vrJlMFXxg3GYG6II8lrfYiAdjlLbFk3N3UAv5OVEMWEK0s9yO8+Pwsl/40VSYCq4fgmFZQDiOTac/KOgCRq7NMX37a8g/s6eMPRrNblg0WTPkNrnz3ixp4rAIDJd8leynSFODMXufQyxV2NXTnyCJrFG+Ul15NiMVzETIo9cQX5tjZYiuzwISKrgenwuaUYt/6gJKPKbRQny614MCXY8IYmmlsoD/XJfJB1p126ZSa4cd+04J/itSpDL4T9aYFNLYnolGzv+M4WwuUXgHtQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucf+3WLK0/8z2OeuZKgABbRTvYHgWGkRIWuuEEI20rU=;
 b=XvD9LHVNJdnxHegHsHtkOM/VTjhiIGibq2U6VuI91qylVjl9sMdDEqaa9ofXmztW9HOSouxBLYkbzdldn3yVOspqc575sXutxdih673oWrgkLuk4FkKp7gNOyUyWohGzL8DJq8nLgABvRcUh8kfyrPAGlBpjHSpjWc3OtyOXfOE=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 19:25:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 19:25:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: Re: [PATCH net-next 0/4] enetc: code cleanups
Thread-Topic: [PATCH net-next 0/4] enetc: code cleanups
Thread-Index: AQHW0yhbkCOEYv81202yMiMrv5IOLqn6HCiA
Date:   Wed, 16 Dec 2020 19:25:40 +0000
Message-ID: <20201216192539.3xfxmhpejrmayfge@skbuf>
References: <20201215212200.30915-1-michael@walle.cc>
In-Reply-To: <20201215212200.30915-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d243c90b-48ac-47f9-678a-08d8a1f85fbc
x-ms-traffictypediagnostic: VE1PR04MB6637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB663761CE080EFE5349C5B103E0C50@VE1PR04MB6637.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2vnXRuBGRvx6Y09RGusHOzrzFk4PvCHsSAQJgP8hgyvCQOPIOehefehaTV4mMVaWERXlCUe3KL4TUaCvWnR27uVP6vlID3h4EvGx8Mo60lP/JGCT0lvi/py++yd96mWD51O9dMoDuhVi0/e3P8Ig4v4y8kn6/sazUq+WNibZisXGzy3zZV1YNbEsD/LqKpBa6zvpOuBMRy20jLIfpY2ziYayL80OJ7vVSVknillqHwL7mHKh+s9t7qDXXWYqiIsYHLpWa3P3wV8VQj0Wt+WC9xQwVuQcva3+P1ZuDR6bvOvfjJfqAUIxtabBlpoVgG40
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(91956017)(86362001)(1076003)(76116006)(498600001)(558084003)(54906003)(2906002)(186003)(71200400001)(26005)(4326008)(5660300002)(6506007)(6486002)(33716001)(6916009)(44832011)(6512007)(8936002)(9686003)(66476007)(64756008)(66446008)(66946007)(66556008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hm/o+epkSAOmiZ1kRhu9FZPQMQ/voSClWJvcxd5us0w3VtzooWPP6XVxVc6g?=
 =?us-ascii?Q?PM3u+Mi0zz4jjROy+SFeX/m0W0BUh/CILwRL3QBb9cndHs9UxZSStFCumQLC?=
 =?us-ascii?Q?riB7oyvJoctVSS2ANEHTq86D3Mad3eGXKE3YpS2BTt66WRJSTOYU7HsXrg3h?=
 =?us-ascii?Q?/dF/7+/hdTyTAXPq0R07+OG748m0eQaQ/UaTq25LEHfF1/Wa4780Yhmsz+ak?=
 =?us-ascii?Q?luhrFb0qwFe5bpjuD0P3rGRzATKAyod6s4Bp3lREC7yrylPY3JOKTz3by8NQ?=
 =?us-ascii?Q?Tls+So8qtC0KB6rzUZn/B3ITE++rtUKX7slNzoOiAkazKNMKI7WTQiQZ2qKz?=
 =?us-ascii?Q?OMcMGXCBIo+HOqGMw6b3U5mMqKQdkxVIO9/jWA0fR6yNrJVa5unoQyyHMlt9?=
 =?us-ascii?Q?/7mkrYCBiS3/fDYSA0lJi3Yg1xweaX0B160mxhZIhRVnWr/UMTTXkwBo9Vef?=
 =?us-ascii?Q?xLBnMmOH15t8rI78kdcqi2VrhrjsOraf+H40WVJwmCSlJ+qfcT5s0pO1kMFy?=
 =?us-ascii?Q?Zm8L5oWz04IqzW65b5El7sbkcw5d9SPEmyNV1tR7q8yQ80MAWwx0Qk8ia9/h?=
 =?us-ascii?Q?GMpVstVxEcGxH8Y5IM36zBy4rmKywmAoUlw665HHGmb9K18dd34IGaZpsmol?=
 =?us-ascii?Q?N/Y3nnOTNt/Dy5ChHkCVbyVLF1k0W/ofqRoi03G9Ll8Mk1geXza5gXS1HMJJ?=
 =?us-ascii?Q?LxuyyjYW3QPAUYLo84i3oRbjkzTduVLTDcbzBBiqTtPFH07vbkQ/4JiOATzi?=
 =?us-ascii?Q?XAtN6lwMdbRanrRqv5bzVewbfH5iE/N+0mJ3fdZnAvcR1ZqkY1YMH9OfkPbd?=
 =?us-ascii?Q?uDD43qKE5dOI3t7uIUhJVtqGu81sJxc5W5MlQ88yrXILEMq2/e1mEOUaut0Q?=
 =?us-ascii?Q?TXKigz/ofnWvkXpKZoVLKnYASBX9zsBIuGpRhs9oKXkt9jf5qR+TBjdvTYhf?=
 =?us-ascii?Q?j2EIiZQ6DkEeDmDWnsAVD3ABu1VVph00P/KnB7G7/foawPZEJY6NXkmajCIx?=
 =?us-ascii?Q?OU81?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6EFB0DF061BAC4B81ED2A1C9D1565D9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d243c90b-48ac-47f9-678a-08d8a1f85fbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 19:25:40.2429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wSGnfAqOXXRG78SGErWYs3stU2uvBC+m7zRAfFPcdJre7pyMBkm35UKUm0eq9RRK3r+PGHvSvgYWY2+Hk+2Omg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Tue, Dec 15, 2020 at 10:21:56PM +0100, Michael Walle wrote:
> This are some code cleanups in the MDIO part of the enetc. They are
> intended to make the code more readable.

Nice cleanup, please resend it after net-next opens again.=
