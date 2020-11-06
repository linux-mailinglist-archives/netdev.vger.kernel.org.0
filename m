Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EE12A920C
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgKFJDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 04:03:39 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:37563 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726127AbgKFJD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 04:03:26 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-249-0IkPmc9wNca7yYUeYdFKGQ-1; Fri, 06 Nov 2020 09:03:21 +0000
X-MC-Unique: 0IkPmc9wNca7yYUeYdFKGQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 6 Nov 2020 09:03:20 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 6 Nov 2020 09:03:20 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xie He' <xie.he.0141@gmail.com>, Arnd Bergmann <arnd@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Martin Schiller" <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Linux X25 <linux-x25@vger.kernel.org>
Subject: RE: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
Thread-Topic: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
Thread-Index: AQHWs8WUvDVQKZzs2ECZM+crj0xbk6m6zNyw
Date:   Fri, 6 Nov 2020 09:03:20 +0000
Message-ID: <f4b59cfa4f6b4cc89bf2f111974bb86e@AcuMS.aculab.com>
References: <20201105073434.429307-1-xie.he.0141@gmail.com>
 <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com>
 <CAJht_EPP_otbU226Ub5mC_OZPXO4h0O2-URkpsrMBFovcdDHWQ@mail.gmail.com>
 <CAK8P3a2jd3w=k9HC-kFWZYuzAf2D4npkWdrUn6UBj6JzrrVkpQ@mail.gmail.com>
 <CAJht_EPAqy_+Cfh1TXoNeC_j7JDgPWrG-=mMMmQ3ot2gNZuB8A@mail.gmail.com>
In-Reply-To: <CAJht_EPAqy_+Cfh1TXoNeC_j7JDgPWrG-=mMMmQ3ot2gNZuB8A@mail.gmail.com>
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

RnJvbTogWGllIEhlDQo+IFNlbnQ6IDA1IE5vdmVtYmVyIDIwMjAgMjI6NDcNCj4gDQo+IE9uIFRo
dSwgTm92IDUsIDIwMjAgYXQgMTI6NDAgUE0gQXJuZCBCZXJnbWFubiA8YXJuZEBrZXJuZWwub3Jn
PiB3cm90ZToNCj4gPg0KPiA+ID4gSSB0aGluayB0aGlzIGRyaXZlciBuZXZlciB3b3JrZWQuIExv
b2tpbmcgYXQgdGhlIG9yaWdpbmFsIGNvZGUgaW4NCj4gPiA+IExpbnV4IDIuMS4zMSwgaXQgYWxy
ZWFkeSBoYXMgdGhlIHByb2JsZW1zIEkgZml4ZWQgaW4gY29tbWl0DQo+ID4gPiA4ZmRjYWJlYWMz
OTguDQo+ID4gPg0KPiA+ID4gSSBndWVzcyB3aGVuIHBlb3BsZSAob3IgYm90cykgc2F5IHRoZXkg
InRlc3RlZCIsIHRoZXkgaGF2ZSBub3QNCj4gPiA+IG5lY2Vzc2FyaWx5IHVzZWQgdGhpcyBkcml2
ZXIgdG8gYWN0dWFsbHkgdHJ5IHRyYW5zcG9ydGluZyBkYXRhLiBUaGV5DQo+ID4gPiBtYXkganVz
dCBoYXZlIHRlc3RlZCBvcGVuL2Nsb3NlLCBldGMuIHRvIGNvbmZpcm0gdGhhdCB0aGUgcGFydGlj
dWxhcg0KPiA+ID4gcHJvYmxlbS9pc3N1ZSB0aGV5IHNhdyBoYWQgYmVlbiBmaXhlZC4NCj4gPg0K
PiA+IEl0IGRpZG4ndCBzb3VuZCBsaWtlIHRoYXQgZnJvbSB0aGUgY29tbWl0IG1lc3NhZ2UsIGJ1
dCBpdCBjb3VsZCBiZS4NCj4gPiBGb3IgcmVmZXJlbmNlOg0KPiA+DQo+IGh0dHBzOi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RnbHgvaGlzdG9yeS5naXQvY29tbWl0
P2lkPWFhMmI0NDI3YzM1NWFjYWY4NmQyYzdlNmZhZQ0KPiBhMzQ3MjAwNWUzY2ZmDQo+IA0KPiBJ
IHNlZS4gVGhlIGF1dGhvciBvZiB0aGlzIGNvbW1pdCBzYWlkICJJIHRlc3RlZCBieSBicmluZ2lu
ZyB1cCBhbiB4LjI1DQo+IGFzeW5jIGxpbmUgdXNpbmcgYSBtb2RpZmllZCB2ZXJzaW9uIG9mIHNs
YXR0YWNoLiIgTWF5YmUgaGUgb25seQ0KPiBzd2l0Y2hlZCBUVFkgcG9ydHMgZnJvbSB0aGUgTl9U
VFkgbGluZSBkaXNjaXBsaW5lIHRvIHRoZSBOX1gyNSBsaW5lDQo+IGRpc2NpcGxpbmUuIFRvIGFj
dHVhbGx5IHRlc3QgdHJhbnNwb3J0aW5nIGRhdGEsIHdlIG5lZWQgdG8gZWl0aGVyIHVzZQ0KPiBB
Rl9QQUNLRVQgc29ja2V0cywgb3IgdXNlIEFGX1gyNSBzb2NrZXRzIHdpdGggdGhlIFguMjUgcm91
dGluZyB0YWJsZQ0KPiBwcm9wZXJseSBzZXQgdXAuIFRoZSBhdXRob3Igb2YgdGhpcyBjb21taXQg
ZGlkbid0IGNsZWFybHkgaW5kaWNhdGUNCj4gdGhhdCBoZSBkaWQgdGhlc2UuDQoNCkhtbW0uLi4u
IExBUEIgd291bGQgZXhwZWN0IHRvIGhhdmUgYW4gWC4yNSBsZXZlbCAzIGFuZCBtYXliZSBJU08N
CnRyYW5zcG9ydCAoY2xhc3MgMCwgMiBvciAzKSBzYXQgb24gdG9wIG9mIGl0Lg0KVGhlIElTTyBu
ZXR3b3JraW5nIHNlcnZpY2Ugd291bGQgbm9ybWFsbHkgYmUgYWJzZW50IChtb3JlIGxpa2VseSB0
bw0KYmUgdXNlZCB3aXRoIGNsYXNzIDQgdHJhbnNwb3J0IG92ZXIgZXRoZXJuZXQgLSBidXQgc3Rp
bGwgb3B0aW9uYWwpLg0KTm90aGluZyBhdCBhbGwgbGlrZSBTTElQLg0KDQpZb3UgY291bGQgdXNl
IExBUEIgdW5udW1iZXJlZCAoVUkpIGZyYW1lcyB0byBjYXJyeSBJUCBmcmFtZXMNCihhcyBTTElQ
IGRvZXMpIC0gYnV0IHRoYXQgaXMgcmVhbGx5IGp1c3QgdXNpbmcgSERMQyBpbnN0ZWFkIG9mDQph
c3luYy4gRG9pbmcgdGhhdCB1c2luZyBhc3luYyBpcyBqdXN0IHNpbGx5Lg0KDQpMb29rcyBsaWtl
IHRoaXMgY29kZSBzaG91bGQgaGF2ZSBiZWVuIHJlbW92ZWQgZm9yIDIuMiA6LSkNCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

