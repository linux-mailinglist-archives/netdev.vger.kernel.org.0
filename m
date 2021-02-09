Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D99314D68
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhBIKqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:46:42 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:58056 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231785AbhBIKjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:39:53 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-120-WxJzoBj3O66osIn6Rz9_oQ-1; Tue, 09 Feb 2021 10:34:43 +0000
X-MC-Unique: WxJzoBj3O66osIn6Rz9_oQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 9 Feb 2021 10:34:42 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 9 Feb 2021 10:34:42 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marc Kleine-Budde' <mkl@pengutronix.de>,
        Arnd Bergmann <arnd@kernel.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        "Oliver Hartkopp" <socketcan@hartkopp.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] can: ucan: fix alignment constraints
Thread-Topic: [PATCH] can: ucan: fix alignment constraints
Thread-Index: AQHW/h0DjBhn7+16ykCQOOnmCF4WhKpPn1uQ
Date:   Tue, 9 Feb 2021 10:34:42 +0000
Message-ID: <bd7e6497b3f64fb5bb839dc9a9d51d6a@AcuMS.aculab.com>
References: <20210204162625.3099392-1-arnd@kernel.org>
 <20210208131624.y5ro74e4fibpg6rk@hardanger.blackshift.org>
In-Reply-To: <20210208131624.y5ro74e4fibpg6rk@hardanger.blackshift.org>
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

RnJvbTogTWFyYyBLbGVpbmUtQnVkZGUNCj4gU2VudDogMDggRmVicnVhcnkgMjAyMSAxMzoxNg0K
PiANCj4gT24gMDQuMDIuMjAyMSAxNzoyNjoxMywgQXJuZCBCZXJnbWFubiB3cm90ZToNCj4gPiBG
cm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiA+DQo+ID4gc3RydWN0IHVjYW5f
bWVzc2FnZV9pbiBjb250YWlucyBtZW1iZXIgd2l0aCA0LWJ5dGUgYWxpZ25tZW50DQo+ID4gYnV0
IGlzIGl0c2VsZiBtYXJrZWQgYXMgdW5hbGlnbmVkLCB3aGljaCB0cmlnZ2VycyBhIHdhcm5pbmc6
DQo+ID4NCj4gPiBkcml2ZXJzL25ldC9jYW4vdXNiL3VjYW4uYzoyNDk6MTogd2FybmluZzogYWxp
Z25tZW50IDEgb2YgJ3N0cnVjdCB1Y2FuX21lc3NhZ2VfaW4nIGlzIGxlc3MgdGhhbiA0IFstDQo+
IFdwYWNrZWQtbm90LWFsaWduZWRdDQo+ID4NCj4gPiBNYXJrIHRoZSBvdXRlciBzdHJ1Y3R1cmUg
dG8gaGF2ZSB0aGUgc2FtZSBhbGlnbm1lbnQgYXMgdGhlIGlubmVyDQo+ID4gb25lLg0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gDQo+IEFw
cGxpZWQgdG8gbGludXgtY2FuLW5leHQvdGVzdGluZy4NCg0KSSd2ZSBqdXN0IGhhZCBhIGxvb2sg
YXQgdGhhdCBmaWxlLg0KDQpBcmUgYW55IG9mIHRoZSBfX3BhY2tlZCBvciBfX2FsaWduZWQgYWN0
dWFsbHkgcmVxdWlyZWQgYXQgYWxsLg0KDQpBRkFJQ1QgdGhlcmUgaXMgb25lIHN0cnVjdHVyZSB0
aGF0IHdvdWxkIGhhdmUgZW5kLXBhZGRpbmcuDQpCdXQgSSBkaWRuJ3QgYWN0dWFsbHkgc3BvdCBh
bnl0aGluZyB2YWxpZGF0aW5nIGl0J3MgbGVuZ3RoLg0KV2hpY2ggbWF5IHdlbGwgbWVhbiB0aGF0
IGl0IGlzIHBvc3NpYmxlIHRvIHJlYWQgb2ZmIHRoZSBlbmQNCm9mIHRoZSBVU0IgcmVjZWl2ZSBi
dWZmZXIgLSBwbGF1c2libHkgaW50byB1bm1hcHBlZCBhZGRyZXNzZXMuDQoNCkkgbG9va2VkIGJl
Y2F1c2UgYWxsIHRoZSBwYXRjaGVzIHRvICdmaXgnIHRoZSBjb21waWxlciB3YXJuaW5nDQphcmUg
ZHViaW91cy4NCk9uY2UgeW91J3ZlIGNoYW5nZWQgdGhlIG91dGVyIGFsaWdubWVudCAoZWcgb2Yg
YSB1bmlvbikgdGhlbg0KdGhlIGNvbXBpbGVyIHdpbGwgYXNzdW1lIHRoYXQgYW55IHBvaW50ZXIg
dG8gdGhhdCB1bmlvbiBpcyBhbGlnbmVkLg0KU28gYW55IF9wYWNrZWQoKSBhdHRyaWJ1dGVzIHRo
YXQgYXJlIHJlcXVpcmVkIGZvciBtaXMtYWxpZ25lZA0KYWNjZXNzZXMgZ2V0IGlnbm9yZWQgLSBi
ZWNhdXNlIHRoZSBjb21waWxlciBrbm93cyB0aGUgcG9pbnRlcg0KbXVzdCBiZSBhbGlnbmVkLg0K
DQpTbyB3aGlsZSB0aGUgY2hhbmdlcyByZW1vdmUgdGhlIHdhcm5pbmcsIHRoZXkgbWF5IGJlIHJl
bW92aW5nDQpzdXBwb3J0IGZvciBtaXNhbGlnbmVkIGFkZHJlc3Nlcy4NCg0KCURhdmlkDQoNCi0N
ClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBN
aWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxl
cykNCg==

