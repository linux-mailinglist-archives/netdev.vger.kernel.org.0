Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5EB4AA8C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 21:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfFRTDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 15:03:00 -0400
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:3905
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727386AbfFRTDA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 15:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EoXDLsFrsdn0r7ejsSlX5l7GKcc7/TCPz/18AQWJ4Go=;
 b=HZFhb20x4m9HxUBx1TJT308CrR+VjRsZOjuS4L5/3kJbecDNC+AAa0aAd7AKpwBC4kYJ3kdf0TdMxU7xhOExogVEedHupCutnsR976yZn+8bkr819hIUllR9P1bY69XBgobsNL0tDnaWAYsKMpr/ude/4T976PybRZgKGughLMQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2695.eurprd05.prod.outlook.com (10.172.225.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Tue, 18 Jun 2019 19:02:55 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 19:02:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] net/mlx5: add missing void argument to function
 mlx5_devlink_alloc
Thread-Topic: [PATCH][next] net/mlx5: add missing void argument to function
 mlx5_devlink_alloc
Thread-Index: AQHVJeigp+yH7eURB0ynX/ql1MMSgKahxQoA
Date:   Tue, 18 Jun 2019 19:02:54 +0000
Message-ID: <cbf35c6557791aae0aec2eb3cb1b66cc5030ec9f.camel@mellanox.com>
References: <20190618151510.18672-1-colin.king@canonical.com>
In-Reply-To: <20190618151510.18672-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c454dc5-965c-45d0-a3e1-08d6f41f920f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2695;
x-ms-traffictypediagnostic: DB6PR0501MB2695:
x-microsoft-antispam-prvs: <DB6PR0501MB26953F225197F98649DE7AC5BEEA0@DB6PR0501MB2695.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(6116002)(3846002)(118296001)(6246003)(11346002)(2201001)(26005)(5660300002)(86362001)(6486002)(8676002)(54906003)(305945005)(256004)(99286004)(229853002)(14444005)(2906002)(71200400001)(7736002)(316002)(4326008)(53936002)(6436002)(76176011)(64756008)(66556008)(8936002)(91956017)(66476007)(66946007)(76116006)(66446008)(73956011)(6512007)(2616005)(4744005)(14454004)(81166006)(71190400001)(478600001)(6506007)(81156014)(66066001)(36756003)(102836004)(58126008)(68736007)(486006)(476003)(186003)(2501003)(110136005)(446003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2695;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tQHUbyUzwKAS6YmQJnOSf66MBoNe8xFaOMewaz5fVi4uWjOVWjcMiRWNerggmI6rPfNgPlw6Dzh6VxToBMwN2cxxOzPVMKjqdJdRP0DvWuG+ky5iEGdo/QgcwmrWkaDWMDi3KSDimYHI7ETK7eA8XXu1+qw+uWiVdFOdz8heH40/ptxvifvSgKTCNYGrVSE8QBbXK+95/LRODeUYGyRTdbB2TDfN9wcn97ptzK1kbpAUFnjDtinB70ZaL52Wi6v7X1U4zLNjeU9LDKFt2LCGRjUpi4zesqgM+NSWTDtxrgqp+L6eEKmX8CJ2GGaCShOWWhBCmnr5zxY43ZvJAQ5FsTXs5MV0oT+x5r4WIXqw5yjhtCAJ/60UhenDctMOB/bZSesbThjWOoIqRMl3g81epbRYu7fbNpvcM3gwsdlDZkY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7431CCDFE395F34992A12CBA4DCCED0E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c454dc5-965c-45d0-a3e1-08d6f41f920f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 19:02:54.9734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2695
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTE4IGF0IDE2OjE1ICswMTAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gRnVu
Y3Rpb24gbWx4NV9kZXZsaW5rX2FsbG9jIGlzIG1pc3NpbmcgYSB2b2lkIGFyZ3VtZW50LCBhZGQg
aXQNCj4gdG8gY2xlYW4gdXAgdGhlIG5vbi1BTlNJIGZ1bmN0aW9uIGRlY2xhcmF0aW9uLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNv
bT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGV2
bGluay5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2RldmxpbmsuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9kZXZsaW5rLmMNCj4gaW5kZXggZWQ0MjAyZTg4M2YwLi4xNTMzYzY1NzIyMGIgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kZXZs
aW5rLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Rl
dmxpbmsuYw0KPiBAQCAtMzcsNyArMzcsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGRldmxpbmtf
b3BzIG1seDVfZGV2bGlua19vcHMgPQ0KPiB7DQo+ICAJLmZsYXNoX3VwZGF0ZSA9IG1seDVfZGV2
bGlua19mbGFzaF91cGRhdGUsDQo+ICB9Ow0KPiAgDQo+IC1zdHJ1Y3QgZGV2bGluayAqbWx4NV9k
ZXZsaW5rX2FsbG9jKCkNCj4gK3N0cnVjdCBkZXZsaW5rICptbHg1X2RldmxpbmtfYWxsb2Modm9p
ZCkNCj4gIHsNCj4gIAlyZXR1cm4gZGV2bGlua19hbGxvYygmbWx4NV9kZXZsaW5rX29wcywgc2l6
ZW9mKHN0cnVjdA0KPiBtbHg1X2NvcmVfZGV2KSk7DQo+ICB9DQoNCkFja2VkLWJ5OiBTYWVlZCBN
YWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCg0KRGF2ZSwgdGhpcyBvbmUgY2FuIGdvIHRv
IG5ldC1uZXh0Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg==
