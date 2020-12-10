Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074D72D5695
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732556AbgLJJQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:16:45 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:48119 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388948AbgLJJQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:16:17 -0500
X-Greylist: delayed 42763 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2020 04:16:16 EST
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-22-d2LaCE-KOWaxiGCsoXYLMQ-1; Thu, 10 Dec 2020 09:14:37 +0000
X-MC-Unique: d2LaCE-KOWaxiGCsoXYLMQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 10 Dec 2020 09:14:36 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 10 Dec 2020 09:14:36 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xie He' <xie.he.0141@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin Schiller" <ms@dev.tdt.de>
Subject: RE: [PATCH net-next] net: x25: Remove unimplemented X.25-over-LLC
 code stubs
Thread-Topic: [PATCH net-next] net: x25: Remove unimplemented X.25-over-LLC
 code stubs
Thread-Index: AQHWzdxRX1QgNEu/LUu372JTopy8S6nvRYJAgAAbHICAAKnREA==
Date:   Thu, 10 Dec 2020 09:14:36 +0000
Message-ID: <3e7fb08afd624399a7f689c2b507a01e@AcuMS.aculab.com>
References: <20201209033346.83742-1-xie.he.0141@gmail.com>
 <801dc0320e484bf7a5048c0cddac12af@AcuMS.aculab.com>
 <CAJht_EMQFtR_-QH=QMHt9+cLcNO6LHBSy2fy=mgbic+=JUsR-Q@mail.gmail.com>
In-Reply-To: <CAJht_EMQFtR_-QH=QMHt9+cLcNO6LHBSy2fy=mgbic+=JUsR-Q@mail.gmail.com>
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

RnJvbTogWGllIEhlDQo+IFNlbnQ6IDA5IERlY2VtYmVyIDIwMjAgMjI6NTQNCj4gDQo+IE9uIFdl
ZCwgRGVjIDksIDIwMjAgYXQgMToyMSBQTSBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBhY3Vs
YWIuY29tPiB3cm90ZToNCj4gPg0KPiA+IEkgYWx3YXlzIHdvbmRlcmVkIGFib3V0IHJ1bm5pbmcg
Q2xhc3MgMiB0cmFuc3BvcnQgZGlyZWN0bHkgb3ZlciBMTEMyDQo+ID4gKHJhdGhlciB0aGFuIENs
YXNzIDQgb3ZlciBMTEMxKS4NCj4gPiBCdXQgdGhlIG9ubHkgTExDMiB1c2VyIHdhcyBuZXRiaW9z
IC0gYW5kIG1pY3Jvc29mdCdzIExMQzIgd2FzIGJyb2tlbi4NCj4gPiBOb3QgdG8gbWVudGlvbiB0
aGUgd2luZG93IHByb2JpbmcgbmVlZGVkIHRvIGhhbmRsZSBzeXN0ZW1zIHRoYXQNCj4gPiBzYWlk
IHRoZXkgc3VwcG9ydGVkIGEgd2luZG93IG9mIChJSVJDKSAxNSBidXQgd291bGQgZGlzY2FyZCB0
aGUNCj4gPiA1dGggYmFjayB0byBiYWNrIGZyYW1lLg0KPiANCj4gVG8gbWUsIExMQzEgYW5kIExM
QzIgYXJlIHRvIEV0aGVybmV0IHdoYXQgVURQIGFuZCBUQ1AgYXJlIHRvIElQDQo+IG5ldHdvcmtz
LiBJIHRoaW5rIHdlIGNhbiB1c2UgTExDMSBhbmQgTExDMiB3aGVyZXZlciBVRFAgYW5kIFRDUCBj
YW4gYmUNCj4gdXNlZCwgYXMgbG9uZyBhcyB3ZSBhcmUgaW4gdGhlIHNhbWUgTEFOIGFuZCBhcmUg
d2lsbGluZyB0byB1c2UgTUFDDQo+IGFkZHJlc3NlcyBhcyB0aGUgYWRkcmVzc2VzLg0KDQpFeGNl
cHQgdGhhdCB5b3UgZG9uJ3QgaGF2ZSBhbnkgd2hlcmUgbmVhciBlbm91Z2ggJ3BvcnRzJyBzbyB5
b3UgbmVlZA0Kc29tZXRoaW5nIHRvIGRlbXVsdGlwbGV4IG1lc3NhZ2VzIHRvIGRpZmZlcmVudCBh
cHBsaWNhdGlvbnMuDQoNCldlIChJQ0wpIGFsd2F5cyByYW4gY2xhc3MgNCB0cmFuc3BvcnQgKHdo
aWNoIGRvZXMgZXJyb3IgcmVjb3ZlcnkpDQpkaXJlY3RseSBvdmVyIExMQzEgdXNpbmcgTUFDIGFk
ZHJlc3MgKGEgTlVMIGJ5dGUgZm9yIHRoZSBuZXR3b3JrIGxheWVyKS4NClRoaXMgcmVxdWlyZXMg
YSBicmlkZ2VkIG5ldHdvcmsgYW5kIGdsb2JhbGx5IHVuaXF1ZSBNQUMgYWRkcmVzc2VzLg0KU2Vu
ZGluZyBvdXQgYW4gTExDIHJlZmxlY3QgcGFja2V0IHRvIHRoZSBicm9hZGNhc3QgTUFDIGFkZHJl
c3MgdXNlZCB0bw0KZ2VuZXJhdGUgYSBjb3VwbGUgb2YgdGhvdXNhbmQgcmVzcG9uc2VzIChtYW55
IHdvdWxkIGdldCBkaXNjYXJkZWQNCmJlY2F1c2UgdGhlIGJyaWRnZXMgZ290IG92ZXJsb2FkZWQp
Lg0KDQo+IFguMjUgbGF5ZXIgMyBjZXJ0YWlubHkgY2FuIGFsc28gcnVuIG92ZXIgTExDMi4NCg0K
WW91IGRvbid0IG5lZWQgWC4yNSBsYXllciAzLg0KWC4yNSBsYXllciAyIGRvZXMgZXJyb3IgcmVj
b3Zlcnkgb3ZlciBhIHBvaW50LXRvLXBvaW50IGxpbmsuDQpYLjI1IGxheWVyIDMgZG9lcyBzd2l0
Y2hpbmcgYmV0d2VlbiBtYWNoaW5lcy4NCkNsYXNzIDIgdHJhbnNwb3J0IGRvZXMgbXVsdGlwbGV4
aW5nIG92ZXIgYSByZWxpYWJsZSBsb3dlciBsYXllci4NClNvIHlvdSBub3JtYWxseSBuZWVkIGFs
bCB0aHJlZS4NCg0KSG93ZXZlciBMTEMyIGdpdmVzIHlvdSBhIHJlbGlhYmxlIGNvbm5lY3Rpb24g
YmV0d2VlbiB0d28gbWFjaGluZXMNCihzZWxlY3RlZCBieSBNQUMgYWRkcmVzcykuDQpTbyB5b3Ug
c2hvdWxkIGJlIGFibGUgdG8gcnVuIENsYXNzIDIgdHJhbnNwb3J0ICh3ZWxsIG9uZSBvZiBpdHMN
CjQgdmFyaWFudHMhKSBkaXJlY3RseSBvdmVyIExMMi4NCg0KVGhlIGFkdmFudGFnZSBvdmVyIENs
YXNzIDQgdHJhbnNwb3J0IG92ZXIgTExDMSBpcyB0aGF0IHRoZXJlIGlzDQpvbmx5IG9uZSBzZXQg
b2YgcmV0cmFuc21pdCBidWZmZXJzIChldGMpIHJlZ2FyZGxlc3Mgb2YgdGhlIG51bWJlcg0Kb2Yg
Y29ubmVjdGlvbnMuDQoNCkJ1dCB0aGlzIGlzIGFsbCAzMCB5ZWFyIG9sZCBoaXN0b3J5Li4uDQoN
CglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwg
TW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzog
MTM5NzM4NiAoV2FsZXMpDQo=

