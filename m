Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE736299980
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393297AbgJZWUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:20:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:46841 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393115AbgJZWUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 18:20:32 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-226-CxmIqS_MMd6bNjgoAN5dHg-1; Mon, 26 Oct 2020 22:20:28 +0000
X-MC-Unique: CxmIqS_MMd6bNjgoAN5dHg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 26 Oct 2020 22:20:27 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 26 Oct 2020 22:20:27 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Arnd Bergmann <arnd@arndb.de>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] bpf: suppress -Wcast-function-type warning
Thread-Topic: [PATCH] bpf: suppress -Wcast-function-type warning
Thread-Index: AQHWq9uAWK+UHblJmEuANCC8GziLxqmqc8OQ
Date:   Mon, 26 Oct 2020 22:20:27 +0000
Message-ID: <0f6785599a2f4903bd65c5e498b9a197@AcuMS.aculab.com>
References: <20201026210332.3885166-1-arnd@kernel.org>
In-Reply-To: <20201026210332.3885166-1-arnd@kernel.org>
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

RnJvbTogQXJuZCBCZXJnbWFubg0KPiBTZW50OiAyNiBPY3RvYmVyIDIwMjAgMjE6MDMNCj4gDQo+
IEZyb206IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+DQo+IA0KPiBCdWlsZGluZyB3aXRo
IC1XZXh0cmEgc2hvd3MgbG90cyBvZiB3YXJuaW5ncyBpbiB0aGUgYnBmDQo+IGNvZGUgc3VjaCBh
cw0KPiANCj4ga2VybmVsL2JwZi92ZXJpZmllci5jOiBJbiBmdW5jdGlvbiDigJhqaXRfc3VicHJv
Z3PigJk6DQo+IGluY2x1ZGUvbGludXgvZmlsdGVyLmg6MzQ1OjQ6IHdhcm5pbmc6IGNhc3QgYmV0
d2VlbiBpbmNvbXBhdGlibGUgZnVuY3Rpb24gdHlwZXMgZnJvbSDigJh1bnNpZ25lZCBpbnQNCj4g
KCopKGNvbnN0IHZvaWQgKiwgY29uc3Qgc3RydWN0IGJwZl9pbnNuICop4oCZIHRvIOKAmHU2NCAo
KikodTY0LCAgdTY0LCAgdTY0LCAgdTY0LCAgdTY0KeKAmSB7YWthIOKAmGxvbmcgbG9uZw0KPiB1
bnNpZ25lZCBpbnQgKCopKGxvbmcgbG9uZyB1bnNpZ25lZCBpbnQsICBsb25nIGxvbmcgdW5zaWdu
ZWQgaW50LCAgbG9uZyBsb25nIHVuc2lnbmVkIGludCwgIGxvbmcgbG9uZw0KPiB1bnNpZ25lZCBp
bnQsICBsb25nIGxvbmcgdW5zaWduZWQgaW50KeKAmX0gWy1XY2FzdC1mdW5jdGlvbi10eXBlXQ0K
PiAgIDM0NSB8ICAgKCh1NjQgKCopKHU2NCwgdTY0LCB1NjQsIHU2NCwgdTY0KSkoeCkpDQo+ICAg
ICAgIHwgICAgXg0KPiBrZXJuZWwvYnBmL3ZlcmlmaWVyLmM6MTA3MDY6MTY6IG5vdGU6IGluIGV4
cGFuc2lvbiBvZiBtYWNybyDigJhCUEZfQ0FTVF9DQUxM4oCZDQo+IDEwNzA2IHwgICAgaW5zbi0+
aW1tID0gQlBGX0NBU1RfQ0FMTChmdW5jW3N1YnByb2ddLT5icGZfZnVuYykgLQ0KPiAgICAgICB8
ICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn4NCj4gDQo+IFRoaXMgYXBwZWFycyB0byBiZSBp
bnRlbnRpb25hbCwgc28gY2hhbmdlIHRoZSBjYXN0IGluIGEgd2F5IHRoYXQNCj4gc3VwcHJlc3Nl
cyB0aGUgd2FybmluZy4NCg0KSXQgaXMgYWxzbyB1dHRlcmx5IGhvcnJpZC4NCklmIHRoZSB2YWx1
ZSBpcyBldmVyIGNhc3QgYmFjayB0aGVuIHRoZXJlIGlzIGEgbG90IG9mIHNjb3BlDQpmb3IgaXQg
Z29pbmcgYmFkbHkgd3Jvbmcgc29tZXdoZXJlLg0KSXQgY2VydGFpbmx5IGlzbid0IHZhbGlkIHRv
IHVzZSB0aGUgdGFyZ2V0IHR5cGUgdG8gY2FsbCB0aGUgb3JpZ2luYWwgZnVuY3Rpb24uDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

