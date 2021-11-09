Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1C744AFAA
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbhKIOmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:42:35 -0500
Received: from mswedge1.sunplus.com ([60.248.182.113]:56046 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231136AbhKIOmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 09:42:35 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(25039:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Tue, 09 Nov 2021 22:39:38 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Tue, 9 Nov 2021 22:39:33 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Tue, 9 Nov 2021
 22:39:33 +0800
From:   =?utf-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
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
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKvxfraAgAGf2kCAAU6CgIAE3RVA///T9oCAAJMwUP//h9mAgACMUqD//6B2AAA6wUXQ
Date:   Tue, 9 Nov 2021 14:39:33 +0000
Message-ID: <941aabfafa674999b2c0f4fc88025518@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <YYK+EeCOu/BXBXDi@lunn.ch>
 <64626e48052c4fba9057369060bfbc84@sphcmbx02.sunplus.com.tw>
 <YYUzgyS6pfQOmKRk@lunn.ch>
 <7c77f644b7a14402bad6dd6326ba85b1@sphcmbx02.sunplus.com.tw>
 <YYkjBdu64r2JF1bR@lunn.ch>
 <4e663877558247048e9b04b027e555b8@sphcmbx02.sunplus.com.tw>
 <YYk5s5fDuub7eBqu@lunn.ch>
 <585e234fdb74499caafee3b43b5e5ab4@sphcmbx02.sunplus.com.tw>
 <YYlfRB7updHplnLE@lunn.ch>
In-Reply-To: <YYlfRB7updHplnLE@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.25.108.39]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBNb24sIE5vdiAwOCwgMjAyMSBhdCAwNDo0NzozNFBNICswMDAwLCBXZWxscyBMdSDlkYLo
irPpqLAgd3JvdGU6DQo+ID4gPiA+IFRoZSBzd2l0Y2ggd2lsbCBub3QgcmVjb2duaXplIHR5cGUg
b2YgcGFja2V0cywgcmVnYXJkbGVzcyBCUERVLA0KPiA+ID4gPiBQVFAgb3IgYW55IG90aGVyIHBh
Y2tldHMuIElmIHR1cm5pbmcgb2ZmIHNvdXJjZS1hZGRyZXNzIGxlYXJuaW5nDQo+ID4gPiA+IGZ1
bmN0aW9uLCBpdCB3b3JrcyBsaWtlIGFuIEV0aGVybmV0IHBsdXMgYSAyLXBvcnQgaHViLg0KPiA+
ID4NCj4gPiA+IFNvIHdpdGhvdXQgU1RQLCB0aGVyZSBpcyBubyB3YXkgdG8gc3RvcCBhbiBsb29w
LCBhbmQgYSBicm9hZGNhc3QNCj4gPiA+IHN0b3JtIHRha2luZyBkb3duIHlvdXIgbmV0d29yaz8N
Cj4gPg0KPiA+IERvIHlvdSBtZWFuIGNvbm5lY3RpbmcgdHdvIFBIWSBwb3J0cyB0byB0aGUgc2Ft
ZSBMQU4/IFdlIG5ldmVyIGNvbm5lY3QNCj4gPiB0d28gUEhZIHBvcnRzIHRvIHRoZSBzYW1lIExB
TiAob3IgaHViKS4gSSBuZXZlciB0aGluayBvZiB0aGlzIGxvb3ANCj4gPiBwcm9ibGVtLiBJIHRo
b3VnaHQgb25seSBXQU4gaGFzIHRoZSBsb29wIHByb2JsZW0uDQo+IA0KPiBBbnkgRXRoZXJuZXQg
bmV0d29yayBjYW4gaGF2ZSBhIGxvb3AuIE9mdGVuIGxvb3BzIGEgZGVsaWJlcmF0ZSBiZWNhdXNl
IHRoZXkNCj4gZ2l2ZSByZWR1bmRhbmN5LiBTVFAgd2lsbCBkZXRlY3QgdGhpcyBsb29wLCBhbmQg
c29tZXdoZXJlIGluIHRoZSBuZXR3b3JrIG9uZQ0KPiBvZiB0aGUgc3dpdGNoZXMgd2lsbCBibG9j
ayB0cmFmZmljIHRvIGJyZWFrIHRoZSBsb29wLiBCdXQgaWYgc29tZXRoaW5nIGluIHRoZQ0KPiBu
ZXR3b3JrIGJyZWFrcywgdGhlIHBvcnQgY2FuIGJlIHVuYmxvY2tlZCB0byBhbGxvdyB0cmFmZmlj
IHRvIGZsb3csIHJlZHVuZGFuY3kuDQo+IFdlbGwgYmVoYXZlZCBzd2l0Y2hlcyBzaG91bGQgYWx3
YXlzIGltcGxlbWVudCBTVFAuDQoNCkkgZG9uJ3Qga25vdyBob3cgdG8gaW1wbGVtZW50IFNUUCBp
biBMMiBzd2l0Y2ggbGlrZSBTUDcwMjEuDQpIb3cgYWJvdXQgb25lIE5JQyArIDItcG9ydCBzaW1w
bGUgZnJhbWUtZmxvb2RpbmcgaHViPw0KU29tZW9uZSB0b2xkIG1lIHRoYXQgc29tZSBsb3ctY29z
dCBFdGhlcm5ldCBodWIganVzdCBkb2VzIGZyYW1lLWZsb29kaW5nIA0KdG8gb3RoZXIgcG9ydHMu
IExldCB1c2VycyB0YWtlIGNhcmUgb2YgdXNlLg0KSWYgdGhpcyBpcyBhY2NlcHRhYmxlLCBJJ2Qg
bGlrZSB0byBoYXZlIEV0aGVybmV0IG9mIFNQNzAyMSBoYXZlIHR3byBvcGVyYXRpb24gDQptb2Rl
czoNCiAtIER1YWwgTklDIG1vZGUNCiAtIFNpbmdsZSBOSUMgd2l0aCAyLXBvcnQgZnJhbWUtZmxv
b2RpbmcgaHViIG1vZGUNCg0KSWYgdGhpcyBpcyBub3QgYWNjZXB0YWJsZSwgY2FuIEksIGluc3Rl
YWQsIGltcGxlbWVudCB0aGUgdHdvIG9wZXJhdGlvbiBtb2RlczoNCiAtIER1YWwgTklDIG1vZGUN
CiAtIFNpbmdsZSBOSUMgbW9kZQ0KDQpSTUlJIHBpbnMgb2YgUEhZIHBvcnRzIG9mIFNQNzAyMSBh
cmUgbXVsdGlwbGV4YWJsZS4gSSdkIGxpa2UgdG8gc3dpdGNoIFJNSUkgDQpwaW5zIG9mIHRoZSBz
ZWNvbmQgUEhZIGZvciBvdGhlciB1c2UgaWYgc2luZ2xlIE5JQyBtb2RlIGlzIHVzZWQuDQpJbiBm
YWN0LCBzb21lIFNQNzAyMSBib2FyZHMgaGF2ZSBkdWFsIEV0aGVybmV0IGFuZCBzb21lIGhhdmUg
b25seSBvbmUNCkV0aGVybmV0LiBXZSByZWFsbHkgbmVlZCB0aGUgdHdvIG9wZXJhdGlvbiBtb2Rl
cy4NCg0KDQo+ID4gSG93IGFuIEV0aGVybmV0IGh1YiB0YWtlIGNhcmUgb2YgdGhpcyBzaXR1YXRp
b24/DQo+IA0KPiBTVFAuIFJ1biB0Y3BkdW1wIG9uIHlvdXIgbmV0d29yay4gRGVwZW5kaW5nIG9u
IGhvdyB5b3VyIG5ldHdvcmsgaXMNCj4gY29uZmlndXJlZCwgeW91IG1pZ2h0IHNlZSBCUERVIGZy
b20geW91ciBidWlsZGluZyBzd2l0Y2hlcy4NCg0KVGhhbmtzIGEgbG90LiBJIHVuZGVyc3RhbmQu
DQoNCj4gPiBJcyB0aGF0IHJlYXNvbmFibGUgdG8gY29ubmVjdCB0d28gcG9ydHMgb2YgYW4gRXRo
ZXJuZXQgaHViIHRvZ2V0aGVyPw0KPiANCj4gSXQgaXMgbm90IGp1c3QgdG9nZXRoZXIuIFlvdSBj
YW5ub3QgZ3VhcmFudGVlIGFueSBFdGhlcm5ldCBuZXR3b3JrIGlzIGEgdHJlZS4gWW91DQo+IGNv
dWxkIGNvbm5lY3QgdGhlIHR3byBwb3J0cyB0byB0d28gZGlmZmVyZW50IGh1YnMsIGJ1dCB0aG9z
ZSBodWJzIGFyZQ0KPiBjb25uZWN0ZWQgdG9nZXRoZXIsIGFuZCBzbyB5b3UgZ2V0IGEgbG9vcC4N
Cg0KVGhhbmtzIGZvciBleHBsYW5hdGlvbi4gSSBnb3QgaXQuDQoNCj4gPiA+IExvb2tpbmcgYXQg
dGhlIFRYIGRlc2NyaXB0b3IsIHRoZXJlIGFyZSB0d28gYml0czoNCj4gPiA+DQo+ID4gPiAgICAg
ICAgICAgWzE4XTogZm9yY2UgZm9yd2FyZCB0byBwb3J0IDANCj4gPiA+ICAgICAgICAgICBbMTld
OiBmb3JjZSBmb3J3YXJkIHRvIHBvcnQgMQ0KPiA+ID4NCj4gPiA+IFdoZW4gdGhlIHN3aXRjaCBp
cyBlbmFibGVkLCBjYW4gdGhlc2UgdHdvIGJpdHMgYmUgdXNlZD8NCj4gPg0KPiA+IFllcywgZm9y
IGV4YW1wbGUsIHdoZW4gYml0IDE5IG9mIFRYIGRlc2NyaXB0b3IgaXMgZW5hYmxlZCwgYSBwYWNr
ZXQNCj4gPiBmcm9tIENQVSBwb3J0IGlzIGZvcndhcmRlZCB0byBMQU4gcG9ydCAwIGZvcmNpYmx5
Lg0KPiA+DQo+ID4NCj4gPiA+IEluIHRoZSBSWCBkZXNjcmlwdG9yIHRoZXJlIGlzOg0KPiA+ID4N
Cj4gPiA+IHBrdF9zcDoNCj4gPiA+ICAgICAgICAgICAwMDA6IGZyb20gcG9ydDANCj4gPiA+ICAg
ICAgICAgICAwMDE6IGZyb20gcG9ydDENCj4gPiA+ICAgICAgICAgICAxMTA6IHNvYzAgbG9vcGJh
Y2sNCj4gPiA+ICAgICAgICAgICAxMDE6IHNvYzEgbG9vcGJhY2sNCj4gPiA+DQo+ID4gPiBBcmUg
dGhlc2UgYml0cyB1c2VkIHdoZW4gdGhlIHN3aXRjaCBpcyBlbmFibGVkPw0KPiA+DQo+ID4gWWVz
LCBFLSBNQUMgZHJpdmVyIHVzZXMgdGhlc2UgYml0cyB0byB0ZWxsIHdoZXJlIGEgcGFja2V0IGNv
bWVzIGZyb20uDQo+ID4gTm90ZSB0aGF0IHNvYzEgcG9ydCAoQ1BVIHBvcnQpIGhhcyBiZWVuIHJl
bW92ZWQgaW4gdGhpcyBjaGlwLg0KPiANCj4gUmlnaHQuIFNvIHlvdSBjYW4gaGF2ZSB0d28gbmV0
ZGV2IHdoZW4gaW4gTDIgc3dpdGNoIG1vZGUuDQo+IA0KPiBZb3UgbmVlZCB0byB0aGluayBhYm91
dCB0aGUgTGludXggbW9kZWwgc29tZSBtb3JlLiBJbiBsaW51eCwgbmV0d29ya2luZw0KPiBoYXJk
d2FyZSBpcyB0aGVyZSB0byBhY2NlbGVyYXRlIHdoYXQgdGhlIExpbnV4IHN0YWNrIGNhbiBkbyBp
biBzb2Z0d2FyZS4gVGFrZQ0KPiBmb3IgZXhhbXBsZSBhIHNpbXBsZSBTb0Mgd2lsbCBoYXZlIHR3
byBFdGhlcm5ldCBpbnRlcmZhY2VzLiBZb3UgY2FuIHBlcmZvcm0NCj4gc29mdHdhcmUgYnJpZGdp
bmcgb24gdGhvc2UgdHdvIGludGVyZmFjZXM6DQo+IA0KPiBpcCBsaW5rIGFkZCBuYW1lIGJyMCB0
eXBlIGJyaWRnZQ0KPiBpcCBsaW5rIHNldCBkZXYgYnIwIHVwDQo+IGlwIGxpbmsgc2V0IGRldiBl
dGgwIG1hc3RlciBicjANCj4gaXAgbGluayBzZXQgZGV2IGV0aDEgbWFzdGVyIGJyMA0KPiANCj4g
VGhlIHNvZnR3YXJlIGJyaWRnZSB3aWxsIGRlY2lkZWQgd2hpY2ggaW50ZXJmYWNlIHRvIHNlbmQg
YSBwYWNrZXQgb3V0LiBUaGUNCj4gc29mdHdhcmUgd2lsbCBwZXJmb3JtIGxlYXJuaW5nIGV0Yy4N
Cj4gDQo+IFlvdSBjYW4gdXNlIHlvdXIgZHVhbCBNQUMgc2V0dXAgZXhhY3RseSBsaWtlIHRoaXMu
IEJ1dCB5b3UgY2FuIGFsc28gZ28gZnVydGhlci4NCj4gWW91IGNhbiB1c2UgdGhlIGhhcmR3YXJl
IHRvIGFjY2VsZXJhdGUgc3dpdGNoaW5nIHBhY2tldHMgYmV0d2VlbiBldGgwIGFuZA0KPiBldGgx
LiBCdXQgYWxzbyBMaW51eCBjYW4gc3RpbGwgc2VuZCBwYWNrZXRzIG91dCBzcGVjaWZpYyBwb3J0
cyB1c2luZyB0aGVzZSBiaXRzLg0KPiBUaGUgc29mdHdhcmUgYnJpZGdlIGFuZCB0aGUgaGFyZHdh
cmUgYnJpZGdlIHdvcmsgdG9nZXRoZXIuIFRoaXMgaXMgdGhlIGNvcnJlY3QNCj4gd2F5IHRvIGRv
IHRoaXMgaW4gTGludXguDQoNClNvcnJ5LCBJIGFtIG5vdCBjYXBhYmxlIHRvIGRvIHRoYXQuDQpJ
IG5lZWQgdG8gc3R1ZHkgbW9yZSBhYm91dCBMaW51eCBzd2l0Y2ggZGV2aWNlLCBMMiBzd2l0Y2gg
b2YgU1A3MDIxLCBwcm9jb3RvbHMsLi4uDQpTbyB3aGF0IEkgY2FuIHVzZSBub3cgaXMgcHVyZSBz
b2Z0d2FyZSBicmlkZ2UgZm9yIGR1YWwgRXRoZXJuZXQgY2FzZS4NCg0KPiA+IFNvcnJ5LCBJIGRv
bid0IGtub3cgd2hhdCBpcyBhIFJNQyBwYWNrZXQ/DQo+DQo+IFNvcnJ5LCBpIGhhdmUgbm8gaWRl
YS4NCg0KQWZ0ZXIgbG9va2luZyB1cCBzb21lIGRhdGEsIEkgZmluZCBSTUMgbWVhbnMgcmVzZXJ2
ZWQgbXVsdGktY2FzdC4NClJNQyBwYWNrZXRzIG1lYW5zIHBhY2tldHMgd2l0aCBEQSA9IDB4MDE4
MGMyMDAwMDAwLCAweDAxODBjMjAwMDAwMiB+IDB4MDE4MGMyMDAwMDBmLA0KZXhjZXB0IHRoZSBQ
QVVTRSBwYWNrZXQgKERBID0gMHgwMTgwYzIwMDAwMDEpDQoNCg0KPiAgICAgICAgQW5kcmV3DQoN
ClRoYW5rIHlvdSBmb3IgeW91ciByZXZpZXcuDQoNCg0K
