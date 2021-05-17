Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87ACD382C90
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 14:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhEQMvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 08:51:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:47992 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237130AbhEQMvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 08:51:52 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-149-wut8-mPqOHOv3M2Sd2gB7Q-1; Mon, 17 May 2021 13:50:33 +0100
X-MC-Unique: wut8-mPqOHOv3M2Sd2gB7Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 17 May 2021 13:50:30 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Mon, 17 May 2021 13:50:30 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Neal Cardwell' <ncardwell@google.com>,
        louisrossberg <louisrossberg@protonmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: RE: Listening on a TCP socket from a Kernel Module
Thread-Topic: Listening on a TCP socket from a Kernel Module
Thread-Index: AQHXSr+3GMYNZUgdCkOEAPNeLW2sIqrnnyqg
Date:   Mon, 17 May 2021 12:50:30 +0000
Message-ID: <576922badb254ef0a73443a7752ba9c8@AcuMS.aculab.com>
References: <5J_z4QNPMBAk4y0rGshI7mBykT1tivh3037CbQRYXTu_Ra6zuojEcI0RB04ghXQxgdtDbt3YFv6sA882mrFyTdzQePwHwvLoECnqFTnYNZI=@protonmail.com>
 <CADVnQymGvCTEzdd8dSLZnn0dwnHAoNiwo72yEFeNr47+Na8GDg@mail.gmail.com>
In-Reply-To: <CADVnQymGvCTEzdd8dSLZnn0dwnHAoNiwo72yEFeNr47+Na8GDg@mail.gmail.com>
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

RnJvbTogTmVhbCBDYXJkd2VsbA0KPiBTZW50OiAxNyBNYXkgMjAyMSAwMjo1NQ0KPiANCj4gT24g
U3VuLCBNYXkgMTYsIDIwMjEgYXQgNzoyMCBQTSBsb3Vpc3Jvc3NiZXJnDQo+IDxsb3Vpc3Jvc3Ni
ZXJnQHByb3Rvbm1haWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IEhlbGxvLCBjYW4gc29tZWJvZHkg
cG9pbnQgbWUgaW4gdGhlIHJpZ2h0IGRpcmVjdGlvbiBmb3INCj4gPiB3aGF0IEkgd291bGQgdXNl
IHRvIGxpc3RlbiBvbiBhIFRDUCBzb2NrZXQgZnJvbSB0aGUNCj4gPiBrZXJuZWw/IEkgYW0gd29y
a2luZyBvbiBhIGtlcm5lbCBtb2R1bGUgYW5kIGhhdmUgc3BlbnQgdGhlDQo+ID4gcGFzdCBkYXkg
bG9va2luZyB0aHJvdWdoIGluY2x1ZGUvbmV0IGFuZCBpbmNsdWRlL2xpbnV4IGZvcg0KPiA+IHNv
bWV0aGluZyB0aGF0IHdvdWxkIGFsbG93IG1lIHRvIGRvIHNvLiBJIGtub3cgVENQDQo+ID4gbGlz
dGVuaW5nIGlzIHR5cGljYWxseSBkb25lIGluIHVzZXJzcGFjZSwgYnV0IGl0IHNob3VsZCBiZQ0K
PiA+IHBvc3NpYmxlIGF0IHRoZSBrZXJuZWwgbGV2ZWwgcmlnaHQ/ICB0Y3BfZGlhZyBsb29rcw0K
PiA+IHByb21pc2luZywgYnV0IGl0IHNlZW1zIGxpa2UgdGhhdCBpcyBtYWlubHkgZm9yIG1vbml0
b3JpbmcNCj4gPiBzb2NrZXRzLCBhbmQgSSdtIG5vdCBzdXJlIGlmIEkgd291bGQgYmUgYWJsZSB0
byBwcm92aWRlDQo+ID4gcmVzcG9uc2VzIGZyb20gaXQuDQo+ID4NCj4gPiBMb3VpcyBSb3NzYmVy
ZywNCj4gPiBXYXJwZWQgVGVjaG5vbG9naWVzDQo+IA0KPiBQZXJoYXBzIGtlcm5lbF9saXN0ZW4o
KSBhbmQgcmVsYXRlZCBmdW5jdGlvbnMgKGtlcm5lbF9iaW5kKCksDQo+IGtlcm5lbF9hY2NlcHQo
KSwgZXRjLikgaW4gbmV0L3NvY2tldC5jIG1pZ2h0IGRvIHRoZSB0cmljayBmb3IgeW91ciB1c2UN
Cj4gY2FzZT8gTG9va2luZyBhdCBob3cgdGhlIGNhbGxlcnMgb2YgdGhlc2UgZnVuY3Rpb25zIHN0
cnVjdHVyZSB0aGVpcg0KPiBjb2RlIG1pZ2h0IGdpdmUgeW91IGVub3VnaCB0byBnbyBvbi4NCg0K
VGhleSBzaG91bGQgd29yay4NClRoZXJlIGFyZSBhIGNvdXBsZSBvZiBpc3N1ZXMgdGhvdWdoOg0K
LSBUaGVyZSBpcyBubyBnZXRzb2Nrb3B0KCkgc3VwcG9ydCBpbiBjdXJyZW50IGtlcm5lbHMuDQot
IFlvdSBtYXkgbmVlZCB0byB1c2UgX19zb2NrX2NyZWF0ZSgpIHJhdGhlciB0aGFuIHNvY2tfY3Jl
YXRlX2tlcm4oKQ0KICBpbiBvcmRlciB0byBob2xkIGEgcmVmZXJlbmNlIHRvIHRoZSBuZXR3b3Jr
IG5hbWVzcGFjZS4NCkl0IG1heSBiZSBwb3NzaWJsZSB0byB1c2UgdGhlIHdha2V1cCBjYWxsYmFj
a3MgdGhhdCBzZWxlY3QvcG9sbCB1c2UuDQpCdXQgaXQgaXMgcHJvYmFibHkgc2FmZXIgdG8gdXNl
IGJsb2NraW5nIG9wZXJhdGlvbnMgZnJvbSBhIHNlcGFyYXRlDQprZXJuZWwgdGhyZWFkLg0KDQoJ
RGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1v
dW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEz
OTczODYgKFdhbGVzKQ0K

