Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EE84447EF
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 19:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhKCSLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 14:11:24 -0400
Received: from mswedge2.sunplus.com ([60.248.182.106]:54896 "EHLO
        mg.sunplus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229558AbhKCSLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 14:11:24 -0400
X-MailGates: (flag:3,DYNAMIC,RELAY,NOHOST:PASS)(compute_score:DELIVER,40
        ,3)
Received: from 172.17.9.202
        by mg02.sunplus.com with MailGates ESMTP Server V5.0(53146:0:AUTH_RELAY)
        (envelope-from <wells.lu@sunplus.com>); Thu, 04 Nov 2021 02:08:29 +0800 (CST)
Received: from sphcmbx02.sunplus.com.tw (172.17.9.112) by
 sphcmbx01.sunplus.com.tw (172.17.9.202) with Microsoft SMTP Server (TLS) id
 15.0.1497.23; Thu, 4 Nov 2021 02:08:28 +0800
Received: from sphcmbx02.sunplus.com.tw ([::1]) by sphcmbx02.sunplus.com.tw
 ([fe80::f8bb:bd77:a854:5b9e%14]) with mapi id 15.00.1497.023; Thu, 4 Nov 2021
 02:08:29 +0800
From:   =?utf-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
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
Thread-Index: AQHX0KKBcebTINBXKk6D/f7Frpi9sKvxbhgAgAClKgA=
Date:   Wed, 3 Nov 2021 18:08:29 +0000
Message-ID: <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
In-Reply-To: <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
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

PiANCj4gSGktLQ0KPiANCj4gT24gMTEvMy8yMSA0OjAyIEFNLCBXZWxscyBMdSB3cm90ZToNCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3VucGx1cy9LY29uZmlnDQo+ID4g
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdW5wbHVzL0tjb25maWcNCj4gPiBuZXcgZmlsZSBtb2Rl
IDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAuLmE5ZTNhNGMNCj4gPiAtLS0gL2Rldi9udWxsDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3VucGx1cy9LY29uZmlnDQo+ID4gQEAgLTAs
MCArMSwyMCBAQA0KPiA+ICsjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQo+ID4g
KyMNCj4gPiArIyBTdW5wbHVzIEV0aGVybmV0IGRldmljZSBjb25maWd1cmF0aW9uICMNCj4gPiAr
DQo+ID4gK2NvbmZpZyBORVRfVkVORE9SX1NVTlBMVVMNCj4gPiArCXRyaXN0YXRlICJTdW5wbHVz
IER1YWwgMTBNLzEwME0gRXRoZXJuZXQgKHdpdGggTDIgc3dpdGNoKSBkZXZpY2VzIg0KPiA+ICsJ
ZGVwZW5kcyBvbiBFVEhFUk5FVCAmJiBTT0NfU1A3MDIxDQo+ID4gKwlzZWxlY3QgUEhZTElCDQo+
ID4gKwlzZWxlY3QgUElOQ1RSTF9TUFBDVEwNCj4gPiArCXNlbGVjdCBDT01NT05fQ0xLX1NQNzAy
MQ0KPiA+ICsJc2VsZWN0IFJFU0VUX1NVTlBMVVMNCj4gPiArCXNlbGVjdCBOVk1FTV9TVU5QTFVT
X09DT1RQDQo+ID4gKwloZWxwDQo+ID4gKwkgIElmIHlvdSBoYXZlIFN1bnBsdXMgZHVhbCAxME0v
MTAwTSBFdGhlcm5ldCAod2l0aCBMMiBzd2l0Y2gpDQo+ID4gKwkgIGRldmljZXMsIHNheSBZLg0K
PiA+ICsJICBUaGUgbmV0d29yayBkZXZpY2Ugc3VwcG9ydHMgZHVhbCAxME0vMTAwTSBFdGhlcm5l
dCBpbnRlcmZhY2VzLA0KPiA+ICsJICBvciBvbmUgMTAvMTAwTSBFdGhlcm5ldCBpbnRlcmZhY2Ug
d2l0aCB0d28gTEFOIHBvcnRzLg0KPiA+ICsJICBUbyBjb21waWxlIHRoaXMgZHJpdmVyIGFzIGEg
bW9kdWxlLCBjaG9vc2UgTSBoZXJlLiAgVGhlIG1vZHVsZQ0KPiA+ICsJICB3aWxsIGJlIGNhbGxl
ZCBzcF9sMnN3Lg0KPiANCj4gUGxlYXNlIHVzZSBORVRfVkVORE9SX1NVTlBMVVMgaW4gdGhlIHNh
bWUgd2F5IHRoYXQgb3RoZXINCj4gTkVUX1ZFTkRPUl93eXh6IGtjb25maWcgc3ltYm9scyBhcmUg
dXNlZC4gSXQgc2hvdWxkIGp1c3QgZW5hYmxlIG9yDQo+IGRpc2FibGUgYW55IHNwZWNpZmljIGRl
dmljZSBkcml2ZXJzIHVuZGVyIGl0Lg0KPiANCj4gDQo+IC0tDQo+IH5SYW5keQ0KDQpJIGxvb2tl
ZCB1cCBLY29uZmlnIGZpbGUgb2Ygb3RoZXIgdmVuZG9ycywgYnV0IG5vdCBzdXJlIHdoYXQgSSBz
aG91bGQgZG8uDQpEbyBJIG5lZWQgdG8gbW9kaWZ5IEtjb25maWcgZmlsZSBpbiB0aGUgZm9ybSBh
cyBzaG93biBiZWxvdz8NCg0KIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KIw0K
IyBTdW5wbHVzIGRldmljZSBjb25maWd1cmF0aW9uDQojDQoNCmNvbmZpZyBORVRfVkVORE9SX1NV
TlBMVVMNCglib29sICJTdW5wbHVzIGRldmljZXMiDQoJZGVmYXVsdCB5DQoJZGVwZW5kcyBvbiBB
UkNIX1NVTlBMVVMNCgktLS1oZWxwLS0tDQoJICBJZiB5b3UgaGF2ZSBhIG5ldHdvcmsgKEV0aGVy
bmV0KSBjYXJkIGJlbG9uZ2luZyB0byB0aGlzDQoJICBjbGFzcywgc2F5IFkgaGVyZS4NCg0KCSAg
Tm90ZSB0aGF0IHRoZSBhbnN3ZXIgdG8gdGhpcyBxdWVzdGlvbiBkb2Vzbid0IGRpcmVjdGx5DQoJ
ICBhZmZlY3QgdGhlIGtlcm5lbDogc2F5aW5nIE4gd2lsbCBqdXN0IGNhdXNlIHRoZSBjb25maWd1
cmF0b3INCgkgIHRvIHNraXAgYWxsIHRoZSBxdWVzdGlvbnMgYWJvdXQgU3VucGx1cyBjYXJkcy4g
SWYgeW91IHNheSBZLA0KCSAgeW91IHdpbGwgYmUgYXNrZWQgZm9yIHlvdXIgc3BlY2lmaWMgY2Fy
ZCBpbiB0aGUgZm9sbG93aW5nDQoJICBxdWVzdGlvbnMuDQoNCmlmIE5FVF9WRU5ET1JfU1VOUExV
Uw0KDQpjb25maWcgU1A3MDIxX0VNQUMNCgl0cmlzdGF0ZSAiU3VucGx1cyBEdWFsIDEwTS8xMDBN
IEV0aGVybmV0ICh3aXRoIEwyIHN3aXRjaCkgZGV2aWNlcyINCglkZXBlbmRzIG9uIEVUSEVSTkVU
ICYmIFNPQ19TUDcwMjENCglzZWxlY3QgUEhZTElCDQoJc2VsZWN0IFBJTkNUUkxfU1BQQ1RMDQoJ
c2VsZWN0IENPTU1PTl9DTEtfU1A3MDIxDQoJc2VsZWN0IFJFU0VUX1NVTlBMVVMNCglzZWxlY3Qg
TlZNRU1fU1VOUExVU19PQ09UUA0KCWhlbHANCgkgIElmIHlvdSBoYXZlIFN1bnBsdXMgZHVhbCAx
ME0vMTAwTSBFdGhlcm5ldCAod2l0aCBMMiBzd2l0Y2gpDQoJICBkZXZpY2VzLCBzYXkgWS4NCgkg
IFRoZSBuZXR3b3JrIGRldmljZSBzdXBwb3J0cyBkdWFsIDEwTS8xMDBNIEV0aGVybmV0IGludGVy
ZmFjZXMsDQoJICBvciBvbmUgMTAvMTAwTSBFdGhlcm5ldCBpbnRlcmZhY2Ugd2l0aCB0d28gTEFO
IHBvcnRzLg0KCSAgVG8gY29tcGlsZSB0aGlzIGRyaXZlciBhcyBhIG1vZHVsZSwgY2hvb3NlIE0g
aGVyZS4gIFRoZSBtb2R1bGUNCgkgIHdpbGwgYmUgY2FsbGVkIHNwX2wyc3cuDQoNCmVuZGlmICMg
TkVUX1ZFTkRPUl9TVU5QTFVTDQoNCkJlc3QgcmVnYXJkcywNCldlbGxzDQo=
