Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5232B819D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgKRQTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:19:14 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:45643 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726110AbgKRQTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:19:13 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-8-THpUwe-mO1GkQJ3DCpN0sA-1; Wed, 18 Nov 2020 16:19:10 +0000
X-MC-Unique: THpUwe-mO1GkQJ3DCpN0sA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 18 Nov 2020 16:19:09 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 18 Nov 2020 16:19:09 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Mathieu Desnoyers' <mathieu.desnoyers@efficios.com>,
        rostedt <rostedt@goodmis.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-toolchains <linux-toolchains@vger.kernel.org>
Subject: RE: violating function pointer signature
Thread-Topic: violating function pointer signature
Thread-Index: Ada9xosijLd/DjVTQ26YGUc47fMkpg==
Date:   Wed, 18 Nov 2020 16:19:09 +0000
Message-ID: <dade033f8ffa4b5fb01627bee0d55825@AcuMS.aculab.com>
References: <20201116175107.02db396d@gandalf.local.home>
 <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
 <20201117142145.43194f1a@gandalf.local.home>
 <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
 <20201117153451.3015c5c9@gandalf.local.home>
 <20201118132136.GJ3121378@hirez.programming.kicks-ass.net>
 <20201118090256.55656208@gandalf.local.home>
 <1762005214.49230.1605715285133.JavaMail.zimbra@efficios.com>
In-Reply-To: <1762005214.49230.1605715285133.JavaMail.zimbra@efficios.com>
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

RnJvbTogTWF0aGlldSBEZXNub3llcnMNCj4gU2VudDogMTggTm92ZW1iZXIgMjAyMCAxNjowMQ0K
Li4uDQo+ID4gSWYgaXQgaXMgYWxyZWFkeSBkb25lIGVsc2V3aGVyZSBpbiB0aGUga2VybmVsLCB0
aGVuIEkgd2lsbCBjYWxsIHRoaXMNCj4gPiBwcmVjZWRlbmNlLCBhbmQga2VlcCB0aGUgb3JpZ2lu
YWwgdmVyc2lvbi4NCj4gDQo+IEl0IHdvcmtzIGZvciBtZS4gQm9udXMgcG9pbnRzIGlmIHlvdSBj
YW4gZG9jdW1lbnQgaW4gYSBjb21tZW50IHRoYXQgdGhpcw0KPiB0cmljayBkZXBlbmRzIG9uIHRo
ZSBjZGVjbCBjYWxsaW5nIGNvbnZlbnRpb24uDQoNCkl0IGhhcyBub3RoaW5nIHRvIGRvIHdpdGgg
J2NkZWNsJyAtIHdoaWNoIElJUkMgaXMgYSBtaWNyb3NvZnQgdGVybS4NCg0KSGlzdG9yaWNhbGx5
IEMganVzdCBwdXNoZWQgYXJndW1lbnRzIG9uIHRoZSBzdGFjayAobm8gcHJvdG90eXBlcykNClRo
ZSBjYWxsaW5nIGNvZGUga25ldyBub3RoaW5nIGFib3V0IHRoZSBjYWxsZWQgY29kZSBvciB3aGV0
aGVyIGENCmZ1bmN0aW9uIG1pZ2h0IGV4cGVjdCB0byBoYXZlIGEgdmFyaWFibGUgbnVtYmVyIG9m
IGFyZ3VtZW50cy4NClRvIHN0b3AgdGhpcyBnb2luZyBob3JyaWJseSB3cm9uZyB0aGUgc3RhY2sg
aXMgdGlkaWVkIHVwIGJ5IHRoZSBjYWxsZXIuDQoNClBBU0NBTCAod2hpY2ggZG9lc24ndCByZWFs
bHkgc3VwcG9ydCBsaW5raW5nISkgZGlkbid0IHN1cHBvcnQNCnZhcmlhYmxlIGFyZ3VtZW50IGxp
c3RzIGFuZCB3b3VsZCBnZXQgdGhlIGNhbGxlZCBjb2RlIHRvIHJlbW92ZQ0KdGhlIGFyZ3VtZW50
cyAod2hpY2ggaXMgd2h5IHg4NiBoYXMgYSAncmV0IG4nIGluc3RydWN0aW9uKS4NCkluIHByaW5j
aXBsZSB0aGlzIGdlbmVyYXRlcyBzbWFsbGVyL2Zhc3RlciBjb2RlIGFuZCBtYW55IG9mIHRoZQ0K
MzJiaXQgd2luZG93cyBmdW5jdGlvbnMgdXNlIGl0IC0gcHJvYmFibHkgZHVlIHRvIHR1cmJvLXBh
c2NhbCkuDQoNCk1vZGVybiBjYWxsaW5nIGNvbnZlbnRpb25zIHRlbmQgdG8gcGFzcyBzb21lIGFy
Z3VtZW50cyBpbiByZWdpc3RlcnMuDQpBbGwgdGhlIG9uZXMgdGhhdCBnZXQgdXNlZCAoYnkgZGVm
YXVsdCkgb24gbGludXggd2lsbCBnZXQgdGhlDQpjYWxsZXIgdG8gdGlkeSB0aGUgc3RhY2suDQpB
bHRob3VnaCBzb21lIG1heSB1c2UgYSBzaW1wbGVyIGNhbGxpbmcgY29udmVudGlvbiBmb3IgdmFy
YXJncyBmdW5jdGlvbnMuDQoNClNvIGEgY29tbW9uICdyZXR1cm4gY29uc3RhbnQnIGZ1bmN0aW9u
IGNhbiBiZSBjYWxsZWQgZnJvbSBhbnkgY2FsbCBzaXRlLg0KQnV0IGl0IHlvdSBhY3R1YWxseSBj
YWxsIGEgcmVhbCBmdW5jdGlvbiAodGhhdCBsb29rcyBhdCB0aGUgYXJndW1lbnRzKQ0KeW91IGJl
dHRlciBoYXZlIGEgbWF0Y2hpbmcgcHJvdG90eXBlLg0KKGVnIGNhc3QgdGhlIGZ1bmN0aW9uIHBv
aW50ZXIgYmFjayB0byB0aGUgY29ycmVjdCBvbmUgYmVmb3JlIHRoZSBjYWxsLikNCg0KVGhlcmUg
YXJlIGNhbGxpbmcgY29udmVudGlvbnMgd2hlcmUgcG9pbnRlciBhbmQgaW50ZWdlciBwYXJhbWV0
ZXJzDQphbmQgcmVzdWx0cyBhcmUgcGFzc2VkIGluIGRpZmZlcmVudCByZWdpc3RlcnMuDQpUaGUg
dXN1YWwgZGVmaW5pdGlvbiBvZiBpb2N0bCgpIGlzIHR5cGljYWxseSBicm9rZW4uDQoNCglEYXZp
ZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQg
RmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4
NiAoV2FsZXMpDQo=

