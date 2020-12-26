Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F052E2F15
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 21:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgLZUm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 15:42:29 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:35321 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbgLZUm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 15:42:28 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-23-I-8rGLxaNH6OrhhBUzf87g-1; Sat, 26 Dec 2020 20:40:50 +0000
X-MC-Unique: I-8rGLxaNH6OrhhBUzf87g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 26 Dec 2020 20:40:48 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 26 Dec 2020 20:40:48 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tom Rix' <trix@redhat.com>, Joe Perches <joe@perches.com>,
        Simon Horman <simon.horman@netronome.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] nfp: remove h from printk format specifier
Thread-Topic: [PATCH] nfp: remove h from printk format specifier
Thread-Index: AQHW2s6Qh9Jx9VdXck+UoJgZsYMiQaoJ1s2w
Date:   Sat, 26 Dec 2020 20:40:48 +0000
Message-ID: <bf541f5de2624693ae96887afbfd04bc@AcuMS.aculab.com>
References: <20201223202053.131157-1-trix@redhat.com>
 <20201224202152.GA3380@netronome.com>
 <bac92bab-243b-ca48-647c-dad5688fa060@redhat.com>
 <18c81854639aa21e76c8b26cc3e7999b0428cc4e.camel@perches.com>
 <7b5517e6-41a9-cc7f-f42f-8ef449f3898e@redhat.com>
In-Reply-To: <7b5517e6-41a9-cc7f-f42f-8ef449f3898e@redhat.com>
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

RnJvbTogVG9tIFJpeA0KPiBTZW50OiAyNSBEZWNlbWJlciAyMDIwIDE0OjU3DQouLi4NCj4gPiBL
ZXJuZWwgY29kZSBkb2Vzbid0IHVzZSBhIHNpZ25lZCBjaGFyIG9yIHNob3J0IHdpdGggJWh4IG9y
ICVodSB2ZXJ5IG9mdGVuDQo+ID4gYnV0IGluIGNhc2UgeW91IGRpZG4ndCBhbHJlYWR5IGtub3cs
IGFueSBzaWduZWQgY2hhci9zaG9ydCBlbWl0dGVkIHdpdGgNCj4gPiBhbnl0aGluZyBsaWtlICVo
eCBvciAlaHUgbmVlZHMgdG8gYmUgbGVmdCBhbG9uZSBhcyBzaWduIGV4dGVuc2lvbiBvY2N1cnMg
c286DQo+IA0KPiBZZXMsIHRoaXMgd291bGQgYWxzbyBlZmZlY3QgY2hlY2twYXRjaC4NCg0KRG9l
cyB0aGUga2VybmVsIHByaW50ZiBkbyB0aGUgbWFza2luZyBmb3IgJWh4IGFuZCAlaGh4Pw0KQSBx
dWljayBjaGVjayBJIGRpZCBzaG93ZWQgdGhhdCAoYXQgbGVhc3Qgc29tZSB2ZXJzaW9ucyBvZikg
Z2xpYmMgZG9lcy4NCkJ1dCB0aGUgcHJpbnRmIGJ1aWx0aW4gaW4gYmFzaCBkb2Vzbid0Lg0KDQpJ
ZiB0aGUgbWFza2luZyBpcyB0aGVyZSB0aGVuICVoW2RpdXhdIGFuZCAlaGhbZGl1eF0gYXJlIHZh
bGlkDQpldmVuIHRob3VnaCB0aGUgdmFyYXJncyBzdXBwbGllZCBwYXJhbWV0ZXIgaXMgYWx3YXlz
IGV4dGVuZGVkIHRvDQphdCBsZWFzdCB0aGUgc2l6ZSBvZiBpbnQuDQoNClRoaXMgaXMgZXZlbiB0
cnVlIGlmIHRoZSBwYXJhbWV0ZXIgbWlnaHQgYmUgbGFyZ2UuDQpGb3IgaW5zdGFuY2UgZG9pbmc6
DQoJLi4uLCAiJWhoMDJ4OiVoaDAyeDolaGgwMng6JWhoMDJ4IiwgeCA+PiAyNCwgeCA+PiAxNiwg
eCA+PiA4LCB4KTsNCndpbGwgZ2VuZXJhdGUgc2xpZ2h0bHkgc21hbGxlciBjb2RlIHRoYW4gbWFz
a2luZyB0aGUgcGFzc2VkIHZhbHVlcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVz
cyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEg
MVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

