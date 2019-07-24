Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAF2732ED
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 17:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387696AbfGXPjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 11:39:09 -0400
Received: from mail-eopbgr30045.outbound.protection.outlook.com ([40.107.3.45]:27911
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725870AbfGXPjI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 11:39:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iv1yjZmrPbJG0vNy+dmYncECZofourr5Ok9CYy5Jzx5wVQUihZMhejh/0QOA+cF9kVM8gUGpEjretEKrqny+PTQX9ALZhdamzQIcZLzN7z3dfdy7LP/+hiU4xRugJMRQ++rmmZRnfoSsiQwtaJrXr28UdZKUfsruioPxy2odRq0yDzRL1xAG9jm6Smqt0+6oEhxpKNz0C6XWVtuGCFlk6ugK50yasqRXqavnhnIkyPFiXKoaeYWY5RXEFQ9D53XapR/gwuBwQzkt7Bjt2RyAa51aEXFmjj3gKNxAwUG/yDhVPnnNwMMN1viOiJmjC4CX1Os0EcUIXb6Kz3+O5egI6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJtin+o6wuBXJt4WB9kBJNcxV77h3TF6Yx+mu5+Uvvo=;
 b=hz1ozqNJ0qmvnhpz4T9zSTEysC9s4zTqB2ceKne2H/ExgjTNUaN3pEfqlKsLbUNkjGRUniQ53ypCoKAFjmbWfYiC7WY2S9KGdk16eXt/s8y5Rr0KLAo+zyXoit8PmBCavmb5zogUkHMPmMEae3Ds0nUE0hWzu+ImqKR2rCjd6AXB4ag6ec/KBSHHiXUQHaBfoWrrF6ta979+iSgJLRcinPjRXAS4jEO8JgLnnbon+3GyiujZsasTkRiB+hlI5DAVYMug5h+2oCu49b0OZKmZiGoEow5AyoEehPGpCHn8TXSg9tSJ3x5TtZSyiLJYgsyYql7QD+XO7/h/LD3mwmegaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJtin+o6wuBXJt4WB9kBJNcxV77h3TF6Yx+mu5+Uvvo=;
 b=Qg1oO97xYCPiZFcdyevcOv26/0ntrbGSMzYLoRQdv+tWoE5ZU8WoF+/8Xj5tPVS3JvV0VGW7ZNoipHgWaOodFHvMyQHS8QFF1zMRVZL24qlkRjsz0PCKyE+c337pwqIiGfjSf/ipcuTGLScRpmEQZWt2kEPuAtni5S3rHqlHQZk=
Received: from VI1PR05MB5344.eurprd05.prod.outlook.com (20.178.9.81) by
 VI1PR05MB4287.eurprd05.prod.outlook.com (52.133.12.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 15:39:05 +0000
Received: from VI1PR05MB5344.eurprd05.prod.outlook.com
 ([fe80::406f:2c4e:37cf:adbc]) by VI1PR05MB5344.eurprd05.prod.outlook.com
 ([fe80::406f:2c4e:37cf:adbc%7]) with mapi id 15.20.2094.013; Wed, 24 Jul 2019
 15:39:05 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Masanari Iida <standby24x7@gmail.com>
CC:     "shuah@kernel.org" <shuah@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] selftests: mlxsw: Fix typo in qos_mc_aware.sh
Thread-Topic: [PATCH net-next] selftests: mlxsw: Fix typo in qos_mc_aware.sh
Thread-Index: AQHVQjSnpdNa8x6TMUWgIlMliwWOj6bZ52wA
Date:   Wed, 24 Jul 2019 15:39:04 +0000
Message-ID: <20190724153902.GA18809@splinter>
References: <20190724152951.4618-1-standby24x7@gmail.com>
In-Reply-To: <20190724152951.4618-1-standby24x7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0005.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::17)
 To VI1PR05MB5344.eurprd05.prod.outlook.com (2603:10a6:803:a5::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51f0f3d5-1d16-4a28-2144-08d7104d0f12
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4287;
x-ms-traffictypediagnostic: VI1PR05MB4287:
x-microsoft-antispam-prvs: <VI1PR05MB4287776A54EE8BE5DBB4527DBFC60@VI1PR05MB4287.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(2906002)(486006)(25786009)(33656002)(305945005)(7736002)(1411001)(76176011)(54906003)(5660300002)(256004)(478600001)(99286004)(52116002)(66446008)(558084003)(66946007)(64756008)(66556008)(66476007)(186003)(6512007)(66066001)(9686003)(4326008)(6436002)(1076003)(476003)(71200400001)(33716001)(8676002)(71190400001)(102836004)(386003)(86362001)(6506007)(26005)(229853002)(8936002)(68736007)(81166006)(14454004)(316002)(6116002)(6486002)(11346002)(3846002)(6246003)(53936002)(446003)(81156014)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4287;H:VI1PR05MB5344.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MwVmIJXMg0r885PVXEkxxX6S+p8PA4nhMULwR/zQ2xPWn8IYqK1HmNW3/1Uo2fn96YNc4MlI7odwahP9wV9Md6tR/b2uWRG3oMgUD62Y88roqWiHYK/OpdNCw5hGjGXOV38+Hx8Av8tYc8r9oz9mxpSgUkRIyPLwVhymI7Al47T/acYQkvbQ8sf339sAYggKOcfsx/7wL0EglwKZWJDOyrPQeD1/3jdH4f3p+ssmMVGolQmw4GvrihGQr5eS4Wq3z2s0yBmmLAETWsrL6EV74ARi+eBH+QQL5c9OVK/ODg2ubSgVYanJfchnh6A2gSpY5gFFQlKtMMXsI6cgso2F0TK1OPI8ArIaXmD243zuA6VG3io1sYE5xY5HNFvCmo8/58MdQZQTUIO3G9/H1Y1TRlzxTaehjtl9kB4U44rQcOc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40791E250C96C7409D0DAA47BAA6A948@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f0f3d5-1d16-4a28-2144-08d7104d0f12
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 15:39:04.9376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: idosch@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4287
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 12:29:51AM +0900, Masanari Iida wrote:
> This patch fix some spelling typo in qos_mc_aware.sh
>=20
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
