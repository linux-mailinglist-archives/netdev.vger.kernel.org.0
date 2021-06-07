Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8A939DEAB
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFGO05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:26:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3088 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhFGO04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:26:56 -0400
Received: from dggeme759-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzFrX64V8zWsDT;
        Mon,  7 Jun 2021 22:20:12 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme759-chm.china.huawei.com (10.3.19.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 22:25:02 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Mon, 7 Jun 2021 22:25:02 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogaXB2NDogdXNlIEJVR19P?=
 =?utf-8?Q?N_instead_of_if_condition_followed_by_BUG?=
Thread-Topic: [PATCH net-next] net: ipv4: use BUG_ON instead of if condition
 followed by BUG
Thread-Index: AQHXW3s1hXims0p6KUeYFOmb1rqaBqsH/OYAgACdybA=
Date:   Mon, 7 Jun 2021 14:25:02 +0000
Message-ID: <08e628dd41ac4e3cb8720daf11b7ba11@huawei.com>
References: <20210607091131.2766890-1-zhengyongjun3@huawei.com>
 <6b84747d-80a9-08d8-c4e3-c91cdaa99330@gmail.com>
In-Reply-To: <6b84747d-80a9-08d8-c4e3-c91cdaa99330@gmail.com>
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

VGhhbmtzIGZvciB5b3VyIGFkdmljZSwgSSB3aWxsIGRvIGFzIHlvdXIgYWR2aWNlIGFuZCBzZW5k
IHBhdGNoICcgMDAwMS1uZXQtaXB2NC1SZW1vdmUtdW5uZWVkLUJVRy1mdW5jdGlvbi5wYXRjaCAn
IDopDQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogRGF2aWQgQWhlcm4gW21h
aWx0bzpkc2FoZXJuQGdtYWlsLmNvbV0gDQrlj5HpgIHml7bpl7Q6IDIwMjHlubQ25pyIN+aXpSAy
MTowMA0K5pS25Lu25Lq6OiB6aGVuZ3lvbmdqdW4gPHpoZW5neW9uZ2p1bjNAaHVhd2VpLmNvbT47
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IHlvc2hmdWppQGxpbnV4LWlwdjYub3JnOyBkc2FoZXJuQGtl
cm5lbC5vcmc7IGt1YmFAa2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZw0K5Li76aKYOiBSZTogW1BBVENIIG5ldC1uZXh0XSBuZXQ6
IGlwdjQ6IHVzZSBCVUdfT04gaW5zdGVhZCBvZiBpZiBjb25kaXRpb24gZm9sbG93ZWQgYnkgQlVH
DQoNCk9uIDYvNy8yMSAzOjExIEFNLCBaaGVuZyBZb25nanVuIHdyb3RlOg0KPiBVc2UgQlVHX09O
IGluc3RlYWQgb2YgaWYgY29uZGl0aW9uIGZvbGxvd2VkIGJ5IEJVRyBpbiBpbmV0X3NldF9saW5r
X2FmLg0KPiANCj4gVGhpcyBpc3N1ZSB3YXMgZGV0ZWN0ZWQgd2l0aCB0aGUgaGVscCBvZiBDb2Nj
aW5lbGxlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVu
M0BodWF3ZWkuY29tPg0KPiAtLS0NCj4gIG5ldC9pcHY0L2RldmluZXQuYyB8IDMgKy0tDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvbmV0L2lwdjQvZGV2aW5ldC5jIGIvbmV0L2lwdjQvZGV2aW5ldC5jIGluZGV4IA0K
PiAyZTM1ZjY4ZGE0MGEuLmUzZTFlOGE2MDBlZiAxMDA2NDQNCj4gLS0tIGEvbmV0L2lwdjQvZGV2
aW5ldC5jDQo+ICsrKyBiL25ldC9pcHY0L2RldmluZXQuYw0KPiBAQCAtMTk4OCw4ICsxOTg4LDcg
QEAgc3RhdGljIGludCBpbmV0X3NldF9saW5rX2FmKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGNv
bnN0IHN0cnVjdCBubGF0dHIgKm5sYSwNCj4gIAlpZiAoIWluX2RldikNCj4gIAkJcmV0dXJuIC1F
QUZOT1NVUFBPUlQ7DQo+ICANCj4gLQlpZiAobmxhX3BhcnNlX25lc3RlZF9kZXByZWNhdGVkKHRi
LCBJRkxBX0lORVRfTUFYLCBubGEsIE5VTEwsIE5VTEwpIDwgMCkNCj4gLQkJQlVHKCk7DQo+ICsJ
QlVHX09OKG5sYV9wYXJzZV9uZXN0ZWRfZGVwcmVjYXRlZCh0YiwgSUZMQV9JTkVUX01BWCwgbmxh
LCBOVUxMLCANCj4gK05VTEwpIDwgMCk7DQo+ICANCj4gIAlpZiAodGJbSUZMQV9JTkVUX0NPTkZd
KSB7DQo+ICAJCW5sYV9mb3JfZWFjaF9uZXN0ZWQoYSwgdGJbSUZMQV9JTkVUX0NPTkZdLCByZW0p
DQo+IA0KDQpubyByZWFzb24gdG8gaGF2ZSBhIEJVRyBoZXJlIGF0IGFsbC4gQ2F0Y2ggdGhlIGVy
cm9yIGFuZCByZXR1cm4uDQo=
