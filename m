Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D872A80B9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 15:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbgKEOVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 09:21:01 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:33284 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728371AbgKEOVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 09:21:01 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-184-tq6AhFg1PzKetDtINwwp3Q-1; Thu, 05 Nov 2020 14:20:57 +0000
X-MC-Unique: tq6AhFg1PzKetDtINwwp3Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 5 Nov 2020 14:20:56 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 5 Nov 2020 14:20:56 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Heiner Kallweit' <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "Realtek linux nic maintainers" <nic_swsd@realtek.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] r8169: disable hw csum for short packets and chip
 versions with hw padding bug
Thread-Topic: [PATCH net] r8169: disable hw csum for short packets and chip
 versions with hw padding bug
Thread-Index: AQHWs3u0hhejhqJ3R0Win5AW1pXPBKm5lgJw
Date:   Thu, 5 Nov 2020 14:20:56 +0000
Message-ID: <1a20cb5755db4916b873d88460ccf19e@AcuMS.aculab.com>
References: <e82f7f4d-8d45-1e7c-a2ef-5a8bfc3992c6@gmail.com>
In-Reply-To: <e82f7f4d-8d45-1e7c-a2ef-5a8bfc3992c6@gmail.com>
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

RnJvbTogSGVpbmVyIEthbGx3ZWl0DQo+IFNlbnQ6IDA1IE5vdmVtYmVyIDIwMjAgMTM6NTgNCj4g
DQo+IFJUTDgxMjVCIGhhcyBzYW1lIG9yIHNpbWlsYXIgc2hvcnQgcGFja2V0IGh3IHBhZGRpbmcg
YnVnIGFzIFJUTDgxNjhldmwuDQo+IFRoZSBtYWluIHdvcmthcm91bmQgaGFzIGJlZW4gZXh0ZW5k
ZWQgYWNjb3JkaW5nbHksIGhvd2V2ZXIgd2UgaGF2ZSB0bw0KPiBkaXNhYmxlIGFsc28gaHcgY2hl
Y2tzdW1taW5nIGZvciBzaG9ydCBwYWNrZXRzIG9uIGFmZmVjdGVkIG5ldyBjaGlwDQo+IHZlcnNp
b25zLiBDaGFuZ2UgdGhlIGNvZGUgaW4gYSB3YXkgdGhhdCBpbiBjYXNlIG9mIGZ1cnRoZXIgYWZm
ZWN0ZWQNCj4gY2hpcCB2ZXJzaW9ucyB3ZSBoYXZlIHRvIGFkZCB0aGVtIGluIG9uZSBwbGFjZSBv
bmx5Lg0KDQpXaHkgbm90IGp1c3QgZGlzYWJsZSBodyBjaGVja3N1bW1pbmcgZm9yIHNob3J0IHBh
Y2tldHMgb24NCmFsbCBkZXZpY2VzICh0aGF0IHVzZSB0aGlzIGRyaXZlcikuDQoNCkl0IGNhbid0
IG1ha2UgbXVjaCBkaWZmZXJlbmNlIHRvIHRoZSBwZXJmb3JtYW5jZS4NClRoZSBsYWNrIG9mIGNv
bmRpdGlvbmFscyBtYXkgZXZlbiBtYWtlIGl0IGZhc3Rlci4NCg0KCURhdmlkDQoNCi0NClJlZ2lz
dGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24g
S2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

