Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012311183C8
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfLJJjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:39:18 -0500
Received: from mx21.baidu.com ([220.181.3.85]:33750 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726915AbfLJJjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 04:39:17 -0500
Received: from BJHW-Mail-Ex16.internal.baidu.com (unknown [10.127.64.39])
        by Forcepoint Email with ESMTPS id A3039B19AABF1;
        Tue, 10 Dec 2019 17:39:13 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex16.internal.baidu.com (10.127.64.39) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Tue, 10 Dec 2019 17:39:14 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Tue, 10 Dec 2019 17:39:14 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBwYWdlX3Bvb2w6IGhhbmRsZSBwYWdlIHJl?=
 =?utf-8?B?Y3ljbGUgZm9yIE5VTUFfTk9fTk9ERSBjb25kaXRpb24=?=
Thread-Topic: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Index: AQHVrBgioGDhH/MP9UuNcNvu7zNf3aeuC1gAgAMqtQCAAL3wgIAAIMoAgAEG1JA=
Date:   Tue, 10 Dec 2019 09:39:14 +0000
Message-ID: <bb3c3846334744d7bbe83b1a29eaa762@baidu.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191209131416.238d4ae4@carbon>
 <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
 <e9855bd9-dddd-e12c-c889-b872702f80d1@huawei.com>
In-Reply-To: <e9855bd9-dddd-e12c-c889-b872702f80d1@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.19]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex16_2019-12-10 17:39:14:464
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex16_GRAY_Inside_WithoutAtta_2019-12-10
 17:39:14:448
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gc3RhdGljIGludCBtdm5ldGFfY3JlYXRlX3BhZ2VfcG9vbChzdHJ1Y3QgbXZuZXRhX3Bv
cnQgKnBwLA0KPiAJCQkJICAgc3RydWN0IG12bmV0YV9yeF9xdWV1ZSAqcnhxLCBpbnQgc2l6ZSkg
ew0KPiAJc3RydWN0IGJwZl9wcm9nICp4ZHBfcHJvZyA9IFJFQURfT05DRShwcC0+eGRwX3Byb2cp
Ow0KPiAJc3RydWN0IHBhZ2VfcG9vbF9wYXJhbXMgcHBfcGFyYW1zID0gew0KPiAJCS5vcmRlciA9
IDAsDQo+IAkJLmZsYWdzID0gUFBfRkxBR19ETUFfTUFQIHwgUFBfRkxBR19ETUFfU1lOQ19ERVYs
DQo+IAkJLnBvb2xfc2l6ZSA9IHNpemUsDQo+IAkJLm5pZCA9IGNwdV90b19ub2RlKDApLA0KDQpU
aGlzIGtpbmQgb2YgZGV2aWNlIHNob3VsZCBvbmx5IGJlIGluc3RhbGxlZCB0byB2ZW5kb3IncyBw
bGF0Zm9ybSB3aGljaCBkaWQgbm90IHN1cHBvcnQgbnVtYQ0KDQpCdXQgYXMgeW91IHNheSAsIFNh
ZWVkIGFkdmljZSBtYXliZSBjYXVzZSB0aGF0IHJlY3ljbGUgYWx3YXlzIGZhaWwsIGlmIG5pZCBp
cyBjb25maWd1cmVkIGxpa2UgdXBwZXIsIGFuZCBkaWZmZXJlbnQgZnJvbSBydW5uaW5nIE5BUEkg
bm9kZSBpZA0KDQpBbmQgbWF5YmUgd2UgY2FuIGNhdGNoIHRoaXMgY2FzZSBieSB0aGUgYmVsb3cN
Cg0KZGlmZiAtLWdpdCBhL25ldC9jb3JlL3BhZ2VfcG9vbC5jIGIvbmV0L2NvcmUvcGFnZV9wb29s
LmMNCmluZGV4IDNjOGI1MWNjZDFjMS4uOTczMjM1YzA5NDg3IDEwMDY0NA0KLS0tIGEvbmV0L2Nv
cmUvcGFnZV9wb29sLmMNCisrKyBiL25ldC9jb3JlL3BhZ2VfcG9vbC5jDQpAQCAtMzI4LDYgKzMy
OCwxMSBAQCBzdGF0aWMgYm9vbCBwb29sX3BhZ2VfcmV1c2FibGUoc3RydWN0IHBhZ2VfcG9vbCAq
cG9vbCwgc3RydWN0IHBhZ2UgKnBhZ2UpDQogdm9pZCBfX3BhZ2VfcG9vbF9wdXRfcGFnZShzdHJ1
Y3QgcGFnZV9wb29sICpwb29sLCBzdHJ1Y3QgcGFnZSAqcGFnZSwNCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgdW5zaWduZWQgaW50IGRtYV9zeW5jX3NpemUsIGJvb2wgYWxsb3dfZGlyZWN0KQ0K
IHsNCisgICAgICAgYWxsb3dfZGlyZWN0ID0gYWxsb3dfZGlyZWN0ICYmIGluX3NlcnZpbmdfc29m
dGlycSgpOw0KKw0KKyAgICAgICBpZiAoYWxsb3dfZGlyZWN0KQ0KKyAgICAgICAgICAgICAgIFdB
Uk5fT05fT05DRSgocG9vbC0+cC5uaWQgIT0gTlVNQV9OT19OT0RFKSAmJg0KKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIChwb29sLT5wLm5pZCAhPSBudW1hX21lbV9pZCgpKSk7
DQogICAgICAgIC8qIFRoaXMgYWxsb2NhdG9yIGlzIG9wdGltaXplZCBmb3IgdGhlIFhEUCBtb2Rl
IHRoYXQgdXNlcw0KICAgICAgICAgKiBvbmUtZnJhbWUtcGVyLXBhZ2UsIGJ1dCBoYXZlIGZhbGxi
YWNrcyB0aGF0IGFjdCBsaWtlIHRoZQ0KICAgICAgICAgKiByZWd1bGFyIHBhZ2UgYWxsb2NhdG9y
IEFQSXMuDQpAQCAtMzQyLDcgKzM0Nyw3IEBAIHZvaWQgX19wYWdlX3Bvb2xfcHV0X3BhZ2Uoc3Ry
dWN0IHBhZ2VfcG9vbCAqcG9vbCwgc3RydWN0IHBhZ2UgKnBhZ2UsDQogICAgICAgICAgICAgICAg
ICAgICAgICBwYWdlX3Bvb2xfZG1hX3N5bmNfZm9yX2RldmljZShwb29sLCBwYWdlLA0KICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZG1hX3N5bmNf
c2l6ZSk7DQogDQotICAgICAgICAgICAgICAgaWYgKGFsbG93X2RpcmVjdCAmJiBpbl9zZXJ2aW5n
X3NvZnRpcnEoKSkNCisgICAgICAgICAgICAgICBpZiAoYWxsb3dfZGlyZWN0KQ0KICAgICAgICAg
ICAgICAgICAgICAgICAgaWYgKF9fcGFnZV9wb29sX3JlY3ljbGVfZGlyZWN0KHBhZ2UsIHBvb2wp
KQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXR1cm47DQoNCg0KLUxpDQoNCj4g
CQkuZGV2ID0gcHAtPmRldi0+ZGV2LnBhcmVudCwNCj4gCQkuZG1hX2RpciA9IHhkcF9wcm9nID8g
RE1BX0JJRElSRUNUSU9OQUwgOiBETUFfRlJPTV9ERVZJQ0UsDQo+IAkJLm9mZnNldCA9IHBwLT5y
eF9vZmZzZXRfY29ycmVjdGlvbiwNCj4gCQkubWF4X2xlbiA9IE1WTkVUQV9NQVhfUlhfQlVGX1NJ
WkUsDQo+IAl9Ow0KPiANCj4gdGhlIHBvb2wtPnAubmlkIGlzIG5vdCBOVU1BX05PX05PREUsIHRo
ZW4gdGhlIG5vZGUgb2YgcGFnZSBhbGxvY2F0ZWQgZm9yIHJ4DQo+IG1heSBub3QgYmUgbnVtYV9t
ZW1faWQoKSB3aGVuIHJ1bm5pbmcgaW4gdGhlIE5BUEkgcG9sbGluZywgYmVjYXVzZQ0KPiBwb29s
LT5wLm5pZCBpcyBub3QgdGhlIHNhbWUgYXMgdGhlIG5vZGUgb2YgY3B1IHJ1bm5pbmcgaW4gdGhl
IE5BUEkgcG9sbGluZy4NCj4gDQo+IERvZXMgdGhlIHBhZ2UgcG9vbCBzdXBwb3J0IHJlY3ljbGlu
ZyBmb3IgYWJvdmUgY2FzZT8NCj4gDQo+IE9yIHdlICJmaXgnIHRoZSBhYm92ZSBjYXNlIGJ5IHNl
dHRpbmcgcG9vbC0+cC5uaWQgdG8NCj4gTlVNQV9OT19OT0RFL2Rldl90b19ub2RlKCksIG9yIGJ5
IGNhbGxpbmcgcG9vbF91cGRhdGVfbmlkKCkgaW4gTkFQSQ0KPiBwb2xsaW5nIGFzIG1seDUgZG9l
cz8NCj4gDQo+IA0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IFNhZWVkLg0KPiA+DQo+ID4NCj4gPg0K
PiA+DQo+ID4NCj4gPg0KPiA+DQoNCg==
