Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E2121F09
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfEQUUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:20:07 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28487
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729201AbfEQUUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:20:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L00+XkABDSn+KMGdDWuJiZ4rxNxtDFaXj1guX29TviU=;
 b=YeBjrn4e2dCrUyX/e4j2UNxteQnULW8j3hPJyYJV0+cyUSKcJ9/81zoNgGTUkBqtXpkLUexDxAnQm9B7Lud0ozg9ZnFUQCqaDXHyCGTpxQlf9I4ZE7P5rTy0yb2GWM0wDHxy0yAlj+XAe+GOpHTBkyoA7vUtfuAI7zq9IrS2/Xg=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 17 May 2019 20:19:56 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:19:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Gavi Teitz <gavi@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 08/11] net/mlx5e: Add missing ethtool driver info for
 representors
Thread-Topic: [net 08/11] net/mlx5e: Add missing ethtool driver info for
 representors
Thread-Index: AQHVDO3kdg4bF00CUEym7J1Yv2RBlw==
Date:   Fri, 17 May 2019 20:19:56 +0000
Message-ID: <20190517201910.32216-9-saeedm@mellanox.com>
References: <20190517201910.32216-1-saeedm@mellanox.com>
In-Reply-To: <20190517201910.32216-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79407295-86f6-42a0-e41f-08d6db0506e1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB61380B31D8F6F1F13D6A718EBE0B0@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(446003)(305945005)(11346002)(71190400001)(71200400001)(66066001)(476003)(14444005)(486006)(386003)(6506007)(76176011)(256004)(7736002)(2616005)(102836004)(6916009)(64756008)(25786009)(66946007)(66446008)(81156014)(81166006)(66556008)(66476007)(26005)(54906003)(2906002)(99286004)(86362001)(52116002)(6436002)(6512007)(8936002)(316002)(8676002)(73956011)(1076003)(14454004)(6116002)(5660300002)(4326008)(50226002)(53936002)(107886003)(68736007)(6486002)(186003)(478600001)(36756003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JTHAlhCPndTrqG070YqmXMUrbIMjIvgcixQzWTCPjNNkAqHVw4ZB43HVMMk/z5ixr5V5+7qbbbP1oAEYaQDgZ9Er1N+R9eHCUq6MN492rM2FL8jp03SKcukDpq8iPPcZU9Ycd7wipj4gcI7wyGFB3c2MSJl6w7wY1NqCnjdtQbiUiYf0p84h42l6CYDV3tFosiM9GY2L4AC9zEcEVrTXgmFOY7aD0U+h8UqJ0u3Ggj3sUhkkTKaHxy6g/my8MIJIDb9xxj0w4wdTPCTyZ1XmMrk5Fks/CA+duE8icQiungkMjzRZVMKYIzSsNMuNlCCA1S+KXLvmcahbrcx5UnwMkyh7bU0ljY6G642xHP5zWo1N+zr7NCtMv5aBUj4xMYG5JwzuJhJ2uMla12erx34GVGZf3lq/eFf4DfSzadLJhfM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79407295-86f6-42a0-e41f-08d6db0506e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:19:56.3316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRG15dHJvIExpbmtpbiA8ZG1pdHJvbGluQG1lbGxhbm94LmNvbT4NCg0KRm9yIGFsbCBy
ZXByZXNlbnRvcnMgYWRkZWQgZmlybXdhcmUgdmVyc2lvbiBpbmZvIHRvIHNob3cgaW4NCmV0aHRv
b2wgZHJpdmVyIGluZm8uDQpGb3IgdXBsaW5rIHJlcHJlc2VudG9yLCBiZWNhdXNlIG9ubHkgaXQg
aXMgdGllZCB0byB0aGUgcGNpIGRldmljZQ0Kc3lzZnMsIGFkZGVkIHBjaSBidXMgaW5mby4NCg0K
Rml4ZXM6IGZmOWI4NWRlNWQ1ZCAoIm5ldC9tbHg1ZTogQWRkIHNvbWUgZXRodG9vbCBwb3J0IGNv
bnRyb2wgZW50cmllcyB0byB0aGUgdXBsaW5rIHJlcCBuZXRkZXYiKQ0KU2lnbmVkLW9mZi1ieTog
RG15dHJvIExpbmtpbiA8ZG1pdHJvbGluQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBHYXZp
IFRlaXR6IDxnYXZpQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRA
bWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxs
YW5veC5jb20+DQotLS0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9y
ZXAuYyAgfCAxOSArKysrKysrKysrKysrKysrKystDQogMSBmaWxlIGNoYW5nZWQsIDE4IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KaW5kZXggOTFlMjRmMWNlYWQ4Li41MjgzZTE2YzY5
ZTQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW5fcmVwLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9yZXAuYw0KQEAgLTY1LDkgKzY1LDI2IEBAIHN0YXRpYyB2b2lkIG1seDVlX3JlcF9pbmRyX3Vu
cmVnaXN0ZXJfYmxvY2soc3RydWN0IG1seDVlX3JlcF9wcml2ICpycHJpdiwNCiBzdGF0aWMgdm9p
ZCBtbHg1ZV9yZXBfZ2V0X2RydmluZm8oc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCiAJCQkJICBz
dHJ1Y3QgZXRodG9vbF9kcnZpbmZvICpkcnZpbmZvKQ0KIHsNCisJc3RydWN0IG1seDVlX3ByaXYg
KnByaXYgPSBuZXRkZXZfcHJpdihkZXYpOw0KKwlzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqbWRldiA9
IHByaXYtPm1kZXY7DQorDQogCXN0cmxjcHkoZHJ2aW5mby0+ZHJpdmVyLCBtbHg1ZV9yZXBfZHJp
dmVyX25hbWUsDQogCQlzaXplb2YoZHJ2aW5mby0+ZHJpdmVyKSk7DQogCXN0cmxjcHkoZHJ2aW5m
by0+dmVyc2lvbiwgVVRTX1JFTEVBU0UsIHNpemVvZihkcnZpbmZvLT52ZXJzaW9uKSk7DQorCXNu
cHJpbnRmKGRydmluZm8tPmZ3X3ZlcnNpb24sIHNpemVvZihkcnZpbmZvLT5md192ZXJzaW9uKSwN
CisJCSAiJWQuJWQuJTA0ZCAoJS4xNnMpIiwNCisJCSBmd19yZXZfbWFqKG1kZXYpLCBmd19yZXZf
bWluKG1kZXYpLA0KKwkJIGZ3X3Jldl9zdWIobWRldiksIG1kZXYtPmJvYXJkX2lkKTsNCit9DQor
DQorc3RhdGljIHZvaWQgbWx4NWVfdXBsaW5rX3JlcF9nZXRfZHJ2aW5mbyhzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2LA0KKwkJCQkJIHN0cnVjdCBldGh0b29sX2RydmluZm8gKmRydmluZm8pDQorew0K
KwlzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQorDQorCW1seDVl
X3JlcF9nZXRfZHJ2aW5mbyhkZXYsIGRydmluZm8pOw0KKwlzdHJsY3B5KGRydmluZm8tPmJ1c19p
bmZvLCBwY2lfbmFtZShwcml2LT5tZGV2LT5wZGV2KSwNCisJCXNpemVvZihkcnZpbmZvLT5idXNf
aW5mbykpOw0KIH0NCiANCiBzdGF0aWMgY29uc3Qgc3RydWN0IGNvdW50ZXJfZGVzYyBzd19yZXBf
c3RhdHNfZGVzY1tdID0gew0KQEAgLTM2Myw3ICszODAsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0
IGV0aHRvb2xfb3BzIG1seDVlX3ZmX3JlcF9ldGh0b29sX29wcyA9IHsNCiB9Ow0KIA0KIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgZXRodG9vbF9vcHMgbWx4NWVfdXBsaW5rX3JlcF9ldGh0b29sX29wcyA9
IHsNCi0JLmdldF9kcnZpbmZvCSAgID0gbWx4NWVfcmVwX2dldF9kcnZpbmZvLA0KKwkuZ2V0X2Ry
dmluZm8JICAgPSBtbHg1ZV91cGxpbmtfcmVwX2dldF9kcnZpbmZvLA0KIAkuZ2V0X2xpbmsJICAg
PSBldGh0b29sX29wX2dldF9saW5rLA0KIAkuZ2V0X3N0cmluZ3MgICAgICAgPSBtbHg1ZV9yZXBf
Z2V0X3N0cmluZ3MsDQogCS5nZXRfc3NldF9jb3VudCAgICA9IG1seDVlX3JlcF9nZXRfc3NldF9j
b3VudCwNCi0tIA0KMi4yMS4wDQoNCg==
