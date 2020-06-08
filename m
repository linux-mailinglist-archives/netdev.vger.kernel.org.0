Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1621F2165
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 23:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgFHVNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 17:13:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:34293 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbgFHVNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 17:13:22 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-71-YI87RbRkNr-qQv0QA8wF6w-1; Mon, 08 Jun 2020 22:13:15 +0100
X-MC-Unique: YI87RbRkNr-qQv0QA8wF6w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Jun 2020 22:13:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Jun 2020 22:13:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Michael Tuexen' <Michael.Tuexen@lurchi.franken.de>
CC:     =?utf-8?B?SXZhbiBTa3l0dGUgSsO4cmdlbnNlbg==?= <isj-sctp@i1.dk>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: packed structures used in socket options
Thread-Topic: packed structures used in socket options
Thread-Index: AQHWPLpUTq2nADe9c02l9PzEMhJDA6jNLBzwgAAGoICAAC9ugP//9FcAgABAGeCAAAZCgIABR3tggAAIYoCAAEsBgA==
Date:   Mon, 8 Jun 2020 21:13:15 +0000
Message-ID: <529a772bd3ef40d3a310e78d613339ca@AcuMS.aculab.com>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
 <B69695A1-F45B-4375-B9BB-1E50D1550C6D@lurchi.franken.de>
 <23a14b44bd5749a6b1b51150c7f3c8ba@AcuMS.aculab.com>
 <2213135.ChUyxVVRYb@isjsys>
 <cd3793726252407f8e80aa8d0025d44f@AcuMS.aculab.com>
 <7BD347D7-562F-459D-B0CB-0BC798919876@lurchi.franken.de>
In-Reply-To: <7BD347D7-562F-459D-B0CB-0BC798919876@lurchi.franken.de>
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

RnJvbTogTWljaGFlbCBUdWV4ZW4NCj4gU2VudDogMDggSnVuZSAyMDIwIDE4OjM3DQo+ID4gT24g
OC4gSnVuIDIwMjAsIGF0IDE4OjE4LCBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBBQ1VMQUIu
Q09NPiB3cm90ZToNCj4gPg0KPiA+IEZyb206IEl2YW4gU2t5dHRlIErDuHJnZW5zZW4NCj4gPj4g
U2VudDogMDcgSnVuZSAyMDIwIDIyOjM1DQo+ID4gLi4uDQo+ID4+Pj4+Pj4+IGNvbnRhaW5zOg0K
PiA+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+PiBzdHJ1Y3Qgc2N0cF9wYWRkcnBhcmFtcyB7DQo+ID4+Pj4+
Pj4+IAlzY3RwX2Fzc29jX3QJCXNwcF9hc3NvY19pZDsNCj4gPj4+Pj4+Pj4gCXN0cnVjdCBzb2Nr
YWRkcl9zdG9yYWdlCXNwcF9hZGRyZXNzOw0KPiA+Pj4+Pj4+PiAJX191MzIJCQlzcHBfaGJpbnRl
cnZhbDsNCj4gPj4+Pj4+Pj4gCV9fdTE2CQkJc3BwX3BhdGhtYXhyeHQ7DQo+ID4+Pj4+Pj4+IAlf
X3UzMgkJCXNwcF9wYXRobXR1Ow0KPiA+Pj4+Pj4+PiAJX191MzIJCQlzcHBfc2Fja2RlbGF5Ow0K
PiA+Pj4+Pj4+PiAJX191MzIJCQlzcHBfZmxhZ3M7DQo+ID4+Pj4+Pj4+IAlfX3UzMgkJCXNwcF9p
cHY2X2Zsb3dsYWJlbDsNCj4gPj4+Pj4+Pj4gCV9fdTgJCQlzcHBfZHNjcDsNCj4gPj4+Pj4+Pj4g
fSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQsIGFsaWduZWQoNCkpKTsNCj4gPj4+Pj4+Pj4NCj4gPj4+
Pj4+Pj4gVGhpcyBzdHJ1Y3R1cmUgaXMgb25seSB1c2VkIGluIHRoZSBJUFBST1RPX1NDVFAgbGV2
ZWwgc29ja2V0IG9wdGlvbiBTQ1RQX1BFRVJfQUREUl9QQVJBTVMuDQo+ID4+Pj4+Pj4+IFdoeSBp
cyBpdCBwYWNrZWQ/DQo+ID4gLi4uDQo+ID4+IEkgd2FzIGludm9sdmVkLiBBdCB0aGF0IHRpbWUg
KFNlcHRlbWJlciAyMDA1KSB0aGUgU0NUUCBBUEkgd2FzIHN0aWxsIGV2b2x2aW5nIChmaXJzdCBm
aW5hbGl6ZWQgaW4NCj4gPj4gMjAxMSksIGFuZCBvbmUgb2YgdGhlIG1ham9yIHVzZXJzIG9mIHRo
ZSBBUEkgd2FzIDMyLWJpdCBwcm9ncmFtcyBydW5uaW5nIG9uIDY0LWJpdCBrZXJuZWwgKG9uDQo+
IHBvd2VycGMNCj4gPj4gYXMgSSByZWNhbGwpLiBXaGVuIHdlIHJlYWxpemVkIHRoYXQgdGhlIHN0
cnVjdHVyZXMgd2VyZSBkaWZmZXJlbnQgYmV0d2VlbiAzMmJpdCBhbmQgNjRiaXQgd2UgaGFkIHRv
DQo+ID4+IGJyZWFrIHRoZSBsZWFzdCBudW1iZXIgb2YgcHJvZ3JhbXMsIGFuZCB0aGUgcmVzdWx0
IHdlcmUgdGhvc2UgKChwYWNrZWQpKSBzdHJ1Y3RzIHNvIDMyLWJpdCBwcm9ncmFtcw0KPiA+PiB3
b3VsZG4ndCBiZSBicm9rZW4gYW5kIHdlIGRpZG4ndCBuZWVkIGEgeHh4X2NvbXBhdCB0cmFuc2xh
dGlvbiBsYXllciBpbiB0aGUga2VybmVsLg0KPiA+DQo+ID4gSSB3YXMgYWxzbyBsb29raW5nIGF0
IGFsbCB0aGUgX191MTYgaW4gdGhhdCBoZWFkZXIgLSBib3JrZWQuDQo+ID4NCj4gPiBPaywgc28g
dGhlIGludGVudGlvbiB3YXMgdG8gYXZvaWQgcGFkZGluZyBjYXVzZWQgYnkgdGhlIGFsaWdubWVu
dA0KPiA+IG9mIHNvY2thZGRyX3N0b3JhZ2UgcmF0aGVyIHRoYW4gYXJvdW5kIHRoZSAnX191MTYg
c3BwX2ZsYWdzJy4NCj4gPg0KPiA+IEknZCBoYXZlIHRvIGxvb2sgdXAgd2hhdCAocGFja2VkLCBh
bGlnbmVkKDQpKSBhY3R1YWxseSBtZWFucy4NCj4gPiBJdCBjb3VsZCBmb3JjZSB0aGUgc3RydWN0
dXJlIHRvIGJlIGZ1bGx5IHBhY2tlZCAobm8gaG9sZXMpDQo+ID4gYnV0IGFsd2F5cyBoYXZlIGFu
IG92ZXJhbGwgYWxpZ25tZW50IG9mIDQuDQo+ID4NCj4gPiBJdCBtaWdodCBoYXZlIGJlZW4gY2xl
YXJlciB0byBwdXQgYW4gJ2FsaWduZWQoNCknIGF0dHJpYnV0ZQ0KPiA+IG9uIHRoZSBzcHBfYWRk
cmVzcyBmaWVsZCBpdHNlbGYuDQo+ID4gT3IgZXZlbiB3b25kZXIgd2hldGhlciBzb2NrYWRkcl9z
dG9yYWdlIHNob3VsZCBhY3R1YWxseQ0KPiA+IGhhdmUgOCBieXRlIGFsaWdubWVudC4NCj4gPg0K
PiA+IElmIGl0IGhhcyAxNiBieXRlIGFsaWdubWVudCB0aGVuIHlvdSBjYW5ub3QgY2FzdCBhbiBJ
UHY0DQo+ID4gc29ja2V0IGJ1ZmZlciBhZGRyZXNzICh3aGljaCB3aWxsIGJlIGF0IG1vc3QgNCBi
eXRlIGFsaWduZWQpDQo+ID4gdG8gc29ja2FkZHJfc3RvcmFnZSBhbmQgZXhwZWN0IHRoZSBjb21w
aWxlciBub3QgdG8gZ2VuZXJhdGUNCj4gPiBjb2RlIHRoYXQgd2lsbCBjcmFzaCBhbmQgYnVybiBv
biBzcGFyYzY0Lg0KDQpBY3R1YWxseSwgd2hhdCBoYXBwZW5zIHdoZW4gdGhlIG1pc2FsaWduZWQg
J3N0cnVjdCBzb2NrYWRkcicNCihpbiB0aGUgc2N0cCBvcHRpb25zKSBpcyBwYXNzZWQgdGhyb3Vn
aCB0byBhIGZ1bmN0aW9uDQp0aGF0IGV4cGVjdHMgaXQgdG8gYmUgYWxpZ25lZCBhbmQgdGhlbiBh
Y2Nlc3NlcyBwYXJ0IG9mIChzYXkpDQphbiBJUHY2IHN0cnVjdHVyZSB1c2luZyA4IGJ5dGVzIGFj
Y2Vzc2VzLg0KVGhhdCB3aWxsICdjcmFzaCBhbmQgYnVybicgb24gc3BhcmM2NCBhcyB3ZWxsLg0K
DQo+ID4gSVNUUiB0aGF0IHRoZSBOZXRCU0QgdmlldyB3YXMgdGhhdCAnc29ja2FkZHJfc3RvcmFn
ZScgc2hvdWxkDQo+ID4gbmV2ZXIgYWN0dWFsbHkgYmUgaW5zdGFudGlhdGVkIC0gaXQgb25seSBl
eGlzdGVkIGFzIGEgdHlwZWQNCj4gPiBwb2ludGVyLg0KPg0KPiBOb3Qgc3VyZSB0aGlzIGlzIGNv
cnJlY3QuIEkgd291bGQgc2F5IHRoaXMgYXBwbGllcyB0byBzdHVjdCBzb2NrYWRkciAqLg0KPiBJ
IGhhdmUgc2VlbiBpbnN0YW50aWF0ZWQgc29ja2FkZHJfc3RvcmFnZSB2YXJpYWJsZSBpbiBnZW5l
cmljIGNvZGUsDQo+IHdoZXJlIHlvdSBuZWVkIHRvIHByb3ZpZGUgZW5vdWdoIHNwYWNlIHRvIGhv
bGQgYW4gYWRkcmVzcywgbm90IHlldA0KPiBrbm93aW5nIHRoZSBhZGRyZXNzIGZhbWlseS4gSG93
ZXZlciwgSSdtIG5vdCBmYW1pbGlhciB3aXRoIHRoZSBOZXRCU0QNCj4gY29kZSBiYXNlLg0KDQpC
YXNpY2FsbHkgeW91IHNob3VsZCBhbHdheXMgaGF2ZSB0aGUgYWRkcmVzcyBsZW5ndGguDQpJIGp1
c3QgcmVtZW1iZXIgQ2hyaXN0b3MgY29tcGxhaW5pbmcgYWJvdXQgc29tZSBrZXJuZWwgY29kZQ0K
dGhhdCBhbGxvY2F0ZWQgb25lIG9uIHN0YWNrLg0KKE15IE5ldEJTRCAnY29tbWl0IGJpdCcgaGFz
IHJhdGhlciBsYXBzZWQuKQ0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

