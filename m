Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8310E2D3B9E
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 07:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgLIGni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 01:43:38 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2474 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgLIGni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 01:43:38 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CrSCL2XBfz53HR;
        Wed,  9 Dec 2020 14:42:22 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 9 Dec 2020 14:42:53 +0800
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 9 Dec 2020 14:42:53 +0800
Received: from dggemi762-chm.china.huawei.com ([10.1.198.148]) by
 dggemi762-chm.china.huawei.com ([10.1.198.148]) with mapi id 15.01.1913.007;
 Wed, 9 Dec 2020 14:42:53 +0800
From:   "Zouwei (Samuel)" <zou_wei@huawei.com>
To:     Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggLW5leHRdIG5ldC9tbHg1X2NvcmU6IHJlbW92ZSB1?=
 =?utf-8?Q?nused_including_<generated/utsrelease.h>?=
Thread-Topic: [PATCH -next] net/mlx5_core: remove unused including
 <generated/utsrelease.h>
Thread-Index: AQHWzJDaljzX6seqXUWx/HXxe0lIeantD64AgAC4AACAAIv7sA==
Date:   Wed, 9 Dec 2020 06:42:53 +0000
Message-ID: <2cea626052e7430bbc39c3ba14bf8fe2@huawei.com>
References: <1607343240-39155-1-git-send-email-zou_wei@huawei.com>
 <20201208112226.1bb31229@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201209062100.GK4430@unreal>
In-Reply-To: <20201209062100.GK4430@unreal>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

b2ssIEkgd2lsbCBhZGQgdGhlIEZpeGVzIGxpbmUgYW5kIHNlbmQgdGhlIHYyIHNvb24uDQoNCi0t
LS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogTGVvbiBSb21hbm92c2t5IFttYWlsdG86
bGVvbkBrZXJuZWwub3JnXSANCuWPkemAgeaXtumXtDogMjAyMOW5tDEy5pyIOeaXpSAxNDoyMQ0K
5pS25Lu25Lq6OiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0K5oqE6YCBOiBab3V3
ZWkgKFNhbXVlbCkgPHpvdV93ZWlAaHVhd2VpLmNvbT47IHNhZWVkbUBudmlkaWEuY29tOyBkYXZl
bUBkYXZlbWxvZnQubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1yZG1hQHZnZXIu
a2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0K5Li76aKYOiBSZTogW1BB
VENIIC1uZXh0XSBuZXQvbWx4NV9jb3JlOiByZW1vdmUgdW51c2VkIGluY2x1ZGluZyA8Z2VuZXJh
dGVkL3V0c3JlbGVhc2UuaD4NCg0KT24gVHVlLCBEZWMgMDgsIDIwMjAgYXQgMTE6MjI6MjZBTSAt
MDgwMCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIE1vbiwgNyBEZWMgMjAyMCAyMDoxNDow
MCArMDgwMCBab3UgV2VpIHdyb3RlOg0KPiA+IFJlbW92ZSBpbmNsdWRpbmcgPGdlbmVyYXRlZC91
dHNyZWxlYXNlLmg+IHRoYXQgZG9uJ3QgbmVlZCBpdC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IFpvdSBXZWkgPHpvdV93ZWlAaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jIHwgMSAtDQo+ID4gIDEgZmlsZSBj
aGFuZ2VkLCAxIGRlbGV0aW9uKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jIA0KPiA+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+ID4gaW5kZXggOTg5YzcwYy4u
ODJlY2MxNjEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX3JlcC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+ID4gQEAgLTMwLDcgKzMwLDYgQEANCj4gPiAgICogU09G
VFdBUkUuDQo+ID4gICAqLw0KPiA+DQo+ID4gLSNpbmNsdWRlIDxnZW5lcmF0ZWQvdXRzcmVsZWFz
ZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvbWx4NS9mcy5oPg0KPiA+ICAjaW5jbHVkZSA8bmV0
L3N3aXRjaGRldi5oPg0KPiA+ICAjaW5jbHVkZSA8bmV0L3BrdF9jbHMuaD4NCg0KSmFrdWIsDQoN
CllvdSBwcm9iYWJseSBkb2Vzbid0IGhhdmUgbGF0ZXN0IG5ldC1uZXh0Lg0KDQpJbiB0aGUgY29t
bWl0IDE3YTc2MTJiOTllNiAoIm5ldC9tbHg1X2NvcmU6IENsZWFuIGRyaXZlciB2ZXJzaW9uIGFu
ZCBuYW1lIiksIEkgcmVtb3ZlZCAic3RybGNweShkcnZpbmZvLT52ZXJzaW9uLCBVVFNfUkVMRUFT
RSwgc2l6ZW9mKGRydmluZm8tPnZlcnNpb24pKTsiIGxpbmUuDQoNClRoZSBwYXRjaCBpcyBvaywg
YnV0IHNob3VsZCBoYXZlIEZpeGVzIGxpbmUuDQpGaXhlczogMTdhNzYxMmI5OWU2ICgibmV0L21s
eDVfY29yZTogQ2xlYW4gZHJpdmVyIHZlcnNpb24gYW5kIG5hbWUiKQ0KDQpUaGFua3MNCg0KPg0K
Pg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmM6IElu
IGZ1bmN0aW9uIOKAmG1seDVlX3JlcF9nZXRfZHJ2aW5mb+KAmToNCj4gZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jOjY2OjI4OiBlcnJvcjog4oCYVVRTX1JF
TEVBU0XigJkgdW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pOyBkaWQgeW91
IG1lYW4g4oCYQ1NTX1JFTEVBU0VE4oCZPw0KPiAgICA2NiB8ICBzdHJsY3B5KGRydmluZm8tPnZl
cnNpb24sIFVUU19SRUxFQVNFLCBzaXplb2YoZHJ2aW5mby0+dmVyc2lvbikpOw0KPiAgICAgICB8
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+DQo+ICAgICAgIHwgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgQ1NTX1JFTEVBU0VEDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYzo2NjoyODogbm90ZTogZWFjaCANCj4gdW5kZWNs
YXJlZCBpZGVudGlmaWVyIGlzIHJlcG9ydGVkIG9ubHkgb25jZSBmb3IgZWFjaCBmdW5jdGlvbiBp
dCANCj4gYXBwZWFycyBpbg0KPiBtYWtlWzZdOiAqKiogW2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9yZXAub10gRXJyb3IgDQo+IDENCj4gbWFrZVs1XTogKioqIFtk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmVdIEVycm9yIDINCj4gbWFrZVs0
XTogKioqIFtkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veF0gRXJyb3IgMg0KPiBtYWtlWzNd
OiAqKiogW2RyaXZlcnMvbmV0L2V0aGVybmV0XSBFcnJvciAyDQo+IG1ha2VbMl06ICoqKiBbZHJp
dmVycy9uZXRdIEVycm9yIDINCj4gbWFrZVsyXTogKioqIFdhaXRpbmcgZm9yIHVuZmluaXNoZWQg
am9icy4uLi4NCj4gbWFrZVsxXTogKioqIFtkcml2ZXJzXSBFcnJvciAyDQo+IG1ha2U6ICoqKiBb
X19zdWItbWFrZV0gRXJyb3IgMg0K
