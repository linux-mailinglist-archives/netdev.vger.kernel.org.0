Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65BA45E6B1
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358024AbhKZEB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 23:01:58 -0500
Received: from mswedge1.sunplus.com ([60.248.182.113]:39896 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S245314AbhKZD74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 22:59:56 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg01.sunplus.com with MailGates ESMTP Server V5.0(27483:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Fri, 26 Nov 2021 11:56:34 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Fri, 26 Nov 2021 11:56:28 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Fri, 26 Nov
 2021 11:56:28 +0800
From:   =?big5?B?V2VsbHMgTHUgp2aq2sTL?= <wells.lu@sunplus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Wells Lu <wellslutw@gmail.com>,
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
Thread-Index: AQHX1ttDZ0jKVsi7r0auZS2tEQF+d6wADq2AgAXn1uCADjVYcP//wFkAgAFNSvA=
Date:   Fri, 26 Nov 2021 03:56:28 +0000
Message-ID: <6c1ce569d2dd46eba8d4b0be84d6159b@sphcmbx02.sunplus.com.tw>
References: <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
 <YY7/v1msiaqJF3Uy@lunn.ch>
 <7cccf9f79363416ca8115a7ed9b1b7fd@sphcmbx02.sunplus.com.tw>
 <YZ+pzFRCB0faDikb@lunn.ch>
In-Reply-To: <YZ+pzFRCB0faDikb@lunn.ch>
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

SGkgQW5kcmV3LA0KDQpJIHNldCBwaHktaWQgcmVnaXN0ZXJzIHRvIDMwIGFuZCAzMSBhbmQgZm91
bmQgdGhlIHJlYWQtYmFjaw0KdmFsdWVzIG9mIG1kaW8gcmVhZCBjb21tYW5kcyBmcm9tIENQVSBh
cmUgYWxsIDB4MDAwMC4NCg0KSSBjb25zdWx0ZWQgd2l0aCBhbiBBU0lDIGVuZ2luZWVyLiBTaGUg
Y29uZmlybWVkIHRoYXQgaWYNCnBoeS1pZCBvZiBhIG1kaW8gY29tbWFuZCBmcm9tIENQVSBkb2Vz
IG5vdCBtYXRjaCBhbnkgDQpwaHktaWQgcmVnaXN0ZXJzLCB0aGUgbWRpbyBjb21tYW5kIHdpbGwg
bm90IGJlIHNlbnQgb3V0Lg0KDQpTaGUgZXhwbGFpbmVkIGlmIHBoeS1pZCBvZiBhIG1kaW8gY29t
bWFuZCBkb2VzIG5vdCBtYXRjaCANCmFueSBwaHktaWQgcmVnaXN0ZXJzIChyZXByZXNlbnQgYWRk
cmVzc2VzIG9mIGV4dGVybmFsIFBIWXMpLA0Kd2h5IE1BQyBuZWVkcyB0byBzZW5kIGEgY29tbWFu
ZCB0byBub24tZXhpc3RpbmcgUEhZPw0KDQoNCkJlc3QgcmVnYXJkcywNCg0KV2VsbHMgTHUNCqdm
qtrEyw0KDQq0vK/guUK64rFNrtcvU21hcnQgQ29tcHV0aW5nIFByb2dyYW0NCq5hrnilraV4qMa3
frhzL0hvbWUgRW50ZXJ0YWlubWVudCBCdXNpbmVzcyBVbml0DQqt4ranrOyn3i9TdW5wbHVzIFRl
Y2hub2xvZ3kgQ28uLCBMdGQuDQqmYad9oUczMDC3c6bLrOy+x7bpsM+z0LdzpEC49DE5uLkNCjE5
LCBJbm5vdmF0aW9uIDFzdCBSb2FkLA0KU2NpZW5jZS1iYXNlZCBJbmR1c3RyaWFsIFBhcmsNCkhz
aW4tQ2h1LCBUYWl3YW4gMzAwDQpURUyhRzg4Ni0zLTU3ODYwMDUgZXh0LiAyNTgwDQoNCj4gLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5u
LmNoPg0KPiBTZW50OiBUaHVyc2RheSwgTm92ZW1iZXIgMjUsIDIwMjEgMTE6MjEgUE0NCj4gVG86
IFdlbGxzIEx1IKdmqtrEyyA8d2VsbHMubHVAc3VucGx1cy5jb20+DQo+IENjOiBXZWxscyBMdSA8
d2VsbHNsdXR3QGdtYWlsLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9y
ZzsNCj4gcm9iaCtkdEBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0
cmVlQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgcC56
YWJlbEBwZW5ndXRyb25peC5kZTsgVmluY2VudCBTaGloIKxJwEPCRQ0KPiA8dmluY2VudC5zaGlo
QHN1bnBsdXMuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIDIvMl0gbmV0OiBldGhlcm5l
dDogQWRkIGRyaXZlciBmb3IgU3VucGx1cyBTUDcwMjENCj4gDQo+ID4gRHVlIHRvIGhhcmR3YXJl
IGRlc2lnbiwgd2Ugc3RpbGwgbmVlZCB0byBzZXQgUEhZIGFkZHJlc3MsIGJlY2F1c2UgTURJTw0K
PiA+IGNvbnRyb2xsZXIgb2YgU1A3MDIxIG9ubHkgc2VuZHMgb3V0IE1ESU8gY29tbWFuZHMgd2l0
aCB0aGUgc2FtZQ0KPiA+IGFkZHJlc3MgbGlzdGVkIGluIFBIWSBhZGRyZXNzIHJlZ2lzdGVycy4g
VGhlIGZ1bmN0aW9uIGJlbG93IG5lZWRzIHRvDQo+ID4gYmUga2VwdC4NCj4gDQo+IEkgc3VnZ2Vz
dCB5b3UgYWN0dWFsbHkgc2V0IGl0IHRvIHNvbWUgb3RoZXIgYWRkcmVzcy4gT25lIG9mIHRoZSBn
b29kL2JhZCB0aGluZ3MgYWJvdXQgTURJTw0KPiBpcyB5b3UgaGF2ZSBubyBpZGVhIGlmIHRoZSBk
ZXZpY2UgaXMgdGhlcmUuIEEgcmVhZCB0byBhIGRldmljZSB3aGljaCBkb2VzIG5vdCBleGlzdCBq
dXN0DQo+IHJldHVybnMgMHhmZmZmLCBub3QgYW4gZXJyb3IuIFNvIGkgd291bGQgc2V0IHRoZSBh
ZGRyZXNzIG9mIDB4MWYuIEkndmUgbmV2ZXIgc2VlbiBhIFBIWQ0KPiBhY3R1YWxseSB1c2UgdGhh
dCBhZGRyZXNzLg0KPiANCj4gICAgIEFuZHJldw0K
