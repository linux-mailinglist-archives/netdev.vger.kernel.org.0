Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F39E116BA0
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 12:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfLILBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 06:01:39 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:23648 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727163AbfLILBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 06:01:36 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-195-oi3zS5NyMcuX2OLZVzunJg-1; Mon, 09 Dec 2019 11:01:31 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 9 Dec 2019 11:01:30 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 9 Dec 2019 11:01:30 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
Thread-Topic: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
Thread-Index: AdWsNynavvs+VRwOQ6mSStk+IzVA6AACUqqAAI3fO8A=
Date:   Mon, 9 Dec 2019 11:01:30 +0000
Message-ID: <efffc167eff1475f94f745f733171d59@AcuMS.aculab.com>
References: <23db23416d3148fa86e54dccc6152266@AcuMS.aculab.com>
 <dc10298d-4280-b9b4-9203-be4000e85c42@gmail.com>
In-Reply-To: <dc10298d-4280-b9b4-9203-be4000e85c42@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: oi3zS5NyMcuX2OLZVzunJg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDA2IERlY2VtYmVyIDIwMTkgMTQ6MjINCi4uLg0K
PiBSZWFsIHF1ZXN0aW9uIGlzIDogRG8geW91IGFjdHVhbGx5IG5lZWQgdG8gdXNlIHJlY3Ztc2co
KSBpbnN0ZWFkIG9mIHJlY3Zmcm9tKCkgPw0KPiBJZiByZWN2bXNnKCkgcHJvdmlkZXMgYWRkaXRp
b25hbCBjbXNnLCB0aGlzIGlzIG5vdCBzdXJwcmlzaW5nIGl0IGlzIG1vcmUgZXhwZW5zaXZlLg0K
DQpFeGNlcHQgSSdtIG5vdCBwYXNzaW5nIGluIGEgYnVmZmVyIGZvciBpdC4NClRoZSByZWFzb24g
SSdtIGxvb2tpbmcgYXQgcmVjdm1zZyBpcyB0aGF0IEknZCBsaWtlIHRvIHVzZSByZWN2bW1zZyBp
dCBvcmRlciB0bw0KcmVhZCBvdXQgbW9yZSB0aGFuIG9uZSBtZXNzYWdlIGZyb20gYSBzb2NrZXQg
d2l0aG91dCBkb2luZyBhbiBleHRyYSBwb2xsKCkuDQpOb3RlIHRoYXQgSSBkb24ndCBleHBlY3Qg
dGhlcmUgdG8gYmUgYSBzZWNvbmQgbWVzc2FnZSBtb3N0IG9mIHRoZSB0aW1lIGFuZA0KYWxtb3N0
IG5ldmVyIGEgdGhpcmQgb25lLg0KDQpBbHRob3VnaCBJIHRoaW5rIHRoYXQgd2lsbCBvbmx5IGV2
ZXIgJ3dpbicgaWYgcmVjdm1tc2coKSBjYWxsZWQgdmZzX3BvbGwoKSB0byBmaW5kDQppZiB0aGVy
ZSB3YXMgbW9yZSBkYXRhIHRvIHJlYWQgYmVmb3JlIGRvaW5nIGFueSBvZiB0aGUgY29weV9mcm9t
X3VzZXIoKSBldGMuDQoNCj4gcmVjdm1zZygpIGFsc28gdXNlcyBhbiBpbmRpcmVjdCBjYWxsLCBz
byBDT05GSUdfUkVUUE9MSU5FPXkgaXMgcHJvYmFibHkgaHVydGluZy4NCg0KSSBkb24ndCBoYXZl
IENPTkZJR19SRVRQT0xJTkUgZW5hYmxlZCwgdGhlIGNvbXBpbGVyIEknbSB1c2luZyBpcyB0b28g
b2xkLg0KKGdjYyA0LjcuMykuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFr
ZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwg
VUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

