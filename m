Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48E6506682
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349713AbiDSIKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbiDSIKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:10:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB0472715E
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 01:07:54 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-127-e4KWbpF-O9CJiTd9liyVDw-1; Tue, 19 Apr 2022 09:07:51 +0100
X-MC-Unique: e4KWbpF-O9CJiTd9liyVDw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Tue, 19 Apr 2022 09:07:50 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Tue, 19 Apr 2022 09:07:50 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexander Lobakin' <alobakin@pm.me>, Song Liu <song@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "Jonathan Lemon" <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "Chenbo Feng" <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>
Subject: RE: [PATCH bpf-next 07/11] samples: bpf: fix uin64_t format literals
Thread-Topic: [PATCH bpf-next 07/11] samples: bpf: fix uin64_t format literals
Thread-Index: AQHYUbspso42ifnDw02kovtD5V7S26z25T3g
Date:   Tue, 19 Apr 2022 08:07:50 +0000
Message-ID: <9465da05497746b3b70d7c841a585d5b@AcuMS.aculab.com>
References: <20220414223704.341028-1-alobakin@pm.me>
 <20220414223704.341028-8-alobakin@pm.me>
 <CAPhsuW7FuAKX0fJ1XPfFWWwRS+wTW0qA49V-iQVzxv4jOb47MA@mail.gmail.com>
 <20220416174816.198651-1-alobakin@pm.me>
In-Reply-To: <20220416174816.198651-1-alobakin@pm.me>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQWxleGFuZGVyIExvYmFraW4NCj4gU2VudDogMTYgQXByaWwgMjAyMiAxODo1NQ0KPiBU
bzogU29uZyBMaXUgPHNvbmdAa2VybmVsLm9yZz4NCj4gDQo+IEZyb206IFNvbmcgTGl1IDxzb25n
QGtlcm5lbC5vcmc+DQo+IERhdGU6IEZyaSwgMTUgQXByIDIwMjIgMTY6NTI6MTMgLTA3MDANCj4g
DQo+ID4gT24gVGh1LCBBcHIgMTQsIDIwMjIgYXQgMzo0NiBQTSBBbGV4YW5kZXIgTG9iYWtpbiA8
YWxvYmFraW5AcG0ubWU+IHdyb3RlOg0KPiA+ID4NCj4gPiA+IFRoZXJlJ3MgYSBjb3VwbGUgcGxh
Y2VzIHdoZXJlIHVpbjY0X3QgaXMgYmVpbmcgcGFzc2VkIGFzIGFuICVsZA0KPiA+ID4gZm9ybWF0
IGFyZ3VtZW50LCB3aGljaCBpcyBpbmNvcnJlY3QgKHNob3VsZCBiZSAlbGxkKS4gRml4IHRoZW0u
DQo+ID4NCj4gPiBUaGlzIHdpbGwgY2F1c2Ugc29tZSB3YXJuaW5nIG9uIHNvbWUgNjQtYml0IGNv
bXBpbGVyLCBubz8NCj4gDQo+IE9oIHdhaXQsIEkgYWNjaWRlbnRpYWxseSBtZW50aW9uZWQgJWxk
IGFuZCAlbGxkIGFsdGhvdWdoIGluIGZhY3QgSQ0KPiBjaGFuZ2VkICVsdSB0byAlbGx1LiBTbyB0
aGVyZSB3b24ndCBiZSBhbnkgY29tcGlsZXIgd2FybmluZ3MuIEknbGwNCj4gZml4IHRoZSBjb21t
aXQgbWVzc2FnZSBpbiB2Mi4NCg0KVGhhdCB3b24ndCBtYWtlIGFueSBkaWZmZXJlbmNlLg0KVGhl
IGNvcnJlY3Qgd2F5IHRvIHByaW50IHVpbnQ2NF90IGlzIHVzaW5nIFBSSXU2NC4NCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

