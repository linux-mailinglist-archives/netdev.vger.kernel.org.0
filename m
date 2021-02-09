Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BE2315102
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhBIN5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:57:00 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:26344 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232107AbhBINz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 08:55:29 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-5-mCfALkJXP3Sgnq38bQfAag-1;
 Tue, 09 Feb 2021 13:53:43 +0000
X-MC-Unique: mCfALkJXP3Sgnq38bQfAag-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 9 Feb 2021 13:53:43 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 9 Feb 2021 13:53:43 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marc Kleine-Budde' <mkl@pengutronix.de>
CC:     Arnd Bergmann <arnd@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] can: ucan: fix alignment constraints
Thread-Topic: [PATCH] can: ucan: fix alignment constraints
Thread-Index: AQHW/h0DjBhn7+16ykCQOOnmCF4WhKpPn1uQgAARu4CAACZvoA==
Date:   Tue, 9 Feb 2021 13:53:43 +0000
Message-ID: <e0a5cbe1e41f4326aa4c9800f4a351b2@AcuMS.aculab.com>
References: <20210204162625.3099392-1-arnd@kernel.org>
 <20210208131624.y5ro74e4fibpg6rk@hardanger.blackshift.org>
 <bd7e6497b3f64fb5bb839dc9a9d51d6a@AcuMS.aculab.com>
 <20210209112815.hqndd7qonsygvv4n@hardanger.blackshift.org>
In-Reply-To: <20210209112815.hqndd7qonsygvv4n@hardanger.blackshift.org>
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

RnJvbTogTWFyYyBLbGVpbmUtQnVkZGUNCj4gU2VudDogMDkgRmVicnVhcnkgMjAyMSAxMToyOA0K
PiANCj4gT24gMDkuMDIuMjAyMSAxMDozNDo0MiwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KLi4uDQo+
ID4gQUZBSUNUIHRoZXJlIGlzIG9uZSBzdHJ1Y3R1cmUgdGhhdCB3b3VsZCBoYXZlIGVuZC1wYWRk
aW5nLg0KPiA+IEJ1dCBJIGRpZG4ndCBhY3R1YWxseSBzcG90IGFueXRoaW5nIHZhbGlkYXRpbmcg
aXQncyBsZW5ndGguDQo+ID4gV2hpY2ggbWF5IHdlbGwgbWVhbiB0aGF0IGl0IGlzIHBvc3NpYmxl
IHRvIHJlYWQgb2ZmIHRoZSBlbmQNCj4gPiBvZiB0aGUgVVNCIHJlY2VpdmUgYnVmZmVyIC0gcGxh
dXNpYmx5IGludG8gdW5tYXBwZWQgYWRkcmVzc2VzLg0KPiANCj4gSW4gdWNhbl9yZWFkX2J1bGtf
Y2FsbGJhY2soKSB0aGVyZSBpcyBhIGNoZWNrIG9mIHRoZSB1cmIncyBsZW5ndGgsDQo+IGFzIHdl
bGwgYXMgdGhlIGxlbmd0aCBpbmZvcm1hdGlvbiBpbnNpZGUgdGhlIHJ4J2VkIGRhdGE6DQo+IA0K
PiBodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92NS4xMC4xNC9zb3VyY2UvZHJpdmVy
cy9uZXQvY2FuL3VzYi91Y2FuLmMjTDczNA0KPiANCj4gfCBzdGF0aWMgdm9pZCB1Y2FuX3JlYWRf
YnVsa19jYWxsYmFjayhzdHJ1Y3QgdXJiICp1cmIpDQo+IHwgWy4uLl0NCj4gfCAJCS8qIGNoZWNr
IHNhbml0eSAobGVuZ3RoIG9mIGhlYWRlcikgKi8NCj4gfCAJCWlmICgodXJiLT5hY3R1YWxfbGVu
Z3RoIC0gcG9zKSA8IFVDQU5fSU5fSERSX1NJWkUpIHsNCj4gfCAJCQluZXRkZXZfd2Fybih1cC0+
bmV0ZGV2LA0KPiB8IAkJCQkgICAgImludmFsaWQgbWVzc2FnZSAoc2hvcnQ7IG5vIGhkcjsgbDol
ZClcbiIsDQo+IHwgCQkJCSAgICB1cmItPmFjdHVhbF9sZW5ndGgpOw0KPiB8IAkJCWdvdG8gcmVz
dWJtaXQ7DQo+IHwgCQl9DQo+IHwNCj4gfCAJCS8qIHNldHVwIHRoZSBtZXNzYWdlIGFkZHJlc3Mg
Ki8NCj4gfCAJCW0gPSAoc3RydWN0IHVjYW5fbWVzc2FnZV9pbiAqKQ0KPiB8IAkJCSgodTggKil1
cmItPnRyYW5zZmVyX2J1ZmZlciArIHBvcyk7DQo+IHwgCQlsZW4gPSBsZTE2X3RvX2NwdShtLT5s
ZW4pOw0KPiB8DQo+IHwgCQkvKiBjaGVjayBzYW5pdHkgKGxlbmd0aCBvZiBjb250ZW50KSAqLw0K
PiB8IAkJaWYgKHVyYi0+YWN0dWFsX2xlbmd0aCAtIHBvcyA8IGxlbikgew0KPiB8IAkJCW5ldGRl
dl93YXJuKHVwLT5uZXRkZXYsDQo+IHwgCQkJCSAgICAiaW52YWxpZCBtZXNzYWdlIChzaG9ydDsg
bm8gZGF0YTsgbDolZClcbiIsDQo+IHwgCQkJCSAgICB1cmItPmFjdHVhbF9sZW5ndGgpOw0KPiB8
IAkJCXByaW50X2hleF9kdW1wKEtFUk5fV0FSTklORywNCj4gfCAJCQkJICAgICAgICJyYXcgZGF0
YTogIiwNCj4gfCAJCQkJICAgICAgIERVTVBfUFJFRklYX0FERFJFU1MsDQo+IHwgCQkJCSAgICAg
ICAxNiwNCj4gfCAJCQkJICAgICAgIDEsDQo+IHwgCQkJCSAgICAgICB1cmItPnRyYW5zZmVyX2J1
ZmZlciwNCj4gfCAJCQkJICAgICAgIHVyYi0+YWN0dWFsX2xlbmd0aCwNCj4gfCAJCQkJICAgICAg
IHRydWUpOw0KPiB8DQo+IHwgCQkJZ290byByZXN1Ym1pdDsNCj4gfCAJCX0NCg0KVGhhdCBsb29r
cyBhcyB0aG91Z2ggaXQgY2hlY2tzIHRoYXQgdGhlIGJ1ZmZlciBsZW5ndGggcHJvdmlkZWQNCmJ5
IHRoZSBkZXZpY2UgaXMgYWxsIGNvbnRhaW5lZCB3aXRoaW4gdGhlIGJ1ZmZlci4NCg0KSSB3YXMg
bG9va2luZyBmb3IgdGhlIGNoZWNrIHRoYXQgdGhlIHN0cnVjdHVyZSB0eXBlIHRoZSBkYXRhDQpi
dWZmZXIgaXMgY2FzdCB0byBmaXRzIGlzIHRoZSBzdXBwbGllZCBkYXRhLg0KSSBkaWRuJ3Qgc2Vl
IGEgJ3NpemVvZiAoYnVmZmVyX3R5cGUpJyBmb3IgdGhlIG9uZSBJIGxvb2tlZCBmb3INCih0aGUg
c3RydWN0dXJlIHdpdGggYWxsIHRoZSB2ZXJzaW9uIGluZm8gaW4gaXQpLg0KDQo+IA0KPiANCj4g
PiBJIGxvb2tlZCBiZWNhdXNlIGFsbCB0aGUgcGF0Y2hlcyB0byAnZml4JyB0aGUgY29tcGlsZXIg
d2FybmluZw0KPiA+IGFyZSBkdWJpb3VzLg0KPiA+IE9uY2UgeW91J3ZlIGNoYW5nZWQgdGhlIG91
dGVyIGFsaWdubWVudCAoZWcgb2YgYSB1bmlvbikgdGhlbg0KPiA+IHRoZSBjb21waWxlciB3aWxs
IGFzc3VtZSB0aGF0IGFueSBwb2ludGVyIHRvIHRoYXQgdW5pb24gaXMgYWxpZ25lZC4NCj4gPiBT
byBhbnkgX3BhY2tlZCgpIGF0dHJpYnV0ZXMgdGhhdCBhcmUgcmVxdWlyZWQgZm9yIG1pcy1hbGln
bmVkDQo+ID4gYWNjZXNzZXMgZ2V0IGlnbm9yZWQgLSBiZWNhdXNlIHRoZSBjb21waWxlciBrbm93
cyB0aGUgcG9pbnRlcg0KPiA+IG11c3QgYmUgYWxpZ25lZC4NCj4gDQo+IEhlcmUgdGhlIHBhY2tl
ZCBhdHRyaWJ1dGUgaXMgbm90IHRvIHRlbGwgdGhlIGNvbXBpbGVyLCB0aGF0IGEgcG9pbnRlcg0K
PiB0byB0aGUgc3RydWN0IHVjYW5fbWVzc2FnZV9pbiBtYXkgYmUgdW5hbGlnbmVkLiBSYXRoZXIg
aXMgdGVsbHMgdGhlDQo+IGNvbXBpbGVyIHRvIG5vdCBhZGQgYW55IGhvbGVzIGludG8gdGhlIHN0
cnVjdC4NCg0KQnV0IHRoYXQgaXNuJ3Qgd2hhdCBpdCBtZWFucy4NClVzaW5nIGl0IHRoYXQgd2F5
IGlzIGJhc2ljYWxseSB3cm9uZy4NCkl0IHRlbGxzIHRoZSBjb21waWxlciB0aGF0IHRoZSBzdHJ1
Y3R1cmUgbWlnaHQgYmUgbWlzYWxpZ25lZA0KYW5kLCBpZiBuZWNlc3NhcnksIGRvIGJ5dGUgYWNj
ZXNzZXMgYW5kIHNoaWZ0cy4NCg0KSSBzdWdnZXN0IHlvdSBsb29rIGF0IHRoZSBnZW5lcmF0ZWQg
Y29kZSBmb3IgYW4gYXJjaGl0ZWN0dXJlDQp0aGF0IGRvZXNuJ3QgaGF2ZSBlZmZpY2llbnQgdW5h
bGlnbmVkIGFjY2Vzc2VzIC0gZWcgc3BhcmMgb3IgcHBjDQooYW5kIHByb2JhYmx5IGFybTMyIGFu
ZCBtYW55IG90aGVycykuDQoNClRoZSBjb21waWxlciB3b24ndCBhZGQgJ3JhbmRvbScgaG9sZXMu
DQpJZiB5b3Ugd2FudCB0byB2ZXJpZnkgdGhhdCB0aGVyZSBhcmVuJ3QgYWN0dWFsbHkgYW55IGhv
bGVzDQp0aGVuIHVzZSBhIGNvbXBpbGUtdGltZSBhc3NlcnQgb24gdGhlIHNpemUuDQoNCglEYXZp
ZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQg
RmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4
NiAoV2FsZXMpDQo=

