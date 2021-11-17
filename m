Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B679D4543BD
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhKQJbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 04:31:38 -0500
Received: from mswedge2.sunplus.com ([60.248.182.106]:36420 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235191AbhKQJbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:31:34 -0500
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.112
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(23399:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Wed, 17 Nov 2021 17:28:32 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx02.sunplus.com.tw (172.17.9.112) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Wed, 17 Nov 2021 17:28:27 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Wed, 17 Nov
 2021 17:28:27 +0800
From:   =?utf-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
To:     Pavel Skripkin <paskripkin@gmail.com>,
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
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKwC8bWAgASQUtA=
Date:   Wed, 17 Nov 2021 09:28:27 +0000
Message-ID: <29c352ebf87a4ecb854c5599f5282910@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <52dbf9c9-0fa6-d4c6-ed6e-bba39e6e921b@gmail.com>
In-Reply-To: <52dbf9c9-0fa6-d4c6-ed6e-bba39e6e921b@gmail.com>
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

SGkgUGF2ZWwsDQoNCj4gSGksIFdlbGxzIQ0KPiANCj4gT24gMTEvMy8yMSAxNDowMiwgV2VsbHMg
THUgd3JvdGU6DQo+IA0KPiBbY29kZSBzbmlwXQ0KPiANCj4gPiArCQlpZiAoY29tbS0+ZHVhbF9u
aWMpIHsNCj4gPiArCQkJc3RydWN0IG5ldF9kZXZpY2UgKm5ldF9kZXYyID0gbWFjLT5uZXh0X25l
dGRldjsNCj4gPiArDQo+ID4gKwkJCWlmICghbmV0aWZfcnVubmluZyhuZXRfZGV2MikpIHsNCj4g
PiArCQkJCW1hY19od19zdG9wKG1hYyk7DQo+ID4gKw0KPiA+ICsJCQkJbWFjMiA9IG5ldGRldl9w
cml2KG5ldF9kZXYyKTsNCj4gPiArDQo+IA0KPiAoKikNCj4gDQo+ID4gKwkJCQkvLyB1bnJlZ2lz
dGVyIGFuZCBmcmVlIG5ldCBkZXZpY2UuDQo+ID4gKwkJCQl1bnJlZ2lzdGVyX25ldGRldihuZXRf
ZGV2Mik7DQo+ID4gKwkJCQlmcmVlX25ldGRldihuZXRfZGV2Mik7DQo+ID4gKwkJCQltYWMtPm5l
eHRfbmV0ZGV2ID0gTlVMTDsNCj4gPiArCQkJCXByX2luZm8oIiBVbnJlZ2lzdGVyZWQgYW5kIGZy
ZWVkIG5ldCBkZXZpY2UgXCJldGgxXCIhXG4iKTsNCj4gPiArDQo+ID4gKwkJCQljb21tLT5kdWFs
X25pYyA9IDA7DQo+ID4gKwkJCQltYWNfc3dpdGNoX21vZGUobWFjKTsNCj4gPiArCQkJCXJ4X21v
ZGVfc2V0KG5ldF9kZXYpOw0KPiA+ICsJCQkJbWFjX2h3X2FkZHJfZGVsKG1hYzIpOw0KPiA+ICsN
Cj4gDQo+IG1hYzIgaXMgbmV0X2RldjIgcHJpdmF0ZSBkYXRhICgqKSwgc28gaXQgd2lsbCBiZWNv
bWUgZnJlZWQgYWZ0ZXINCj4gZnJlZV9uZXRkZXYoKSBjYWxsLg0KPiANCj4gRldJVyB0aGUgbGF0
ZXN0IGBzbWF0Y2hgIHNob3VsZCB3YXJuIGFib3V0IHRoaXMgdHlwZSBvZiBidWdzLg0KDQpZZXMs
IHRoaXMgaXMgaW5kZWVkIGEgYnVnLg0KQnV0IHRoZSBjb2RlIHBhcmFncmFwaCBoYXMgYmVlbiBy
ZW1vdmVkIHRob3JvdWdobHkgaW4gW1BBVENIIHYyXS4NCg0KDQo+ID4gKwkJCQkvLyBJZiBldGgw
IGlzIHVwLCB0dXJuIG9uIGxhbiAwIGFuZCAxIHdoZW4NCj4gPiArCQkJCS8vIHN3aXRjaGluZyB0
byBkYWlzeS1jaGFpbiBtb2RlLg0KPiA+ICsJCQkJaWYgKGNvbW0tPmVuYWJsZSAmIDB4MSkNCj4g
PiArCQkJCQljb21tLT5lbmFibGUgPSAweDM7DQo+IA0KPiBbY29kZSBzbmlwXQ0KPiANCj4gPiAr
c3RhdGljIGludCBsMnN3X3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KSB7DQo+
ID4gKwlzdHJ1Y3QgbmV0X2RldmljZSAqbmV0X2RldjsNCj4gPiArCXN0cnVjdCBuZXRfZGV2aWNl
ICpuZXRfZGV2MjsNCj4gPiArCXN0cnVjdCBsMnN3X21hYyAqbWFjOw0KPiA+ICsNCj4gPiArCW5l
dF9kZXYgPSBwbGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2KTsNCj4gPiArCWlmICghbmV0X2RldikN
Cj4gPiArCQlyZXR1cm4gMDsNCj4gPiArCW1hYyA9IG5ldGRldl9wcml2KG5ldF9kZXYpOw0KPiA+
ICsNCj4gPiArCS8vIFVucmVnaXN0ZXIgYW5kIGZyZWUgMm5kIG5ldCBkZXZpY2UuDQo+ID4gKwlu
ZXRfZGV2MiA9IG1hYy0+bmV4dF9uZXRkZXY7DQo+ID4gKwlpZiAobmV0X2RldjIpIHsNCj4gPiAr
CQl1bnJlZ2lzdGVyX25ldGRldihuZXRfZGV2Mik7DQo+ID4gKwkJZnJlZV9uZXRkZXYobmV0X2Rl
djIpOw0KPiA+ICsJfQ0KPiA+ICsNCj4gDQo+IElzIGl0IHNhdmUgaGVyZSB0byBmcmVlIG1hYy0+
bmV4dF9uZXRkZXYgYmVmb3JlIHVucmVnaXN0ZXJpbmcgInBhcmVudCINCj4gbmV0ZGV2PyBJIGhh
dmVuJ3QgY2hlY2tlZCB0aGUgd2hvbGUgY29kZSwganVzdCBhc2tpbmcgOikNCg0KWWVzLCBJIHRo
aW5rIGl0IGlzIHNhdmUuDQpuZXRkZXYyIHNob3VsZCBiZSB1bnJlZ2lzdGVyZWQgYW5kIGZyZWVk
IGJlZm9yZSBuZXRfZGV2Lg0KSWYgbmV0X2RldiBpcyB1bnJlZ2lzdGVyZWQgYW5kIGZyZWVkIGlu
IGFkdmFuY2UsDQptYWMtPm5leHRfbmV0ZGV2IGJlY29tZXMgZGFuZ2VyIGJlY2F1c2UgJ21hYycg
aGFzIGJlZW4gZnJlZWQuDQoNCg0KPiA+ICsJc3lzZnNfcmVtb3ZlX2dyb3VwKCZwZGV2LT5kZXYu
a29iaiwgJmwyc3dfYXR0cmlidXRlX2dyb3VwKTsNCj4gPiArDQo+ID4gKwltYWMtPmNvbW0tPmVu
YWJsZSA9IDA7DQo+ID4gKwlzb2MwX3N0b3AobWFjKTsNCj4gPiArDQo+ID4gKwluYXBpX2Rpc2Fi
bGUoJm1hYy0+Y29tbS0+cnhfbmFwaSk7DQo+ID4gKwluZXRpZl9uYXBpX2RlbCgmbWFjLT5jb21t
LT5yeF9uYXBpKTsNCj4gPiArCW5hcGlfZGlzYWJsZSgmbWFjLT5jb21tLT50eF9uYXBpKTsNCj4g
PiArCW5ldGlmX25hcGlfZGVsKCZtYWMtPmNvbW0tPnR4X25hcGkpOw0KPiA+ICsNCj4gPiArCW1k
aW9fcmVtb3ZlKG5ldF9kZXYpOw0KPiA+ICsNCj4gPiArCS8vIFVucmVnaXN0ZXIgYW5kIGZyZWUg
MXN0IG5ldCBkZXZpY2UuDQo+ID4gKwl1bnJlZ2lzdGVyX25ldGRldihuZXRfZGV2KTsNCj4gPiAr
CWZyZWVfbmV0ZGV2KG5ldF9kZXYpOw0KPiA+ICsNCj4gPiArCWNsa19kaXNhYmxlKG1hYy0+Y29t
bS0+Y2xrKTsNCj4gPiArDQo+ID4gKwkvLyBGcmVlICdjb21tb24nIGFyZWEuDQo+ID4gKwlrZnJl
ZShtYWMtPmNvbW0pOw0KPiANCj4gU2FtZSBoZXJlIHdpdGggYG1hY2AuDQoNClRoaXMgaXMgaW5k
ZWVkIGEgYnVnLg0KQnV0IHRoZSBzdGF0ZW1lbnQsIEtmcmVlKG1hYy0+Y29tbSk7LCBoYXMgYmVl
biByZW1vdmVkIGluIFtQQVRDSCB2Ml0uDQpJbiBbUEFUQ0ggdjJdLCBzdHJ1Y3R1cmUgZGF0YSAn
bWFjLT5jb21tJyBpcyBhbGxvY2F0ZWQgYnkNCmRldm1fa3phbGxvYygpLiBObyBtb3JlIG5lZWQg
dG8gZnJlZSBpdCBoZXJlLg0KDQoNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+IA0KPiANCj4g
SSBoYXZlbid0IHJlYWQgdGhlIHdob2xlIHRocmVhZCwgaSBhbSBzb3JyeSBpZiB0aGVzZSBxdWVz
dGlvbnMgd2VyZSBhbHJlYWR5IGRpc2N1c3NlZC4NCj4gDQo+IA0KPiANCj4gV2l0aCByZWdhcmRz
LA0KPiBQYXZlbCBTa3JpcGtpbg0KDQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgcmV2
aWV3IQ0KDQpCZXN0IHJlZ2FyZHMsDQpXZWxscyBMdQ0K
