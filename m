Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9164B218AE
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 14:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfEQM5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 08:57:40 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:57511 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728575AbfEQM5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 08:57:40 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-101-g0dBW_K3ORqRsV6sBecm3g-1; Fri, 17 May 2019 13:57:37 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri,
 17 May 2019 13:57:37 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 17 May 2019 13:57:37 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        Adam Urban <adam.urban@appleguru.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: RE: Kernel UDP behavior with missing destinations
Thread-Topic: Kernel UDP behavior with missing destinations
Thread-Index: AQHVDF/dVLHMBGRH2UCXYs4ZosL7YqZvHIew
Date:   Fri, 17 May 2019 12:57:36 +0000
Message-ID: <655000834f584886ae87f5d8836837ba@AcuMS.aculab.com>
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
 <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
 <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com>
 <CABUuw67P+oZ+P4Ed4si5QB52aamhCKx80o47oU0jNjWzB6C3iw@mail.gmail.com>
 <CA+FuTSdcik=QLc=XMjWSFWty=zEm6_0Q3xKMo=1zi2_zNjwjpw@mail.gmail.com>
In-Reply-To: <CA+FuTSdcik=QLc=XMjWSFWty=zEm6_0Q3xKMo=1zi2_zNjwjpw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: g0dBW_K3ORqRsV6sBecm3g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2lsbGVtIGRlIEJydWlqbg0KPiBTZW50OiAxNyBNYXkgMjAxOSAwNDoyMw0KPiBPbiBU
aHUsIE1heSAxNiwgMjAxOSBhdCA4OjI3IFBNIEFkYW0gVXJiYW4gPGFkYW0udXJiYW5AYXBwbGVn
dXJ1Lm9yZz4gd3JvdGU6DQo+ID4NCj4gPiBBbmQgcmVwbHlpbmcgdG8geW91ciBlYXJsaWVyIGNv
bW1lbnQgYWJvdXQgVFRMLCB5ZXMgSSB0aGluayBhIFRUTCBvbg0KPiA+IGFycF9xdWV1ZXMgd291
bGQgYmUgaHVnZWx5IGhlbHBmdWwuDQo+ID4NCj4gPiBJbiBhbnkgZW52aXJvbm1lbnQgd2hlcmUg
eW91IGFyZSBzdHJlYW1pbmcgdGltZS1zZW5zaXRpdmUgVURQIHRyYWZmaWMsDQo+ID4geW91IHJl
YWxseSB3YW50IHRoZSBrZXJuZWwgdG8gYmUgdHVuZWQgdG8gaW1tZWRpYXRlbHkgZHJvcCB0aGUN
Cj4gPiBvdXRnb2luZyBwYWNrZXQgaWYgdGhlIGRlc3RpbmF0aW9uIGlzbid0IHlldCBrbm93bi9p
biB0aGUgYXJwIHRhYmxlDQo+ID4gYWxyZWFkeS4uLg0KDQpJIHN1c3BlY3Qgd2UgbWF5IHN1ZmZl
ciBmcm9tIHRoZSBzYW1lIHByb2JsZW1zIHdoZW4gc2VuZGluZyBvdXQgYSBsb3QNCm9mIFJUUCAo
dGhpbmsgb2Ygc2VuZGluZyAxMDAwcyBvZiBVRFAgbWVzc2FnZXMgdG8gZGlmZmVyZW50IGFkZHJl
c3Nlcw0KZXZlcnkgMjBtcykuDQpGb3IgdmFyaW91cyByZWFzb25zIHRoZSBzZW5kcyBhcmUgZG9u
ZSBmcm9tIGEgc2luZ2xlIHJhdyBzb2NrZXQgKHJhdGhlcg0KdGhhbiAnY29ubmVjdGVkJyBVRFAg
c29ja2V0cykuDQoNCj4gRm9yIHBhY2tldHMgdGhhdCBuZWVkIHRvIGJlIHNlbnQgaW1tZWRpYXRl
bHkgb3Igbm90IGF0IGFsbCwgeW91DQo+IHByb2JhYmx5IGRvIG5vdCB3YW50IGEgVFRMLCBidXQg
c2ltcGx5IGZvciB0aGUgc2VuZCBjYWxsIHRvIGZhaWwNCj4gaW1tZWRpYXRlbHkgd2l0aCBFQUdB
SU4gaW5zdGVhZCBvZiBxdWV1aW5nIHRoZSBwYWNrZXQgZm9yIEFSUA0KPiByZXNvbHV0aW9uIGF0
IGFsbC4gV2hpY2ggaXMgYXBwcm94aW1hdGVkIHdpdGggdW5yZXNfcWxlbiAwLg0KPiANCj4gVGhl
IHJlbGF0aW9uIGJldHdlZW4gdW5yZXNfcWxlbl9ieXRlcywgYXJwX3F1ZXVlIGFuZCBTT19TTkRC
VUYgaXMNCj4gcHJldHR5IHN0cmFpZ2h0Zm9yd2FyZCBpbiBwcmluY2lwYWwuIFBhY2tldHMgY2Fu
IGJlIHF1ZXVlZCBvbiB0aGUgYXJwDQo+IHF1ZXVlIHVudGlsIHRoZSBieXRlIGxpbWl0IGlzIHJl
YWNoZWQuIEFueSBwYWNrZXRzIG9uIHRoaXMgcXVldWUgc3RpbGwNCj4gaGF2ZSB0aGVpciBtZW1v
cnkgY291bnRlZCB0b3dhcmRzIHRoZWlyIHNvY2tldCBzZW5kIGJ1ZGdldC4gSWYgYQ0KPiBwYWNr
ZXQgaXMgcXVldWVkIHRoYXQgY2F1c2VzIHRvIGV4Y2VlZCB0aGUgdGhyZXNob2xkLCBvbGRlciBw
YWNrZXRzDQo+IGFyZSBmcmVlZCBhbmQgZHJvcHBlZCBhcyBuZWVkZWQuIENhbGN1bGF0aW5nIHRo
ZSBleGFjdCBudW1iZXJzIGlzIG5vdA0KPiBhcyBzdHJhaWdodGZvcndhcmQsIGFzLCBmb3IgaW5z
dGFuY2UsIHNrYi0+dHJ1ZXNpemUgaXMgYSBrZXJuZWwNCj4gaW1wbGVtZW50YXRpb24gZGV0YWls
Lg0KDQpCdXQgJ2ZpZGRsaW5nJyB3aXRoIHRoZSBhcnAgcXVldWUgd2lsbCBhZmZlY3QgYWxsIHRy
YWZmaWMuDQpTbyB5b3UnZCBuZWVkIGl0IHRvIGJlIHBlciBzb2NrZXQgb3B0aW9uIHNvIHRoYXQg
aXQgaXMgYSBwcm9wZXJ0eQ0Kb2YgdGhlIG1lc3NhZ2UgYnkgdGhlIHRpbWUgaXQgcmVhY2hlcyB0
aGUgYXJwIGNvZGUuDQoNCj4gVGhlIHNpbXBsZSBzb2x1dGlvbiBpcyBqdXN0IHRvIG92ZXJwcm92
aXNpb24gdGhlIHNvY2tldCBTT19TTkRCVUYuIElmDQo+IHRoZXJlIGFyZSBmZXcgc29ja2V0cyBp
biB0aGUgc3lzdGVtIHRoYXQgcGVyZm9ybSB0aGlzIHJvbGUsIHRoYXQgc2VlbXMNCj4gcGVyZmVj
dGx5IGZpbmUuDQoNClRoYXQgZGVwZW5kcyBvbiBob3cgb2Z0ZW4geW91IGFyZSBzZW5kaW5nIG1l
c3NhZ2VzIGNvbXBhcmVkIHRvIHRoZQ0KYXJwIHRpbWVvdXQuIElmIHlvdSBhcmUgc2VuZGluZyA1
MCBtZXNzYWdlcyBhIHNlY29uZCB0byBlYWNoIG9mIDEwMDANCmRlc3RpbmF0aW9ucyB0aGUgb3Zl
ciBwcm92aXNpb25pbmcgb2YgU09fU05EQlVGIHdvdWxkIGhhdmUgdG8gYmUgZXh0cmVtZS4NCg0K
RldJVyB3ZSBkbyBzb21ldGltZXMgc2VlIHNlbmRtc2coKSB0YWtpbmcgbXVjaCBsb25nZXIgdGhh
biBleHBlY3RlZCwNCmJ1dCBoYXZlbid0IGdldCB0cmFja2VkIGRvd24gd2h5Lg0KDQoJRGF2aWQN
Cg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZh
cm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYg
KFdhbGVzKQ0K

