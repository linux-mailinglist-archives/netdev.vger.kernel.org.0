Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA2312498F
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfLRO1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:27:39 -0500
Received: from mx22.baidu.com ([220.181.50.185]:38596 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727124AbfLRO1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:27:37 -0500
Received: from BJHW-Mail-Ex16.internal.baidu.com (unknown [10.127.64.39])
        by Forcepoint Email with ESMTPS id B036887B36948970E6BB;
        Wed, 18 Dec 2019 22:27:26 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex16.internal.baidu.com (10.127.64.39) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Wed, 18 Dec 2019 22:27:26 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Wed, 18 Dec 2019 22:27:13 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW25ldC1uZXh0IHY0IFBBVENIXSBwYWdlX3Bvb2w6IGhhbmRsZSBw?=
 =?gb2312?B?YWdlIHJlY3ljbGUgZm9yIE5VTUFfTk9fTk9ERSBjb25kaXRpb24=?=
Thread-Topic: [net-next v4 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Thread-Index: AQHVtXlmIvmGikvRt0uoQcyHJL+0JKe/8iWl
Date:   Wed, 18 Dec 2019 14:27:13 +0000
Message-ID: <7d1d07c680b6411aada4840edaff3b12@baidu.com>
References: <20191218084437.6db92d32@carbon>,<157665609556.170047.13435503155369210509.stgit@firesoul>
In-Reply-To: <157665609556.170047.13435503155369210509.stgit@firesoul>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.29.233]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex16_2019-12-18 22:27:26:665
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex16_GRAY_Inside_WithoutAtta_2019-12-18
 22:27:26:650
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpzZWVtIGl0IGNhbiBub3QgaGFuZGxlIHRoZSBpbi1mbGlnaHQgcGFnZXMgaWYgcmVtb3ZlIHRo
ZSBjaGVjayBub2RlIGlkIGZyb20gcG9vbF9wYWdlX3JldXNhYmxlPw0KDQoNCi1MaQ0K
