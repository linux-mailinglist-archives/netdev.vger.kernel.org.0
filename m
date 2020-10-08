Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF8287632
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgJHOhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:37:48 -0400
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:21984
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729770AbgJHOhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 10:37:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvXnDgG5yrJqzxw10cz7Icc470amBCjKeisLATrgaDTS72FSQfGr7M2uon+XJxhZ9JhNAhtudxUppb0NFJyiIHuiabHGXbSuyAhV06rxcEAo+WcIXrlXOyXtYAw7h4x3F3h/2BxlJO8b/ob8nokQCowDif2DH63XK+56fMU0GEorXWlsUUS0Ltubi2Wxt6JcE5l1oWbrkXZVh8JTT86bMx2/xETD92SJV6cac0tCAgXA883f9fZ+C7aYW1J4DRgkyqDw3mkP9IT0LwcU/bZEpelsNH8bGNigJmfs1B/zv/H3Cm7q9pWbXH8Dx7exEdkw6CkvSaOJ2Ht0C7e2X9MB0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFfdn0tUXe518f9ZnDff6DZ5J/H9qDn969qk1PZwifo=;
 b=c76P6FPjyFxwHIccN1IR4Cg7jGwhh1PFuphnvUwd7CyesBWsNBosDZzgLOf+CxsUvJq+J7uYsc4E4wnte5+nBE2EVMjak6kap70dGT9srCgvejY+i60GR03BLRTJIo//tprtzq+PZkxdsuMWC+MUZiVw3QeOO8FDOIeg6t0LXwhMfXvfPCdqXKWdhEnIRGbdSM3FMXuaN/F/c6lFuZBX9iB9ukUBqNt3D8X1ZSQm4rkFmPOsVHyhGocKfmn+fhOPzlj6Hx5iClvulDNMmFmv+FflZIvYu+MQ6pnifSOwp3Aoq48+dCulYgRmfmuLR4HaRQ29cQuKZZHanTDsnHOgQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFfdn0tUXe518f9ZnDff6DZ5J/H9qDn969qk1PZwifo=;
 b=M8gq9SH4cN4RvwLJPs5C+G2OmA0J8v7eg7V60djyfgxnmEJaXnPKPs+POaBqcw7ueN2ZjfrwnLkiBqVk6usmUf9OnylXvv2+BY+UJGeFETZYxKCGvxs8mdyyKsgTvHM56qQo+ZMh2Cioz/JSTU0Ton0b/g7f9n65lsMO6Z4sTyk=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB4325.eurprd04.prod.outlook.com (2603:10a6:209:47::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Thu, 8 Oct
 2020 14:37:44 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::38f4:5b8f:1ffd:71b2]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::38f4:5b8f:1ffd:71b2%3]) with mapi id 15.20.3455.023; Thu, 8 Oct 2020
 14:37:44 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: RE: [PATCH] dpaa_eth: enable NETIF_MSG_HW by default
Thread-Topic: [PATCH] dpaa_eth: enable NETIF_MSG_HW by default
Thread-Index: AQHWnWsJ7wvNaIoRG0GlKg5WTkNhjqmNxf9g
Date:   Thu, 8 Oct 2020 14:37:44 +0000
Message-ID: <AM6PR04MB39762E887745C2CAC34F9098EC0B0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201008120312.258644-1-vladimir.oltean@nxp.com>
In-Reply-To: <20201008120312.258644-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [82.76.227.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: edfbf9b6-b522-41b5-0dcc-08d86b97b82d
x-ms-traffictypediagnostic: AM6PR04MB4325:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB43252F6EBE1DA0EC1CB02FF2AD0B0@AM6PR04MB4325.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KupozJwf36dbb0sQ+A/2EH6kT6nRnh3OgdrCC9JTwT6Gq3sEOQGVmCdqGH1Ew5rinBJcfixYpioPEqXVi8lbbp3IWAIak0PT/FDsI6jO9DNn+J28qO725G8YbO/N50XT+sDw+uWQb4UHsnBLPeV+NyDAjAZ1JQTln+t6qpaeRfg3L5zGREcPa5r6SNe9nSi4GYYO3zqTl9NBn6BPKD0I7DdcgXv6pU+mP1woKSmj238ydBwm1WjBwcwxT38/Dw7iGcMZxQdjdgVpLycv+cMR2v9l2xOGX+BVtVigGe4Ag/T4gLJnPXCjqIkeQNwiErS3KVHt3y1PDuHlE3ksU4njHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39850400004)(26005)(83380400001)(53546011)(7696005)(316002)(110136005)(4326008)(54906003)(5660300002)(6506007)(478600001)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(86362001)(71200400001)(52536014)(2906002)(9686003)(186003)(8936002)(33656002)(55016002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: oy06cRYQUP0slAMxpJ71P2cWIzPjangq+xZX/OryeGoh6GdkM8NkCzxP1C57FQrabQAOer5LaNxCnAy2lLbk7cjfHsbASI+XptFkayAsLe0U8YBpci/kbxX1Lcs0zugzyggQK4QStNItyhIkC+3g2PRuKCH0okTRRg+vMm1dM2aCeROXGhangOG70XBcosAUxXz9044WJyRuoaVQ2a72ORLsnhjfp+3Y3KwVzsrspLX9RQ2bwBAESHeS5QUT2uWs8rhqCGTzd8tdAnT9jAFhA81wZfRxOUyOaUVWnRD21Lgrzsjaw6pZh+NzgR7Kc6PyhZ/uv2tNBOJov7cN1LjIQZXSjUo3Vhse5vaKEKi/5W4GxtoG4Rj5AWUulq2tdiacvqSn8ib1uzZy+GJgF7J42GLAbReXGW3aJd0zviDzFR2NDY3cH1lYAwIt7e3MGLO2o9YfM+XL/sqWqGkDVdCFuIIOBFmJMBSRcdwRac7ruXzj5tTmtX259bo0Fe71yBVs2fGMZ1OzfKJQd/bY0c+KOnBwZhFSN5GkyKDDHElxlP5nfZC5Akcn6x3P4Xi45maubJjAmxTbS2q3nyB0ZZBMuYNU4Lqik9tQBiglbVs76iNEalm2B9Juo93g6DZWRhjgTGB4c/DpjYV+nEKklwDRyg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edfbf9b6-b522-41b5-0dcc-08d86b97b82d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 14:37:44.5570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TZ35LlDno1HOdlbbrzxgfxVhIAblRv2atunWJOxQxmM6NVoNT3u4to6nzkNU90yJyonZhjepdMfVVKq+PoRX3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> To: davem@davemloft.net
> Subject: [PATCH] dpaa_eth: enable NETIF_MSG_HW by default
>=20
> From: Maxim Kochetkov <fido_max@inbox.ru>
>=20
> When packets are received on the error queue, this function under
> net_ratelimit():
>=20
> netif_err(priv, hw, net_dev, "Err FD status =3D 0x%08x\n");
>=20
> does not get printed. Instead we only see:
>=20
> [ 3658.845592] net_ratelimit: 244 callbacks suppressed
> [ 3663.969535] net_ratelimit: 230 callbacks suppressed
> [ 3669.085478] net_ratelimit: 228 callbacks suppressed
>=20
> Enabling NETIF_MSG_HW fixes this issue, and we can see some information
> about the frame descriptors of packets.
>=20
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index fdff3b4723ba..06cc863f4dd6 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -87,7 +87,7 @@ MODULE_PARM_DESC(tx_timeout, "The Tx timeout in ms");
>=20
>  #define DPAA_MSG_DEFAULT (NETIF_MSG_DRV | NETIF_MSG_PROBE | \
>  			  NETIF_MSG_LINK | NETIF_MSG_IFUP | \
> -			  NETIF_MSG_IFDOWN)
> +			  NETIF_MSG_IFDOWN | NETIF_MSG_HW)
>=20
>  #define DPAA_INGRESS_CS_THRESHOLD 0x10000000
>  /* Ingress congestion threshold on FMan ports
> --
> 2.25.1

Reviewed-by: Madalin Bucur <madalin.bucur@oss.nxp.com>

