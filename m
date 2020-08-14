Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9162B244C8A
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgHNQSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:18:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:38068 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728232AbgHNQSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:18:10 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-58-GBcrWMuKP5mavZ544X16Wg-1; Fri, 14 Aug 2020 17:18:05 +0100
X-MC-Unique: GBcrWMuKP5mavZ544X16Wg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 14 Aug 2020 17:18:05 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 14 Aug 2020 17:18:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'kent.overstreet@gmail.com'" <kent.overstreet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: RE: sctp: num_ostreams and max_instreams negotiation
Thread-Topic: sctp: num_ostreams and max_instreams negotiation
Thread-Index: AdZyPjABix+HSvLeTmG2b9Vg1HRq1AAFgglg
Date:   Fri, 14 Aug 2020 16:18:05 +0000
Message-ID: <868bd24b536345e6a5596f856a0ebe90@AcuMS.aculab.com>
References: <9a1bfa6085854387bf98b6171c879b37@AcuMS.aculab.com>
In-Reply-To: <9a1bfa6085854387bf98b6171c879b37@AcuMS.aculab.com>
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

PiA+ID4gQXQgc29tZSBwb2ludCB0aGUgbmVnb3RpYXRpb24gb2YgdGhlIG51bWJlciBvZiBTQ1RQ
IHN0cmVhbXMNCj4gPiA+IHNlZW1zIHRvIGhhdmUgZ290IGJyb2tlbi4NCj4gPiA+IEkndmUgZGVm
aW5pdGVseSB0ZXN0ZWQgaXQgaW4gdGhlIHBhc3QgKHByb2JhYmx5IDEwIHllYXJzIGFnbyEpDQo+
ID4gPiBidXQgb24gYSA1LjguMCBrZXJuZWwgZ2V0c29ja29wdChTQ1RQX0lORk8pIHNlZW1zIHRv
IGJlDQo+ID4gPiByZXR1cm5pbmcgdGhlICdudW1fb3N0cmVhbXMnIHNldCBieSBzZXRzb2Nrb3B0
KFNDVFBfSU5JVCkNCj4gPiA+IHJhdGhlciB0aGFuIHRoZSBzbWFsbGVyIG9mIHRoYXQgdmFsdWUg
YW5kIHRoYXQgY29uZmlndXJlZA0KPiA+ID4gYXQgdGhlIG90aGVyIGVuZCBvZiB0aGUgY29ubmVj
dGlvbi4NCj4gPiA+DQo+ID4gPiBJJ2xsIGRvIGEgYml0IG9mIGRpZ2dpbmcuDQo+ID4NCj4gPiBJ
IGNhbid0IGZpbmQgdGhlIGNvZGUgdGhhdCBwcm9jZXNzZXMgdGhlIGluaXRfYWNrLg0KPiA+IEJ1
dCB3aGVuIHNjdHBfcHJvY3NzX2ludCgpIHNhdmVzIHRoZSBzbWFsbGVyIHZhbHVlDQo+ID4gaW4g
YXNvYy0+Yy5zaW5pbnRfbWF4X29zdHJlYW1zLg0KPiA+DQo+ID4gQnV0IGFmZTg5OTk2MmVlMDc5
IChpZiBJJ3ZlIHR5cGVkIGl0IHJpZ2h0KSBjaGFuZ2VkDQo+ID4gdGhlIHZhbHVlcyBTQ1RQX0lO
Rk8gcmVwb3J0ZWQuDQo+ID4gQXBwYXJhbnRseSBhZGRpbmcgJ3NjdHAgcmVjb25maWcnIGhhZCBj
aGFuZ2VkIHRoaW5ncy4NCj4gPg0KPiA+IFNvIEkgc3VzcGVjdCB0aGlzIGhhcyBhbGwgYmVlbiBi
cm9rZW4gZm9yIG92ZXIgMyB5ZWFycy4NCj4gDQo+IEl0IGxvb2tzIGxpa2UgdGhlIGNoYW5nZXMg
dGhhdCBicm9rZSBpdCB3ZW50IGludG8gNC4xMS4NCj4gSSd2ZSBqdXN0IGNoZWNrZWQgYSAzLjgg
a2VybmVsIGFuZCB0aGF0IG5lZ290aWF0ZXMgdGhlDQo+IHZhbHVlcyBkb3duIGluIGJvdGggZGly
ZWN0aW9ucy4NCj4gDQo+IEkgZG9uJ3QgaGF2ZSBhbnkga2VybmVscyBsdXJraW5nIGJldHdlZW4g
My44IGFuZCA0LjE1Lg0KPiAoWWVzLCBJIGNvdWxkIGJ1aWxkIG9uZSwgYnV0IGl0IGRvZXNuJ3Qg
cmVhbGx5IGhlbHAuKQ0KDQpPaywgYnVnIGxvY2F0ZWQgLSBwcmV0dHkgb2J2aW91cyByZWFsbHku
DQpuZXQvc2N0cC9zdHJlYW0uIGhhcyB0aGUgZm9sbG93aW5nIGNvZGU6DQoNCnN0YXRpYyBpbnQg
c2N0cF9zdHJlYW1fYWxsb2Nfb3V0KHN0cnVjdCBzY3RwX3N0cmVhbSAqc3RyZWFtLCBfX3UxNiBv
dXRjbnQsDQoJCQkJIGdmcF90IGdmcCkNCnsNCglpbnQgcmV0Ow0KDQoJaWYgKG91dGNudCA8PSBz
dHJlYW0tPm91dGNudCkNCgkJcmV0dXJuIDA7DQoNCglyZXQgPSBnZW5yYWRpeF9wcmVhbGxvYygm
c3RyZWFtLT5vdXQsIG91dGNudCwgZ2ZwKTsNCglpZiAocmV0KQ0KCQlyZXR1cm4gcmV0Ow0KDQoJ
c3RyZWFtLT5vdXRjbnQgPSBvdXRjbnQ7DQoJcmV0dXJuIDA7DQp9DQoNCnNjdHBfc3RyZWFtX2Fs
bG9jX2luKCkgaXMgdGhlIHNhbWUuDQoNClRoaXMgaXMgY2FsbGVkIHRvIHJlZHVjZSB0aGUgbnVt
YmVyIG9mIHN0cmVhbXMuDQpCdXQgaW4gdGhhdCBjYXNlIGl0IGRvZXMgbm90aGluZyBhdCBhbGwu
DQoNCldoaWNoIG1lYW5zIHRoYXQgdGhlICdjb252ZXJ0IHRvIGdlbnJhZGl4JyBjaGFuZ2UgYnJv
a2UgaXQuDQpUYWcgMjA3NWU1MGNhZjVlYS4NCg0KSSBkb24ndCBrbm93IHdoYXQgJ2dlbnJhZGl4
JyBhcnJheXMgb3IgdGhlIGVhcmxpZXIgJ2ZsZXhfYXJyYXknDQphY3R1YWxseSBsb29rIGxpa2Uu
DQpCdXQgaWYgJ2dlbnJhZGl4JyBpcyBzb21lIGtpbmQgb2YgcmFkaXgtdHJlZSBpdCBpcyBwcm9i
YWJseSB0aGUNCndyb25nIGJlYXN0IGZvciBTQ1RQIHN0cmVhbXMuDQpMb3RzIG9mIGNvZGUgbG9v
cHMgdGhyb3VnaCBhbGwgb2YgdGhlbS4NCg0KVGhpcyBkb2VzIG1lYW4gdGhhdCBpdCBoYXMgb25s
eSBiZWVuIGJyb2tlbiBzaW5jZSB0aGUgNS4xDQptZXJnZSB3aW5kb3cuDQoNCldoaWxlIGp1c3Qg
YXNzaWduaW5nIHRvIHN0cmVhbS0+b3V0Y250IHdoZW4gdGhlIHZhbHVlDQppcyByZWR1Y2VkIHdp
bGwgZml4IHRoZSBuZWdvdGlhdGlvbiwgSSd2ZSBubyBpZGVhDQp3aGF0IHNpZGUtZWZmZWN0cyB0
aGF0IGhhcy4NCg0KCURhdmlkDQoNCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBM
YWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBU
LCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

