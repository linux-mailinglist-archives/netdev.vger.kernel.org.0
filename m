Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB30E444E6F
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 06:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhKDFpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 01:45:34 -0400
Received: from mswedge2.sunplus.com ([60.248.182.106]:54304 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229824AbhKDFpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 01:45:34 -0400
X-MailGates: (compute_score:DELIVER,40,3)
Received: from 172.17.9.202
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(53140:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Thu, 04 Nov 2021 13:32:03 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Thu, 4 Nov 2021 13:31:57 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Thu, 4 Nov 2021
 13:31:57 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
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
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKvxbhgAgAClKgD//5f5gIABJz+w
Date:   Thu, 4 Nov 2021 05:31:57 +0000
Message-ID: <36d5bc6d40734ae0a9c1fb26d258f49f@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
 <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
 <YYLjaYCQHzqBzN1l@lunn.ch>
In-Reply-To: <YYLjaYCQHzqBzN1l@lunn.ch>
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

SGksDQoNClRoYW5rcyBhIGxvdCBmb3IgcmV2aWV3Lg0KDQo+IA0KPiA+IGNvbmZpZyBORVRfVkVO
RE9SX1NVTlBMVVMNCj4gPiAJYm9vbCAiU3VucGx1cyBkZXZpY2VzIg0KPiA+IAlkZWZhdWx0IHkN
Cj4gPiAJZGVwZW5kcyBvbiBBUkNIX1NVTlBMVVMNCj4gDQo+IERvZXMgaXQgYWN0dWFsbHkgZGVw
ZW5kIG9uIEFSQ0hfU1VOUExVUz8gV2hhdCBkbyB5b3UgbWFrZSB1c2Ugb2Y/DQoNCkFSQ0hfU1VO
UExVUyB3aWxsIGJlIGRlZmluZWQgZm9yIFN1bnBsdXMgZmFtaWx5IHNlcmllcyBTb0MuDQpFdGhl
cm5ldCBkZXZpY2VzIG9mIFN1bnBsdXMgYXJlIGRlc2lnbmVkIGFuZCB1c2VkIGZvciBTdW5wbHVz
IFNvQy4NClNvIGZhciwgb25seSB0d28gU29DIG9mIFN1bnBsdXMgaGF2ZSB0aGUgbmV0d29yayBk
ZXZpY2UuDQpJJ2QgbGlrZSB0byBzaG93IHVwIHRoZSBzZWxlY3Rpb24gb25seSBmb3IgU3VucGx1
cyBTb0MuDQoNCj4gDQo+IElkZWFsbHksIHlvdSB3YW50IGl0IHRvIGFsc28gYnVpbGQgd2l0aCBD
T01QSUxFX1RFU1QsIHNvIHRoYXQgdGhlIGRyaXZlciBnZXRzDQo+IGJ1aWxkIGJ5IDAtZGF5IGFu
ZCBhbGwgdGhlIG90aGVyIGJ1aWxkIGJvdHMuDQoNCkkgYW0gbm90IHN1cmUgaWYgdGhpcyBpcyBt
YW5kYXRvcnkgb3Igbm90Lg0KU2hvdWxkIEkgYWRkIENPTVBJTEVfVEVTVCBhcyBiZWxvdz8NCg0K
CWRlcGVuZHMgb24gQVJDSF9TVU5QTFVTIHwgQ09NUElMRV9URVNUDQoNCj4gDQo+ID4gCS0tLWhl
bHAtLS0NCj4gPiAJICBJZiB5b3UgaGF2ZSBhIG5ldHdvcmsgKEV0aGVybmV0KSBjYXJkIGJlbG9u
Z2luZyB0byB0aGlzDQo+ID4gCSAgY2xhc3MsIHNheSBZIGhlcmUuDQo+ID4NCj4gPiAJICBOb3Rl
IHRoYXQgdGhlIGFuc3dlciB0byB0aGlzIHF1ZXN0aW9uIGRvZXNuJ3QgZGlyZWN0bHkNCj4gPiAJ
ICBhZmZlY3QgdGhlIGtlcm5lbDogc2F5aW5nIE4gd2lsbCBqdXN0IGNhdXNlIHRoZSBjb25maWd1
cmF0b3INCj4gPiAJICB0byBza2lwIGFsbCB0aGUgcXVlc3Rpb25zIGFib3V0IFN1bnBsdXMgY2Fy
ZHMuIElmIHlvdSBzYXkgWSwNCj4gPiAJICB5b3Ugd2lsbCBiZSBhc2tlZCBmb3IgeW91ciBzcGVj
aWZpYyBjYXJkIGluIHRoZSBmb2xsb3dpbmcNCj4gPiAJICBxdWVzdGlvbnMuDQo+ID4NCj4gPiBp
ZiBORVRfVkVORE9SX1NVTlBMVVMNCj4gPg0KPiA+IGNvbmZpZyBTUDcwMjFfRU1BQw0KPiA+IAl0
cmlzdGF0ZSAiU3VucGx1cyBEdWFsIDEwTS8xMDBNIEV0aGVybmV0ICh3aXRoIEwyIHN3aXRjaCkg
ZGV2aWNlcyINCj4gPiAJZGVwZW5kcyBvbiBFVEhFUk5FVCAmJiBTT0NfU1A3MDIxDQo+IA0KPiBE
b2VzIGl0IGFjdHVhbGx5IGRlcGVuZCBvbiBTT0NfU1A3MDIxIHRvIGJ1aWxkPw0KPiANCj4gICAg
ICBBbmRyZXcNCg0KWWVzLCB0aGUgZGV2aWNlIGlzIG5vdyBvbmx5IGZvciBTdW5wbHVzIFNQNzAy
MSBTb0MuDQpEZXZpY2VzIGluIGVhY2ggU29DIG1heSBoYXZlIGEgYml0IGRpZmZlcmVuY2UgYmVj
YXVzZSBvZiBhZGRpbmcgbmV3IA0KZnVuY3Rpb24gb3IgaW1wcm92aW5nIHNvbWV0aGluZy4NCg0K
