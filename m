Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D844D1F0B78
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 15:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgFGNfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 09:35:52 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:28413 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726517AbgFGNfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 09:35:52 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-56-gAtFnUnCPQuRadnGrFS-tw-1; Sun, 07 Jun 2020 14:35:48 +0100
X-MC-Unique: gAtFnUnCPQuRadnGrFS-tw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 7 Jun 2020 14:35:48 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 7 Jun 2020 14:35:48 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stanislav Fomichev' <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: RE: [PATCH bpf v2] bpf: increase {get,set}sockopt optval size limit
Thread-Topic: [PATCH bpf v2] bpf: increase {get,set}sockopt optval size limit
Thread-Index: AQHWOs9eM1HPxgEZJ0SdZVJ+nDicwqjNKdyg
Date:   Sun, 7 Jun 2020 13:35:48 +0000
Message-ID: <676ee05282404ea98e5de55d0c254902@AcuMS.aculab.com>
References: <20200605002155.93267-1-sdf@google.com>
In-Reply-To: <20200605002155.93267-1-sdf@google.com>
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

RnJvbTogU3RhbmlzbGF2IEZvbWljaGV2DQo+IFNlbnQ6IDA1IEp1bmUgMjAyMCAwMToyMg0KPiBB
dHRhY2hpbmcgdG8gdGhlc2UgaG9va3MgY2FuIGJyZWFrIGlwdGFibGVzIGJlY2F1c2UgaXRzIG9w
dHZhbCBpcw0KPiB1c3VhbGx5IHF1aXRlIGJpZywgb3IgYXQgbGVhc3QgYmlnZ2VyIHRoYW4gdGhl
IGN1cnJlbnQgUEFHRV9TSVpFIGxpbWl0Lg0KPiANCj4gVGhlcmUgYXJlIHR3byBwb3NzaWJsZSB3
YXlzIHRvIGZpeCBpdDoNCj4gMS4gSW5jcmVhc2UgdGhlIGxpbWl0IHRvIG1hdGNoIGlwdGFibGVz
IG1heCBvcHR2YWwuDQo+IDIuIEltcGxlbWVudCBzb21lIHdheSB0byBieXBhc3MgdGhlIHZhbHVl
IGlmIGl0J3MgdG9vIGJpZyBhbmQgdHJpZ2dlcg0KPiAgICBCUEYgb25seSB3aXRoIGxldmVsL29w
dG5hbWUgc28gQlBGIGNhbiBzdGlsbCBkZWNpZGUgd2hldGhlcg0KPiAgICB0byBhbGxvdy9kZW55
IGJpZyBzb2Nrb3B0cy4NCj4gDQo+IEkgd2VudCB3aXRoICMxIHdoaWNoIG1lYW5zIHdlIGFyZSBw
b3RlbnRpYWxseSBpbmNyZWFzaW5nIHRoZQ0KPiBhbW91bnQgb2YgZGF0YSB3ZSBjb3B5IGZyb20g
dGhlIHVzZXJzcGFjZSBmcm9tIFBBR0VfU0laRSB0byA1MTJNLg0KLi4uDQo+ICsJY29uc3QgaW50
IG1heF9zdXBwb3J0ZWRfb3B0bGVuID0gNTEyICogMTAyNCAqIDEwMjQgKyAxMjg7DQoNCjUxMk1C
IHNlZW1zIGEgYml0IGJpZy4NCkknZCBoYXZlIHRob3VnaHQgdGhhdCBpcHRhYmxlcyB3b3VsZCBi
ZSB1c2FibGUgZnJvbSBhIDMyYml0IGFwcGxpY2F0aW9uDQp3aGVyZSB0aGF0IGlzIDEvNnRoIHRo
ZSBwcm9jZXNzIGFkZHJlc3Mgc3BhY2UuDQpBbnl0aGluZyB0aGF0IG1pZ2h0IGJlIHRoYXQgYmln
IG91Z2h0IHRvIGJlIGRvbmUgaW4gY2h1bmtzLg0KDQpJIHdhcyBsb29raW5nIGF0IHRoZSBTQ1RQ
IHNvY2tldCBvcHRpb24gY29kZS4NCklTVFIgdGhhdCBtYXkgcmVxdWlyZSBqdXN0IG92ZXIgMjU2
a0IgLSBzdGlsbCBzaWxseSwgYnV0IG5vdCBhcyBiYWQuDQoNClNDVFAgYWxzbyByZXF1aXJlcyB0
aGF0IGdldHNvY2tvcHQoKSBjb3B5IHRoZSBidWZmZXIgaW4gZnJvbSB1c2Vyc3BhY2UuDQpPbmUg
Y2FsbCByZXF1aXJlZCBtb3JlIHRoYW4gYSAnc29ja2FkZHIgc3RvcmFnZScgYmUgcmVhZCBpbi4N
Cg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2Fk
LCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5v
OiAxMzk3Mzg2IChXYWxlcykNCg==

