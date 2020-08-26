Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA1B2532DA
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 17:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgHZPG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 11:06:58 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:32158 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727108AbgHZPG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 11:06:56 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-261-ph5PWed-PFGPcuia_f9y9w-1; Wed, 26 Aug 2020 16:06:52 +0100
X-MC-Unique: ph5PWed-PFGPcuia_f9y9w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 26 Aug 2020 16:06:51 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 26 Aug 2020 16:06:51 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Lukasz Stelmach' <l.stelmach@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>
Subject: RE: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Thread-Topic: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Thread-Index: AQHWe7mj43dSzPFWakSayEhKlD9dNqlKfEsw
Date:   Wed, 26 Aug 2020 15:06:51 +0000
Message-ID: <1efebb42c30a4c40bf91649d83d60e1c@AcuMS.aculab.com>
References: <20200825184413.GA2693@kozik-lap>
        <CGME20200826145929eucas1p1367c260edb8fa003869de1da527039c0@eucas1p1.samsung.com>
 <dleftja6yhv4g2.fsf%l.stelmach@samsung.com>
In-Reply-To: <dleftja6yhv4g2.fsf%l.stelmach@samsung.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTHVrYXN6IFN0ZWxtYWNoDQo+IFNlbnQ6IDI2IEF1Z3VzdCAyMDIwIDE1OjU5DQo+IA0K
PiBJdCB3YXMgPDIwMjAtMDgtMjUgd3RvIDIwOjQ0Piwgd2hlbiBLcnp5c3p0b2YgS296bG93c2tp
IHdyb3RlOg0KPiA+IE9uIFR1ZSwgQXVnIDI1LCAyMDIwIGF0IDA3OjAzOjA5UE0gKzAyMDAsIMWB
dWthc3ogU3RlbG1hY2ggd3JvdGU6DQo+ID4+IEFTSVggQVg4ODc5NlsxXSBpcyBhIHZlcnNhdGls
ZSBldGhlcm5ldCBhZGFwdGVyIGNoaXAsIHRoYXQgY2FuIGJlDQo+ID4+IGNvbm5lY3RlZCB0byBh
IENQVSB3aXRoIGEgOC8xNi1iaXQgYnVzIG9yIHdpdGggYW4gU1BJLiBUaGlzIGRyaXZlcg0KPiA+
PiBzdXBwb3J0cyBTUEkgY29ubmVjdGlvbi4NCi4uLg0KPiA+PiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9hc2l4L0tjb25maWcNCj4gPj4gQEAgLTAsMCArMSwyMCBAQA0KPiA+PiArIw0KPiA+
PiArIyBBc2l4IG5ldHdvcmsgZGV2aWNlIGNvbmZpZ3VyYXRpb24NCj4gPj4gKyMNCj4gPj4gKw0K
PiA+PiArY29uZmlnIE5FVF9WRU5ET1JfQVNJWA0KPiA+PiArCWJvb2wgIkFzaXggZGV2aWNlcyIN
Cj4gPj4gKwlkZXBlbmRzIG9uIFNQSQ0KPiA+PiArCWhlbHANCj4gPj4gKwkgIElmIHlvdSBoYXZl
IGEgbmV0d29yayAoRXRoZXJuZXQpIGludGVyZmFjZSBiYXNlZCBvbiBhIGNoaXAgZnJvbSBBU0lY
LCBzYXkgWQ0KPiA+DQo+ID4gTG9va3MgbGlrZSB0b28gbG9uZywgZGlkIGl0IHBhc3MgY2hlY2tw
YXRjaD8NCj4gDQo+IFllcz8gTGV0IG1lIHRyeSBhZ2Fpbi4gWWVzLCB0aGlzIG9uZSBwYXNzZWQs
IGJ1dCBJIG1pc3NlZCBhIGZldyBvdGhlcg0KPiBwcm9ibGVtcy4gVGhhbmsgeW91Lg0KPiANCj4g
Pj4gKw0KPiA+PiAraWYgTkVUX1ZFTkRPUl9BU0lYDQo+ID4+ICsNCj4gPj4gK2NvbmZpZyBTUElf
QVg4ODc5NkMNCj4gPj4gKwl0cmlzdGF0ZSAiQXNpeCBBWDg4Nzk2Qy1TUEkgc3VwcG9ydCINCj4g
Pj4gKwlkZXBlbmRzIG9uIFNQSQ0KPiA+PiArCWRlcGVuZHMgb24gR1BJT0xJQg0KPiA+PiArCWhl
bHANCj4gPj4gKwkgIFNheSBZIGhlcmUgaWYgeW91IGludGVuZCB0byBhdHRhY2ggYSBBc2l4IEFY
ODg3OTZDIGFzIFNQSSBtb2RlDQo+ID4+ICsNCj4gPj4gK2VuZGlmICMgTkVUX1ZFTkRPUl9BU0lY
DQoNClRoZXJlIGFyZSBwbGVudHkgb2Ygb3RoZXIgZXRoZXJuZXQgZGV2aWNlcyBtYWRlIGJ5IEFT
SVggKGVnIFVTQiBvbmVzKQ0KdGhhdCBoYXZlIG5vdGhpbmcgYXQgYWxsIHRvIGRvIHdpdGggdGhp
cyBkcml2ZXIuDQpTbyB0aG9zZSBxdWVzdGlvbnMgYXJlIHRvbyBicm9hZC4NCg0KVGhlIGZpcnN0
IG9uZSBzaG91bGQgcHJvYmFibGUgYmUgZm9yIEFTSVggU1BJIG5ldHdvcmsgZGV2aWNlcy4NCg0K
KEkgY2FuJ3QgaW1hZ2luZSBTUEkgYmVpbmcgZmFzdCBlbm91Z2ggdG8gYmUgdXNlZnVsIGZvciBl
dGhlcm5ldC4uLikNCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwg
QnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVn
aXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

