Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEE8996B8
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733118AbfHVOdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:33:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3947 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbfHVOdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 10:33:21 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 57833C69CDDBA8AEFD72;
        Thu, 22 Aug 2019 22:33:15 +0800 (CST)
Received: from dggeme704-chm.china.huawei.com (10.1.199.100) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 22 Aug 2019 22:33:14 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme704-chm.china.huawei.com (10.1.199.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 22 Aug 2019 22:33:14 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1591.008;
 Thu, 22 Aug 2019 22:33:14 +0800
From:   "zhangsha (A)" <zhangsha.zhang@huawei.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yuehaibing <yuehaibing@huawei.com>,
        hunongda <hunongda@huawei.com>,
        "Chenzhendong (alex)" <alex.chen@huawei.com>
Subject: RE: [PATCH] bonding: force enable lacp port after link state recovery
 for 802.3ad
Thread-Topic: [PATCH] bonding: force enable lacp port after link state
 recovery for 802.3ad
Thread-Index: AQHVV1yNiE92g/fPt0eCCAQnmCU0dqcEJTkAgAMVw0A=
Date:   Thu, 22 Aug 2019 14:33:14 +0000
Message-ID: <bf596a59f3124e7abf796b09811d7264@huawei.com>
References: <20190820133822.2508-1-zhangsha.zhang@huawei.com>
 <27042.1566342874@famine>
In-Reply-To: <27042.1566342874@famine>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.220.209]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmF5IFZvc2J1cmdoIFtt
YWlsdG86amF5LnZvc2J1cmdoQGNhbm9uaWNhbC5jb21dDQo+IFNlbnQ6IDIwMTnE6jjUwjIxyNUg
NzoxNQ0KPiBUbzogemhhbmdzaGEgKEEpIDx6aGFuZ3NoYS56aGFuZ0BodWF3ZWkuY29tPg0KPiBD
YzogdmZhbGljb0BnbWFpbC5jb207IGFuZHlAZ3JleWhvdXNlLm5ldDsgZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZzsgeXVlaGFpYmluZw0KPiA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPjsgaHVub25nZGEgPGh1
bm9uZ2RhQGh1YXdlaS5jb20+Ow0KPiBDaGVuemhlbmRvbmcgKGFsZXgpIDxhbGV4LmNoZW5AaHVh
d2VpLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gYm9uZGluZzogZm9yY2UgZW5hYmxlIGxh
Y3AgcG9ydCBhZnRlciBsaW5rIHN0YXRlIHJlY292ZXJ5DQo+IGZvciA4MDIuM2FkDQo+IA0KPiA8
emhhbmdzaGEuemhhbmdAaHVhd2VpLmNvbT4gd3JvdGU6DQo+IA0KPiA+RnJvbTogU2hhIFpoYW5n
IDx6aGFuZ3NoYS56aGFuZ0BodWF3ZWkuY29tPg0KPiA+DQo+ID5BZnRlciB0aGUgY29tbWl0IDMz
NDAzMTIxOWE4NCAoImJvbmRpbmcvODAyLjNhZDogZml4IHNsYXZlIGxpbmsNCj4gPmluaXRpYWxp
emF0aW9uIHRyYW5zaXRpb24gc3RhdGVzIikgbWVyZ2VkLCB0aGUgc2xhdmUncyBsaW5rIHN0YXR1
cyB3aWxsDQo+ID5iZSBjaGFuZ2VkIHRvIEJPTkRfTElOS19GQUlMIGZyb20gQk9ORF9MSU5LX0RP
V04gaW4gdGhlIGZvbGxvd2luZw0KPiA+c2NlbmFyaW86DQo+ID4tIERyaXZlciByZXBvcnRzIGxv
c3Mgb2YgY2FycmllciBhbmQNCj4gPiAgYm9uZGluZyBkcml2ZXIgcmVjZWl2ZXMgTkVUREVWX0NI
QU5HRSBub3RpZmllcg0KPiA+LSBzbGF2ZSdzIGR1cGxleCBhbmQgc3BlZWQgaXMgemVyb2QgYW5k
DQo+ID4gIGl0cyBwb3J0LT5pc19lbmFibGVkIGlzIGNsZWFyZCB0byAnZmFsc2UnOw0KPiA+LSBE
cml2ZXIgcmVwb3J0cyBsaW5rIHJlY292ZXJ5IGFuZA0KPiA+ICBib25kaW5nIGRyaXZlciByZWNl
aXZlcyBORVRERVZfVVAgbm90aWZpZXI7DQo+ID4tIElmIHNwZWVkL2R1cGxleCBnZXR0aW5nIGZh
aWxlZCBoZXJlLCB0aGUgbGluayBzdGF0dXMNCj4gPiAgd2lsbCBiZSBjaGFuZ2VkIHRvIEJPTkRf
TElOS19GQUlMOw0KPiA+LSBUaGUgTUlJIG1vbm90b3IgbGF0ZXIgcmVjb3ZlciB0aGUgc2xhdmUn
cyBzcGVlZC9kdXBsZXgNCj4gPiAgYW5kIHNldCBsaW5rIHN0YXR1cyB0byBCT05EX0xJTktfVVAs
IGJ1dCByZW1haW5zDQo+ID4gIHRoZSAncG9ydC0+aXNfZW5hYmxlZCcgdG8gJ2ZhbHNlJy4NCj4g
Pg0KPiA+SW4gdGhpcyBzY2VuYXJpbywgdGhlIGxhY3AgcG9ydCB3aWxsIG5vdCBiZSBlbmFibGVk
IGV2ZW4gaXRzIHNwZWVkIGFuZA0KPiA+ZHVwbGV4IGFyZSB2YWxpZC4gVGhlIGJvbmQgd2lsbCBu
b3Qgc2VuZCBMQUNQRFUncywgYW5kIGl0cyBzdGF0ZSBpcw0KPiA+J0FEX1NUQVRFX0RFRkFVTFRF
RCcgZm9yZXZlci4gVGhlIHNpbXBsZXN0IGZpeCBJIHRoaW5rIGlzIHRvIGZvcmNlDQo+ID5lbmFi
bGUgbGFjcCBhZnRlciBwb3J0IHNsYXZlIHNwZWVkIGNoZWNrIGluIGJvbmRfbWlpbW9uX2NvbW1p
dC4gQXMNCj4gPmVuYWJsZWQsIHRoZSBsYWNwIHBvcnQgY2FuIHJ1biBpdHMgc3RhdGUgbWFjaGlu
ZSBub3JtYWxseSBhZnRlciBsaW5rDQo+ID5yZWNvdmVyeS4NCj4gPg0KPiA+U2lnbmVkLW9mZi1i
eTogU2hhIFpoYW5nIDx6aGFuZ3NoYS56aGFuZ0BodWF3ZWkuY29tPg0KPiA+LS0tDQo+ID4gZHJp
dmVycy9uZXQvYm9uZGluZy9ib25kX21haW4uYyB8IDggKysrKysrKy0NCj4gPiAxIGZpbGUgY2hh
bmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfbWFpbi5jDQo+ID5iL2RyaXZlcnMvbmV0L2JvbmRp
bmcvYm9uZF9tYWluLmMgaW5kZXggOTMxZDlkOS4uMzc5MjUzYSAxMDA2NDQNCj4gPi0tLSBhL2Ry
aXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMNCj4gPisrKyBiL2RyaXZlcnMvbmV0L2JvbmRp
bmcvYm9uZF9tYWluLmMNCj4gPkBAIC0yMTk0LDYgKzIxOTQsNyBAQCBzdGF0aWMgdm9pZCBib25k
X21paW1vbl9jb21taXQoc3RydWN0IGJvbmRpbmcNCj4gPipib25kKSAgew0KPiA+IAlzdHJ1Y3Qg
bGlzdF9oZWFkICppdGVyOw0KPiA+IAlzdHJ1Y3Qgc2xhdmUgKnNsYXZlLCAqcHJpbWFyeTsNCj4g
PisJc3RydWN0IHBvcnQgKnBvcnQ7DQo+ID4NCj4gPiAJYm9uZF9mb3JfZWFjaF9zbGF2ZShib25k
LCBzbGF2ZSwgaXRlcikgew0KPiA+IAkJc3dpdGNoIChzbGF2ZS0+bmV3X2xpbmspIHsNCj4gPkBA
IC0yMjA1LDggKzIyMDYsMTMgQEAgc3RhdGljIHZvaWQgYm9uZF9taWltb25fY29tbWl0KHN0cnVj
dCBib25kaW5nDQo+ICpib25kKQ0KPiA+IAkJCSAqIGxpbmsgc3RhdHVzDQo+ID4gCQkJICovDQo+
ID4gCQkJaWYgKEJPTkRfTU9ERShib25kKSA9PSBCT05EX01PREVfODAyM0FEICYmDQo+ID4tCQkJ
ICAgIHNsYXZlLT5saW5rID09IEJPTkRfTElOS19VUCkNCj4gPisJCQkgICAgc2xhdmUtPmxpbmsg
PT0gQk9ORF9MSU5LX1VQKSB7DQo+ID4NCj4gCWJvbmRfM2FkX2FkYXB0ZXJfc3BlZWRfZHVwbGV4
X2NoYW5nZWQoc2xhdmUpOw0KPiA+KwkJCQlpZiAoc2xhdmUtPmR1cGxleCA9PSBEVVBMRVhfRlVM
TCkgew0KPiA+KwkJCQkJcG9ydCA9ICYoU0xBVkVfQURfSU5GTyhzbGF2ZSktDQo+ID5wb3J0KTsN
Cj4gPisJCQkJCXBvcnQtPmlzX2VuYWJsZWQgPSB0cnVlOw0KPiA+KwkJCQl9DQo+ID4rCQkJfQ0K
PiANCj4gCUkgZG9uJ3QgYmVsaWV2ZSB0aGF0IHRlc3RpbmcgZHVwbGV4IGhlcmUgaXMgY29ycmVj
dDsgaXNfZW5hYmxlZCBpcyBub3QNCj4gY29udHJvbGxlZCBieSBkdXBsZXgsIGJ1dCBieSBjYXJy
aWVyIHN0YXRlLiAgRHVwbGV4IGRvZXMgYWZmZWN0IHdoZXRoZXIgb3Igbm90DQo+IGEgcG9ydCBp
cyBwZXJtaXR0ZWQgdG8gYWdncmVnYXRlLCBidXQgdGhhdCdzIGVudGlyZWx5IHNlcGFyYXRlIGxv
Z2ljICh0aGUNCj4gQURfUE9SVF9MQUNQX0VOQUJMRUQgZmxhZykuDQo+IA0KPiAJV291bGQgaXQg
YmUgYmV0dGVyIHRvIGNhbGwgYm9uZF8zYWRfaGFuZGxlX2xpbmtfY2hhbmdlKCkgaGVyZSwNCj4g
aW5zdGVhZCBvZiBtYW51YWxseSB0ZXN0aW5nIGR1cGxleCBhbmQgc2V0dGluZyBpc19lbmFibGVk
Pw0KPiANCj4gCS1KDQoNCkhpLCBKYXksDQpUaGFua3MgZm9yICB0aGUgcmVwbHkgYW5kIEkgdGhp
bmsgYm9uZF8zYWRfaGFuZGxlX2xpbmtfY2hhbmdlIGlzIGluZGVlZCBhIGJldHRlciB3YXkgaGVy
ZS4NCkkgd2lsbCBzZW5kIGEgbmV3IHBhdGNoIGxhdGVyIGFmdGVyIGhhdmluZyBpdCAgdGVzdGVk
Lg0KDQo+IA0KPiA+IAkJCWNvbnRpbnVlOw0KPiA+DQo+ID4gCQljYXNlIEJPTkRfTElOS19VUDoN
Cj4gPi0tDQo+ID4xLjguMy4xDQo+ID4NCj4gDQo+IC0tLQ0KPiAJLUpheSBWb3NidXJnaCwgamF5
LnZvc2J1cmdoQGNhbm9uaWNhbC5jb20NCg==
