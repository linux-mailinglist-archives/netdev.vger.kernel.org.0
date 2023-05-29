Return-Path: <netdev+bounces-6070-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C171714A60
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25AD5280E93
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747CC747B;
	Mon, 29 May 2023 13:32:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C1C7476
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:32:13 +0000 (UTC)
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383A78E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:32:09 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-16-wjxXWMCdOBeYCL4LasRi8Q-1; Mon, 29 May 2023 14:32:07 +0100
X-MC-Unique: wjxXWMCdOBeYCL4LasRi8Q-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 29 May
 2023 14:32:02 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Mon, 29 May 2023 14:32:02 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Jeffrey E Altman' <jaltman@auristor.com>, Kenny Ho <y2kenny@gmail.com>
CC: Andrew Lunn <andrew@lunn.ch>, Marc Dionne <marc.dionne@auristor.com>,
	Kenny Ho <Kenny.Ho@amd.com>, David Howells <dhowells@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Remove hardcoded static string length
Thread-Topic: [PATCH] Remove hardcoded static string length
Thread-Index: AQHZjmnJx5LdtvUc0U+gvus5miHTlK9qs1lwgABJPoCAABjC4IADKDDLgAMCIaA=
Date: Mon, 29 May 2023 13:32:02 +0000
Message-ID: <9ef0c93114814352877825321e9e2826@AcuMS.aculab.com>
References: <20230523223944.691076-1-Kenny.Ho@amd.com>
 <01936d68-85d3-4d20-9beb-27ff9f62d826@lunn.ch>
 <CAB9dFdt4-cBFhEqsTXk9suE+Bw-xcpM0n3Q6rFmBaa+8A5uMWQ@mail.gmail.com>
 <c0fda91b-1e98-420f-a18a-16bbed25e98d@lunn.ch>
 <CAOWid-erNGD24Ouf4fAJJBqm69QVoHOpNt0E-G+Wt=nq1W4oBQ@mail.gmail.com>
 <5b1355b8-17f7-49c8-b7b5-3d9ecdb146ce@lunn.ch>
 <CAOWid-dYtkcKuNxoOyf3yqSJ7OtcNjaqJLVX1QhRUhYSOO6vHA@mail.gmail.com>
 <30d65ea9170d4f60bd76ed516541cb46@AcuMS.aculab.com>
 <CAOWid-eEbeeU9mOpwgOatt5rHQhRt+xPrsQ1fsMemVZDdeN=MQ@mail.gmail.com>
 <81d01562a59a4fb49cd4681ebcf2e74a@AcuMS.aculab.com>
 <CAOWid-d=OFn7JS5JvsK9qc7X6HeZgOm5OAd1_g2=_GZgpKRZnA@mail.gmail.com>
 <c22f76b1-0559-410f-38f2-266e1a9fcca5@auristor.com>
In-Reply-To: <c22f76b1-0559-410f-38f2-266e1a9fcca5@auristor.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

RnJvbTogSmVmZnJleSBFIEFsdG1hbg0KPiBTZW50OiAyNyBNYXkgMjAyMyAxNjowOQ0KPiANCj4g
T24gNS8yNS8yMDIzIDExOjM3IEFNLCBLZW5ueSBIbyB3cm90ZToNCj4gPiBPbiBUaHUsIE1heSAy
NSwgMjAyMyBhdCAxMTowNOKAr0FNIERhdmlkIExhaWdodDxEYXZpZC5MYWlnaHRAYWN1bGFiLmNv
bT4gIHdyb3RlOg0KPiA+Pj4gIlRoZSBzdGFuZGFyZCBmb3JtdWxhdGlvbiBzZWVtcyB0byBiZTog
PHByb2plY3Q+IDx2ZXJzaW9uPiBidWlsdA0KPiA+Pj4gPHl5eXk+LTxtbT4tPGRkPiINCj4gPj4g
V2hpY2ggSSBkb24ndCByZWNhbGwgdGhlIHN0cmluZyBhY3R1YWxseSBtYXRjaGluZz8NCj4gPj4g
QWxzbyB0aGUgcGVvcGxlIHdobyBsaWtlIHJlcHJvZHVjaWJsZSBidWlsZHMgZG9uJ3QgbGlrZSBf
X0RBVEVfXy4NCj4gPiBUaGF0J3MgY29ycmVjdCwgaXQgd2FzIG5vdCBtYXRjaGluZyBldmVuIHdo
ZW4gaXQgd2FzIGludHJvZHVjZWQuICBJIGFtDQo+ID4gc2ltcGx5IHRha2luZyB0aGF0IGFzIHBl
b3BsZSBjYXJpbmcgYWJvdXQgdGhlIGNvbnRlbnQgYW5kIG5vdCBzaW1wbHkNCj4gPiBtYWtpbmcg
cnhycGNfdmVyc2lvbl9zdHJpbmcgPT0gVVRTX1JFTEVBU0UuICBUaGUgY3VycmVudCBmb3JtYXQg
aXM6DQo+ID4NCj4gPiAibGludXgtIiBVVFNfUkVMRUFTRSAiIEFGX1JYUlBDIg0KPiA+DQo+ID4g
S2VubnkNCj4gDQo+IFRoZSBSWF9QQUNLRVRfVFlQRV9WRVJTSU9OIHF1ZXJ5IGlzIGlzc3VlZCBi
eSB0aGUgInJ4ZGVidWcgPGhvc3Q+IDxwb3J0Pg0KPiAtdmVyc2lvbiIgY29tbWFuZCB3aGljaCBw
cmludHMgdGhlIHJlY2VpdmVkIHN0cmluZyB0byBzdGRvdXQuwqDCoCBJdCBoYXMNCj4gYWxzbyBi
ZWVuIHVzZWQgc29tZSBpbXBsZW1lbnRhdGlvbnMgdG8gcmVjb3JkIHRoZSB2ZXJzaW9uIG9mIHRo
ZSBwZWVyLg0KPiBBbHRob3VnaCBpdCBpcyByZXF1aXJlZCB0aGF0IGEgcmVzcG9uc2UgdG8gdGhl
IFJYX1BBQ0tFVF9UWVBFX1ZFUlNJT04NCj4gcXVlcnkgYmUgaXNzdWVkLCB0aGVyZSBpcyBubyBy
ZXF1aXJlbWVudCB0aGF0IHRoZSByZXR1cm5lZCBzdHJpbmcNCj4gY29udGFpbiBhbnl0aGluZyBi
ZXlvbmQgYSBzaW5nbGUgTlVMIG9jdGV0Lg0KDQpEb2VzIHRoYXQgbWVhbiB0aGF0IHRoZSB6ZXJv
LXBhZGRpbmcvdHJ1bmNhdGlvbiB0byA2NSBieXRlcyBpcyBib2d1cz8NCkFkZGl0aW9uYWxseSBp
cyB0aGUgcmVzcG9uc2Ugc3VwcG9zZWQgdG8gdGhlICdcMCcgdGVybWluYXRlZD8NClRoZSBleGlz
dGluZyBjb2RlIGRvZXNuJ3QgZ3VhcmFudGVlIHRoYXQgYXQgYWxsLg0KDQo+IEFsdGhvdWdoIGl0
IGlzIGNvbnZlbmllbnQgdG8gYmUgYWJsZSB0byByZW1vdGVseSBpZGVudGlmeSB0aGUgdmVyc2lv
biBvZg0KPiBhbiBSeCBpbXBsZW1lbnRhdGlvbiwgdGhlcmUgYXJlIGdvb2QgcmVhc29ucyB3aHkg
dGhpcyBpbmZvcm1hdGlvbiBzaG91bGQNCj4gbm90IGJlIGV4cG9zZWQgdG8gYW4gYW5vbnltb3Vz
IHJlcXVlc3RlcjoNCj4gDQo+ICAxLiBMaW51eCBBRl9SWFJQQyBpcyBwYXJ0IG9mIHRoZSBrZXJu
ZWwuwqAgQXMgc3VjaCwgcmV0dXJuaW5nDQo+ICAgICBVVFNfUkVMRUFTRSBpZGVudGlmaWVzIHRv
IHBvdGVudGlhbCBhdHRhY2tlcnMgdGhlIGV4cGxpY2l0IGtlcm5lbA0KPiAgICAgdmVyc2lvbiwg
YXJjaGl0ZWN0dXJlIGFuZCBwZXJoYXBzIGRpc3Ryby7CoCBBcyB0aGlzIHF1ZXJ5IGNhbiBiZQ0K
PiAgICAgaXNzdWVkIGFub255bW91c2x5LCB0aGlzIHByb3ZpZGVzIGFuIGluZm9ybWF0aW9uIGRp
c2Nsb3N1cmUgdGhhdCBjYW4NCj4gICAgIGJlIHVzZWQgdG8gdGFyZ2V0IGtub3duIHZ1bG5lcmFi
aWxpdGllcyBpbiB0aGUga2VybmVsLg0KDQpJIGd1ZXNzIGl0IGNvdWxkIGV2ZW4gYmUgdXNlZCBh
cyBhIHByb2JlIHRvIGZpbmQgbW9yZS9pbnRlcmVzdGluZw0Kc3lzdGVtcyB0byBhdHRhY2sgb25j
ZSBpbnNpZGUgdGhlIGZpcmV3YWxsLg0KDQo+ICAyLiBUaGUgUlhfUEFDS0VUX1RZUEVfVkVSU0lP
TiByZXBseSBpcyBsYXJnZXIgdGhhbiB0aGUgcXVlcnkgYnkgdGhlDQo+ICAgICBudW1iZXIgb2Yg
b2N0ZXRzIGluIHRoZSB2ZXJzaW9uIGRhdGEuwqAgQXMgdGhlIHF1ZXJ5IGlzIHJlY2VpdmVkIHZp
YQ0KPiAgICAgdWRwIHdpdGggbm8gcmVhY2hhYmlsaXR5IHRlc3QsIGl0IG1lYW5zIHRoYXQgdGhl
DQo+ICAgICBSWF9QQUNLRVRfVFlQRV9WRVJTSU9OIHF1ZXJ5L3Jlc3BvbnNlIGNhbiBiZSB1c2Vk
IHRvIHBlcmZvcm0gYW4gMy4zeA0KPiAgICAgYW1wbGlmaWNhdGlvbiBhdHRhY2s6IDI4IG9jdGV0
cyBpbiBhbmQgcG90ZW50aWFsbHkgOTMgb2N0ZXRzIG91dC4NCj4gDQo+IFdpdGggbXkgc2VjdXJp
dHkgaGF0IG9uIEkgd291bGQgc3VnZ2VzdCB0aGF0IGVpdGhlciBBRl9SWFJQQyByZXR1cm4gYQ0K
PiBzaW5nbGUgTlVMIG9jdGV0IG9yIHRoZSBjLXN0cmluZyAiQUZfUlhSUEMiIGFuZCBub3RoaW5n
IG1vcmUuDQoNCklzIHRoZXJlIGFueSBwb2ludCBpbmNsdWRpbmcgIkFGX1JYUlBDIj8NCkl0IGlz
IGFsbW9zdCBjZXJ0YWlubHkgaW1wbGllZCBieSB0aGUgbWVzc2FnZSBmb3JtYXQuDQoNCk9yIHRo
ZSBleGFjdCB0ZXh0IGZyb20gdGhlIHN0YW5kYXJkIC0gd2hpY2ggbWlnaHQgYmU6DQogICJ2ZXJz
aW9uIHN0cmluZyAtIHRvIGJlIHN1cHBsaWVkIGJ5IE8uRS5NLiINCihJJ3ZlIHNlZW4gaGFyZHdh
cmUgdmVyc2lvbnMgd2l0aCBzdHJpbmdzIGxpa2UgdGhlIGFib3ZlIHRoYXQNCmV4YWN0bHkgbWF0
Y2ggdGhlIGRhdGFzaGVldC4uLi4pDQoNCkxpbWl0aW5nIHRoZSB2ZXJzaW9uIHRvIChlZykgNi4y
IHdvdWxkIGdpdmUgYSBoaW50IHRvIHRoZQ0KY2FwYWJpbGl0aWVzL2J1Z3Mgd2l0aG91dCBnaXZp
bmcgYXdheSBhbGwgdGhlIHJlbGF0aXZlIGFkZHJlc3Nlcw0KaW4gc29tZXRoaW5nIGxpa2UgYSBS
SEVMIGtlcm5lbC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwg
QnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVn
aXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==


