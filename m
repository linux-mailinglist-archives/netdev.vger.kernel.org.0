Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0F144B1B7
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 18:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240731AbhKIRID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 12:08:03 -0500
Received: from mswedge2.sunplus.com ([60.248.182.106]:39736 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231883AbhKIRIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 12:08:02 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(57744:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Wed, 10 Nov 2021 01:05:06 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Wed, 10 Nov 2021 01:05:01 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Wed, 10 Nov
 2021 01:05:01 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Subject: RE: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Topic: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKvxfraAgAGf2kCAAU6CgIAE3RVA///T9oCAAJMwUP//h9mAgACMUqD//6B2AAA6wUXQ//+arYD//2ouwA==
Date:   Tue, 9 Nov 2021 17:05:01 +0000
Message-ID: <da39cce70a2849799bfff07394e27b0d@sphcmbx02.sunplus.com.tw>
References: <YYK+EeCOu/BXBXDi@lunn.ch>
 <64626e48052c4fba9057369060bfbc84@sphcmbx02.sunplus.com.tw>
 <YYUzgyS6pfQOmKRk@lunn.ch>
 <7c77f644b7a14402bad6dd6326ba85b1@sphcmbx02.sunplus.com.tw>
 <YYkjBdu64r2JF1bR@lunn.ch>
 <4e663877558247048e9b04b027e555b8@sphcmbx02.sunplus.com.tw>
 <YYk5s5fDuub7eBqu@lunn.ch>
 <585e234fdb74499caafee3b43b5e5ab4@sphcmbx02.sunplus.com.tw>
 <YYlfRB7updHplnLE@lunn.ch>
 <941aabfafa674999b2c0f4fc88025518@sphcmbx02.sunplus.com.tw>
 <YYqUkfepXZzGpR3w@lunn.ch>
In-Reply-To: <YYqUkfepXZzGpR3w@lunn.ch>
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

PiA+IEkgZG9uJ3Qga25vdyBob3cgdG8gaW1wbGVtZW50IFNUUCBpbiBMMiBzd2l0Y2ggbGlrZSBT
UDcwMjEuDQo+IA0KPiBUaGF0IGlzIHRoZSBuaWNlIHRoaW5nIGFib3V0IHVzaW5nIExpbnV4LiBJ
dCBhbHJlYWR5IGtub3dzIGhvdyB0byBpbXBsZW1lbnQNCj4gU1RQLiBUaGUgYnJpZGdlIHdpbGwg
ZG8gaXQgZm9yIHlvdS4gWW91IGp1c3QgbmVlZCB0byBhZGQgdGhlIGNhbGxiYWNrcyBpbiB0aGUN
Cj4gZHJpdmVyIHdoaWNoIGFyZSBuZWVkZWQuIFBsZWFzZSB0YWtlIGEgbG9vayBhdCBvdGhlciBz
d2l0Y2hkZXYgZHJpdmVycy4NCj4gDQo+ID4gSWYgdGhpcyBpcyBhY2NlcHRhYmxlLCBJJ2QgbGlr
ZSB0byBoYXZlIEV0aGVybmV0IG9mIFNQNzAyMSBoYXZlIHR3bw0KPiA+IG9wZXJhdGlvbg0KPiA+
IG1vZGVzOg0KPiA+ICAtIER1YWwgTklDIG1vZGUNCj4gPiAgLSBTaW5nbGUgTklDIHdpdGggMi1w
b3J0IGZyYW1lLWZsb29kaW5nIGh1YiBtb2RlDQo+IA0KPiBObywgc29ycnkuIERvIGl0IGNvcnJl
Y3RseSwgb3IgZG8gbm90IGRvIGl0LiBQbGVhc2Ugc3RhcnQgd2l0aCBhIGNsZWFuIGRyaXZlciBk
b2luZw0KPiBEdWFsIE5JQyBtb2RlLiBZb3UgY2FuIGFkZCBMMiBzdXBwb3J0IGxhdGVyLCBvbmNl
IHlvdSBoYXZlIGRvbmUgdGhlIHJlc2VhcmNoDQo+IHRvIHVuZGVyc3RhbmQgc3dpdGNoZGV2LCBl
dGMuDQoNClNvcnJ5LCBJIHdpbGwgZ28gd2l0aCBEdWFsIE5JQyBtb2RlLiBJJ2xsIGRvIGEgd2hv
bGUgY2xlYW51cCBvbiBkcml2ZXIgZm9yIHRoaXMuDQpQbGVhc2Uga2luZGx5IHJldmlldyBhZ2Fp
bi4NCg0KSSBuZWVkIHRpbWUgdG8gc3R1ZHkgbW9yZSBhYm91dCBzd2l0Y2hkZXYgYW5kIHByb3Bv
c2UgYSBwbGFuIHRvIGhpZ2gNCm1hbmFnZW1lbnQgb2YgY29tcGFueS4gSG93ZXZlciwgU3VucGx1
cyBpcyBub3QgYSBuZXR3b3JraW5nIGNvbXBhbnksIA0KYnV0IHRhcmdldHMgb24gTGludXgtYmFz
ZWQgaW5kdXN0cmlhbCBjb250cm9sLCBhdXRvbm9tb3VzIG1vYmlsZSByb2JvdCwgLi4uDQoNCg0K
PiA+IFJNSUkgcGlucyBvZiBQSFkgcG9ydHMgb2YgU1A3MDIxIGFyZSBtdWx0aXBsZXhhYmxlLiBJ
J2QgbGlrZSB0byBzd2l0Y2gNCj4gPiBSTUlJIHBpbnMgb2YgdGhlIHNlY29uZCBQSFkgZm9yIG90
aGVyIHVzZSBpZiBzaW5nbGUgTklDIG1vZGUgaXMgdXNlZC4NCj4gPiBJbiBmYWN0LCBzb21lIFNQ
NzAyMSBib2FyZHMgaGF2ZSBkdWFsIEV0aGVybmV0IGFuZCBzb21lIGhhdmUgb25seSBvbmUNCj4g
PiBFdGhlcm5ldC4gV2UgcmVhbGx5IG5lZWQgdGhlIHR3byBvcGVyYXRpb24gbW9kZXMuDQo+IA0K
PiBPbmx5IHVzaW5nIGEgc3Vic2V0IG9mIHBvcnRzIGluIGEgc3dpdGNoIGlzIGNvbW1vbi4gVGhl
IGNvbW1vbiBiaW5kaW5nIGZvcg0KPiBEU0Egc3dpdGNoZXMgaXMgZGVzY3JpYmVkIGluOg0KPiAN
Cj4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvZHNhLnlhbWwgYW5k
IGZvciBleGFtcGxlDQo+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNh
L2hpcnNjaG1hbm4saGVsbGNyZWVrLnlhbWwgaXMgYQ0KPiBtZW1vcnkgbWFwcGVkIHN3aXRjaC4g
Tm90aWNlIHRoZSByZWcgbnVtYmVyczoNCj4gDQo+ICAgICAgICAgICAgZXRoZXJuZXQtcG9ydHMg
ew0KPiAgICAgICAgICAgICAgICAgI2FkZHJlc3MtY2VsbHMgPSA8MT47DQo+ICAgICAgICAgICAg
ICAgICAjc2l6ZS1jZWxscyA9IDwwPjsNCj4gDQo+ICAgICAgICAgICAgICAgICBwb3J0QDAgew0K
PiAgICAgICAgICAgICAgICAgICAgIHJlZyA9IDwwPjsNCj4gICAgICAgICAgICAgICAgICAgICBs
YWJlbCA9ICJjcHUiOw0KPiAgICAgICAgICAgICAgICAgICAgIGV0aGVybmV0ID0gPCZnbWFjMD47
DQo+ICAgICAgICAgICAgICAgICB9Ow0KPiANCj4gICAgICAgICAgICAgICAgIHBvcnRAMiB7DQo+
ICAgICAgICAgICAgICAgICAgICAgcmVnID0gPDI+Ow0KPiAgICAgICAgICAgICAgICAgICAgIGxh
YmVsID0gImxhbjAiOw0KPiAgICAgICAgICAgICAgICAgICAgIHBoeS1oYW5kbGUgPSA8JnBoeTE+
Ow0KPiAgICAgICAgICAgICAgICAgfTsNCj4gDQo+IHJlZyA9IDwxPiBpcyBtaXNzaW5nIGluIHRo
aXMgZXhhbXBsZS4gUG9ydCAxIG9mIHRoZSBzd2l0Y2ggaXMgbm90IHVzZWQuIFlvdSBjYW4NCj4g
ZG8gdGhlIHNhbWUgd2l0aCBhIDIgcG9ydCBzd2l0Y2gsIHdoZW4geW91IGRvbid0IHdhbnQgdG8g
bWFrZSB1c2Ugb2YgYSBwb3J0Lg0KPiBKdXN0IGRvbid0IGxpc3QgaXQgaW4gRFQuDQoNClRoYW5r
IHlvdSBmb3Igcm91dGluZyBtZSB0byB0aGUgZG9jdW1lbnQuDQpOb3cgSSBrbm93IHRoZXJlIGFy
ZSBzd2l0Y2ggZGV2aWNlIGV4YW1wbGVzIGluIGZvbGRlciBkc2EvLg0KV2UgY2FuIHJlZmVyIHRv
IHRoZW0gd2hlbiB3ZSB3YW50IHRvIG1ha2UgYSBzd2l0Y2guDQoNCg0KPiA+IEFmdGVyIGxvb2tp
bmcgdXAgc29tZSBkYXRhLCBJIGZpbmQgUk1DIG1lYW5zIHJlc2VydmVkIG11bHRpLWNhc3QuDQo+
ID4gUk1DIHBhY2tldHMgbWVhbnMgcGFja2V0cyB3aXRoIERBID0gMHgwMTgwYzIwMDAwMDAsIDB4
MDE4MGMyMDAwMDAyIH4NCj4gPiAweDAxODBjMjAwMDAwZiwgZXhjZXB0IHRoZSBQQVVTRSBwYWNr
ZXQgKERBID0gMHgwMTgwYzIwMDAwMDEpDQo+IA0KPiBBaCwgZ29vZC4gQlBEVXMgdXNlIDAxOjgw
OkMyOjAwOjAwOjAwLiBTbyB0aGV5IHdpbGwgYmUgcGFzc2VkIHdoZW4gdGhlIHBvcnQgaXMNCj4g
aW4gYmxvY2tpbmcgbW9kZS4gUFRQIHVzZXMgMDE6ODA6QzI6MDA6MDA6MEUuIFNvIHRoZSBoYXJk
d2FyZSBkZXNpZ25lcnMNCj4gYXBwZWFyIHRvIG9mIGRlc2lnbmVkIGEgcHJvcGVyIEwyIHN3aXRj
aCB3aXRoIGV2ZXJ5dGhpbmcgeW91IG5lZWQgZm9yIGENCj4gbWFuYWdlZCBzd2l0Y2guIFdoYXQg
aXMgbWlzc2luZyBpcyBzb2Z0d2FyZS4gVGhlIG1vcmUgaSBsZWFybiBhYm91dCB0aGlzDQo+IGhh
cmR3YXJlLCB0aGUgbW9yZSBpJ3ZlIGNvbnZpbmNlZCB5b3UgbmVlZCB0byB3cml0ZSBwcm9wZXIg
TGludXggc3VwcG9ydCBmb3INCj4gaXQsIG5vdCB5b3VyIG1vZGUgaGFja3MuDQo+IA0KPiAgICAg
QW5kcmV3DQoNClRoYW5rcyBmb3IgY29uZmlybWluZyB0aGF0IHRoZSBMMiBzd2l0Y2ggaXMgZ29v
ZCBlbm91Z2ggZm9yIHN3aXRjaCBkZXZpY2UuDQpBY3R1YWxseSwgdGhlIElQIHdhcyBsaWNlbnNl
ZCBmcm9tIG90aGVyIGNvbXBhbnkgbG9uZyBhZ28uIFdlIGRvbqGmdCBrbm93IA0KYWxsIGRldGFp
bHMuDQoNCg==
