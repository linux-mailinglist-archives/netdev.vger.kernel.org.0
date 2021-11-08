Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDD34481AD
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbhKHO3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:29:06 -0500
Received: from mswedge2.sunplus.com ([60.248.182.106]:48032 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234601AbhKHO3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:29:05 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(53121:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Mon, 08 Nov 2021 22:26:11 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Mon, 8 Nov 2021 22:26:11 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Mon, 8 Nov 2021
 22:26:11 +0800
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
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKvxfraAgAGf2kCAAU6CgIAE3RVA///T9oCAAJMwUA==
Date:   Mon, 8 Nov 2021 14:26:11 +0000
Message-ID: <4e663877558247048e9b04b027e555b8@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <YYK+EeCOu/BXBXDi@lunn.ch>
 <64626e48052c4fba9057369060bfbc84@sphcmbx02.sunplus.com.tw>
 <YYUzgyS6pfQOmKRk@lunn.ch>
 <7c77f644b7a14402bad6dd6326ba85b1@sphcmbx02.sunplus.com.tw>
 <YYkjBdu64r2JF1bR@lunn.ch>
In-Reply-To: <YYkjBdu64r2JF1bR@lunn.ch>
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

PiA+IFNQNzAyMSBFdGhlcm5ldCBzdXBwb3J0cyAzIG9wZXJhdGlvbiBtb2RlczoNCj4gPiAgLSBE
dWFsIEV0aGVybmV0IG1vZGUNCj4gPiAgICBJbiB0aGlzIG1vZGUsIGRyaXZlciBjcmVhdGVzIHR3
byBuZXQtZGV2aWNlIGludGVyZmFjZXMuIEVhY2ggY29ubmVjdHMNCj4gPiAgICB0byBQSFkuIFRo
ZXJlIGFyZSB0d28gTEFOIHBvcnRzIHRvdGFsbHkuDQo+ID4gICAgSSBhbSBzb3JyeSB0aGF0IEVN
QUMgb2YgU1A3MDIxIGNhbm5vdCBzdXBwb3J0IEwyIHN3aXRjaCBmdW5jdGlvbnMNCj4gPiAgICBv
ZiBMaW51eCBzd2l0Y2gtZGV2aWNlIG1vZGVsIGJlY2F1c2UgaXQgb25seSBoYXMgcGFydGlhbCBm
dW5jdGlvbiBvZg0KPiA+ICAgIHN3aXRjaC4NCj4gDQo+IFRoaXMgaXMgZmluZS4NCg0KVGhhbmtz
IGEgbG90IQ0KDQoNCj4gPg0KPiA+ICAtIE9uZSBFdGhlcm5ldCBtb2RlDQo+ID4gICAgSW4gdGhp
cyBtb2RlLCBkcml2ZXIgY3JlYXRlcyBvbmUgbmV0LWRldmljZSBpbnRlcmZhY2UuIEl0IGNvbm5l
Y3RzIHRvDQo+ID4gICAgdG8gYSBQSFkgKFRoZXJlIGlzIG9ubHkgb25lIExBTiBwb3J0KS4NCj4g
PiAgICBUaGUgTEFOIHBvcnQgaXMgdGhlbiBjb25uZWN0ZWQgdG8gYSAzLXBvcnQgRXRoZXJuZXQg
aHViLg0KPiA+ICAgIFRoZSAzLXBvcnQgRXRoZXJuZXQgaHViIGlzIGEgaGFyZHdhcmUgY2lyY3Vp
dHJ5LiBBbGwgb3BlcmF0aW9ucw0KPiA+ICAgIChwYWNrZXQgZm9yd2FyZGluZykgYXJlIGRvbmUg
YnkgaGFyZHdhcmUuIE5vIHNvZnR3YXJlDQo+ID4gICAgaW50ZXJ2ZW50aW9uIGlzIG5lZWRlZC4g
QWN0dWFsbHksIGV2ZW4ganVzdCBwb3dlci1vbiwgbm8gc29mdHdhcmUNCj4gPiAgICBydW5uaW5n
LCB0d28gTEFOIHBvcnRzIG9mIFNQNzAyMSB3b3JrIHdlbGwgYXMgMi1wb3J0IGh1Yi4NCj4gDQo+
IFdlIG5lZWQgdG8gZGlnIGludG8gdGhlIGRldGFpbHMgb2YgdGhpcyBtb2RlLiBJIHdvdWxkIGlu
aXRpYWxseSBzYXkgbm8sIHVudGlsIHdlDQo+IHJlYWxseSBkbyBrbm93IGl0IGlzIGltcG9zc2li
bGUgdG8gZG8gaXQgY29ycmVjdGx5LiAgRXZlbiBpZiBpdCBpcyBpbXBvc3NpYmxlIHRvIGRvDQo+
IGl0IGNvcnJlY3RseSwgaSdtIHN0aWxsIHRlbXBlZCB0byByZWplY3QgdGhpcyBtb2RlLg0KPiAN
Cj4gSG93IGRvZXMgc3Bhbm5pbmcgdHJlZSB3b3JrPyBXaG8gc2VuZHMgYW5kIHJlY2VpdmVzIHRo
ZSBCUERVPw0KPiANCj4gSXMgdGhlcmUgUFRQIHN1cHBvcnQ/IEhvdyBkbyB5b3Ugc2VuZCBhbmQg
cmVjZWl2ZSB0aGUgUFRQIGZyYW1lcz8NCj4gDQo+IElzIElHTVAgc25vb3Bpbmcgc3VwcG9ydGVk
Pw0KPiANCj4gQWxsIG9mIHRoZXNlIGhhdmUgb25lIHRoaW5nIGluIGNvbW1vbiwgeW91IG5lZWQg
dG8gYmUgYWJsZSB0byBlZ3Jlc3MgZnJhbWVzDQo+IG91dCBhIHNwZWNpZmljIHBvcnQgb2YgdGhl
IHN3aXRjaCwgYW5kIHlvdSBuZWVkIHRvIGtub3cgd2hhdCBwb3J0IGEgcmVjZWl2ZWQNCj4gZnJh
bWVzIGluZ3Jlc3NlZCBvbi4gSWYgeW91IGNhbiBkbyB0aGF0LCB5b3UgY2FuIHByb2JhYmx5IGRv
IHByb3BlciBzdXBwb3J0IGluDQo+IExpbnV4Lg0KDQpUaGUgIkwyIHN3aXRjaCIgaXMgYSB2ZXJ5
IHNpbXBsZSB3aXRjaC4gSXQgaGFzIDMgcG9ydHM6IENQVSwgTEFOIHBvcnQgMCBhbmQgTEFOIA0K
cG9ydCAxLiBBIHBhY2tldCBpcyBhbHdheXMgZm9yd2FyZGVkIHRvIG90aGVyIHR3byBwb3J0cyBp
ZiBzb3VyY2UtYWRkcmVzcyAob2YgTUFDKQ0KbGVhcm5pbmcgZnVuY3Rpb24gaXMgb2ZmLCBvciBm
b3J3YXJkZWQgdG8gb25lIG9mIHRoZSB0d28gcG9ydHMgaWYgc291cmNlLWFkZHJlc3MNCmxlYXJu
aW5nIGZ1bmN0aW9uIGlzIG9uIGFuZCBzb3VyY2UgYWRkcmVzcyBpcyBsZWFybnQgKHJlY29yZGVk
IGJ5IHN3aXRjaCkuDQoNClRoZSBzd2l0Y2ggd2lsbCBub3QgcmVjb2duaXplIHR5cGUgb2YgcGFj
a2V0cywgcmVnYXJkbGVzcyBCUERVLCBQVFAgb3IgYW55IG90aGVyDQpwYWNrZXRzLiBJZiB0dXJu
aW5nIG9mZiBzb3VyY2UtYWRkcmVzcyBsZWFybmluZyBmdW5jdGlvbiwgaXQgd29ya3MgbGlrZSBh
biBFdGhlcm5ldA0KcGx1cyBhIDItcG9ydCBodWIuDQoNCg0KPiBJcyB0aGUgZGF0YXNoZWV0IGF2
YWlsYWJsZT8NCg0KWWVzLCByZWZlciB0byBvbi1saW5lIGRvY3VtZW50IG9mIFNQNzAyMToNCmh0
dHBzOi8vc3VucGx1cy10aWJiby5hdGxhc3NpYW4ubmV0L3dpa2kvc3BhY2VzL2RvYy9wYWdlcy80
NjI1NTMwOTAvMTUuK0V0aGVybmV0K1N3aXRjaA0KDQoNCj4gDQo+ICAgIEFuZHJldw0K
