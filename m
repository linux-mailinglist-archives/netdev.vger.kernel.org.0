Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF5E435E11
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 11:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhJUJjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 05:39:41 -0400
Received: from mail-eopbgr20048.outbound.protection.outlook.com ([40.107.2.48]:57270
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231475AbhJUJji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 05:39:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZR7Glo419vd658u5A801nnirh4MzA6iTNscS/1REb83iLyEMeS9YPTMSquDX7d0sKqjd64Rl4SCdhuILnb+zdfyFqp6JAthImrX6rUpjVk5ACK0NwN7TPcjqJUwXBO4Hn6cbd7gUvYrHPc1kPJGHJlySlVqIafov9UI2gwMoC7M6rw8gYnb/lAXRWIylwd4/vgr75bdTKrhbiq9KD+T77BUteh1oBEEbwocrgEe22o6hjNL/xVI82hltFQgIE3TEXQ0sumB9mh6IPCYM4MnAACV0/ZITuqRoMw767CapMTjl0Hv8N9pskxF6S/a00nn3Yz33Pyx08PiV5+WQkY22DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTbgQMaG0UtNTn5ECHZQFu3jxi3UKJ0rsuX1adMvbpg=;
 b=e/QkBXnzIVkiR0p1CGWp7omBJkki49zl0M7yJ78csR/WqWc5SV1Wm1RirAsydOR8E3k64uVkMH3HZhyAvW23SGVDmTEstRpsptilunF9mdeiNjTHBknFGbiy5ax3pJUZH6fAMwuoZz5k//rSWia5I5yX3GEyx5yAK0IjpObK/CSZUOF0qN3hkr6O06cScKwarMy5eytN3Htjb0hW25Un00qnthyZUkEhdXpY2ZYUms8BoAi7mjpMguH6CZ8/gqqkLJwBsGcQS8IQzF/jXJ6gpveH6QNZqW+mXCa32GxzM3GQl2D89hnLRdNQVMrq1oBFbvScLKkW7gLbNJKLUlDPJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTbgQMaG0UtNTn5ECHZQFu3jxi3UKJ0rsuX1adMvbpg=;
 b=pqf5Hfk0LGev2+L+j8VFdzTz/NYd/8xrqrOfb0AHBjaZZvtN22dqMxi+xj7vrP1Az6JL3A0G3YVrX6/VCZnxxIcnlUkl70hE+eVeKsXHA108mXL6AkHYYqTfjwvCzvBU52cnDMeZ98pBvbdBUJ7owHqVmHw6rpJm8K0tfM6NDLQ=
Received: from DB9PR04MB8395.eurprd04.prod.outlook.com (2603:10a6:10:247::15)
 by DB3PR0402MB3673.eurprd04.prod.outlook.com (2603:10a6:8:c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 09:37:20 +0000
Received: from DB9PR04MB8395.eurprd04.prod.outlook.com
 ([fe80::d8af:597:3279:448e]) by DB9PR04MB8395.eurprd04.prod.outlook.com
 ([fe80::d8af:597:3279:448e%7]) with mapi id 15.20.4608.018; Thu, 21 Oct 2021
 09:37:20 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH net] net: enetc: fix ethtool counter name for PM0_TERR
Thread-Topic: [PATCH net] net: enetc: fix ethtool counter name for PM0_TERR
Thread-Index: AQHXxdLXmfATDocqqUqtFHyn0HQoSavdMdpw
Date:   Thu, 21 Oct 2021 09:37:20 +0000
Message-ID: <DB9PR04MB8395B43BB0033D177A6248C696BF9@DB9PR04MB8395.eurprd04.prod.outlook.com>
References: <20211020165206.1069889-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211020165206.1069889-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6eb7d20b-cfe5-4150-8c5e-08d99476613d
x-ms-traffictypediagnostic: DB3PR0402MB3673:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB3673B6D959903BC664E8850996BF9@DB3PR0402MB3673.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QPzoy2MzVY9FSBbwcvQmzdFjsscxGWkQMprdgyDYD7fCS/PpXux/xINh1hEPMRrBA6+qRrynqiaKk+X0fX9Jq7q8jgTa4iy1Ox3wAm3eqk5JauXMCDIfnEqRqaY4Aex4nS9R2xtST6QUJ2ezjBNXGs88FEtU9JufQ078rrX+HefkkV+I/Obv/8vUNacxnfb2eTcXlVEuT8QQa55pjbaakmHIWgziISHg395R3sVMSkXq3uOBJG+kSrMmvOKv0cMeN4HWmNFfOQwNxcGUf6aPJcjrsCiYKAHOdZ/kWjXJ09OSJbzWrahYpQeOYg3cOTU59HErBJIgWr1tJTgyVqvJQM1DaMjq2mNK0s5jaqGzbf+pbh+p0PoEG6ZJl/ECr7hGZ/Za1izl1TpXdnyqEqGKppzsfHMmpFnzdrJiw2UEx71aPamBMbRyf/a7/SHdohhu9AKKXmRJEjgD+jqNXMm0CAPJEgXAQu2axATGs3GAKDc5/Dz/21tF1wUiRGesUJpe2iEpI/It5mB1WPEMCZDcYURfp2Tq2BXJvA8WT3iPkxNfUnCRroMqGH2NlXKsGJbniP8+x803oplAKLDCHiSaiQ5vGynpNnplLLONULmOxWRJSyH38kxNlu9LZ3LlUCuC5o7z/VlL4caurEAE2gycO16T+FAmu1riGpPX6Gcd08wpbJtKZiVFc6pC78moXd1tYEr9UmhMU7Qc3MNAP7Un1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8395.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(9686003)(122000001)(86362001)(8676002)(52536014)(44832011)(66476007)(38100700002)(7696005)(316002)(66556008)(508600001)(55016002)(38070700005)(66946007)(4744005)(64756008)(53546011)(8936002)(83380400001)(33656002)(76116006)(5660300002)(6506007)(186003)(26005)(2906002)(110136005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qeopEthzpnvi1pZ98VznITQ/oTFnyj7DtfO+40u+ZrLdFW7A2RP+ZpKqQhUI?=
 =?us-ascii?Q?PC8UNps58tFQmjhFPGwofLT6sD3jtq+pDgupaWoq/SvauNXViWoxV0XaeBGG?=
 =?us-ascii?Q?fmumrBqwPapADna61aiWcnAzeSC/BarzcC0GgmplA5ikRBHwEecL+/Vp7J9r?=
 =?us-ascii?Q?bIC/xZb8DRrP5GIwvIwDf11P4XQyk2nugSdJIrW990eLJ3qokZWoWtNoiet3?=
 =?us-ascii?Q?0Uh2Rdov5czZl0GlUgCKZC3Wz4p2vQGdRdUQ4coazAHShuamhf5Tjp459FGH?=
 =?us-ascii?Q?GQRGTiLtzyxzqjcyS/aCHESHjaMsqckHX/rMe9kw8SRmOs6MTC6SNeP7qdoc?=
 =?us-ascii?Q?ri62K1WrpmfoMy6oes3K7aZy27dZcpWgnTqtcxI0VOpvZq1Fd5u7NBLex5Fj?=
 =?us-ascii?Q?xZy4U3CMDuz/1vLLt5yrbo+VW1kmDoT0iteig7+/KclHIjIOUFI8i9mq/Pc9?=
 =?us-ascii?Q?MMEd9hw4wkz5J7hht3ZkwVs9Dq9R9ngb9Vf+rqQ9sPJ9dilGbcUWTyGuAfln?=
 =?us-ascii?Q?nxyb4zO38oSQ7bY9NR4q7gDp474CLabAdboXRK8Ma4qqMdaz8tqZOPLtOobD?=
 =?us-ascii?Q?vZIMNg08CwQLclWc2gOl7UauUv9WxHN4qJCCC+qEtnkxW+eSb8cyKjVLYhLQ?=
 =?us-ascii?Q?/YwhQSIey6DGIe3tOPwFZ2etQ0roC4+gDUGNALc/ERd3vsBL2WBcukNluxF0?=
 =?us-ascii?Q?2LL/sslcK38SGeHLM0koENBIl318d5COqBWWOc8admlpsKR++SWD0z64d5L0?=
 =?us-ascii?Q?iTklZ+k0xis2QhhSebKrSfFzWxUES0R+9XcPaMnt08PZCzmNGgHh5LsHNRNd?=
 =?us-ascii?Q?+xKgm21pu8HBsUl8QV9Ts8Lk/8MB9+Nog/L+XxzMjbjf+Tt4OXG2Z8XJnT+d?=
 =?us-ascii?Q?OuGxJeYLiG2mrK7RvdMOXm++H+1mMdzevaRnYjA/0rGTuooux8u03kepX+m0?=
 =?us-ascii?Q?mNU2LRTnveNjVzBeKlSmYnUAlKzn9XojODVSUO13Hjl2VqrwyKwVzGhErvt+?=
 =?us-ascii?Q?30KUOmfu7XNmieSICHyByfIhbrAKfIwRmJ5N2bY2yIBvtRlK8lC6Vlw4dXpi?=
 =?us-ascii?Q?NgNJRfFfqCTZe+XLcTnMyEcUrmPYlZ6dUaClJtnjB3jauZEuvIcC3hiVqN7n?=
 =?us-ascii?Q?R43jE32P3vfwxhwlHQiZiB0QB3Nis7egyEOxY8JtMdVPQdYtTcGIwAk+hpCv?=
 =?us-ascii?Q?B7T9h/qyfYjez/08jbbUgYT7ys5HY75fW5z1cNKuxSWEy5jUA3023KiPFGAa?=
 =?us-ascii?Q?k6lATFfXsmz3aJGa3c5n5RC0ezP860jMAac4Ot2VvCmimD0Ihmuk8J8sCc/Y?=
 =?us-ascii?Q?iPQoa7AZ9ZFhzv0osrb3+hyk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8395.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb7d20b-cfe5-4150-8c5e-08d99476613d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 09:37:20.6319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: claudiu.manoil@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3673
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Wednesday, October 20, 2021 7:52 PM
[...]
> Subject: [PATCH net] net: enetc: fix ethtool counter name for PM0_TERR
>=20
> There are two counters named "MAC tx frames", one of them is actually
> incorrect. The correct name for that counter should be "MAC tx error
> frames", which is symmetric to the existing "MAC rx error frames".
>=20
> Fixes: 16eb4c85c964 ("enetc: Add ethtool statistics")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: <Claudiu Manoil <claudiu.manoil@nxp.com>
