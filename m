Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C815745F184
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378397AbhKZQSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:18:11 -0500
Received: from mswedge1.sunplus.com ([60.248.182.113]:52112 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1378396AbhKZQQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 11:16:11 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(15732:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Sat, 27 Nov 2021 00:12:50 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Sat, 27 Nov 2021 00:12:47 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Sat, 27 Nov
 2021 00:12:47 +0800
From:   =?utf-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        =?utf-8?B?VmluY2VudCBTaGloIOaWvemMlem0uw==?= 
        <vincent.shih@sunplus.com>
Subject: RE: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Topic: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
Thread-Index: AQHX1ttDZ0jKVsi7r0auZS2tEQF+d6wADq2AgAXn1uCADjVYcP//wFkAgAFNSvCAADlOgIAAnUMA
Date:   Fri, 26 Nov 2021 16:12:46 +0000
Message-ID: <38e40bc4c0de409ca959bcb847c1fc96@sphcmbx02.sunplus.com.tw>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <YY7/v1msiaqJF3Uy@lunn.ch>
 <7cccf9f79363416ca8115a7ed9b1b7fd@sphcmbx02.sunplus.com.tw>
 <YZ+pzFRCB0faDikb@lunn.ch>
 <6c1ce569d2dd46eba8d4b0be84d6159b@sphcmbx02.sunplus.com.tw>
 <YaDxc2+HKUYxsmX4@lunn.ch>
In-Reply-To: <YaDxc2+HKUYxsmX4@lunn.ch>
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

SGkgQW5kcmV3LA0KDQoNCkZyb20gZGF0YSBwcm92aWRlZCBieSBBU0lDIGVuZ2luZWVyLCBNQUMg
b2YgU1A3MDIxIG9ubHkNCnJlYWRzIHRoZSA0IHJlZ2lzdGVycyBvZiBQSFk6DQowOiBDb250cm9s
IHJlZ2lzdGVyDQoxOiBTdGF0dXMgcmVnaXN0ZXINCjQ6IEF1dG8tbmVnb3RpYXRpb24gYWR2ZXJ0
aXNlbWVudCByZWdpc3Rlcg0KNTogQXV0by1uZWdvdGlhdGlvbiBsaW5rIHBhcnRuZXIgYWJpbGl0
eSByZWdpc3Rlcg0KDQpJdCBkb2VzIG5vdCByZWFkIGFueSBvdGhlciByZWdpc3RlcnMgb2YgUEhZ
Lg0KDQoNCkJlc3QgcmVnYXJkcywNCldlbGxzIEx1DQoNCg0KPiA+IEhpIEFuZHJldywNCj4gPg0K
PiA+IEkgc2V0IHBoeS1pZCByZWdpc3RlcnMgdG8gMzAgYW5kIDMxIGFuZCBmb3VuZCB0aGUgcmVh
ZC1iYWNrIHZhbHVlcyBvZg0KPiA+IG1kaW8gcmVhZCBjb21tYW5kcyBmcm9tIENQVSBhcmUgYWxs
IDB4MDAwMC4NCj4gPg0KPiA+IEkgY29uc3VsdGVkIHdpdGggYW4gQVNJQyBlbmdpbmVlci4gU2hl
IGNvbmZpcm1lZCB0aGF0IGlmIHBoeS1pZCBvZiBhDQo+ID4gbWRpbyBjb21tYW5kIGZyb20gQ1BV
IGRvZXMgbm90IG1hdGNoIGFueSBwaHktaWQgcmVnaXN0ZXJzLCB0aGUgbWRpbw0KPiA+IGNvbW1h
bmQgd2lsbCBub3QgYmUgc2VudCBvdXQuDQo+ID4NCj4gPiBTaGUgZXhwbGFpbmVkIGlmIHBoeS1p
ZCBvZiBhIG1kaW8gY29tbWFuZCBkb2VzIG5vdCBtYXRjaCBhbnkgcGh5LWlkDQo+ID4gcmVnaXN0
ZXJzIChyZXByZXNlbnQgYWRkcmVzc2VzIG9mIGV4dGVybmFsIFBIWXMpLCB3aHkgTUFDIG5lZWRz
IHRvDQo+ID4gc2VuZCBhIGNvbW1hbmQgdG8gbm9uLWV4aXN0aW5nIFBIWT8NCj4gDQo+IFJlYWRz
IG9yIHdyaXRlcyBvbiBhIHJlYWwgUEhZIHdoaWNoIExpbnV4IGlzIGRyaXZpbmcgY2FuIGhhdmUg
c2lkZSBlZmZlY3RzLiBUaGVyZSBpcyBhDQo+IGxpbmsgc3RhdHVlIHJlZ2lzdGVyIHdoaWNoIGxh
dGNoZXMuIFJlYWQgaXQgb25jZSwgeW91IGdldCB0aGUgbGFzdCBzdGF0dXMsIHJlYWQgaXQgYWdh
aW4sDQo+IHlvdSBnZXQgdGhlIGN1cnJlbnQgc3RhdHVzLiBJZiB0aGUgTUFDIGhhcmR3YXJlIGlz
IHJlYWRpbmcgdGhpcyByZWdpc3RlciBhcyB3ZWxsIGEgTGludXgsDQo+IGJhZCB0aGluZ3Mgd2ls
bCBoYXBwZW4uIEEgcmVhZCBvbiB0aGUgaW50ZXJydXB0IHN0YXR1cyByZWdpc3RlciBvZnRlbiBj
bGVhcnMgdGhlIGludGVycnVwdHMuDQo+IFNvIExpbnV4IHdpbGwgbm90IHNlZSB0aGUgaW50ZXJy
dXB0cy4NCj4gDQo+IFNvIHlvdSBuZWVkIHRvIG1ha2Ugc3VyZSB5b3UgaGFyZHdhcmUgaXMgbm90
IHRvdWNoaW5nIGEgUEhZIHdoaWNoIExpbnV4IHVzZXMuIFdoaWNoIGlzDQo+IHdoeSBpIHN1Z2dl
c3RlZCB1c2luZyBNRElPIGJ1cyBhZGRyZXNzIDMxLCB3aGljaCBnZW5lcmFsbHkgZG9lcyBub3Qg
aGF2ZSBhIFBIWSBhdCB0aGF0DQo+IGFkZHJlc3MuDQo+IA0KPiAJICBBbmRyZXcNCg==
