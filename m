Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF4F120FEA
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfLPQpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:45:39 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:36493 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbfLPQpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:45:39 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-48-DDDIDTkbM2-IdtSXm6boZQ-1; Mon, 16 Dec 2019 16:45:36 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 16 Dec 2019 16:45:35 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 16 Dec 2019 16:45:35 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?utf-8?B?J0Jqw7ZybiBUw7ZwZWwn?= <bjorn.topel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "thoiland@redhat.com" <thoiland@redhat.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
Subject: RE: [PATCH bpf-next v5 6/6] bpf, x86: align dispatcher branch targets
 to 16B
Thread-Topic: [PATCH bpf-next v5 6/6] bpf, x86: align dispatcher branch
 targets to 16B
Thread-Index: AQHVsd4ABA0oC/ymIkOBdFAQgZTG6qe8+uVQ
Date:   Mon, 16 Dec 2019 16:45:35 +0000
Message-ID: <1cb77c2dcfeb495c9e7c417edd7f43cc@AcuMS.aculab.com>
References: <20191213175112.30208-1-bjorn.topel@gmail.com>
 <20191213175112.30208-7-bjorn.topel@gmail.com>
In-Reply-To: <20191213175112.30208-7-bjorn.topel@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: DDDIDTkbM2-IdtSXm6boZQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQmrDtnJuIFTDtnBlbA0KPiBTZW50OiAxMyBEZWNlbWJlciAyMDE5IDE3OjUxDQo+IEZy
b206IEJqw7ZybiBUw7ZwZWwgPGJqb3JuLnRvcGVsQGludGVsLmNvbT4NCj4gDQo+IEZyb20gSW50
ZWwgNjQgYW5kIElBLTMyIEFyY2hpdGVjdHVyZXMgT3B0aW1pemF0aW9uIFJlZmVyZW5jZSBNYW51
YWwsDQo+IDMuNC4xLjQgQ29kZSBBbGlnbm1lbnQsIEFzc2VtYmx5L0NvbXBpbGVyIENvZGluZyBS
dWxlIDExOiBBbGwgYnJhbmNoDQo+IHRhcmdldHMgc2hvdWxkIGJlIDE2LWJ5dGUgYWxpZ25lZC4N
Cj4gDQo+IFRoaXMgY29tbWl0cyBhbGlnbnMgYnJhbmNoIHRhcmdldHMgYWNjb3JkaW5nIHRvIHRo
ZSBJbnRlbCBtYW51YWwuDQoNCkknZCBJZ25vcmUgdGhhdCBhZHZpY2UuLi4uDQpJdCBtYWtlcyB2
ZXJ5IGxpdHRsZSBkaWZmZXJlbmNlLCBhbmQgbm9uZSBhdCBhbGwgb24gbW9yZSByZWNlbnQgY3B1
Lg0KUmVhZCBodHRwczovL3d3dy5hZ25lci5vcmcvb3B0aW1pemUvbWljcm9hcmNoaXRlY3R1cmUu
cGRmDQpUaGUgZXh0cmEgY2FjaGUgZm9vdHByaW50IHByb2JhYmx5IG1ha2VzIGEgYmlnZ2VyIGRp
ZmZlcmVuY2UuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJy
YW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lz
dHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

