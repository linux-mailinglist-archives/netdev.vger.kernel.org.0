Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C2A3CF773
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbhGTJaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:30:30 -0400
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:59265
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233914AbhGTJa0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 05:30:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdTqbPMXI7fVwAdSO3Yu4w8jHrf4yde6UcC9AyLJb7vl3IFQSt+nPy14TJ8bM9/Ui98EwgZK2MxO1xMsTC4gy+yrTqyCRO62fslNS7Z5xVejSZOXToHyviJGdd/Z7u7AaaaHRcmDZGHq/B5wsgI3BEJcp9rlSLRV6BKgzBco0dyOEw/DfeBcwgV+vt8MfOHgC1abrZ4TSpCtXJDcC7DXbuFr2lfLr9p3EEB4br5WZRs3NhQQUUxgpweTOUNsauEI8JGOMobYukKSYlTF+0HSdsAN3YyHS15xEL0vIsubuov771XbTAkdIz7GFB9+5fvnxrGbxghH35gMRFVgnh9iqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuW9ATX8WBbaMKqa2ycaDBuP5sZ7Dnah1Feza3sSwgY=;
 b=aQ2kM1vZ1Kw2e+8ro8P/A/pB+2pziTYnL4ZIhCltec/61Wderp27KA+yDMvDfm0bIez+AEWU2rvt65KWZDJwPqSQNcqMUG7B3NO4PUIBg6D7/z5N2d/14fegUhzDJkB6x9vJFj0bWm0jwlXN0gaK/G64pxGmNWklQ01MFoeGj8K4D5EGJWPGfDXChQnLxqDT8UjLpVVhHuEujd2uMiEEY2OCNnXLfdZYS8+2K7fJ/wsqQnXYzNvTYE7+OpXao0+upUhqEVrdFMmVy5f3Op2uwbx77hRD5x7VWppnItwIpO7hPkFwXZYRcObAPUwkmhfOrBTc4Usc3gdsT3f/syIGFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuW9ATX8WBbaMKqa2ycaDBuP5sZ7Dnah1Feza3sSwgY=;
 b=ASV1EA5QKvpByLkT+ZNfST0rP/DE47wMpk+5EchzHTebRLDZ1z8nKC4vrWzgiANYKSj8tJ3EyUIgHdEj8gFh6NAj3/lGwszeDJLlUif+GlTzd2tTRwYC+UcP1Fb4iMPusCQANJenGj8dDfi6vG0UFwvvvnYbSbPR6aMXioZk6bU=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB5078.eurprd04.prod.outlook.com (2603:10a6:20b:5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.28; Tue, 20 Jul
 2021 10:11:02 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7854:74ce:4bb7:858a]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7854:74ce:4bb7:858a%4]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 10:11:02 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Maxim Kochetkov <fido_max@inbox.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: RE: [PATCH] fsl/fman: Add fibre support
Thread-Topic: [PATCH] fsl/fman: Add fibre support
Thread-Index: AQHXfSUInPfcmH74vkmxE18u53qNN6tLo0sQ
Date:   Tue, 20 Jul 2021 10:11:01 +0000
Message-ID: <AM6PR04MB3976BC1543A83359367AB668ECE29@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20210720050838.7635-1-fido_max@inbox.ru>
In-Reply-To: <20210720050838.7635-1-fido_max@inbox.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: inbox.ru; dkim=none (message not signed)
 header.d=none;inbox.ru; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d04c0c9-9304-41f5-db62-08d94b66ada2
x-ms-traffictypediagnostic: AM6PR04MB5078:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5078AC2C4015C419231E02A7ADE29@AM6PR04MB5078.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:475;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UPMfwB0bi67UL/6jW+eeUK3nXd37c+1mCcrjle7v+wvtalonRP30agvyKbSCNl2cC9aMa1K22nF1xDeUvcgic/tJRuwsnfQPv3QOTMIINIHUmy8vLWEe+3Csll+WmxmeKQyN+DfTN54s9HckrhCp/ZCoo1ru1kU0Cemtk/Zv7mm65Zq2HzkNMSYAjWCwuO07JP8djyVzQOHQWDiqRWe+zowvFJH1zvC29OZPvP2NYdmIlULFn7IhKhhlZCdALUb3+MsqyMn2L2T0f20iztRUKYZYrH1rPONSPDiYzaLdw6OoIdsTnF8/pYBhri8cC0maPR5f3enQ6NeWigrfTANNp16HLOSNNh5NOQJgSBksQEsSwEFSJi3wrUsNe/FKtiHVz0L2D+v30yTmUuXgSLTQHKWsD6SZQPaa9WXUya32gnKCoXKvV6gsWBOgPRpqk+6jJXjJJT4wa7KdukGJGfEI6wFOeURk2/He8xnoORF0SkRFUquPNpxBt5Ar2qcuS+XxiMUdjrDm8xF0QZaedkQMNujHB4oBIUlnVWwniOzVzjYXSP6eCj55Ssk7Bxx5o3aNpGsCY1j9/zO7t3uncoB8RpXS7CDIYqERqLjETr/KF08B+diOJoLfkvrwXIGveW7lhQQjKoe6H1/WM1+x8HN6mbmBwB8jANPWZoHl9al2lueRELQLkRcayKSTYk7emFxUJDJZc1QZj+JLN+VY3tDeHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(396003)(376002)(346002)(2906002)(478600001)(9686003)(71200400001)(83380400001)(316002)(33656002)(54906003)(8936002)(86362001)(110136005)(8676002)(52536014)(4326008)(5660300002)(66556008)(186003)(26005)(7696005)(55016002)(4744005)(76116006)(66946007)(64756008)(66476007)(66446008)(122000001)(53546011)(38100700002)(6506007)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Du9FH/3xj/9SvWTUhO/bN32Q8pGpi8/02wLL1ml/WX0kRX9snXrs56888DuZ?=
 =?us-ascii?Q?ZgZUE9IfMQCgqsKEbT+Q4tev3DyAsu6RnqPxA+aYv9G5QmX+ZOnfRBQGnS/7?=
 =?us-ascii?Q?lvoIkfUcFBqYUEOUU0tzxHBSGvYEoSUnnkyjNmcwms6sJW5hhFUGbztaIB+J?=
 =?us-ascii?Q?+kuB5BQBFHG6x/hMLwzHOi8hllXGj8Cxs96Br99d/T/yP3xw/8vgiEvtqaKN?=
 =?us-ascii?Q?s9NpAKqwwrUOvAsag2z383kTYTKZ6QmLIzjT5AYYjBxhtIGPlsj8HJl4HlJY?=
 =?us-ascii?Q?iqLrob7RffDtBCTAZShHkdqcv4W++zC3xDWw5oVEgNNY15jRz5300rCCr3fA?=
 =?us-ascii?Q?LGFN8zh9o9QL4jydJHKJniRmT6o1crVfM03YZIq1XUggGaCt+7Xnr/uwPkPt?=
 =?us-ascii?Q?5HEOZzaUxRsVzZKlkAi0pxmb4CrDTl/AJMknL89k009ayimKKtrz1uShq1Ds?=
 =?us-ascii?Q?z369fzW7BgmrenBfQZvMkVaU40/Uk3u8tfTiwHjDNFYEkpKrbpPH+ilBHhex?=
 =?us-ascii?Q?17uTgmPgLr6aDRNA7n3+yxypSjhIV1C1f1lGKF2TKCsF2rtt4IN8bxV1VeI9?=
 =?us-ascii?Q?bXcSZ9AkDkh0aLjM64RBphYHzI9AtzP8hyPfgzjPPx8cE6fItZxvHCE+8AMv?=
 =?us-ascii?Q?VBpTP6iDoxzpMZ3PHbM5pO1Q221A62ECffzv5xgTFKlCxn7qGWcdg3/qPPJJ?=
 =?us-ascii?Q?OE4SPD1bdYF0f1f+POITHtHksy5OV98huZYcRduEyiwQyfMNlRkTZ2tIHNjd?=
 =?us-ascii?Q?1y0UsiVZF203IP9mEjkCywuwqFgvqUoZ6+XxWJqIJAjaYx0qINGQzW0AJb0R?=
 =?us-ascii?Q?Bmd3iZKrgXEn73w+z7hQkLVLysgsdO8H4guI78K5vq4JbnD9DLVOQBGwyAi0?=
 =?us-ascii?Q?LTSmKFb4LpyagjhNgopOF6QCzF0p7d6hBMN9PpwjN8NYGYu/Zcs8i1VkEDfc?=
 =?us-ascii?Q?hhy7xPUeZy01WyAn8rlJx7OrPKd0r/5ka8gqFMB0ZYkmMCXJDTXHDEhSvlIV?=
 =?us-ascii?Q?gGeJElp/ofHL1Xvgo+39VSFRmLtflLqqMSmY/J9XYVqaVMV8Yy+3Rs4s1n76?=
 =?us-ascii?Q?6gxlOInHe9Pt/E8xJYLndX6g28UkxIV7NkmtD3j3hOqOozKy2ptTsX7+clvc?=
 =?us-ascii?Q?mnYiU1wYAOkvJLa7yKeCmc4jDx+f6Ar7elaQmttK7ILh0sZs9iVoRJKtiXOn?=
 =?us-ascii?Q?Xfz6o9xQarzujc6LarEVaiqRAzEakZofj2GTkyHCtHt+zsNhTwJA0apXQzrI?=
 =?us-ascii?Q?xZRvfRiFfg00xHPH+F417gI/522NDUP7hY3XkbXdJ8lsrXojNepuHG0Jghz4?=
 =?us-ascii?Q?i2She7z8UmqxV6hfpOLFhlVs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d04c0c9-9304-41f5-db62-08d94b66ada2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2021 10:11:02.0085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MkTcGJyig2cFft0+Qv0jAn/hRu+26mOto0dmPXYfA+59TfoWbqPPTcNgcjectyovOC3L1jF0EBoeiGBngsDKew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5078
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maxim Kochetkov <fido_max@inbox.ru>
> Sent: 20 July 2021 08:09
> To: netdev@vger.kernel.org
> Cc: Madalin Bucur <madalin.bucur@nxp.com>; davem@davemloft.net;
> kuba@kernel.org; Maxim Kochetkov <fido_max@inbox.ru>
> Subject: [PATCH] fsl/fman: Add fibre support
>=20
> Set SUPPORTED_FIBRE to mac_dev->if_support. It allows proper usage of
> PHYs with optical/fiber support.
>=20
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> ---
>  drivers/net/ethernet/freescale/fman/mac.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/freescale/fman/mac.c
> b/drivers/net/ethernet/freescale/fman/mac.c
> index 46ecb42f2ef8..d9fc5c456bf3 100644
> --- a/drivers/net/ethernet/freescale/fman/mac.c
> +++ b/drivers/net/ethernet/freescale/fman/mac.c
> @@ -524,6 +524,7 @@ static void setup_memac(struct mac_device *mac_dev)
>  	| SUPPORTED_Autoneg \
>  	| SUPPORTED_Pause \
>  	| SUPPORTED_Asym_Pause \
> +	| SUPPORTED_FIBRE \
>  	| SUPPORTED_MII)
>=20
>  static DEFINE_MUTEX(eth_lock);
> --
> 2.31.1

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
