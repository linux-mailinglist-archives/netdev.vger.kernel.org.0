Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D977D245555
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 03:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgHPBu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 21:50:59 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3062 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726029AbgHPBu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 21:50:59 -0400
Received: from dggeme753-chm.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id AE8CB6034F408C27F43B;
        Sat, 15 Aug 2020 09:50:20 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme753-chm.china.huawei.com (10.3.19.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 15 Aug 2020 09:50:20 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Sat, 15 Aug 2020 09:50:20 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Yonghong Song <yhs@fb.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "andriin@fb.com" <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: Convert to use the preferred fallthrough macro
Thread-Topic: [PATCH] bpf: Convert to use the preferred fallthrough macro
Thread-Index: AdZypir53l10TT+tT3O02hA35HBVZA==
Date:   Sat, 15 Aug 2020 01:50:20 +0000
Message-ID: <878cef61a8c549fd92764314e7c07a95@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.252]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3JvdGU6DQo+T24gOC8xNC8yMCAyOjE2IEFNLCBN
aWFvaGUgTGluIHdyb3RlOg0KPj4gQ29udmVydCB0aGUgdXNlcyBvZiBmYWxsdGhyb3VnaCBjb21t
ZW50cyB0byBmYWxsdGhyb3VnaCBtYWNyby4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogTWlhb2hl
IExpbiA8bGlubWlhb2hlQGh1YXdlaS5jb20+DQo+DQo+VGhpcyBpcyBub3QgYSBidWcgZml4IGJ1
dCByYXRoZXIgYW4gZW5oYW5jZW1lbnQgc28gbm90IHN1cmUgd2hldGhlciB0aGlzIHNob3VsZCBw
dXNoIHRvIGJwZiB0cmVlIG9yIHdhaXQgdW50aWwgYnBmLW5leHQuDQo+DQo+SXQgbWF5IGJlIHdv
cnRod2hpbGUgdG8gbWVudGlvbiBDb21taXQgMjk0ZjY5ZTY2MmQxDQo+ICgiY29tcGlsZXJfYXR0
cmlidXRlcy5oOiBBZGQgJ2ZhbGx0aHJvdWdoJyBwc2V1ZG8ga2V5d29yZCBmb3Igc3dpdGNoL2Nh
c2UgdXNlIikgc28gcGVvcGxlIGNhbiB1bmRlcnN0YW5kIHdoeSB0aGlzIHBhdGNoIGlzIG5lZWRl
ZC4NCj4NCg0KV2lsbCBkby4gTWFueSB0aGFua3MuDQoNCj5XaXRoIGFib3ZlIHN1Z2dlc3Rpb25z
LA0KPkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KPg0KDQo=
