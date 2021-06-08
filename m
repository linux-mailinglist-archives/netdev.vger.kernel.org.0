Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5592F39EB7C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 03:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhFHBeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 21:34:07 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5275 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhFHBeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 21:34:05 -0400
Received: from dggeme762-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FzXfJ6WC4z1BKgf;
        Tue,  8 Jun 2021 09:27:20 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 09:32:10 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Tue, 8 Jun 2021 09:32:10 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogaXB2NDogUmVtb3ZlIHVu?=
 =?utf-8?Q?need_BUG()_function?=
Thread-Topic: [PATCH net-next] net: ipv4: Remove unneed BUG() function
Thread-Index: AQHXW6j7NF91AHGh+Uu1rQMEw2T1x6sINL8AgAEgCKA=
Date:   Tue, 8 Jun 2021 01:32:10 +0000
Message-ID: <e06f752c9dc647428a7d4ebb80f28592@huawei.com>
References: <20210607143909.2844407-1-zhengyongjun3@huawei.com>
 <9274e18e-dc57-f6c2-e0cc-0d06841df54e@gmail.com>
In-Reply-To: <9274e18e-dc57-f6c2-e0cc-0d06841df54e@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.64]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSB3aWxsIGRvIGFzIHlvdXIgYWR2aWNlIGFuZCBzZW5kIHBhdGNoIHYyIDopDQoNCi0tLS0t6YKu
5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogRGF2aWQgQWhlcm4gW21haWx0bzpkc2FoZXJuQGdt
YWlsLmNvbV0gDQrlj5HpgIHml7bpl7Q6IDIwMjHlubQ25pyIOOaXpSAwOjIxDQrmlLbku7bkuro6
IHpoZW5neW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsgeW9zaGZ1amlAbGludXgtaXB2Ni5vcmc7IGRzYWhlcm5Aa2VybmVsLm9yZzsga3ViYUBr
ZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQrkuLvpopg6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogaXB2NDogUmVtb3ZlIHVu
bmVlZCBCVUcoKSBmdW5jdGlvbg0KDQpPbiA2LzcvMjEgODozOSBBTSwgWmhlbmcgWW9uZ2p1biB3
cm90ZToNCj4gV2hlbiAnbmxhX3BhcnNlX25lc3RlZF9kZXByZWNhdGVkJyBmYWlsZWQsIGl0J3Mg
bm8gbmVlZCB0bw0KPiBCVUcoKSBoZXJlLCByZXR1cm4gLUVJTlZBTCBpcyBvay4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IFpoZW5nIFlvbmdqdW4gPHpoZW5neW9uZ2p1bjNAaHVhd2VpLmNvbT4NCj4g
LS0tDQo+ICBuZXQvaXB2NC9kZXZpbmV0LmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvaXB2NC9k
ZXZpbmV0LmMgYi9uZXQvaXB2NC9kZXZpbmV0LmMgaW5kZXggDQo+IDJlMzVmNjhkYTQwYS4uMWM2
NDI5YzM1M2E5IDEwMDY0NA0KPiAtLS0gYS9uZXQvaXB2NC9kZXZpbmV0LmMNCj4gKysrIGIvbmV0
L2lwdjQvZGV2aW5ldC5jDQo+IEBAIC0xOTg5LDcgKzE5ODksNyBAQCBzdGF0aWMgaW50IGluZXRf
c2V0X2xpbmtfYWYoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgY29uc3Qgc3RydWN0IG5sYXR0ciAq
bmxhLA0KPiAgCQlyZXR1cm4gLUVBRk5PU1VQUE9SVDsNCj4gIA0KPiAgCWlmIChubGFfcGFyc2Vf
bmVzdGVkX2RlcHJlY2F0ZWQodGIsIElGTEFfSU5FVF9NQVgsIG5sYSwgTlVMTCwgTlVMTCkgDQo+
IDwgMCkNCg0KQXZvaWQgYXNzdW1wdGlvbnMgb24gdGhlIGZhaWx1cmUgcmVhc29uOg0KDQoJaW50
IGVycjsNCg0KCWVyciA9IG5sYV9wYXJzZV9uZXN0ZWRfZGVwcmVjYXRlZCgpOw0KCWlmIChlcnIg
PCAwKQ0KCQlyZXR1cm4gZXJyOw0KDQo+IC0JCUJVRygpOw0KPiArCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gIA0KPiAgCWlmICh0YltJRkxBX0lORVRfQ09ORl0pIHsNCj4gIAkJbmxhX2Zvcl9lYWNoX25l
c3RlZChhLCB0YltJRkxBX0lORVRfQ09ORl0sIHJlbSkNCj4gDQoNCnNlZW1zIGxpa2UgdGhpcyBw
YXRjaCBhbmQgYSBzaW1pbGFyIGZpeCBmb3IgdGhlIElQdjYgdmVyc2lvbiBvZiBzZXRfbGlua19h
ZiBzaG91bGQgZ28gdG8gbmV0IHJhdGhlciB0aGFuIG5ldC1uZXh0Lg0KDQo=
