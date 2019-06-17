Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34E748E5A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfFQTXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:23:49 -0400
Received: from mail-eopbgr20087.outbound.protection.outlook.com ([40.107.2.87]:28142
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728855AbfFQTXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVxOwrqH10i/pMRrecocnWetvf0FbABZf3Magw2uZkY=;
 b=NmBU/9KTh/WpCRUf32yZHx6Epiy71g2hcfjCQ2Q4KoeRU/DHaqGoQNtdz8b1eljUfPFY0DhsEoH1qHRDek4r9/3hgl5KbrqUGb6oxaz1LtV7Vqu3FH0adXFdFtRxcgbIDYBy7VUWP6+Pl4OGym+dp28ulBZ6UOcqDb7VNPfc3xQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2789.eurprd05.prod.outlook.com (10.172.226.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:23:34 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:23:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 13/15] net/mlx5: E-Switch, Use vport index when init
 rep
Thread-Topic: [PATCH mlx5-next 13/15] net/mlx5: E-Switch, Use vport index when
 init rep
Thread-Index: AQHVJUIokKB6OifAXkie+hs9tJtG/g==
Date:   Mon, 17 Jun 2019 19:23:34 +0000
Message-ID: <20190617192247.25107-14-saeedm@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
In-Reply-To: <20190617192247.25107-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::41) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82adfb38-c1a3-4799-fb3d-08d6f3594a3c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2789;
x-ms-traffictypediagnostic: DB6PR0501MB2789:
x-microsoft-antispam-prvs: <DB6PR0501MB27890D21A3DFED083F988AA1BEEB0@DB6PR0501MB2789.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(2906002)(50226002)(64756008)(66556008)(66446008)(68736007)(256004)(6636002)(66476007)(2616005)(476003)(446003)(66946007)(73956011)(5660300002)(71200400001)(7736002)(6506007)(386003)(71190400001)(76176011)(102836004)(99286004)(53936002)(305945005)(52116002)(11346002)(1076003)(8676002)(4326008)(450100002)(25786009)(6486002)(3846002)(6116002)(478600001)(186003)(26005)(316002)(110136005)(8936002)(6512007)(81166006)(486006)(81156014)(107886003)(86362001)(14454004)(66066001)(6436002)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2789;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: d56oEl0QILZJhM2VRNt1urOsWUeO5syJ7IKLAXzBuRx9HTJ0yydPEqo101NKIn+MTuhwtSdV20W9JR2nUvYmswaCyjRrxejiFJsTfgls3PagP0NSSXU5nNqnqeQ5Vt/KZFMc6YO2MfGpIyb3dEp8RFkJ129zY7LCaA/56mvk2bTwg7zZIiH0nszUpZROnd6NcTmuG5jPDFU8ZBrKEBjXNkm2sX7u4ybt0dpn3VpGQSCR+laJhGl2Xiube8G3t2EXK7xj7N2c+PPRB8pPyjgR3+XjRdHnQpSkZeDjX/UZHZdnVAmLlvqilYr/wnyQBGhhxR1faG19oI783Ht2Hxk7ptCddhtlt1S7t442VSoEoJ0j8YJlUhAkUf3k0GRrJCKDfUtjVGTa6O+sxIMeoO5Ky804qs1NPKXvRRhdfTO1+/o=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82adfb38-c1a3-4799-fb3d-08d6f3594a3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:23:34.8017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2789
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCkRyaXZlciBpcyByZWZl
cnJpbmcgdG8gdGhlIGFycmF5IGluZGV4IHdoZW4gZG9pbmcgcmVwIGluaXRpYWxpemF0aW9uLA0K
dXNpbmcgdnBvcnQgaXMgY29uZnVzaW5nIGFzIGl0J3Mgbm9ybWFsbHkgaW50ZXJwcmV0ZWQgYXMg
dnBvcnQgbnVtYmVyLg0KDQpUaGlzIHBhdGNoIGRvZXNuJ3QgY2hhbmdlIGFueSBmdW5jdGlvbmFs
aXR5Lg0KDQpTaWduZWQtb2ZmLWJ5OiBCb2RvbmcgV2FuZyA8Ym9kb25nQG1lbGxhbm94LmNvbT4N
ClJldmlld2VkLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClJldmlld2Vk
LWJ5OiBNYXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVl
ZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgfCA2ICsrKy0tLQ0KIDEg
ZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZs
b2Fkcy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hf
b2ZmbG9hZHMuYw0KaW5kZXggNTEyNDIxOWEzMWRlLi5mMjliOWUxZjQ5YWUgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fk
cy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRj
aF9vZmZsb2Fkcy5jDQpAQCAtMTM5OSw3ICsxMzk5LDcgQEAgaW50IGVzd19vZmZsb2Fkc19pbml0
X3JlcHMoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KIAlzdHJ1Y3QgbWx4NV9jb3JlX2RldiAq
ZGV2ID0gZXN3LT5kZXY7DQogCXN0cnVjdCBtbHg1X2Vzd2l0Y2hfcmVwICpyZXA7DQogCXU4IGh3
X2lkW0VUSF9BTEVOXSwgcmVwX3R5cGU7DQotCWludCB2cG9ydDsNCisJaW50IHZwb3J0X2luZGV4
Ow0KIA0KIAllc3ctPm9mZmxvYWRzLnZwb3J0X3JlcHMgPSBrY2FsbG9jKHRvdGFsX3Zwb3J0cywN
CiAJCQkJCSAgIHNpemVvZihzdHJ1Y3QgbWx4NV9lc3dpdGNoX3JlcCksDQpAQCAtMTQwOSw4ICsx
NDA5LDggQEAgaW50IGVzd19vZmZsb2Fkc19pbml0X3JlcHMoc3RydWN0IG1seDVfZXN3aXRjaCAq
ZXN3KQ0KIA0KIAltbHg1X3F1ZXJ5X25pY192cG9ydF9tYWNfYWRkcmVzcyhkZXYsIDAsIGh3X2lk
KTsNCiANCi0JbWx4NV9lc3dfZm9yX2FsbF9yZXBzKGVzdywgdnBvcnQsIHJlcCkgew0KLQkJcmVw
LT52cG9ydCA9IG1seDVfZXN3aXRjaF9pbmRleF90b192cG9ydF9udW0oZXN3LCB2cG9ydCk7DQor
CW1seDVfZXN3X2Zvcl9hbGxfcmVwcyhlc3csIHZwb3J0X2luZGV4LCByZXApIHsNCisJCXJlcC0+
dnBvcnQgPSBtbHg1X2Vzd2l0Y2hfaW5kZXhfdG9fdnBvcnRfbnVtKGVzdywgdnBvcnRfaW5kZXgp
Ow0KIAkJZXRoZXJfYWRkcl9jb3B5KHJlcC0+aHdfaWQsIGh3X2lkKTsNCiANCiAJCWZvciAocmVw
X3R5cGUgPSAwOyByZXBfdHlwZSA8IE5VTV9SRVBfVFlQRVM7IHJlcF90eXBlKyspDQotLSANCjIu
MjEuMA0KDQo=
