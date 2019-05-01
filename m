Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06D310ED4
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfEAVzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:55:14 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:32576
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726128AbfEAVzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 17:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32E9Mfb+Qjx08Pulgz9vHq/0N4qgLwhMpgtCMBEB3us=;
 b=IImvpcJkPqEC3/uf6hKzRl6e109LFrEFXo1lolSBR59LGXZZ25LAM/KMjF07vH1G2mhUo1JEbl18KMGzB9w/v83jm06oSQb2mdJ2g9JLQVOb3VxhAE6rlrNHKkVyZXYsmnVvW9L/+973r/h+qJmikClNq8pGp3V18srpkV+Ex/w=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5868.eurprd05.prod.outlook.com (20.179.8.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Wed, 1 May 2019 21:55:02 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 21:55:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 10/15] net/mlx5: Remove unused
 mlx5_query_nic_vport_vlans
Thread-Topic: [net-next V2 10/15] net/mlx5: Remove unused
 mlx5_query_nic_vport_vlans
Thread-Index: AQHVAGiHE/PZNlk4vUWAwKX0pgWNfQ==
Date:   Wed, 1 May 2019 21:55:02 +0000
Message-ID: <20190501215433.24047-11-saeedm@mellanox.com>
References: <20190501215433.24047-1-saeedm@mellanox.com>
In-Reply-To: <20190501215433.24047-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0012.prod.exchangelabs.com (2603:10b6:a02:80::25)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 020bcfa4-c199-4709-9824-08d6ce7fa9af
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5868;
x-ms-traffictypediagnostic: DB8PR05MB5868:
x-microsoft-antispam-prvs: <DB8PR05MB58686186FF72CC77F0BEFA50BE3B0@DB8PR05MB5868.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(5660300002)(256004)(86362001)(6512007)(66066001)(71190400001)(71200400001)(316002)(478600001)(446003)(11346002)(476003)(2616005)(186003)(1076003)(6486002)(26005)(486006)(6436002)(2906002)(102836004)(52116002)(6506007)(36756003)(6916009)(4326008)(76176011)(50226002)(107886003)(66446008)(68736007)(7736002)(66946007)(66476007)(66556008)(64756008)(53936002)(54906003)(305945005)(8676002)(81156014)(3846002)(81166006)(386003)(25786009)(73956011)(8936002)(99286004)(6116002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5868;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ggDXWP4Wb3c0UG4Q4wYv7MKlfmMOb340LoP/VIlBAcIfqrGMAvSmR3ypNXSGz5GCYJ0eROIqcYmwC2f6/D8KdxH+DW3uYkmKQ7botbsOSdR8iSOfnmOLFutTxYZUkgNwxGoBM0n2wayj5UUgisfw7G2miA7OG7nxfTgBvzL10C6WcVxZE7y6C2RcAXDgSN1oZBRH/FG9vaH0mLId7o3L8DfAqMuQ5z6gZCOEX1csC0YN4tZoeRbrgjB+WE0TB1n5E674v0JOzzrp0LrC4310ge+MgQi/IoNjUcmek8i0gpG9LoFG7UyRIPbIbumor45gLQaBv8zH9yeNh7hFD4QR+cfrU6zYubwHX74pEAmHgzI8Bkfxi/R/fhhRc3if3doowNsAkokoS09/UerfQmws8tfg+8LRXTo/RohqM76gZ7M=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 020bcfa4-c199-4709-9824-08d6ce7fa9af
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 21:55:02.7112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5868
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
