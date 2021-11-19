Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E5D456C42
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 10:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhKSJZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 04:25:26 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31888 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbhKSJZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 04:25:26 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HwWK21phgzcbGn;
        Fri, 19 Nov 2021 17:17:26 +0800 (CST)
Received: from dggema722-chm.china.huawei.com (10.3.20.86) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.20; Fri, 19 Nov 2021 17:22:22 +0800
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggema722-chm.china.huawei.com (10.3.20.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 19 Nov 2021 17:22:22 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.015;
 Fri, 19 Nov 2021 17:22:22 +0800
From:   guodaxing <guodaxing@huawei.com>
To:     "greg@kroah.com" <greg@kroah.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chenzhe <chenzhe@huawei.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBuZXQvc21jOiBsb29wIGluIHNtY19saXN0ZW4=?=
Thread-Topic: [PATCH] net/smc: loop in smc_listen
Thread-Index: Adfc89A5MXcXseYRQqyX5/r50pQRHv//uvEA//9U5lA=
Date:   Fri, 19 Nov 2021 09:22:22 +0000
Message-ID: <a6f25ac86f284731962152ecba173d37@huawei.com>
References: <aec0a1e1964b4696b8636ce3945e6551@huawei.com>
 <YZdNks4CQ7CS8ILg@kroah.com>
In-Reply-To: <YZdNks4CQ7CS8ILg@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.108.243.85]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T0sNCg0KLS0tLS3Tyrz+1K28/i0tLS0tDQq3orz+yMs6IGdyZWdAa3JvYWguY29tIFttYWlsdG86
Z3JlZ0Brcm9haC5jb21dIA0Kt6LLzcqxvOQ6IDIwMjHE6jEx1MIxOcjVIDE1OjA5DQrK1bz+yMs6
IGd1b2RheGluZyA8Z3VvZGF4aW5nQGh1YXdlaS5jb20+DQqzrcvNOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBDaGVuemhlIDxjaGVuemhlQGh1YXdlaS5jb20+OyBsaW51eC1zMzkwQHZnZXIua2Vy
bmVsLm9yZw0K1vfM4jogUmU6IFtQQVRDSF0gbmV0L3NtYzogbG9vcCBpbiBzbWNfbGlzdGVuDQoN
Ck9uIEZyaSwgTm92IDE5LCAyMDIxIGF0IDAzOjIxOjE2QU0gKzAwMDAsIGd1b2RheGluZyB3cm90
ZToNCj4gVGhlIGtlcm5lbF9saXN0ZW4gZnVuY3Rpb24gaW4gc21jX2xpc3RlbiB3aWxsIGZhaWwg
d2hlbiBhbGwgdGhlIA0KPiBhdmFpbGFibGUNCg0KPHNuaXA+DQoNCllvdSBuZWVkIHRvIHJlc2Vu
ZCB0aGlzIHdpdGhvdXQgaHRtbCwgYXMgdGhlIG1haWxpbmcgbGlzdCByZWplY3RzIGh0bWwgcGF0
Y2hlcyBhbmQgd2UgY2FuIG5vdCBhcHBseSB0aGVtLg0KDQp0aGFua3MsDQoNCmdyZWcgay1oDQo=
