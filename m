Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927894458FD
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhKDRyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:54:06 -0400
Received: from mswedge1.sunplus.com ([60.248.182.113]:36518 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232048AbhKDRyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:54:05 -0400
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(13483:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Fri, 05 Nov 2021 01:51:11 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Fri, 5 Nov 2021 01:51:11 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Fri, 5 Nov 2021
 01:51:11 +0800
From:   =?utf-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
To:     Randy Dunlap <rdunlap@infradead.org>, Andrew Lunn <andrew@lunn.ch>
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
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKvxbhgAgAClKgD//5f5gIABJz+w///9xoCAACBhAIAAtknA
Date:   Thu, 4 Nov 2021 17:51:11 +0000
Message-ID: <22012af032f04f2684f2d9bf64ed7028@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
 <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
 <YYLjaYCQHzqBzN1l@lunn.ch>
 <36d5bc6d40734ae0a9c1fb26d258f49f@sphcmbx02.sunplus.com.tw>
 <YYPZN9hPBJTBzVUl@lunn.ch>
 <3209bc4b-bde5-2e7e-4a91-429d2e83905e@infradead.org>
In-Reply-To: <3209bc4b-bde5-2e7e-4a91-429d2e83905e@infradead.org>
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

PiBPbiAxMS80LzIxIDU6NTkgQU0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+IE9uIFRodSwgTm92
IDA0LCAyMDIxIGF0IDA1OjMxOjU3QU0gKzAwMDAsIFdlbGxzIEx1IOWRguiKs+mosCB3cm90ZToN
Cj4gPj4gSGksDQo+ID4+DQo+ID4+IFRoYW5rcyBhIGxvdCBmb3IgcmV2aWV3Lg0KPiA+Pg0KPiA+
Pj4NCj4gPj4+PiBjb25maWcgTkVUX1ZFTkRPUl9TVU5QTFVTDQo+ID4+Pj4gCWJvb2wgIlN1bnBs
dXMgZGV2aWNlcyINCj4gPj4+PiAJZGVmYXVsdCB5DQo+ID4+Pj4gCWRlcGVuZHMgb24gQVJDSF9T
VU5QTFVTDQo+ID4+Pg0KPiA+Pj4gRG9lcyBpdCBhY3R1YWxseSBkZXBlbmQgb24gQVJDSF9TVU5Q
TFVTPyBXaGF0IGRvIHlvdSBtYWtlIHVzZSBvZj8NCj4gPj4NCj4gPj4gQVJDSF9TVU5QTFVTIHdp
bGwgYmUgZGVmaW5lZCBmb3IgU3VucGx1cyBmYW1pbHkgc2VyaWVzIFNvQy4NCj4gPj4gRXRoZXJu
ZXQgZGV2aWNlcyBvZiBTdW5wbHVzIGFyZSBkZXNpZ25lZCBhbmQgdXNlZCBmb3IgU3VucGx1cyBT
b0MuDQo+ID4+IFNvIGZhciwgb25seSB0d28gU29DIG9mIFN1bnBsdXMgaGF2ZSB0aGUgbmV0d29y
ayBkZXZpY2UuDQo+ID4+IEknZCBsaWtlIHRvIHNob3cgdXAgdGhlIHNlbGVjdGlvbiBvbmx5IGZv
ciBTdW5wbHVzIFNvQy4NCj4gPg0KPiA+IFNvIGl0IGRvZXMgbm90IGFjdHVhbGx5IGRlcGVuZCBv
biBBUkNIX1NVTlBMVVMuIFRoZXJlIGFyZSBhIGZldyBjYXNlcw0KPiA+IHdoZXJlIGRyaXZlcnMg
aGF2ZSBuZWVkZWQgdG8gY2FsbCBpbnRvIGFyY2ggc3BlY2lmaWMgY29kZSwgd2hpY2ggc3RvcHMN
Cj4gPiB0aGVtIGJ1aWxkaW5nIGZvciBhbnkgb3RoZXIgYXJjaC4NCj4gPg0KPiA+Pj4gSWRlYWxs
eSwgeW91IHdhbnQgaXQgdG8gYWxzbyBidWlsZCB3aXRoIENPTVBJTEVfVEVTVCwgc28gdGhhdCB0
aGUNCj4gPj4+IGRyaXZlciBnZXRzIGJ1aWxkIGJ5IDAtZGF5IGFuZCBhbGwgdGhlIG90aGVyIGJ1
aWxkIGJvdHMuDQo+ID4+DQo+ID4+IEkgYW0gbm90IHN1cmUgaWYgdGhpcyBpcyBtYW5kYXRvcnkg
b3Igbm90Lg0KPiA+PiBTaG91bGQgSSBhZGQgQ09NUElMRV9URVNUIGFzIGJlbG93Pw0KPiA+Pg0K
PiA+PiAJZGVwZW5kcyBvbiBBUkNIX1NVTlBMVVMgfCBDT01QSUxFX1RFU1QNCj4gPg0KPiA+IFll
cy4NCj4gDQo+IFllcywgYnV0IHVzZSAifHwiIGluc3RlYWQgb2Ygb25lICJ8Ii4NCj4gDQo+ID4N
Cj4gPj4gWWVzLCB0aGUgZGV2aWNlIGlzIG5vdyBvbmx5IGZvciBTdW5wbHVzIFNQNzAyMSBTb0Mu
DQo+ID4+IERldmljZXMgaW4gZWFjaCBTb0MgbWF5IGhhdmUgYSBiaXQgZGlmZmVyZW5jZSBiZWNh
dXNlIG9mIGFkZGluZyBuZXcNCj4gPj4gZnVuY3Rpb24gb3IgaW1wcm92aW5nIHNvbWV0aGluZy4N
Cj4gPg0KPiA+IElmIGl0IHdpbGwgY29tcGlsZSB3aXRoIENPTVBJTEVfVEVTVCBvbiB4ODYsIG1p
cHMsIGV0YywgeW91IHNob3VsZA0KPiA+IGFsbG93IGl0IHRvIGNvbXBpbGUgd2l0aCBDT01QSUxF
X1RFU1QuIFlvdSBnZXQgYmV0dGVyIGNvbXBpbGUgdGVzdGluZw0KPiA+IHRoYXQgd2F5Lg0KPiA+
DQo+ID4gICAgICAgQW5kcmV3DQo+ID4NCj4gDQo+IA0KPiAtLQ0KPiB+UmFuZHkNCg0KSSB3aWxs
IGRvIGl0IGluIFBBVENIIHYyLg0KDQpUaGFua3MsDQo=
