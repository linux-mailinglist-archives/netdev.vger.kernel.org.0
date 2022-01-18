Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DBE4925EF
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbiARMpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 07:45:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:25204 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237803AbiARMpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 07:45:00 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-230-d_QmobujNXmDT8znvK2f3A-1; Tue, 18 Jan 2022 12:44:58 +0000
X-MC-Unique: d_QmobujNXmDT8znvK2f3A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 18 Jan 2022 12:44:57 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 18 Jan 2022 12:44:57 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jason A. Donenfeld'" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wireguard@lists.zx2c4.com" <wireguard@lists.zx2c4.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jeanphilippe.aumasson@gmail.com" <jeanphilippe.aumasson@gmail.com>,
        "ardb@kernel.org" <ardb@kernel.org>
Subject: RE: [PATCH crypto v3 0/2] reduce code size from blake2s on m68k and
 other small platforms
Thread-Topic: [PATCH crypto v3 0/2] reduce code size from blake2s on m68k and
 other small platforms
Thread-Index: AQHYDGCZ1hhaA5g8jUud5pQLYuQbPqxotdeQ
Date:   Tue, 18 Jan 2022 12:44:57 +0000
Message-ID: <ad862f5ad048404ab452e25bba074824@AcuMS.aculab.com>
References: <CAHmME9rxdksVZkN4DF_GabsEPrSDrKbo1cVQs77B_s-e2jZ64A@mail.gmail.com>
 <YeZhVGczxcBl0sI9@gondor.apana.org.au>
 <CAHmME9ogAW0o2PReNtsD+fFgwp28q2kP7WADtbd8kA7GsnKBpg@mail.gmail.com>
In-Reply-To: <CAHmME9ogAW0o2PReNtsD+fFgwp28q2kP7WADtbd8kA7GsnKBpg@mail.gmail.com>
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

RnJvbTogSmFzb24gQS4gRG9uZW5mZWxkDQo+IFNlbnQ6IDE4IEphbnVhcnkgMjAyMiAxMTo0Mw0K
PiANCj4gT24gMS8xOC8yMiwgSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1
PiB3cm90ZToNCj4gPiBBcyB0aGUgcGF0Y2hlcyB0aGF0IHRyaWdnZXJlZCB0aGlzIHdlcmVuJ3Qg
cGFydCBvZiB0aGUgY3J5cHRvDQo+ID4gdHJlZSwgdGhpcyB3aWxsIGhhdmUgdG8gZ28gdGhyb3Vn
aCB0aGUgcmFuZG9tIHRyZWUgaWYgeW91IHdhbnQNCj4gPiB0aGVtIGZvciA1LjE3Lg0KPiANCj4g
U3VyZSwgd2lsbCBkby4NCg0KSSd2ZSByYW1tZWQgdGhlIGNvZGUgdGhyb3VnaCBnb2Rib2x0Li4u
IGh0dHBzOi8vZ29kYm9sdC5vcmcvei9XdjY0ejl6RzgNCg0KU29tZSB0aGluZ3MgSSd2ZSBub3Rp
Y2VkOw0KDQoxKSBUaGVyZSBpcyBubyBwb2ludCBoYXZpbmcgYWxsIHRoZSBpbmxpbmUgZnVuY3Rp
b25zLg0KICAgRmFyIGJldHRlciB0byBoYXZlIHJlYWwgZnVuY3Rpb25zIHRvIGRvIHRoZSB3b3Jr
Lg0KICAgR2l2ZW4gdGhlIGNvc3Qgb2YgaGFzaGluZyA2NCBieXRlcyBvZiBkYXRhIHRoZSBleHRy
YQ0KICAgZnVuY3Rpb24gY2FsbCB3b24ndCBtYXR0ZXIuDQogICBJbmRlZWQgZm9yIHJlcGVhdGVk
IGNhbGxzIGl0IHdpbGwgaGVscCBiZWNhdXNlIHRoZSByZXF1aXJlZA0KICAgY29kZSB3aWxsIGJl
IGluIHRoZSBJLWNhY2hlLg0KDQoyKSBUaGUgY29tcGlsZXMgSSB0cmllZCBkbyBtYW5hZ2UgdG8g
cmVtb3ZlIHRoZSBibGFrZTJfc2lnbWFbXVtdDQogICB3aGVuIHVucm9sbGluZyBldmVyeXRoaW5n
IC0gd2hpY2ggaXMgYSBzbGlnaHQgZ2FpbiBmb3IgdGhlIGZ1bGwNCiAgIHVucm9sbC4gQnV0IEkg
ZG91YnQgaXQgaXMgdGhhdCBzaWduaWZpY2FudCBpZiB0aGUgYWNjZXNzIGNhbg0KICAgZ2V0IHNl
bnNpYmx5IG9wdGltaXNlZC4NCiAgIEZvciBub24teDg2IHRoYXQgbWlnaHQgcmVxdWlyZSBhbGwg
dGhlIHZhbHVlcyBieSBtdWx0aXBsaWVkIGJ5IDQuDQoNCjMpIEFsdGhvdWdoIEcoKSBpcyBhIG1h
c3NpdmUgcmVnaXN0ZXIgZGVwZW5kZW5jeSBjaGFpbiB0aGUgY29tcGlsZXINCiAgIGtub3dzIHRo
YXQgRygsWzAtM10sKSBhcmUgaW5kZXBlbmRlbnQgYW5kIGNhbiBleGVjdXRlIGluIHBhcmFsbGVs
Lg0KICAgVGhpcyBkb2VzIGhlbHAgZXhlY3V0aW9uIHRpbWUgb24gbXVsdGktaXNzdWUgY3B1IChs
aWtlIHg4NikuDQogICBXaXRoIGNhcmUgaXQgb3VnaHQgdG8gYmUgcG9zc2libGUgdG8gdXNlIHRo
ZSBzYW1lIGNvZGUgZm9yIEcoLFs0LTddLCkNCiAgIHdpdGhvdXQgc3RvcHBpbmcgdGhlIGNvbXBp
bGVyIGludGVybGVhdmluZyBhbGwgdGhlIGluc3RydWN0aW9ucy4NCg0KNCkgSSBzdHJvbmdseSBz
dXNwZWN0IHRoYXQgdXNpbmcgYSBsb29wIGZvciB0aGUgcm91bmRzIHdpbGwgaGF2ZQ0KICAgbWlu
aW1hbCBpbXBhY3Qgb24gcGVyZm9ybWFuY2UgLSBlc3BlY2lhbGx5IGlmIHRoZSBmaXJzdCBjYWxs
IGlzDQogICAnY29sZCBjYWNoZScuDQogICBCdXQgSSd2ZSBub3QgZ290IHRpbWUgdG8gdGVzdCB0
aGUgY29kZS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJh
bWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0
cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

