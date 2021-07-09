Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77ED93C23A5
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 14:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhGIMqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 08:46:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:36838 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231371AbhGIMqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 08:46:22 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-261-jl8sSiT-MC6pmAkf5iHnzw-1; Fri, 09 Jul 2021 13:43:34 +0100
X-MC-Unique: jl8sSiT-MC6pmAkf5iHnzw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.18; Fri, 9 Jul 2021 13:43:33 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Fri, 9 Jul 2021 13:43:33 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Nikolai Zhubr' <zhubr.2@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>
CC:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: Realtek 8139 problem on 486.
Thread-Topic: Realtek 8139 problem on 486.
Thread-Index: AQHXdCzzYiQdGnMnnEWWVOij3gyW26s6kyMA
Date:   Fri, 9 Jul 2021 12:43:32 +0000
Message-ID: <134a4f75cfe44d898f12038248ff5d56@AcuMS.aculab.com>
References: <60B24AC2.9050505@gmail.com> <60B611C6.2000801@gmail.com>
 <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com> <60B65BBB.2040507@gmail.com>
 <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <alpine.DEB.2.21.2106032014320.2979@angie.orcam.me.uk>
 <CAK8P3a0oLiBD+zjmBxsrHxdMeYSeNhg6fhC+VPV8TAf9wbauSg@mail.gmail.com>
 <877dipgyrb.ffs@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.2106200749300.61140@angie.orcam.me.uk>
 <CAK8P3a0Z56XvLHJHjvsX3F76ZF0n-VXwPoWbvfQdTgfEBfOneg@mail.gmail.com>
 <60D1DAC1.9060200@gmail.com>
 <CAK8P3a1XaTUgxM3YBa=iHGrLX_Wn66NhTTEXtV=vaNre7K3GOA@mail.gmail.com>
 <60D22F1D.1000205@gmail.com>
 <CAK8P3a3Jk+zNnQ5r9gb60deqCmJT+S07VvL3SipKRYXdxM2kPQ@mail.gmail.com>
 <60D361FF.70905@gmail.com>
 <alpine.DEB.2.21.2106240044080.37803@angie.orcam.me.uk>
 <CAK8P3a0u+usoPon7aNOAB_g+Jzkhbz9Q7-vyYci1ReHB6c-JMQ@mail.gmail.com>
 <60DF62DA.6030508@gmail.com>
 <CAK8P3a2=d0wT9UWgkKDJS5Bd8dPYswah79O5tAg5tHpr4vMH4Q@mail.gmail.com>
 <60E75057.60706@gmail.com>
In-Reply-To: <60E75057.60706@gmail.com>
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

RnJvbTogTmlrb2xhaSBaaHVicg0KPiBTZW50OiAwOCBKdWx5IDIwMjEgMjA6MjINCi4uLg0KPiAy
Mi4wNi4yMDIxIDE0OjEyLCBEYXZpZCBMYWlnaHQ6DQo+ICA+IFR5cGljYWxseSB5b3UgbmVlZCB0
bzoNCj4gID4gMSkgc3RvcCB0aGUgY2hpcCBkcml2aW5nIElSUSBsb3cuDQo+ICA+IDIpIHByb2Nl
c3MgYWxsIHRoZSBjb21wbGV0ZWQgUlggYW5kIFRYIGVudHJpZXMuDQo+ICA+IDMpIGNsZWFyIHRo
ZSBjaGlwJ3MgaW50ZXJydXB0IHBlbmRpbmcgYml0cyAob2Z0ZW4gd3JpdGUgdG8gY2xlYXIpLg0K
PiAgPiA0KSBjaGVjayBmb3IgY29tcGxldGVkIFJYL1RYIGVudHJpZXMsIGJhY2sgdG8gMiBpZiBm
b3VuZC4NCj4gID4gNSkgZW5hYmxlIGRyaXZpbmcgSVJRLg0KPiAgPg0KPiAgPiBUaGUgbG9vcCAo
NCkgaXMgbmVlZGVkIGJlY2F1c2Ugb2YgdGhlIHRpbWluZyB3aW5kb3cgYmV0d2Vlbg0KPiAgPiAo
MikgYW5kICgzKS4NCj4gID4gWW91IGNhbiBzd2FwICgyKSBhbmQgKDMpIG92ZXIgLSBidXQgdGhl
biB5b3UgZ2V0IGFuIGFkZGl0aW9uYWwNCj4gID4gaW50ZXJydXB0IGlmIHBhY2tldHMgYXJyaXZl
IGR1cmluZyBwcm9jZXNzaW5nIC0gd2hpY2ggaXMgY29tbW9uLg0KPiANCj4gU28gaW4gdGVybXMg
b2Ygc3VjaCBvdXRsaW5lLCB0aGUgInBvbGwgYXBwcm9hY2giIG5vdyBpbXBsZW1lbnRzIDEsIDIs
IDMsDQo+IDUgYnV0IHN0aWxsIG1pc3NlcyA0LCBhbmQgbXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0
IGl0IGlzIHRoZXJlZm9yZSBzdGlsbA0KPiBub3QgYSBjb21wbGV0ZSBzb2x1dGlvbiBmb3IgdGhl
IGJyb2tlbiB0cmlnZ2VyaW5nIGNhc2UgKEFsdGhvdWdoDQo+IHByYWN0aWNhbGx5LCB0aGUgdGlt
ZSB3aW5kb3cgbWlnaHQgYmUgdG9vIHNtYWxsIGZvciB0aGUgcmFjZSBlZmZlY3QgdG8NCj4gYmUg
ZXZlciBvYnNlcnZhYmxlKSBGcm9tIG15IHByZXZpb3VzIHRlc3RpbmcgSSBrbm93IHRoYXQgc3Vj
aCBhIGxvb3ANCj4gZG9lcyBub3QgYWZmZWN0IHRoZSBwZXJmb21hbmNlIHRvbyBtdWNoIGFueXdh
eSwgc28gaXQgc2VlbXMgcXVpdGUgc2FmZQ0KPiB0byBhZGQgaXQuIE1heWJlIEkndmUgbWlzc3Vu
ZGVyc3Rvb2Qgc29tZXRoaW5nIHRob3VnaC4NCg0KVGhlIHRpbWluZyB3aW5kb3cgKDQpIGhhcHBl
bnMuDQpUaGUgbmV4dCByZWNlaXZlIHBhY2tldCB3aWxsIHVzdWFsbHkgY2xlYXIgaXQgLSBidXQg
dGhhdCBtaWdodCByZXF1aXJlIGEgdGltZW91dC4NCkknbSBzdXJlIEkgZ290IGEgdHJpcCB0byBT
d2VkZW4gb3V0IG9mIGl0Lg0KDQpJIGFsc28gdGhpbmsgTGludXggcmVxdWlyZXMgdGhlIHR4LXJl
YXAgYmUgZG9uZSBpbiBhIHRpbWVseSBtYW5uZXIuDQpJZiB0aGF0IGlzIG9ubHkgZG9uZSBpbiBy
ZXNwb25zZSB0byBhbiBlbmQgb2YgdHggaW50ZXJydXB0IHRoZSBkZWxheQ0KY291bGQgYmUgc3Vi
c3RhbnRpYWwuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJy
YW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lz
dHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

