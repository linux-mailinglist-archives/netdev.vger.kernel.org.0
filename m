Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F251329EE02
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgJ2OTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:19:32 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:27455 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725300AbgJ2OTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 10:19:32 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-166-iBl7a8ITPDy5owCvVqa8cg-1; Thu, 29 Oct 2020 14:19:28 +0000
X-MC-Unique: iBl7a8ITPDy5owCvVqa8cg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 29 Oct 2020 14:19:27 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 29 Oct 2020 14:19:27 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andrew Lunn' <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: RE: [PATCH net-next 2/2] net: rose: Escape trigraph to fix warning
 with W=1
Thread-Topic: [PATCH net-next 2/2] net: rose: Escape trigraph to fix warning
 with W=1
Thread-Index: AQHWrYhh0XmwM4Ib50eEMfDvUoESGqmuoTkg
Date:   Thu, 29 Oct 2020 14:19:27 +0000
Message-ID: <294bfee65035493fac1e2643a5e360d5@AcuMS.aculab.com>
References: <20201028002235.928999-1-andrew@lunn.ch>
 <20201028002235.928999-3-andrew@lunn.ch>
In-Reply-To: <20201028002235.928999-3-andrew@lunn.ch>
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

RnJvbTogQW5kcmV3IEx1bm4NCj4gU2VudDogMjggT2N0b2JlciAyMDIwIDAwOjIzDQo+IA0KPiBu
ZXQvcm9zZS9hZl9yb3NlLmM6IEluIGZ1bmN0aW9uIOKAmHJvc2VfaW5mb19zaG934oCZOg0KPiBu
ZXQvcm9zZS9hZl9yb3NlLmM6MTQxMzoyMDogd2FybmluZzogdHJpZ3JhcGggPz8tIGlnbm9yZWQs
IHVzZSAtdHJpZ3JhcGhzIHRvIGVuYWJsZSBbLVd0cmlncmFwaHNdDQo+ICAxNDEzIHwgICAgY2Fs
bHNpZ24gPSAiPz8/Pz8/LT8iOw0KPiANCj4gPz8tIGlzIGEgdHJpZ3JhcGgsIGFuZCBzaG91bGQg
YmUgcmVwbGFjZWQgYnkgYSDLnCBieSB0aGUNCj4gY29tcGlsZXIuIEhvd2V2ZXIsIHRyaWdyYXBo
cyBhcmUgYmVpbmcgaWdub3JlZCBpbiB0aGUgYnVpbGQuIEZpeCB0aGUNCj4gd2FybmluZyBieSBl
c2NhcGluZyB0aGUgPz8gcHJlZml4IG9mIGEgdHJpZ3JhcGguDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+IC0tLQ0KPiAgbmV0L3Jvc2UvYWZfcm9z
ZS5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L3Jvc2UvYWZfcm9zZS5jIGIvbmV0L3Jvc2UvYWZf
cm9zZS5jDQo+IGluZGV4IGNmN2Q5NzRlMGY2MS4uMmMyOTc4MzRkMjY4IDEwMDY0NA0KPiAtLS0g
YS9uZXQvcm9zZS9hZl9yb3NlLmMNCj4gKysrIGIvbmV0L3Jvc2UvYWZfcm9zZS5jDQo+IEBAIC0x
NDEwLDcgKzE0MTAsNyBAQCBzdGF0aWMgaW50IHJvc2VfaW5mb19zaG93KHN0cnVjdCBzZXFfZmls
ZSAqc2VxLCB2b2lkICp2KQ0KPiAgCQkJICAgYXgyYXNjKGJ1ZiwgJnJvc2UtPmRlc3RfY2FsbCkp
Ow0KPiANCj4gIAkJaWYgKGF4MjVjbXAoJnJvc2UtPnNvdXJjZV9jYWxsLCAmbnVsbF9heDI1X2Fk
ZHJlc3MpID09IDApDQo+IC0JCQljYWxsc2lnbiA9ICI/Pz8/Pz8tPyI7DQo+ICsJCQljYWxsc2ln
biA9ICI/Pz8/XD9cPy0/IjsNCg0KSSB0aGluayBJJ2QganVzdCBzcGxpdCB0aGUgc3RyaW5nLCBl
ZzogIj8/Pz8/IiAiLT8iLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

