Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 959DE7EBD3
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 07:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732575AbfHBFLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 01:11:40 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:47686 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfHBFLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 01:11:39 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 39DDE886BF;
        Fri,  2 Aug 2019 17:11:36 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1564722696;
        bh=tC4vIW4Ii5JkgwtqbHGlUUwX7EbA4mh0QRIQ43Vafq4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=fKaf9cXxDgaQ0QIN/wqSmb/N28WoKrk1g8FJteMa1kN19HYshhpYj7xlQnPJlwyoD
         HRyMCqjAvXqAKWzlpUh9BFfFm94amEVTysH42bUVyYzBCTnLMT2mdiYa1cUkIXyscX
         iKG0lSWjODWXJXPzzraB+cAMZHZ+xSJa23PBFBXa+gKfgJFZT1WSHUMBfCYsg7ToO8
         h7+fBkr25ncX538JB29bquq70T1JnoqeSvnXzoomm2Adk1RX/CzbmWMjmnbQHevEY4
         SAWtqkguTw1rPdrnguTdXq0GYYaDCMb6SfLss3MzySlRrIZDAIV8aTH12RdXEmj+oI
         JaPbU2ivfudiQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d43c6080000>; Fri, 02 Aug 2019 17:11:36 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1156.6; Fri, 2 Aug 2019 17:11:30 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Fri, 2 Aug 2019 17:11:30 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "jon.maloy@ericsson.com" <jon.maloy@ericsson.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Slowness forming TIPC cluster with explicit node addresses
Thread-Topic: Slowness forming TIPC cluster with explicit node addresses
Thread-Index: AQHVQ0Hkw5M86TmlWkazctTgG4cJIabc5XqAgALa5YCABtFugA==
Date:   Fri, 2 Aug 2019 05:11:29 +0000
Message-ID: <1564722689.4914.27.camel@alliedtelesis.co.nz>
References: <1564097836.11887.16.camel@alliedtelesis.co.nz>
         <CH2PR15MB35754D65AB240A74AE488E719AC00@CH2PR15MB3575.namprd15.prod.outlook.com>
         <1564347861.9737.25.camel@alliedtelesis.co.nz>
In-Reply-To: <1564347861.9737.25.camel@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.18.5.2-0ubuntu3.2 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:3a2c:4aff:fe70:2b02]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F2E798B01063047A30B81CD42F549F0@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTI5IGF0IDA5OjA0ICsxMjAwLCBDaHJpcyBQYWNraGFtIHdyb3RlOg0K
PiBPbiBGcmksIDIwMTktMDctMjYgYXQgMTM6MzEgKzAwMDAsIEpvbiBNYWxveSB3cm90ZToNCj4g
PiANCj4gPiANCj4gPiA+IA0KPiA+ID4gDQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiA+ID4gRnJvbTogbmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93bmVy
QHZnZXIua2VybmVsLm9yZz4NCj4gPiA+IE9uDQo+ID4gPiBCZWhhbGYgT2YgQ2hyaXMgUGFja2hh
bQ0KPiA+ID4gU2VudDogMjUtSnVsLTE5IDE5OjM3DQo+ID4gPiBUbzogdGlwYy1kaXNjdXNzaW9u
QGxpc3RzLnNvdXJjZWZvcmdlLm5ldA0KPiA+ID4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+IFN1YmplY3Q6IFNsb3duZXNzIGZv
cm1pbmcgVElQQyBjbHVzdGVyIHdpdGggZXhwbGljaXQgbm9kZQ0KPiA+ID4gYWRkcmVzc2VzDQo+
ID4gPiANCj4gPiA+IEhpLA0KPiA+ID4gDQo+ID4gPiBJJ20gaGF2aW5nIHByb2JsZW1zIGZvcm1p
bmcgYSBUSVBDIGNsdXN0ZXIgYmV0d2VlbiAyIG5vZGVzLg0KPiA+ID4gDQo+ID4gPiBUaGlzIGlz
IHRoZSBiYXNpYyBzdGVwcyBJJ20gZ29pbmcgdGhyb3VnaCBvbiBlYWNoIG5vZGUuDQo+ID4gPiAN
Cj4gPiA+IG1vZHByb2JlIHRpcGMNCj4gPiA+IGlwIGxpbmsgc2V0IGV0aDIgdXANCj4gPiA+IHRp
cGMgbm9kZSBzZXQgYWRkciAxLjEuNSAjIG9yIDEuMS42DQo+ID4gPiB0aXBjIGJlYXJlciBlbmFi
bGUgbWVkaWEgZXRoIGRldiBldGgwDQo+ID4gZXRoMiwgSSBhc3N1bWUuLi4NCj4gPiANCj4gWWVz
IHNvcnJ5IEkga2VlcCBzd2l0Y2hpbmcgYmV0d2VlbiBiZXR3ZWVuIEV0aGVybmV0IHBvcnRzIGZv
ciB0ZXN0aW5nDQo+IHNvIEkgaGFuZCBlZGl0ZWQgdGhlIGVtYWlsLg0KPiANCj4gPiANCj4gPiA+
IA0KPiA+ID4gDQo+ID4gPiANCj4gPiA+IFRoZW4gdG8gY29uZmlybSBpZiB0aGUgY2x1c3RlciBp
cyBmb3JtZWQgSSB1c2XCoHRpcGMgbGluayBsaXN0DQo+ID4gPiANCj4gPiA+IFtyb290QG5vZGUt
NSB+XSMgdGlwYyBsaW5rIGxpc3QNCj4gPiA+IGJyb2FkY2FzdC1saW5rOiB1cA0KPiA+ID4gLi4u
DQo+ID4gPiANCj4gPiA+IExvb2tpbmcgYXQgdGNwZHVtcCB0aGUgdHdvIG5vZGVzIGFyZSBzZW5k
aW5nIHBhY2tldHMNCj4gPiA+IA0KPiA+ID4gMjI6MzA6MDUuNzgyMzIwIFRJUEMgdjIuMCAxLjEu
NSA+IDAuMC4wLCBoZWFkZXJsZW5ndGggNjAgYnl0ZXMsDQo+ID4gPiBNZXNzYWdlU2l6ZQ0KPiA+
ID4gNzYgYnl0ZXMsIE5laWdoYm9yIERldGVjdGlvbiBQcm90b2NvbCBpbnRlcm5hbCwgbWVzc2Fn
ZVR5cGUgTGluaw0KPiA+ID4gcmVxdWVzdA0KPiA+ID4gMjI6MzA6MDUuODYzNTU1IFRJUEMgdjIu
MCAxLjEuNiA+IDAuMC4wLCBoZWFkZXJsZW5ndGggNjAgYnl0ZXMsDQo+ID4gPiBNZXNzYWdlU2l6
ZQ0KPiA+ID4gNzYgYnl0ZXMsIE5laWdoYm9yIERldGVjdGlvbiBQcm90b2NvbCBpbnRlcm5hbCwg
bWVzc2FnZVR5cGUgTGluaw0KPiA+ID4gcmVxdWVzdA0KPiA+ID4gDQo+ID4gPiBFdmVudHVhbGx5
IChhZnRlciBhIGZldyBtaW51dGVzKSB0aGUgbGluayBkb2VzIGNvbWUgdXANCj4gPiA+IA0KPiA+
ID4gW3Jvb3RAbm9kZS02wqB+XSMgdGlwYyBsaW5rIGxpc3QNCj4gPiA+IGJyb2FkY2FzdC1saW5r
OiB1cA0KPiA+ID4gMTAwMTAwNjpldGgyLTEwMDEwMDU6ZXRoMjogdXANCj4gPiA+IA0KPiA+ID4g
W3Jvb3RAbm9kZS01wqB+XSMgdGlwYyBsaW5rIGxpc3QNCj4gPiA+IGJyb2FkY2FzdC1saW5rOiB1
cA0KPiA+ID4gMTAwMTAwNTpldGgyLTEwMDEwMDY6ZXRoMjogdXANCj4gPiA+IA0KPiA+ID4gV2hl
biBJIHJlbW92ZSB0aGUgInRpcGMgbm9kZSBzZXQgYWRkciIgdGhpbmdzIHNlZW0gdG8ga2ljayBp
bnRvDQo+ID4gPiBsaWZlIHN0cmFpZ2h0DQo+ID4gPiBhd2F5DQo+ID4gPiANCj4gPiA+IFtyb290
QG5vZGUtNSB+XSMgdGlwYyBsaW5rIGxpc3QNCj4gPiA+IGJyb2FkY2FzdC1saW5rOiB1cA0KPiA+
ID4gMDA1MGI2MWJkMmFhOmV0aDItMDA1MGI2MWU2ZGZhOmV0aDI6IHVwDQo+ID4gPiANCj4gPiA+
IFNvIHRoZXJlIGFwcGVhcnMgdG8gYmUgc29tZSBkaWZmZXJlbmNlIGluIGJlaGF2aW91ciBiZXR3
ZWVuDQo+ID4gPiBoYXZpbmcNCj4gPiA+IGFuDQo+ID4gPiBleHBsaWNpdCBub2RlIGFkZHJlc3Mg
YW5kIHVzaW5nIHRoZSBkZWZhdWx0LiBVbmZvcnR1bmF0ZWx5IG91cg0KPiA+ID4gYXBwbGljYXRp
b24NCj4gPiA+IHJlbGllcyBvbiBzZXR0aW5nIHRoZSBub2RlIGFkZHJlc3Nlcy4NCj4gPiBJIGRv
IHRoaXMgbWFueSB0aW1lcyBhIGRheSwgd2l0aG91dCBhbnkgcHJvYmxlbXMuIElmIHRoZXJlIHdv
dWxkIGJlDQo+ID4gYW55IHRpbWUgZGlmZmVyZW5jZSwgSSB3b3VsZCBleHBlY3QgdGhlICdhdXRv
IGNvbmZpZ3VyYWJsZScgdmVyc2lvbg0KPiA+IHRvIGJlIHNsb3dlciwgYmVjYXVzZSBpdCBpbnZv
bHZlcyBhIERBRCBzdGVwLg0KPiA+IEFyZSB5b3Ugc3VyZSB5b3UgZG9uJ3QgaGF2ZSBhbnkgb3Ro
ZXIgbm9kZXMgcnVubmluZyBpbiB5b3VyIHN5c3RlbT8NCj4gPiANCj4gPiAvLy9qb24NCj4gPiAN
Cj4gTm9wZSB0aGUgdHdvIG5vZGVzIGFyZSBjb25uZWN0ZWQgYmFjayB0byBiYWNrLiBEb2VzIHRo
ZSBudW1iZXIgb2YNCj4gRXRoZXJuZXQgaW50ZXJmYWNlcyBtYWtlIGEgZGlmZmVyZW5jZT8gQXMg
eW91IGNhbiBzZWUgSSd2ZSBnb3QgMyBvbg0KPiBlYWNoIG5vZGUuIE9uZSBpcyBjb21wbGV0ZWx5
IGRpc2Nvbm5lY3RlZCwgb25lIGlzIGZvciBib290aW5nIG92ZXINCj4gVEZUUA0KPiDCoChvbmx5
IHVzZWQgYnkgVS1ib290KSBhbmQgdGhlIG90aGVyIGlzIHRoZSBVU0IgRXRoZXJuZXQgSSdtIHVz
aW5nDQo+IGZvcg0KPiB0ZXN0aW5nLg0KPiANCg0KU28gSSBjYW4gc3RpbGwgcmVwcm9kdWNlIHRo
aXMgb24gbm9kZXMgdGhhdCBvbmx5IGhhdmUgb25lIG5ldHdvcmsNCmludGVyZmFjZSBhbmQgYXJl
IHRoZSBvbmx5IHRoaW5ncyBjb25uZWN0ZWQuDQoNCkkgZGlkIGZpbmQgb25lIHRoaW5nIHRoYXQg
aGVscHMNCg0KZGlmZiAtLWdpdCBhL25ldC90aXBjL2Rpc2NvdmVyLmMgYi9uZXQvdGlwYy9kaXNj
b3Zlci5jDQppbmRleCBjMTM4ZDY4ZThhNjkuLjQ5OTIxZGFkNDA0YSAxMDA2NDQNCi0tLSBhL25l
dC90aXBjL2Rpc2NvdmVyLmMNCisrKyBiL25ldC90aXBjL2Rpc2NvdmVyLmMNCkBAIC0zNTgsMTAg
KzM1OCwxMCBAQCBpbnQgdGlwY19kaXNjX2NyZWF0ZShzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdA0K
dGlwY19iZWFyZXIgKmIsDQrCoMKgwqDCoMKgwqDCoMKgdGlwY19kaXNjX2luaXRfbXNnKG5ldCwg
ZC0+c2tiLCBEU0NfUkVRX01TRywgYik7DQrCoA0KwqDCoMKgwqDCoMKgwqDCoC8qIERvIHdlIG5l
ZWQgYW4gYWRkcmVzcyB0cmlhbCBwZXJpb2QgZmlyc3QgPyAqLw0KLcKgwqDCoMKgwqDCoMKgaWYg
KCF0aXBjX293bl9hZGRyKG5ldCkpIHsNCisvL8KgwqDCoMKgwqBpZiAoIXRpcGNfb3duX2FkZHIo
bmV0KSkgew0KwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0bi0+YWRkcl90cmlhbF9l
bmQgPSBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcygxMDAwKTsNCsKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgbXNnX3NldF90eXBlKGJ1Zl9tc2coZC0+c2tiKSwgRFNDX1RSSUFMX01T
Ryk7DQotwqDCoMKgwqDCoMKgwqB9DQorLy/CoMKgwqDCoMKgfQ0KwqDCoMKgwqDCoMKgwqDCoG1l
bWNweSgmZC0+ZGVzdCwgZGVzdCwgc2l6ZW9mKCpkZXN0KSk7DQrCoMKgwqDCoMKgwqDCoMKgZC0+
bmV0ID0gbmV0Ow0KwqDCoMKgwqDCoMKgwqDCoGQtPmJlYXJlcl9pZCA9IGItPmlkZW50aXR5Ow0K
DQpJIHRoaW5rIGJlY2F1c2Ugd2l0aCBwcmUtY29uZmlndXJlZCBhZGRyZXNzZXMgdGhlIGR1cGxp
Y2F0ZSBhZGRyZXNzDQpkZXRlY3Rpb24gaXMgc2tpcHBlZCB0aGUgc2hvcnRlciBpbml0IHBoYXNl
IGlzIHNraXBwZWQuIFdvdWxkIGlzIG1ha2UNCnNlbnNlIHRvIHVuY29uZGl0aW9uYWxseSBkbyB0
aGUgdHJpYWwgc3RlcD8gT3IgaXMgdGhlcmUgc29tZSBiZXR0ZXIgd2F5DQp0byBnZXQgdGhpbmdz
IHRvIHRyYW5zaXRpb24gd2l0aCBwcmUtYXNzaWduZWQgYWRkcmVzc2VzLg==
