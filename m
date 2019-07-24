Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953FD736A9
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbfGXSge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:36:34 -0400
Received: from mail-eopbgr150073.outbound.protection.outlook.com ([40.107.15.73]:32654
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727716AbfGXSge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 14:36:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnZWURL0CRONFVQmQHBefrgFrTxgtb5qxmTEioEtWwhvg/F6LSVYJEhzC/sho/JiKnAhul5ktCgssW3G5qPG0oli/uuRe2O5NywUPPPcYSI3UP6GBVyPt/rBaoQ5VLE5mB+SWC+UxlMXyDCSepu5m0kdyDmHd0BVI1dE6fT8Pe/k1+R6IDsy9DxjhPNHrr7W5ac9pa5WJTX5F+BRiniIjfJvpTPO+UyW5tqU2O4o4kPxu/LAfj54qkLjcB/n/BxoSc9/8Z9ShG6Z39ZAeFRtsfwNBK2lxIKlxdV4zUeQIJqMETScPExbR2qxYQTMN0pvOj/mcKhdFtnKpLwrRswDeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94Z9h3lI4RctXDoi46IUbqvoHzAVol1ijQoz/rYOs58=;
 b=I1BSmcB3ZH1NOAIu+q4YAe7zzsbVGSuB7U1vN3Zv3gU0lXQxvjNnq5QUHyaMt5+A4/+y1U0SJL1rqI+a2SvQXKSuf7tlckSroGz6FF8cFLAg/uuN1eWhQGws83LgemBXqG9+UnjDMTKGJll2KKyrPIoJ/4Yk1N/SyR0wfxbWTbV+03SH5ZCbgMJ26XkRxlvF1YlX7oi0HQOVONyO7BHkcWpY9v8fSM+grMFFG++Ws1mcIY1N8o7XRMktd660SachWq+jcDZVQkRtmrNUhbZu8VB3qk3IHziojkqh/iUQGHHQF1Me03+/WtNKaQPkIbeBXmE5QrGPA3ZiJnwh4R/aCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94Z9h3lI4RctXDoi46IUbqvoHzAVol1ijQoz/rYOs58=;
 b=mbuuMxbEpo94jggw7Ay/4JdU9lhl8GbfPXHA/uC4uSCDNkoN4uI7AkKO7gYd1AqPo5cxjwp74anBqbLpbUAkCswK4Ty/RFaw3UmrvnZFn174dl6yn58j0+BFFQ1Ukx1wvQQLZ3jWGZ2OxR5mXwk16oxigzYRC0vT5sEv33MTZCw=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2167.eurprd05.prod.outlook.com (10.168.58.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 18:34:50 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 18:34:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 06/11] net: hns3: modify firmware version display
 format
Thread-Topic: [PATCH net-next 06/11] net: hns3: modify firmware version
 display format
Thread-Index: AQHVQc7gPUQCkxP3gUGLgKEVDyBYDqbaGVMA
Date:   Wed, 24 Jul 2019 18:34:50 +0000
Message-ID: <4c4ce27c9a9372340c0e2b0f654b3fb9cd85b3e4.camel@mellanox.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
         <1563938327-9865-7-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1563938327-9865-7-git-send-email-tanhuazhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cf771be-785e-4047-71b0-08d710659cd1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2167;
x-ms-traffictypediagnostic: DB6PR0501MB2167:
x-microsoft-antispam-prvs: <DB6PR0501MB2167AB6E5CD4764097BE1E1ABEC60@DB6PR0501MB2167.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(189003)(199004)(2501003)(6486002)(36756003)(76176011)(4326008)(256004)(14454004)(66066001)(5660300002)(81166006)(316002)(3846002)(25786009)(8936002)(53936002)(476003)(76116006)(305945005)(6246003)(2616005)(11346002)(446003)(66446008)(66946007)(64756008)(81156014)(6116002)(6512007)(186003)(99286004)(66556008)(6506007)(86362001)(71190400001)(2906002)(478600001)(486006)(26005)(229853002)(102836004)(110136005)(118296001)(6436002)(7736002)(91956017)(68736007)(71200400001)(8676002)(54906003)(66476007)(58126008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2167;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Xs15pHkKVjKYA2tPumH8hVqcBKuudt54Bu0qpQGuatezX3Rp+KPPYb0+5wGAwKJ/IEwJJ0gEv3q1n/kI60z4z+49e/i35bCHRFfkw2Rjoc1ZUSCM4/3g3MllXKZYwFn0G7r2QZJZxY4f1VCqOamVVxJr588VKg9yhu5iK4nQZIbOuGpWtAdtAs9apP5nNzAheUj9oZJfw9Ql84l9W0kkVD/G8u56lboHDfi+CLv5mgW3X44BYapatrQXXG0NMjrdOYpF7pSwXj6arTH9j+y8KkQL6yx05aBaRnstgawU0j+Ld2qfrcDb86UzGhnI3EQRthSL6TMuGy80Y2YBLFL4zvUwJvOuS386T6LPxF9EgzRKf1ZyT4AV4WjMU0snCFO4YxzemzDq+BVvWU9/t2E35aFqKCrRYxOq6+ZfFV4Bhzs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B3704AC2642B8499370B2B78642FDED@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf771be-785e-4047-71b0-08d710659cd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 18:34:50.3008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTI0IGF0IDExOjE4ICswODAwLCBIdWF6aG9uZyBUYW4gd3JvdGU6DQo+
IEZyb206IFl1ZmVuZyBNbyA8bW95dWZlbmdAaHVhd2VpLmNvbT4NCj4gDQo+IFRoaXMgcGF0Y2gg
bW9kaWZpZXMgZmlybXdhcmUgdmVyc2lvbiBkaXNwbGF5IGZvcm1hdCBpbg0KPiBoY2xnZSh2Zilf
Y21kX2luaXQoKSBhbmQgaG5zM19nZXRfZHJ2aW5mbygpLiBBbHNvLCBhZGRzDQo+IHNvbWUgb3B0
aW1pemF0aW9ucyBmb3IgZmlybXdhcmUgdmVyc2lvbiBkaXNwbGF5IGZvcm1hdC4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IFl1ZmVuZyBNbyA8bW95dWZlbmdAaHVhd2VpLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogUGVuZyBMaSA8bGlwZW5nMzIxQGh1YXdlaS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEh1
YXpob25nIFRhbiA8dGFuaHVhemhvbmdAaHVhd2VpLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9obmFlMy5oICAgICAgICAgICAgICB8ICA5DQo+ICsr
KysrKysrKw0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5zM19ldGh0
b29sLmMgICAgICAgfCAxNQ0KPiArKysrKysrKysrKysrLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2hpc2lsaWNvbi9obnMzL2huczNwZi9oY2xnZV9jbWQuYyAgIHwgMTANCj4gKysrKysrKysr
LQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5zM3ZmL2hjbGdldmZf
Y21kLmMgfCAxMQ0KPiArKysrKysrKystLQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCA0MCBpbnNlcnRp
b25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2hpc2lsaWNvbi9obnMzL2huYWUzLmgNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9o
aXNpbGljb24vaG5zMy9obmFlMy5oDQo+IGluZGV4IDQ4YzdiNzAuLmE0NjI0ZGIgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMzL2huYWUzLmgNCj4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5hZTMuaA0KPiBAQCAtMTc5
LDYgKzE3OSwxNSBAQCBzdHJ1Y3QgaG5hZTNfdmVjdG9yX2luZm8gew0KPiAgI2RlZmluZSBITkFF
M19SSU5HX0dMX1JYIDANCj4gICNkZWZpbmUgSE5BRTNfUklOR19HTF9UWCAxDQo+ICANCj4gKyNk
ZWZpbmUgSE5BRTNfRldfVkVSU0lPTl9CWVRFM19TSElGVAkyNA0KPiArI2RlZmluZSBITkFFM19G
V19WRVJTSU9OX0JZVEUzX01BU0sJR0VOTUFTSygzMSwgMjQpDQo+ICsjZGVmaW5lIEhOQUUzX0ZX
X1ZFUlNJT05fQllURTJfU0hJRlQJMTYNCj4gKyNkZWZpbmUgSE5BRTNfRldfVkVSU0lPTl9CWVRF
Ml9NQVNLCUdFTk1BU0soMjMsIDE2KQ0KPiArI2RlZmluZSBITkFFM19GV19WRVJTSU9OX0JZVEUx
X1NISUZUCTgNCj4gKyNkZWZpbmUgSE5BRTNfRldfVkVSU0lPTl9CWVRFMV9NQVNLCUdFTk1BU0so
MTUsIDgpDQo+ICsjZGVmaW5lIEhOQUUzX0ZXX1ZFUlNJT05fQllURTBfU0hJRlQJMA0KPiArI2Rl
ZmluZSBITkFFM19GV19WRVJTSU9OX0JZVEUwX01BU0sJR0VOTUFTSyg3LCAwKQ0KPiArDQo+ICBz
dHJ1Y3QgaG5hZTNfcmluZ19jaGFpbl9ub2RlIHsNCj4gIAlzdHJ1Y3QgaG5hZTNfcmluZ19jaGFp
bl9ub2RlICpuZXh0Ow0KPiAgCXUzMiB0cXBfaW5kZXg7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9obnMzX2V0aHRvb2wuYw0KPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMzL2huczNfZXRodG9vbC5jDQo+IGluZGV4IDViZmY5
OGEuLmU3MWM5MmIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNv
bi9obnMzL2huczNfZXRodG9vbC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2ls
aWNvbi9obnMzL2huczNfZXRodG9vbC5jDQo+IEBAIC01MjcsNiArNTI3LDcgQEAgc3RhdGljIHZv
aWQgaG5zM19nZXRfZHJ2aW5mbyhzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqbmV0ZGV2LA0KPiAgew0K
PiAgCXN0cnVjdCBobnMzX25pY19wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYobmV0ZGV2KTsNCj4g
IAlzdHJ1Y3QgaG5hZTNfaGFuZGxlICpoID0gcHJpdi0+YWVfaGFuZGxlOw0KPiArCXUzMiBmd192
ZXJzaW9uOw0KPiAgDQo+ICAJaWYgKCFoLT5hZV9hbGdvLT5vcHMtPmdldF9md192ZXJzaW9uKSB7
DQo+ICAJCW5ldGRldl9lcnIobmV0ZGV2LCAiY291bGQgbm90IGdldCBmdyB2ZXJzaW9uIVxuIik7
DQo+IEBAIC01NDUsOCArNTQ2LDE4IEBAIHN0YXRpYyB2b2lkIGhuczNfZ2V0X2RydmluZm8oc3Ry
dWN0IG5ldF9kZXZpY2UNCj4gKm5ldGRldiwNCj4gIAkJc2l6ZW9mKGRydmluZm8tPmJ1c19pbmZv
KSk7DQo+ICAJZHJ2aW5mby0+YnVzX2luZm9bRVRIVE9PTF9CVVNJTkZPX0xFTiAtIDFdID0gJ1ww
JzsNCj4gIA0KPiAtCXNucHJpbnRmKGRydmluZm8tPmZ3X3ZlcnNpb24sIHNpemVvZihkcnZpbmZv
LT5md192ZXJzaW9uKSwNCj4gIjB4JTA4eCIsDQo+IC0JCSBwcml2LT5hZV9oYW5kbGUtPmFlX2Fs
Z28tPm9wcy0+Z2V0X2Z3X3ZlcnNpb24oaCkpOw0KPiArCWZ3X3ZlcnNpb24gPSBwcml2LT5hZV9o
YW5kbGUtPmFlX2FsZ28tPm9wcy0+Z2V0X2Z3X3ZlcnNpb24oaCk7DQo+ICsNCj4gKwlzbnByaW50
ZihkcnZpbmZvLT5md192ZXJzaW9uLCBzaXplb2YoZHJ2aW5mby0+ZndfdmVyc2lvbiksDQo+ICsJ
CSAiJWx1LiVsdS4lbHUuJWx1IiwNCj4gKwkJIGhuYWUzX2dldF9maWVsZChmd192ZXJzaW9uLA0K
PiBITkFFM19GV19WRVJTSU9OX0JZVEUzX01BU0ssDQo+ICsJCQkJIEhOQUUzX0ZXX1ZFUlNJT05f
QllURTNfU0hJRlQpLA0KPiArCQkgaG5hZTNfZ2V0X2ZpZWxkKGZ3X3ZlcnNpb24sDQo+IEhOQUUz
X0ZXX1ZFUlNJT05fQllURTJfTUFTSywNCj4gKwkJCQkgSE5BRTNfRldfVkVSU0lPTl9CWVRFMl9T
SElGVCksDQo+ICsJCSBobmFlM19nZXRfZmllbGQoZndfdmVyc2lvbiwNCj4gSE5BRTNfRldfVkVS
U0lPTl9CWVRFMV9NQVNLLA0KPiArCQkJCSBITkFFM19GV19WRVJTSU9OX0JZVEUxX1NISUZUKSwN
Cj4gKwkJIGhuYWUzX2dldF9maWVsZChmd192ZXJzaW9uLA0KPiBITkFFM19GV19WRVJTSU9OX0JZ
VEUwX01BU0ssDQo+ICsJCQkJIEhOQUUzX0ZXX1ZFUlNJT05fQllURTBfU0hJRlQpKTsNCj4gIH0N
Cj4gIA0KPiAgc3RhdGljIHUzMiBobnMzX2dldF9saW5rKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRk
ZXYpDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9o
bnMzcGYvaGNsZ2VfY21kLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5z
My9obnMzcGYvaGNsZ2VfY21kLmMNCj4gaW5kZXggMjJmNmFjZC4uYzIzMjBiZiAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5zM3BmL2hjbGdlX2Nt
ZC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMzL2huczNwZi9o
Y2xnZV9jbWQuYw0KPiBAQCAtNDE5LDcgKzQxOSwxNSBAQCBpbnQgaGNsZ2VfY21kX2luaXQoc3Ry
dWN0IGhjbGdlX2RldiAqaGRldikNCj4gIAl9DQo+ICAJaGRldi0+ZndfdmVyc2lvbiA9IHZlcnNp
b247DQo+ICANCj4gLQlkZXZfaW5mbygmaGRldi0+cGRldi0+ZGV2LCAiVGhlIGZpcm13YXJlIHZl
cnNpb24gaXMgJTA4eFxuIiwNCj4gdmVyc2lvbik7DQo+ICsJcHJfaW5mb19vbmNlKCJUaGUgZmly
bXdhcmUgdmVyc2lvbiBpcyAlbHUuJWx1LiVsdS4lbHVcbiIsDQo+ICsJCSAgICAgaG5hZTNfZ2V0
X2ZpZWxkKHZlcnNpb24sDQo+IEhOQUUzX0ZXX1ZFUlNJT05fQllURTNfTUFTSywNCj4gKwkJCQkg
ICAgIEhOQUUzX0ZXX1ZFUlNJT05fQllURTNfU0hJRlQpLA0KPiArCQkgICAgIGhuYWUzX2dldF9m
aWVsZCh2ZXJzaW9uLA0KPiBITkFFM19GV19WRVJTSU9OX0JZVEUyX01BU0ssDQo+ICsJCQkJICAg
ICBITkFFM19GV19WRVJTSU9OX0JZVEUyX1NISUZUKSwNCj4gKwkJICAgICBobmFlM19nZXRfZmll
bGQodmVyc2lvbiwNCj4gSE5BRTNfRldfVkVSU0lPTl9CWVRFMV9NQVNLLA0KPiArCQkJCSAgICAg
SE5BRTNfRldfVkVSU0lPTl9CWVRFMV9TSElGVCksDQo+ICsJCSAgICAgaG5hZTNfZ2V0X2ZpZWxk
KHZlcnNpb24sDQo+IEhOQUUzX0ZXX1ZFUlNJT05fQllURTBfTUFTSywNCj4gKwkJCQkgICAgIEhO
QUUzX0ZXX1ZFUlNJT05fQllURTBfU0hJRlQpKTsNCj4gIA0KDQpEZXZpY2UgbmFtZS9zdHJpbmcg
d2lsbCBub3QgYmUgcHJpbnRlZCBub3csIHdoYXQgaGFwcGVucyBpZiBpIGhhdmUNCm11bHRpcGxl
IGRldmljZXMgPyBhdCBsZWFzdCBwcmludCB0aGUgZGV2aWNlIG5hbWUgYXMgaXQgd2FzIGJlZm9y
ZQ0KDQo+ICAJcmV0dXJuIDA7DQo+ICANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2hpc2lsaWNvbi9obnMzL2huczN2Zi9oY2xnZXZmX2NtZC5jDQo+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5zM3ZmL2hjbGdldmZfY21kLmMNCj4gaW5kZXggNjUy
Yjc5Ni4uMDA0MTI1YiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxp
Y29uL2huczMvaG5zM3ZmL2hjbGdldmZfY21kLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaGlzaWxpY29uL2huczMvaG5zM3ZmL2hjbGdldmZfY21kLmMNCj4gQEAgLTQwNSw4ICs0MDUs
MTUgQEAgaW50IGhjbGdldmZfY21kX2luaXQoc3RydWN0IGhjbGdldmZfZGV2ICpoZGV2KQ0KPiAg
CX0NCj4gIAloZGV2LT5md192ZXJzaW9uID0gdmVyc2lvbjsNCj4gIA0KPiAtCWRldl9pbmZvKCZo
ZGV2LT5wZGV2LT5kZXYsICJUaGUgZmlybXdhcmUgdmVyc2lvbiBpcyAlMDh4XG4iLA0KPiB2ZXJz
aW9uKTsNCj4gLQ0KPiArCXByX2luZm9fb25jZSgiVGhlIGZpcm13YXJlIHZlcnNpb24gaXMgJWx1
LiVsdS4lbHUuJWx1XG4iLA0KPiArCQkgICAgIGhuYWUzX2dldF9maWVsZCh2ZXJzaW9uLA0KPiBI
TkFFM19GV19WRVJTSU9OX0JZVEUzX01BU0ssDQo+ICsJCQkJICAgICBITkFFM19GV19WRVJTSU9O
X0JZVEUzX1NISUZUKSwNCj4gKwkJICAgICBobmFlM19nZXRfZmllbGQodmVyc2lvbiwNCj4gSE5B
RTNfRldfVkVSU0lPTl9CWVRFMl9NQVNLLA0KPiArCQkJCSAgICAgSE5BRTNfRldfVkVSU0lPTl9C
WVRFMl9TSElGVCksDQo+ICsJCSAgICAgaG5hZTNfZ2V0X2ZpZWxkKHZlcnNpb24sDQo+IEhOQUUz
X0ZXX1ZFUlNJT05fQllURTFfTUFTSywNCj4gKwkJCQkgICAgIEhOQUUzX0ZXX1ZFUlNJT05fQllU
RTFfU0hJRlQpLA0KPiArCQkgICAgIGhuYWUzX2dldF9maWVsZCh2ZXJzaW9uLA0KPiBITkFFM19G
V19WRVJTSU9OX0JZVEUwX01BU0ssDQo+ICsJCQkJICAgICBITkFFM19GV19WRVJTSU9OX0JZVEUw
X1NISUZUKSk7DQo+ICAJcmV0dXJuIDA7DQo+ICANCg0KU2FtZS4NCg0K
