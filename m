Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCEB3DD259
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhHBIxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:53:02 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12336 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbhHBIw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 04:52:56 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GdWqH4jJVz81tS;
        Mon,  2 Aug 2021 16:47:55 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 2 Aug 2021 16:52:44 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Mon, 2 Aug 2021 16:52:44 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHRdIHRpcGM6IFJldHVybiB0aGUgY29y?=
 =?utf-8?Q?rect_errno_code?=
Thread-Topic: [PATCH net-next] tipc: Return the correct errno code
Thread-Index: AQHXWOGc9Q9RY5DeKECVhQca9yM8QKsDEZ6AgFyf3YCAAJKkAA==
Date:   Mon, 2 Aug 2021 08:52:44 +0000
Message-ID: <129ae4700e9740ad8ef1e5bb1862e2ff@huawei.com>
References: <20210604014702.2087584-1-zhengyongjun3@huawei.com>
 <7b100c7c3a7c4c658374164cb848d8e6@huawei.com>
 <VE1PR05MB7327C7E4BC3EAF9D398A6B86F1EF9@VE1PR05MB7327.eurprd05.prod.outlook.com>
In-Reply-To: <VE1PR05MB7327C7E4BC3EAF9D398A6B86F1EF9@VE1PR05MB7327.eurprd05.prod.outlook.com>
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

SGkgaG9hbmcsDQoNCkkgZG9uJ3Qgbm90aWNlIHRoYXQgcGF0Y2ggaGFzIGJlZW4gbWVyZ2VkLCBJ
ZiB5b3UgbmVlZCBtZSB0byBzZW5kIGEgcmV2ZXJ0IHBhdGNoLCBJIHdpbGwgc2VuZCBpdCBhcyBz
b29uIGFzIHBvc3NpYmxlLg0KSWYgeW91IHN1Ym1pdCB0aGUgcmV2ZXJ0IHBhdGNoIGJ5IHlvdXIg
dGVhbSwgaXQncyBhbHNvIG9rLiANCg0KVGhhbmtzLA0KWmhlbmcNCg0KLS0tLS3pgq7ku7bljp/k
u7YtLS0tLQ0K5Y+R5Lu25Lq6OiBIb2FuZyBIdXUgTGUgW21haWx0bzpob2FuZy5oLmxlQGRla3Rl
Y2guY29tLmF1XSANCuWPkemAgeaXtumXtDogMjAyMeW5tDjmnIgy5pelIDE2OjAyDQrmlLbku7bk
uro6IHpoZW5neW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPjsgam1hbG95QHJlZGhh
dC5jb207IHlpbmcueHVlQHdpbmRyaXZlci5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFA
a2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdGlwYy1kaXNjdXNzaW9uQGxpc3Rz
LnNvdXJjZWZvcmdlLm5ldDsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0K5Li76aKYOiBS
RTogW1BBVENIIG5ldC1uZXh0XSB0aXBjOiBSZXR1cm4gdGhlIGNvcnJlY3QgZXJybm8gY29kZQ0K
DQpIaSBaaGVuZywNCg0KVGhlIHBhdGNoIHdhcyBiZWluZyBtZXJnZWQgYnkgYWNjaWRlbnQuIFdp
bGwgaGF2ZSB5b3UgcGxhbm5pbmcgdG8gcmV2ZXJ0IGl0Pw0KV2UgbmVlZCB0byBkbyBBU0FQIHNp
bmNlIGNhbGxpbmcgcGF0aCB0aXBjX25vZGVfeG1pdCgpIC0+IHRpcGNfbGlua194bWl0KCkgYnJv
a2VuIGFzIHNpZGUgZWZmZWN0Lg0KDQpUaGFua3MsDQpob2FuZw0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiB6aGVuZ3lvbmdqdW4gPHpoZW5neW9uZ2p1bjNAaHVhd2VpLmNv
bT4NCj4gU2VudDogRnJpZGF5LCBKdW5lIDQsIDIwMjEgODozNSBBTQ0KPiBUbzogam1hbG95QHJl
ZGhhdC5jb207IHlpbmcueHVlQHdpbmRyaXZlci5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IA0K
PiBrdWJhQGtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHRpcGMtIA0KPiBkaXNj
dXNzaW9uQGxpc3RzLnNvdXJjZWZvcmdlLm5ldDsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiDnrZTlpI06IFtQQVRDSCBuZXQtbmV4dF0gdGlwYzogUmV0dXJuIHRoZSBj
b3JyZWN0IGVycm5vIGNvZGUNCj4gDQo+IFNvcnJ5LCB0aGlzIHBhdGNoIGlzIHdyb25nLCBwbGVh
c2UgaWdub3JlIGl0LCB0aGFua3MgOikNCj4gDQo+IC0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCj4g
5Y+R5Lu25Lq6OiB6aGVuZ3lvbmdqdW4NCj4g5Y+R6YCB5pe26Ze0OiAyMDIx5bm0NuaciDTml6Ug
OTo0Nw0KPiDmlLbku7bkuro6IGptYWxveUByZWRoYXQuY29tOyB5aW5nLnh1ZUB3aW5kcml2ZXIu
Y29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyANCj4ga3ViYUBrZXJuZWwub3JnOyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOyB0aXBjLSANCj4gZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQ7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g5oqE6YCBOiB6aGVuZ3lvbmdqdW4gPHpo
ZW5neW9uZ2p1bjNAaHVhd2VpLmNvbT4NCj4g5Li76aKYOiBbUEFUQ0ggbmV0LW5leHRdIHRpcGM6
IFJldHVybiB0aGUgY29ycmVjdCBlcnJubyBjb2RlDQo+IA0KPiBXaGVuIGthbGxvYyBvciBrbWVt
ZHVwIGZhaWxlZCwgc2hvdWxkIHJldHVybiBFTk9NRU0gcmF0aGVyIHRoYW4gRU5PQlVGLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29t
Pg0KPiAtLS0NCj4gIG5ldC90aXBjL2xpbmsuYyB8IDYgKysrLS0tDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25l
dC90aXBjL2xpbmsuYyBiL25ldC90aXBjL2xpbmsuYyBpbmRleCANCj4gYzQ0YjRiZmFhZWU2Li41
YjYxODEyNzdjYzUgMTAwNjQ0DQo+IC0tLSBhL25ldC90aXBjL2xpbmsuYw0KPiArKysgYi9uZXQv
dGlwYy9saW5rLmMNCj4gQEAgLTkxMiw3ICs5MTIsNyBAQCBzdGF0aWMgaW50IGxpbmtfc2NoZWR1
bGVfdXNlcihzdHJ1Y3QgdGlwY19saW5rICpsLCBzdHJ1Y3QgdGlwY19tc2cgKmhkcikNCj4gIAlz
a2IgPSB0aXBjX21zZ19jcmVhdGUoU09DS19XQUtFVVAsIDAsIElOVF9IX1NJWkUsIDAsDQo+ICAJ
CQkgICAgICBkbm9kZSwgbC0+YWRkciwgZHBvcnQsIDAsIDApOw0KPiAgCWlmICghc2tiKQ0KPiAt
CQlyZXR1cm4gLUVOT0JVRlM7DQo+ICsJCXJldHVybiAtRU5PTUVNOw0KPiAgCW1zZ19zZXRfZGVz
dF9kcm9wcGFibGUoYnVmX21zZyhza2IpLCB0cnVlKTsNCj4gIAlUSVBDX1NLQl9DQihza2IpLT5j
aGFpbl9pbXAgPSBtc2dfaW1wb3J0YW5jZShoZHIpOw0KPiAgCXNrYl9xdWV1ZV90YWlsKCZsLT53
YWtldXBxLCBza2IpOw0KPiBAQCAtMTAzMCw3ICsxMDMwLDcgQEAgdm9pZCB0aXBjX2xpbmtfcmVz
ZXQoc3RydWN0IHRpcGNfbGluayAqbCkNCj4gICAqDQo+ICAgKiBDb25zdW1lcyB0aGUgYnVmZmVy
IGNoYWluLg0KPiAgICogTWVzc2FnZXMgYXQgVElQQ19TWVNURU1fSU1QT1JUQU5DRSBhcmUgYWx3
YXlzIGFjY2VwdGVkDQo+IC0gKiBSZXR1cm46IDAgaWYgc3VjY2Vzcywgb3IgZXJybm86IC1FTElO
S0NPTkcsIC1FTVNHU0laRSBvciAtRU5PQlVGUw0KPiArICogUmV0dXJuOiAwIGlmIHN1Y2Nlc3Ms
IG9yIGVycm5vOiAtRUxJTktDT05HLCAtRU1TR1NJWkUgb3IgLUVOT0JVRlMgDQo+ICsgb3IgLUVO
T01FTQ0KPiAgICovDQo+ICBpbnQgdGlwY19saW5rX3htaXQoc3RydWN0IHRpcGNfbGluayAqbCwg
c3RydWN0IHNrX2J1ZmZfaGVhZCAqbGlzdCwNCj4gIAkJICAgc3RydWN0IHNrX2J1ZmZfaGVhZCAq
eG1pdHEpDQo+IEBAIC0xMDg4LDcgKzEwODgsNyBAQCBpbnQgdGlwY19saW5rX3htaXQoc3RydWN0
IHRpcGNfbGluayAqbCwgc3RydWN0IHNrX2J1ZmZfaGVhZCAqbGlzdCwNCj4gIAkJCWlmICghX3Nr
Yikgew0KPiAgCQkJCWtmcmVlX3NrYihza2IpOw0KPiAgCQkJCV9fc2tiX3F1ZXVlX3B1cmdlKGxp
c3QpOw0KPiAtCQkJCXJldHVybiAtRU5PQlVGUzsNCj4gKwkJCQlyZXR1cm4gLUVOT01FTTsNCj4g
IAkJCX0NCj4gIAkJCV9fc2tiX3F1ZXVlX3RhaWwodHJhbnNtcSwgc2tiKTsNCj4gIAkJCXRpcGNf
bGlua19zZXRfc2tiX3JldHJhbnNtaXRfdGltZShza2IsIGwpOw0KPiAtLQ0KPiAyLjI1LjENCg0K
