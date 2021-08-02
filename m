Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733CC3DE0B3
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhHBUbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:31:35 -0400
Received: from mail-db8eur05on2071.outbound.protection.outlook.com ([40.107.20.71]:59393
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229729AbhHBUbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:31:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leFN1t2HFat3wg4KTiddTl2W70Q2TRbul+ckPGX37WqOjABjx1pDgvMh8CcMbdhGa4AruU2iOaYx8pJFE07daI/XGWB5PdfBzJ/1qPbYRGA0quL+JSIqj1QZhIKFlUkaLqI/FidxWSfDH+0T6RUdHRZpG7oQzfWJ3vj6sEXUobQiAh64Go5QhX6Vqv5PJG6i0RDpHI9b8NN+FpOjCdQREJMn1CMgkweWqGx16FIvoY0BG+agPntwKZ4BHDcPJe1RSuO36/LkRqT8OGfulpbash9+W0pxPZ9zmERIY4tL9w0/DxBZaUBX7NScABWx6qlu623DS5vKiFTz61Bkt3pLOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNz0nUrEkuT4hV8Y5WYeEf8L3XXFIRwc0AK31qpKZCc=;
 b=Msi1SVai1XWR/d9iJNMEB6OsuifftGzHFDwLTwIH/HygDQtBWUZP1eqfaVcxMmlLxDdqw28XMwzF5KygKyo1i0tEQ39Qq6OhPCWZi6A5YOzVfVMWS0NwAdn3ttaJT7TKHaHVKrKf0m1jb7KSRTDauVxBp2rYax723ZgTrwUwJjd5rw363PPPifmHUVKTZAhx1aaqvh8hFgCba1ud8nfoYBjMwcsZ+Hf19dmg1kV6lNsbU0QWi651pXCzDnMF2FXltg2o9nRL06XJMTIbhdbaIiDC8E02owjFfkZv9X2Z19zS+xYbvrP/pyTkX8zNAi46nJkM31ou0EmyMHIrXlEjCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNz0nUrEkuT4hV8Y5WYeEf8L3XXFIRwc0AK31qpKZCc=;
 b=PhVTicHDlxM5ZW7eLp3X4HUofOVjsUMExbgQraf7rWZ0GAVdi0pw0gEriMhNiV9VTTlyMhGNRHuEpoPUrZR5hLRohQxbpo1wWaAkkOBSIebcjMQ5liwddTbxou/u2CyA3+nsJ/Qpkv4n6xYqMoxZYcoC6YEEiHo+HVf3Ss730Ug=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2512.eurprd04.prod.outlook.com (2603:10a6:800:4e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 20:31:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 20:31:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Mark Brown <broonie@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Thread-Topic: linux-next: manual merge of the net-next tree with the net tree
Thread-Index: AQHXh9yVdl8lK4R1wkyVts+VWcD2T6tgqvsA
Date:   Mon, 2 Aug 2021 20:31:21 +0000
Message-ID: <20210802203120.t6yobpb6r7kro2c5@skbuf>
References: <20210802202531.40356-1-broonie@kernel.org>
In-Reply-To: <20210802202531.40356-1-broonie@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24c5d209-4239-421c-65e7-08d955f47d45
x-ms-traffictypediagnostic: VI1PR0401MB2512:
x-microsoft-antispam-prvs: <VI1PR0401MB25123B8E1EA320136AF1EF0FE0EF9@VI1PR0401MB2512.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +RUCWlPs3BNcYq6mX07FhXskBxL9sCIuZ8+SRJk6QPMU3bMedHOUVP+EzFQ8HOKl2IP6SvW/yNW6aBsDL0nO61KcJt2GwiysUCQsji0fpqeuOXxXpToC7Y4l+AQS2a8zOiIJiOUkUyYf8bXIT4m9wyzYzFA9Bp4lFxopz/lhuMuCj2Y4LGwuZGgWn8uwi5yGs5HCm4PGqx2L4uwsLGq48vsR/U/xzhvZi5UWtb8ShQWGfN2AD9Fd5o9Imqi3reCcTwmGHng4ak/XI/fQcrfFoU4sBmn8DkD+ddyToepw2c9tjz2rYslpzxuULIt4uhmRPHe8kXP2/hUPo599XKh12+3x02/RQ1zF4SQCr7j0+TY/6bwXSVNxpHMLw5ECn+EhVV1HgUSGWM9I+lhlfQn1nW2S1ILXjuN7obwGBzW3NWBeAIokDUY3e1MJkbPUK4zKRgIUqT2GFznkwdBghOaj91weB4ZSLj2C/SOW8tV1ADLGF1L97deEWDJmoaG4X0xPolV5X7LZY5KnI7rvaTzL3fBPqNG6hBboPt5PSTL+RLKCPTE9/mnIGJKl9UjFBLk1IdMhhKcrGZeu8L5fIg61nS3ocHXIzWJIXH3JFD0hlemZK0+viFoJb7WHykf2jGAlFcTNPy7IN68LtHh70C5PB4E2a5JGcUHJsOLhJ+ogFtEPqmPBuOHfD24V2Lr6Afia
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(54906003)(26005)(66946007)(33716001)(5660300002)(6506007)(4744005)(316002)(2906002)(83380400001)(508600001)(6916009)(76116006)(186003)(1076003)(8936002)(6486002)(38070700005)(71200400001)(44832011)(4326008)(122000001)(8676002)(6512007)(64756008)(66556008)(66446008)(86362001)(66476007)(38100700002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4t6FeiBsWe+0bGUU1yyHYulOG6qbMZN3KMo0K0k3QhSimVWO2q4F+NE5xJlu?=
 =?us-ascii?Q?eZ60MqGV3nD4T6Sv3ppT8cHq4/K6l3F9j1Vw3nc8PlfOkx5ZAhMo+I/lO9RV?=
 =?us-ascii?Q?sZLBlQv7i9YkpfFOUbrjEFR3Vvv6vZFKmGq2aBFeiQI2aBoPEAPgqozzRPTT?=
 =?us-ascii?Q?Q2BD5ytX676TdINFOM+noHUneIeHBUVcU5h7HuYmoqfL4Z5ZTxMkhfE8KB8F?=
 =?us-ascii?Q?T2IF4ZzerlBzAs1jD+ogCLJW3wvxytpgHVo9qWyuCIPP4HM8ZcH7/CbbNbYV?=
 =?us-ascii?Q?x+/2ahiCdrDtkvJb/NUMBn+b3iXPBuBVmmb2gKWc6LVmeZ3eTIoH//7iW90v?=
 =?us-ascii?Q?xsQii17Czz9ug71TqoubL8/MroPWa3yUtlyZrgmC1lJBDsL5/bdRSQKQ3vmD?=
 =?us-ascii?Q?dRa3ledQHmJdgt94aoC/jYZR8RH5JLPCx3Pk+R1Ups7BW//f6RagTYvQBs3H?=
 =?us-ascii?Q?jobY8XnEvYdjf3yEa/kI/eEjruIq7qMv0xRVB3bOn0QPanz5lICMgJJr4P67?=
 =?us-ascii?Q?6WhBoBgzt1GLto02hF5vs1Sc/f5i3+tlRkSbB+CnjE0gWRQETPoKMYJsKpvv?=
 =?us-ascii?Q?LkOkTOw9by7TrbU3QBePCaLfPqtXYLPM3BiLnlYubOozGkTbSMIgR1YIjBoA?=
 =?us-ascii?Q?SP7psvJxHJnq4DKBYwFzLsCU12+FE6gY2sI1rr+7cU9YNg3hbD0Eny6k/HZd?=
 =?us-ascii?Q?d2V+4L7U49S7MOFJeCDxBGjeh/mpY79c/w5VESEY/zOAjw3dqobyjo6CIa6T?=
 =?us-ascii?Q?sV4qOq0ypn+e3Pthpz1xpO/ZfU7oSCki3b7HRiSn6DfbkhqmMFkTbU6T68F7?=
 =?us-ascii?Q?3gex8PR4p5BRA9dZXdN9HM0hT/YG1ZDAUr+kg4JVej+kUuGdCt94LGn0w++l?=
 =?us-ascii?Q?m4ILgNk2n7PA16lf9lVOzG6U3X1YDf/s5QtoU9TA874d7nCkcxD6LVduLFXR?=
 =?us-ascii?Q?6Ii3e4Mmita4nLyaa8QMaAo+qMR1GvDDlZMRz32Xi7IPLiPo3B0Grz0YFtsM?=
 =?us-ascii?Q?Zp1DEGhgouW5J8JJfLoGFvn0iv7p+p0tetGEkfjX6eihl2uJtgxlCrD2PeLi?=
 =?us-ascii?Q?9KWVVXSK5XONWpwhivJqrMXKfcqwf3oSXGJEtKvabVQ6ZFB1N5SfBt6571+c?=
 =?us-ascii?Q?g4hMRBfbQELNr7QuSYhIXLPg3yn2Egv1KzoEtjhpi4bx1vrl/FJAln/ZcvcD?=
 =?us-ascii?Q?RMmv/H1C95LMLl8enUh0z68wdKINQkOskDHxyZuHCTf26SNx3Ct8EX78NKul?=
 =?us-ascii?Q?RBya+brT2tiudJkgI8TWCrMCIvcbWiaOR47bDPFjbhG7b1TN+m8kSEw3hbbW?=
 =?us-ascii?Q?MXSMt/WuqJ296NoORXaElMHR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E116F9721EFEAD46AC751002D5889F28@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c5d209-4239-421c-65e7-08d955f47d45
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 20:31:21.0347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9U0b6RV0YtIRHeXzlVvQ0aQ2RMQAdBsnEK/v5OWW7APPwZsQVEsR566fvZd9okY/kCwtw9PiHHNPSGJ1JDrFog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Mark,

On Mon, Aug 02, 2021 at 09:25:31PM +0100, Mark Brown wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   drivers/net/dsa/sja1105/sja1105_main.c
>
> between commit:
>
>   589918df9322 ("net: dsa: sja1105: be stateless with FDB entries on SJA1=
105P/Q/R/S/SJA1110 too")
>
> from the net tree and commit:
>
>   0fac6aa098ed ("net: dsa: sja1105: delete the best_effort_vlan_filtering=
 mode")
>
> from the net-next tree.

The conflict resolution I intended (not the one you came up with) is
described in the commit message of patch 589918df9322 ("net: dsa:
sja1105: be stateless with FDB entries on SJA1105P/Q/R/S/SJA1110 too").=
