Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA1827F22A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729645AbgI3TAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:00:40 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:54457
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725799AbgI3TAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 15:00:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiU2Vy1ZMw+yn/0PRplRKFWXn56rMQBOl26Xo9HslpNMgAJJWBYQnIoZLvqq3Om0pf9GAz4oASoiKExXMIuHe6zqDIw7V64okXAcrH5pRDKuvrtR2EuS6cJHQ6BOIHnA7GbqzdVe1suWQRFuxWajthkxGbsF9WM+NZKkS0yBIz5bZNpHvMTTNBbkHy3kGFUnMZavwdrkLYeAd+2g9rpWCUhQ5px+mzzUdgvYyNAYp2TABLjBvV/KcyQ3nTkVdLhgK1NKBOfww6Syz7lT7191bFgYotO1dsPFYR3xjivaiW9SaMWNBYfewPBOVwPQR13QX5HUkNXpaaHmvlXYXrjFeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5RNsFNvLcyhBNLcfyjQ8q6oaJbQIxb8PlgZfha6WvM=;
 b=HhHpoUemjk28z3VgvpvzXC/HbtHxn/ga9cRSeJ0e8KgldDUoz9YRUwfZWVCjd/gMqiNruoIZ6Vfi67g+akDRs0LwCXP6xK2M1GNoCD3HsMTej5iK5d5+BmRVaPXTTiHxfVYwhopOqBPo31EWOKIAICQao3F8vlQRjtlsdzgFwdoMuSF1IDiL4b5cTwK3KLPKq8nTdn2S3Pr0ox6MGZEM78L35tGdoks0JP314blx6auPbV9oevP+lWnWL+V5yqaZKG4FHJ/QK0vvIZ1nL91b4qRhoMEBG3CQHAhVcuqPe+FTd9gJr0YyAH4AhDrEcxNOaExym7LbIvcShyuXVhfAhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5RNsFNvLcyhBNLcfyjQ8q6oaJbQIxb8PlgZfha6WvM=;
 b=CSwb9khtHL0ZLn6TvwOMUJio6kAtqKGzKPB6JOic5iN6V20sGYKVZUD5AOPD6MJ3RlRvhiAKqorVojNnXbyc0zVL5aoCmg0Ti/D0YR05okJxD/3bkQ5g574ChezCp5qYF5yon3bx3WXpfvLeVN8aCHhYk9vhz3SI2iAU2UB1ixE=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB7007.eurprd04.prod.outlook.com
 (2603:10a6:803:13e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Wed, 30 Sep
 2020 19:00:36 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 19:00:36 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>
Subject: Re: [PATCH net-next 3/4] dpaa2-eth: add basic devlink support
Thread-Topic: [PATCH net-next 3/4] dpaa2-eth: add basic devlink support
Thread-Index: AQHWl01xeoMMuSGY3kKylyKku97egKmBePeAgAAQYwA=
Date:   Wed, 30 Sep 2020 19:00:36 +0000
Message-ID: <20200930190036.5z4bof5sjieddfmi@skbuf>
References: <20200930171611.27121-1-ioana.ciornei@nxp.com>
 <20200930171611.27121-4-ioana.ciornei@nxp.com>
 <20200930110157.55d85efa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200930110157.55d85efa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f7759f04-909a-4622-0a1a-08d865731db7
x-ms-traffictypediagnostic: VI1PR04MB7007:
x-microsoft-antispam-prvs: <VI1PR04MB70076C92825A860D72AECC56E0330@VI1PR04MB7007.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P4byQL7dCGhkg6nOZktyCMK+12H56JqttJsdKlu/r02hMj/hcGWC5VieLvDc66uPKbzkXOsDAFZAAT9CTpHg76GgnZ2tB5tgBTP3/jAJYHq0N14RG9pjz7/23HBwGY58FowmNfpsS4Bf4k17NHdUqBMu/Bu6DEbBnjDq/QO6kVnhNkhAuo9oRbo57toB66/vClA6yKidhKqteDy+ttFW050s5NbzfqXEBiWnSeRpSxm8HyNcj6CTBjET4pyisDIJ+7FKgap8Skoi89FKmp+SnHn/1VOp/I7tG4tgTHysVXcug0m+qEgnJn2Z8lqzxfhUeh7I3I8ZFFKH7RaVEws3aw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(6512007)(9686003)(66476007)(64756008)(8676002)(66446008)(66946007)(66556008)(76116006)(478600001)(316002)(1076003)(186003)(2906002)(4326008)(54906003)(8936002)(33716001)(86362001)(6506007)(71200400001)(6486002)(26005)(5660300002)(6916009)(44832011)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: U/Eps+9PQDAc/598g4GMAb3Xb9OLdFF3O5WnkRt8v6a136vL8lvC22l8sgWFolAZjjntkRHu5zkICH+608HZrmq1YCLssDmEhcaO62Ogm0x4+yDEtk5vZrT0o3syc0c97kcMabfGaLupo7FX2upkMH1bhJ/5t2IfPyrYshyzrEp7Pt/ZdH2u1YpTc1V2JmFRHEmTgVUA6d2PR7VReFlQwP2kEaOMeCHxKpzS4YSFXdR6siZoRDxXVe3jp0hcxACIW0UIC0R3Cx+uYFfjhGACr1Gl0UArboIAH2XKnlsbkFY4T5GhEH/bDmNyR0zWeUdkv9yN3bbSzBWzhjn/FcztPJttSJZ4u6eZxp9SmB93FuBLPkIYeKcWCEJhbbZ+Ea704vC9EPbRrnZGAsmfCDOIdzxDxchnxM0/Pk2Gbru7HglQSFEIAggKY2fYCvPbssldDJjWa0JNkOPhBtA+clqDtY0LTspgzFoTs/Xr72M2hWYbnzVKzZT3sJMqGbnIW7SaMWWGurlYNVxOa2uWKzxFAhClfGAE34pY8IrlktyV6RkoG4p1OSo1zPRgCuOxyoMIotowXmM7aIOVDOJjKmI/Y4dAtJxOM5MUhi3uIL16e/59fw6NbbaPYj4kDZk62cGrjTWMPRZfYjGkh3T8OJSoUQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <043FF4C00CFDA742A3B1E67C90DD1DE4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7759f04-909a-4622-0a1a-08d865731db7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2020 19:00:36.5785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QOCOlw38onpNrSldaYaIxqmnl1hbvwv6bIHqDmyELuwIDZ78IvxpIrstPHlZR336kmQg974WZUhpk3RVLwBGBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7007
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 11:01:57AM -0700, Jakub Kicinski wrote:
> On Wed, 30 Sep 2020 20:16:10 +0300 Ioana Ciornei wrote:
> > Add basic support in dpaa2-eth for devlink. For the moment, just
> > register the device with devlink, add the corresponding devlink port an=
d
> > implement the .info_get() callback.
> >=20
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> This one does not build, sadly.

Uhh, sorry for this. I'll send a v2 shortly.

Ioana=
