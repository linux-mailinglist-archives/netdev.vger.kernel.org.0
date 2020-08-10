Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC2E240346
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 10:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgHJIPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 04:15:53 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:55701 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbgHJIPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 04:15:52 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-197-nvd0HwJXOMeNqVEmqPMuVw-1; Mon, 10 Aug 2020 09:15:49 +0100
X-MC-Unique: nvd0HwJXOMeNqVEmqPMuVw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 10 Aug 2020 09:15:48 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 10 Aug 2020 09:15:48 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'luobin (L)'" <luobin9@huawei.com>,
        Kees Cook <keescook@chromium.org>
CC:     David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "luoxianjun@huawei.com" <luoxianjun@huawei.com>,
        "yin.yinshi@huawei.com" <yin.yinshi@huawei.com>,
        "cloud.wangxiaoyun@huawei.com" <cloud.wangxiaoyun@huawei.com>,
        "chiqijun@huawei.com" <chiqijun@huawei.com>
Subject: RE: [PATCH net-next v1] hinic: fix strncpy output truncated compile
 warnings
Thread-Topic: [PATCH net-next v1] hinic: fix strncpy output truncated compile
 warnings
Thread-Index: AQHWbF+/LM1G8mFmIkykQEWb0Xuu7aksYh5wgAK89iyAAeG0UA==
Date:   Mon, 10 Aug 2020 08:15:48 +0000
Message-ID: <fad888cb3cdc4a05b091bf22711479b0@AcuMS.aculab.com>
References: <20200807020914.3123-1-luobin9@huawei.com>
 <e7a4fcf12a4e4d179e2fae8ffb44f992@AcuMS.aculab.com>
 <b886a6ff-8ed8-c857-f190-e99f8f735e02@huawei.com>
 <20200807.204243.696618708291045170.davem@davemloft.net>
 <202008072320.03879DAC@keescook>
 <493cae67-6346-1a57-5cca-65a2b6d2aeba@huawei.com>
In-Reply-To: <493cae67-6346-1a57-5cca-65a2b6d2aeba@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBUaGFua3MgZm9yIHlvdXIgZXhwbGFuYXRpb24gYW5kIHJldmlldy4gSSBoYXZlbid0IHJlYWxp
emVkIHVzaW5nIHN0cm5jcHkoKSBvbiBOVUwtdGVybWluYXRlZCBzdHJpbmdzDQo+IGlzIGRlcHJl
Y2F0ZWQNCj4gYW5kIGp1c3QgdHJ5aW5nIHRvIGF2b2lkIHRoZSBjb21waWxlIHdhcm5pbmdzLiBU
aGUgd2Vic2l0ZSB5b3UgcHJvdmlkZSBoZWxwcyBtZSBhIGxvdC4gVGhhbmsgeW91IHZlcnkNCj4g
bXVjaCENCg0KTmV2ZXIgdHJ5IHRvIHJlbW92ZSBjb21waWxlLXRpbWUgd2FybmluZ3Mgd2l0aG91
dCB1bmRlcnN0YW5kaW5nDQp3aGF0ICB0aGUgY29kZSBpdCBkb2luZy4NCg0KVGhlIGJhc2ljIHBy
b2JsZW0gaXMgdGhhdCBzdHJuY3B5KCkgYWxtb3N0IFsxXSBuZXZlciBkb2VzIHdoYXQgeW91IHdh
bnQuDQpJdCByZWFsbHkgZXhwZWN0cyBpdCdzIGlucHV0IHN0cmluZyB0byBiZSAnXDAnIHRlcm1p
bmF0ZWQgYnV0DQpkb2Vzbid0IGd1YXJhbnRlZSB0aGUgb3V0cHV0IHdpbGwgYmUsIGFuZCBhbHNv
ICh0eXBpY2FsbHkpIHdhc3Rlcw0KY3B1IGN5Y2xlcyB6ZXJvIGZpbGxpbmcgdGhlIG91dHB1dCBi
dWZmZXIuDQoNClNvbWVvbmUgdGhlbiBkZWZpbmVkIHN0cnNjcHkoKSBhcyBhbiBhbHRlcm5hdGl2
ZSwgaXQgZ3VhcmFudGVlcw0KdG8gJ1wwJyB0aGUgb3V0cHV0IGFuZCBkb2Vzbid0IHplcm8gZmls
bCAtIHdoaWNoIGNhbiBiZSBhbiBpc3N1ZS4NCkhvd2V2ZXIgc3Ryc2NweSgpIGhhcyBpdCdzIG93
biBwcm9ibGVtcywgdGhlIHJldHVybiB2YWx1ZSBpcw0KZGVmaW5lZCB0byBiZSB0aGUgbGVuZ3Ro
IG9mIHRoZSBpbnB1dCBzdHJpbmcgLSB3aGljaCBhYnNvbHV0ZWx5DQpyZXF1aXJlcyBpdCBiZSAn
XDAnIHRlcm1pbmF0ZWQuIFdpdGggJ3Vua25vd24nIGlucHV0IHRoaXMgY2FuDQpwYWdlIGZhdWx0
IQ0KDQpbMV0gVGhpcyBmcmFnbWVudCBsb29rZWQgd3JvbmcsIGJ1dCB3YXMgcmlnaHQhDQoJc3Ry
bmNweShkZXN0LCBzcmMsIHNpemVvZiBzcmMpOw0KTmFpdmUgY29udmVyc2lvbiB0byByZW1vdmUg
dGhlIHN0cm5jcHkoKSBicm9rZSBpdC4NCkluIGZhY3QgJ2Rlc3QnIHdhcyAxIGJ5dGUgbG9uZ2Vy
IHRoYW4gJ3NyYycgYW5kIGFscmVhZHkNCnplcm8gZmlsbGVkLCAnc3JjJyBtaWdodCBub3QgaGF2
ZSBiZWVuICdcMCcgdGVybWluYXRlZC4NCkl0IGlzIGFib3V0IHRoZSBvbmx5IHRpbWUgc3RybmNw
eSgpIGlzIHdoYXQgeW91IHdhbnQhDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3Mg
TGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQ
VCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

