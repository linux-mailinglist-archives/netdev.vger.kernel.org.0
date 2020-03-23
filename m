Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650AD18FAA2
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCWQ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:58:45 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:48312 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727374AbgCWQ6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 12:58:45 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-167-GzfuyjbyN3-G2xGQwmdVDQ-1; Mon, 23 Mar 2020 16:58:42 +0000
X-MC-Unique: GzfuyjbyN3-G2xGQwmdVDQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 23 Mar 2020 16:58:42 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 23 Mar 2020 16:58:42 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Ahern' <dsahern@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] Remove DST_HOST
Thread-Topic: [PATCH net-next] Remove DST_HOST
Thread-Index: AdYBH4gs8HTGreJ2SnCmnalhRsiIuQADrm8AAAFcQ3A=
Date:   Mon, 23 Mar 2020 16:58:41 +0000
Message-ID: <3316a66b025a4823887e4c34c6e2fe7e@AcuMS.aculab.com>
References: <746901f88f174ea8bda66e37f92961e6@AcuMS.aculab.com>
 <1daa5b45-1507-5899-609c-1ebbc7816db1@gmail.com>
In-Reply-To: <1daa5b45-1507-5899-609c-1ebbc7816db1@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgQWhlcm4NCj4gU2VudDogMjMgTWFyY2ggMjAyMCAxNjoxNQ0KPiBPbiAzLzIz
LzIwIDg6MzEgQU0sIERhdmlkIExhaWdodCB3cm90ZToNCj4gPiBQcmV2aW91cyBjaGFuZ2VzIHRv
IHRoZSBJUCByb3V0aW5nIGNvZGUgaGF2ZSByZW1vdmVkIGFsbCB0aGUNCj4gPiB0ZXN0cyBmb3Ig
dGhlIERTX0hPU1Qgcm91dGUgZmxhZy4NCj4gPiBSZW1vdmUgdGhlIGZsYWdzIGFuZCBhbGwgdGhl
IGNvZGUgdGhhdCBzZXRzIGl0Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogRGF2aWQgTGFpZ2h0
IDxkYXZpZC5sYWlnaHRAYWN1bGFiLmNvbT4NCj4gPiAtLS0NCj4gPiBBRkFJQ1QgdGhlIERTVF9I
T1NUIGZsYWcgaW4gcm91dGUgdGFibGUgZW50cmllcyBoYXNuJ3QgYmVlbg0KPiA+IGxvb2tlZCBh
dCBzaW5jZSB2NC4yLXJjMS4NCj4gDQo+IGV2ZW4gYmFjayBpbiA0LjE0IGl0IHdhcyBzZXQgYW5k
IG9ubHkgY2hlY2tlZCBpbiBvbmUgc3BvdCAtDQo+IGZpYjZfY29tbWl0X21ldHJpY3MuDQo+IA0K
PiA+DQo+ID4gQSBxdWljayBzZWFyY2ggZmFpbGVkIHRvIGZpbmQgdGhlIGNvbW1pdCB0aGF0IHJl
bW92ZWQgdGhlDQo+ID4gdGVzdHMgZm9yIGl0IGZyb20gaXB2Ni9yb3V0ZS5jDQo+ID4gSSBzdXNw
ZWN0IG90aGVyIGNoYW5nZXMgZ290IGFkZGVkIG9uIHRvcC4NCj4gDQo+IGJlZW4gb24gbXkgdG8t
ZG8gbGlzdCB0byB2ZXJpZnkgaXQgd2FzIG5vIGxvbmdlciBuZWVkZWQuIHRoYW5rcyBmb3Igc2Vu
ZGluZy4NCg0KSSB3YXMgdHJ5aW5nIHRvIHVucmF2ZWwgdGhhdCBjb2RlIGEgYml0IHRvIGZpbmQg
b3V0IHdoZXRoZXINCnJhdyBzb2NrZXRzIHdpdGggJ2hkcmluY2wnIGxvb2tlZCB1cCB0aGUgY29y
cmVjdCByb3V0ZSAoaWUNCnRoZSBvbmUgZnJvbSB0aGUgc2VuZHRvICdkZXN0aW5hdGlvbiBhZGRy
ZXNzJyByYXRoZXIgdGhhbg0KYW55dGhpbmcgaW4gdGhlIHN1cHBsaWVkIGlwIGhlYWRlcikuDQpU
aGUgdGVtcG9yYXJ5ICdkc3QnIHN0cnVjdHVyZXMgYXJlIGV4cGVuc2l2ZScuDQpJZiBub3RoaW5n
IGVsc2UgdGhleSBjYW4gYmUgZnJlZWQgaW1tZWRpYXRlbHkgcmF0aGVyIHRoYW4NCmFmdGVyIHJj
dS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

