Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D293029EED4
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgJ2OyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:54:03 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:31226 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbgJ2OyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 10:54:02 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-305-1ZHTd6FQOZmcpLkExSygcQ-1; Thu, 29 Oct 2020 14:52:53 +0000
X-MC-Unique: 1ZHTd6FQOZmcpLkExSygcQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 29 Oct 2020 14:52:52 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 29 Oct 2020 14:52:52 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrew Lunn' <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: RE: [PATCH net-next 2/2] net: rose: Escape trigraph to fix warning
 with W=1
Thread-Topic: [PATCH net-next 2/2] net: rose: Escape trigraph to fix warning
 with W=1
Thread-Index: AQHWrYhh0XmwM4Ib50eEMfDvUoESGqmuoTkggAAEDYCAAASXkA==
Date:   Thu, 29 Oct 2020 14:52:52 +0000
Message-ID: <2c3145a577f84e96b2ec7be15db90331@AcuMS.aculab.com>
References: <20201028002235.928999-1-andrew@lunn.ch>
 <20201028002235.928999-3-andrew@lunn.ch>
 <294bfee65035493fac1e2643a5e360d5@AcuMS.aculab.com>
 <20201029143121.GN878328@lunn.ch>
In-Reply-To: <20201029143121.GN878328@lunn.ch>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW5kcmV3IEx1bm4NCj4gU2VudDogMjkgT2N0b2JlciAyMDIwIDE0OjMxDQo+IE9uIFRo
dSwgT2N0IDI5LCAyMDIwIGF0IDAyOjE5OjI3UE0gKzAwMDAsIERhdmlkIExhaWdodCB3cm90ZToN
Cj4gPiBGcm9tOiBBbmRyZXcgTHVubg0KPiA+ID4gU2VudDogMjggT2N0b2JlciAyMDIwIDAwOjIz
DQo+ID4gPg0KPiA+ID4gbmV0L3Jvc2UvYWZfcm9zZS5jOiBJbiBmdW5jdGlvbiDigJhyb3NlX2lu
Zm9fc2hvd+KAmToNCj4gPiA+IG5ldC9yb3NlL2FmX3Jvc2UuYzoxNDEzOjIwOiB3YXJuaW5nOiB0
cmlncmFwaCA/Py0gaWdub3JlZCwgdXNlIC10cmlncmFwaHMgdG8gZW5hYmxlIFstV3RyaWdyYXBo
c10NCj4gPiA+ICAxNDEzIHwgICAgY2FsbHNpZ24gPSAiPz8/Pz8/LT8iOw0KPiA+ID4NCj4gPiA+
ID8/LSBpcyBhIHRyaWdyYXBoLCBhbmQgc2hvdWxkIGJlIHJlcGxhY2VkIGJ5IGEgy5wgYnkgdGhl
DQo+ID4gPiBjb21waWxlci4gSG93ZXZlciwgdHJpZ3JhcGhzIGFyZSBiZWluZyBpZ25vcmVkIGlu
IHRoZSBidWlsZC4gRml4IHRoZQ0KPiA+ID4gd2FybmluZyBieSBlc2NhcGluZyB0aGUgPz8gcHJl
Zml4IG9mIGEgdHJpZ3JhcGguDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IEx1
bm4gPGFuZHJld0BsdW5uLmNoPg0KPiA+ID4gLS0tDQo+ID4gPiAgbmV0L3Jvc2UvYWZfcm9zZS5j
IHwgMiArLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9uZXQvcm9zZS9hZl9yb3NlLmMgYi9uZXQv
cm9zZS9hZl9yb3NlLmMNCj4gPiA+IGluZGV4IGNmN2Q5NzRlMGY2MS4uMmMyOTc4MzRkMjY4IDEw
MDY0NA0KPiA+ID4gLS0tIGEvbmV0L3Jvc2UvYWZfcm9zZS5jDQo+ID4gPiArKysgYi9uZXQvcm9z
ZS9hZl9yb3NlLmMNCj4gPiA+IEBAIC0xNDEwLDcgKzE0MTAsNyBAQCBzdGF0aWMgaW50IHJvc2Vf
aW5mb19zaG93KHN0cnVjdCBzZXFfZmlsZSAqc2VxLCB2b2lkICp2KQ0KPiA+ID4gIAkJCSAgIGF4
MmFzYyhidWYsICZyb3NlLT5kZXN0X2NhbGwpKTsNCj4gPiA+DQo+ID4gPiAgCQlpZiAoYXgyNWNt
cCgmcm9zZS0+c291cmNlX2NhbGwsICZudWxsX2F4MjVfYWRkcmVzcykgPT0gMCkNCj4gPiA+IC0J
CQljYWxsc2lnbiA9ICI/Pz8/Pz8tPyI7DQo+ID4gPiArCQkJY2FsbHNpZ24gPSAiPz8/P1w/XD8t
PyI7DQo+ID4NCj4gPiBJIHRoaW5rIEknZCBqdXN0IHNwbGl0IHRoZSBzdHJpbmcsIGVnOiAiPz8/
Pz8iICItPyIuDQo+IA0KPiBIdW1tLiBJIHRoaW5rIHdlIG5lZWQgYSBsYW5ndWFnZSBsYXd5ZXIu
DQo+IA0KPiBEb2VzIGl0IGNvbmNhdGVuYXRlIHRoZSBzdHJpbmdzIGFuZCB0aGVuIGV2YWx1YXRl
IGZvciB0cmlncmFwaHM/IE9yDQo+IGRvZXMgaXQgZXZhbHVhdGUgZm9yIHRyaWdyYXBocywgYW5k
IHRoZW4gY29uY2F0ZW5hdGUgdGhlIHN0cmluZ3M/DQoNCkknbSA5OS45OTk5JSBzdXJlIHRyaWdy
YXBocyBhcmUgZXZhbHVhdGVkIGJlZm9yZSBzdHJpbmcgY29uY2F0ZW5hdGlvbi4NCg0KQWx0aG91
Z2ggdHJpZ3JhcGhzIGFyZSBzdWNoIGEgc3R1cGlkIGlkZWEgSSdkIGJlIHRlbXB0ZWQgdG8ganVz
dA0KdHVybiB0aGUgd2FybmluZyBvZmYuDQpUaGVyZSBpcyBnb29kIHJlYXNvbiB3aHkgdGhleSBh
cmUgaWdub3JlZCBieSBkZWZhdWx0Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

