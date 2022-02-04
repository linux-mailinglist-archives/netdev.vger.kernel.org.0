Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1E24A9796
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358238AbiBDKSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:18:07 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:44081 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357686AbiBDKSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:18:07 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-11-iL5DZ5WfMwq3QzIiwTg0dw-1; Fri, 04 Feb 2022 10:18:04 +0000
X-MC-Unique: iL5DZ5WfMwq3QzIiwTg0dw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Fri, 4 Feb 2022 10:18:02 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Fri, 4 Feb 2022 10:18:02 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexander Duyck' <alexander.duyck@gmail.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Subject: RE: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
Thread-Topic: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
Thread-Index: AQHYGSdy3sa2eCpjBEavXhDJsDS/c6yDIqMg
Date:   Fri, 4 Feb 2022 10:18:02 +0000
Message-ID: <11f331492498494584f171c4ab8dc733@AcuMS.aculab.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-10-eric.dumazet@gmail.com>
 <ee1fedeb33cd989379b72faac0fd6a366966f032.camel@gmail.com>
 <CANn89iKxGvbXQqoRZZ5j22-5YkpiCLS13EGoQ1OYe3EHjEss6A@mail.gmail.com>
 <CAKgT0UeTvj_6DWUskxxaRiQQxcwg6j0u+UHDaougJSMdkogKWA@mail.gmail.com>
In-Reply-To: <CAKgT0UeTvj_6DWUskxxaRiQQxcwg6j0u+UHDaougJSMdkogKWA@mail.gmail.com>
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

RnJvbTogQWxleGFuZGVyIER1eWNrDQo+IFNlbnQ6IDAzIEZlYnJ1YXJ5IDIwMjIgMTc6NTcNCi4u
Lg0KPiA+ID4gU28gYSBiaWcgaXNzdWUgSSBzZWUgd2l0aCB0aGlzIHBhdGNoIGlzIHRoZSBwb3Rl
bnRpYWwgcXVldWVpbmcgaXNzdWVzDQo+ID4gPiBpdCBtYXkgaW50cm9kdWNlIG9uIFR4IHF1ZXVl
cy4gSSBzdXNwZWN0IGl0IHdpbGwgY2F1c2UgYSBudW1iZXIgb2YNCj4gPiA+IHBlcmZvcm1hbmNl
IHJlZ3Jlc3Npb25zIGFuZCBkZWFkbG9ja3MgYXMgaXQgd2lsbCBjaGFuZ2UgdGhlIFR4IHF1ZXVl
aW5nDQo+ID4gPiBiZWhhdmlvciBmb3IgbWFueSBOSUNzLg0KPiA+ID4NCj4gPiA+IEFzIEkgcmVj
YWxsIG1hbnkgb2YgdGhlIEludGVsIGRyaXZlcnMgYXJlIHVzaW5nIE1BWF9TS0JfRlJBR1MgYXMg
b25lIG9mDQo+ID4gPiB0aGUgaW5ncmVkaWVudHMgZm9yIERFU0NfTkVFREVEIGluIG9yZGVyIHRv
IGRldGVybWluZSBpZiB0aGUgVHggcXVldWUNCj4gPiA+IG5lZWRzIHRvIHN0b3AuIFdpdGggdGhp
cyBjaGFuZ2UgdGhlIHZhbHVlIGZvciBpZ2IgZm9yIGluc3RhbmNlIGlzDQo+ID4gPiBqdW1waW5n
IGZyb20gMjEgdG8gNDksIGFuZCB0aGUgd2FrZSB0aHJlc2hvbGQgaXMgdHdpY2UgdGhhdCwgOTgu
IEFzDQo+ID4gPiBzdWNoIHRoZSBtaW5pbXVtIFR4IGRlc2NyaXB0b3IgdGhyZXNob2xkIGZvciB0
aGUgZHJpdmVyIHdvdWxkIG5lZWQgdG8NCj4gPiA+IGJlIHVwZGF0ZWQgYmV5b25kIDgwIG90aGVy
d2lzZSBpdCBpcyBsaWtlbHkgdG8gZGVhZGxvY2sgdGhlIGZpcnN0IHRpbWUNCj4gPiA+IGl0IGhh
cyB0byBwYXVzZS4NCj4gPg0KPiA+IEFyZSB0aGVzZSBsaW1pdHMgaGFyZCBjb2RlZCBpbiBJbnRl
bCBkcml2ZXJzIGFuZCBmaXJtd2FyZSwgb3IgZG8geW91DQo+ID4gdGhpbmsgdGhpcyBjYW4gYmUg
Y2hhbmdlZCA/DQo+IA0KPiBUaGlzIGlzIGFsbCBjb2RlIGluIHRoZSBkcml2ZXJzLiBNb3N0IGRy
aXZlcnMgaGF2ZSB0aGVtIGFzIHRoZSBsb2dpYw0KPiBpcyB1c2VkIHRvIGF2b2lkIGhhdmluZyB0
byByZXR1cm4gTkVUSURFVl9UWF9CVVNZLiBCYXNpY2FsbHkgdGhlDQo+IGFzc3VtcHRpb24gaXMg
dGhlcmUgaXMgYSAxOjEgY29ycmVsYXRpb24gYmV0d2VlbiBkZXNjcmlwdG9ycyBhbmQNCj4gaW5k
aXZpZHVhbCBmcmFncy4gU28gbW9zdCBkcml2ZXJzIHdvdWxkIG5lZWQgdG8gaW5jcmVhc2UgdGhl
IHNpemUgb2YNCj4gdGhlaXIgVHggZGVzY3JpcHRvciByaW5ncyBpZiB0aGV5IHdlcmUgb3B0aW1p
emVkIGZvciBhIGxvd2VyIHZhbHVlLg0KDQpNYXliZSB0aGUgZHJpdmVycyBjYW4gYmUgYSBsaXR0
bGUgbGVzcyBjb25zZXJ2YXRpdmUgYWJvdXQgdGhlIG51bWJlcg0Kb2YgZnJhZ21lbnRzIHRoZXkg
ZXhwZWN0IGluIHRoZSBuZXh0IG1lc3NhZ2U/DQpUaGVyZSBpcyBsaXR0bGUgcG9pbnQgcmVxdWly
aW5nIDQ5IGZyZWUgZGVzY3JpcHRvcnMgd2hlbiB0aGUgd29ya2xvYWQNCm5ldmVyIGhhcyBtb3Jl
IHRoYW4gMiBvciAzIGZyYWdtZW50cy4NCg0KQ2xlYXJseSB5b3UgZG9uJ3Qgd2FudCB0byByZS1l
bmFibGUgdGhpbmdzIHVubGVzcyB0aGVyZSBhcmUgZW5vdWdoDQpkZXNjcmlwdG9ycyBmb3IgYW4g
c2tiIHRoYXQgaGFzIGdlbmVyYXRlZCBORVRERVZfVFhfQlVTWSwgYnV0IHRoZQ0KY3VycmVudCBs
b2dpYyBvZiAndHJ5aW5nIHRvIG5ldmVyIGFjdHVhbGx5IHJldHVybiBORVRERVZfVFhfQlVTWScN
CmlzIHByb2JhYmx5IG92ZXIgY2F1dGlvdXMuDQoNCkRvZXMgTGludXggYWxsb3cgc2tiIHRvIGhh
dmUgYSBsb3Qgb2Ygc2hvcnQgZnJhZ21lbnRzPw0KSWYgZG1hX21hcCBpc24ndCBjaGVhcCAocHJv
YmFibHkgYW55dGhpbmcgd2l0aCBhbiBpb21tdSBvciBub24tY29oZXJlbnQNCm1lbW9yeSkgdGhl
bSBjb3B5aW5nL21lcmdpbmcgc2hvcnQgZnJhZ21lbnRzIGludG8gYSBwcmUtbWFwcGVkDQpidWZm
ZXIgY2FuIGVhc2lseSBiZSBmYXN0ZXIuDQpNYW55IHllYXJzIGFnbyB3ZSBmb3VuZCBpdCB3YXMg
d29ydGggY29weWluZyBhbnl0aGluZyB1bmRlciAxayBvbg0KYSBzcGFyYyBtYnVzK3NidXMgc3lz
dGVtLg0KSSBkb24ndCB0aGluayBMaW51eCBjYW4gZ2VuZXJhdGUgd2hhdCBJJ3ZlIHNlZW4gZWxz
ZXdoZXJlIC0gdGhlIG1hYw0KZHJpdmVyIGJlaW5nIGFza2VkIHRvIHRyYW5zbWl0IHNvbWV0aGlu
ZyB3aXRoIDEwMDArIG9uZSBieXRlIGZyYWdtZW10cyENCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVy
ZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5
bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

