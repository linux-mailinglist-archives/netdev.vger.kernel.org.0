Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A290B79B3
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389490AbfISMqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:46:34 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2422 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387520AbfISMqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 08:46:34 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 05307FA15F673BD8CFC2;
        Thu, 19 Sep 2019 20:46:32 +0800 (CST)
Received: from dggeme701-chm.china.huawei.com (10.1.199.97) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 19 Sep 2019 20:46:31 +0800
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme701-chm.china.huawei.com (10.1.199.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 19 Sep 2019 20:46:31 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1713.004;
 Thu, 19 Sep 2019 20:46:31 +0800
From:   "zhangsha (A)" <zhangsha.zhang@huawei.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        "zaharov@selectel.ru" <zaharov@selectel.ru>
CC:     "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yuehaibing <yuehaibing@huawei.com>,
        hunongda <hunongda@huawei.com>,
        "Chenzhendong (alex)" <alex.chen@huawei.com>
Subject: RE: [PATCH v3] bonding: force enable lacp port after link state
 recovery for 802.3ad
Thread-Topic: [PATCH v3] bonding: force enable lacp port after link state
 recovery for 802.3ad
Thread-Index: AQHVbiHhj1lgrT2osES7x4pU2JseVqcxaH3AgAC46oCAAMB2EA==
Date:   Thu, 19 Sep 2019 12:46:31 +0000
Message-ID: <e9a3d1748f0641ebb2423d2121123ff3@huawei.com>
References: <20190918130620.8556-1-zhangsha.zhang@huawei.com>
 <e333c8d2f3624a898a378eb1073f5f29@huawei.com> <10098.1568880711@nyx>
In-Reply-To: <10098.1568880711@nyx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.220.209]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmF5IFZvc2J1cmdoIFtt
YWlsdG86amF5LnZvc2J1cmdoQGNhbm9uaWNhbC5jb21dDQo+IFNlbnQ6IDIwMTnlubQ55pyIMTnm
l6UgMTY6MTINCj4gVG86IHpoYW5nc2hhIChBKSA8emhhbmdzaGEuemhhbmdAaHVhd2VpLmNvbT4N
Cj4gQ2M6IHZmYWxpY29AZ21haWwuY29tOyBhbmR5QGdyZXlob3VzZS5uZXQ7IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IHl1ZWhhaWJpbmcNCj4gPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT47IGh1bm9uZ2Rh
IDxodW5vbmdkYUBodWF3ZWkuY29tPjsNCj4gQ2hlbnpoZW5kb25nIChhbGV4KSA8YWxleC5jaGVu
QGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjNdIGJvbmRpbmc6IGZvcmNlIGVu
YWJsZSBsYWNwIHBvcnQgYWZ0ZXIgbGluayBzdGF0ZQ0KPiByZWNvdmVyeSBmb3IgODAyLjNhZA0K
PiANCj4gemhhbmdzaGEgKEEpIDx6aGFuZ3NoYS56aGFuZ0BodWF3ZWkuY29tPiB3cm90ZToNCj4g
DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IHpoYW5nc2hhIChB
KQ0KPiA+PiBTZW50OiAyMDE55bm0OeaciDE45pelIDIxOjA2DQo+ID4+IFRvOiBqYXkudm9zYnVy
Z2hAY2Fub25pY2FsLmNvbTsgdmZhbGljb0BnbWFpbC5jb207DQo+ID4+IGFuZHlAZ3JleWhvdXNl
Lm5ldDsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gPj4g
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgeXVlaGFpYmluZyA8eXVlaGFpYmluZ0BodWF3
ZWkuY29tPjsNCj4gPj4gaHVub25nZGEgPGh1bm9uZ2RhQGh1YXdlaS5jb20+OyBDaGVuemhlbmRv
bmcgKGFsZXgpDQo+ID4+IDxhbGV4LmNoZW5AaHVhd2VpLmNvbT47IHpoYW5nc2hhIChBKSA8emhh
bmdzaGEuemhhbmdAaHVhd2VpLmNvbT4NCj4gPj4gU3ViamVjdDogW1BBVENIIHYzXSBib25kaW5n
OiBmb3JjZSBlbmFibGUgbGFjcCBwb3J0IGFmdGVyIGxpbmsgc3RhdGUNCj4gPj4gcmVjb3Zlcnkg
Zm9yIDgwMi4zYWQNCj4gPj4NCj4gPj4gRnJvbTogU2hhIFpoYW5nIDx6aGFuZ3NoYS56aGFuZ0Bo
dWF3ZWkuY29tPg0KPiA+Pg0KPiA+PiBBZnRlciB0aGUgY29tbWl0IDMzNDAzMTIxOWE4NCAoImJv
bmRpbmcvODAyLjNhZDogZml4IHNsYXZlIGxpbmsNCj4gPj4gaW5pdGlhbGl6YXRpb24gdHJhbnNp
dGlvbiBzdGF0ZXMiKSBtZXJnZWQsIHRoZSBzbGF2ZSdzIGxpbmsgc3RhdHVzDQo+ID4+IHdpbGwg
YmUgY2hhbmdlZCB0byBCT05EX0xJTktfRkFJTCBmcm9tIEJPTkRfTElOS19ET1dOIGluIHRoZQ0K
PiBmb2xsb3dpbmcgc2NlbmFyaW86DQo+ID4+IC0gRHJpdmVyIHJlcG9ydHMgbG9zcyBvZiBjYXJy
aWVyIGFuZA0KPiA+PiAgIGJvbmRpbmcgZHJpdmVyIHJlY2VpdmVzIE5FVERFVl9ET1dOIG5vdGlm
aWVyDQo+ID4+IC0gc2xhdmUncyBkdXBsZXggYW5kIHNwZWVkIGlzIHplcm9kIGFuZA0KPiA+PiAg
IGl0cyBwb3J0LT5pc19lbmFibGVkIGlzIGNsZWFyZCB0byAnZmFsc2UnOw0KPiA+PiAtIERyaXZl
ciByZXBvcnRzIGxpbmsgcmVjb3ZlcnkgYW5kDQo+ID4+ICAgYm9uZGluZyBkcml2ZXIgcmVjZWl2
ZXMgTkVUREVWX1VQIG5vdGlmaWVyOw0KPiA+PiAtIElmIHNwZWVkL2R1cGxleCBnZXR0aW5nIGZh
aWxlZCBoZXJlLCB0aGUgbGluayBzdGF0dXMNCj4gPj4gICB3aWxsIGJlIGNoYW5nZWQgdG8gQk9O
RF9MSU5LX0ZBSUw7DQo+ID4+IC0gVGhlIE1JSSBtb25vdG9yIGxhdGVyIHJlY292ZXIgdGhlIHNs
YXZlJ3Mgc3BlZWQvZHVwbGV4DQo+ID4+ICAgYW5kIHNldCBsaW5rIHN0YXR1cyB0byBCT05EX0xJ
TktfVVAsIGJ1dCByZW1haW5zDQo+ID4+ICAgdGhlICdwb3J0LT5pc19lbmFibGVkJyB0byAnZmFs
c2UnLg0KPiA+Pg0KPiA+PiBJbiB0aGlzIHNjZW5hcmlvLCB0aGUgbGFjcCBwb3J0IHdpbGwgbm90
IGJlIGVuYWJsZWQgZXZlbiBpdHMgc3BlZWQNCj4gPj4gYW5kIGR1cGxleCBhcmUgdmFsaWQuIFRo
ZSBib25kIHdpbGwgbm90IHNlbmQgTEFDUERVJ3MsIGFuZCBpdHMgc3RhdGUgaXMNCj4gJ0FEX1NU
QVRFX0RFRkFVTFRFRCcNCj4gPj4gZm9yZXZlci4gVGhlIHNpbXBsZXN0IGZpeCBJIHRoaW5rIGlz
IHRvIGNhbGwNCj4gPj4gYm9uZF8zYWRfaGFuZGxlX2xpbmtfY2hhbmdlKCkgaW4gYm9uZF9taWlt
b25fY29tbWl0LCB0aGlzIGZ1bmN0aW9uDQo+ID4+IGNhbiBlbmFibGUgbGFjcCBhZnRlciBwb3J0
IHNsYXZlIHNwZWVkIGNoZWNrLg0KPiA+PiBBcyBlbmFibGVkLCB0aGUgbGFjcCBwb3J0IGNhbiBy
dW4gaXRzIHN0YXRlIG1hY2hpbmUgbm9ybWFsbHkgYWZ0ZXIgbGluaw0KPiByZWNvdmVyeS4NCj4g
Pj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogU2hhIFpoYW5nIDx6aGFuZ3NoYS56aGFuZ0BodWF3ZWku
Y29tPg0KPiA+PiAtLS0NCj4gPj4gIGRyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMgfCAz
ICsrLQ0KPiA+PiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPiA+Pg0KPiA+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX21haW4u
Yw0KPiA+PiBiL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMgaW5kZXggOTMxZDlkOS4u
NzYzMjRhNSAxMDA2NDQNCj4gPj4gLS0tIGEvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX21haW4u
Yw0KPiA+PiArKysgYi9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfbWFpbi5jDQo+ID4+IEBAIC0y
MjA2LDcgKzIyMDYsOCBAQCBzdGF0aWMgdm9pZCBib25kX21paW1vbl9jb21taXQoc3RydWN0IGJv
bmRpbmcNCj4gPj4gKmJvbmQpDQo+ID4+ICAJCQkgKi8NCj4gPj4gIAkJCWlmIChCT05EX01PREUo
Ym9uZCkgPT0gQk9ORF9NT0RFXzgwMjNBRCAmJg0KPiA+PiAgCQkJICAgIHNsYXZlLT5saW5rID09
IEJPTkRfTElOS19VUCkNCj4gPj4gLQ0KPiA+PiAJYm9uZF8zYWRfYWRhcHRlcl9zcGVlZF9kdXBs
ZXhfY2hhbmdlZChzbGF2ZSk7DQo+ID4+ICsJCQkJYm9uZF8zYWRfaGFuZGxlX2xpbmtfY2hhbmdl
KHNsYXZlLA0KPiA+PiArCQkJCQkJCSAgICBCT05EX0xJTktfVVApOw0KPiA+PiAgCQkJY29udGlu
dWU7DQo+ID4+DQo+ID4+ICAJCWNhc2UgQk9ORF9MSU5LX1VQOg0KPiA+DQo+ID5IaSwgRGF2aWQs
DQo+ID5JIGhhdmUgcmVwbGllZCB5b3VyIGVtYWlsIGZvciBhIHdoaWxlLCAgSSBndWVzcyB5b3Ug
bWF5IG1pc3MgbXkgZW1haWwsIHNvIEkNCj4gcmVzZW5kIGl0Lg0KPiA+VGhlIGZvbGxvd2luZyBs
aW5rIGFkZHJlc3MgaXMgdGhlIGxhc3QgZW1haWwsIHBsZWFzZSByZXZpZXcgdGhlIG5ldyBvbmUg
YWdhaW4sDQo+IHRoYW5rIHlvdS4NCj4gPmh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcGF0
Y2gvMTE1MTkxNS8NCj4gPg0KPiA+TGFzdCB0aW1lLCB5b3UgZG91YnRlZCB0aGlzIGlzIGEgZHJp
dmVyIHNwZWNpZmljIHByb2JsZW0sIEkgcHJlZmVyIHRvDQo+ID5iZWxpZXZlIGl0J3Mgbm90IGJl
Y2F1c2UgSSBmaW5kIHRoZSBjb21taXQgNGQyYzBjZGEsIGl0cyBsb2cgc2F5cyAiDQo+ID5Tb21l
IE5JQyBkcml2ZXJzIGRvbid0IGhhdmUgY29ycmVjdCBzcGVlZC9kdXBsZXggc2V0dGluZ3MgYXQg
dGhlIHRpbWUNCj4gPnRoZXkgc2VuZCBORVRERVZfVVAgbm90aWZpY2F0aW9uIC4uLiIuDQo+ID4N
Cj4gPkFueXdheSwgSSB0aGluayB0aGUgbGFjcCBzdGF0dXMgc2hvdWxkIGJlIGZpeGVkIGNvcnJl
Y3RseSwgc2luY2UNCj4gPmxpbmstbW9uaXRvcmluZyAobWlpbW9uKSBzZXQgU1BFRUQvRFVQTEVY
IHJpZ2h0IGhlcmUuDQo+IA0KPiAJSSBzdXNwZWN0IHRoaXMgaXMgZ29pbmcgdG8gYmUgcmVsYXRl
ZCB0byB0aGUgY29uY3VycmVudCBkaXNjdXNzaW9uIHdpdGgNCj4gQWxla3NlaSwgYW5kIHdvdWxk
IGxpa2UgdG8gc2VlIHRoZSBpbnN0cnVtZW50YXRpb24gcmVzdWx0cyBmcm9tIGhpcyB0ZXN0cyBi
ZWZvcmUNCj4gYWRkaW5nIGFub3RoZXIgY2hhbmdlIHRvIGF0dGVtcHQgdG8gcmVzb2x2ZSB0aGlz
Lg0KPiANCj4gCUFsc28sIHdoYXQgZGV2aWNlIGFyZSB5b3UgdXNpbmcgZm9yIHlvdXIgdGVzdGlu
ZywgYW5kIGFyZSB5b3UgYWJsZSB0bw0KPiBydW4gdGhlIGluc3RydW1lbnRhdGlvbiBwYXRjaCB0
aGF0IEkgcHJvdmlkZWQgdG8gQWxla3NlaSBhbmQgcHJvdmlkZSBpdHMgcmVzdWx0cz8NCj4gCQ0K
PiAJLUoNCj4gDQoNClllcywgSSB0aGluayBpdCdzIHRoZSBzYW1lIHByb2JsZW0uDQpJIGFtIHVz
aW5nIGEgSHVhd2VpIGhpbmljIGNhcmQgd2l0aCBrZXJuZWwgNC4xOSBhbmQgZ290IHRoZSBzYW1l
IG1lc3NhZ2UgYW5kIHRoZQ0Kd2VpcmQgc3lzdGVtIG1hYyAiMDA6MDA6MDA6MDA6MDA6MDAiOg0K
Imxpbmsgc3RhdHVzIGRlZmluaXRlbHkgZG93biBmb3IgaW50ZXJmYWNlIGV0aDYsIGRpc2FibGlu
ZyBpdA0KIGxpbmsgc3RhdHVzIHVwIGFnYWluIGFmdGVyIDAgbXMgZm9yIGludGVyZmFjZSBldGg2
Ig0KDQpJIHdpbGwgcnVuIHlvdXIgaW5zdHJ1bWVudGF0aW9uIHBhdGNoLCBidXQgbWF5YmUgSSBu
ZWVkIG1vcmUgdGltZXMuDQpJbiBmYWN0LCBJIGhhdmUgdHJpZWQgdG8gcmVwcm9kdWNlIHRoZSBw
cm9ibGVtIGZvciB0aG91c2FuZHMgb2YgdGltZXMsIGJ1dCBuZXZlciBzdWNjZWVkZWQuDQoNCj4g
LS0tDQo+IAktSmF5IFZvc2J1cmdoLCBqYXkudm9zYnVyZ2hAY2Fub25pY2FsLmNvbQ0K
