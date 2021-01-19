Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FC72FC1FB
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 22:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731449AbhASSsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 13:48:43 -0500
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:23905
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730106AbhASRxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 12:53:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTKYKE/b/iBAOX97FSXMGd1IKEwqxFEuH2tAvXg5s6kiLa1IY6GlETpGYNZJJxIrRpNLb2wKd/bh3lMINfo9eaXiz8aD4lvA+BuPr2o924I8ee06AMqrQlZrqkZOePqmvO6StuFFpdVUU2ha9Ymd7q16lm8YS9oqk2pBqAQYWfxLBk04v3cqb0jY0VTX8FN+yNwlYObFxHehFJjv4GkKhkqhqrfpMK23QH3x/6rIA63rYUsOOxpdPeBRDKLdpy+MLx1wJRmnHLT9Nai6LYmK7FcpAQWY3NI1zUyEtjMk/nzBjc8ifIHcPILOCmqfAY5tLTex9sD+MGxNtTzkQaXhAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+ZOnzc9z4VWeqrorUMWfPQsZmTFYIlhtcubzLr3e3U=;
 b=fCcPmjf62gaPYubsAvOI//s4EnHk9928YR+cUkY8o/QJwt9ShAASAxObcnxyBXZqH83sE/fNqLGsK3IcZZqPEKV7HiPhTeqh7eiIy7cY1QHAlNZBfUjN0bBDJWPC5qFR+aauKY3IMQqhzX+71kgAXUpjQJ9dO6+1Ank+JP2kCF2AQxHrudmW015FQ59n2AQGatMhy/N1IL7UYyJeFoh0PXA5ze8FD9x/lFbtFf8sLwbuIPfMICK4BZzeyeIHl8YGOmX47ArYDzaA7MACpzkEbDD7+Cph1rO1LoMIYl0a0ea1cMDTstbKz+QfJIkIRdZz4Gku8fDVB0YnH1LlwY9g8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+ZOnzc9z4VWeqrorUMWfPQsZmTFYIlhtcubzLr3e3U=;
 b=WewSimn40R2HZ85cAWsayLxl76HWmrLBogkEJUFnOhjFqICGLepVPGexZDUcjbN7mPxfIONU4TP35w9g0Ec3dK6LwmPfc3DJqyWzBUi+i0YYlrO/a/iNNC+xBTqOdCKEigaZHJeZp21Iq05vhPnjitULtgkej9OBrkH5Rd0ZOl8=
Received: from VE1PR04MB6687.eurprd04.prod.outlook.com (2603:10a6:803:121::30)
 by VI1PR04MB4157.eurprd04.prod.outlook.com (2603:10a6:803:46::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 17:52:31 +0000
Received: from VE1PR04MB6687.eurprd04.prod.outlook.com
 ([fe80::e9ab:4d78:5b38:aa3c]) by VE1PR04MB6687.eurprd04.prod.outlook.com
 ([fe80::e9ab:4d78:5b38:aa3c%7]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 17:52:31 +0000
From:   Leo Li <leoyang.li@nxp.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Qiang Zhao <qiang.zhao@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        "jocke@infinera.com" <joakim.tjernlund@infinera.com>
Subject: RE: [PATCH net-next v2 00/17] ucc_geth improvements
Thread-Topic: [PATCH net-next v2 00/17] ucc_geth improvements
Thread-Index: AQHW7nUGKGYqnv/Sk0GV3xsfrGpwrqovOnqQ
Date:   Tue, 19 Jan 2021 17:52:31 +0000
Message-ID: <VE1PR04MB66872D9B4C27A349099814B88FA30@VE1PR04MB6687.eurprd04.prod.outlook.com>
References: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20210119150802.19997-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: prevas.dk; dkim=none (message not signed)
 header.d=none;prevas.dk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [136.49.1.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ab3517d0-81f3-47d1-4649-08d8bca2fe93
x-ms-traffictypediagnostic: VI1PR04MB4157:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB41572D715CECA17E19E807138FA30@VI1PR04MB4157.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TIDGmKbGsHG020DskmzGnhPE+8YloIob0HiZOqIdvqI+sE9IReIJl7NqBmdkpkKy1sB6WOVcsRhV4ldw6v/4S56rzkDwdZJUG0FKAEW8mz2H6t9bEuoCXJQNHXR+qzX9GRgZD8hqQJ73xHOq46QCjIT8i95LIMcCfxlmLYC2pJT0MTGmShB51k/65RFOh1IIoseKeTOJLVVjiY0uFl4PJnpSLo6LRWMGXEL7A0uIHoqJfM0dv05fynY1rXZDl5Y4FOUL01gPMZgnYRAJYR9KItDD/aKg5ngTOwpYIzv7qH1tTrRSbHLbugX7rFQg+g4srK12Zt4gAu4Z80DGgqH91iDItkbeT3w31Tgmbj6gev4qjUWs0GzciPXA4e2CkGaMCZsV1PRoQT8aDX2gcVRnGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6687.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(5660300002)(76116006)(4326008)(33656002)(53546011)(6506007)(54906003)(66446008)(66946007)(26005)(478600001)(2906002)(66476007)(52536014)(64756008)(8676002)(66556008)(7696005)(8936002)(55016002)(110136005)(9686003)(71200400001)(83380400001)(86362001)(316002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?s8CxY+trD7nQbSuiFe85bt+ydtXBEZlo2iuRLFUiZRuXBtdwSnMtlqgT2rYN?=
 =?us-ascii?Q?kAzYYjg0lrZBldDd28VSu2D2WEE0xEo3U1ns5gae/FlT4PVYa4G54gUKC2T1?=
 =?us-ascii?Q?tzJjTJxi5fETOosmzv7DcsV0YZgDYoyC8PDRJJ6WmkSyFkiiNoHm/DJgz7Ue?=
 =?us-ascii?Q?xb/mXp159xir9JlolIIZo2i0GRDJlPLnrGPmzXgz4bUZaywD9fOzzt1qakrD?=
 =?us-ascii?Q?JcZMnS6SBe3xWEM9Xfq6xDaDRs8htiJtryAOHPa/Ud48ACgJthXQpetx+rLJ?=
 =?us-ascii?Q?M0lMB/TY1adQu4vrBZuGAor6IljUHLeHJvzGqgeaeNIy5YCAMr+QeYtFxvae?=
 =?us-ascii?Q?9F0S7KpSBYs3DTGCn5nH0QPLa45NX+2X6BHFRIer5rR99o0BDZFNzOG5Axhb?=
 =?us-ascii?Q?944r/bDmTzZGQBBWZ+fSVeiAUG9wCLNm7ScjUqkb0Pc+xJwNz/z0sn1/N3xD?=
 =?us-ascii?Q?2g/DChWhva04q7zfDNtkhO1kXbQXqgCnLXyL7LA9jRInY5Jvur5xJvtZR9ru?=
 =?us-ascii?Q?9820TM478dBV4UVns9ATFzZh8sHkx7NVUHdEvNApNQYSaMHOGHv1iGPWCCdw?=
 =?us-ascii?Q?+XRjU/YQXmA+2oVcSpQ1mIOk5DWn9Qnkxct4HluaYR50A9/sjxj6pVlaTjfg?=
 =?us-ascii?Q?6pBnJaHJAPsmVfvtcTHMr+l0BQzLJdYcDczH+QY68KCOfXalbRX7rmJbApHW?=
 =?us-ascii?Q?DZDYJ/M79ZU0QTUKPoVadSnRLOOx9GtjLFXEhmvyIkxjYAYkHWxeDUs8jfht?=
 =?us-ascii?Q?kkw00zGS7TD6kDWkxaxWb+Pts7/yPt9sa+wxY8gps9R0OHjL7RWGXsiMICC3?=
 =?us-ascii?Q?fP3e0aKzweOWmoPbw0bZfC4jL/+iSbf6p4AaRCqBzLyWZrcAZwBX6LHSvE8U?=
 =?us-ascii?Q?JgRZpDyFENtiZQ7lZ7t/5gh45T/ADfbScdfZDc1CF7/IzUHjv4EBiecPfVeX?=
 =?us-ascii?Q?9H1P+cCQenEqw5BamAYN7jlUifNcM325Hhabt/IIUsY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6687.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab3517d0-81f3-47d1-4649-08d8bca2fe93
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 17:52:31.4064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zFl3IP4jF8fZ5d8TBgoDEglqbqVPXqsJSzpRLeQ36IJipUc3Le8FG8UfXG+H+irlh0FqeDeCr2p9sCtgVFuVow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> Sent: Tuesday, January 19, 2021 9:08 AM
> To: netdev@vger.kernel.org
> Cc: Leo Li <leoyang.li@nxp.com>; David S . Miller <davem@davemloft.net>;
> Qiang Zhao <qiang.zhao@nxp.com>; Andrew Lunn <andrew@lunn.ch>;
> Christophe Leroy <christophe.leroy@csgroup.eu>; Jakub Kicinski
> <kuba@kernel.org>; jocke@infinera.com <joakim.tjernlund@infinera.com>;
> Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> Subject: [PATCH net-next v2 00/17] ucc_geth improvements
>=20
> This is a resend of some improvements to the ucc_geth driver that was
> previously sent together with bug fixes, which have by now been applied.
>=20
> Li Yang, if you don't speak up, I'm going to assume you're fine with
> 2,3,4 being taken through the net tree?

I'm fine with them going through the net tree.

>=20
> v2: rebase to net/master; address minor style issues; don't introduce a u=
se-
> after-free in patch "don't statically allocate eight ucc_geth_info".
>=20
> Rasmus Villemoes (17):
>   ethernet: ucc_geth: remove unused read of temoder field
>   soc: fsl: qe: make cpm_muram_offset take a const void* argument
>   soc: fsl: qe: store muram_vbase as a void pointer instead of u8
>   soc: fsl: qe: add cpm_muram_free_addr() helper
>   ethernet: ucc_geth: use qe_muram_free_addr()
>   ethernet: ucc_geth: remove unnecessary memset_io() calls
>   ethernet: ucc_geth: replace kmalloc+memset by kzalloc
>   ethernet: ucc_geth: remove {rx,tx}_glbl_pram_offset from struct
>     ucc_geth_private
>   ethernet: ucc_geth: factor out parsing of {rx,tx}-clock{,-name}
>     properties
>   ethernet: ucc_geth: constify ugeth_primary_info
>   ethernet: ucc_geth: don't statically allocate eight ucc_geth_info
>   ethernet: ucc_geth: use UCC_GETH_{RX,TX}_BD_RING_ALIGNMENT
> macros
>     directly
>   ethernet: ucc_geth: remove bd_mem_part and all associated code
>   ethernet: ucc_geth: replace kmalloc_array()+for loop by kcalloc()
>   ethernet: ucc_geth: add helper to replace repeated switch statements
>   ethernet: ucc_geth: inform the compiler that numQueues is always 1
>   ethernet: ucc_geth: simplify rx/tx allocations
>=20
>  drivers/net/ethernet/freescale/ucc_geth.c | 549 ++++++++--------------
>  drivers/net/ethernet/freescale/ucc_geth.h |   6 -
>  drivers/soc/fsl/qe/qe_common.c            |  20 +-
>  include/soc/fsl/qe/qe.h                   |  15 +-
>  include/soc/fsl/qe/ucc_fast.h             |   1 -
>  5 files changed, 209 insertions(+), 382 deletions(-)
>=20
> --
> 2.23.0

