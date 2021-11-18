Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14284556E3
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 09:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244375AbhKRIZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 03:25:42 -0500
Received: from mswedge1.sunplus.com ([60.248.182.113]:35358 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S244270AbhKRIZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 03:25:42 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(29077:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Thu, 18 Nov 2021 16:22:37 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Thu, 18 Nov 2021 16:22:32 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Thu, 18 Nov
 2021 16:22:32 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        =?big5?B?VmluY2VudCBTaGloIKxJwEPCRQ==?= <vincent.shih@sunplus.com>
Subject: RE: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Topic: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Index: AQHX1ttDZ0jKVsi7r0auZS2tEQF+d6wADq2AgAXn1uCAAER4gIACwF1Q
Date:   Thu, 18 Nov 2021 08:22:32 +0000
Message-ID: <7f23aac12a5b46a5ae240146a26b0297@sphcmbx02.sunplus.com.tw>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <YY7/v1msiaqJF3Uy@lunn.ch>
 <452b9aa57d034bed988a685d320906c6@sphcmbx02.sunplus.com.tw>
 <YZQtZ4kMEGa+tFuU@lunn.ch>
In-Reply-To: <YZQtZ4kMEGa+tFuU@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.25.108.39]
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIA0KDQoNCj4gPiA+ID4gK3N0YXRpYyBjb25zdCBjaGFyIGRlZl9tYWNfYWRkcltFVEhFUk5F
VF9NQUNfQUREUl9MRU5dID0gew0KPiA+ID4gPiArCTB4ZmMsIDB4NGIsIDB4YmMsIDB4MDAsIDB4
MDAsIDB4MDANCj4gPiA+DQo+ID4gPiBUaGlzIGRvZXMgbm90IGhhdmUgdGhlIGxvY2FsbHkgYWRt
aW5pc3RlcmVkIGJpdCBzZXQuIFNob3VsZCBpdD8gT3INCj4gPiA+IGlzIHRoaXMgYW5kIGFkZHJl
c3MgZnJvbSB5b3VyIE9VST8NCj4gPg0KPiA+IFRoaXMgaXMgZGVmYXVsdCBNQUMgYWRkcmVzcyB3
aGVuIE1BQyBhZGRyZXNzIGluIE5WTUVNIGlzIG5vdCBmb3VuZC4NCj4gPiBGYzo0YjpiYzowMDow
MDowMCBpcyBPVUkgb2YgIlN1bnBsdXMgVGVjaG5vbG9neSBDby4sIEx0ZC4iLg0KPiA+IENhbiBJ
IGtlZXAgdGhpcz8gb3IgaXQgc2hvdWxkIGJlIHJlbW92ZWQ/DQo+IA0KPiBQbGVhc2UgYWRkIGEg
Y29tbWVudCBhYm91dCB3aG9zIE9VSSBpdCBpcy4NCj4gDQo+IEl0IGlzIGhvd2V2ZXIgbW9yZSBu
b3JtYWwgdG8gdXNlIGEgcmFuZG9tIE1BQyBhZGRyZXNzIGlmIG5vIG90aGVyIE1BQyBhZGRyZXNz
IGlzIGF2YWlsYWJsZS4NCj4gVGhhdCB3YXksIHlvdSBhdm9pZCBtdWx0aXBsZSBkZXZpY2VzIG9u
IG9uZSBMQU4gdXNpbmcgdGhlIHNhbWUgZGVmYXVsdCBNQUMgYWRkcmVzcy4NCg0KWWVzLCBJJ2xs
IGFkZCBhIGNvbW1lbnQgYWJvdXQgdGhlIE9VSSBhbmQgYWxzbyB1c2UgJ2dldF9yYW5kb21faW50
KCkgJSAyNTUnIA0KdG8gZ2VuZXJhdGUgdGhlIGxhdGVzdCAzIG9jdGV0cyAoY29udHJvbGxlciBz
cGVjaWZpYykuDQoNCg0KPiA+ID4gPiArCWlmIChtYWMtPm5leHRfbmRldikgew0KPiA+ID4gPiAr
CQlzdHJ1Y3QgbmV0X2RldmljZSAqbmRldjIgPSBtYWMtPm5leHRfbmRldjsNCj4gPiA+ID4gKw0K
PiA+ID4gPiArCQlpZiAoIW5ldGlmX2NhcnJpZXJfb2sobmRldjIpICYmIChyZWcgJiBQT1JUX0FC
SUxJVFlfTElOS19TVF9QMSkpIHsNCj4gPiA+ID4gKwkJCW5ldGlmX2NhcnJpZXJfb24obmRldjIp
Ow0KPiA+ID4gPiArCQkJbmV0aWZfc3RhcnRfcXVldWUobmRldjIpOw0KPiA+ID4gPiArCQl9IGVs
c2UgaWYgKG5ldGlmX2NhcnJpZXJfb2sobmRldjIpICYmICEocmVnICYgUE9SVF9BQklMSVRZX0xJ
TktfU1RfUDEpKSB7DQo+ID4gPiA+ICsJCQluZXRpZl9jYXJyaWVyX29mZihuZGV2Mik7DQo+ID4g
PiA+ICsJCQluZXRpZl9zdG9wX3F1ZXVlKG5kZXYyKTsNCj4gPiA+ID4gKwkJfQ0KPiA+ID4NCj4g
PiA+IExvb2tzIHZlcnkgb2RkLiBUaGUgdHdvIG5ldGRldiBzaG91bGQgYmUgaW5kZXBlbmRlbnQu
DQo+ID4NCj4gPiBJIGRvbid0IHVuZGVyc3RhbmQgeW91ciBjb21tZW50Lg0KPiA+IG5kZXYgY2hl
Y2tzIFBPUlRfQUJJTElUWV9MSU5LX1NUX1AwDQo+ID4gbmRldjIgY2hlY2tzIFBPUlRfQUJJTElU
WV9MSU5LX1NUX1AxDQo+ID4gVGhleSBhcmUgaW5kZXBlbmRlbnQgYWxyZWFkeS4NCj4gDQo+IEkg
d291bGQgdHJ5IHRvIHJlbW92ZSB0aGUgbWFjLT5uZXh0X25kZXYuIEkgdGhpbmsgd2l0aG91dCB0
aGF0LCB5b3Ugd2lsbCBnZXQgYSBjbGVhbmVyDQo+IGFic3RyYWN0aW9uLiBZb3UgbWlnaHQgd2Fu
dCB0byBrZWVwIGFuIGFycmF5IG9mIG1hYyBwb2ludGVycyBpbiB5b3VyIHRvcCBsZXZlbCBzaGFy
ZWQNCj4gc3RydWN0dXJlLg0KDQpZZXMsIEknbGwgZGVmaW5lIGEgYXJyYXkgKHBvaW50ZXIgdG8g
c3RydWN0IG5ldF9kZXYgb3IgbWFjKSBpbiBkcml2ZXIgcHJpdmF0ZSAoc2hhcmVkKSANCnN0cnVj
dHVyZSB0byBhY2Nlc3MgdG8gYWxsIG5ldCBkZXZpY2VzLiBObyBtb3JlIG1hYy0+bmV4dF9uZGV2
Oy4NCg0KDQo+IAkgQW5kcmV3DQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgcmV2aWV3
Lg0KDQpCZXN0IHJlZ2FyZHMsDQpXZWxscw0K
