Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4082F1FC4C3
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 05:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgFQDiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 23:38:15 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2610 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726497AbgFQDiO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 23:38:14 -0400
Received: from nkgeml709-chm.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 0F926964A3111022ECF8;
        Wed, 17 Jun 2020 11:38:12 +0800 (CST)
Received: from nkgeml708-chm.china.huawei.com (10.98.57.160) by
 nkgeml709-chm.china.huawei.com (10.98.57.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 17 Jun 2020 11:38:11 +0800
Received: from nkgeml708-chm.china.huawei.com ([10.98.57.160]) by
 nkgeml708-chm.china.huawei.com ([10.98.57.160]) with mapi id 15.01.1913.007;
 Wed, 17 Jun 2020 11:38:11 +0800
From:   "Guodeqing (A)" <geffrey.guo@huawei.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dsa@cumulusnetworks.com" <dsa@cumulusnetworks.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG5ldDogRml4IHRoZSBhcnAgZXJyb3IgaW4gc29t?=
 =?utf-8?Q?e_cases?=
Thread-Topic: [PATCH] net: Fix the arp error in some cases
Thread-Index: AQHWREyWidRQh+MCik6tWg2ID4mh6ajbmuIAgACNscA=
Date:   Wed, 17 Jun 2020 03:38:11 +0000
Message-ID: <55929b71c9b24aeeba760585fc59497f@huawei.com>
References: <1592359636-107798-1-git-send-email-geffrey.guo@huawei.com>
 <39780a81-8ac8-871b-2176-2102322f9321@gmail.com>
In-Reply-To: <39780a81-8ac8-871b-2176-2102322f9321@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.164.122.165]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cnRfc2V0X25leHRob3AgaW4gX19ta3JvdXRlX291dHB1dCB3aWxsIGNoZWNrIHRoZSBuaC0+bmhf
c2NvcGUgdmFsdWUgdG8gZGV0ZXJtaW5lIHdoZXRoZXIgdG8gdXNlIHRoZSBndyBvciBub3QuDQoJ
CWlmIChuaC0+bmhfZ3cgJiYgbmgtPm5oX3Njb3BlID09IFJUX1NDT1BFX0xJTkspIHsNCgkJCXJ0
LT5ydF9nYXRld2F5ID0gbmgtPm5oX2d3Ow0KCQkJcnQtPnJ0X3VzZXNfZ2F0ZXdheSA9IDE7DQoJ
CX0NCg0KKGlwX3JvdXRlX291dHB1dF9rZXlfaGFzaC0+IGlwX3JvdXRlX291dHB1dF9rZXlfaGFz
aF9yY3UtPiBfX21rcm91dGVfb3V0cHV0LT4gcnRfc2V0X25leHRob3ApDQoNCi0tLS0t6YKu5Lu2
5Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogRGF2aWQgQWhlcm4gW21haWx0bzpkc2FoZXJuQGdtYWls
LmNvbV0gDQrlj5HpgIHml7bpl7Q6IFdlZG5lc2RheSwgSnVuZSAxNywgMjAyMCAxMToxMA0K5pS2
5Lu25Lq6OiBHdW9kZXFpbmcgKEEpIDxnZWZmcmV5Lmd1b0BodWF3ZWkuY29tPjsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldA0K5oqE6YCBOiBrdXpuZXRAbXMyLmluci5hYy5ydTsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgZHNhQGN1bXVsdXNuZXR3b3Jrcy5jb207IGt1YmFAa2VybmVsLm9yZw0K5Li76aKY
OiBSZTogW1BBVENIXSBuZXQ6IEZpeCB0aGUgYXJwIGVycm9yIGluIHNvbWUgY2FzZXMNCg0KT24g
Ni8xNi8yMCA4OjA3IFBNLCBndW9kZXFpbmcgd3JvdGU6DQo+IGllLiwNCj4gJCBpZmNvbmZpZyBl
dGgwIDYuNi42LjYgbmV0bWFzayAyNTUuMjU1LjI1NS4wDQo+IA0KPiAkIGlwIHJ1bGUgYWRkIGZy
b20gNi42LjYuNiB0YWJsZSA2NjY2DQo+IA0KPiAkIGlwIHJvdXRlIGFkZCA5LjkuOS45IHZpYSA2
LjYuNi42DQo+IA0KPiAkIHBpbmcgLUkgNi42LjYuNiA5LjkuOS45DQo+IFBJTkcgOS45LjkuOSAo
OS45LjkuOSkgZnJvbSA2LjYuNi42IDogNTYoODQpIGJ5dGVzIG9mIGRhdGEuDQo+IA0KPiAzIHBh
Y2tldHMgdHJhbnNtaXR0ZWQsIDAgcmVjZWl2ZWQsIDEwMCUgcGFja2V0IGxvc3MsIHRpbWUgMjA3
OW1zDQo+IA0KPiAkIGFycA0KPiBBZGRyZXNzICAgICBIV3R5cGUgIEhXYWRkcmVzcyAgICAgICAg
ICAgRmxhZ3MgTWFzayAgICAgICAgICAgIElmYWNlDQo+IDYuNi42LjYgICAgICAgICAgICAgKGlu
Y29tcGxldGUpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZXRoMA0KPiANCj4gVGhlIGFy
cCByZXF1ZXN0IGFkZHJlc3MgaXMgZXJyb3IsIHRoaXMgaXMgYmVjYXVzZSBmaWJfdGFibGVfbG9v
a3VwIGluIA0KPiBmaWJfY2hlY2tfbmggbG9va3VwIHRoZSBkZXN0bmF0aW9uIDkuOS45LjkgbmV4
dGhvcCwgdGhlIHNjb3BlIG9mIHRoZSANCj4gZmliIHJlc3VsdCBpcyBSVF9TQ09QRV9MSU5LLHRo
ZSBjb3JyZWN0IHNjb3BlIGlzIFJUX1NDT1BFX0hPU1QuDQo+IEhlcmUgSSBhZGQgYSBjaGVjayBv
ZiB3aGV0aGVyIHRoaXMgaXMgUlRfVEFCTEVfTUFJTiB0byBzb2x2ZSB0aGlzIHByb2JsZW0uDQoN
CmZpYl9jaGVja19uaCogaXMgb25seSB1c2VkIHdoZW4gdGhlIHJvdXRlIGlzIGluc3RhbGxlZCBp
bnRvIHRoZSBGSUIgdG8gdmVyaWZ5IHRoZSBnYXRld2F5IGlzIGxlZ2l0LiBJdCBpcyBub3QgdXNl
ZCB3aGVuIHByb2Nlc3NpbmcgYXJwIHJlcXVlc3RzLiBXaHkgdGhlbiwgZG8geW91IGJlbGlldmUg
dGhpcyBmaXhlcyBzb21ldGhpbmc/DQo=
