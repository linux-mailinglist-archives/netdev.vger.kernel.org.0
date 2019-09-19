Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC76FB7DE3
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 17:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391136AbfISPN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 11:13:59 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:5504
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388792AbfISPN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 11:13:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWm0r57VrK7e72CdBv11lfikeR5xntqJ0aDj5LfM1SOkvUDY+1Ah2yEU7f1hT6ZtnNYJhpQNKO2M0A2XeQq4vuv8EqPJCXKclK/XjtRpxiuw7UeBruJvDF14fi9M3cHzilP2v65Gv7P0p5N1O/AsH3XbxjoUvPW0LWJar4puQs1SP21E/Oc/LHXVLLcRelqn5PUv8Ze9j4U8OThqxVLMUInHGAF0f6k4IGMOd+FNPtYkUZbaF8zSd9mxUpfgjijY3q8ORD9Qy/0HOG6EddrBcY81H20xuM8CRxSOn3jCJpRWgX1zotx6YuczTTqHbHuXOaRlnudw3TIGiiYle8GmVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwC3C00COist2GJDk9tyfwFu+9I8w+XF47aIf54h1Jk=;
 b=S40ptiGhwqu3UeeIESoWK6pTbPVDZsZ2dhsvJRC/VN9EPS4PKrmIgefOqCvpA7tC1SWNOu/iUwoa27gHzPBxPhE6KrKdR7pUDwoppVQ0JjLEBbMz4gbmUgu4RQ1FHXJ+zUe6JSRh2l9dogW0/y24xCDQMMznr3nkLtRcr2QUvQO1w0WG3q7tGtFE5sYMGnlwgPLdzrYMCpMbqrB3Oe/SSlgqS3ycH3NgXHVBGvYILTV1gz8jUy/pG7nD2S9B1LwrQk041vrmCBfL3AG5OtnzT2wLRwHp/OOuBLT45NdNgyOdgQ7is4Y+vDVdZ+pDzzPjvRqTo6x7UqybpfQDhLjDbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwC3C00COist2GJDk9tyfwFu+9I8w+XF47aIf54h1Jk=;
 b=C1fsjPZCv4tFRdf/JVdS3UgIXh0R3mCIOiwuw34cmo3bNgbolP1YeWQeSohkWu8gfeikBLtEjfS2zIwm14YzbA4jVN1Gu62cP+I//3MF+BoiQcmze9p6RO5zHw6kLFWi1mGad2CpW2SkLMT0PG1pGkcb/ebeo22THJlvWYHB33U=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5117.eurprd05.prod.outlook.com (20.178.10.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.20; Thu, 19 Sep 2019 15:13:55 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d%6]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 15:13:55 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: CONFIG_NET_TC_SKB_EXT
Thread-Topic: CONFIG_NET_TC_SKB_EXT
Thread-Index: AQHVbtxxpoQTEAw2kku04afcAlO8FaczG86A
Date:   Thu, 19 Sep 2019 15:13:55 +0000
Message-ID: <vbfk1a41fr1.fsf@mellanox.com>
References: <20190919.132147.31804711876075453.davem@davemloft.net>
In-Reply-To: <20190919.132147.31804711876075453.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0044.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::32)
 To VI1PR05MB5295.eurprd05.prod.outlook.com (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3b94037-8039-4077-5348-08d73d13fce6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5117;
x-ms-traffictypediagnostic: VI1PR05MB5117:|VI1PR05MB5117:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5117D3F7DBAD0A2A0CDF3EE8AD890@VI1PR05MB5117.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(189003)(199004)(8936002)(81166006)(52116002)(186003)(5660300002)(81156014)(66066001)(8676002)(71200400001)(66946007)(66476007)(66446008)(4744005)(6512007)(66556008)(6486002)(64756008)(3846002)(229853002)(4326008)(36756003)(6116002)(6246003)(6916009)(86362001)(6436002)(478600001)(25786009)(71190400001)(2906002)(102836004)(76176011)(11346002)(2616005)(26005)(446003)(7736002)(305945005)(316002)(14454004)(476003)(54906003)(7116003)(99286004)(486006)(256004)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5117;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AtnHl3YMzrJ2Xn7/g7/hl4PdBHfQI4ZIGFGZd/R+mbddlFi4/+gbfrba3VCpZSfOjY4SBMnCCrWICwxyVoFGVwc9Lvdezdprf75jtXn55SQsJi6JaWXOVPmfD/IWfmXWch/rCJPC7qkRWG+Xuy/Q/0mITHI4umnlCLloWNDlaRtYd4YQXYwR0s5AylRD8iNTGxuH96Ru0O5wjmAMI7FBqpVd6KU0/Qr4M1Voyjdg3LicQXmbCJrXDPlltp/a9d7MN8v0B1cfA5Bq2KvyfZ/4gXld1Pa9S8Yg8V9ULDiS1tB3GF67XJxw7l0hbXPdu2Hdviqwi1wZKQiYcB4TuCjNgDrNJKY4WGWWIwQpE+zT1KnhRUPvh5/sxNGBhGBAy175mNolPAsfgqNFpDv+u0gOdFRe2jpprfq8ZbXsUU8E5Fo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3b94037-8039-4077-5348-08d73d13fce6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 15:13:55.4709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5kt6JnmC2ADFVEAYU788bzsYSFooDdm1not7CqOars2zWxUwcrsGqRrnHMHr80ut6WngVE66BGBaFic1ZRhRHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 19 Sep 2019 at 14:21, David Miller <davem@davemloft.net> wrote:
> As Linus pointed out, the Kconfig logic for CONFIG_NET_TC_SKB_EXT
> is really not acceptable.
>
> It should not be enabled by default at all.
>
> Instead the actual users should turn it on or depend upon it, which in
> this case seems to be OVS.
>
> Please fix this, thank you.

Hi David,

We are working on it, but Paul is OoO today. Is it okay if we send the
fix early next week?

Thanks,
Vlad
