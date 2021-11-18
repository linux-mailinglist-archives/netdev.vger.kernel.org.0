Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329D04556D6
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 09:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244658AbhKRIUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 03:20:36 -0500
Received: from 113.196.136.146.ll.static.sparqnet.net ([113.196.136.146]:50636
        "EHLO mg.sunplus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S244677AbhKRISc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 03:18:32 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(23403:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Thu, 18 Nov 2021 16:15:16 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Thu, 18 Nov 2021 16:15:11 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Thu, 18 Nov
 2021 16:15:11 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Denis Kirjanov <dkirjanov@suse.de>, Wells Lu <wellslutw@gmail.com>,
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
Thread-Index: AQHX1ttDZ0jKVsi7r0auZS2tEQF+d6v9q5oAgAC70cCAAqzAAIAH4LIg
Date:   Thu, 18 Nov 2021 08:15:11 +0000
Message-ID: <62964ef2c4bc4dd6a316f160f2a3b94d@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <cba74b41-7159-60e5-ec1f-007b27e72b22@suse.de>
 <07c59ab058a746c694b1c3a746525009@sphcmbx02.sunplus.com.tw>
 <YY/bGkVEKLS75sU0@lunn.ch>
In-Reply-To: <YY/bGkVEKLS75sU0@lunn.ch>
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

SGksDQoNCg0KPiA+ID4gPiArLy9kZWZpbmUgTUFDIGludGVycnVwdCBzdGF0dXMgYml0DQo+ID4g
PiBwbGVhc2UgZW1icmFjZSBhbGwgY29tbWVudHMgd2l0aCAvKiAqLw0KPiA+DQo+ID4gRG8geW91
IG1lYW4gdG8gbW9kaWZ5IGNvbW1lbnQsIGZvciBleGFtcGxlLA0KPiA+DQo+ID4gLy9kZWZpbmUg
TUFDIGludGVycnVwdCBzdGF0dXMgYml0DQo+ID4NCj4gPiB0bw0KPiA+DQo+ID4gLyogZGVmaW5l
IE1BQyBpbnRlcnJ1cHQgc3RhdHVzIGJpdCAqLw0KPiANCj4gWWVzLiBUaGUgS2VybmVsIGlzIHdy
aXR0ZW4gaW4gQywgc28gQyBzdHlsZSBjb21tZW50cyBhcmUgcHJlZmVycmVkIG92ZXIgQysrIGNv
bW1lbnRzLCBldmVuDQo+IGlmIGxhdGVyIHZlcnNpb25zIG9mIHRoZSBDIHN0YW5kYXJkIGFsbG93
IEMrKyBzdHlsZSBjb21tZW50cy4NCg0KSSdsbCBtb2RpZnkgYWxsIGNvbW1lbnRzIHRvIEMgc3R5
bGUgaW4gbmV4dCBwYXRjaC4NCg0KDQo+IFlvdSBzaG91bGQgYWxzbyByZWFkIHRoZSBuZXRkZXYg
RkFRLCB3aGljaCBtYWtlcyBzb21lIHNwZWNpZmljIGNvbW1lbnRzIGFib3V0IGhvdyBtdWx0aS1s
aW5lDQo+IGNvbW1lbnRzIHNob3VsZCBiZSBmb3JtYXR0ZWQuDQoNClRoYW5rcyBmb3Igcm91dGlu
ZyBtZSB0byB0aGUgZG9jdW1lbnQuDQpJJ2xsIHVzZSB0aGUgbmV3IGZvcm1hdCBmb3IgbXVsdGkt
bGluZSBjb21tZW50cy4NCi0tLQ0KSXQgaXMgcmVxdWVzdGVkIHRoYXQgeW91IG1ha2UgaXQgbG9v
ayBsaWtlIHRoaXM6DQoNCi8qIGZvb2JhciBibGFoIGJsYWggYmxhaA0KICogYW5vdGhlciBsaW5l
IG9mIHRleHQNCiAqLw0KDQoNCj4gPiBZZXMsIEknbGwgYWRkIGVycm9yIGNoZWNrIGluIG5leHQg
cGF0Y2ggYXMgc2hvd24gYmVsb3c6DQo+ID4NCj4gPiAJCXJ4X3NrYmluZm9bal0ubWFwcGluZyA9
IGRtYV9tYXBfc2luZ2xlKCZjb21tLT5wZGV2LT5kZXYsIHNrYi0+ZGF0YSwNCj4gPiAJCQkJCQkg
ICAgICAgY29tbS0+cnhfZGVzY19idWZmX3NpemUsDQo+ID4gCQkJCQkJICAgICAgIERNQV9GUk9N
X0RFVklDRSk7DQo+ID4gCQlpZiAoZG1hX21hcHBpbmdfZXJyb3IoJmNvbW0tPnBkZXYtPmRldiwg
cnhfc2tiaW5mb1tqXS5tYXBwaW5nKSkNCj4gPiAJCQlnb3RvIG1lbV9hbGxvY19mYWlsOw0KPiAN
Cj4gSWYgaXQgaXMgY2xlYXIgaG93IHRvIGZpeCB0aGUgY29kZSwganVzdCBkbyBpdC4gTm8gbmVl
ZCB0byB0ZWxsIHVzIHdoYXQgeW91IGFyZSBnb2luZyB0bw0KPiBkbywgd2Ugd2lsbCBzZWUgdGhl
IGNoYW5nZSB3aGVuIHJldmlld2luZyB0aGUgbmV4dCB2ZXJzaW9uLg0KDQpUaGFua3MsIEkgc2Vl
Lg0KDQoNCj4gPiA+ID4gKy8qIFRyYW5zbWl0IGEgcGFja2V0IChjYWxsZWQgYnkgdGhlIGtlcm5l
bCkgKi8gc3RhdGljIGludA0KPiA+ID4gPiArZXRoZXJuZXRfc3RhcnRfeG1pdChzdHJ1Y3Qgc2tf
YnVmZiAqc2tiLCBzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCj4gPiA+ID4gK3sNCj4gPiA+ID4g
KwlzdHJ1Y3Qgc3BfbWFjICptYWMgPSBuZXRkZXZfcHJpdihuZGV2KTsNCj4gPiA+ID4gKwlzdHJ1
Y3Qgc3BfY29tbW9uICpjb21tID0gbWFjLT5jb21tOw0KPiA+ID4gPiArCXUzMiB0eF9wb3M7DQo+
ID4gPiA+ICsJdTMyIGNtZDE7DQo+ID4gPiA+ICsJdTMyIGNtZDI7DQo+ID4gPiA+ICsJc3RydWN0
IG1hY19kZXNjICp0eGRlc2M7DQo+ID4gPiA+ICsJc3RydWN0IHNrYl9pbmZvICpza2JpbmZvOw0K
PiA+ID4gPiArCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlpZiAo
dW5saWtlbHkoY29tbS0+dHhfZGVzY19mdWxsID09IDEpKSB7DQo+ID4gPiA+ICsJCS8vIE5vIFRY
IGRlc2NyaXB0b3JzIGxlZnQuIFdhaXQgZm9yIHR4IGludGVycnVwdC4NCj4gPiA+ID4gKwkJbmV0
ZGV2X2luZm8obmRldiwgIlRYIGRlc2NyaXB0b3IgcXVldWUgZnVsbCB3aGVuIHhtaXQhXG4iKTsN
Cj4gPiA+ID4gKwkJcmV0dXJuIE5FVERFVl9UWF9CVVNZOw0KPiA+ID4gRG8geW91IHJlYWxseSBo
YXZlIHRvIHJldHVybiBORVRERVZfVFhfQlVTWT8NCj4gPg0KPiA+ICh0eF9kZXNjX2Z1bGwgPT0g
MSkgbWVhbnMgdGhlcmUgaXMgbm8gVFggZGVzY3JpcHRvciBsZWZ0IGluIHJpbmcgYnVmZmVyLg0K
PiA+IFNvIHRoZXJlIGlzIG5vIHdheSB0byBkbyBuZXcgdHJhbnNtaXQuIFJldHVybiAnYnVzeScg
ZGlyZWN0bHkuDQo+ID4gSSBhbSBub3Qgc3VyZSBpZiB0aGlzIGlzIGEgY29ycmVjdCBwcm9jZXNz
IG9yIG5vdC4NCj4gPiBDb3VsZCB5b3UgcGxlYXNlIHRlYWNoIGlzIHRoZXJlIGFueSBvdGhlciB3
YXkgdG8gdGFrZSBjYXJlIG9mIHRoaXMgY2FzZT8NCj4gPiBEcm9wIGRpcmVjdGx5Pw0KPiANCj4g
VGhlcmUgYXJlIGEgZmV3IGh1bmRyZWQgZXhhbXBsZXMgdG8gZm9sbG93LCBvdGhlciBNQUMgZHJp
dmVycy4gV2hhdCBkbyB0aGV5IGRvIHdoZW4gb3V0DQo+IG9mIFRYIGJ1ZmZlcnM/IEZpbmQgdGhl
IG1vc3QgY29tbW9uIHBhdHRlcm4sIGFuZCBmb2xsb3cgaXQuDQoNCkJ1dCBzb21lIGRyaXZlcnMg
cmV0dXJuIE5FVERFVl9UWF9CVVNZLCBzb21lIGRyaXZlcnMgZHJvcCBwYWNrZXQgYW5kIHJldHVy
biBORVRERVZfVFhfT0sNClNvbWUgZHJpdmVycyBzZWVtIGRvIG5vdCB0YWtlIGNhcmUgdGhpcyBp
c3N1ZS4gSSBhbSBub3Qgc3VyZS4NCg0KDQo+IFlvdSBzaG91bGQgYWxzbyB0aGlua2luZyBhYm91
dCB0aGUgbmV0ZGV2X2luZm8oKS4gRG8geW91IHJlYWxseSB3YW50IHRvIHNwYW0gdGhlIGtlcm5l
bA0KPiBsb2c/IFNheSB5b3UgYXJlIGNvbm5lY3RlZCB0byBhIDEwL0hhbGYgbGluaywgYW5kIHRo
ZSBhcHBsaWNhdGlvbiBpcyB0cnlpbmcgdG8gc2VuZCBVRFANCj4gYXQgMTAwTWJwcywgV29uJ3Qg
eW91IHNlZSBhIGxvdCBvZiB0aGVzZSBtZXNzYWdlcz8gY2hhbmdlIGl0IHRvIF9kZWJ1ZygpLCBv
ciByYXRlIGxpbWl0DQo+IGl0Lg0KDQpZZXMsIEknbGwgbW9kaWZ5IG1vc3QgbmV0ZGV2X2luZm8o
KSB0byBuZXRkZXZfZGJnKCkgaW4gbmV4dCBwYXRjaC4NCg0KDQo+ID4gc3RhdGljIHZvaWQgZXRo
ZXJuZXRfdHhfdGltZW91dChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldiwgdW5zaWduZWQgaW50DQo+
ID4gdHhxdWV1ZSkgew0KPiA+IAlzdHJ1Y3Qgc3BfbWFjICptYWMgPSBuZXRkZXZfcHJpdihuZGV2
KTsNCj4gPiAJc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYyOw0KPiA+IAl1bnNpZ25lZCBsb25nIGZs
YWdzOw0KPiA+DQo+ID4gCW5ldGRldl9lcnIobmRldiwgIlRYIHRpbWVkIG91dCFcbiIpOw0KPiA+
IAluZGV2LT5zdGF0cy50eF9lcnJvcnMrKzsNCj4gPg0KPiA+IAlzcGluX2xvY2tfaXJxc2F2ZSgm
bWFjLT5jb21tLT50eF9sb2NrLCBmbGFncyk7DQo+ID4gCW5ldGlmX3N0b3BfcXVldWUobmRldik7
DQo+ID4gCW5kZXYyID0gbWFjLT5uZXh0X25kZXY7DQo+ID4gCWlmIChuZGV2MikNCj4gPiAJCW5l
dGlmX3N0b3BfcXVldWUobmRldjIpOw0KPiA+DQo+ID4gCWhhbF9tYWNfc3RvcChtYWMpOw0KPiA+
IAloYWxfbWFjX2luaXQobWFjKTsNCj4gPiAJaGFsX21hY19zdGFydChtYWMpOw0KPiA+DQo+ID4g
CS8vIEFjY2VwdCBUWCBwYWNrZXRzIGFnYWluLg0KPiA+IAluZXRpZl90cmFuc191cGRhdGUobmRl
dik7DQo+ID4gCW5ldGlmX3dha2VfcXVldWUobmRldik7DQo+ID4gCWlmIChuZGV2Mikgew0KPiA+
IAkJbmV0aWZfdHJhbnNfdXBkYXRlKG5kZXYyKTsNCj4gPiAJCW5ldGlmX3dha2VfcXVldWUobmRl
djIpOw0KPiA+IAl9DQo+ID4NCj4gPiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmbWFjLT5jb21t
LT50eF9sb2NrLCBmbGFncyk7IH0NCj4gPg0KPiA+IElzIHRoYXQgb2s/DQo+IA0KPiBUaGlzIG5k
ZXYyIHN0dWZmIGlzIG5vdCBuaWNlLiBZb3UgcHJvYmFibHkgbmVlZCBhIGNsZWFuZXIgYWJzdHJh
Y3Qgb2YgdHdvIG5ldGRldidzIHNoYXJpbmcNCj4gb25lIFRYIGFuZCBSWCByaW5nLiBTZWUgaWYg
dGhlcmUgYXJlIGFueSBvdGhlciBzd2l0Y2hkZXYgZHJpdmVycyB3aXRoIGEgc2ltaWxhciBzdHJ1
Y3R1cmUNCj4geW91IGNhbiBjb3B5LiBNYXliZSBjcHN3X25ldy5jPyBCdXQgYmUgY2FyZWZ1bCB3
aXRoIHRoYXQgZHJpdmVyLiBjcHN3IGlzIGEgYml0IG9mIGEgbWVzcw0KPiBkdWUgdG8gYW4gaW5j
b3JyZWN0IGluaXRpYWwgZGVzaWduIHdpdGggcmVzcGVjdCB0byBpdHMgTDIgc3dpdGNoLiBBIGxv
dCBvZiBteSBpbml0aWFsIGNvbW1lbnRzDQo+IGFyZSB0byBzdG9wIHlvdSBtYWtpbmcgdGhlIHNh
bWUgbWlzdGFrZXMuDQoNCkknbGwgZGVmaW5lIGEgYXJyYXkgKHBvaW50ZXIgdG8gc3RydWN0IG5l
dF9kZXYpIGluIGRyaXZlciBwcml2YXRlIChzaGFyZWQpIA0Kc3RydWN0dXJlIHRvIGFjY2VzcyB0
byBhbGwgbmV0IGRldmljZXMuIE5vIG1vcmUgbWFjLT5uZXh0X25kZXY7Lg0KDQo+ICAgICBBbmRy
ZXcNCg0KVGhhbmsgeW91IHZlcnkgbXVjaCBmb3IgeW91ciByZXZpZXcuDQoNCg0KQmVzdCByZWdh
cmRzLA0KV2VsbHMNCg==
