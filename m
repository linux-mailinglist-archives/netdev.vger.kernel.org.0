Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF753E5A7C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239178AbhHJM4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:56:06 -0400
Received: from mail-eopbgr40080.outbound.protection.outlook.com ([40.107.4.80]:64649
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237431AbhHJM4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 08:56:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jI0+ATGkPUvex0AH73nsFRiK25jyxiBiw2fR0hzi4Qa1e9JYE/lLcdHh+qJ2QCajrLnilqz0DspoHxl+GIrgJYulG55ZOy76swOGiF9KlJI+AZIlfFiPxeEfzCvGxvyT5auXogoaQuk2WwyJ/B8kr2hGaKOsRu83p1y48ZtcuZk6GtC28hLd8Ce2eHXZhHN7ZM8JcbH6Fy2Cb6Khtkt3TVhXffHodOBPJM8inx8bNzWwKxHirWWnhPztuNI4WFtAAuVOp8JTvCCb2JRJ66J4p/+u5PZWHzI+6k1OCAAZXGfb/ZyY2dTJePNVvrS+2eQcpdRTUjAYLV6cdaGNRhQhjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq9pVKcK14ksFItnBie83G9eScESLVclaIFeCev+JG4=;
 b=m2sQAGVkbtI34g86y+1RBG3dQ9pGiDxR2zhUCm5PqHy7tbufExeIz6L22fixIVtZO+Fy2RHlhqcIRLmpJHDXA94rULXt8rVVhuhH68sWB4nNXpV3IfVJ907YRVNwW3ZKcSAcKH/wZROB9U5RGUHL6Xqm/0UT4wEO2ah/0O0Ndbhi49CE0CyA1d7E9xl2WQj2FNjC6ANmZaW9rqodyhie15Ne2tAQ5MqmITqWMipi6etW1PYptm3m0L6QZwkdzVz/0EZvYQnVd2WCgNKgYw6iP0sDRly9sB2MO33jylEmF86Y1gK0il2pf42oBrH63930o6mNtVr2u/Kbf/z9bIlpzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq9pVKcK14ksFItnBie83G9eScESLVclaIFeCev+JG4=;
 b=MSwgThy1GtymLCI8JeU+PUMSd6b41s2JkMzKVdmfT1D1XLhXWRKg9jQ12whTDzzSmQvVbwAYK2P4jEePkk1fo6oLB9NkQ/RRqvlheGEdmHeEhMHLdcjeKGr+EAGUPrHeEaUmES6oepNX3+V8P1t0WiyhFpS4KBcP+8hEzuNXTK0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 10 Aug
 2021 12:55:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 12:55:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Mark Brown <broonie@kernel.org>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mscc: Fix non-GPL export of regmap APIs
Thread-Topic: [PATCH] net: mscc: Fix non-GPL export of regmap APIs
Thread-Index: AQHXjeVJiBGHZ3dsjk2QEBc/tY+GFKtssjsA
Date:   Tue, 10 Aug 2021 12:55:37 +0000
Message-ID: <20210810125536.edr64jhzgr7rdnmd@skbuf>
References: <20210810123748.47871-1-broonie@kernel.org>
In-Reply-To: <20210810123748.47871-1-broonie@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2790fe80-af63-4a53-cf76-08d95bfe267e
x-ms-traffictypediagnostic: VI1PR0401MB2687:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2687D84F526C229FEC965E48E0F79@VI1PR0401MB2687.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:118;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Xy/qJtXGbD8RQrFSQ1U9a8CmnQMEu3G8Zq28e5H6lAAFBrMhumi+ZZaTloh2mhmHkAa2nh0TfjrA1+7Kk7cjoOU0oqF0qUW7YMiWSz1W126n/6hauPBbxXGjYyjJt/Z4c4Q5k06wvXGU5/L16N0L+CAUfSEZKoeb2IqXXWC21bMsG3Uq4QLv/nfQoPH0PET6UxShDZGv8TOEkU6icW4Q6LXQonwl4pk+mrfbfzURfQDRS4jhyZZXywRzPcR3KLuB+FWVLgIB+DJVArF0cXVmw2pYo2DQLndJuKuBfc8S6LptwQsAhQ4V20nUa0ABHdArOm0oJb/W6W3LSF1j2kNS3OWRMJrltvXXFb+ARCWjDsL5D8GNFikuFeNYjaBxBJNZnumLlDYHdSRP0iLMyESxFCRdloir2ltnyWgGjSKWe+DDZ4mhzjMFGjZljUuEvsd0cI39Jn3R56m+dfTl/CwaeiMtWRl7s2GzYX5paKVF4b4+GPLjkYx6ErqLYldD/A89BgBnQ4msVF9IfN3tTH+dUSfqHpCrQ5FVzzI9IX+K1GdeRtX7pNML07HmtEphXxXvR/WEbBTxsGgSVBdCaxiGrqXWWqNi+bS2hWq3JTbR6WYXWRbZQTDeYvDCknFEynBew62VxMYMqPCH+nyY3SAP0r3RpoP48G6dk+q5nry8czhJ7PsVg2bcyA2D9DLg605YhRmL0mJyxsAMCACm4fmew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(346002)(376002)(396003)(366004)(136003)(71200400001)(316002)(1076003)(4744005)(6916009)(54906003)(122000001)(44832011)(6486002)(9686003)(38070700005)(38100700002)(8676002)(478600001)(6512007)(6506007)(186003)(26005)(8936002)(83380400001)(5660300002)(66446008)(64756008)(66556008)(66476007)(91956017)(66946007)(76116006)(4326008)(2906002)(33716001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/wWTmU7lKvj2ruoyF+kEL2Z9mU4vfKZgP+QfGC/PsovyjoBNEtEpz5ku/XDi?=
 =?us-ascii?Q?VrnejAVvzeFJOvHG8XPFieAgvT1lTCUgEK3C07+lPsW7UaAT5GP9KZ+XRfFm?=
 =?us-ascii?Q?eqcK8lsghhpxFf4hm8mOQ4WbCB6HgMzQ7+ZY0dqpD+k28T+zOiXuOjgwNa/z?=
 =?us-ascii?Q?7pJZkgv5XowqUtSzC0q38h30pHBU0P52uAH7/zuiageC+EsxrDtgZ3TN0dtU?=
 =?us-ascii?Q?p6RHao8Y6NRD59YGjjVYKwz9ok3G/OxYb6Ci7dNS2X3KVCapcjBjHOLjoNy2?=
 =?us-ascii?Q?ByU5xNeCzC/BOGOze9UXbmgTRDSs2uwuVij8tUs8MNCDYJwpcUoIV9cj/atq?=
 =?us-ascii?Q?E/v1OS7iDcynUojHgNZfar9Xrv9R4BfLpLD3FpcOGNO02XMl3orsFj1kXQLT?=
 =?us-ascii?Q?mY6m3uMbDhNGHEuEgB+zSM95IhVORgZZKYgGUCN/PHr9tLrtlu/Xyh/4gsu4?=
 =?us-ascii?Q?XQl98Jqhu8GnUnr2h30MgLrHUNN0gQPfP6lrF3JCdh/N7WzoRbeZE1xjEQnn?=
 =?us-ascii?Q?FPetxU2GJsqA6yQmYKzk8k5d311Lzs4m0ByGsyPYSBytA6avI5lORqFg29g+?=
 =?us-ascii?Q?rPoxAByZLyh6o6xMdQxuxZoLVLMfjXCJPDkfnO3CbfmtPdT+rInuP5+5Kveq?=
 =?us-ascii?Q?P3KRLlnpx0UPugfLpFkXRJeYKap7Kbw84lZy2nx+nUmLxtcU0a/po0SHK9OJ?=
 =?us-ascii?Q?xZhVM9FvXwQI8GNB7oRpFUQ8rzTMmVs4SoJM1OI9F5fh9gDAKzkar6XXm0OD?=
 =?us-ascii?Q?nbbLM++qADTVkaACz3H+eKTJkKWULcBzq63QHFDVlpLhSnOx1G7tGSrVt/8z?=
 =?us-ascii?Q?xUwqEpHijUa71XfoH7lxTfKqFoT+VzC1jY1UUmzBC54y2njVnG/DTW03uXfR?=
 =?us-ascii?Q?Xi1A3WooK7s5n0eBTeqfCwNNEtbye2s6ptx3/EozQNiJVW1dnZRCdPISy7po?=
 =?us-ascii?Q?dX3bD7GHp7s6U0UJm509zTg77wXJhnf2WAaE5+Zt+iCr6YMef/TlgpmCx8gK?=
 =?us-ascii?Q?s+pTC4/GAwoWcmVu8iVaUFbeYcJhu++kdoJwW7S5bFb1z8GYEJT3AvOUqu+T?=
 =?us-ascii?Q?4G+829B5Vm7dVZbm9hctsO81AavMg7La5vLJGR2rewfdWiVtZwnPnrw/zCZf?=
 =?us-ascii?Q?qYfh46C3W2N8q6WO/lFWjbYIlGB7YtEKnt42jFbZeJeaFXGLWl3wHuG6Cyna?=
 =?us-ascii?Q?WU8r/0u54GacaZfYjJL/x+YXwZld09RDCvJBZ+fdWwAZcEPH/AAzkYDgJC93?=
 =?us-ascii?Q?CDQ1qyp7Zm35yneGNjvqXmHOHi8Xmu1adYGARRzCVEmh4mOk2FIuaOHY7SfS?=
 =?us-ascii?Q?DVd1fWJgmHmDBza7Bpx/8eWY?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32BFCA0874CA294E870B2486478AD103@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2790fe80-af63-4a53-cf76-08d95bfe267e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 12:55:37.3872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: onJN5e0+Dmdt0E8aOvIueHd9GTlFUHph9ycRfqkaDasxUmsuc48h6oTL+KFi9PTicZIOG0uefnOPJiXJQ53g2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 01:37:48PM +0100, Mark Brown wrote:
> The ocelot driver makes use of regmap, wrapping it with driver specific
> operations that are thin wrappers around the core regmap APIs. These are
> exported with EXPORT_SYMBOL, dropping the _GPL from the core regmap
> exports which is frowned upon. Add _GPL suffixes to at least the APIs tha=
t
> are doing register I/O.
>=20
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---

Stupid question: is this enough? We also have order-two symbols exported
as non-GPL, which call one of {__ocelot_read_ix, __ocelot_write_ix,
__ocelot_rmw_ix, ocelot_port_writel, ocelot_port_rmwl, ocelot_regfields_ini=
t,
ocelot_regmap_init}, and therefore indirectly call regmap. In fact, I
think that all symbols exported by ocelot do that.=
