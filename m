Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC94D3EA0C2
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbhHLIm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:42:57 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:63085
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231786AbhHLIm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 04:42:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYh21VA76298zTUOEvzPPWuIODP4Jdghk2GHVWA3dNss9ri8w3UJAmHj9fMgn8lbdIrsXwGC2i5evhQtjadjr2HgcJn5m/aISHSjqGSsUrQsDCwPolPW80hDOtl52/QkmqKDINDbWwnAVvwJTnjqQzzRIlHLC406QRdaUdBwz6676EKwK1Tsxq6ptKmXX6eIxqfb34RI4MWw/emehCmu2yzQMt/dp5fWRNFgTG88Bbe6LT38tzm/ctCA79EWu8FYbu4a2LmpfWQMsT034NRMzbWnpCrO2HkSbR0vHPbgNIjtmy6+VIWQvQeJwBKY9TIkA1/2xb2AAp4hgAaA0DApwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAk9V9t/o0/aLWegjh45d1GfeSr+GY2ORW6YZNsZjxg=;
 b=dMs/woPM91agHH4b+mIFukatAerbkASBwBLkozQ6AbuTH0RNusz2YSkSp3gJaGKyLJRZuLGAZ1wNLnZkvVXsXe+f8t/Qseph71cm4gtofWUrnBEVRPK74fhkYEec4mquN+3yXLGKZAggCOBcnfdr15Y9deUpiX2B+drKNrIjRR4Ix08xkiEV5rjxCixNd6KzxIc48CZCrBOxIlKkU5sljve16byI0VVqaP9Hdg6tdwO8BQxqXaorkQpQZ26SclUDKUPuLtqwxzEvfuDTisNSXWcu6Lj0D+gFFzpo7HQF9aWtPW4S89KANFUhBT1SpnpQURPlNqJ2aJkB7tE15DMOSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAk9V9t/o0/aLWegjh45d1GfeSr+GY2ORW6YZNsZjxg=;
 b=c+kO1BlxdW/FcshMib9v/d8TwkydFSar952qWxmHB+ynEPYN5vqGassuVi9tXWqxrpBu4CGidQCr0lXEzS6hVuK9gNqOgu5Lrn2ANU4PpzYEZcO/4HcNfwv8ILW7GsPVKMwe76Ux+O4BzegYrluNJcUstOFzwkCScA4lnryyv4Y=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AS8PR04MB7656.eurprd04.prod.outlook.com (2603:10a6:20b:29b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Thu, 12 Aug
 2021 08:42:29 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::48d7:fb2c:38dc:4f5f]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::48d7:fb2c:38dc:4f5f%4]) with mapi id 15.20.4394.023; Thu, 12 Aug 2021
 08:42:29 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
CC:     Randy Dunlap <rdunlap@infradead.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] net: dpaa_eth: remove dead select in menuconfig
 FSL_DPAA_ETH
Thread-Topic: [PATCH 3/3] net: dpaa_eth: remove dead select in menuconfig
 FSL_DPAA_ETH
Thread-Index: AQHXj1VsNzsUTnII/UWblHLiVegTM6tvjQ9A
Date:   Thu, 12 Aug 2021 08:42:29 +0000
Message-ID: <AM6PR04MB3976A72707A65CB74B11AFFCECF99@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20210812083806.28434-1-lukas.bulwahn@gmail.com>
 <20210812083806.28434-4-lukas.bulwahn@gmail.com>
In-Reply-To: <20210812083806.28434-4-lukas.bulwahn@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca91f74f-dc63-4c7d-172e-08d95d6d1e9e
x-ms-traffictypediagnostic: AS8PR04MB7656:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AS8PR04MB7656A4CA521E06FED49BE561ADF99@AS8PR04MB7656.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JwCrSb/14379eX80iWHqMxPu938hk445coXwwbKYqDaTjADU8oWK4TlRMwOGXCIynJI4fGE7RLyZ1tATFWBUpBee/ZtJHC2AUFIYTK22QlC3BrUaSx+cEVk9TmGGC0Q97b95nyWWiqddsJ/RqQ7O1otCJWdlthdnStiuCUUmEBIdcXDFMJ0OERUDFzmGZItVIDn3vmwKacKAUdbef+J9KBCT/KPV5mgV59Tjlm2IRA8gTvW8SZB+AbBfVfODbCxoUAr4MKsTcxCVuMLNmIBCdd8y+U9uCm7N81tZlO23Q4f934+dHcZnU9mRwQS0YCD0VHdY1Gozs8QpL/Sx2jjcF+wzS+lUo08b6QW3XdT4ZbQ5Jlmp2G+GYXlerM+X+XLR7LxuqsjYiMDhuSEFJu5C92/3JUWSaaw2SoT2HlCyQsYs+gcDBXOclYdNL+WnteyNAjkD2oUSIQSuiwfp120Cc89lXe5NcY7Opo5b/Fv1cYDkTU3qSNRCNF3Xzs6UUnpbDDj8AU+tu9OD31c8dr1CspOicGBwwmPd8o7jgPHi/9DMnPytVdbJIyQtggKJNPn/qcC8/C9vVt3ecMWxatPXJng9DQehwH9xg+Z0mWieIFSD6ubTRCwM0sdLJHAbuj7lLvRyf1c8ZblY3TBLkfPV6oy11LkbZisMSWbPlKYzuAUDlfpXJ4MyW/+BH5PSKstkfhdnPFymsaeudFjs5+BDSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(110136005)(83380400001)(7696005)(316002)(66446008)(66946007)(66476007)(86362001)(66556008)(64756008)(508600001)(33656002)(38100700002)(186003)(8936002)(122000001)(5660300002)(71200400001)(52536014)(6636002)(8676002)(76116006)(2906002)(38070700005)(55016002)(9686003)(4326008)(26005)(53546011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+FznP6vCM8Kfsp+RWDYZOrriq6xcODjeDewllxY8lwVAgjtE1u+dBT36uMVb?=
 =?us-ascii?Q?zB6yEwyKvIkCGUpmCeYMCM3T0D2EVoeQyOyhUqzgdFRvcuzDyQ9htKbW9p2/?=
 =?us-ascii?Q?kMCZ9eFI+V3F+yX1BByNx9gh7Bk1uYfiHYnt/8NZzAsPmo8QLWvS9Uj1bVYH?=
 =?us-ascii?Q?DcBdLbSZ79G4HI3KZ5pNdKWIh9Yt8XcvHSFjywI7KXTgcZFVnW+XHtcHqoNa?=
 =?us-ascii?Q?LV1V+r8idYEcB3I05Bk3HFXYM+T+a+98PtSYYFSk/sJo6jROc6aogFOfw56g?=
 =?us-ascii?Q?yzvARf1jkH12eHNfGW6hziD4WV1bQkIoAowTVVgbcjGb00RN1qjKIbtdQGrS?=
 =?us-ascii?Q?0CsMQftEsOjyYV4FDUrBNUYF4eIPxsXq0maxmhwjOEnMQE56tb5xuuF7ODtU?=
 =?us-ascii?Q?q/96waLe/9fQRPUZSeW6W+lBEVjnKwXup+hYORH/AJcUTYsuitqN0B6KtiGo?=
 =?us-ascii?Q?kg99yLgKlKaZJzFizkN4sZrk4Wm+KKVTi5WNETZrvfc8pknQop/5N+cz9hgU?=
 =?us-ascii?Q?ZWyf3757OfeJh9CdQUFFlmtuJ88MEBvMo4a2iZxNZK+2utV683SdhR5AjwwS?=
 =?us-ascii?Q?tfPA4aGbj2UFhk5KeWTOL6N/iNhEzfJYSYmCeB93JsAJhUBuF4p5Wydz7BzE?=
 =?us-ascii?Q?ozFdODFKIidKfgzWpTMw7OB0CL95t2rneTnSYWdR7K/2YDO/PwXF6jLCSTs8?=
 =?us-ascii?Q?l9O6kPEB3gPVkZ8Dh8UbWoVZl8IuhGwJQpbXA9XM+RbQodunvsvAu2+4uciG?=
 =?us-ascii?Q?dnWddKMel4o9dLFoPooOicwy6Fz2pCie9u8IyfsPmdqw1+QaaxQXJz9tUJ2p?=
 =?us-ascii?Q?HThYdKP08j063ES925qYIeJyESchhi6qAlJxFf6kTqR6DyG7vNCRH+cqR8C1?=
 =?us-ascii?Q?y1YkM+dAeP35W+f5l5rwRqZ3sia+RxYcnTmzh9KQpzqLQDadj/l/PYERX8Gv?=
 =?us-ascii?Q?TsyndH2wc260Sc8EUe4mEbFUAEwfGFJoccTUeQI+OGnTkplw1x7AjvZFn5AG?=
 =?us-ascii?Q?Vt40o6CI891/sYZBiX4rmd15rnfhPSIiIvDKy9M3iN/hO7HJ253sR5qJTQX1?=
 =?us-ascii?Q?CvwyZZ9Afajh9ve/cQXgx2Xri+sb9oxHCJqgNedEMxgqtMs7oDjCrTuEpakt?=
 =?us-ascii?Q?zAZBqTNLXrqCEMX9z7KRmGCkdFuV/Id4OvOrK3nRU3+Cz7GvZHu+4JvuETwy?=
 =?us-ascii?Q?G7gJvozXhdJshcxJ6OkMO0PrYsxdsXK/h92ojDJ6SNFTUWUmxw4Z66ln2xKu?=
 =?us-ascii?Q?EKOsedruKGaL5LZjKZ/i59MKkcPeNbbGmGoVGndSfjJRSqjw+Q5x14ZRWlnc?=
 =?us-ascii?Q?OJROTwT3qzQKUeR3a7FE7pTj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca91f74f-dc63-4c7d-172e-08d95d6d1e9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 08:42:29.5391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hLZGDBL3980k5ZwQCXYzyCOJQ/JpNJntp3PbP7J+m5TrVANz785dHfDqQi6cqBUcvdIHgAZfOM4NnCi8XQmeOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7656
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Sent: 12 August 2021 11:38
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; netdev@vger.kernel.org
> Cc: Madalin Bucur <madalin.bucur@nxp.com>; Randy Dunlap
> <rdunlap@infradead.org>; kernel-janitors@vger.kernel.org; linux-
> kernel@vger.kernel.org; Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Subject: [PATCH 3/3] net: dpaa_eth: remove dead select in menuconfig
> FSL_DPAA_ETH
>=20
> The menuconfig FSL_DPAA_ETH selects config FSL_FMAN_MAC, but the config
> FSL_FMAN_MAC never existed in the kernel tree.
>=20
> Hence, ./scripts/checkkconfigsymbols.py warns:
>=20
> FSL_FMAN_MAC
> Referencing files: drivers/net/ethernet/freescale/dpaa/Kconfig
>=20
> Remove this dead select in menuconfig FSL_DPAA_ETH.
>=20
> Fixes: 9ad1a3749333 ("dpaa_eth: add support for DPAA Ethernet")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/Kconfig
> b/drivers/net/ethernet/freescale/dpaa/Kconfig
> index 626ec58a0afc..0e1439fd00bd 100644
> --- a/drivers/net/ethernet/freescale/dpaa/Kconfig
> +++ b/drivers/net/ethernet/freescale/dpaa/Kconfig
> @@ -4,7 +4,6 @@ menuconfig FSL_DPAA_ETH
>  	depends on FSL_DPAA && FSL_FMAN
>  	select PHYLIB
>  	select FIXED_PHY
> -	select FSL_FMAN_MAC
>  	help
>  	  Data Path Acceleration Architecture Ethernet driver,
>  	  supporting the Freescale QorIQ chips.
> --
> 2.17.1

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
