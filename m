Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3BE3FEA9E
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 10:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244361AbhIBI3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 04:29:00 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:37605 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233546AbhIBI27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 04:28:59 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-186-MeFaDgDnNiWxWafPYWD99g-1; Thu, 02 Sep 2021 09:27:59 +0100
X-MC-Unique: MeFaDgDnNiWxWafPYWD99g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Thu, 2 Sep 2021 09:27:58 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Thu, 2 Sep 2021 09:27:58 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Ahern' <dsahern@gmail.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: RE: IP routing sending local packet to gateway.
Thread-Topic: IP routing sending local packet to gateway.
Thread-Index: AdebRgbMhfPTX4NbSQqr56kVCuK30gAGAC7A///6eoD/+bbC8P/x1sKwgB0DIQD//6CM8A==
Date:   Thu, 2 Sep 2021 08:27:58 +0000
Message-ID: <dec7285c174e4299bb90dfe81952c68a@AcuMS.aculab.com>
References: <15a53d9cc54d42dca565247363b5c205@AcuMS.aculab.com>
 <adaaf38562be4c0ba3e8fe13b90f2178@AcuMS.aculab.com>
 <532f9e8f-5e48-9e2e-c346-e2522f788a40@gmail.com>
 <b1ca6c99cd684a4a83059a0156761d75@AcuMS.aculab.com>
 <b332ecafbd3b4be5949edae050f98882@AcuMS.aculab.com>
 <36d69eb1-fdb0-772e-4d3c-33ebead92b0a@gmail.com>
In-Reply-To: <36d69eb1-fdb0-772e-4d3c-33ebead92b0a@gmail.com>
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

RnJvbTogRGF2aWQgQWhlcm4NCj4gU2VudDogMDIgU2VwdGVtYmVyIDIwMjEgMDQ6MzgNCj4gDQo+
IE9uIDkvMS8yMSA5OjI0IEFNLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gSSd2ZSBmb3VuZCBh
IHNjcmlwdCB0aGF0IGdldHMgcnVuIGFmdGVyIHRoZSBJUCBhZGRyZXNzIGFuZCBkZWZhdWx0IHJv
dXRlDQo+ID4gaGF2ZSBiZWVuIGFkZGVkIHRoYXQgZG9lczoNCj4gPg0KPiA+IAlTT1VSQ0U9MTky
LjE2OC4xLjg4DQo+ID4gCUdBVEVXQVk9MTkyLjE2OC4xLjENCj4gPg0KPiA+IAlpcCBydWxlIGFk
ZCBmcm9tICIkU09VUkNFIiBsb29rdXAgcHgwDQo+ID4gCWlwIHJ1bGUgYWRkIHRvICIkU09VUkNF
IiBsb29rdXAgcHgwDQo+ID4NCj4gPiAJaXAgcm91dGUgYWRkIGRlZmF1bHQgdmlhICR7R0FURVdB
WX0gZGV2IHB4MCBzcmMgJHtTT1VSQ0V9IHRhYmxlIHB4MA0KPiA+DQo+ID4gVGhlICdpcCBydWxl
JyBhcmUgcHJvYmFibHkgbm90IHJlbGF0ZWQgKG9yIG5lZWRlZCkuDQo+ID4gSSBzdXNwZWN0IHRo
ZXkgY2F1c2UgdHJhZmZpYyB0byB0aGUgbG9jYWwgSVAgYmUgdHJhbnNtaXR0ZWQgb24gcHgwLg0K
PiA+IChUaGV5IG1heSBiZSBmcm9tIGEgc3RyYW5nZSBzZXR1cCB3ZSBoYWQgd2hlcmUgdGhhdCBt
aWdodCBoYXZlIGJlZW4gbmVlZGVkLA0KPiA+IGJ1dCB3aHkgc29tZXRoaW5nIGZyb20gMTAgeWVh
cnMgYWdvIGFwcGVhcmVkIGlzIGJleW9uZCBtZSAtIGFuZCBvdXIgc291cmNlIGNvbnRyb2wuKQ0K
PiA+DQo+ID4gQW0gSSByaWdodCBpbiB0aGlua2luZyB0aGF0IHRoZSAndGFibGUgcHgwJyBiaXQg
aXMgd2hhdCBjYXVzZXMgJ0lkIDIwMCcNCj4gPiBiZSBjcmVhdGVkIGFuZCB0aGF0IGl0IHdvdWxk
IHJlYWxseSBuZWVkIHRoZSBub3JtYWwgJ3VzZSBhcnAnIHJvdXRlDQo+ID4gYWRkZWQgYXMgd2Vs
bD8NCj4gPg0KPiANCj4gdGhpcyBpcyB3aHkgdGhlIGZpYiB0cmFjZXBvaW50IGV4aXN0cy4gSXQg
c2hvd3Mgd2hhdCBpcyBoYXBwZW5pbmcgYXQgdGhlDQo+IHRpbWUgb2YgdGhlIGZpYiBsb29rdXAg
LSBpbnB1dHMgYW5kIGxvb2t1cCByZXN1bHRzIChndywgZGV2aWNlKSAtIHdoaWNoDQo+IGdpdmUg
dGhlIGNsdWUgYXMgdG8gd2h5IHRoZSBwYWNrZXQgd2VudCB0aGUgZGlyZWN0aW9uIGl0IGRpZC4N
Cg0KVGhleSBtb3N0bHkgZ2F2ZSBtZSBhIGhpbnQgYXMgdG8gd2hlcmUgdG8gbG9vay4NClRoZXJl
IGFyZSBkZWZpbml0ZWx5IHNvbWUgY29kZSBwYXRocyB3aGVyZSBhIGZpYiBlbnRyeSBpcw0KaWdu
b3JlZCAoYW5kIGl0IGNvbnRpbnVlcyB0byBzZWFyY2gpIHRoYXQgY291bGQgZG8gd2l0aCB0cmFj
aW5nLg0KDQpCdXQgSSBoYWQgdG8gYWRkIGV4dHJhIHRyYWNlcyB0byB0aGUgJ3JvdXRlIGFkZCcg
cGF0aHMgdG8NCmZpbmQgd2hhdCB3YXMgYWRkaW5nIHRoZSBleHRyYSBmaWIgdGFibGUuDQpGb3J0
dW5hdGVseSBJJ3ZlIGdvdCBhIHNlcmlhbCBjb25zb2xlIHNldHVwIChpbnRvIHB1dHR5KQ0Kc28g
SSBzZXR1cCBmdHJhY2UgYmVmb3JlIHRoZSBuZXR3b3JrIGNvbmZpZyBhY3R1YWxseSBoYXBwZW5z
Lg0KDQpBbnl3YXkgdGhlIHNjcmlwdCBpcyB0cnlpbmcgdG8gZG8gc29tZXRoaW5nIHRoYXQgd291
bGQgYmUNCmJldHRlciBkb25lIHdpdGggYSBuZXR3b3JrIG5hbWVzcGFjZS4NCg0KVGhhbmtzIGZv
ciB0aGUgcG9pbnRlcnMuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNp
ZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsN
ClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

