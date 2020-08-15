Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5750E245309
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 23:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgHOV5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 17:57:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:36989 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728966AbgHOVwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:52:03 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-268-OMTNH1z9M3WH3llN6ul8QQ-1; Sat, 15 Aug 2020 15:49:32 +0100
X-MC-Unique: OMTNH1z9M3WH3llN6ul8QQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 15 Aug 2020 15:49:31 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 15 Aug 2020 15:49:31 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>,
        'Andrew Morton' <akpm@linux-foundation.org>
CC:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: RE: sctp: num_ostreams and max_instreams negotiation
Thread-Topic: sctp: num_ostreams and max_instreams negotiation
Thread-Index: AdZyPjABix+HSvLeTmG2b9Vg1HRq1AAFgglgAC9e6TA=
Date:   Sat, 15 Aug 2020 14:49:31 +0000
Message-ID: <0c1621e5da2e41e8905762d0208f9d40@AcuMS.aculab.com>
References: <9a1bfa6085854387bf98b6171c879b37@AcuMS.aculab.com>
 <868bd24b536345e6a5596f856a0ebe90@AcuMS.aculab.com>
In-Reply-To: <868bd24b536345e6a5596f856a0ebe90@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDE0IEF1Z3VzdCAyMDIwIDE3OjE4DQo+IA0KPiA+
ID4gPiBBdCBzb21lIHBvaW50IHRoZSBuZWdvdGlhdGlvbiBvZiB0aGUgbnVtYmVyIG9mIFNDVFAg
c3RyZWFtcw0KPiA+ID4gPiBzZWVtcyB0byBoYXZlIGdvdCBicm9rZW4uDQo+ID4gPiA+IEkndmUg
ZGVmaW5pdGVseSB0ZXN0ZWQgaXQgaW4gdGhlIHBhc3QgKHByb2JhYmx5IDEwIHllYXJzIGFnbyEp
DQo+ID4gPiA+IGJ1dCBvbiBhIDUuOC4wIGtlcm5lbCBnZXRzb2Nrb3B0KFNDVFBfSU5GTykgc2Vl
bXMgdG8gYmUNCj4gPiA+ID4gcmV0dXJuaW5nIHRoZSAnbnVtX29zdHJlYW1zJyBzZXQgYnkgc2V0
c29ja29wdChTQ1RQX0lOSVQpDQo+ID4gPiA+IHJhdGhlciB0aGFuIHRoZSBzbWFsbGVyIG9mIHRo
YXQgdmFsdWUgYW5kIHRoYXQgY29uZmlndXJlZA0KPiA+ID4gPiBhdCB0aGUgb3RoZXIgZW5kIG9m
IHRoZSBjb25uZWN0aW9uLg0KPiA+ID4gPg0KPiA+ID4gPiBJJ2xsIGRvIGEgYml0IG9mIGRpZ2dp
bmcuDQo+ID4gPg0KPiA+ID4gSSBjYW4ndCBmaW5kIHRoZSBjb2RlIHRoYXQgcHJvY2Vzc2VzIHRo
ZSBpbml0X2Fjay4NCj4gPiA+IEJ1dCB3aGVuIHNjdHBfcHJvY3NzX2ludCgpIHNhdmVzIHRoZSBz
bWFsbGVyIHZhbHVlDQo+ID4gPiBpbiBhc29jLT5jLnNpbmludF9tYXhfb3N0cmVhbXMuDQo+ID4g
Pg0KPiA+ID4gQnV0IGFmZTg5OTk2MmVlMDc5IChpZiBJJ3ZlIHR5cGVkIGl0IHJpZ2h0KSBjaGFu
Z2VkDQo+ID4gPiB0aGUgdmFsdWVzIFNDVFBfSU5GTyByZXBvcnRlZC4NCj4gPiA+IEFwcGFyYW50
bHkgYWRkaW5nICdzY3RwIHJlY29uZmlnJyBoYWQgY2hhbmdlZCB0aGluZ3MuDQo+ID4gPg0KPiA+
ID4gU28gSSBzdXNwZWN0IHRoaXMgaGFzIGFsbCBiZWVuIGJyb2tlbiBmb3Igb3ZlciAzIHllYXJz
Lg0KPiA+DQo+ID4gSXQgbG9va3MgbGlrZSB0aGUgY2hhbmdlcyB0aGF0IGJyb2tlIGl0IHdlbnQg
aW50byA0LjExLg0KPiA+IEkndmUganVzdCBjaGVja2VkIGEgMy44IGtlcm5lbCBhbmQgdGhhdCBu
ZWdvdGlhdGVzIHRoZQ0KPiA+IHZhbHVlcyBkb3duIGluIGJvdGggZGlyZWN0aW9ucy4NCj4gPg0K
PiA+IEkgZG9uJ3QgaGF2ZSBhbnkga2VybmVscyBsdXJraW5nIGJldHdlZW4gMy44IGFuZCA0LjE1
Lg0KPiA+IChZZXMsIEkgY291bGQgYnVpbGQgb25lLCBidXQgaXQgZG9lc24ndCByZWFsbHkgaGVs
cC4pDQo+IA0KPiBPaywgYnVnIGxvY2F0ZWQgLSBwcmV0dHkgb2J2aW91cyByZWFsbHkuDQo+IG5l
dC9zY3RwL3N0cmVhbS4gaGFzIHRoZSBmb2xsb3dpbmcgY29kZToNCj4gDQo+IHN0YXRpYyBpbnQg
c2N0cF9zdHJlYW1fYWxsb2Nfb3V0KHN0cnVjdCBzY3RwX3N0cmVhbSAqc3RyZWFtLCBfX3UxNiBv
dXRjbnQsDQo+IAkJCQkgZ2ZwX3QgZ2ZwKQ0KPiB7DQo+IAlpbnQgcmV0Ow0KPiANCj4gCWlmIChv
dXRjbnQgPD0gc3RyZWFtLT5vdXRjbnQpDQo+IAkJcmV0dXJuIDA7DQoNCkRlbGV0aW5nIHRoaXMg
Y2hlY2sgaXMgc3VmZmljaWVudCB0byBmaXggdGhlIGNvZGUuDQpBbG9uZyB3aXRoIHRoZSBlcXVp
dmFsZW50IGNoZWNrIGluIHNjdHBfc3RyZWFtLWFsbG9jX2luKCkuDQoNCg0KPiBUaGlzIGRvZXMg
bWVhbiB0aGF0IGl0IGhhcyBvbmx5IGJlZW4gYnJva2VuIHNpbmNlIHRoZSA1LjENCj4gbWVyZ2Ug
d2luZG93Lg0KDQpBbmQgaXMgYSBnb29kIGNhbmRpZGF0ZSBmb3IgdGhlIGJhY2stcG9ydHMuDQoN
Cj4gCXJldCA9IGdlbnJhZGl4X3ByZWFsbG9jKCZzdHJlYW0tPm91dCwgb3V0Y250LCBnZnApOw0K
PiAJaWYgKHJldCkNCj4gCQlyZXR1cm4gcmV0Ow0KPiANCj4gCXN0cmVhbS0+b3V0Y250ID0gb3V0
Y250Ow0KPiAJcmV0dXJuIDA7DQo+IH0NCj4gDQo+IHNjdHBfc3RyZWFtX2FsbG9jX2luKCkgaXMg
dGhlIHNhbWUuDQo+IA0KPiBUaGlzIGlzIGNhbGxlZCB0byByZWR1Y2UgdGhlIG51bWJlciBvZiBz
dHJlYW1zLg0KPiBCdXQgaW4gdGhhdCBjYXNlIGl0IGRvZXMgbm90aGluZyBhdCBhbGwuDQo+IA0K
PiBXaGljaCBtZWFucyB0aGF0IHRoZSAnY29udmVydCB0byBnZW5yYWRpeCcgY2hhbmdlIGJyb2tl
IGl0Lg0KPiBUYWcgMjA3NWU1MGNhZjVlYS4NCj4gDQo+IEkgZG9uJ3Qga25vdyB3aGF0ICdnZW5y
YWRpeCcgYXJyYXlzIG9yIHRoZSBlYXJsaWVyICdmbGV4X2FycmF5Jw0KPiBhY3R1YWxseSBsb29r
IGxpa2UuDQo+IEJ1dCBpZiAnZ2VucmFkaXgnIGlzIHNvbWUga2luZCBvZiByYWRpeC10cmVlIGl0
IGlzIHByb2JhYmx5IHRoZQ0KPiB3cm9uZyBiZWFzdCBmb3IgU0NUUCBzdHJlYW1zLg0KPiBMb3Rz
IG9mIGNvZGUgbG9vcHMgdGhyb3VnaCBhbGwgb2YgdGhlbS4NCg0KWWVwLCBJJ20gcHJldHR5IHN1
cmUgYSBrdm1hbGxvYygpIHdvdWxkIGJlIGJlc3QuDQoNCj4gV2hpbGUganVzdCBhc3NpZ25pbmcg
dG8gc3RyZWFtLT5vdXRjbnQgd2hlbiB0aGUgdmFsdWUNCj4gaXMgcmVkdWNlZCB3aWxsIGZpeCB0
aGUgbmVnb3RpYXRpb24sIEkndmUgbm8gaWRlYQ0KPiB3aGF0IHNpZGUtZWZmZWN0cyB0aGF0IGhh
cy4NCg0KSSd2ZSBkb25lIHNvbWUgY2hlY2tzLg0KVGhlIGFycmF5cyBhcmUgYWxsb2NhdGVkIHdo
ZW4gYW4gSU5JVCBpcyBzZW50IGFuZCBhbHNvIGJlZm9yZQ0KYSByZWNlaXZlZCBJTklUIGlzIHBy
b2Nlc3NlZC4NClNvIGlmIG9uZSBzaWRlIChlZyB0aGUgcmVzcG9uZGVyKSBhbGxvY2F0ZXMgYSB2
ZXJ5IGJpZyB2YWx1ZQ0KdGhlbiB0aGUgYXNzb2NpYXRlZCBtZW1vcnkgaXMgbmV2ZXIgZnJlZWQg
d2hlbiB0aGUgdmFsdWUNCmlzIG5lZ290aWF0ZWQgZG93bi4NClRoZXJlIGlzIGEgY29tbWVudCB0
byB0aGUgZWZmZWN0IHRoYXQgdGhpcyBpcyBkZXNpcmFibGUuDQoNCklmIG15IHF1aWNrIGNhbGN1
bGF0aW9ucyBhcmUgY29ycmVjdCB0aGVuIGVhY2ggJ2luJyBpcyAyMCBieXRlcw0KYW5kIGVhY2gg
J291dCcgMjQgKHdpdGggYSBsb3Qgb2YgcGFkIGJ5dGVzKS4NClNvIHRoZSBtYXggc2l6ZXMgYXJl
IDMyMiBhbmQgMzg2IDRrIHBhZ2VzLg0KDQpJIGhhdmVuJ3QgbG9va2VkIGF0IGhvdyBtYW55IG9m
IHRoZSAnb3V0JyBzdHJlYW1zIGdldHMgdGhlDQpleHRyYSwgc2VwYXJhdGVseSBhbGxvY2F0ZWQs
IHN0cnVjdHVyZS4NCkkgc3VzcGVjdCB0aGUgbWVtb3J5IGZvb3RwcmludCBmb3IgYSBzaW5nbGUg
U0NUUCBjb25uZWN0aW9uDQppcyBwb3RlbnRpYWxseSBodWdlLg0KDQoJRGF2aWQNCg0KLQ0KUmVn
aXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRv
biBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

