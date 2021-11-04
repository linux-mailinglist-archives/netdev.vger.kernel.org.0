Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E29B4458E5
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhKDRtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:49:35 -0400
Received: from 113.196.136.146.ll.static.sparqnet.net ([113.196.136.146]:42198
        "EHLO mg.sunplus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232318AbhKDRtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:49:33 -0400
X-Greylist: delayed 44076 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2021 13:49:32 EDT
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(53130:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Fri, 05 Nov 2021 01:46:36 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Fri, 5 Nov 2021 01:46:36 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Fri, 5 Nov 2021
 01:46:36 +0800
From:   =?utf-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Randy Dunlap <rdunlap@infradead.org>,
        Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Subject: RE: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Topic: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKvxbhgAgAClKgD//5f5gIABJz+w///9xoCAANUOEA==
Date:   Thu, 4 Nov 2021 17:46:35 +0000
Message-ID: <c51d2927eedb4f3999b8361a44526a07@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
 <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
 <YYLjaYCQHzqBzN1l@lunn.ch>
 <36d5bc6d40734ae0a9c1fb26d258f49f@sphcmbx02.sunplus.com.tw>
 <YYPZN9hPBJTBzVUl@lunn.ch>
In-Reply-To: <YYPZN9hPBJTBzVUl@lunn.ch>
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

PiBPbiBUaHUsIE5vdiAwNCwgMjAyMSBhdCAwNTozMTo1N0FNICswMDAwLCBXZWxscyBMdSDlkYLo
irPpqLAgd3JvdGU6DQo+ID4gSGksDQo+ID4NCj4gPiBUaGFua3MgYSBsb3QgZm9yIHJldmlldy4N
Cj4gPg0KPiA+ID4NCj4gPiA+ID4gY29uZmlnIE5FVF9WRU5ET1JfU1VOUExVUw0KPiA+ID4gPiAJ
Ym9vbCAiU3VucGx1cyBkZXZpY2VzIg0KPiA+ID4gPiAJZGVmYXVsdCB5DQo+ID4gPiA+IAlkZXBl
bmRzIG9uIEFSQ0hfU1VOUExVUw0KPiA+ID4NCj4gPiA+IERvZXMgaXQgYWN0dWFsbHkgZGVwZW5k
IG9uIEFSQ0hfU1VOUExVUz8gV2hhdCBkbyB5b3UgbWFrZSB1c2Ugb2Y/DQo+ID4NCj4gPiBBUkNI
X1NVTlBMVVMgd2lsbCBiZSBkZWZpbmVkIGZvciBTdW5wbHVzIGZhbWlseSBzZXJpZXMgU29DLg0K
PiA+IEV0aGVybmV0IGRldmljZXMgb2YgU3VucGx1cyBhcmUgZGVzaWduZWQgYW5kIHVzZWQgZm9y
IFN1bnBsdXMgU29DLg0KPiA+IFNvIGZhciwgb25seSB0d28gU29DIG9mIFN1bnBsdXMgaGF2ZSB0
aGUgbmV0d29yayBkZXZpY2UuDQo+ID4gSSdkIGxpa2UgdG8gc2hvdyB1cCB0aGUgc2VsZWN0aW9u
IG9ubHkgZm9yIFN1bnBsdXMgU29DLg0KPiANCj4gU28gaXQgZG9lcyBub3QgYWN0dWFsbHkgZGVw
ZW5kIG9uIEFSQ0hfU1VOUExVUy4gVGhlcmUgYXJlIGEgZmV3IGNhc2VzIHdoZXJlDQo+IGRyaXZl
cnMgaGF2ZSBuZWVkZWQgdG8gY2FsbCBpbnRvIGFyY2ggc3BlY2lmaWMgY29kZSwgd2hpY2ggc3Rv
cHMgdGhlbSBidWlsZGluZw0KPiBmb3IgYW55IG90aGVyIGFyY2guDQo+IA0KPiA+ID4gSWRlYWxs
eSwgeW91IHdhbnQgaXQgdG8gYWxzbyBidWlsZCB3aXRoIENPTVBJTEVfVEVTVCwgc28gdGhhdCB0
aGUNCj4gPiA+IGRyaXZlciBnZXRzIGJ1aWxkIGJ5IDAtZGF5IGFuZCBhbGwgdGhlIG90aGVyIGJ1
aWxkIGJvdHMuDQo+ID4NCj4gPiBJIGFtIG5vdCBzdXJlIGlmIHRoaXMgaXMgbWFuZGF0b3J5IG9y
IG5vdC4NCj4gPiBTaG91bGQgSSBhZGQgQ09NUElMRV9URVNUIGFzIGJlbG93Pw0KPiA+DQo+ID4g
CWRlcGVuZHMgb24gQVJDSF9TVU5QTFVTIHwgQ09NUElMRV9URVNUDQo+IA0KPiBZZXMuDQo+IA0K
PiA+IFllcywgdGhlIGRldmljZSBpcyBub3cgb25seSBmb3IgU3VucGx1cyBTUDcwMjEgU29DLg0K
PiA+IERldmljZXMgaW4gZWFjaCBTb0MgbWF5IGhhdmUgYSBiaXQgZGlmZmVyZW5jZSBiZWNhdXNl
IG9mIGFkZGluZyBuZXcNCj4gPiBmdW5jdGlvbiBvciBpbXByb3Zpbmcgc29tZXRoaW5nLg0KPiAN
Cj4gSWYgaXQgd2lsbCBjb21waWxlIHdpdGggQ09NUElMRV9URVNUIG9uIHg4NiwgbWlwcywgZXRj
LCB5b3Ugc2hvdWxkIGFsbG93IGl0IHRvDQo+IGNvbXBpbGUgd2l0aCBDT01QSUxFX1RFU1QuIFlv
dSBnZXQgYmV0dGVyIGNvbXBpbGUgdGVzdGluZyB0aGF0IHdheS4NCj4gDQo+ICAgICAgQW5kcmV3
DQoNCk5vLCB3ZSBvbmx5IGRldmVsb3AgYXJtLWJhc2VkIFNvQywgbmV2ZXIgZm9yIHg4NiBvciBt
aXBzLg0KV2UgbmV2ZXIgY29tcGlsZSB0aGUgZHJpdmVyIGZvciB4ODYgb3IgbWlwcyBtYWNoaW5l
Lg0KDQo=
