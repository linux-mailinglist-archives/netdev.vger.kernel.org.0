Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59F898C5A
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 09:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbfHVHSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 03:18:25 -0400
Received: from mail-eopbgr00055.outbound.protection.outlook.com ([40.107.0.55]:48293
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727476AbfHVHSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 03:18:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHYZpDp/eNbWe6/JLVgWQdKxN30tufm5cIa4fef3kQUm+bX70WmZZoiMS/IWsvGehWWwGazuldh6ib9DckXmkyAmAarFZiZ58bHCu24uklXECPB5M4Kb38re5enkjSYB13ak5MM+gQeSd9LOwHqBWU3QTPuCNvi/6bD5MvzJe924P0DhLrgiw924JCB6nu9OJhu+HIhcavPC+OkJXC8ut77fJTxaolYcwgG2C7Ds1MFaNZWFY7aSzj1Jq0dEUUhrAZ7ObDuB9NM8h/CZTIfQJwFJjKYqarJfMeBu5r7P1ge6X5KgFaAMh+2/W+B/NeTKkWOmV6TNQq+8+KFvLFrxxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJoE5pILTTiTePtSXKpYWAQi4Bn/pTem5qKkkR5z8yk=;
 b=ltr5cKHCIdsUIkjYUkBpgbRR9bN2kFZZnyfFwTncouv1AoILFLvw9qi3MbGxDkgtodNeBRZFBHrwweSCZ9kPNZI1ETe+7nUN5JsL4ClXYIMa0hVcxztZh/2TwWhOISFeUxiohMtYo1LcuTZaISoslLrJpZDcQMHRXLL7Ftd5lYuGde9dTX7q5Ocrdfkp6nYtN2wUHKz/l8o9dx3kY6IRATcH//ck22S4TidsAMNF8E58znWJmy3vhk9x1qFYgIaJBOKqBAs7wX25hKfbKzVdAK/9BDFCRBRp7ffV+wyqRo0vxnG2IAcbWkd/Vs4paobWA34t0TS5pUS2r06Uxog7jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJoE5pILTTiTePtSXKpYWAQi4Bn/pTem5qKkkR5z8yk=;
 b=YuXzuxuyJj6vqi4do39epOJ/WDQW+ISAfYg0n6w0TDW/eUaAROUspd1DdPccbMAuyJuwjL9wEPaWV9Rn96DVFPAiiyQmBKU9rik7QOL+vhHUFDRKisw2EQk+THx9GBJBz7BPbrI/RASBVeKXcZPtw/BZ4s7uDn9Jv+trRreCTzo=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3877.eurprd04.prod.outlook.com (52.133.30.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 07:18:19 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 07:18:19 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Topic: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Index: AQHVWLnFOZqG4EcHiU275uWw+5j6mA==
Date:   Thu, 22 Aug 2019 07:18:18 +0000
Message-ID: <AM6PR0402MB3798C702793071E34A5659ED86A50@AM6PR0402MB3798.eurprd04.prod.outlook.com>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
 <AM6PR0402MB379864B810F08D3698618B5F86A80@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <13e65051-fe4f-5964-30b3-75285e6d2eee@gmail.com>
 <AM6PR0402MB3798FCBF1EE592687B13A3C386AB0@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <5c920846-b8f5-d087-cea4-a8ca3f816127@gmail.com>
 <20190821185715.GA16401@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8960d3b-22c3-4385-d5b9-08d726d0e867
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM6PR0402MB3877;
x-ms-traffictypediagnostic: AM6PR0402MB3877:
x-microsoft-antispam-prvs: <AM6PR0402MB38770FE26382D8B981B8EA0886A50@AM6PR0402MB3877.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(199004)(189003)(74316002)(66946007)(33656002)(256004)(54906003)(14444005)(44832011)(446003)(52536014)(6436002)(55236004)(110136005)(81166006)(8936002)(9686003)(66446008)(81156014)(86362001)(476003)(486006)(66476007)(8676002)(66556008)(53546011)(64756008)(26005)(186003)(316002)(76116006)(6506007)(91956017)(229853002)(66066001)(478600001)(7696005)(5660300002)(102836004)(3846002)(6116002)(2906002)(4326008)(25786009)(53936002)(76176011)(55016002)(71200400001)(99286004)(14454004)(71190400001)(7736002)(305945005)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3877;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9Nws+Yla2KPJrVxGI5unbeOVu4KXwl27yOPjBk3och+qcme4zdD9mr3Ip+lCYZkmBHItEILdk2Pj3zwXiZ9psXh9VfrLMCZyaauXUxHv7m5qUB4s1EMWzs+FQX/++Mmc5XGxA0pWUS/uoZR4rhaDy4IbKX5Br5Z6NNvMSlL6zlIba/q8sH8jzZuHBM6qDoKb25/eZY5Et3lSgU/xbesAvRzTyEPJZLwKVWWwi6JkZXSvDlW1B+VMn2k0/q1j08dDs6qyIS0pRYi5jPGVYR/raDbeNJl+iVC+WTmsyP7N5zLI3ERmz/JZnPjC0Z6D7V8Z6iUCqPhjhyMihB1FbF5Obnq4Ry1ae0T33fCQaMkT8OJeDK3+F56QZNQrElrKI92zH23flM6GkcRglb2Lrv9EFjEf6nuSsyjqhsXW7scYIjE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8960d3b-22c3-4385-d5b9-08d726d0e867
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 07:18:18.9557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ns8h476ulbU5m6JCNtQwAo38lJoe3aeIl4v8NMN68EEs9RuS7bcQV2WLtlaWSFuqGszBbMaiMY7uboVqk4CHVbcfwh3AEGmc5baltDeCuzI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3877
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.08.2019 20:57, Andrew Lunn wrote:=0A=
> =0A=
>> The current patch set IMO is a little bit hacky. I'm not 100% happy=0A=
>> with the implicit assumption that there can't be devices supporting=0A=
>> T1 and classic BaseT modes or fiber modes.=0A=
>=0A=
>> Andrew: Do you have an opinion on that?=0A=
> =0A=
> Hi Heiner=0A=
> =0A=
> I would also like cleaner integration. I doubt here is anything in the=0A=
> standard which says you cannot combine these modes. It is more a=0A=
> marketing question if anybody would build such a device. Maybe not=0A=
> directly into a vehicle, but you could imaging a mobile test device=0A=
> which uses T1 to talk to the car and T4 to connect to the garage=0A=
> network?=0A=
> =0A=
> So i don't think we should limit ourselves. phylib should provide a=0A=
> clean, simple set of helpers to perform standard operations for=0A=
> various modes. Drivers can make use of those helpers. That much should=0A=
> be clear. If we try to make genphy support them all simultaneously, is=0A=
> less clear.=0A=
> =0A=
>       Andrew=0A=
> =0A=
=0A=
If you want to go down this path, then i think we have to ask some more =0A=
questions. Clause 45 is a very scalable register scheme, it is not a =0A=
specific class of devices and will be extended and extended.=0A=
=0A=
Currently, the phy-c45.c supports 10/100/1000/2500/5000/10000 Mbps =0A=
consumer/enterprise PHYs. This is also an implicit assumption. The =0A=
register set (e.g. on auto-neg) used for this will also only support =0A=
these modes and nothing more, as it is done scaling.=0A=
=0A=
Currently not supported, but already present in IEEE 802.3:=0A=
- MultiGBASE-T (25/40 Gbps) (see e.g. MultiGBASE-T AN control 1 register)=
=0A=
- BASE-T1=0A=
- 10BASE-T1=0A=
- NGBASE-T1=0A=
=0A=
And surely there are some on the way or already there that I am not =0A=
aware of.=0A=
=0A=
To me, one architectural decision point is if you want to have generic =0A=
support for all C45 PHYs in one file, or if you want to split it by =0A=
device class. I went down the first path with my patch, as this is the =0A=
road gone also with the existing code.=0A=
=0A=
If you want to split BASE-T1, i think you will need one basic C45 =0A=
library (genphy_c45_pma_read_abilities() is a good example of a function =
=0A=
that is not specific to a device class). On the other hand, =0A=
genphy_c45_pma_setup_forced() is not a generic function at this point as =
=0A=
it supports only a subset of devices managed in C45.=0A=
=0A=
I tend to agree with you that splitting is the best way to go in the =0A=
long run, but that also requires a split of the existing phy-c45.c into =0A=
two IMHO.=0A=
