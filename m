Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC912CEDF4
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgLDMTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:19:05 -0500
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:20128
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727385AbgLDMTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 07:19:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeSohrHnLBXfV2Om+n6in/c7WIVHzJ7Fm+YWWS98+NNHSVs4qHIAq/9daXnHxZvGjV64HK7ZhdwIuMvJ9ux4kjz9gVx+4rduIPjvGkYg8jLT2pbUX4tG/dImdvJl/0Xy/+CoUa/QASnDS5eYyHcWMQ0OGAb5LS957Jzahb399hBk+xk24yk8bCPPD5VfYkLtA5MdzJYeiutOVYro9vCUwhqVj7xgtLXn5D43BwCQuEatkj25FkomjrMb525UWIZcvpQG/RMdWmkRAqyVTVt1Mpeq2HMP85BXGO8IvrCUYZA2Ep0z+kXIKmVL6cKqRzCpkXELS1QlTjEaxxywKu3dnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cf8M99viUZEAovJha0oGl0/L/QfQnQIhsr0zegiapBg=;
 b=UtMNSiR76SGfWbPeiYlCfpQtyy1u59a8FQ8K61Gr8/PPcejbS+eogvp9t02VOe1il3iRcyYGeFWVKMtFykbObgsKXvtG516S4Hfbpf9g0UwpycI9eyrOzjT6A3iwbXgYDSA+QOJVeuK/9iI+yTZk1F4/oDE+lGmfmoq1tihdyqfnUPFh5AG4fOTpjuL8KviC6QsNZzhiJSsgmfpbBAgtuYuCXbcoy1ysRP+v37TUPXdhBe28t1x5uYvMbeJvPtt8e5mKHzNPQkLw+Gt31j0q1Tc4PC8OgAK3Z5nVbsmTjsO3ZYJGXDVIYnU5OgXAgBf2W5yoGk63pgPKPjFIWl0nbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cf8M99viUZEAovJha0oGl0/L/QfQnQIhsr0zegiapBg=;
 b=HzIkccAJtxHoJld07smLIF71w4xq7IU7ABGKs/3yp7aiD3qbDdFkfnmNl90caIuHDX+kMcoY4UCtaVsix+i0V8sOca3DFsHJCbIJDYchO6IdnD1sktp4dt6fbW5IaMsvVgFMks1+WtK1rm3kUgKOZ9Yukwc44tVAQG2+SlZO/NI=
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DB8PR04MB6491.eurprd04.prod.outlook.com (2603:10a6:10:10f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Fri, 4 Dec
 2020 12:18:16 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90%6]) with mapi id 15.20.3611.031; Fri, 4 Dec 2020
 12:18:16 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.cionei@nxp.com>
CC:     Arnd Bergmann <arnd@arndb.de>, Michael Walle <michael@walle.cc>,
        Po Liu <po.liu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] enetc: fix build warning
Thread-Topic: [PATCH] enetc: fix build warning
Thread-Index: AQHWycTyKaMdKSe1d0OiHw6Q5/4O0Knm2NiA
Date:   Fri, 4 Dec 2020 12:18:16 +0000
Message-ID: <DB8PR04MB67644946C4F1DAF8F8F38A4196F10@DB8PR04MB6764.eurprd04.prod.outlook.com>
References: <20201203223747.1337389-1-arnd@kernel.org>
In-Reply-To: <20201203223747.1337389-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.121.118.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7da71fe0-7b14-494f-bb5f-08d8984eadc3
x-ms-traffictypediagnostic: DB8PR04MB6491:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB649189F155CED9B12A7DAF7996F10@DB8PR04MB6491.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V2uFEfdKxNVFssZbaDBiqT5YEBhkXKWsVnUMfHKO2cyWbZMYHhV6oqi+gLWnC53k02cIBy8mOz/pv3QklVdKvGUfGL6kVgibyYB+fzpsleOvESGn3SGWZFD0Vo5RzbXOXri/7h+Bp6y8iaMLCDIH6ZC16xsJrRuXZAOaP+89xN8AON+SFxOxyg+mf0gwOlynnL7wtSVljODVb699PJTka/SwcVYbRDNVphdRzAuzl+NPQjwQz98B5tQn7Ny7fHl0iEIR54eEcBlazFpBfuTO8OaVy4C4PhEZM8YjBirixfI3IOjxlvpoxFa8NjHoqUkDQjxiZX27JcrSz+iFtGjMBnmZUkmT8+PgOMVWh1+MPEDPxe1Fa+qqUS006IEaZy9OPfXz+QTwCkx7MEei/BcIJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(8936002)(71200400001)(26005)(6506007)(478600001)(7696005)(186003)(5660300002)(66946007)(44832011)(52536014)(9686003)(66476007)(110136005)(83380400001)(8676002)(55016002)(66446008)(66556008)(54906003)(64756008)(966005)(4326008)(33656002)(2906002)(316002)(76116006)(86362001)(6636002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zDHyRGaDzd8G0yHYq06gZ5rWp63ee8osT/mPN3rEWZwh2z3zNIEVewfAOkJp?=
 =?us-ascii?Q?Rywv6FUljVXCm2jpzY7e5TvvgebXUU2/w/KqVxwPuOcUudiZPTwljfkvyD0F?=
 =?us-ascii?Q?TM5EUDNVnZSrMT3G4YQGqrqxXHxZQYtkD1dGSWVkoz/RaSUYtTojsSmmhJQM?=
 =?us-ascii?Q?m+VDiT8HsA9Lgub7EPpNOJt3P06Ko+uyxQNITgeUNU93urPBFoyqnoo3nO89?=
 =?us-ascii?Q?/ndiGXh5Rw6NB08bTQdsF9bARJJZMy5NgVEcXvBVaoWvuetGRi82NdmJ+dXs?=
 =?us-ascii?Q?hEw/NayYm/IOdM9BU/czMWW11VwsM4kJHzm59/bls3B+VAumFyiGzY/qPcWW?=
 =?us-ascii?Q?2QMaR4OU9V8QO8nJfy7yrktYZPcJDbdoJrL6f0f1gcy3AewJhraetCkP3xHX?=
 =?us-ascii?Q?2YB1DrJyYZhiv3CdkQiEx+ZBsu+PGDD3rYB6SiM1QWj1X56ViTHH+wXlDaFq?=
 =?us-ascii?Q?k8VYvHhMhDmFry1/9B3HCsOzKe1X/u/cbLwoiU7UO6DPCjvMubfGpZb8QVU+?=
 =?us-ascii?Q?0YpLkeU656G2FGNAREr+cIvmDZSFmbqhXfsGi5V0lj6D8EnLwIKQSwDTpCHz?=
 =?us-ascii?Q?R4zbyCwmmSgZX5MNbsF4AuMHSPSiCom71QaMbSBJ0hph5MkGkufuqKxcYDrr?=
 =?us-ascii?Q?jL3SFTu9lFF6ZP3SFwomOPUZF/vvpopKUkZrkdcyP/tILcaDbFzjyUKTWdB5?=
 =?us-ascii?Q?soruLkGCAP+L0PoOjNIOgIhbs6Mvm6jHTPUjr1Rf5sq18HRYjBij36fE1c4w?=
 =?us-ascii?Q?afbpuURlis3n+Mr0nmScfzvxD2b8YAk+4yKVyKhgPy/XC0u6DFHdz7WgFdhr?=
 =?us-ascii?Q?Vji5QQoK6v7VzaUvxx50HQFQ6Z5YnuhmmJy2LNWLWYruuHvJTZ7Ip9FJ3Rl9?=
 =?us-ascii?Q?DxeOcH7aVNLpMXuhF1Ca8pA6FAe+icpYJGjSbrYe086LQLEHUGDLImKIaF4i?=
 =?us-ascii?Q?Xr+5QLBQt9bIEt2VStLMWccgHKepbypCzLwyWBtS2VY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da71fe0-7b14-494f-bb5f-08d8984eadc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 12:18:16.2092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bb5xMUSQxft4xzGpSqP9FVxVv/fLZUdltoFYugmeM1MpskXC8DZAljEl3suCAoYjn+5uz7mMhMykq5klrBp1FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6491
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Arnd Bergmann <arnd@kernel.org>
>Sent: Friday, December 4, 2020 12:37 AM
[...]
>Subject: [PATCH] enetc: fix build warning
>
>From: Arnd Bergmann <arnd@arndb.de>
>
>When CONFIG_OF is disabled, there is a harmless warning about
>an unused variable:
>
>enetc_pf.c: In function 'enetc_phylink_create':
>enetc_pf.c:981:17: error: unused variable 'dev' [-Werror=3Dunused-variable=
]
>
>Slightly rearrange the code to pass around the of_node as a
>function argument, which avoids the problem without hurting
>readability.
>
>Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
>Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Very nice cleanup, the code looks much better like this.
For some reason this patch is marked as "Not applicable" in patchwork.
So I took the patch, made a small cosmetic change (see nit below), added a =
more
verbose subject line, tested and resent it, patchwork link here:
https://patchwork.ozlabs.org/project/netdev/patch/20201204120800.17193-1-cl=
audiu.manoil@nxp.com/

Thanks.

>---
> .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 +++++++++----------
>@@ -1005,9 +1003,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
> 	struct net_device *ndev;
> 	struct enetc_si *si;
> 	struct enetc_pf *pf;
>+	struct device_node *node =3D pdev->dev.of_node;

Nit: move this long line to the top (reverse tree)
