Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A34B245569
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 04:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgHPCCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 22:02:36 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3478 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727824AbgHPCCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 22:02:36 -0400
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id B36A2BC88270589DE43A;
        Sat, 15 Aug 2020 10:02:18 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme752-chm.china.huawei.com (10.3.19.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 15 Aug 2020 10:02:18 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Sat, 15 Aug 2020 10:02:18 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: correct zerocopy refcnt with newly allocated UDP or
 RAW uarg
Thread-Topic: [PATCH] net: correct zerocopy refcnt with newly allocated UDP or
 RAW uarg
Thread-Index: AdZyp1tkhsmk8znDTaCFo8WdLFJE0Q==
Date:   Sat, 15 Aug 2020 02:02:18 +0000
Message-ID: <0627950da21443c2b422d9861e81bf3a@huawei.com>
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

V2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4gd3JvdGU6
DQo+T24gRnJpLCBBdWcgMTQsIDIwMjAgYXQgMTA6MTcgQU0gbGlubWlhb2hlIDxsaW5taWFvaGVA
aHVhd2VpLmNvbT4gd3JvdGU6DQo+Pg0KPg0KPkkgZG9uJ3QgdGhpbmsgdGhhdCBjYW4gaGFwcGVu
Lg0KPg0KPlRoZSBxdWVzdGlvbiBpcyB3aGVuIHRoaXMgYnJhbmNoIGlzIGZhbHNlDQo+DQo+ICAg
ICAgICAgICAgICAgIG5leHQgPSAodTMyKWF0b21pY19yZWFkKCZzay0+c2tfemNrZXkpOw0KPiAg
ICAgICAgICAgICAgICBpZiAoKHUzMikodWFyZy0+aWQgKyB1YXJnLT5sZW4pID09IG5leHQpIHsN
Cj4NCj5JIGNhbm5vdCBjb21lIHVwIHdpdGggYSBjYXNlLiBJIHRoaW5rIGl0IG1pZ2h0IGJlIHZl
c3RpZ2lhbC4gVGhlIGdvYWwgaXMgdG8gZW5zdXJlIHRvIGFwcGVuZCBvbmx5IGEgY29uc2VjdXRp
dmUgcmFuZ2Ugb2Ygbm90aWZpY2F0aW9uIElEcy4NCj5FYWNoIG5vdGlmaWNhdGlvbiBJRCBjb3Jy
ZXNwb25kcyB0byBhIHNlbmRtc2cgaW52b2NhdGlvbiB3aXRoIE1TR19aRVJPQ09QWS4gSW4gYm90
aCBUQ1AgYW5kIFVEUCB3aXRoIGNvcmtpbmcsIGRhdGEgaXMgb3JkZXJlZCBhbmQgYWNjZXNzIHRv
IGNoYW5nZXMgdG8gdGhlc2UgZmllbGRzIGhhcHBlbiB0b2dldGhlciBhcyBhIHRyYW5zYWN0aW9u
Og0KPg0KPiAgICAgICAgICAgICAgICAvKiByZWFsbG9jIG9ubHkgd2hlbiBzb2NrZXQgaXMgbG9j
a2VkIChUQ1AsIFVEUCBjb3JrKSwNCj4gICAgICAgICAgICAgICAgICogc28gdWFyZy0+bGVuIGFu
ZCBza196Y2tleSBhY2Nlc3MgaXMgc2VyaWFsaXplZA0KPiAgICAgICAgICAgICAgICAgKi8NCg0K
U28gd2hhdCBJIGNvbmNlcm5lZCBpcyBqdXN0IGEgdGhlb3JldGljYWxseSBwcm9ibGVtcy4gSWYg
d2UgY2FuIGFsd2F5cyBndWFyYW50ZWUgc29ja196ZXJvY29weV9yZWFsbG9jIG9ubHkgcmV0dXJu
cyB0aGUgZXhpc3RpbmcgdWFyZyBvciBOVUxMIHdoZW4gb24gc2tiX3pjb3B5KHNrYiksDQpiYWQg
dGhpbmdzIHdvbid0IGhhcHBlbi4NCg0KTWFueSB0aGFua3MgZm9yIHlvdXIgZGV0YWlsZWQgZXhw
bGFpbmF0aW9uLg0KDQo=
