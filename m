Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C4E42BA2F
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 10:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhJMI2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 04:28:38 -0400
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:31904
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233015AbhJMI2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 04:28:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWXWJrsrEfdFE2PWZ84tGwuBSjOETJSy5SXn8N57ZQfR9kDwzAbJBlb1pRrVVkRkCu5ZXowWBTuQaf7Mke5C5GpPQeMJHHeC2uHZySk0k3LLXxCk9U14UgyiU+OW9+Oxa/zbq+6AJZJShPSTk15TKALMMsmK8Xc3VZYasaKQ8aZOHXOP8f2LbCYnsAdIj44Cu6yHgl/iiXPoYO325/JU8ZiwdKk9jHYjJEkxH7fSpy3B0cgSR5ZUwu5997Xkg9WU6hdGqT9ZCySc2UiIrC73vaRmPutiJo8fgkq7A3nAEz+k97PHkwRwppIUkNCS5gFFM/PjAY7zJ79Ll6J1jjUFpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iyy/tOkRdvreDidcu70qQO3SefoBw0vCRCSExSrlbw4=;
 b=mvnwmJgSRrHuNemZYBlOnANPm4GT8wRb06cM5zgH4hyXP2ztTWqrw1iRAEZv3tWY7XSD1lLxW/ge0HhPomKbNu/Vwj0kffEkeTWf78l2DWtQAn+HrY+wXSij3QgoZxES7SMaGIwvhr83/JDPmJHhLeFyxNXw4St+WZ0OMVxqty9zE3/+6gb3PnbTnyldQ3cEyMdbVT486ZfIAN50wxCXV2GzJ4m+je1zTghhQOF5XTkrUl3JJliApTC6EWYeKCmM53nP6VrTGKxC3fyqHP0Id7I3X3Gp5lTBawreKnbVf3BF4NHgobfccXqSDYjvEi0gXGpgWiTjbeboYIzhYPLORA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyy/tOkRdvreDidcu70qQO3SefoBw0vCRCSExSrlbw4=;
 b=Z+yiSlCIBKxC84WuSA7odNHTRIF+Kiu72NImEHQZqZ5JNKcTh/5P5i81hQCFZMXs0c5ZaqZrjhDya1BRalr4NEsNPbsJC51cCQS7cBYML6U52FFq9WrX2mFlT88an3g/hU6MC8WNGy7CueHPDG2YQLLqRW3VEXw1cvybqxU31pA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4815.eurprd04.prod.outlook.com (2603:10a6:803:5d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 13 Oct
 2021 08:26:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 08:26:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: enetc: include ip6_checksum.h for
 csum_ipv6_magic
Thread-Topic: [PATCH net-next] net: enetc: include ip6_checksum.h for
 csum_ipv6_magic
Thread-Index: AQHXv2Ky9VbrXXIV7k6frD+mWysNs6vQmUYA
Date:   Wed, 13 Oct 2021 08:26:31 +0000
Message-ID: <20211013082630.5evpkrmidqiap65y@skbuf>
References: <20211012121358.16641-1-ioana.ciornei@nxp.com>
In-Reply-To: <20211012121358.16641-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eccf366c-5a79-44f6-6b93-08d98e23292b
x-ms-traffictypediagnostic: VI1PR04MB4815:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4815A4CF9C5231873E635C16E0B79@VI1PR04MB4815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UGh1ATp/04e66shvfmmkfAqj9A0tlsbjksXk6ZtQLv8d74/URUyKd2DElJd5M92VaZc/pEfmY/yissHu7KzjhrZiz2wV9OnXaloJU/OR/qzByI4KPr7gAfLBaws7awKOhP/hPDAAKJME4O5XP1Qcs5xIq08xBSe+Ek50AtE2Ebl1/UFU3u0CyNJTgUS+PDIaLPMe21xLGLpGfox0hPlewuJK4krLkCG531AhS4EslBj6dldRl7msksMDvqX2nyYSPSxZgmpzquO/vsLeD8VWr6rIPB9xxi1oLEYgw+6nIW5VJL7U6upXXspmROxi+4Q9tQ79sHTpsVQp3kFCZqHlUKrzjILdUSANiIMfaVA32ioat9gJkhWIdSGvFFOBjeDNd4qYF3PXf9Fp+p0fxalIRzM4RQpdeYrKXKDuyxYS8xShmsvzDamnyvXMhYdJcSjTv1Mei6jJErKq8ionZHCs2nsrVj7pUf2xlAHR+QOVcwossERRL5M32uRsNHc08O7z4gyHKMxppkbXKNImewB4H0WQD5/fS4R4HgUJA4CFbF87orlDQfY6TcZB2yLQ98zpFztWgfNk/dxrUI+0N2Ylrqoaf51tGozMKKLUMWag36jeSJfyrQaaeH9zJaFEZMoGO7O9uk41bZ+f91bWN0Mt8AfEoCChvCntQBmGhApFl4URnUScYaLniHOoVO0EEHANEV48Ao07zntYztDeA6dvUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(86362001)(2906002)(76116006)(6636002)(6506007)(91956017)(4744005)(64756008)(8676002)(66946007)(38100700002)(33716001)(66446008)(122000001)(1076003)(38070700005)(8936002)(6862004)(4326008)(9686003)(316002)(5660300002)(186003)(71200400001)(44832011)(26005)(54906003)(66476007)(66556008)(508600001)(6486002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4r/hhtA5sCMt3NYXMzz/0Dr72Zf7hxRxnVZlXOMB6BIVtdbDGG+i059XP/AR?=
 =?us-ascii?Q?Ckl1MKrOcw2DdGKVnRToPz0iHmY4c/OfS+TaVRVJHO7Zc09uqN7t7e4wMPxH?=
 =?us-ascii?Q?QfBxbV+B0bVFfMMHWhWVULM/eGcewsunWbZqCgiHtR1RPSOkVng4Me95cbl2?=
 =?us-ascii?Q?CSv1GYc8yzPQQ+DvYTzEuLs9Dg4t0m+L5TeJUtvWbRWnayU3HDZpHPYL6ygG?=
 =?us-ascii?Q?sQU5HrfmgqJZgKy4HCC2xkbikYn4a+SeLUh2jsk9a18vlyt13ONTVitDO+bI?=
 =?us-ascii?Q?/8toVkCXLREJm2P6qBYjRbVm+kzQbNEkIZCZkmC9NUbl17RIl/W0MQS6x8a7?=
 =?us-ascii?Q?g/TqJRpJvN60jU4n2ztaGidGsCUWymwI1rvsvzlRqK+AkJk/l6k/RvMOs1Fq?=
 =?us-ascii?Q?KyAJ4wN/O/yOQ+hpSyiByxpywFjhVl5yYqFpsQpQzTD4SvMVLrMDjTBXhmNl?=
 =?us-ascii?Q?A5lN0tWVK2rTL2TJZqE6ULWvx8HlSWNRECPteC9SnbK/K9NmyWLyCZ2sNP9w?=
 =?us-ascii?Q?P1AryhRZyiJkfhEjn3b4zzmCecOqIVSRChDP7PdzVz8m0f3oGrxcqUnD66YP?=
 =?us-ascii?Q?cbupewn0oqRcnvSdCKAfP/OQQgBsY9678POxyt3vXMv+3ogC5wYE67SobgSf?=
 =?us-ascii?Q?7VeosTVAAfgtNMWfBkoWXkgIBeACjB5yFa59ohgHj08GPa7HqEKgwZ9cAtnF?=
 =?us-ascii?Q?1xXTohlOeRP6APdqCDwE22FsTCglfF34E6woIVAw3XIuFH3ZZ4PfO1pjjLoY?=
 =?us-ascii?Q?e6BAQq9EwfgSHf88U7zTIZfE+dk02iqcMhaQgMFJECt9y4HCGy+l5kApoHp0?=
 =?us-ascii?Q?H+uu6AZWxP6hPkJzj5teCadJuxmb7r4Nqt4mcjXnGIgr+MoLSPjs5Ko2yUN4?=
 =?us-ascii?Q?lUvkR3MWKq/S0v1XG8rgPF9ug+KcQ2qQWtJFQhD33yyUq5L3C7X+UxWCfMMq?=
 =?us-ascii?Q?5wJ5Pkx2rJzx3HjVSt5VuJvD8wK6vQk3Nx6LLz6DWqPgYq52NazQKz4WsxP3?=
 =?us-ascii?Q?2IR2h6wNvvKkzWuDncBQSHBbntTxtyw8BSmTPuH2cFql6+lJp1H5RlIXvzI7?=
 =?us-ascii?Q?BF17YfeYGD2NhHdvpEQuyw7h9KtbhjSOeLc84C3clyZru5WcyicAHrtD8oPe?=
 =?us-ascii?Q?fogOWpjuFrmV96QqQQaeLPTBpPiDFuU2tJ2FyMXr0wflV9H0A3EmB/u1mV05?=
 =?us-ascii?Q?+gqVQ7d/VWOX2aQN+04Q1g0dgjFvd3m+WcfgiVEBHjeWaNHVU3R8tGTlNMj5?=
 =?us-ascii?Q?Onta7wXWYiEKQTFVYkK87gFAeFJlKe3Wktr4UGNLNdEKRwG+rQNL5ssQahs5?=
 =?us-ascii?Q?O2KSwaVQPo8OwNY2O4I0C1Zg?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E1F0E07A2D26094CB76AC4035CBF453B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eccf366c-5a79-44f6-6b93-08d98e23292b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 08:26:31.3867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u43JRJgPJQ3mtE6aOmWf/AsDzQnNJjMJHECaA6JrGy6BEjf+EbY5LJ2eVyvlB67Kr2o5uZHiLPjibaupuotcmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4815
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 03:13:58PM +0300, Ioana Ciornei wrote:
> For those architectures which do not define_HAVE_ARCH_IPV6_CSUM, we need
> to include ip6_checksum.h which provides the csum_ipv6_magic() function.
>=20
> Fixes: fb8629e2cbfc ("net: enetc: add support for software TSO")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/ethernet/freescale/enetc/enetc.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/e=
thernet/freescale/enetc/enetc.c
> index 09193b478ab3..3ae4f49a9055 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -7,6 +7,7 @@
>  #include <linux/udp.h>
>  #include <linux/vmalloc.h>
>  #include <linux/ptp_classify.h>
> +#include <net/ip6_checksum.h>
>  #include <net/pkt_sched.h>
>  #include <net/tso.h>
> =20
> --=20
> 2.17.1
> =
