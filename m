Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC3D75A711
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfF1Wgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:54 -0400
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:2242
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726892AbfF1Wgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=olveLdaYHnF7gm+fAT+EuBZRgv70zl0G8SG98357yFsdkSyiouqq58iA7PsBoHDFYYYtxYzc21WoxtG+0weV4XdsJra40wv6WX6zDL53+oPaiSDLrcZeFUNO+GwNFnR2KnmBYGJkD4wfayW/Sp5jvPnWNW9zUPEgfpp+B3Zex9E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4seYw6lJWiZfn6j7X5+BnFJvitpC4uDOTg8X4SzNwC8=;
 b=EGTSP210KuF3B3wcolVndWYCBDu9Tyt+m+KWuDHvT3bPSe8x8DktXD5LMbY8w/KU9Eub9VULvPrilYf9yM6nl3/D2ljM0OXRklTmpq25azBtyB7ltBVSeSJXQxk3XKKKaxlt6wZ1FimWLTTN1BZ7oNQPELKPu5B/bnniBDuJYWc=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4seYw6lJWiZfn6j7X5+BnFJvitpC4uDOTg8X4SzNwC8=;
 b=EBU8F2oe80G4K7Rj8arm7+ACu09xRiZewcghD2Vt5tDoXe3pEQtaIhRzyHPtwzbRpfFb9WnyWvkeCzFvbhKT3qLXrYPAfwxDm4nOJOE+NPaySaB/l2a9fPCICakBrwLJGvkoKbe3Y4xdaaxiQuqdEatttgNQdcb93cGE9TZuEzE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:35:58 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:35:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>, Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 06/18] net/mlx5: Rename mlx5_pci_dev_type to
 mlx5_coredev_type
Thread-Topic: [PATCH mlx5-next 06/18] net/mlx5: Rename mlx5_pci_dev_type to
 mlx5_coredev_type
Thread-Index: AQHVLgHayF8jsOI7wkWu7jL1AsBI7A==
Date:   Fri, 28 Jun 2019 22:35:58 +0000
Message-ID: <20190628223516.9368-7-saeedm@mellanox.com>
References: <20190628223516.9368-1-saeedm@mellanox.com>
In-Reply-To: <20190628223516.9368-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 659b5d2a-fbca-4770-dc90-08d6fc18fd36
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB2357BD4FF9E190FCA83B5456BEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:935;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: m8JUQ7K/l5V2FwZ2afkfgkD7qJige/DWkfcI/YeGJzc7b3zW59G6b693yCuzwcIKgSw2++w0SKsShmKK/9r2S49mZQRgnfT96moSOtqBVodTBf13uHKS4NBG37Lq4O4p0eSNxQd3Y4bTUqZnARKiMo8uED3s5tJcCGX+nz6DCSRiGOY8IC59rC5PB3XBcduaPPkNz2/p9nxjansfGE1inniUOrtm7UXvMKzt+tAaTP8It8n01agjfxWJVaCVVaw68n9FvJwAIqe4x25v+kyFqskWsnNrG9I6ujCTqaNKA2z1E86ISsHYGttxGHEov66Et6aoA4jsNr4CP2GqfF55d2FBia1wqh5conZq8wlZAweF6geOxnaZKOUYXlxugi9enH3Y/aNgQ+UZPLjBhioAfwkA0lGp95Jq9h+j3ISdtbo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 659b5d2a-fbca-4770-dc90-08d6fc18fd36
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:35:58.1363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSHV5IE5ndXllbiA8aHV5bkBtZWxsYW5veC5jb20+DQoNClJlbmFtZSBtbHg1X3BjaV9k
ZXZfdHlwZSB0byBtbHg1X2NvcmVkZXZfdHlwZSB0byBkaXN0aW5ndWlzaCBkaWZmZXJlbnQgbWx4
NQ0KZGV2aWNlIHR5cGVzLg0KDQptbHg1X2NvcmVkZXZfdHlwZSByZXByZXNlbnRzIG1seDVfY29y
ZV9kZXYgaW5zdGFuY2UgdHlwZS4gSGVuY2Uga2VlcA0KbWx4NV9jb3JlZGV2X3R5cGUgaW4gbWx4
NV9jb3JlX2RldiBzdHJ1Y3R1cmUuDQoNClNpZ25lZC1vZmYtYnk6IEh1eSBOZ3V5ZW4gPGh1eW5A
bWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogVnUgUGhhbSA8dnVodW9uZ0BtZWxsYW5veC5j
b20+DQpTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClJl
dmlld2VkLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYt
Ynk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYyB8ICA1ICsrKy0tDQogaW5jbHVk
ZS9saW51eC9tbHg1L2RyaXZlci5oICAgICAgICAgICAgICAgICAgICB8IDExICsrKysrKysrLS0t
DQogMiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4u
YyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMNCmluZGV4
IGJmYzhjNmZhZWRjMi4uZTVmOWRmN2Y3ZTM0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KQEAgLTczMSw4ICs3MzEsNiBAQCBzdGF0aWMg
aW50IG1seDVfcGNpX2luaXQoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgc3RydWN0IHBjaV9k
ZXYgKnBkZXYsDQogCXN0cnVjdCBtbHg1X3ByaXYgKnByaXYgPSAmZGV2LT5wcml2Ow0KIAlpbnQg
ZXJyID0gMDsNCiANCi0JcHJpdi0+cGNpX2Rldl9kYXRhID0gaWQtPmRyaXZlcl9kYXRhOw0KLQ0K
IAlwY2lfc2V0X2RydmRhdGEoZGV2LT5wZGV2LCBkZXYpOw0KIA0KIAlkZXYtPmJhcl9hZGRyID0g
cGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYsIDApOw0KQEAgLTEzMjAsNiArMTMxOCw5IEBAIHN0YXRp
YyBpbnQgaW5pdF9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2
aWNlX2lkICppZCkNCiAJZGV2LT5kZXZpY2UgPSAmcGRldi0+ZGV2Ow0KIAlkZXYtPnBkZXYgPSBw
ZGV2Ow0KIA0KKwlkZXYtPmNvcmVkZXZfdHlwZSA9IGlkLT5kcml2ZXJfZGF0YSAmIE1MWDVfUENJ
X0RFVl9JU19WRiA/DQorCQkJIE1MWDVfQ09SRURFVl9WRiA6IE1MWDVfQ09SRURFVl9QRjsNCisN
CiAJZXJyID0gbWx4NV9tZGV2X2luaXQoZGV2LCBwcm9mX3NlbCk7DQogCWlmIChlcnIpDQogCQln
b3RvIG1kZXZfaW5pdF9lcnI7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L2RyaXZl
ci5oIGIvaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oDQppbmRleCAyZmY2MjRhOTFlM2QuLjE1
NWI4Y2JlMWNjOSAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaA0KKysr
IGIvaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oDQpAQCAtMTgyLDYgKzE4MiwxMSBAQCBlbnVt
IHBvcnRfc3RhdGVfcG9saWN5IHsNCiAJTUxYNV9QT0xJQ1lfSU5WQUxJRAk9IDB4ZmZmZmZmZmYN
CiB9Ow0KIA0KK2VudW0gbWx4NV9jb3JlZGV2X3R5cGUgew0KKwlNTFg1X0NPUkVERVZfUEYsDQor
CU1MWDVfQ09SRURFVl9WRg0KK307DQorDQogc3RydWN0IG1seDVfZmllbGRfZGVzYyB7DQogCXN0
cnVjdCBkZW50cnkJICAgICAgICpkZW50Ow0KIAlpbnQJCQlpOw0KQEAgLTU2Nyw3ICs1NzIsNiBA
QCBzdHJ1Y3QgbWx4NV9wcml2IHsNCiAJc3RydWN0IG1seDVfY29yZV9zcmlvdglzcmlvdjsNCiAJ
c3RydWN0IG1seDVfbGFnCQkqbGFnOw0KIAlzdHJ1Y3QgbWx4NV9kZXZjb20JKmRldmNvbTsNCi0J
dW5zaWduZWQgbG9uZwkJcGNpX2Rldl9kYXRhOw0KIAlzdHJ1Y3QgbWx4NV9jb3JlX3JvY2UJcm9j
ZTsNCiAJc3RydWN0IG1seDVfZmNfc3RhdHMJCWZjX3N0YXRzOw0KIAlzdHJ1Y3QgbWx4NV9ybF90
YWJsZSAgICAgICAgICAgIHJsX3RhYmxlOw0KQEAgLTY0Niw2ICs2NTAsNyBAQCBzdHJ1Y3QgbWx4
NV92eGxhbjsNCiANCiBzdHJ1Y3QgbWx4NV9jb3JlX2RldiB7DQogCXN0cnVjdCBkZXZpY2UgKmRl
dmljZTsNCisJZW51bSBtbHg1X2NvcmVkZXZfdHlwZSBjb3JlZGV2X3R5cGU7DQogCXN0cnVjdCBw
Y2lfZGV2CSAgICAgICAqcGRldjsNCiAJLyogc3luYyBwY2kgc3RhdGUgKi8NCiAJc3RydWN0IG11
dGV4CQlwY2lfc3RhdHVzX211dGV4Ow0KQEAgLTEwNzksOSArMTA4NCw5IEBAIGVudW0gew0KIAlN
TFg1X1BDSV9ERVZfSVNfVkYJCT0gMSA8PCAwLA0KIH07DQogDQotc3RhdGljIGlubGluZSBpbnQg
bWx4NV9jb3JlX2lzX3BmKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQorc3RhdGljIGlubGlu
ZSBib29sIG1seDVfY29yZV9pc19wZihzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIHsNCi0J
cmV0dXJuICEoZGV2LT5wcml2LnBjaV9kZXZfZGF0YSAmIE1MWDVfUENJX0RFVl9JU19WRik7DQor
CXJldHVybiBkZXYtPmNvcmVkZXZfdHlwZSA9PSBNTFg1X0NPUkVERVZfUEY7DQogfQ0KIA0KIHN0
YXRpYyBpbmxpbmUgYm9vbCBtbHg1X2NvcmVfaXNfZWNwZihzdHJ1Y3QgbWx4NV9jb3JlX2RldiAq
ZGV2KQ0KLS0gDQoyLjIxLjANCg0K
