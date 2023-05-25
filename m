Return-Path: <netdev+bounces-5279-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF2D710878
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D7A11C202F2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB8DD533;
	Thu, 25 May 2023 09:15:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409B73D7C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:15:08 +0000 (UTC)
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2729D1B0
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 02:15:04 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-51-2196sYpmN7CoD8Mxrq-LpA-1; Thu, 25 May 2023 10:14:54 +0100
X-MC-Unique: 2196sYpmN7CoD8Mxrq-LpA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 25 May
 2023 10:14:53 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Thu, 25 May 2023 10:14:53 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Kenny Ho' <y2kenny@gmail.com>, Andrew Lunn <andrew@lunn.ch>
CC: Marc Dionne <marc.dionne@auristor.com>, Kenny Ho <Kenny.Ho@amd.com>,
	"David Howells" <dhowells@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Remove hardcoded static string length
Thread-Topic: [PATCH] Remove hardcoded static string length
Thread-Index: AQHZjmnJx5LdtvUc0U+gvus5miHTlK9qs1lw
Date: Thu, 25 May 2023 09:14:53 +0000
Message-ID: <30d65ea9170d4f60bd76ed516541cb46@AcuMS.aculab.com>
References: <20230523223944.691076-1-Kenny.Ho@amd.com>
 <01936d68-85d3-4d20-9beb-27ff9f62d826@lunn.ch>
 <CAB9dFdt4-cBFhEqsTXk9suE+Bw-xcpM0n3Q6rFmBaa+8A5uMWQ@mail.gmail.com>
 <c0fda91b-1e98-420f-a18a-16bbed25e98d@lunn.ch>
 <CAOWid-erNGD24Ouf4fAJJBqm69QVoHOpNt0E-G+Wt=nq1W4oBQ@mail.gmail.com>
 <5b1355b8-17f7-49c8-b7b5-3d9ecdb146ce@lunn.ch>
 <CAOWid-dYtkcKuNxoOyf3yqSJ7OtcNjaqJLVX1QhRUhYSOO6vHA@mail.gmail.com>
In-Reply-To: <CAOWid-dYtkcKuNxoOyf3yqSJ7OtcNjaqJLVX1QhRUhYSOO6vHA@mail.gmail.com>
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
	SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

RnJvbTogS2VubnkgSG8NCj4gU2VudDogMjQgTWF5IDIwMjMgMTk6MDENCj4gDQo+IE9uIFdlZCwg
TWF5IDI0LCAyMDIzIGF0IDE6NDPigK9QTSBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+IHdy
b3RlOg0KPiA+DQo+ID4gVGhlIG90aGVyIGVuZCBvZiB0aGUgc29ja2V0IHNob3VsZCBub3QgYmxv
dyB1cCwgYmVjYXVzZSB0aGF0IHdvdWxkIGJlDQo+ID4gYW4gb2J2aW91cyBET1Mgb3IgYnVmZmVy
IG92ZXJ3cml0ZSBhdHRhY2sgdmVjdG9yLiBTbyB5b3UgbmVlZCB0bw0KPiA+IGRlY2lkZSwgZG8g
eW91IHdhbnQgdG8gZXhwb3NlIHN1Y2ggaXNzdWVzIGFuZCBzZWUgaWYgYW55dGhpbmcgZG9lcw0K
PiA+IGFjdHVhbGx5IGJsb3cgdXAsIG9yIGRvIHlvdSB3YW50IHRvIGRvIGEgYml0IG1vcmUgd29y
ayBhbmQgY29ycmVjdGx5DQo+ID4gdGVybWluYXRlIHRoZSBzdHJpbmcgd2hlbiBjYXBwZWQ/DQo+
IA0KPiBSaWdodC4uLiBJIGd1ZXNzIGl0J3Mgbm90IGNsZWFyIHRvIG1lIHRoYXQgZXhpc3Rpbmcg
aW1wbGVtZW50YXRpb25zDQo+IG51bGwtdGVybWluYXRlIGNvcnJlY3RseSB3aGVuIFVUU19SRUxF
QVNFIGNhdXNlcyB0aGUgc3RyaW5nIHRvIGV4Y2VlZA0KPiB0aGUgNjUgYnl0ZSBzaXplIG9mIHJ4
cnBjX3ZlcnNpb25fc3RyaW5nLiAgV2UgY2FuIG9mIGNvdXJzZSBkbyBiZXR0ZXIsDQo+IGJ1dCBJ
IGhlc2l0YXRlIHRvIGRvIHN0cm5jcHkgYmVjYXVzZSBJIGFtIG5vdCBmYW1pbGlhciB3aXRoIHRo
aXMgY29kZQ0KPiBiYXNlIGVub3VnaCB0byB0ZWxsIGlmIHRoaXMgZnVuY3Rpb24gaXMgcGFydCBv
ZiBzb21lIGhvdCBwYXRoIHdoZXJlDQo+IHN0cm5jcHkgbWF0dGVycy4NCg0KVGhlIHdob2xlIHRo
aW5nIGxvb2tzIGxpa2UgaXQgaXMgZXhwZWN0aW5nIGEgbWF4IG9mIDY0IGNoYXJhY3RlcnMNCmFu
ZCBhIHRlcm1pbmF0aW5nICdcMCcuDQpTaW5jZSBVVEVfUkVMRUFTRSBnb2VzIGluIGJldHdlZW4g
dHdvIGZpeGVkIHN0cmluZ3MgdHJ1bmNhdGluZw0KdGhlIHdob2xlIHRoaW5nIHRvIDY0LzY1IGNo
YXJzL2J5dGVzIGRvZXNuJ3Qgc2VlbSBpZGVhbC4NCg0KSSBkb2VzIHJhdGhlciBiZWcgdGhlIHF1
ZXN0aW9uIGFzIHdoYXQgaXMgaW4gVVRTX1JFTEVBU0Ugd2hlbg0KaXQgZXhjZWVkcyAoSUlSQykg
YWJvdXQgNDggY2hhcmFjdGVycz8NCg0KSWYgVVRTX1JFTEVBU0UgaXMgZ2V0dGluZyB0aGF0IGxv
bmcsIGl0IG1pZ2h0IGVhc2lseSBleGNlZWQNCnRoZSA2NCBjaGFyYWN0ZXJzIHJldHVybmVkIGJ5
IHVuYW1lKCkuDQoNCkkgc3VzcGVjdCB0aGF0IHlvdSBuZWVkIHRvIHRydW5jYXRlIFVUU19SRUxF
QVNFIHRvIGxpbWl0DQp0aGUgc3RyaW5nIHRvIDY0IGNoYXJhY3RlcnMgLSBzbyBzb21ldGhpbmcg
bGlrZToNCglzdGF0aWMgY2hhciBpZFs2NV07DQoJaWYgKCFpZFswXSkNCgkJc25wcmludGYoaWQs
IHNpemVvZiBpZCwgInh4eC0lLjQ4cy15eXkiLCBVVFNfUkVMRUFTRSk7DQoNClVzaW5nIGFuIG9u
LXN0YWNrIGJ1ZmZlciBhbG1vc3QgY2VydGFpbmx5IHdvdWxkbid0IG1hdHRlci4NCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==


