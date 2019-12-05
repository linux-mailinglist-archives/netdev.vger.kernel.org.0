Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC7F113A0E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 03:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbfLECrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 21:47:15 -0500
Received: from mx21.baidu.com ([220.181.3.85]:41110 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbfLECrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 21:47:14 -0500
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id 2651154B0B54B;
        Thu,  5 Dec 2019 10:47:07 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 5 Dec 2019 10:47:08 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 5 Dec 2019 10:47:07 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTog562U5aSNOiBbUEFUQ0hdIHBhZ2Vf?=
 =?utf-8?Q?pool:_mark_unbound_node_page_as_reusable_pages?=
Thread-Topic: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogW1BBVENIXSBwYWdlX3Bvb2w6IG1h?=
 =?utf-8?Q?rk_unbound_node_page_as_reusable_pages?=
Thread-Index: AQHVqwayi5QrKWQh5UWha5lw3I639qequlQw//+EaICAAIiS4P//fa6AgACIR2D//350gAARIFtw
Date:   Thu, 5 Dec 2019 02:47:07 +0000
Message-ID: <504bf0958f424a2c9add3a84543c45c6@baidu.com>
References: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
 <d7836d35-ba21-69ab-8aba-457b2da6ffa1@huawei.com>
 <656e11b6605740b18ac7bb8e3b67ed93@baidu.com>
 <f52fe7e8-2b6f-5e67-aa4b-38277478a7d1@huawei.com>
 <68135c0148894aa3b26db19120fb7bac@baidu.com>
 <3e3b1e0c-e7e0-eea2-b1b5-20bf2b8fc34b@huawei.com>
 <cd63eccb89bb406ca6edea46aee60e3a@baidu.com>
 <cc336ff3-b729-539e-59f7-67c6c37663d9@huawei.com>
In-Reply-To: <cc336ff3-b729-539e-59f7-67c6c37663d9@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.17]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex13_2019-12-05 10:47:08:217
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex13_GRAY_Inside_WithoutAtta_2019-12-05
 10:47:08:202
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3BhdGNod29yay9wYXRjaC8xMTI1Nzg5
Lw0KDQoNCldoYXQgaXMgc3RhdHVzIG9mIHRoaXMgcGF0Y2g/IEkgdGhpbmsgeW91IHNob3VsZCBm
aXggeW91ciBmaXJtd2FyZSBvciBiaW9zDQoNCkNvbnNpZGVyIHRoZSBiZWxvdyBjb25kaXRpb246
DQoNCnRoZXJlIGlzIHR3byBudW1hIG5vZGUsIGFuZCBOSUMgc2l0ZXMgb24gbm9kZSAyLCBidXQg
TlVNQV9OT19OT0RFIGlzIHVzZWQsIHJlY3ljbGUgd2lsbCBmYWlsIGR1ZSB0byBwYWdlX3RvX25p
ZChwYWdlKSA9PSBudW1hX21lbV9pZCgpLCANCmFuZCByZWFsbG9jYXRlZCBwYWdlcyBtYXliZSBh
bHdheXMgZnJvbSBub2RlIDEsIHRoZW4gdGhlIHJlY3ljbGUgd2lsbCBuZXZlciBzdWNjZXNzLg0K
DQotUm9uZ1FpbmcNCg0KDQo=
