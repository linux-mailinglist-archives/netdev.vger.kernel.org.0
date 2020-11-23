Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2BC2C0263
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgKWJje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:39:34 -0500
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:3302
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725275AbgKWJje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 04:39:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFRM8ICIgMYx5VKK9tgCDVvUCTMkpsEUApr8MGqEg0H/rabQiO69tgjmpE8D/fK9iccAjUH1jtMbuFtK9aNlP7tWDw8HnJnAAPqU4AGPxadHLa+T/JacfTRFdItshoCiZZT1wDzBQ2JG9pnL01fd3QJo2ogSS8tEkPwHNDpyLwgC6dgnFtqxrqKBcgurVHelXIorhbosiVdNOw2f5NkK3y9GHz94JL5GNMdp51DSinUgaZBDB6ldpevkY2Y78/OoZ9bcmk6DFU2IelMaQaFclw9PMtjz5SzbgIozlnEAS7N0voLPHU8S2NXZPn6JVBxqHrdN2PdqNh+irmUojYHhXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAB4oX3YldQcNMrHU99KaW4yrGzWRv4bvAIUi7MF3UM=;
 b=hC0SdGnXasyBX4EG/hAhT+ty6TrGwITKWFfbI8H543i1z8Zs9EHOkOX9NbCUiRzj+AGPAZr+5qgFZyLB6hv2QNV6hzrWFkKFVCgJOJ6HipRSHUGpNVDovvYR3uEQZm2sfcjrowS91J3m5F5zglwFL2FP1/uAMZM4xjyCr1kX9CeMEeU+YqtMQ5fiS4fU+gnZdMaMhcqxk74bMsA1PoaIc87BKodx8g4sqiHQNuc8JqZdQkM43IYGp8UyIvTSp6PKH5m/ojsxcHjDM14SNCqQcpISSrgZJijLcrfICgT0h9GDoH7NLJb81jDzO35LF9xE6MKhHbymc3BpdYhQyofeSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAB4oX3YldQcNMrHU99KaW4yrGzWRv4bvAIUi7MF3UM=;
 b=J+9RpZq+u48ji85KZH690WxURDbi44Ql0Noay2n8EP/fES5Tp0Qv6iN+nsXt9a6/vKKLsMZng1qGUqkzddjlfPlLCII89O5sf0ZoXyqlKFMGvQuzJV9uh+lz0PWVaNUD9tp7joq70vZI0V69XxUmQPggyj/Z8BHHa/NstnhMtJ4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4031.eurprd04.prod.outlook.com
 (2603:10a6:803:4c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Mon, 23 Nov
 2020 09:39:29 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3589.028; Mon, 23 Nov 2020
 09:39:28 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Ezequiel Garcia <ezequiel@collabora.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "kernel@collabora.com" <kernel@collabora.com>
Subject: Re: [PATCH] dpaa2-eth: Fix compile error due to missing devlink
 support
Thread-Topic: [PATCH] dpaa2-eth: Fix compile error due to missing devlink
 support
Thread-Index: AQHWwGYkrPZWLBjkiECa2U/nsQMfUKnVeEYA
Date:   Mon, 23 Nov 2020 09:39:28 +0000
Message-ID: <20201123093928.pfvlpcdssjaxa37d@skbuf>
References: <20201122002336.79912-1-ezequiel@collabora.com>
In-Reply-To: <20201122002336.79912-1-ezequiel@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: collabora.com; dkim=none (message not signed)
 header.d=none;collabora.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 37a02c6c-4b7c-46e7-b67d-08d88f93ac7a
x-ms-traffictypediagnostic: VI1PR04MB4031:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB403114D78451B392F7611AADE0FC0@VI1PR04MB4031.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FKWYrBN24yBDAfbHoFHSDo5ScroBP4RZCFxGN49YvVnN2ZbpVOYtCjgW9AlIBUAC/M4bGICc3iRre4avyp/Ybv7itepGAXNbl6kW89XkDlTKBACch+6SCqEBZQBA+Hcp1s4L3LLVMe3okOoNkyDFC24F9M0oCmDJaVYf5g6jWNOq15CrSPpadhlaoy83TzX3BQEAlvjToge1k7iUy+pi3Heg1w/WWduiKAnlgAIq6cW+QpjLNYXN5JbxhLWXQHgNea/ajiYDOmNHQuXlfLE5bnFzPMVolOOljFz2/u0CTJdSeHRocgoLj/taT5gaGKVZLwgtwjSZCBrMuw8IzrBl8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(346002)(39860400002)(396003)(376002)(366004)(478600001)(71200400001)(44832011)(8936002)(8676002)(54906003)(6506007)(26005)(316002)(186003)(1076003)(6512007)(9686003)(5660300002)(66446008)(83380400001)(6486002)(66476007)(6916009)(33716001)(66946007)(64756008)(76116006)(86362001)(66556008)(4326008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 6nW5SaLFpSu6O+xFUcjsSKQGNQLHbRzoMcPu5DC7SQbJCpkhFs+kRh/lZS77EtYSZ+zbXHeAATUmLy5iw/5St1HjUJjjzPljwFWNiFeAb8zfo0qsqr6TBW6qlfm4FMl27So27/lrOomiUB0IWzTin5sTrOf3ZD/pmawRHl6qOHM/EXCjNcdefT9M/5wL2a4P1dokhfYn+aqRkfrwvV9IKxEB3OEfcXjJUUjSL7+BguziIume7xtScSdXHXJ6C75K2cdouNMiTaE7BfXJ19ZzW61KCVXM/SOBfEq38sQlisoGzrFjBJ9l/a5qSEPo8dnBHA11aNj8PrBNpjn/Av/1+kRPwHVxogF/0brNeWSy1h4jkbvRLIyus0p4w6btr1DkecCwauVuCjRnS3rEXOCxiQfdXh8KYtMg2eJrW8KzV8JWy+q/DrO1rpIJRQN/pL2KwK7HRzRceJHueSAR9vQBifB8J9n5uLgXWRuF65PpMLvEzw3EZmoKWk/FrrEie112UkQibciBRIenCOeKaHpNnm4UicOwbEVGG/SeFpm7fUs8fJdWgKx3PoCuCLEFcVK8MLRrCzUM4VTmkskyH44YtJyaZ/dXIDqJZwuG4+rA4h7OfT9CCs8tmkuI2idVkSvYBQq57CAhWJzn0KBuSuqbjs8r9OOipwZsAfckGf7LVLkG2zH3EFA1efq/6FjQOhfKmHq/HLsapNxTUVuUXl2p5k7uS6w4XY7Wsf2N9xM9x5+aq4eRkEsLySfacL6c5fqp9+qoFLsV6+0k6TfhCdTxq5Duagn1E6Zsq4QcWxahRUSb5yOejuixXGiXF6M+OGcDvsHk2nsAiNqxzjnQbLqaAFGoDb1kQ6/tLyg5IGBSK8dQSaWUxhUJ339H40UFbKQTKl56g/qMeMxt21EPlChUiA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0119F396BC53494F9D33744A4F7A4E74@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a02c6c-4b7c-46e7-b67d-08d88f93ac7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 09:39:28.8663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yR4l689H/L+HITG55vqphy9FeaFpsSc9dlcb8R+kragQxZubSN4izUyYK/RVKoNNgD42XEKgBai/joBH7wgvDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Ezequiel,

Thanks a lot for the fix, I overlooked this when adding devlink support.

On Sat, Nov 21, 2020 at 09:23:36PM -0300, Ezequiel Garcia wrote:
> The dpaa2 driver depends on devlink, so it should select
> NET_DEVLINK in order to fix compile errors, such as:
>
> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.o: in function `dpaa2_eth_=
rx_err':
> dpaa2-eth.c:(.text+0x3cec): undefined reference to `devlink_trap_report'
> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dp=
aa2_eth_dl_info_get':
> dpaa2-eth-devlink.c:(.text+0x160): undefined reference to `devlink_info_d=
river_name_put'
>

What tree is this intended for?

Maybe add a fixes tag and send this towards the net tree?

Ioana

> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/e=
thernet/freescale/dpaa2/Kconfig
> index cfd369cf4c8c..aee59ead7250 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
> +++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
> @@ -2,6 +2,7 @@
>  config FSL_DPAA2_ETH
>       tristate "Freescale DPAA2 Ethernet"
>       depends on FSL_MC_BUS && FSL_MC_DPIO
> +     select NET_DEVLINK
>       select PHYLINK
>       select PCS_LYNX
>       help
> --
> 2.27.0
>=
