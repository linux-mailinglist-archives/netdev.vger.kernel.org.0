Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5C910108
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 22:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfD3UkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 16:40:14 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:37375
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727177AbfD3UkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 16:40:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32E9Mfb+Qjx08Pulgz9vHq/0N4qgLwhMpgtCMBEB3us=;
 b=NfEgCuje9zL6u1w64239YkwK1dI5vYDtPM0Dp6KGf++tf1dsQ3GTMG9SQlOM8IkVdH7ctunvGQn/weLoClkfck8ev6Po+1bgCADcKMvKZzw3bLhqwU3+Cs0ktFZNAtCFBBI5ASzy20ZRVNAfy9xfPIM6mVIHzns0EjL7vjRdWsY=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB6542.eurprd05.prod.outlook.com (20.179.27.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 20:40:03 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 20:40:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/15] net/mlx5: Remove unused mlx5_query_nic_vport_vlans
Thread-Topic: [net-next 10/15] net/mlx5: Remove unused
 mlx5_query_nic_vport_vlans
Thread-Index: AQHU/5Tjo2e/Xb3jjES2QSN72OetFw==
Date:   Tue, 30 Apr 2019 20:40:03 +0000
Message-ID: <20190430203926.19284-11-saeedm@mellanox.com>
References: <20190430203926.19284-1-saeedm@mellanox.com>
In-Reply-To: <20190430203926.19284-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9bc1c0de-ab43-4cbf-94cb-08d6cdac0593
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6542;
x-ms-traffictypediagnostic: VI1PR05MB6542:
x-microsoft-antispam-prvs: <VI1PR05MB65421B232A05ACABF23C9CA3BE3A0@VI1PR05MB6542.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(99286004)(25786009)(102836004)(53936002)(36756003)(386003)(478600001)(186003)(6506007)(7736002)(26005)(2616005)(476003)(446003)(52116002)(6436002)(4326008)(305945005)(5660300002)(76176011)(486006)(66066001)(11346002)(14454004)(107886003)(6512007)(6486002)(68736007)(71200400001)(2906002)(6916009)(81166006)(316002)(1076003)(97736004)(81156014)(66446008)(64756008)(66556008)(50226002)(66476007)(66946007)(73956011)(8936002)(54906003)(256004)(8676002)(3846002)(86362001)(6116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6542;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nu+KYDN3YlyU4GzfRkuDITmycTmxBkcK/W0zPu9DPUr1U/rx93pcTS7QliTUTt/ldedepOkRpe5HIP24b5HcBpvIHdvd8m2q2BOrRA1/5kGt8AaWdwoUyZIV/tvWxBZujXztaZint1Z/tKKufBNvdlBdmFv5/AnWokg/gB5jWTBd4QN8f+Zpyj8I9Io0K1pCFlvHHg+bDJ8zMUmMVrQGlRIszS8JdiLzRLQJWeK2Co/1vLyjHPobUAYOeCvc4YOcmo6iJcgHJ8fNA4pX48S4nxmBkPA8hBZXRf3x9QPp5XRW0TdXd1maL8ddt4Omq/fTo8i2YXwzJCUP5ok1eY/s46iRGQXfE4qt17sUZBj0KcPSyCi22kJg/ZV0QkVmaOkwko1jpJhkUcyCBmH1CDTI4D7BSBM5Wtvwxtq3CsXi8UM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc1c0de-ab43-4cbf-94cb-08d6cdac0593
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 20:40:03.6204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6542
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCm1seDVfcXVlcnlfbmlj
X3Zwb3J0X3ZsYW5zKCkgaXMgbm90IHVzZWQgYW55bW9yZS4gSGVuY2UgcmVtb3ZlIGl0Lg0KVGhp
cyBwYXRjaCBkb2Vzbid0IGNoYW5nZSBhbnkgZnVuY3Rpb25hbGl0eS4NCg0KU2lnbmVkLW9mZi1i
eTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogUGFyYXYg
UGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVl
ZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL3Zwb3J0LmMgICB8IDYxIC0tLS0tLS0tLS0tLS0tLS0tLS0NCiBpbmNsdWRlL2xp
bnV4L21seDUvdnBvcnQuaCAgICAgICAgICAgICAgICAgICAgfCAgNCAtLQ0KIDIgZmlsZXMgY2hh
bmdlZCwgNjUgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvdnBvcnQuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS92cG9ydC5jDQppbmRleCBlZjk1ZmVjYTk5NjEuLjk1Y2RjOGNiY2JhNCAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS92cG9y
dC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvdnBvcnQu
Yw0KQEAgLTM3MSw2NyArMzcxLDYgQEAgaW50IG1seDVfbW9kaWZ5X25pY192cG9ydF9tYWNfbGlz
dChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LA0KIH0NCiBFWFBPUlRfU1lNQk9MX0dQTChtbHg1
X21vZGlmeV9uaWNfdnBvcnRfbWFjX2xpc3QpOw0KIA0KLWludCBtbHg1X3F1ZXJ5X25pY192cG9y
dF92bGFucyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LA0KLQkJCSAgICAgICB1MTYgdnBvcnQs
DQotCQkJICAgICAgIHUxNiB2bGFuc1tdLA0KLQkJCSAgICAgICBpbnQgKnNpemUpDQotew0KLQl1
MzIgaW5bTUxYNV9TVF9TWl9EVyhxdWVyeV9uaWNfdnBvcnRfY29udGV4dF9pbildOw0KLQl2b2lk
ICpuaWNfdnBvcnRfY3R4Ow0KLQlpbnQgcmVxX2xpc3Rfc2l6ZTsNCi0JaW50IG1heF9saXN0X3Np
emU7DQotCWludCBvdXRfc3o7DQotCXZvaWQgKm91dDsNCi0JaW50IGVycjsNCi0JaW50IGk7DQot
DQotCXJlcV9saXN0X3NpemUgPSAqc2l6ZTsNCi0JbWF4X2xpc3Rfc2l6ZSA9IDEgPDwgTUxYNV9D
QVBfR0VOKGRldiwgbG9nX21heF92bGFuX2xpc3QpOw0KLQlpZiAocmVxX2xpc3Rfc2l6ZSA+IG1h
eF9saXN0X3NpemUpIHsNCi0JCW1seDVfY29yZV93YXJuKGRldiwgIlJlcXVlc3RlZCBsaXN0IHNp
emUgKCVkKSA+ICglZCkgbWF4IGxpc3Qgc2l6ZVxuIiwNCi0JCQkgICAgICAgcmVxX2xpc3Rfc2l6
ZSwgbWF4X2xpc3Rfc2l6ZSk7DQotCQlyZXFfbGlzdF9zaXplID0gbWF4X2xpc3Rfc2l6ZTsNCi0J
fQ0KLQ0KLQlvdXRfc3ogPSBNTFg1X1NUX1NaX0JZVEVTKG1vZGlmeV9uaWNfdnBvcnRfY29udGV4
dF9pbikgKw0KLQkJCXJlcV9saXN0X3NpemUgKiBNTFg1X1NUX1NaX0JZVEVTKHZsYW5fbGF5b3V0
KTsNCi0NCi0JbWVtc2V0KGluLCAwLCBzaXplb2YoaW4pKTsNCi0Jb3V0ID0ga3phbGxvYyhvdXRf
c3osIEdGUF9LRVJORUwpOw0KLQlpZiAoIW91dCkNCi0JCXJldHVybiAtRU5PTUVNOw0KLQ0KLQlN
TFg1X1NFVChxdWVyeV9uaWNfdnBvcnRfY29udGV4dF9pbiwgaW4sIG9wY29kZSwNCi0JCSBNTFg1
X0NNRF9PUF9RVUVSWV9OSUNfVlBPUlRfQ09OVEVYVCk7DQotCU1MWDVfU0VUKHF1ZXJ5X25pY192
cG9ydF9jb250ZXh0X2luLCBpbiwgYWxsb3dlZF9saXN0X3R5cGUsDQotCQkgTUxYNV9OVlBSVF9M
SVNUX1RZUEVfVkxBTik7DQotCU1MWDVfU0VUKHF1ZXJ5X25pY192cG9ydF9jb250ZXh0X2luLCBp
biwgdnBvcnRfbnVtYmVyLCB2cG9ydCk7DQotDQotCWlmICh2cG9ydCkNCi0JCU1MWDVfU0VUKHF1
ZXJ5X25pY192cG9ydF9jb250ZXh0X2luLCBpbiwgb3RoZXJfdnBvcnQsIDEpOw0KLQ0KLQllcnIg
PSBtbHg1X2NtZF9leGVjKGRldiwgaW4sIHNpemVvZihpbiksIG91dCwgb3V0X3N6KTsNCi0JaWYg
KGVycikNCi0JCWdvdG8gb3V0Ow0KLQ0KLQluaWNfdnBvcnRfY3R4ID0gTUxYNV9BRERSX09GKHF1
ZXJ5X25pY192cG9ydF9jb250ZXh0X291dCwgb3V0LA0KLQkJCQkgICAgIG5pY192cG9ydF9jb250
ZXh0KTsNCi0JcmVxX2xpc3Rfc2l6ZSA9IE1MWDVfR0VUKG5pY192cG9ydF9jb250ZXh0LCBuaWNf
dnBvcnRfY3R4LA0KLQkJCQkgYWxsb3dlZF9saXN0X3NpemUpOw0KLQ0KLQkqc2l6ZSA9IHJlcV9s
aXN0X3NpemU7DQotCWZvciAoaSA9IDA7IGkgPCByZXFfbGlzdF9zaXplOyBpKyspIHsNCi0JCXZv
aWQgKnZsYW5fYWRkciA9IE1MWDVfQUREUl9PRihuaWNfdnBvcnRfY29udGV4dCwNCi0JCQkJCSAg
ICAgICBuaWNfdnBvcnRfY3R4LA0KLQkJCQkJICAgICAgIGN1cnJlbnRfdWNfbWFjX2FkZHJlc3Nb
aV0pOw0KLQkJdmxhbnNbaV0gPSBNTFg1X0dFVCh2bGFuX2xheW91dCwgdmxhbl9hZGRyLCB2bGFu
KTsNCi0JfQ0KLW91dDoNCi0Ja2ZyZWUob3V0KTsNCi0JcmV0dXJuIGVycjsNCi19DQotRVhQT1JU
X1NZTUJPTF9HUEwobWx4NV9xdWVyeV9uaWNfdnBvcnRfdmxhbnMpOw0KLQ0KIGludCBtbHg1X21v
ZGlmeV9uaWNfdnBvcnRfdmxhbnMoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwNCiAJCQkJdTE2
IHZsYW5zW10sDQogCQkJCWludCBsaXN0X3NpemUpDQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51
eC9tbHg1L3Zwb3J0LmggYi9pbmNsdWRlL2xpbnV4L21seDUvdnBvcnQuaA0KaW5kZXggMGVlZjU0
OGI5OTQ2Li4zZDFjNmNkYmJiYTcgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L21seDUvdnBv
cnQuaA0KKysrIGIvaW5jbHVkZS9saW51eC9tbHg1L3Zwb3J0LmgNCkBAIC0xMTgsMTAgKzExOCw2
IEBAIGludCBtbHg1X21vZGlmeV9uaWNfdnBvcnRfcHJvbWlzYyhzdHJ1Y3QgbWx4NV9jb3JlX2Rl
diAqbWRldiwNCiAJCQkJICBpbnQgcHJvbWlzY191YywNCiAJCQkJICBpbnQgcHJvbWlzY19tYywN
CiAJCQkJICBpbnQgcHJvbWlzY19hbGwpOw0KLWludCBtbHg1X3F1ZXJ5X25pY192cG9ydF92bGFu
cyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LA0KLQkJCSAgICAgICB1MTYgdnBvcnQsDQotCQkJ
ICAgICAgIHUxNiB2bGFuc1tdLA0KLQkJCSAgICAgICBpbnQgKnNpemUpOw0KIGludCBtbHg1X21v
ZGlmeV9uaWNfdnBvcnRfdmxhbnMoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwNCiAJCQkJdTE2
IHZsYW5zW10sDQogCQkJCWludCBsaXN0X3NpemUpOw0KLS0gDQoyLjIwLjENCg0K
