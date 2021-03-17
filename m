Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635B533F4B3
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 16:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhCQPyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 11:54:40 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:50476 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232110AbhCQPy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 11:54:26 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-60-oQ0pwa1TOHujcwRSYTLDnQ-1; Wed, 17 Mar 2021 15:12:09 +0000
X-MC-Unique: oQ0pwa1TOHujcwRSYTLDnQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 17 Mar 2021 15:12:08 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Wed, 17 Mar 2021 15:12:08 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Guenter Roeck' <linux@roeck-us.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "dong.menglong@zte.com.cn" <dong.menglong@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
Thread-Topic: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
Thread-Index: AQHXGs5TpdCa8vtrqUa2nPH93KR5PaqISaGw
Date:   Wed, 17 Mar 2021 15:12:08 +0000
Message-ID: <a4dbb6f5b86649e2a46878eb00853f44@AcuMS.aculab.com>
References: <20210310015135.293794-1-dong.menglong@zte.com.cn>
 <20210316224820.GA225411@roeck-us.net>
 <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
 <20210317013758.GA134033@roeck-us.net>
In-Reply-To: <20210317013758.GA134033@roeck-us.net>
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

RnJvbTogR3VlbnRlciBSb2Vjaw0KPiBTZW50OiAxNyBNYXJjaCAyMDIxIDAxOjM4DQouLi4NCj4g
TVNHX0NNU0dfQ09NUEFUICgweDgwMDAwMDAwKSBpcyBzZXQgaW4gZmxhZ3MsIG1lYW5pbmcgaXRz
IHZhbHVlIGlzIG5lZ2F0aXZlLg0KPiBUaGlzIGlzIHRoZW4gZXZhbHVhdGVkIGluDQo+IA0KPiAg
ICAgICAgaWYgKGZsYWdzICYgfihNU0dfUEVFS3xNU0dfRE9OVFdBSVR8TVNHX1RSVU5DfE1TR19D
TVNHX0NPTVBBVHxNU0dfRVJSUVVFVUUpKQ0KPiAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+
IA0KPiBJZiBhbnkgb2YgdGhvc2UgZmxhZ3MgaXMgZGVjbGFyZWQgYXMgQklUKCkgYW5kIHRodXMg
bG9uZywgZmxhZ3MgaXMNCj4gc2lnbi1leHRlbmRlZCB0byBsb25nLiBTaW5jZSBpdCBpcyBuZWdh
dGl2ZSwgaXRzIHVwcGVyIDMyIGJpdHMgd2lsbCBiZSBzZXQsDQo+IHRoZSBpZiBzdGF0ZW1lbnQg
ZXZhbHVhdGVzIGFzIHRydWUsIGFuZCB0aGUgZnVuY3Rpb24gYmFpbHMgb3V0Lg0KPiANCj4gVGhp
cyBpcyByZWxhdGl2ZWx5IGVhc3kgdG8gZml4IGhlcmUgd2l0aCwgZm9yIGV4YW1wbGUsDQo+IA0K
PiAgICAgICAgIGlmICgodW5zaWduZWQgaW50KWZsYWdzICYgfihNU0dfUEVFS3xNU0dfRE9OVFdB
SVR8TVNHX1RSVU5DfE1TR19DTVNHX0NPTVBBVHxNU0dfRVJSUVVFVUUpKQ0KPiAgICAgICAgICAg
ICAgICAgZ290byBvdXQ7DQo+IA0KPiBidXQgdGhhdCBpcyBqdXN0IGEgaGFjaywgYW5kIGl0IGRv
ZXNuJ3Qgc29sdmUgdGhlIHJlYWwgcHJvYmxlbToNCj4gRWFjaCBmdW5jdGlvbiBpbiBzdHJ1Y3Qg
cHJvdG9fb3BzIHdoaWNoIHBhc3NlcyBmbGFncyBwYXNzZXMgaXQgYXMgaW50DQo+IChzZWUgaW5j
bHVkZS9saW51eC9uZXQuaDpzdHJ1Y3QgcHJvdG9fb3BzKS4gRWFjaCBzdWNoIGZ1bmN0aW9uLCBp
Zg0KPiBjYWxsZWQgd2l0aCBNU0dfQ01TR19DT01QQVQgc2V0LCB3aWxsIGZhaWwgYSBtYXRjaCBh
Z2FpbnN0DQo+IH4oTVNHX2FueXRoaW5nKSBpZiBNU0dfYW55dGhpbmcgaXMgZGVjbGFyZWQgYXMg
QklUKCkgb3IgbG9uZy4NCg0KSXNuJ3QgTVNHX0NNU0dfQ09NUEFUIGFuIGludGVybmFsIHZhbHVl
Pw0KQ291bGQgaXQgYmUgY2hhbmdlZCB0byAxdSA8PCAzMCBpbnN0ZWFkIG9mIDF1IDw8IDMxID8N
ClRoZW4gaXQgd291bGRuJ3QgbWF0dGVyIGlmIHRoZSBoaWdoIGJpdCBvZiBmbGFncyBnb3QgcmVw
bGljYXRlZC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJh
bWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0
cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

