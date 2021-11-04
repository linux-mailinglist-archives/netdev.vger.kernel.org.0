Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB92445A36
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 20:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhKDTGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 15:06:53 -0400
Received: from 113.196.136.162.ll.static.sparqnet.net ([113.196.136.162]:41358
        "EHLO mg.sunplus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233947AbhKDTGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 15:06:50 -0400
X-Greylist: delayed 104113 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2021 15:06:49 EDT
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(13488:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Fri, 05 Nov 2021 03:03:42 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Fri, 5 Nov 2021 03:03:43 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Fri, 5 Nov 2021
 03:03:43 +0800
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
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKvxbhgAgAClKgD//5f5gIABJz+w///9xoCAANUOEP//hOQAABHi4LA=
Date:   Thu, 4 Nov 2021 19:03:43 +0000
Message-ID: <72446c510f05480f9967c32df8787d46@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
 <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
 <YYLjaYCQHzqBzN1l@lunn.ch>
 <36d5bc6d40734ae0a9c1fb26d258f49f@sphcmbx02.sunplus.com.tw>
 <YYPZN9hPBJTBzVUl@lunn.ch>
 <c51d2927eedb4f3999b8361a44526a07@sphcmbx02.sunplus.com.tw>
 <YYQkqkZOwOhTa+VD@lunn.ch>
In-Reply-To: <YYQkqkZOwOhTa+VD@lunn.ch>
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

PiA+IE5vLCB3ZSBvbmx5IGRldmVsb3AgYXJtLWJhc2VkIFNvQywgbmV2ZXIgZm9yIHg4NiBvciBt
aXBzLg0KPiA+IFdlIG5ldmVyIGNvbXBpbGUgdGhlIGRyaXZlciBmb3IgeDg2IG9yIG1pcHMgbWFj
aGluZS4NCj4gDQo+IFlvdSBkb24ndCwgYnV0IHRoZSBMaW51eCBjb21tdW5pdHkgZG9lcyBidWls
ZCBmb3IgdGhvc2UgYXJjaGl0ZWN0dXJlcy4gTW9zdA0KPiBwZW9wbGUgZG8gdHJlZSB3aWRlIHJl
ZmFjdG9yaW5nIHdvcmsgdXNpbmcgeDg2LiBUcmVlIHdpZGUgY2xlYW51cHMgdXNpbmcgeDg2LA0K
PiBldGMuIEFueSBjaGFuZ2VzIGxpa2UgdGhhdCBjb3VsZCB0b3VjaCB5b3VyIGRyaXZlci4gVGhl
IGhhcmRlciBpcyBpdCB0byBidWlsZCwgdGhlDQo+IGxlc3MgYnVpbGQgdGVzdGluZyBpdCB3aWxs
IGdldCwgYW5kIHRyZWUgd2lkZSBjaGFuZ2VzIHdoaWNoIGJyZWFrIGl0IGFyZSBsZXNzIGxpa2Vs
eQ0KPiB0byBnZXQgbm90aWNlZC4gIFNvIHlvdSByZWFsbHkgZG8gd2FudCBpdCB0byBjb21waWxl
IGNsZWFubHkgZm9yIGFsbA0KPiBhcmNoaXRlY3R1cmVzLiBJZiBpdCBkb2VzIG5vdCwgaXQgbm9y
bWFsbHkgYWN0dWFsbHkgbWVhbnMgeW91IGFyZSBkb2luZw0KPiBzb21ldGhpbmcgd3JvbmcsIHNv
bWV0aGluZyB5b3UgbmVlZCB0byBmaXggYW55d2F5LiBTbyBwbGVhc2UgZG8gYnVpbGQgaXQgZm9y
DQo+IHg4NiBhbmQgbWFrZSBzdXJlIGl0IGJ1aWxkcyBjbGVhbmx5Lg0KPiANCj4gCSAgQW5kcmV3
DQoNCk9rLCBJIHVuZGVyc3RhbmQuDQpJJ2xsIGFkZCBDT01QSUxFX1RFU1QgYW5kIGNvbXBpbGUg
ZHJpdmVyIGZvciB4ODYuDQoNClRoYW5rcywNCg==
