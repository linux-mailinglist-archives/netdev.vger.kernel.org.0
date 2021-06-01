Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8B9396E5D
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhFAH5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:57:51 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3490 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbhFAH5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 03:57:50 -0400
Received: from dggeme761-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvPY00Zb1zYptK;
        Tue,  1 Jun 2021 15:53:24 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme761-chm.china.huawei.com (10.3.19.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 15:56:07 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Tue, 1 Jun 2021 15:56:07 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "jdmason@kudzu.us" <jdmason@kudzu.us>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogdnhnZTogUmVtb3ZlIHVu?=
 =?utf-8?Q?used_variable?=
Thread-Topic: [PATCH net-next] net: vxge: Remove unused variable
Thread-Index: AQHXVriJvWdEYw7g0E2WJNfgON0Jh6r+yX2Q
Date:   Tue, 1 Jun 2021 07:56:07 +0000
Message-ID: <937ae366ecb54612a05fec858a3b5418@huawei.com>
References: <20210601074744.4079327-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210601074744.4079327-1-zhengyongjun3@huawei.com>
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

VGhpcyBwYXRjaCBzaG91bGQgbWVsZCBpbnRvIHBhdGNoIEkgc2VuZCBiZWZvcmUsIHNvIHBsZWFz
ZSBpZ25vcmUgdGhpcyBwYXRjaCwgdGhhbmsgeW91IDopDQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0t
LS0NCuWPkeS7tuS6ujogemhlbmd5b25nanVuIA0K5Y+R6YCB5pe26Ze0OiAyMDIx5bm0NuaciDHm
l6UgMTU6NDgNCuaUtuS7tuS6ujogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3Jn
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQrm
ioTpgIE6IGpkbWFzb25Aa3VkenUudXM7IHpoZW5neW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3
ZWkuY29tPg0K5Li76aKYOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogdnhnZTogUmVtb3ZlIHVudXNl
ZCB2YXJpYWJsZQ0KDQpSZW1vdmVzIHRoaXMgYW5ub3lpbmcgd2FybmluZzoNCg0KZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbmV0ZXJpb24vdnhnZS92eGdlLW1haW4uYzoxNjA5OjIyOiB3YXJuaW5nOiB1
bnVzZWQgdmFyaWFibGUg4oCYc3RhdHVz4oCZIFstV3VudXNlZC12YXJpYWJsZV0NCiAxNjA5IHwg
IGVudW0gdnhnZV9od19zdGF0dXMgc3RhdHVzOw0KDQpTaWduZWQtb2ZmLWJ5OiBaaGVuZyBZb25n
anVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9uZXRlcmlvbi92eGdlL3Z4Z2UtbWFpbi5jIHwgMSAtDQogMSBmaWxlIGNoYW5nZWQsIDEgZGVs
ZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L25ldGVyaW9uL3Z4
Z2UvdnhnZS1tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9uZXRlcmlvbi92eGdlL3Z4Z2Ut
bWFpbi5jDQppbmRleCAyMWJjNGQ2NjYyZTQuLjI5N2JjZTVmNjM1ZiAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L25ldGVyaW9uL3Z4Z2UvdnhnZS1tYWluLmMNCisrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L25ldGVyaW9uL3Z4Z2UvdnhnZS1tYWluLmMNCkBAIC0xNjA2LDcgKzE2
MDYsNiBAQCBzdGF0aWMgdm9pZCB2eGdlX2NvbmZpZ19jaV9mb3JfdHRpX3J0aShzdHJ1Y3Qgdnhn
ZWRldiAqdmRldikNCiANCiBzdGF0aWMgaW50IGRvX3Z4Z2VfcmVzZXQoc3RydWN0IHZ4Z2VkZXYg
KnZkZXYsIGludCBldmVudCkgIHsNCi0JZW51bSB2eGdlX2h3X3N0YXR1cyBzdGF0dXM7DQogCWlu
dCByZXQgPSAwLCB2cF9pZCwgaTsNCiANCiAJdnhnZV9kZWJ1Z19lbnRyeWV4aXQoVlhHRV9UUkFD
RSwgIiVzOiVkIiwgX19mdW5jX18sIF9fTElORV9fKTsNCi0tDQoyLjI1LjENCg0K
