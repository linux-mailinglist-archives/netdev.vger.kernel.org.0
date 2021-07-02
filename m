Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C9A3BA257
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhGBOuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:50:24 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:20850 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232607AbhGBOuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:50:23 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-74-fqCV_caBPBSWmy0ru-nyQg-1; Fri, 02 Jul 2021 15:47:48 +0100
X-MC-Unique: fqCV_caBPBSWmy0ru-nyQg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 2 Jul
 2021 15:47:47 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Fri, 2 Jul 2021 15:47:47 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kumar Kartikeya Dwivedi' <memxor@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Leblond <eric@regit.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH net-next v6 2/5] bitops: add non-atomic bitops for
 pointers
Thread-Topic: [PATCH net-next v6 2/5] bitops: add non-atomic bitops for
 pointers
Thread-Index: AQHXbzRKzJTJSAg3rk6Hii1kaDElvqsvwdKQ
Date:   Fri, 2 Jul 2021 14:47:47 +0000
Message-ID: <0660a065aad94979a560682cef5d573c@AcuMS.aculab.com>
References: <20210702111825.491065-1-memxor@gmail.com>
 <20210702111825.491065-3-memxor@gmail.com>
In-Reply-To: <20210702111825.491065-3-memxor@gmail.com>
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

RnJvbTogS3VtYXIgS2FydGlrZXlhIER3aXZlZGkNCj4gU2VudDogMDIgSnVseSAyMDIxIDEyOjE4
DQo+IA0KPiBjcHVtYXAgbmVlZHMgdG8gc2V0LCBjbGVhciwgYW5kIHRlc3QgdGhlIGxvd2VzdCBi
aXQgaW4gc2tiIHBvaW50ZXIgaW4NCj4gdmFyaW91cyBwbGFjZXMuIFRvIG1ha2UgdGhlc2UgY2hl
Y2tzIGxlc3Mgbm9pc3ksIGFkZCBwb2ludGVyIGZyaWVuZGx5DQo+IGJpdG9wIG1hY3JvcyB0aGF0
IGFsc28gZG8gc29tZSB0eXBlY2hlY2tpbmcgdG8gc2FuaXRpemUgdGhlIGFyZ3VtZW50Lg0KDQpX
b3VsZCB0aGlzIHdvcms/DQojZGVmaW5lIEJJVF9PUCh2YWwsIG9wKSAoKHR5cGVvZiAodmFsKSko
KHVuc2lnbmVkIGxvbmcpKHZhbCkgb3ApKQ0KDQpTaG91bGQgbGV0IHlvdSBkbzoNCglwdHIgPSBC
SVRfT1AocHRyLCB8IDEpOw0KCXB0ciA9IEJJVF9PUChwdHIsICYgfjEpOw0KCWlmIChCSVRfT1BU
KHB0ciwgJiAxKSkNCgkJLi4uDQoNClNlZSBodHRwczovL2dvZGJvbHQub3JnL3ovRTU3YUdLNGpz
DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9h
ZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBO
bzogMTM5NzM4NiAoV2FsZXMpDQo=

