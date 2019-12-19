Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAFF3126285
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 13:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfLSMrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 07:47:15 -0500
Received: from mx21.baidu.com ([220.181.3.85]:60898 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726695AbfLSMrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 07:47:15 -0500
Received: from BC-Mail-Ex29.internal.baidu.com (unknown [172.31.51.23])
        by Forcepoint Email with ESMTPS id 5BDAC8ACC5F44746D941;
        Thu, 19 Dec 2019 20:47:05 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex29.internal.baidu.com (172.31.51.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 19 Dec 2019 20:47:05 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 19 Dec 2019 20:47:05 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW25ldC1uZXh0IHY0IFBBVENIXSBwYWdlX3Bvb2w6IGhhbmRsZSBw?=
 =?gb2312?B?YWdlIHJlY3ljbGUgZm9yIE5VTUFfTk9fTk9ERSBjb25kaXRpb24=?=
Thread-Topic: [net-next v4 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Thread-Index: AQHVtXlmIvmGikvRt0uoQcyHJL+0JKe/8iWlgADkiYCAAJD7HQ==
Date:   Thu, 19 Dec 2019 12:47:05 +0000
Message-ID: <ce22066d9ca743bb875c5f0d6da84071@baidu.com>
References: <20191218084437.6db92d32@carbon>
        <157665609556.170047.13435503155369210509.stgit@firesoul>
        <7d1d07c680b6411aada4840edaff3b12@baidu.com>,<20191219130013.7707683f@carbon>
In-Reply-To: <20191219130013.7707683f@carbon>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.29.119]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex29_2019-12-19 20:47:05:321
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex29_GRAY_Inside_WithoutAtta_2019-12-19
 20:47:05:306
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIFdlZCwgMTggRGVjIDIwMTkgMTQ6Mjc6MTMgKzAwMDANCiJMaSxSb25ncWluZyIgPGxp
cm9uZ3FpbmdAYmFpZHUuY29tPiB3cm90ZToNCg0KPj4gc2VlbSBpdCBjYW4gbm90IGhhbmRsZSB0
aGUgaW4tZmxpZ2h0IHBhZ2VzIGlmIHJlbW92ZSB0aGUgY2hlY2sgbm9kZQ0KPj4gaWQgZnJvbSBw
b29sX3BhZ2VfcmV1c2FibGU/DQoNCj5JIGRvbid0IGZvbGxvdy4NCj5JIGRvIHRoaW5rIHRoaXMg
cGF0Y2ggaGFuZGxlIGluLWZsaWdodCBwYWdlcywgYXMgdGhleSBoYXZlIHRvIHRyYXZlbA0KPmJh
Y2stdGhyb3VnaCB0aGUgcHRyX3JpbmcuDQoNCg0KaW4tZmxpZ2h0IHBhZ2VzIG1heWJlIGxvb3Ag
YmV0d2VlbiBwb29sLT4gYWxsb2MuY2FjaGUgYW5kIGluLWZsaWdodCwgYW5kIGRpZCBub3QgdHJh
dmVsIHRvIHB0cl9yaW5nDQoNCg0KLUxpDQoNCg0KDQoNCg0KDQogICAg
