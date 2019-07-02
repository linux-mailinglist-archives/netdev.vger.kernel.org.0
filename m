Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCF25D41E
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGBQSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:18:07 -0400
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:57928
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725922AbfGBQSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 12:18:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8peakhYgc7E2eCB1SUf8Vpeqtlmj0t56JbjCU9JKU7g=;
 b=JQ3STg9hoRDX8pXS3eBS6mEE8lVqZLtKg1lggmifJQuuQWaKSnRiZ8J0ODzjGPvhIc5/RWQ2i/1R1ZMuZE8/yyOOUXeROlb2rx8sqUqZ8pp8jLizi0LitJ+2B5teVOWa89Kr5wgOi4lmW664PueV19iKBpgcOVRVJfgUvizcwHg=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4978.eurprd05.prod.outlook.com (20.177.41.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 16:18:04 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 16:18:04 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: RE: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish the
 port parameters.
Thread-Topic: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish the
 port parameters.
Thread-Index: AQHVMOnVNNDimR9Hpkq8DMdGSDDj46a3f82AgAAAQcA=
Date:   Tue, 2 Jul 2019 16:18:03 +0000
Message-ID: <AM0PR05MB4866D7B26F48AF0BED9055EED1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190702152056.31728-1-skalluru@marvell.com>
 <20190702161133.GP30468@lunn.ch>
In-Reply-To: <20190702161133.GP30468@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8580d3d4-b7f6-42b7-e40d-08d6ff08dc53
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4978;
x-ms-traffictypediagnostic: AM0PR05MB4978:
x-microsoft-antispam-prvs: <AM0PR05MB49788D1AE2BAC39C9CADD053D1F80@AM0PR05MB4978.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(199004)(13464003)(189003)(102836004)(7696005)(53546011)(71190400001)(68736007)(8936002)(55236004)(81156014)(8676002)(66946007)(76176011)(71200400001)(6506007)(26005)(7736002)(74316002)(78486014)(25786009)(76116006)(99286004)(64756008)(66446008)(4744005)(305945005)(52536014)(5660300002)(9456002)(486006)(66476007)(66556008)(81166006)(73956011)(14454004)(476003)(33656002)(9686003)(4326008)(446003)(186003)(316002)(11346002)(6436002)(54906003)(110136005)(66066001)(229853002)(3846002)(86362001)(55016002)(6116002)(53936002)(256004)(478600001)(2906002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4978;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3nnVogTD/TRweoOJhmkhc2rh+3iwNiZ+qsIw5DZrT6Aum8qFDYGGyeylUdEJpU6JVqKzj1lebv64Y6I+OKeH8e6K1z2QsA/c7RJZtfeXDNZnxZ0BaJfyiKQecHR8R4fx/hUhg+uMsc3zEWaRjZzvI5uNK8Ir+i7TOfaa5gMQIG++Sstcn3pLVhNmGi0Gzyd2qNWi71ngfvR5YwO8hM713ybueodC3gzFF/+iiktfoCIEBZWa+WTcDmzhNPGHzMUgJ8NIrmVYBLTzaBQfzgpbQOZrmVA66bR6g4Ce6j8vniMlITPaU/JQ9O7yxSmzxHjUPMX2F8sp5GyYM1u8W4dd++bqMULuLd0k387nIFI7MXd3/W32/suMIfvyPubLrfSOXmCr//fjwFqOExSsw/zoN+FrpVDtV8zFbIcnkqEGKVc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8580d3d4-b7f6-42b7-e40d-08d6ff08dc53
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 16:18:03.9721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4978
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Andrew Lunn
> Sent: Tuesday, July 2, 2019 9:42 PM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; mkalderon@marvell.com;
> aelior@marvell.com; jiri@resnulli.us
> Subject: Re: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish =
the
> port parameters.
>=20
> On Tue, Jul 02, 2019 at 08:20:56AM -0700, Sudarsana Reddy Kalluru wrote:
> > The patch adds devlink interfaces for drivers to publish/unpublish the
> > devlink port parameters.
>=20
> Hi Sudarsana
>=20
> A good commit message says more about 'why' than 'what'. I can see the
> 'what' by reading the code. But the 'why' is often not so clear.
>=20
> Why would i want to unpublish port parameters?
>=20
> Thanks
> 	Andrew

A vendor driver calling these APIs is needed at minimum.
