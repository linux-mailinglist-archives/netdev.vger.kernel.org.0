Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787112A91C9
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgKFIsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:48:53 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:35585 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgKFIsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:48:52 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-113-DayvrsIxPBecSkDdjKOROQ-1; Fri, 06 Nov 2020 08:48:48 +0000
X-MC-Unique: DayvrsIxPBecSkDdjKOROQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 6 Nov 2020 08:48:47 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 6 Nov 2020 08:48:47 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        "Lee Jones" <lee.jones@linaro.org>
Subject: RE: [PATCH net-next v2 1/7] drivers: net: smc91x: Fix set but unused
 W=1 warning
Thread-Topic: [PATCH net-next v2 1/7] drivers: net: smc91x: Fix set but unused
 W=1 warning
Thread-Index: AQHWs8RIsLQXTg3BjUib5tEgD+0g66m6yq0w
Date:   Fri, 6 Nov 2020 08:48:47 +0000
Message-ID: <749857e283f04d3b8f84f603fa065cd6@AcuMS.aculab.com>
References: <20201104154858.1247725-1-andrew@lunn.ch>
        <20201104154858.1247725-2-andrew@lunn.ch>
 <20201105143742.047959ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201105143742.047959ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

RnJvbTogSmFrdWIgS2ljaW5za2kNCj4gU2VudDogMDUgTm92ZW1iZXIgMjAyMCAyMjozOA0KPiBP
biBXZWQsICA0IE5vdiAyMDIwIDE2OjQ4OjUyICswMTAwIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3Ntc2Mvc21jOTF4LmM6NzA2OjUxOiB3YXJuaW5nOiB2YXJp
YWJsZSDigJhwa3RfbGVu4oCZIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLQ0KPiBidXQtc2V0
LXZhcmlhYmxlXQ0KPiA+ICAgNzA2IHwgIHVuc2lnbmVkIGludCBzYXZlZF9wYWNrZXQsIHBhY2tl
dF9ubywgdHhfc3RhdHVzLCBwa3RfbGVuOw0KPiA+DQo+ID4gQWRkIGEgbmV3IG1hY3JvIGZvciBn
ZXR0aW5nIGZpZWxkcyBvdXQgb2YgdGhlIGhlYWRlciwgd2hpY2ggb25seSBnZXRzDQo+ID4gdGhl
IHN0YXR1cywgbm90IHRoZSBsZW5ndGggd2hpY2ggaW4gdGhpcyBjYXNlIGlzIG5vdCBuZWVkZWQu
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+
IA0KPiBTb3JyeSBJIG1pc3NlZCBzb21ldGhpbmcgb24gdjENCj4gDQo+ID4gKyNkZWZpbmUgU01D
X0dFVF9QS1RfSERSX1NUQVRVUyhscCwgc3RhdHVzKQkJCQlcDQo+ID4gKwlkbyB7CQkJCQkJCQlc
DQo+ID4gKwkJaWYgKFNNQ18zMkJJVChscCkpIHsJCQkJCVwNCj4gPiArCQkJdW5zaWduZWQgaW50
IF9fdmFsID0gU01DX2lubChpb2FkZHIsIERBVEFfUkVHKGxwKSk7IFwNCj4gPiArCQkJKHN0YXR1
cykgPSBfX3ZhbCAmIDB4ZmZmZjsJCQlcDQo+ID4gKwkJfSBlbHNlIHsJCQkJCQlcDQo+ID4gKwkJ
CShzdGF0dXMpID0gU01DX2ludyhpb2FkZHIsIERBVEFfUkVHKGxwKSk7CVwNCj4gPiArCQl9CQkJ
CQkJCVwNCj4gPiArCX0gd2hpbGUgKDApDQo+IA0KPiBUaGlzIGlzIHRoZSBvcmlnaW5hbC9mdWxs
IG1hY3JvOg0KPiANCj4gI2RlZmluZSBTTUNfR0VUX1BLVF9IRFIobHAsIHN0YXR1cywgbGVuZ3Ro
KQkJCQlcDQo+IAlkbyB7CQkJCQkJCQlcDQo+IAkJaWYgKFNNQ18zMkJJVChscCkpIHsJCQkJXA0K
PiAJCQl1bnNpZ25lZCBpbnQgX192YWwgPSBTTUNfaW5sKGlvYWRkciwgREFUQV9SRUcobHApKTsg
XA0KPiAJCQkoc3RhdHVzKSA9IF9fdmFsICYgMHhmZmZmOwkJCVwNCj4gCQkJKGxlbmd0aCkgPSBf
X3ZhbCA+PiAxNjsJCQkJXA0KPiAJCX0gZWxzZSB7CQkJCQkJXA0KPiAJCQkoc3RhdHVzKSA9IFNN
Q19pbncoaW9hZGRyLCBEQVRBX1JFRyhscCkpOwlcDQo+IAkJCShsZW5ndGgpID0gU01DX2ludyhp
b2FkZHIsIERBVEFfUkVHKGxwKSk7CVwNCj4gCQl9CQkJCQkJCVwNCj4gCX0gd2hpbGUgKDApDQo+
IA0KPiBOb3RlIHRoYXQgaXQgcmVhZHMgdGhlIHNhbWUgYWRkcmVzcyB0d2ljZSBpbiB0aGUgZWxz
ZSBicmFuY2guDQo+IA0KPiBJJ20gOTAlIHN1cmUgd2UgY2FuJ3QgcmVtb3ZlIHRoZSByZWFkIGhl
cmUgZWl0aGVyIHNvIGJlc3QgdHJlYXQgaXQNCj4gbGlrZSB0aGUgb25lcyBpbiBwYXRjaCAzLCBy
aWdodD8NCg0KT25lIG9mIHRoZSB0d28gU01DX2ludygpIG5lZWRzIHRvIHVzZSAnaW9hZGRyICsg
MicuDQpQcm9iYWJseSB0aGUgb25lIGZvciAobGVuZ3RoKS4NCg0KVGhlIGNvZGUgbWF5IGFsc28g
YmUgYnVnZ3kgb24gQkUgc3lzdGVtcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVz
cyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEg
MVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

