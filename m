Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BADC47A0CC
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 15:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhLSOEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 09:04:20 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:28977 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235890AbhLSOEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 09:04:13 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-281-UDWdNUDTNgaebzpPJPcDfQ-1; Sun, 19 Dec 2021 14:04:09 +0000
X-MC-Unique: UDWdNUDTNgaebzpPJPcDfQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Sun, 19 Dec 2021 14:04:08 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Sun, 19 Dec 2021 14:04:08 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Lee Jones' <lee.jones@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Vlad Yasevich" <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] sctp: export sctp_endpoint_{hold,put}() and return
 incremented endpoint
Thread-Topic: [PATCH v2 1/2] sctp: export sctp_endpoint_{hold,put}() and
 return incremented endpoint
Thread-Index: AQHX80yDhnx49qqwrkWmSXPA3hUXMKw2ugEAgAAGAoCAAxo9gA==
Date:   Sun, 19 Dec 2021 14:04:08 +0000
Message-ID: <20ea50c910654fa0abc601bbddc37eaf@AcuMS.aculab.com>
References: <20211217134607.74983-1-lee.jones@linaro.org>
 <1458e6e239e2493e9147fd95ec32d9fd@AcuMS.aculab.com>
 <YbygIz4oqlTkrQgD@google.com>
In-Reply-To: <YbygIz4oqlTkrQgD@google.com>
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

RnJvbTogTGVlIEpvbmVzDQo+IFNlbnQ6IDE3IERlY2VtYmVyIDIwMjEgMTQ6MzUNCj4gDQo+IE9u
IEZyaSwgMTcgRGVjIDIwMjEsIERhdmlkIExhaWdodCB3cm90ZToNCj4gDQo+ID4gRnJvbTogTGVl
IEpvbmVzDQo+ID4gPiBTZW50OiAxNyBEZWNlbWJlciAyMDIxIDEzOjQ2DQo+ID4gPg0KPiA+ID4g
bmV0L3NjdHAvZGlhZy5jIGZvciBpbnN0YW5jZSBpcyBidWlsdCBpbnRvIGl0cyBvd24gc2VwYXJh
dGUgbW9kdWxlDQo+ID4gPiAoc2N0cF9kaWFnLmtvKSBhbmQgcmVxdWlyZXMgdGhlIHVzZSBvZiBz
Y3RwX2VuZHBvaW50X3tob2xkLHB1dH0oKSBpbg0KPiA+ID4gb3JkZXIgdG8gcHJldmVudCBhIHJl
Y2VudGx5IGZvdW5kIHVzZS1hZnRlci1mcmVlIGlzc3VlLg0KPiA+ID4NCj4gPiA+IEluIG9yZGVy
IHRvIHByZXZlbnQgZGF0YSBjb3JydXB0aW9uIG9mIHRoZSBwb2ludGVyIHVzZWQgdG8gdGFrZSBh
DQo+ID4gPiByZWZlcmVuY2Ugb24gYSBzcGVjaWZpYyBlbmRwb2ludCwgYmV0d2VlbiB0aGUgdGlt
ZSBvZiBjYWxsaW5nDQo+ID4gPiBzY3RwX2VuZHBvaW50X2hvbGQoKSBhbmQgaXQgcmV0dXJuaW5n
LCB0aGUgQVBJIG5vdyByZXR1cm5zIGEgcG9pbnRlcg0KPiA+ID4gdG8gdGhlIGV4YWN0IGVuZHBv
aW50IHRoYXQgd2FzIGluY3JlbWVudGVkLg0KPiA+ID4NCj4gPiA+IEZvciBleGFtcGxlLCBpbiBz
Y3RwX3NvY2tfZHVtcCgpLCB3ZSBjb3VsZCBoYXZlIHRoZSBmb2xsb3dpbmcgaHVuazoNCj4gPiA+
DQo+ID4gPiAJc2N0cF9lbmRwb2ludF9ob2xkKHRzcC0+YXNvYy0+ZXApOw0KPiA+ID4gCWVwID0g
dHNwLT5hc29jLT5lcDsNCj4gPiA+IAlzayA9IGVwLT5iYXNlLnNrDQo+ID4gPiAJbG9ja19zb2Nr
KGVwLT5iYXNlLnNrKTsNCj4gPiA+DQo+ID4gPiBJdCBpcyBwb3NzaWJsZSBmb3IgdGhpcyB0YXNr
IHRvIGJlIHN3YXBwZWQgb3V0IGltbWVkaWF0ZWx5IGZvbGxvd2luZw0KPiA+ID4gdGhlIGNhbGwg
aW50byBzY3RwX2VuZHBvaW50X2hvbGQoKSB0aGF0IHdvdWxkIGNoYW5nZSB0aGUgYWRkcmVzcyBv
Zg0KPiA+ID4gdHNwLT5hc29jLT5lcCB0byBwb2ludCB0byBhIGNvbXBsZXRlbHkgZGlmZmVyZW50
IGVuZHBvaW50LiAgVGhpcyBtZWFucw0KPiA+ID4gYSByZWZlcmVuY2UgY291bGQgYmUgdGFrZW4g
dG8gdGhlIG9sZCBlbmRwb2ludCBhbmQgdGhlIG5ldyBvbmUgd291bGQNCj4gPiA+IGJlIHByb2Nl
c3NlZCB3aXRob3V0IGEgcmVmZXJlbmNlIHRha2VuLCBtb3Jlb3ZlciB0aGUgbmV3IGVuZHBvaW50
DQo+ID4gPiBjb3VsZCB0aGVuIGJlIGZyZWVkIHdoaWxzdCBzdGlsbCBwcm9jZXNzaW5nIGFzIGEg
cmVzdWx0LCBjYXVzaW5nIGENCj4gPiA+IHVzZS1hZnRlci1mcmVlLg0KPiA+ID4NCj4gPiA+IElm
IHdlIHJldHVybiB0aGUgZXhhY3QgcG9pbnRlciB0aGF0IHdhcyBoZWxkLCB3ZSBlbnN1cmUgdGhp
cyB0YXNrDQo+ID4gPiBwcm9jZXNzZXMgb25seSB0aGUgZW5kcG9pbnQgd2UgaGF2ZSB0YWtlbiBh
IHJlZmVyZW5jZSB0by4gIFRoZQ0KPiA+ID4gcmVzdWx0YW50IGh1bmsgbm93IGxvb2tzIGxpa2Ug
dGhpczoNCj4gPiA+DQo+ID4gPiAJZXAgPSBzY3RwX2VuZHBvaW50X2hvbGQodHNwLT5hc29jLT5l
cCk7DQo+ID4gPiAJc2sgPSBlcC0+YmFzZS5zaw0KPiA+ID4gCWxvY2tfc29jayhzayk7DQo+ID4N
Cj4gPiBJc24ndCB0aGF0IGp1c3QgdGhlIHNhbWUgYXMgZG9pbmcgdGhpbmdzIGluIHRoZSBvdGhl
ciBvcmRlcj8NCj4gPiAJZXAgPSB0c3AtPmFzb2MtPmVwOw0KPiA+IAlzY3RwX2VuZHBvaW50X2hv
bGQoZXApOw0KPiANCj4gU2xlZXAgZm9yIGEgZmV3IG1pbGxpc2Vjb25kcyBiZXR3ZWVuIHRob3Nl
IGxpbmVzIGFuZCBzZWUgd2hhdCBoYXBwZW5zLg0KPiANCj4gJ2VwJyBjb3VsZCBzdGlsbCBiZSBm
cmVlZCBiZXR3ZWVuIHRoZSBhc3NpZ25tZW50IGFuZCB0aGUgY2FsbC4NCg0KSXQgY2FuIGFsc28g
YmUgZnJlZWQgaGFsZiB3YXkgdGhyb3VnaCBzZXR0aW5nIHVwIHRoZSBhcmd1bWVudHMgdG8gdGhl
IGNhbGwuDQpTbyBhbnkgY2FsbDoNCgkJeHh4KHRzcC0+YXNvYy0+ZXApOw0KaXMgb25seSByZWFs
bHkgdmFsaWQgaWYgYm90aCB0c3AtPmFzb2MgYW5kIGFzb2MtPmVwIGFyZSBzdGFibGUuDQpTbyBp
dCBpcyBleGFjdGx5IHRoZSBzYW1lIGFzIGRvaW5nOg0KCQllcCA9IHRzcC0+YXNvYy0+ZXA7DQoJ
CXh4eChlcCk7DQpSZXR1cm5pbmcgdGhlIHZhbHVlIG9mIHRoZSBhcmd1bWVudCBkb2Vzbid0IGhl
bHAgaWYgYW55IG9mIHRoZSBwb2ludGVkLXRvDQppdGVtcyBjYW4gZ2V0IGZyZWVkLg0KDQoJRGF2
aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50
IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTcz
ODYgKFdhbGVzKQ0K

