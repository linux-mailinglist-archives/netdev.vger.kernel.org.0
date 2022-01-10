Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA684897E1
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244939AbiAJLuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:50:24 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:45233 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245003AbiAJLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 06:49:09 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-82-dYFaJeRBNJqGMER5FnAqQg-1; Mon, 10 Jan 2022 11:49:05 +0000
X-MC-Unique: dYFaJeRBNJqGMER5FnAqQg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Mon, 10 Jan 2022 11:49:05 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Mon, 10 Jan 2022 11:49:05 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Eric Dumazet' <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "'tglx@linutronix.de'" <tglx@linutronix.de>,
        "'mingo@redhat.com'" <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        "'dave.hansen@linux.intel.com'" <dave.hansen@linux.intel.com>,
        'X86 ML' <x86@kernel.org>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'alexanderduyck@fb.com'" <alexanderduyck@fb.com>,
        'open list' <linux-kernel@vger.kernel.org>,
        'netdev' <netdev@vger.kernel.org>,
        "'Noah Goldstein'" <goldstein.w.n@gmail.com>
Subject: RE: [PATCH v2] x86/lib: Remove the special case for odd-aligned
 buffers in csum-partial_64.c
Thread-Topic: [PATCH v2] x86/lib: Remove the special case for odd-aligned
 buffers in csum-partial_64.c
Thread-Index: AdgDCwHV1n1J2N5MS6O6mkuVVrK4agDDMGDg
Date:   Mon, 10 Jan 2022 11:49:05 +0000
Message-ID: <74c0e781b1f34071bd617aa60baede06@AcuMS.aculab.com>
References: <e2864e9c5d794c79aa7ee7de4abbfc6d@AcuMS.aculab.com>
In-Reply-To: <e2864e9c5d794c79aa7ee7de4abbfc6d@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDA2IEphbnVhcnkgMjAyMiAxNDo0Ng0KPiANCj4g
VGhlcmUgaXMgbm8gbmVlZCB0byBzcGVjaWFsIGNhc2UgdGhlIHZlcnkgdW51c3VhbCBvZGQtYWxp
Z25lZCBidWZmZXJzLg0KPiBUaGV5IGFyZSBubyB3b3JzZSB0aGFuIDRuKzIgYWxpZ25lZCBidWZm
ZXJzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2aWQgTGFpZ2h0IDxkYXZpZC5sYWlnaHRAYWN1
bGFiLmNvbT4NCj4gQWNrZWQtYnk6IEVyaWMgRHVtYXpldA0KPiAtLS0NCg0KUGluZy4uLg0KVGhp
cyAoYW5kIG15IHR3byBvdGhlciBwYXRjaGVzIGZvciB0aGUgc2FtZSBmaWxlKSBhcmUgaW1wcm92
ZW1lbnRzDQp0byBFcmljJ3MgcmV3cml0ZSBvZiB0aGlzIGNvZGUgdGhhdCBpcyBnb2luZyBpbnRv
IDUuMTcuDQpJdCB3b3VsZCBiZSBuaWNlIHRvIGdldCB0aGVzZSBpbiBhcyB3ZWxsLg0KVGhleSBh
cmUgbGlrZWx5IHRvIGJlIG1lYXN1cmFibGUgKGlmIG1pbm9yKSBwZXJmb3JtYW5jZSBpbXByb3Zl
bWVudHMNCmZvciBjb21tb24gY2FzZXMuDQoNCglEYXZpZA0KDQo+IA0KPiByZXNlbmQgLSB2MSBz
ZWVtcyB0byBoYXZlIGdvdCBsb3N0IDotKQ0KPiANCj4gdjI6IEFsc28gZGVsZXRlIGZyb20zMnRv
MTYoKQ0KPiAgICAgQWRkIGFja2VkLWJ5IGZyb20gRXJpYyAoaGUgc2VudCBvbmUgYXQgc29tZSBw
b2ludCkNCj4gICAgIEZpeCBwb3NzaWJsZSB3aGl0ZXNwYWNlIGVycm9yIGluIHRoZSBsYXN0IGh1
bmsuDQo+IA0KPiBUaGUgcGVuYWx0eSBmb3IgYW55IG1pc2FsaWduZWQgYWNjZXNzIHNlZW1zIHRv
IGJlIG1pbmltYWwuDQo+IE9uIGFuIGk3LTc3MDAgbWlzYWxpZ25lZCBidWZmZXJzIGFkZCAyIG9y
IDMgY2xvY2tzIChpbiAxMTUpIHRvIGEgNTEyIGJ5dGUNCj4gICBjaGVja3N1bS4NCj4gVGhhdCBp
cyBsZXNzIHRoYW4gMSBjbG9jayBmb3IgZWFjaCBjYWNoZSBsaW5lIQ0KPiBUaGF0IGlzIGp1c3Qg
bWVhc3VyaW5nIHRoZSBtYWluIGxvb3Agd2l0aCBhbiBsZmVuY2UgcHJpb3IgdG8gcmRwbWMgdG8N
Cj4gcmVhZCBQRVJGX0NPVU5UX0hXX0NQVV9DWUNMRVMuDQo+IA0KPiAgYXJjaC94ODYvbGliL2Nz
dW0tcGFydGlhbF82NC5jIHwgMjggKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvbGliL2NzdW0tcGFydGlhbF82NC5jIGIvYXJjaC94ODYvbGliL2Nz
dW0tcGFydGlhbF82NC5jDQo+IGluZGV4IDFmOGE4Zjg5NTE3My4uMDYxYjFlZDc0ZDZhIDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3g4Ni9saWIvY3N1bS1wYXJ0aWFsXzY0LmMNCj4gKysrIGIvYXJjaC94
ODYvbGliL2NzdW0tcGFydGlhbF82NC5jDQo+IEBAIC0xMSwxNiArMTEsNiBAQA0KPiAgI2luY2x1
ZGUgPGFzbS9jaGVja3N1bS5oPg0KPiAgI2luY2x1ZGUgPGFzbS93b3JkLWF0LWEtdGltZS5oPg0K
PiANCj4gLXN0YXRpYyBpbmxpbmUgdW5zaWduZWQgc2hvcnQgZnJvbTMydG8xNih1bnNpZ25lZCBh
KQ0KPiAtew0KPiAtCXVuc2lnbmVkIHNob3J0IGIgPSBhID4+IDE2Ow0KPiAtCWFzbSgiYWRkdyAl
dzIsJXcwXG5cdCINCj4gLQkgICAgImFkY3cgJDAsJXcwXG4iDQo+IC0JICAgIDogIj1yIiAoYikN
Cj4gLQkgICAgOiAiMCIgKGIpLCAiciIgKGEpKTsNCj4gLQlyZXR1cm4gYjsNCj4gLX0NCj4gLQ0K
PiAgLyoNCj4gICAqIERvIGEgY2hlY2tzdW0gb24gYW4gYXJiaXRyYXJ5IG1lbW9yeSBhcmVhLg0K
PiAgICogUmV0dXJucyBhIDMyYml0IGNoZWNrc3VtLg0KPiBAQCAtMzAsMjIgKzIwLDEyIEBAIHN0
YXRpYyBpbmxpbmUgdW5zaWduZWQgc2hvcnQgZnJvbTMydG8xNih1bnNpZ25lZCBhKQ0KPiAgICoN
Cj4gICAqIFN0aWxsLCB3aXRoIENIRUNLU1VNX0NPTVBMRVRFIHRoaXMgaXMgY2FsbGVkIHRvIGNv
bXB1dGUNCj4gICAqIGNoZWNrc3VtcyBvbiBJUHY2IGhlYWRlcnMgKDQwIGJ5dGVzKSBhbmQgb3Ro
ZXIgc21hbGwgcGFydHMuDQo+IC0gKiBpdCdzIGJlc3QgdG8gaGF2ZSBidWZmIGFsaWduZWQgb24g
YSA2NC1iaXQgYm91bmRhcnkNCj4gKyAqIFRoZSBwZW5hbHR5IGZvciBtaXNhbGlnbmVkIGJ1ZmYg
aXMgbmVnbGlnYWJsZS4NCj4gICAqLw0KPiAgX193c3VtIGNzdW1fcGFydGlhbChjb25zdCB2b2lk
ICpidWZmLCBpbnQgbGVuLCBfX3dzdW0gc3VtKQ0KPiAgew0KPiAgCXU2NCB0ZW1wNjQgPSAoX19m
b3JjZSB1NjQpc3VtOw0KPiAtCXVuc2lnbmVkIG9kZCwgcmVzdWx0Ow0KPiAtDQo+IC0Jb2RkID0g
MSAmICh1bnNpZ25lZCBsb25nKSBidWZmOw0KPiAtCWlmICh1bmxpa2VseShvZGQpKSB7DQo+IC0J
CWlmICh1bmxpa2VseShsZW4gPT0gMCkpDQo+IC0JCQlyZXR1cm4gc3VtOw0KPiAtCQl0ZW1wNjQg
PSByb3IzMigoX19mb3JjZSB1MzIpc3VtLCA4KTsNCj4gLQkJdGVtcDY0ICs9ICgqKHVuc2lnbmVk
IGNoYXIgKilidWZmIDw8IDgpOw0KPiAtCQlsZW4tLTsNCj4gLQkJYnVmZisrOw0KPiAtCX0NCj4g
Kwl1bnNpZ25lZCByZXN1bHQ7DQo+IA0KPiAgCXdoaWxlICh1bmxpa2VseShsZW4gPj0gNjQpKSB7
DQo+ICAJCWFzbSgiYWRkcSAwKjgoJVtzcmNdKSwlW3Jlc11cblx0Ig0KPiBAQCAtMTMwLDEwICsx
MTAsNiBAQCBfX3dzdW0gY3N1bV9wYXJ0aWFsKGNvbnN0IHZvaWQgKmJ1ZmYsIGludCBsZW4sIF9f
d3N1bSBzdW0pDQo+ICAjZW5kaWYNCj4gIAl9DQo+ICAJcmVzdWx0ID0gYWRkMzJfd2l0aF9jYXJy
eSh0ZW1wNjQgPj4gMzIsIHRlbXA2NCAmIDB4ZmZmZmZmZmYpOw0KPiAtCWlmICh1bmxpa2VseShv
ZGQpKSB7DQo+IC0JCXJlc3VsdCA9IGZyb20zMnRvMTYocmVzdWx0KTsNCj4gLQkJcmVzdWx0ID0g
KChyZXN1bHQgPj4gOCkgJiAweGZmKSB8ICgocmVzdWx0ICYgMHhmZikgPDwgOCk7DQo+IC0JfQ0K
PiAgCXJldHVybiAoX19mb3JjZSBfX3dzdW0pcmVzdWx0Ow0KPiAgfQ0KPiAgRVhQT1JUX1NZTUJP
TChjc3VtX3BhcnRpYWwpOw0KPiAtLQ0KPiAyLjE3LjENCj4gDQo+IC0NCj4gUmVnaXN0ZXJlZCBB
ZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMs
IE1LMSAxUFQsIFVLDQo+IFJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQoNCi0NClJl
Z2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0
b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykN
Cg==

