Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE57114D27
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 09:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfLFIFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 03:05:36 -0500
Received: from mx21.baidu.com ([220.181.3.85]:37555 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726596AbfLFIFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 03:05:35 -0500
Received: from BC-Mail-Ex31.internal.baidu.com (unknown [172.31.51.25])
        by Forcepoint Email with ESMTPS id 5D9912216341A;
        Fri,  6 Dec 2019 16:05:31 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex31.internal.baidu.com (172.31.51.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 6 Dec 2019 16:05:32 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Fri, 6 Dec 2019 16:05:32 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTog562U5aSNOiDnrZTlpI06IOetlA==?=
 =?utf-8?B?5aSNOiBbUEFUQ0hdIHBhZ2VfcG9vbDogbWFyayB1bmJvdW5kIG5vZGUgcGFn?=
 =?utf-8?Q?e_as_reusable_pages?=
Thread-Topic: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTog562U5aSNOiDnrZTlpI06IFtQQVRD?=
 =?utf-8?B?SF0gcGFnZV9wb29sOiBtYXJrIHVuYm91bmQgbm9kZSBwYWdlIGFzIHJldXNh?=
 =?utf-8?Q?ble_pages?=
Thread-Index: AQHVqwayi5QrKWQh5UWha5lw3I639qequlQw//+EaICAAIiS4P//fa6AgACIR2D//350gAARIFtw//+AQoD//3jLoIAAj3IA//2brwA=
Date:   Fri, 6 Dec 2019 08:05:32 +0000
Message-ID: <9360bccd58bd4fef8412c2f2d7b04873@baidu.com>
References: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
 <d7836d35-ba21-69ab-8aba-457b2da6ffa1@huawei.com>
 <656e11b6605740b18ac7bb8e3b67ed93@baidu.com>
 <f52fe7e8-2b6f-5e67-aa4b-38277478a7d1@huawei.com>
 <68135c0148894aa3b26db19120fb7bac@baidu.com>
 <3e3b1e0c-e7e0-eea2-b1b5-20bf2b8fc34b@huawei.com>
 <cd63eccb89bb406ca6edea46aee60e3a@baidu.com>
 <cc336ff3-b729-539e-59f7-67c6c37663d9@huawei.com>
 <504bf0958f424a2c9add3a84543c45c6@baidu.com>
 <0c5b19c3-b639-b990-73a1-a1300d417221@huawei.com>
 <3a0d273cb57146d3b2f5c849569fb244@baidu.com>
 <bb1daad7-d5a9-0c36-e218-710b3f15b5a1@huawei.com>
In-Reply-To: <bb1daad7-d5a9-0c36-e218-710b3f15b5a1@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.14]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex31_2019-12-06 16:05:32:358
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex31_GRAY_Inside_WithoutAtta_2019-12-06
 16:05:32:343
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBJIGFtIGp1c3QgYXJndWluZyB0aGF0IHJ4IHJlY3ljbGUgdGhlIHBhZ2UgcG9vbCBpcyBkb2lu
ZyBzaG91bGQgYmUgY29uc2lzdGVudA0KPiB3aXRoIG90aGVyIGRyaXZlciB0aGF0IGRvZXMgaXRz
IG93biByZWN5Y2xlLg0KPiANCj4gSWYgdGhlIGRyaXZlciB0aGF0IGRvZXMgaXRzIG93biByZWN5
Y2xlIGJlZ2luIHRvIHN1cHBvcnQgdGhlIHBhZ2UgcG9vbCwgdGhlbg0KPiB0aGVyZSBtYXkgYmUg
ZGlmZmVyZW50IGJlaGF2aW9yIHdoZW4gdGhleSBhcmUgbm90IGNvbnNpc3RlbnQuDQo+IA0KDQpP
SywgSSB3aWxsIHNlbmQgdjIsIHdpdGggeW91ciBzdWdnZXN0aW9uDQoNClRoYW5rcw0KDQotTGkN
Cg==
