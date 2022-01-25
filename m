Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAA749BE48
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiAYWPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:15:08 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:24750 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233594AbiAYWPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:15:07 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-286-eH9ObO7ZPQOXkYjImAriww-1; Tue, 25 Jan 2022 22:15:00 +0000
X-MC-Unique: eH9ObO7ZPQOXkYjImAriww-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 25 Jan 2022 22:14:58 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 25 Jan 2022 22:14:58 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Yury Norov' <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Joe Perches <joe@perches.com>,
        "Dennis Zhou" <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        "Nicholas Piggin" <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 10/54] net: ethernet: replace bitmap_weight with
 bitmap_empty for qlogic
Thread-Topic: [PATCH 10/54] net: ethernet: replace bitmap_weight with
 bitmap_empty for qlogic
Thread-Index: AQHYEi/xbFZei8h0ukG4wQKpQdgkw6x0TR0w
Date:   Tue, 25 Jan 2022 22:14:58 +0000
Message-ID: <58c222c15b2d43689f43d31afb5cb914@AcuMS.aculab.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
 <20220123183925.1052919-11-yury.norov@gmail.com>
 <Ye6bUC1GyLLUV37p@smile.fi.intel.com>
 <CAAH8bW_u6oNOkMsA_jRyWFHkzjMi0CB7gXmvLYAdjNMSqrrY7w@mail.gmail.com>
In-Reply-To: <CAAH8bW_u6oNOkMsA_jRyWFHkzjMi0CB7gXmvLYAdjNMSqrrY7w@mail.gmail.com>
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

RnJvbTogWXVyeSBOb3Jvdg0KPiBTZW50OiAyNSBKYW51YXJ5IDIwMjIgMjE6MTANCj4gT24gTW9u
LCBKYW4gMjQsIDIwMjIgYXQgNDoyOSBBTSBBbmR5IFNoZXZjaGVua28NCj4gPGFuZHJpeS5zaGV2
Y2hlbmtvQGxpbnV4LmludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiBTdW4sIEphbiAyMywg
MjAyMiBhdCAxMDozODo0MUFNIC0wODAwLCBZdXJ5IE5vcm92IHdyb3RlOg0KPiA+ID4gcWxvZ2lj
L3FlZCBjb2RlIGNhbGxzIGJpdG1hcF93ZWlnaHQoKSB0byBjaGVjayBpZiBhbnkgYml0IG9mIGEg
Z2l2ZW4NCj4gPiA+IGJpdG1hcCBpcyBzZXQuIEl0J3MgYmV0dGVyIHRvIHVzZSBiaXRtYXBfZW1w
dHkoKSBpbiB0aGF0IGNhc2UgYmVjYXVzZQ0KPiA+ID4gYml0bWFwX2VtcHR5KCkgc3RvcHMgdHJh
dmVyc2luZyB0aGUgYml0bWFwIGFzIHNvb24gYXMgaXQgZmluZHMgZmlyc3QNCj4gPiA+IHNldCBi
aXQsIHdoaWxlIGJpdG1hcF93ZWlnaHQoKSBjb3VudHMgYWxsIGJpdHMgdW5jb25kaXRpb25hbGx5
Lg0KPiA+DQo+ID4gPiAtICAgICAgICAgICAgIGlmIChiaXRtYXBfd2VpZ2h0KCh1bnNpZ25lZCBs
b25nICopJnBtYXBbaXRlbV0sIDY0ICogOCkpDQo+ID4gPiArICAgICAgICAgICAgIGlmICghYml0
bWFwX2VtcHR5KCh1bnNpZ25lZCBsb25nICopJnBtYXBbaXRlbV0sIDY0ICogOCkpDQo+ID4NCj4g
PiA+IC0gICAgICAgICAoYml0bWFwX3dlaWdodCgodW5zaWduZWQgbG9uZyAqKSZwbWFwW2l0ZW1d
LA0KPiA+ID4gKyAgICAgICAgICghYml0bWFwX2VtcHR5KCh1bnNpZ25lZCBsb25nICopJnBtYXBb
aXRlbV0sDQo+ID4NCj4gPiBTaWRlIG5vdGUsIHRoZXNlIGNhc3RpbmdzIHJlbWluZHMgbWUgcHJl
dmlvdXMgZGlzY3Vzc2lvbiBhbmQgSSdtIHdvbmRlcmluZw0KPiA+IGlmIHlvdSBoYXZlIHRoaXMg
a2luZCBvZiBwb3RlbnRpYWxseSBwcm9ibGVtYXRpYyBwbGFjZXMgaW4geW91ciBUT0RPIGFzDQo+
ID4gc3ViamVjdCB0byBmaXguDQo+IA0KPiBJbiB0aGUgZGlzY3Vzc2lvbiB5b3UgbWVudGlvbmVk
IGFib3ZlLCB0aGUgdTMyKiB3YXMgY2FzdCB0byB1NjQqLA0KPiB3aGljaCBpcyB3cm9uZy4gVGhl
IGNvZGUNCj4gaGVyZSBpcyBzYWZlIGJlY2F1c2UgaW4gdGhlIHdvcnN0IGNhc2UsIGl0IGNhc3Rz
IHU2NCogdG8gdTMyKi4gVGhpcw0KPiB3b3VsZCBiZSBPSyB3cnQNCj4gIC1XZXJyb3I9YXJyYXkt
Ym91bmRzLg0KPiANCj4gVGhlIGZ1bmN0aW9uIGl0c2VsZiBsb29rcyBsaWtlIGRvaW5nIHRoaXMg
dW5zaWduZWQgbG9uZyA8LT4gdTY0DQo+IGNvbnZlcnNpb25zIGp1c3QgZm9yIHByaW50aW5nDQo+
IHB1cnBvc2UuIEknbSBub3QgYSBxbG9naWMgZXhwZXJ0LCBzbyBsZXQncyB3YWl0IHdoYXQgcGVv
cGxlIHNheT8NCg0KSXQnbGwgYmUgd3Jvbmcgb24gQkUgc3lzdGVtcy4NCllvdSBqdXN0IGNhbid0
IGNhc3QgdGhlIGFyZ3VtZW50IGl0IGhhcyB0byBiZSBsb25nW10uDQoNCglEYXZpZA0KDQotDQpS
ZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWls
dG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMp
DQo=

