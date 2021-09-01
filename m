Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8E13FDFCD
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 18:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245218AbhIAQ0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 12:26:00 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:55404 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229820AbhIAQZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 12:25:59 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-34-cnJKtEYxPxeP-cHkmxaxZQ-1; Wed, 01 Sep 2021 17:24:57 +0100
X-MC-Unique: cnJKtEYxPxeP-cHkmxaxZQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 1 Sep 2021 17:24:50 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Wed, 1 Sep 2021 17:24:50 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Ahern' <dsahern@gmail.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
Subject: RE: IP routing sending local packet to gateway.
Thread-Topic: IP routing sending local packet to gateway.
Thread-Index: AdebRgbMhfPTX4NbSQqr56kVCuK30gAGAC7A///6eoD/+bbC8P/x1sKw
Date:   Wed, 1 Sep 2021 16:24:50 +0000
Message-ID: <b332ecafbd3b4be5949edae050f98882@AcuMS.aculab.com>
References: <15a53d9cc54d42dca565247363b5c205@AcuMS.aculab.com>
 <adaaf38562be4c0ba3e8fe13b90f2178@AcuMS.aculab.com>
 <532f9e8f-5e48-9e2e-c346-e2522f788a40@gmail.com>
 <b1ca6c99cd684a4a83059a0156761d75@AcuMS.aculab.com>
In-Reply-To: <b1ca6c99cd684a4a83059a0156761d75@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDMxIEF1Z3VzdCAyMDIxIDE3OjI0DQouLi4NCj4g
SSdtIHN1cmUgaXQgaGFzIHNvbWV0aGluZyB0byBkbyB3aXRoIHRoZSAnZmliX3RyaWUnIGRhdGEu
DQo+IFdoZW4gaXQgZmFpbHMgSSBnZXQ6DQo+ICMgY2F0IC9wcm9jL25ldC9maWJfdHJpZQ0KPiBJ
ZCAyMDA6DQo+ICAgfC0tIDAuMC4wLjANCj4gICAgICAvMCB1bml2ZXJzZSBVTklDQVNUDQo+IE1h
aW46DQo+ICAgKy0tIDAuMC4wLjAvMCAzIDAgNg0KPiAgICAgIHwtLSAwLjAuMC4wDQo+ICAgICAg
ICAgLzAgdW5pdmVyc2UgVU5JQ0FTVA0KPiAgICAgIHwtLSAxOTIuMTY4LjEuMA0KPiAgICAgICAg
IC8yNCBsaW5rIFVOSUNBU1QNCj4gTG9jYWw6DQo+ICAgKy0tIDAuMC4wLjAvMCAyIDAgMg0KPiAg
ICAgICstLSAxMjcuMC4wLjAvOCAyIDAgMg0KPiAgICAgICAgICstLSAxMjcuMC4wLjAvMzEgMSAw
IDANCj4gICAgICAgICAgICB8LS0gMTI3LjAuMC4wDQo+ICAgICAgICAgICAgICAgLzMyIGxpbmsg
QlJPQURDQVNUDQo+ICAgICAgICAgICAgICAgLzggaG9zdCBMT0NBTA0KPiAgICAgICAgICAgIHwt
LSAxMjcuMC4wLjENCj4gICAgICAgICAgICAgICAvMzIgaG9zdCBMT0NBTA0KPiAgICAgICAgIHwt
LSAxMjcuMjU1LjI1NS4yNTUNCj4gICAgICAgICAgICAvMzIgbGluayBCUk9BRENBU1QNCj4gICAg
ICArLS0gMTkyLjE2OC4xLjAvMjQgMiAwIDENCj4gICAgICAgICB8LS0gMTkyLjE2OC4xLjANCj4g
ICAgICAgICAgICAvMzIgbGluayBCUk9BRENBU1QNCj4gICAgICAgICB8LS0gMTkyLjE2OC4xLjk5
DQo+ICAgICAgICAgICAgLzMyIGhvc3QgTE9DQUwNCj4gICAgICAgICB8LS0gMTkyLjE2OC4xLjI1
NQ0KPiAgICAgICAgICAgIC8zMiBsaW5rIEJST0FEQ0FTVA0KDQpJJ3ZlIGZvdW5kIGEgc2NyaXB0
IHRoYXQgZ2V0cyBydW4gYWZ0ZXIgdGhlIElQIGFkZHJlc3MgYW5kIGRlZmF1bHQgcm91dGUNCmhh
dmUgYmVlbiBhZGRlZCB0aGF0IGRvZXM6DQoNCglTT1VSQ0U9MTkyLjE2OC4xLjg4DQoJR0FURVdB
WT0xOTIuMTY4LjEuMQ0KDQoJaXAgcnVsZSBhZGQgZnJvbSAiJFNPVVJDRSIgbG9va3VwIHB4MA0K
CWlwIHJ1bGUgYWRkIHRvICIkU09VUkNFIiBsb29rdXAgcHgwDQoNCglpcCByb3V0ZSBhZGQgZGVm
YXVsdCB2aWEgJHtHQVRFV0FZfSBkZXYgcHgwIHNyYyAke1NPVVJDRX0gdGFibGUgcHgwDQoNClRo
ZSAnaXAgcnVsZScgYXJlIHByb2JhYmx5IG5vdCByZWxhdGVkIChvciBuZWVkZWQpLg0KSSBzdXNw
ZWN0IHRoZXkgY2F1c2UgdHJhZmZpYyB0byB0aGUgbG9jYWwgSVAgYmUgdHJhbnNtaXR0ZWQgb24g
cHgwLg0KKFRoZXkgbWF5IGJlIGZyb20gYSBzdHJhbmdlIHNldHVwIHdlIGhhZCB3aGVyZSB0aGF0
IG1pZ2h0IGhhdmUgYmVlbiBuZWVkZWQsDQpidXQgd2h5IHNvbWV0aGluZyBmcm9tIDEwIHllYXJz
IGFnbyBhcHBlYXJlZCBpcyBiZXlvbmQgbWUgLSBhbmQgb3VyIHNvdXJjZSBjb250cm9sLikNCg0K
QW0gSSByaWdodCBpbiB0aGlua2luZyB0aGF0IHRoZSAndGFibGUgcHgwJyBiaXQgaXMgd2hhdCBj
YXVzZXMgJ0lkIDIwMCcNCmJlIGNyZWF0ZWQgYW5kIHRoYXQgaXQgd291bGQgcmVhbGx5IG5lZWQg
dGhlIG5vcm1hbCAndXNlIGFycCcgcm91dGUNCmFkZGVkIGFzIHdlbGw/DQoNClRoZXJlIGlzIGFu
IGF0dGVtcHQgYXQgc29tZSAnY2xldmVyIHJvdXRpbmcnIGluIHRoZSBzY3JpcHQuDQpBIHNlY29u
ZCBpbnRlcmZhY2UgY2FuIGJlIGNvbmZpZ3VyZWQgdGhhdCBtaWdodCBoYXZlIGl0cyBvd24NCidk
ZWZhdWx0IHJvdXRlJyAtIGJ1dCBhbGwgdGhhdCB0cmFmZmljIChhbGwgUlRQKSBpcyBzZW50IHVz
aW5nDQpyYXdpcCBhbmQgY2FuIHNlbGVjdCB0aGUgc3BlY2lmaWMgaW50ZXJmYWNlLg0KSXQgaGFz
IHRvIGJlIHNhaWQgdGhhdCBzaG91bGQgcmVhbGx5IGp1c3QgdXNlIGEgZGlmZmVyZW50IG5ldHdv
cmsNCm5hbWVzcGFjZSAtIGFuZCBpdCB3b3VsZCBhbGwgYmUgbXVjaCBzaW1wbGVyLg0KKEFzIHdl
bGwgYXMgZ2l2aW5nIHRoZSBSVFAgYWNjZXNzIHRvIGFsbCA2NGsgVURQIHBvcnQgbnVtYmVycy4p
DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9h
ZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBO
bzogMTM5NzM4NiAoV2FsZXMpDQo=

