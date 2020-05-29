Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AB01E7D6A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgE2Mlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:41:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:44686 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgE2Mln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 08:41:43 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-249-k5q8BMcSNT2HYanjrWyQ4g-1; Fri, 29 May 2020 13:41:39 +0100
X-MC-Unique: k5q8BMcSNT2HYanjrWyQ4g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 29 May 2020 13:41:38 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 29 May 2020 13:41:38 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "brakmo@fb.com" <brakmo@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH bpf-next] bpf: add SO_KEEPALIVE and related options to
 bpf_setsockopt
Thread-Topic: [PATCH bpf-next] bpf: add SO_KEEPALIVE and related options to
 bpf_setsockopt
Thread-Index: AQHWNEXlTLQiJyKpQ0mQqi8tviwX6qi/A7fg
Date:   Fri, 29 May 2020 12:41:38 +0000
Message-ID: <733bf731f95940a495830f3997307eaf@AcuMS.aculab.com>
References: <20200527150543.93335-1-zeil@yandex-team.ru>
 <b5133e4e-4562-1ea0-9d46-c5fb74528ec8@gmail.com>
In-Reply-To: <b5133e4e-4562-1ea0-9d46-c5fb74528ec8@gmail.com>
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

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDI3IE1heSAyMDIwIDE3OjQzDQo+IA0KPiBPbiA1
LzI3LzIwIDg6MDUgQU0sIERtaXRyeSBZYWt1bmluIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggYWRk
cyBzdXBwb3J0IG9mIFNPX0tFRVBBTElWRSBmbGFnIGFuZCBUQ1AgcmVsYXRlZCBvcHRpb25zDQo+
ID4gdG8gYnBmX3NldHNvY2tvcHQoKSByb3V0aW5lLiBUaGlzIGlzIGhlbHBmdWwgaWYgd2Ugd2Fu
dCB0byBlbmFibGUgb3IgdHVuZQ0KPiA+IFRDUCBrZWVwYWxpdmUgZm9yIGFwcGxpY2F0aW9ucyB3
aGljaCBkb24ndCBkbyBpdCBpbiB0aGUgdXNlcnNwYWNlIGNvZGUuDQo+ID4gSW4gb3JkZXIgdG8g
YXZvaWQgY29weS1wYXN0ZSwgY29tbW9uIGNvZGUgZnJvbSBjbGFzc2ljIHNldHNvY2tvcHQgd2Fz
IG1vdmVkDQo+ID4gdG8gYXV4aWxpYXJ5IGZ1bmN0aW9ucyBpbiB0aGUgaGVhZGVycy4NCj4gDQo+
IA0KPiBQbGVhc2Ugc3BsaXQgdGhpcyBpbiB0d28gcGF0Y2hlcyA6DQo+IC0gb25lIGFkZGluZyB0
aGUgaGVscGVycywgYSBwdXJlIFRDUCBwYXRjaC4NCj4gLSBvbmUgZm9yIEJQRiBhZGRpdGlvbnMu
DQo+IA0KLi4uDQo+ID4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL2ZpbHRlci5jIGIvbmV0L2NvcmUv
ZmlsdGVyLmMNCj4gPiBpbmRleCBhNmZjMjM0Li4xMDM1ZTQzIDEwMDY0NA0KPiA+IC0tLSBhL25l
dC9jb3JlL2ZpbHRlci5jDQo+ID4gKysrIGIvbmV0L2NvcmUvZmlsdGVyLmMNCi4uLg0KPiA+ICsJ
CQljYXNlIFRDUF9LRUVQSURMRToNCj4gPiArCQkJCWlmICh2YWwgPCAxIHx8IHZhbCA+IE1BWF9U
Q1BfS0VFUElETEUpDQo+ID4gKwkJCQkJcmV0ID0gLUVJTlZBTDsNCj4gPiArCQkJCWVsc2UNCj4g
PiArCQkJCQlrZWVwYWxpdmVfdGltZV9zZXQodHAsIHZhbCk7DQo+ID4gKwkJCQlicmVhazsNCj4g
PiArCQkJY2FzZSBUQ1BfS0VFUElOVFZMOg0KPiA+ICsJCQkJaWYgKHZhbCA8IDEgfHwgdmFsID4g
TUFYX1RDUF9LRUVQSU5UVkwpDQo+ID4gKwkJCQkJcmV0ID0gLUVJTlZBTDsNCj4gPiArCQkJCWVs
c2UNCj4gPiArCQkJCQl0cC0+a2VlcGFsaXZlX2ludHZsID0gdmFsICogSFo7DQo+ID4gKwkJCQli
cmVhazsNCj4gPiArCQkJY2FzZSBUQ1BfS0VFUENOVDoNCj4gPiArCQkJCWlmICh2YWwgPCAxIHx8
IHZhbCA+IE1BWF9UQ1BfS0VFUENOVCkNCj4gPiArCQkJCQlyZXQgPSAtRUlOVkFMOw0KPiA+ICsJ
CQkJZWxzZQ0KPiA+ICsJCQkJCXRwLT5rZWVwYWxpdmVfcHJvYmVzID0gdmFsOw0KPiA+ICsJCQkJ
YnJlYWs7DQo+ID4gKwkJCWNhc2UgVENQX1NZTkNOVDoNCj4gPiArCQkJCWlmICh2YWwgPCAxIHx8
IHZhbCA+IE1BWF9UQ1BfU1lOQ05UKQ0KPiA+ICsJCQkJCXJldCA9IC1FSU5WQUw7DQo+ID4gKwkJ
CQllbHNlDQo+ID4gKwkJCQkJaWNzay0+aWNza19zeW5fcmV0cmllcyA9IHZhbDsNCj4gPiArCQkJ
CWJyZWFrOw0KPiA+ICsJCQljYXNlIFRDUF9VU0VSX1RJTUVPVVQ6DQo+ID4gKwkJCQlpZiAodmFs
IDwgMCkNCj4gPiArCQkJCQlyZXQgPSAtRUlOVkFMOw0KPiA+ICsJCQkJZWxzZQ0KPiA+ICsJCQkJ
CWljc2stPmljc2tfdXNlcl90aW1lb3V0ID0gdmFsOw0KPiA+ICsJCQkJYnJlYWs7DQoNCkl0IGFs
c28gY2Fubm90IGJlIHJpZ2h0IHRvIGJlIGxheWVyIGJyZWFraW5nIGxpa2UgdGhpcw0KYW5kIGRp
cmVjdGx5IGFjY2Vzc2luZyB0aGUgcHJvdG9jb2wgc29ja2V0IGludGVybmFscy4NCg0KQXQgbGVh
c3QgYSBrZXJuZWxfc2V0c29ja29wdCgpIGZ1bmN0aW9uIGtlZXBzIHRoaXMgc2VwYXJhdGUNCmFu
ZCBlbnN1cmVzIHRoYXQgdGhlIHNvY2tldCB0eXBlIGlzIGNvcnJlY3QuDQoNCglEYXZpZA0KDQot
DQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwg
TWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2Fs
ZXMpDQo=

