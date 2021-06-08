Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BEE39EEBB
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 08:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhFHGbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 02:31:37 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3466 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhFHGbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 02:31:36 -0400
Received: from dggeme762-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzgHg5YHhz6wL4;
        Tue,  8 Jun 2021 14:26:39 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme762-chm.china.huawei.com (10.3.19.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 14:29:42 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Tue, 8 Jun 2021 14:29:42 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIHYzXSBwaW5nOiBDaGVjayByZXR1cm4gdmFsdWUgb2Yg?=
 =?gb2312?B?ZnVuY3Rpb24gJ3BpbmdfcXVldWVfcmN2X3NrYic=?=
Thread-Topic: [PATCH v3] ping: Check return value of function
 'ping_queue_rcv_skb'
Thread-Index: AQHXXAlUyIkiRM5YAUWY4tkTbJcb1KsJGzQAgACL8kA=
Date:   Tue, 8 Jun 2021 06:29:42 +0000
Message-ID: <28ed7b10e53a45989c1de37be0d7cdf5@huawei.com>
References: <20210608020853.3091939-1-zhengyongjun3@huawei.com>
 <YL8JWqVbhMtfPJbb@unreal>
In-Reply-To: <YL8JWqVbhMtfPJbb@unreal>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.64]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHN1Z2dlc3QsIEkgc2VuZCBwYXRjaCB2NCBub3cgOikNCg0KLS0tLS3T
yrz+1K28/i0tLS0tDQq3orz+yMs6IExlb24gUm9tYW5vdnNreSBbbWFpbHRvOmxlb25Aa2VybmVs
Lm9yZ10gDQq3osvNyrG85DogMjAyMcTqNtTCOMjVIDE0OjA4DQrK1bz+yMs6IHpoZW5neW9uZ2p1
biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0Ks63LzTogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
eW9zaGZ1amlAbGludXgtaXB2Ni5vcmc7IGRzYWhlcm5Aa2VybmVsLm9yZzsga3ViYUBrZXJuZWwu
b3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQrW98ziOiBSZTogW1BBVENIIHYzXSBwaW5nOiBDaGVjayByZXR1cm4gdmFsdWUgb2YgZnVuY3Rp
b24gJ3BpbmdfcXVldWVfcmN2X3NrYicNCg0KT24gVHVlLCBKdW4gMDgsIDIwMjEgYXQgMTA6MDg6
NTNBTSArMDgwMCwgWmhlbmcgWW9uZ2p1biB3cm90ZToNCj4gRnVuY3Rpb24gJ3BpbmdfcXVldWVf
cmN2X3NrYicgbm90IGFsd2F5cyByZXR1cm4gc3VjY2Vzcywgd2hpY2ggd2lsbCANCj4gYWxzbyBy
ZXR1cm4gZmFpbC4gSWYgbm90IGNoZWNrIHRoZSB3cm9uZyByZXR1cm4gdmFsdWUgb2YgaXQsIGxl
YWQgdG8gDQo+IGZ1bmN0aW9uIGBwaW5nX3JjdmAgcmV0dXJuIHN1Y2Nlc3MuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBaaGVuZyBZb25nanVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5jb20+DQo+IC0t
LQ0KPiB2MjoNCj4gLSB1c2UgcmMgYXMgcmV0dXJuIHZhbHVlIHRvIG1ha2UgY29kZSBsb29rIGNs
ZWFuZXINCj4gdjM6DQo+IC0gZGVsZXRlIHVubmVjZXNzYXJ5IGJyYWNlcyB7fQ0KPiAgbmV0L2lw
djQvcGluZy5jIHwgOCArKysrLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvaXB2NC9waW5nLmMgYi9u
ZXQvaXB2NC9waW5nLmMgaW5kZXggDQo+IDFjOWY3MWEzNzI1OC4uYWY5ZGEyZjdkYzg1IDEwMDY0
NA0KPiAtLS0gYS9uZXQvaXB2NC9waW5nLmMNCj4gKysrIGIvbmV0L2lwdjQvcGluZy5jDQo+IEBA
IC05NjMsMTkgKzk2MywxOSBAQCBib29sIHBpbmdfcmN2KHN0cnVjdCBza19idWZmICpza2IpDQo+
ICAJLyogUHVzaCBJQ01QIGhlYWRlciBiYWNrICovDQo+ICAJc2tiX3B1c2goc2tiLCBza2ItPmRh
dGEgLSAodTggKilpY21waCk7DQo+ICANCj4gKwlib29sIHJjID0gZmFsc2U7DQoNCkRlY2xhcmF0
aW9uIG9mIG5ldyB2YXJpYWJsZXMgaW4gdGhlIG1pZGRsZSBvZiBmdW5jdGlvbiBpcyBDKyssIHdo
aWxlIHRoZSBrZXJuZWwgaXMgd3JpdHRlbiBpbiBDLiBQbGVhc2UgcHV0IHZhcmlhYmxlIGRlY2xh
cmF0aW9uIGF0IHRoZSBiZWdpbm5pbmcgb2YgZnVuY3Rpb24uDQoNClRoYW5rcw0KDQo+ICAJc2sg
PSBwaW5nX2xvb2t1cChuZXQsIHNrYiwgbnRvaHMoaWNtcGgtPnVuLmVjaG8uaWQpKTsNCj4gIAlp
ZiAoc2spIHsNCj4gIAkJc3RydWN0IHNrX2J1ZmYgKnNrYjIgPSBza2JfY2xvbmUoc2tiLCBHRlBf
QVRPTUlDKTsNCj4gIA0KPiAgCQlwcl9kZWJ1ZygicmN2IG9uIHNvY2tldCAlcFxuIiwgc2spOw0K
PiAtCQlpZiAoc2tiMikNCj4gLQkJCXBpbmdfcXVldWVfcmN2X3NrYihzaywgc2tiMik7DQo+ICsJ
CWlmIChza2IyICYmICFwaW5nX3F1ZXVlX3Jjdl9za2Ioc2ssIHNrYjIpKQ0KPiArCQkJcmMgPSB0
cnVlOw0KPiAgCQlzb2NrX3B1dChzayk7DQo+IC0JCXJldHVybiB0cnVlOw0KPiAgCX0NCj4gIAlw
cl9kZWJ1Zygibm8gc29ja2V0LCBkcm9wcGluZ1xuIik7DQo+ICANCj4gLQlyZXR1cm4gZmFsc2U7
DQo+ICsJcmV0dXJuIHJjOw0KPiAgfQ0KPiAgRVhQT1JUX1NZTUJPTF9HUEwocGluZ19yY3YpOw0K
PiAgDQo+IC0tDQo+IDIuMjUuMQ0KPiANCg==
