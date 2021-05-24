Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D02F38E302
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhEXJNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:13:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3973 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhEXJNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:13:21 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FpWcX1h2szmZH5;
        Mon, 24 May 2021 17:09:32 +0800 (CST)
Received: from dggema722-chm.china.huawei.com (10.3.20.86) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 17:11:51 +0800
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggema722-chm.china.huawei.com (10.3.20.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 17:11:50 +0800
Received: from dggema772-chm.china.huawei.com ([10.9.128.138]) by
 dggema772-chm.china.huawei.com ([10.9.128.138]) with mapi id 15.01.2176.012;
 Mon, 24 May 2021 17:11:50 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Quentin Monnet <quentin@isovalent.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH v2] bpftool: Add sock_release help info for cgroup attach
 command
Thread-Topic: [PATCH v2] bpftool: Add sock_release help info for cgroup attach
 command
Thread-Index: AQHXUHL4/LJJkV64sUiBcYkLggyEearxxRWAgACJx4A=
Date:   Mon, 24 May 2021 09:11:50 +0000
Message-ID: <962a5d78efcb4c82a53b25c81f22433f@huawei.com>
References: <20210524080313.326151-1-liujian56@huawei.com>
 <f8b76c9d-9d92-4b46-eaa3-ba2ba546f91f@isovalent.com>
In-Reply-To: <f8b76c9d-9d92-4b46-eaa3-ba2ba546f91f@isovalent.com>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUXVlbnRpbiBNb25uZXQg
W21haWx0bzpxdWVudGluQGlzb3ZhbGVudC5jb21dDQo+IFNlbnQ6IE1vbmRheSwgTWF5IDI0LCAy
MDIxIDQ6MjMgUE0NCj4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5jb20+OyBh
c3RAa2VybmVsLm9yZzsNCj4gZGFuaWVsQGlvZ2VhcmJveC5uZXQ7IGFuZHJpaUBrZXJuZWwub3Jn
OyBrYWZhaUBmYi5jb207DQo+IHNvbmdsaXVicmF2aW5nQGZiLmNvbTsgeWhzQGZiLmNvbTsgam9o
bi5mYXN0YWJlbmRAZ21haWwuY29tOw0KPiBrcHNpbmdoQGtlcm5lbC5vcmc7IHNkZkBnb29nbGUu
Y29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBicGZAdmdlci5rZXJuZWwub3JnDQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIGJwZnRvb2w6IEFkZCBzb2NrX3JlbGVhc2UgaGVscCBpbmZv
IGZvciBjZ3JvdXANCj4gYXR0YWNoIGNvbW1hbmQNCj4gDQo+IDIwMjEtMDUtMjQgMTY6MDMgVVRD
KzA4MDAgfiBMaXUgSmlhbiA8bGl1amlhbjU2QGh1YXdlaS5jb20+DQo+ID4gVGhlIGhlbHAgaW5m
b3JtYXRpb24gaXMgbm90IGFkZGVkIHdoZW4gdGhlIGZ1bmN0aW9uIGlzIGFkZGVkLg0KPiA+IEFk
ZCB0aGUgbWlzc2luZyBoZWxwIGluZm9ybWF0aW9uLg0KPiA+DQo+ID4gRml4ZXM6IGRiOTRjYzBi
NDgwNSAoImJwZnRvb2w6IEFkZCBzdXBwb3J0IGZvcg0KPiA+IEJQRl9DR1JPVVBfSU5FVF9TT0NL
X1JFTEVBU0UiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBKaWFuIDxsaXVqaWFuNTZAaHVhd2Vp
LmNvbT4NCj4gPiAtLS0NCj4gPiB2MSAtPiB2MjoNCj4gPiAgICAgQWRkIGNoYW5nZWxvZyB0ZXh0
Lg0KPiA+DQo+ID4gIHRvb2xzL2JwZi9icGZ0b29sL2Nncm91cC5jIHwgMyArKy0NCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlm
ZiAtLWdpdCBhL3Rvb2xzL2JwZi9icGZ0b29sL2Nncm91cC5jIGIvdG9vbHMvYnBmL2JwZnRvb2wv
Y2dyb3VwLmMNCj4gPiBpbmRleCBkOTAxY2MxYjkwNGEuLjZlNTNiMWQzOTNmNCAxMDA2NDQNCj4g
PiAtLS0gYS90b29scy9icGYvYnBmdG9vbC9jZ3JvdXAuYw0KPiA+ICsrKyBiL3Rvb2xzL2JwZi9i
cGZ0b29sL2Nncm91cC5jDQo+ID4gQEAgLTI4LDcgKzI4LDggQEANCj4gPiAgCSIgICAgICAgICAg
ICAgICAgICAgICAgICBjb25uZWN0NiB8IGdldHBlZXJuYW1lNCB8IGdldHBlZXJuYW1lNiB8XG4i
ICAgXA0KPiA+ICAJIiAgICAgICAgICAgICAgICAgICAgICAgIGdldHNvY2tuYW1lNCB8IGdldHNv
Y2tuYW1lNiB8IHNlbmRtc2c0IHxcbiIgICBcDQo+ID4gIAkiICAgICAgICAgICAgICAgICAgICAg
ICAgc2VuZG1zZzYgfCByZWN2bXNnNCB8IHJlY3Ztc2c2IHxcbiIgICAgICAgICAgIFwNCj4gPiAt
CSIgICAgICAgICAgICAgICAgICAgICAgICBzeXNjdGwgfCBnZXRzb2Nrb3B0IHwgc2V0c29ja29w
dCB9Ig0KPiA+ICsJIiAgICAgICAgICAgICAgICAgICAgICAgIHN5c2N0bCB8IGdldHNvY2tvcHQg
fCBzZXRzb2Nrb3B0IHxcbiIJICAgICAgIFwNCj4gPiArCSIgICAgICAgICAgICAgICAgICAgICAg
ICBzb2NrX3JlbGVhc2UgfSINCj4gPg0KPiA+ICBzdGF0aWMgdW5zaWduZWQgaW50IHF1ZXJ5X2Zs
YWdzOw0KPiA+DQo+ID4NCj4gDQo+IFRoYW5rcyBhIGxvdCENCj4gDQo+IE5vdGUgdGhhdCB0aGVy
ZSBhcmUgYSBmZXcgb3RoZXIgcGxhY2VzIGluIGJwZnRvb2wgd2hlcmUgdGhlIGF0dGFjaCBwb2lu
dA0KPiBzaG91bGQgYmUgYWRkZWQsIHdvdWxkIHlvdSBtaW5kIHVwZGF0aW5nIHRoZW0gdG9vPyBU
aGF0IHdvdWxkIGJlOiB0aGUNCj4gZG9jdW1lbnRhdGlvbiBwYWdlIGZvciBicGZ0b29sLWNncm91
cCwgdGhlIG9uZSBmb3IgYnBmdG9vbC1wcm9nLCB0aGUgaGVscA0KPiBtZXNzYWdlIGluIHByb2cu
YywgYW5kIHRoZSBiYXNoIGNvbXBsZXRpb24uIEl0IHNob3VsZCBhbGwgYmUgc3RyYWlnaHRmb3J3
YXJkLg0KPiBZb3UgY2FuIHRyeSBzb21ldGhpbmcgbGlrZSAiZ3JlcCByZWN2bXNnNCB0b29scy9i
cGYvYnBmdG9vbCIgdG8gZmluZCB0aGUNCj4gcmVsZXZhbnQgbG9jYXRpb25zLg0KDQpPSywgSSds
bCBjaGFuZ2UgaXQgdG9nZXRoZXIuIFRoYW5rcyBmb3IgeW91ciByZXZpZXcuDQoNCj4gQmVzdCBy
ZWdhcmRzLA0KPiBRdWVudGluDQo=
