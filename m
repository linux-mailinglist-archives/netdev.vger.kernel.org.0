Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF0D44E08A
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 03:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhKLCxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 21:53:09 -0500
Received: from mswedge1.sunplus.com ([60.248.182.113]:40510 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234569AbhKLCxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 21:53:08 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(25022:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Fri, 12 Nov 2021 10:50:07 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Fri, 12 Nov 2021 10:50:06 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Fri, 12 Nov
 2021 10:50:07 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>, Wells Lu <wellslutw@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        =?big5?B?VmluY2VudCBTaGloIKxJwEPCRQ==?= <vincent.shih@sunplus.com>
Subject: RE: [PATCH v2 1/2] devicetree: bindings: net: Add bindings doc for
 Sunplus SP7021.
Thread-Topic: [PATCH v2 1/2] devicetree: bindings: net: Add bindings doc for
 Sunplus SP7021.
Thread-Index: AQHX1ttD14D1e9fuyEOeGcQRZL+/3qv+HqCAgAEP3AA=
Date:   Fri, 12 Nov 2021 02:50:07 +0000
Message-ID: <ad1bd782276844f7b4e2457c5d971af4@sphcmbx02.sunplus.com.tw>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <321e3b1a7dfca81f3ffae03b11099e8efeef92fa.1636620754.git.wells.lu@sunplus.com>
 <YY1fofJI0CW4Wmh5@lunn.ch>
In-Reply-To: <YY1fofJI0CW4Wmh5@lunn.ch>
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

SGksDQoNCj4gPiArZXhhbXBsZXM6DQo+ID4gKyAgLSB8DQo+ID4gKyAgICAjaW5jbHVkZSA8ZHQt
YmluZGluZ3MvaW50ZXJydXB0LWNvbnRyb2xsZXIvaXJxLmg+DQo+ID4gKyAgICBlbWFjOiBlbWFj
QDljMTA4MDAwIHsNCj4gPiArICAgICAgICBjb21wYXRpYmxlID0gInN1bnBsdXMsc3A3MDIxLWVt
YWMiOw0KPiA+ICsgICAgICAgIHJlZyA9IDwweDljMTA4MDAwIDB4NDAwPiwgPDB4OWMwMDAyODAg
MHg4MD47DQo+ID4gKyAgICAgICAgcmVnLW5hbWVzID0gImVtYWMiLCAibW9vbjUiOw0KPiA+ICsg
ICAgICAgIGludGVycnVwdC1wYXJlbnQgPSA8JmludGM+Ow0KPiA+ICsgICAgICAgIGludGVycnVw
dHMgPSA8NjYgSVJRX1RZUEVfTEVWRUxfSElHSD47DQo+ID4gKyAgICAgICAgY2xvY2tzID0gPCZj
bGtjIDB4YTc+Ow0KPiA+ICsgICAgICAgIHJlc2V0cyA9IDwmcnN0YyAweDk3PjsNCj4gPiArICAg
ICAgICBwaHktaGFuZGxlMSA9IDwmZXRoX3BoeTA+Ow0KPiA+ICsgICAgICAgIHBoeS1oYW5kbGUy
ID0gPCZldGhfcGh5MT47DQo+ID4gKyAgICAgICAgcGluY3RybC0wID0gPCZlbWFjX2RlbW9fYm9h
cmRfdjNfcGlucz47DQo+ID4gKyAgICAgICAgcGluY3RybC1uYW1lcyA9ICJkZWZhdWx0IjsNCj4g
PiArICAgICAgICBudm1lbS1jZWxscyA9IDwmbWFjX2FkZHIwPiwgPCZtYWNfYWRkcjE+Ow0KPiA+
ICsgICAgICAgIG52bWVtLWNlbGwtbmFtZXMgPSAibWFjX2FkZHIwIiwgIm1hY19hZGRyMSI7DQo+
ID4gKw0KPiA+ICsgICAgICAgIG1kaW8gew0KPiA+ICsgICAgICAgICAgICAjYWRkcmVzcy1jZWxs
cyA9IDwxPjsNCj4gPiArICAgICAgICAgICAgI3NpemUtY2VsbHMgPSA8MD47DQo+ID4gKyAgICAg
ICAgICAgIGV0aF9waHkwOiBldGhlcm5ldC1waHlAMCB7DQo+ID4gKyAgICAgICAgICAgICAgICBy
ZWcgPSA8MD47DQo+ID4gKyAgICAgICAgICAgICAgICBwaHktbW9kZSA9ICJybWlpIjsNCj4gDQo+
IFRoaXMgaXMgaW4gdGhlIHdyb25nIHBsYWNlLiBJdCBpcyBhIE1BQyBwcm9wZXJ0eS4gWW91IHVz
dWFsbHkgcHV0IGl0IG5leHQgdG8gcGh5LWhhbmRsZS4NCg0KWWVzLCBJJ2xsIG1vdmUgcGh5LW1v
ZGUgdG8gRXRoZXJuZXQtcG9ydCBuZXh0IHBhdGNoLg0KDQoNCj4gPiArICAgICAgICAgICAgfTsN
Cj4gPiArICAgICAgICAgICAgZXRoX3BoeTE6IGV0aGVybmV0LXBoeUAxIHsNCj4gPiArICAgICAg
ICAgICAgICAgIHJlZyA9IDwxPjsNCj4gPiArICAgICAgICAgICAgICAgIHBoeS1tb2RlID0gInJt
aWkiOw0KPiA+ICsgICAgICAgICAgICB9Ow0KPiA+ICsgICAgICAgIH07DQo+IA0KPiBJIHdvdWxk
IHN1Z2dlc3QgeW91IHN0cnVjdHVyZSB0aGlzIGRpZmZlcmVudGx5IHRvIG1ha2UgaXQgY2xlYXIg
aXQgaXMgYSB0d28gcG9ydCBzd2l0Y2g6DQo+IA0KPiAJZXRoZXJuZXQtcG9ydHMgew0KPiAJCSNh
ZGRyZXNzLWNlbGxzID0gPDE+Ow0KPiAgICAgICAgICAgICAgICAgI3NpemUtY2VsbHMgPSA8MD47
DQo+IA0KPiAgICAgICAgICAgICAgICAgcG9ydEAwIHsNCj4gICAgICAgICAgICAgICAgICAgICBy
ZWcgPSA8MD47DQo+IAkJICAgIHBoeS1oYW5kbGUgPSA8JmV0aF9waHkwPjsNCj4gCQkgICAgcGh5
LW1vZGUgPSAicm1paSI7DQo+IAkJfQ0KPiANCj4gCQlwb3J0QDEgew0KPiAgICAgICAgICAgICAg
ICAgICAgIHJlZyA9IDwxPjsNCj4gCQkgICAgcGh5LWhhbmRsZSA9IDwmZXRoX3BoeTE+Ow0KPiAJ
CSAgICBwaHktbW9kZSA9ICJybWlpIjsNCj4gCQl9DQo+IAl9DQo+IA0KPiAJQW5kcmV3DQoNClll
cywgcmVmZXIgdG8gbmV3IGV4YW1wbGU6DQoNCmV4YW1wbGVzOg0KICAtIHwNCiAgICAjaW5jbHVk
ZSA8ZHQtYmluZGluZ3MvaW50ZXJydXB0LWNvbnRyb2xsZXIvaXJxLmg+DQogICAgZW1hYzogZW1h
Y0A5YzEwODAwMCB7DQogICAgICAgIGNvbXBhdGlibGUgPSAic3VucGx1cyxzcDcwMjEtZW1hYyI7
DQogICAgICAgIHJlZyA9IDwweDljMTA4MDAwIDB4NDAwPiwgPDB4OWMwMDAyODAgMHg4MD47DQog
ICAgICAgIHJlZy1uYW1lcyA9ICJlbWFjIiwgIm1vb241IjsNCiAgICAgICAgaW50ZXJydXB0LXBh
cmVudCA9IDwmaW50Yz47DQogICAgICAgIGludGVycnVwdHMgPSA8NjYgSVJRX1RZUEVfTEVWRUxf
SElHSD47DQogICAgICAgIGNsb2NrcyA9IDwmY2xrYyAweGE3PjsNCiAgICAgICAgcmVzZXRzID0g
PCZyc3RjIDB4OTc+Ow0KICAgICAgICBwaW5jdHJsLTAgPSA8JmVtYWNfZGVtb19ib2FyZF92M19w
aW5zPjsNCiAgICAgICAgcGluY3RybC1uYW1lcyA9ICJkZWZhdWx0IjsNCiAgICAgICAgbnZtZW0t
Y2VsbHMgPSA8Jm1hY19hZGRyMD4sIDwmbWFjX2FkZHIxPjsNCiAgICAgICAgbnZtZW0tY2VsbC1u
YW1lcyA9ICJtYWNfYWRkcjAiLCAibWFjX2FkZHIxIjsNCg0KICAgICAgICBldGhlcm5ldC1wb3J0
cyB7DQogICAgICAgICAgICAjYWRkcmVzcy1jZWxscyA9IDwxPjsNCiAgICAgICAgICAgICNzaXpl
LWNlbGxzID0gPDA+Ow0KDQogICAgICAgICAgICBwb3J0QDAgew0KICAgICAgICAgICAgICAgIHJl
ZyA9IDwwPjsNCiAgICAgICAgICAgICAgICBwaHktaGFuZGxlID0gPCZldGhfcGh5MD47DQogICAg
ICAgICAgICAgICAgcGh5LW1vZGUgPSAicm1paSI7DQogICAgICAgICAgICB9Ow0KDQogICAgICAg
ICAgICBwb3J0QDEgew0KICAgICAgICAgICAgICAgIHJlZyA9IDwxPjsNCiAgICAgICAgICAgICAg
ICBwaHktaGFuZGxlID0gPCZldGhfcGh5MT47DQogICAgICAgICAgICAgICAgcGh5LW1vZGUgPSAi
cm1paSI7DQogICAgICAgICAgICB9Ow0KICAgICAgICB9Ow0KDQogICAgICAgIG1kaW8gew0KICAg
ICAgICAgICAgI2FkZHJlc3MtY2VsbHMgPSA8MT47DQogICAgICAgICAgICAjc2l6ZS1jZWxscyA9
IDwwPjsNCg0KICAgICAgICAgICAgZXRoX3BoeTA6IGV0aGVybmV0LXBoeUAwIHsNCiAgICAgICAg
ICAgICAgICByZWcgPSA8MD47DQogICAgICAgICAgICB9Ow0KDQogICAgICAgICAgICBldGhfcGh5
MTogZXRoZXJuZXQtcGh5QDEgew0KICAgICAgICAgICAgICAgIHJlZyA9IDwxPjsNCiAgICAgICAg
ICAgIH07DQogICAgICAgIH07DQogICAgfTsNCg0KSXMgaXQgY29ycmVjdD8NCg0KVGhhbmsgeW91
IHZlcnkgbXVjaCBmb3IgeW91ciByZXZpZXcuDQoNCg==
