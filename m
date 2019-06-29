Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979A05ABB1
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 16:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfF2OOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 10:14:02 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3016 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726770AbfF2OOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 10:14:02 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id EBD3F63A0F28E98C15C6;
        Sat, 29 Jun 2019 22:13:59 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 29 Jun 2019 22:13:59 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Sat, 29 Jun 2019 22:13:59 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1591.008;
 Sat, 29 Jun 2019 22:13:59 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     David Ahern <dsahern@gmail.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>
CC:     "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjRdIG5ldDogbmV0ZmlsdGVyOiBGaXggcnBmaWx0?=
 =?utf-8?Q?er_dropping_vrf_packets_by_mistake?=
Thread-Topic: [PATCH v4] net: netfilter: Fix rpfilter dropping vrf packets by
 mistake
Thread-Index: AdUuGy8DDB3uB4ksWUWckzFOhXp+DAAFqTYAABSVBMA=
Date:   Sat, 29 Jun 2019 14:13:59 +0000
Message-ID: <cef929f9a14f462f9f7d3fa475f84e76@huawei.com>
References: <2213b3e722a14ee48768ecc7118efc46@huawei.com>
 <08740476-acfb-d35a-50b7-3aee42f23bfa@gmail.com>
In-Reply-To: <08740476-acfb-d35a-50b7-3aee42f23bfa@gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yOS8xOSAyMDoyMCBQTSwgRGF2aWQgQWhlcm4gd3JvdGU6DQo+IE9uIDYvMjgvMTkgODox
MyBQTSwgbGlubWlhb2hlIHdyb3RlOg0KPiA+IFlvdSdyZSByaWdodC4gRmliIHJ1bGVzIGNvZGUg
d291bGQgc2V0IEZMT1dJX0ZMQUdfU0tJUF9OSF9PSUYgZmxhZy4gIA0KPiA+IEJ1dCBJIHNldCBp
dCBoZXJlIGZvciBkaXN0aW5ndWlzaCB3aXRoIHRoZSBmbGFncyAmIFhUX1JQRklMVEVSX0xPT1NF
IA0KPiA+IGJyYW5jaC4gV2l0aG91dCB0aGlzLCB0aGV5IGRvIHRoZSBzYW1lIHdvcmsgYW5kIG1h
eWJlIHNob3VsZCBiZSAgDQo+ID4gY29tYmluZWQuIEkgZG9uJ3Qgd2FudCB0byBkbyB0aGF0IGFz
IHRoYXQgbWFrZXMgY29kZSBjb25mdXNpbmcuDQo+ID4gSXMgdGhpcyBjb2RlIHNuaXBldCBiZWxv
dyBvayA/IElmIHNvLCBJIHdvdWxkIGRlbGV0ZSB0aGlzIGZsYWcgc2V0dGluZy4NCj4gPiAgDQo+
ID4gICAgICAgIH0gZWxzZSBpZiAobmV0aWZfaXNfbDNfbWFzdGVyKGRldikgfHwgbmV0aWZfaXNf
bDNfc2xhdmUoZGV2KSkgew0KPiA+ICAgICAgICAgICAgICAgIGZsNi5mbG93aTZfb2lmID0gZGV2
LT5pZmluZGV4Ow0KPiA+ICAgICAgICAgfSBlbHNlIGlmICgoZmxhZ3MgJiBYVF9SUEZJTFRFUl9M
T09TRSkgPT0gMCkNCj4gPiAgICAgICAgICAgICAgICAgZmw2LmZsb3dpNl9vaWYgPSBkZXYtPmlm
aW5kZXg7DQoNCj4gdGhhdCBsb29rcyBmaW5lIHRvIG1lLCBidXQgaXQgaXMgdXAgdG8gUGFibG8u
DQoNCkBEYXZpZCBBaGVybiAgTWFueSB0aGFua3MgZm9yIHlvdXIgdmFsdWFibGUgYWR2aWNlLg0K
DQpAIFBhYmxvIEhpLCBjb3VsZCB5b3UgcGxlYXNlIHRlbGwgbWUgaWYgdGhpcyBjb2RlIHNuaXBl
dCBpcyBvaz8NCklmIG5vdCwgd2hpY2ggY29kZSB3b3VsZCB5b3UgcHJlZmVyPyBJdCdzIHZlcnkg
bmljZSBvZiB5b3UgdG8NCmZpZ3VyZSBpdCBvdXQgZm9yIG1lLiBUaGFua3MgYSBsb3QuDQoNCkhh
dmUgYSBuaWNlIGRheS4NCkJlc3Qgd2lzaGVzLg0K
