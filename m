Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAC2449A45
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbhKHQue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:50:34 -0500
Received: from 113.196.136.162.ll.static.sparqnet.net ([113.196.136.162]:49192
        "EHLO mg.sunplus.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S240259AbhKHQud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 11:50:33 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(13482:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Tue, 09 Nov 2021 00:47:38 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Tue, 9 Nov 2021 00:47:33 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Tue, 9 Nov 2021
 00:47:34 +0800
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
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKvxfraAgAGf2kCAAU6CgIAE3RVA///T9oCAAJMwUP//h9mAgACMUqA=
Date:   Mon, 8 Nov 2021 16:47:34 +0000
Message-ID: <585e234fdb74499caafee3b43b5e5ab4@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <YYK+EeCOu/BXBXDi@lunn.ch>
 <64626e48052c4fba9057369060bfbc84@sphcmbx02.sunplus.com.tw>
 <YYUzgyS6pfQOmKRk@lunn.ch>
 <7c77f644b7a14402bad6dd6326ba85b1@sphcmbx02.sunplus.com.tw>
 <YYkjBdu64r2JF1bR@lunn.ch>
 <4e663877558247048e9b04b027e555b8@sphcmbx02.sunplus.com.tw>
 <YYk5s5fDuub7eBqu@lunn.ch>
In-Reply-To: <YYk5s5fDuub7eBqu@lunn.ch>
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

PiA+IFRoZSBzd2l0Y2ggd2lsbCBub3QgcmVjb2duaXplIHR5cGUgb2YgcGFja2V0cywgcmVnYXJk
bGVzcyBCUERVLCBQVFAgb3INCj4gPiBhbnkgb3RoZXIgcGFja2V0cy4gSWYgdHVybmluZyBvZmYg
c291cmNlLWFkZHJlc3MgbGVhcm5pbmcgZnVuY3Rpb24sIGl0DQo+ID4gd29ya3MgbGlrZSBhbiBF
dGhlcm5ldCBwbHVzIGEgMi1wb3J0IGh1Yi4NCj4gDQo+IFNvIHdpdGhvdXQgU1RQLCB0aGVyZSBp
cyBubyB3YXkgdG8gc3RvcCBhbiBsb29wLCBhbmQgYSBicm9hZGNhc3Qgc3Rvcm0gdGFraW5nDQo+
IGRvd24geW91ciBuZXR3b3JrPw0KDQpEbyB5b3UgbWVhbiBjb25uZWN0aW5nIHR3byBQSFkgcG9y
dHMgdG8gdGhlIHNhbWUgTEFOPyBXZSBuZXZlciANCmNvbm5lY3QgdHdvIFBIWSBwb3J0cyB0byB0
aGUgc2FtZSBMQU4gKG9yIGh1YikuIEkgbmV2ZXIgdGhpbmsgb2YgdGhpcyANCmxvb3AgcHJvYmxl
bS4gSSB0aG91Z2h0IG9ubHkgV0FOIGhhcyB0aGUgbG9vcCBwcm9ibGVtLg0KDQpUaGUgc3dpdGNo
IGhhcyBzb21lIGtpbmRzIG9mIGZsb3cgY29udHJvbCwgcmVmZXIgdG8gMC4yICJGbG93IGNvbnRy
b2wgdGhyZXNob2xkIg0KYW5kIDAuMyAiQ1BVIHBvcnQgZmxvdyBjb250cm9sIHRocmVzaG9sZCIu
IEl0IHdpbGwgZHJvcCBleHRyYSBwYWNrZXRzLg0KSG93IGFuIEV0aGVybmV0IGh1YiB0YWtlIGNh
cmUgb2YgdGhpcyBzaXR1YXRpb24/DQpJcyB0aGF0IHJlYXNvbmFibGUgdG8gY29ubmVjdCB0d28g
cG9ydHMgb2YgYW4gRXRoZXJuZXQgaHViIHRvZ2V0aGVyPw0KDQoNCj4gTG9va2luZyBhdCB0aGUg
VFggZGVzY3JpcHRvciwgdGhlcmUgYXJlIHR3byBiaXRzOg0KPiANCj4gICAgICAgICAgIFsxOF06
IGZvcmNlIGZvcndhcmQgdG8gcG9ydCAwDQo+ICAgICAgICAgICBbMTldOiBmb3JjZSBmb3J3YXJk
IHRvIHBvcnQgMQ0KPiANCj4gV2hlbiB0aGUgc3dpdGNoIGlzIGVuYWJsZWQsIGNhbiB0aGVzZSB0
d28gYml0cyBiZSB1c2VkPw0KDQpZZXMsIGZvciBleGFtcGxlLCB3aGVuIGJpdCAxOSBvZiBUWCBk
ZXNjcmlwdG9yIGlzIGVuYWJsZWQsIGEgcGFja2V0IGZyb20gQ1BVIA0KcG9ydCBpcyBmb3J3YXJk
ZWQgdG8gTEFOIHBvcnQgMCBmb3JjaWJseS4NCg0KDQo+IEluIHRoZSBSWCBkZXNjcmlwdG9yIHRo
ZXJlIGlzOg0KPiANCj4gcGt0X3NwOg0KPiAgICAgICAgICAgMDAwOiBmcm9tIHBvcnQwDQo+ICAg
ICAgICAgICAwMDE6IGZyb20gcG9ydDENCj4gICAgICAgICAgIDExMDogc29jMCBsb29wYmFjaw0K
PiAgICAgICAgICAgMTAxOiBzb2MxIGxvb3BiYWNrDQo+IA0KPiBBcmUgdGhlc2UgYml0cyB1c2Vk
IHdoZW4gdGhlIHN3aXRjaCBpcyBlbmFibGVkPw0KDQpZZXMsIEUtIE1BQyBkcml2ZXIgdXNlcyB0
aGVzZSBiaXRzIHRvIHRlbGwgd2hlcmUgYSBwYWNrZXQgY29tZXMgZnJvbS4NCk5vdGUgdGhhdCBz
b2MxIHBvcnQgKENQVSBwb3J0KSBoYXMgYmVlbiByZW1vdmVkIGluIHRoaXMgY2hpcC4NCg0KDQo+
IDAuMzEgcG9ydCBjb250cm9sIDEgKHBvcnQgY250bDEpIGJsb2NraW5nIHN0YXRlIHNlZW1zIHRv
IGhhdmUgd2hhdCB5b3UgbmVlZCBmb3INCj4gU1RQLg0KDQpGcm9tIGRvY3VtZW50LCBpZiBiaXQg
MTcgb3IgYml0IDE2IG9mIHBvcnRfY250bDEgcmVnaXN0ZXIgaXMgc2V0LCBvbmx5IFJNQyANCnBh
Y2tldHMgd2lsbCBiZSBmb3J3YXJkZWQgdG8gb3RoZXIgTEFOIHBvcnQuIEkgYW0gbm90IHN1cmUg
d2hldGhlciANCmVuYWJsaW5nIHRoZSBiaXRzIGhlbHBzIHRoZSBpc3N1ZS4gU2hvdWxkIEkgZW5h
YmxlIHRoZSBiaXRzPw0KU29ycnksIEkgZG9uJ3Qga25vdyB3aGF0IGlzIGEgUk1DIHBhY2tldD8N
CkNvdWxkIHlvdSBwbGVhc2UgdGVhY2ggbWU/DQoNCg0KPiAgICAgQW5kcmV3DQoNClRoYW5rIHlv
dSBmb3IgcmV2aWV3Lg0KDQo=
