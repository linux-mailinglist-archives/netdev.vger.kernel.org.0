Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BB6245551
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 03:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgHPBth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 21:49:37 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3477 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726029AbgHPBtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 21:49:36 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 697626213E0D19D47355;
        Sat, 15 Aug 2020 09:48:19 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 15 Aug 2020 09:48:18 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Sat, 15 Aug 2020 09:48:19 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: Convert to use the preferred fallthrough macro
Thread-Topic: [PATCH] bpf: Convert to use the preferred fallthrough macro
Thread-Index: AdZypgu/8/yBxLCEJEWOhWkYz2pnlA==
Date:   Sat, 15 Aug 2020 01:48:18 +0000
Message-ID: <f6ec0c0d37f54298956a63ebe1ebf234@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.252]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW5kcmlpIE5ha3J5aWtvIDxhbmRyaWkubmFrcnlpa29AZ21haWwuY29tPiB3cm90ZToNCk9uIEZy
aSwgQXVnIDE0LCAyMDIwIGF0IDI6NTggQU0gTWlhb2hlIExpbiA8bGlubWlhb2hlQGh1YXdlaS5j
b20+IHdyb3RlOg0KPj4NCj4+IENvbnZlcnQgdGhlIHVzZXMgb2YgZmFsbHRocm91Z2ggY29tbWVu
dHMgdG8gZmFsbHRocm91Z2ggbWFjcm8uDQo+PiBAQCAtMTc5NCw3ICsxNzk0LDcgQEAgc3RhdGlj
IGJvb2wgY2dfc29ja29wdF9pc192YWxpZF9hY2Nlc3MoaW50IG9mZiwgaW50IHNpemUsDQo+PiAg
ICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcHJvZy0+ZXhwZWN0ZWRfYXR0YWNoX3R5cGUg
PT0NCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQlBGX0NHUk9VUF9HRVRTT0NL
T1BUOw0KPj4gICAgICAgICAgICAgICAgIGNhc2Ugb2Zmc2V0b2Yoc3RydWN0IGJwZl9zb2Nrb3B0
LCBvcHRuYW1lKToNCj4+IC0gICAgICAgICAgICAgICAgICAgICAgIC8qIGZhbGx0aHJvdWdoICov
DQo+PiArICAgICAgICAgICAgICAgICAgICAgICBmYWxsdGhyb3VnaDsNCj4NCj50aGlzIGZhbGx0
aHJvdWdoIGlzIG5vdCBldmVudCBuZWNlc3NhcnksIGxldCdzIGRyb3AgaXQgaW5zdGVhZD8NCg0K
V2lsbCBkby4gTWFueSB0aGFua3MuDQoNCj4NCj4+ICAgICAgICAgICAgICAgICBjYXNlIG9mZnNl
dG9mKHN0cnVjdCBicGZfc29ja29wdCwgbGV2ZWwpOg0KPj4gICAgICAgICAgICAgICAgICAgICAg
ICAgaWYgKHNpemUgIT0gc2l6ZV9kZWZhdWx0KQ0KPj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICByZXR1cm4gZmFsc2U7DQo+DQo+IFsuLi5dDQo=
