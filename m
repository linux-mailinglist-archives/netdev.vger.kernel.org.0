Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5993651F9DC
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiEIKc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiEIKcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:32:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A91724EA2B;
        Mon,  9 May 2022 03:27:53 -0700 (PDT)
Received: from canpemm100008.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KxclT20G8zfbQ1;
        Mon,  9 May 2022 18:26:13 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 canpemm100008.china.huawei.com (7.192.104.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 9 May 2022 18:27:23 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.024;
 Mon, 9 May 2022 18:27:22 +0800
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggYnBmLW5leHRdIHNhbXBsZXMvYnBmOiBjaGVjayBk?=
 =?utf-8?Q?etach_prog_exist_or_not_in_xdp=5Ffwd?=
Thread-Topic: [PATCH bpf-next] samples/bpf: check detach prog exist or not in
 xdp_fwd
Thread-Index: AQHYYz67ysyf9xnyEEa5gXY59XVHBq0VxqsAgACPrJA=
Date:   Mon, 9 May 2022 10:27:22 +0000
Message-ID: <f9c85578b94a4a38b3f7b9c796810a30@huawei.com>
References: <20220509005105.271089-1-shaozhengchao@huawei.com>
 <87pmknyr6b.fsf@toke.dk>
In-Reply-To: <87pmknyr6b.fsf@toke.dk>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.66]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQotLS0tLemCruS7tuWOn+S7ti0tLS0tDQrlj5Hku7bkuro6IFRva2UgSMO4aWxhbmQtSsO4cmdl
bnNlbiBbbWFpbHRvOnRva2VAa2VybmVsLm9yZ10gDQrlj5HpgIHml7bpl7Q6IDIwMjLlubQ15pyI
OeaXpSAxNzo0Ng0K5pS25Lu25Lq6OiBzaGFvemhlbmdjaGFvIDxzaGFvemhlbmdjaGFvQGh1YXdl
aS5jb20+OyBicGZAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBhc3RAa2VybmVsLm9yZzsgZGFuaWVsQGlvZ2VhcmJv
eC5uZXQ7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgaGF3a0BrZXJuZWwu
b3JnOyBqb2huLmZhc3RhYmVuZEBnbWFpbC5jb207IGFuZHJpaUBrZXJuZWwub3JnOyBrYWZhaUBm
Yi5jb207IHNvbmdsaXVicmF2aW5nQGZiLmNvbTsgeWhzQGZiLmNvbTsga3BzaW5naEBrZXJuZWwu
b3JnDQrmioTpgIE6IHdlaXlvbmdqdW4gKEEpIDx3ZWl5b25nanVuMUBodWF3ZWkuY29tPjsgc2hh
b3poZW5nY2hhbyA8c2hhb3poZW5nY2hhb0BodWF3ZWkuY29tPjsgeXVlaGFpYmluZyA8eXVlaGFp
YmluZ0BodWF3ZWkuY29tPg0K5Li76aKYOiBSZTogW1BBVENIIGJwZi1uZXh0XSBzYW1wbGVzL2Jw
ZjogY2hlY2sgZGV0YWNoIHByb2cgZXhpc3Qgb3Igbm90IGluIHhkcF9md2QNCg0KWmhlbmdjaGFv
IFNoYW8gPHNoYW96aGVuZ2NoYW9AaHVhd2VpLmNvbT4gd3JpdGVzOg0KDQo+IEJlZm9yZSBkZXRh
Y2ggdGhlIHByb2csIHdlIHNob3VsZCBjaGVjayBkZXRhY2ggcHJvZyBleGlzdCBvciBub3QuDQoN
CklmIHdlJ3JlIGFkZGluZyBzdWNoIGEgY2hlY2sgd2Ugc2hvdWxkIGFsc28gY2hlY2sgdGhhdCBp
dCdzIHRoZSAqcmlnaHQqIHByb2dyYW0uIEkuZS4sIHF1ZXJ5IHRoZSBJRCBmb3IgdGhlIHByb2dy
YW0gbmFtZSBhbmQgY2hlY2sgdGhhdCBpdCBtYXRjaGVzIHdoYXQgdGhlIHByb2dyYW0gYXR0YWNo
ZWQsIHRoZW4gb2J0YWluIGFuIGZkIGFuZCBwYXNzIHRoYXQgYXMgWERQX0VYUEVDVEVEX0ZEIG9u
IGRldGFjaCB0byBtYWtlIHN1cmUgaXQgd2Fzbid0IHN3YXBwZWQgb3V0IGluIHRoZSBtZWFudGlt
ZS4uLg0KDQotVG9rZQ0KDQpUaGFuayB5b3UgZm9yIHlvdXIgcmVwbHkuIFdoZW4gZmluaXNoIHJ1
bm5pbmcgeGRwX2Z3ZCB0byBhdHRhdGNoIHByb2csIHRoZSBwcm9ncmFtIHdpbGwgZXhpdCBhbmQg
Y2FuJ3Qgc3RvcmUgZmQgYXMgWERQX0VYUEVDVEVEX0ZELiANCg0KSSB0aGluayB0aGUgc2FtcGxl
IHhkcF9md2QgLWQgaXMganVzdCBkZXRhY2ggcHJvZyBhbmQgZG9uJ3QgY2FyZSBpZiB0aGUgZmQg
aXMgZXhwZWN0ZWQuDQoNCi16aGVuZ2NoYW8gc2hhbyANCg==
