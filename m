Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AD239AFE6
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhFDBgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 21:36:20 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3418 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhFDBgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 21:36:20 -0400
Received: from dggeme759-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fx4x16B8Wz6tpL;
        Fri,  4 Jun 2021 09:31:33 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme759-chm.china.huawei.com (10.3.19.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 4 Jun 2021 09:34:33 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Fri, 4 Jun 2021 09:34:33 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIG5ldC1uZXh0XSB0aXBjOiBSZXR1cm4gdGhlIGNvcnJl?=
 =?gb2312?Q?ct_errno_code?=
Thread-Topic: [PATCH net-next] tipc: Return the correct errno code
Thread-Index: AQHXWOGc9Q9RY5DeKECVhQca9yM8QKsDEZ6A
Date:   Fri, 4 Jun 2021 01:34:32 +0000
Message-ID: <7b100c7c3a7c4c658374164cb848d8e6@huawei.com>
References: <20210604014702.2087584-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210604014702.2087584-1-zhengyongjun3@huawei.com>
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

U29ycnksIHRoaXMgcGF0Y2ggaXMgd3JvbmcsIHBsZWFzZSBpZ25vcmUgaXQsIHRoYW5rcyA6KQ0K
DQotLS0tLdPKvP7Urbz+LS0tLS0NCreivP7Iyzogemhlbmd5b25nanVuIA0Kt6LLzcqxvOQ6IDIw
MjHE6jbUwjTI1SA5OjQ3DQrK1bz+yMs6IGptYWxveUByZWRoYXQuY29tOyB5aW5nLnh1ZUB3aW5k
cml2ZXIuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IHRpcGMtZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQ7IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCrOty806IHpoZW5neW9uZ2p1biA8emhlbmd5b25n
anVuM0BodWF3ZWkuY29tPg0K1vfM4jogW1BBVENIIG5ldC1uZXh0XSB0aXBjOiBSZXR1cm4gdGhl
IGNvcnJlY3QgZXJybm8gY29kZQ0KDQpXaGVuIGthbGxvYyBvciBrbWVtZHVwIGZhaWxlZCwgc2hv
dWxkIHJldHVybiBFTk9NRU0gcmF0aGVyIHRoYW4gRU5PQlVGLg0KDQpTaWduZWQtb2ZmLWJ5OiBa
aGVuZyBZb25nanVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5jb20+DQotLS0NCiBuZXQvdGlwYy9s
aW5rLmMgfCA2ICsrKy0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVs
ZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQvdGlwYy9saW5rLmMgYi9uZXQvdGlwYy9saW5r
LmMgaW5kZXggYzQ0YjRiZmFhZWU2Li41YjYxODEyNzdjYzUgMTAwNjQ0DQotLS0gYS9uZXQvdGlw
Yy9saW5rLmMNCisrKyBiL25ldC90aXBjL2xpbmsuYw0KQEAgLTkxMiw3ICs5MTIsNyBAQCBzdGF0
aWMgaW50IGxpbmtfc2NoZWR1bGVfdXNlcihzdHJ1Y3QgdGlwY19saW5rICpsLCBzdHJ1Y3QgdGlw
Y19tc2cgKmhkcikNCiAJc2tiID0gdGlwY19tc2dfY3JlYXRlKFNPQ0tfV0FLRVVQLCAwLCBJTlRf
SF9TSVpFLCAwLA0KIAkJCSAgICAgIGRub2RlLCBsLT5hZGRyLCBkcG9ydCwgMCwgMCk7DQogCWlm
ICghc2tiKQ0KLQkJcmV0dXJuIC1FTk9CVUZTOw0KKwkJcmV0dXJuIC1FTk9NRU07DQogCW1zZ19z
ZXRfZGVzdF9kcm9wcGFibGUoYnVmX21zZyhza2IpLCB0cnVlKTsNCiAJVElQQ19TS0JfQ0Ioc2ti
KS0+Y2hhaW5faW1wID0gbXNnX2ltcG9ydGFuY2UoaGRyKTsNCiAJc2tiX3F1ZXVlX3RhaWwoJmwt
Pndha2V1cHEsIHNrYik7DQpAQCAtMTAzMCw3ICsxMDMwLDcgQEAgdm9pZCB0aXBjX2xpbmtfcmVz
ZXQoc3RydWN0IHRpcGNfbGluayAqbCkNCiAgKg0KICAqIENvbnN1bWVzIHRoZSBidWZmZXIgY2hh
aW4uDQogICogTWVzc2FnZXMgYXQgVElQQ19TWVNURU1fSU1QT1JUQU5DRSBhcmUgYWx3YXlzIGFj
Y2VwdGVkDQotICogUmV0dXJuOiAwIGlmIHN1Y2Nlc3MsIG9yIGVycm5vOiAtRUxJTktDT05HLCAt
RU1TR1NJWkUgb3IgLUVOT0JVRlMNCisgKiBSZXR1cm46IDAgaWYgc3VjY2Vzcywgb3IgZXJybm86
IC1FTElOS0NPTkcsIC1FTVNHU0laRSBvciAtRU5PQlVGUyBvciANCisgLUVOT01FTQ0KICAqLw0K
IGludCB0aXBjX2xpbmtfeG1pdChzdHJ1Y3QgdGlwY19saW5rICpsLCBzdHJ1Y3Qgc2tfYnVmZl9o
ZWFkICpsaXN0LA0KIAkJICAgc3RydWN0IHNrX2J1ZmZfaGVhZCAqeG1pdHEpDQpAQCAtMTA4OCw3
ICsxMDg4LDcgQEAgaW50IHRpcGNfbGlua194bWl0KHN0cnVjdCB0aXBjX2xpbmsgKmwsIHN0cnVj
dCBza19idWZmX2hlYWQgKmxpc3QsDQogCQkJaWYgKCFfc2tiKSB7DQogCQkJCWtmcmVlX3NrYihz
a2IpOw0KIAkJCQlfX3NrYl9xdWV1ZV9wdXJnZShsaXN0KTsNCi0JCQkJcmV0dXJuIC1FTk9CVUZT
Ow0KKwkJCQlyZXR1cm4gLUVOT01FTTsNCiAJCQl9DQogCQkJX19za2JfcXVldWVfdGFpbCh0cmFu
c21xLCBza2IpOw0KIAkJCXRpcGNfbGlua19zZXRfc2tiX3JldHJhbnNtaXRfdGltZShza2IsIGwp
Ow0KLS0NCjIuMjUuMQ0KDQo=
