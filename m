Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0562449DF
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 14:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgHNMlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 08:41:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:39239 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbgHNMlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 08:41:18 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-198-7PowwcmaMKaF6qjUJpCB3w-1; Fri, 14 Aug 2020 13:41:14 +0100
X-MC-Unique: 7PowwcmaMKaF6qjUJpCB3w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 14 Aug 2020 13:41:13 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 14 Aug 2020 13:41:13 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: num_ostreams and max_instreams negotiation
Thread-Topic: num_ostreams and max_instreams negotiation
Thread-Index: AdZyJ9ADjH3a7lNFS5SQSVqLsdlEogAD2k3Q
Date:   Fri, 14 Aug 2020 12:41:13 +0000
Message-ID: <c23f677ce8e14764815c83c70c6a1577@AcuMS.aculab.com>
References: <0b4319e4b2cf4ee68fc2b0183536aa7a@AcuMS.aculab.com>
In-Reply-To: <0b4319e4b2cf4ee68fc2b0183536aa7a@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBBdCBzb21lIHBvaW50IHRoZSBuZWdvdGlhdGlvbiBvZiB0aGUgbnVtYmVyIG9mIFNDVFAgc3Ry
ZWFtcw0KPiBzZWVtcyB0byBoYXZlIGdvdCBicm9rZW4uDQo+IEkndmUgZGVmaW5pdGVseSB0ZXN0
ZWQgaXQgaW4gdGhlIHBhc3QgKHByb2JhYmx5IDEwIHllYXJzIGFnbyEpDQo+IGJ1dCBvbiBhIDUu
OC4wIGtlcm5lbCBnZXRzb2Nrb3B0KFNDVFBfSU5GTykgc2VlbXMgdG8gYmUNCj4gcmV0dXJuaW5n
IHRoZSAnbnVtX29zdHJlYW1zJyBzZXQgYnkgc2V0c29ja29wdChTQ1RQX0lOSVQpDQo+IHJhdGhl
ciB0aGFuIHRoZSBzbWFsbGVyIG9mIHRoYXQgdmFsdWUgYW5kIHRoYXQgY29uZmlndXJlZA0KPiBh
dCB0aGUgb3RoZXIgZW5kIG9mIHRoZSBjb25uZWN0aW9uLg0KPiANCj4gSSdsbCBkbyBhIGJpdCBv
ZiBkaWdnaW5nLg0KDQpJIGNhbid0IGZpbmQgdGhlIGNvZGUgdGhhdCBwcm9jZXNzZXMgdGhlIGlu
aXRfYWNrLg0KQnV0IHdoZW4gc2N0cF9wcm9jc3NfaW50KCkgc2F2ZXMgdGhlIHNtYWxsZXIgdmFs
dWUNCmluIGFzb2MtPmMuc2luaW50X21heF9vc3RyZWFtcy4NCg0KQnV0IGFmZTg5OTk2MmVlMDc5
IChpZiBJJ3ZlIHR5cGVkIGl0IHJpZ2h0KSBjaGFuZ2VkDQp0aGUgdmFsdWVzIFNDVFBfSU5GTyBy
ZXBvcnRlZC4NCkFwcGFyYW50bHkgYWRkaW5nICdzY3RwIHJlY29uZmlnJyBoYWQgY2hhbmdlZCB0
aGluZ3MuDQoNClNvIEkgc3VzcGVjdCB0aGlzIGhhcyBhbGwgYmVlbiBicm9rZW4gZm9yIG92ZXIg
MyB5ZWFycy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJh
bWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0
cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

