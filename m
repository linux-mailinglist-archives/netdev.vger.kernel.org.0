Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFD92A418C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgKCKUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:20:01 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:21448 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbgKCKUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:20:01 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-149-EtdxkMroPCiCW3klgryENA-1; Tue, 03 Nov 2020 10:19:56 +0000
X-MC-Unique: EtdxkMroPCiCW3klgryENA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 3 Nov 2020 10:19:56 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 3 Nov 2020 10:19:56 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] drivers: net: sky2: Fix -Wstringop-truncation
 with W=1
Thread-Topic: [PATCH net-next] drivers: net: sky2: Fix -Wstringop-truncation
 with W=1
Thread-Index: AQHWsXRwPc6YJKl9qUmfj+yFNGIl5am2Mqmg
Date:   Tue, 3 Nov 2020 10:19:55 +0000
Message-ID: <c3c5682a5953429987bb5d30d631daa7@AcuMS.aculab.com>
References: <20201031174028.1080476-1-andrew@lunn.ch>
 <20201102160106.29edcc11@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102160106.29edcc11@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
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

RnJvbTogSmFrdWIgS2ljaW5za2kNCj4gU2VudDogMDMgTm92ZW1iZXIgMjAyMCAwMDowMQ0KPiAN
Cj4gT24gU2F0LCAzMSBPY3QgMjAyMCAxODo0MDoyOCArMDEwMCBBbmRyZXcgTHVubiB3cm90ZToN
Cj4gPiBJbiBmdW5jdGlvbiDigJhzdHJuY3B54oCZLA0KPiA+ICAgICBpbmxpbmVkIGZyb20g4oCY
c2t5Ml9uYW1l4oCZIGF0IGRyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvc2t5Mi5jOjQ5MDM6
MywNCj4gPiAgICAgaW5saW5lZCBmcm9tIOKAmHNreTJfcHJvYmXigJkgYXQgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWFydmVsbC9za3kyLmM6NTA0OToyOg0KPiA+IC4vaW5jbHVkZS9saW51eC9zdHJp
bmcuaDoyOTc6MzA6IHdhcm5pbmc6IOKAmF9fYnVpbHRpbl9zdHJuY3B54oCZIHNwZWNpZmllZCBi
b3VuZCAxNiBlcXVhbHMgZGVzdGluYXRpb24NCj4gc2l6ZSBbLVdzdHJpbmdvcC10cnVuY2F0aW9u
XQ0KPiA+DQo+ID4gTm9uZSBvZiB0aGUgZGV2aWNlIG5hbWVzIGFyZSAxNiBjaGFyYWN0ZXJzIGxv
bmcsIHNvIGl0IHdhcyBuZXZlciBhbg0KPiA+IGlzc3VlLCBidXQgcmVkdWNlIHRoZSBsZW5ndGgg
b2YgdGhlIGJ1ZmZlciBzaXplIGJ5IG9uZSB0byBhdm9pZCB0aGUNCj4gPiB3YXJuaW5nLg0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiA+IC0t
LQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3NreTIuYyB8IDIgKy0NCj4gPiAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9za3kyLmMgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3NreTIuYw0KPiA+IGluZGV4IDI1OTgxYTdhNDNiNS4uMzVi
MGVjNWFmZTEzIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwv
c2t5Mi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9za3kyLmMNCj4g
PiBAQCAtNDkwMCw3ICs0OTAwLDcgQEAgc3RhdGljIGNvbnN0IGNoYXIgKnNreTJfbmFtZSh1OCBj
aGlwaWQsIGNoYXIgKmJ1ZiwgaW50IHN6KQ0KPiA+ICAJfTsNCj4gPg0KPiA+ICAJaWYgKGNoaXBp
ZCA+PSBDSElQX0lEX1lVS09OX1hMICYmIGNoaXBpZCA8PSBDSElQX0lEX1lVS09OX09QXzIpDQo+
ID4gLQkJc3RybmNweShidWYsIG5hbWVbY2hpcGlkIC0gQ0hJUF9JRF9ZVUtPTl9YTF0sIHN6KTsN
Cj4gPiArCQlzdHJuY3B5KGJ1ZiwgbmFtZVtjaGlwaWQgLSBDSElQX0lEX1lVS09OX1hMXSwgc3og
LSAxKTsNCj4gDQo+IEhtLiBUaGlzIGlya3MgdGhlIGV5ZSBhIGxpdHRsZS4gQUZBSUsgdGhlIGlk
aW9tYXRpYyBjb2RlIHdvdWxkIGJlOg0KPiANCj4gCXN0cm5jcHkoYnVmLCBuYW1lLi4uLCBzeiAt
IDEpOw0KPiAJYnVmW3N6IC0gMV0gPSAnXDAnOw0KPiANCj4gUGVyaGFwcyBpdCdzIGVhc2llciB0
byBjb252ZXJ0IHRvIHN0cnNjcHkoKS9zdHJzY3B5X3BhZCgpPw0KPiANCj4gPiAgCWVsc2UNCj4g
PiAgCQlzbnByaW50ZihidWYsIHN6LCAiKGNoaXAgJSN4KSIsIGNoaXBpZCk7DQo+ID4gIAlyZXR1
cm4gYnVmOw0KDQpJcyB0aGUgcGFkIG5lZWRlZD8NCkl0IGlzbid0IHByZXNlbnQgaW4gdGhlICdl
bHNlJyBicmFuY2guDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUs
IEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJl
Z2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

