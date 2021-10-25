Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BF043937C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 12:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhJYKTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:19:46 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26194 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbhJYKTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 06:19:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hd9p76bV5z8tvD;
        Mon, 25 Oct 2021 18:15:59 +0800 (CST)
Received: from dggema722-chm.china.huawei.com (10.3.20.86) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.15; Mon, 25 Oct 2021 18:17:19 +0800
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggema722-chm.china.huawei.com (10.3.20.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Mon, 25 Oct 2021 18:17:19 +0800
Received: from dggema772-chm.china.huawei.com ([10.9.128.138]) by
 dggema772-chm.china.huawei.com ([10.9.128.138]) with mapi id 15.01.2308.015;
 Mon, 25 Oct 2021 18:17:18 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub@cloudflare.com" <jakub@cloudflare.com>,
        "lmb@cloudflare.com" <lmb@cloudflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Subject: RE: [PATHC bpf v5 3/3] selftests, bpf: Add one test for sockmap with
 strparser
Thread-Topic: [PATHC bpf v5 3/3] selftests, bpf: Add one test for sockmap with
 strparser
Thread-Index: AQHXvzXp2/El6N6AFUS/uEEa0ZcKOaveryUAgATgOnA=
Date:   Mon, 25 Oct 2021 10:17:18 +0000
Message-ID: <c798b06f10f04a6588924e745ced655b@huawei.com>
References: <20211012065705.224643-1-liujian56@huawei.com>
 <20211012065705.224643-3-liujian56@huawei.com>
 <6172d93e2a470_82a7f2083@john-XPS-13-9370.notmuch>
In-Reply-To: <6172d93e2a470_82a7f2083@john-XPS-13-9370.notmuch>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9obiBGYXN0YWJlbmQg
W21haWx0bzpqb2huLmZhc3RhYmVuZEBnbWFpbC5jb21dDQo+IFNlbnQ6IEZyaWRheSwgT2N0b2Jl
ciAyMiwgMjAyMSAxMTozMSBQTQ0KPiBUbzogbGl1amlhbiAoQ0UpIDxsaXVqaWFuNTZAaHVhd2Vp
LmNvbT47IGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbTsNCj4gZGFuaWVsQGlvZ2VhcmJveC5uZXQ7
IGpha3ViQGNsb3VkZmxhcmUuY29tOyBsbWJAY2xvdWRmbGFyZS5jb207DQo+IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgYXN0QGtlcm5lbC5vcmc7DQo+IGFuZHJpaUBrZXJu
ZWwub3JnOyBrYWZhaUBmYi5jb207IHNvbmdsaXVicmF2aW5nQGZiLmNvbTsgeWhzQGZiLmNvbTsN
Cj4ga3BzaW5naEBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBicGZAdmdlci5r
ZXJuZWwub3JnOw0KPiB4aXlvdS53YW5nY29uZ0BnbWFpbC5jb20NCj4gQ2M6IGxpdWppYW4gKENF
KSA8bGl1amlhbjU2QGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJFOiBbUEFUSEMgYnBmIHY1IDMv
M10gc2VsZnRlc3RzLCBicGY6IEFkZCBvbmUgdGVzdCBmb3Igc29ja21hcCB3aXRoDQo+IHN0cnBh
cnNlcg0KPiANCj4gTGl1IEppYW4gd3JvdGU6DQo+ID4gQWRkIHRoZSB0ZXN0IHRvIGNoZWNrIHNv
Y2ttYXAgd2l0aCBzdHJwYXJzZXIgaXMgd29ya2luZyB3ZWxsLg0KPiA+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogTGl1IEppYW4gPGxpdWppYW41NkBodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+ICB0b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9zb2NrbWFwLmMgfCAzMw0KPiA+ICsrKysrKysr
KysrKysrKysrKysrLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKyksIDMg
ZGVsZXRpb25zKC0pDQo+IA0KPiBIaSBMaXUsDQo+IA0KPiBUaGlzIGlzIGEgZ29vZCB0ZXN0LCBi
dXQgd2Ugc2hvdWxkIGFsc28gYWRkIG9uZSB3aXRoIGEgcGFyc2VyIHJldHVybmluZyBhIHZhbHVl
DQo+IHRoYXQgaXMgbm90IHNrYi0+bGVuLiBUaGlzIGRvZXNuJ3QgY292ZXIgdGhlIGNhc2UgZml4
ZWQgaW4gcGF0Y2ggMS8zIGNvcnJlY3Q/DQo+IEZvciB0aGF0IHdlIHdvdWxkIG5lZWQgdG8gbW9k
aWZ5IHRoZSBCUEYgcHJvZyBpdHNlbGYgYXMgd2VsbA0KPiBzb2NrbWFwX3BhcnNlX3Byb2cuYy4N
Cj4gDQpIaSBKb2huLA0KVGhpcyB0ZXN0IHBhdGNoIHVzZSB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9icGYvcHJvZ3MvdGVzdF9zb2NrbWFwX2tlcm4uYyBub3Qgc29ja21hcF9wYXJzZV9wcm9nLmMu
DQoNCklmIHdlIHNldCBza2JfdXNlX3BhcnNlciB0byBub256ZXJvLCB0aGUgYnBmIHBhcnNlciBw
cm9ncmFtIHdpbGwgcmV0dXJuIHNrYl91c2VfcGFyc2VyIG5vdCBza2ItPmxlbi4NCkluIHRoaXMg
dGVzdCBjYXNlLCBJIHNldCBza2JfdXNlX3BhcnNlciB0byAxMCwgc2tiLT5sZW4gdG8gMjAgKG9w
dC0+aW92X2xlbmd0aCkuIA0KVGhpcyBjYW4gdGVzdCAxLzMgcGF0Y2gsIGl0IHdpbGwgY2hlY2sg
dGhlIHJlY3ZlZCBkYXRhIGxlbiBpcyAxMCBub3QgMjAuDQoNClRoZSBwYXJzZXIgcHJvZyBpbiB0
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9zb2NrbWFwX2tlcm4uaA0KU0VD
KCJza19za2IxIikNCmludCBicGZfcHJvZzEoc3RydWN0IF9fc2tfYnVmZiAqc2tiKQ0Kew0KICAg
ICAgICBpbnQgKmYsIHR3byA9IDI7DQoNCiAgICAgICAgZiA9IGJwZl9tYXBfbG9va3VwX2VsZW0o
JnNvY2tfc2tiX29wdHMsICZ0d28pOw0KICAgICAgICBpZiAoZiAmJiAqZikgew0KICAgICAgICAg
ICAgICAgIHJldHVybiAqZjsNCiAgICAgICAgfQ0KICAgICAgICByZXR1cm4gc2tiLT5sZW47DQp9
DQo+IEZvciB0aGlzIHBhdGNoIHRob3VnaCwNCj4gDQo+IEFja2VkLWJ5OiBKb2huIEZhc3RhYmVu
ZCA8am9obi5mYXN0YWJlbmRAZ21haWwuY29tPg0KPiANCj4gVGhlbiBvbmUgbW9yZSBwYXRjaCBp
cyBhbGwgd2UgbmVlZCBzb21ldGhpbmcgdG8gYnJlYWsgdXAgdGhlIHNrYiBmcm9tIHRoZQ0KPiBw
YXJzZXIuIFdlIHJlYWxseSBuZWVkIHRoZSB0ZXN0IGJlY2F1c2UgaXRzIG5vdCBzb21ldGhpbmcg
d2UgY2FuIGVhc2lseSB0ZXN0DQo+IG90aGVyd2lzZSBhbmQgSSBkb24ndCBoYXZlIGFueSB1c2Ug
Y2FzZXMgdGhhdCBkbyB0aGlzIHNvIHdvdWxkbid0IGNhdGNoIGl0Lg0KPiANCj4gVGhhbmtzIQ0K
PiBKb2huDQo=
