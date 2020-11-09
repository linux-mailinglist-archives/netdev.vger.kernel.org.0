Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861A42ABB28
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbgKINYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:24:55 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2304 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387725AbgKINYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:24:50 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4CVBY82Vhwz13RBm;
        Mon,  9 Nov 2020 21:24:28 +0800 (CST)
Received: from dggema708-chm.china.huawei.com (10.3.20.72) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 9 Nov 2020 21:24:43 +0800
Received: from dggema755-chm.china.huawei.com (10.1.198.197) by
 dggema708-chm.china.huawei.com (10.3.20.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 9 Nov 2020 21:24:42 +0800
Received: from dggema755-chm.china.huawei.com ([10.1.198.197]) by
 dggema755-chm.china.huawei.com ([10.1.198.197]) with mapi id 15.01.1913.007;
 Mon, 9 Nov 2020 21:24:42 +0800
From:   zhangqilong <zhangqilong3@huawei.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
CC:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggMS8yXSBQTTogcnVudGltZTogQWRkIGEgZ2VuZXJh?=
 =?utf-8?B?bCBydW50aW1lIGdldCBzeW5jIG9wZXJhdGlvbiB0byBkZWFsIHdpdGggdXNh?=
 =?utf-8?Q?ge_counter?=
Thread-Topic: [PATCH 1/2] PM: runtime: Add a general runtime get sync
 operation to deal with usage counter
Thread-Index: AQHWtphPrqJtWpRvSU6cZd2kwaKEi6m/yHOA
Date:   Mon, 9 Nov 2020 13:24:42 +0000
Message-ID: <d05e3d35a68e41e2ac36acfcd577ad47@huawei.com>
References: <20201109080938.4174745-1-zhangqilong3@huawei.com>
 <20201109080938.4174745-2-zhangqilong3@huawei.com>
 <CAJZ5v0gZp_R60FN+ZrKmEn+m0F4yjt_MB+N8uGG=fxKUnZdknQ@mail.gmail.com>
In-Reply-To: <CAJZ5v0gZp_R60FN+ZrKmEn+m0F4yjt_MB+N8uGG=fxKUnZdknQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.179.28]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkNCj4gDQo+IE9uIE1vbiwgTm92IDksIDIwMjAgYXQgOTowNSBBTSBaaGFuZyBRaWxvbmcgPHpo
YW5ncWlsb25nM0BodWF3ZWkuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IEluIG1hbnkgY2FzZSwg
d2UgbmVlZCB0byBjaGVjayByZXR1cm4gdmFsdWUgb2YgcG1fcnVudGltZV9nZXRfc3luYywNCj4g
PiBidXQgaXQgYnJpbmdzIGEgdHJvdWJsZSB0byB0aGUgdXNhZ2UgY291bnRlciBwcm9jZXNzaW5n
LiBNYW55IGNhbGxlcnMNCj4gPiBmb3JnZXQgdG8gZGVjcmVhc2UgdGhlIHVzYWdlIGNvdW50ZXIg
d2hlbiBpdCBmYWlsZWQuIEl0IGhhcyBiZWVuDQo+ID4gZGlzY3Vzc2VkIGEgbG90WzBdWzFdLiBT
byB3ZSBhZGQgYSBmdW5jdGlvbiB0byBkZWFsIHdpdGggdGhlIHVzYWdlDQo+ID4gY291bnRlciBm
b3IgYmV0dGVyIGNvZGluZy4NCj4gPg0KPiA+IFswXWh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIw
LzYvMTQvODgNCj4gPiBbMV1odHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3Byb2plY3QvbGlu
dXgtdGVncmEvcGF0Y2gvMjAyMDA1MjAwOTUxDQo+ID4gNDguMTA5OTUtMS1kaW5naGFvLmxpdUB6
anUuZWR1LmNuLw0KPiA+IFNpZ25lZC1vZmYtYnk6IFpoYW5nIFFpbG9uZyA8emhhbmdxaWxvbmcz
QGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gIGluY2x1ZGUvbGludXgvcG1fcnVudGltZS5oIHwg
MzIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDMyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3Bt
X3J1bnRpbWUuaCBiL2luY2x1ZGUvbGludXgvcG1fcnVudGltZS5oDQo+ID4gaW5kZXggNGI3MDhm
NGU4ZWVkLi4yYjBhZjViMWRmZmQgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9wbV9y
dW50aW1lLmgNCj4gPiArKysgYi9pbmNsdWRlL2xpbnV4L3BtX3J1bnRpbWUuaA0KPiA+IEBAIC0z
ODYsNiArMzg2LDM4IEBAIHN0YXRpYyBpbmxpbmUgaW50IHBtX3J1bnRpbWVfZ2V0X3N5bmMoc3Ry
dWN0IGRldmljZQ0KPiAqZGV2KQ0KPiA+ICAgICAgICAgcmV0dXJuIF9fcG1fcnVudGltZV9yZXN1
bWUoZGV2LCBSUE1fR0VUX1BVVCk7ICB9DQo+ID4NCj4gPiArLyoqDQo+ID4gKyAqIGdlbmVfcG1f
cnVudGltZV9nZXRfc3luYyAtIEJ1bXAgdXAgdXNhZ2UgY291bnRlciBvZiBhIGRldmljZSBhbmQN
Cj4gcmVzdW1lIGl0Lg0KPiA+ICsgKiBAZGV2OiBUYXJnZXQgZGV2aWNlLg0KPiANCj4gVGhlIGZv
cmNlIGFyZ3VtZW50IGlzIG5vdCBkb2N1bWVudGVkLg0KDQooMSkgR29vZCBjYXRjaCwgSSB3aWxs
IGFkZCBpdCBpbiBuZXh0IHZlcnNpb24uDQoNCj4gDQo+ID4gKyAqDQo+ID4gKyAqIEluY3JlYXNl
IHJ1bnRpbWUgUE0gdXNhZ2UgY291bnRlciBvZiBAZGV2IGZpcnN0LCBhbmQgY2Fycnkgb3V0DQo+
ID4gKyBydW50aW1lLXJlc3VtZQ0KPiA+ICsgKiBvZiBpdCBzeW5jaHJvbm91c2x5LiBJZiBfX3Bt
X3J1bnRpbWVfcmVzdW1lIHJldHVybiBuZWdhdGl2ZQ0KPiA+ICsgdmFsdWUoZGV2aWNlIGlzIGlu
DQo+ID4gKyAqIGVycm9yIHN0YXRlKSBvciByZXR1cm4gcG9zaXRpdmUgdmFsdWUodGhlIHJ1bnRp
bWUgb2YgZGV2aWNlIGlzDQo+ID4gKyBhbHJlYWR5IGFjdGl2ZSkNCj4gPiArICogd2l0aCBmb3Jj
ZSBpcyB0cnVlLCBpdCBuZWVkIGRlY3JlYXNlIHRoZSB1c2FnZSBjb3VudGVyIG9mIHRoZQ0KPiA+
ICsgZGV2aWNlIHdoZW4NCj4gPiArICogcmV0dXJuLg0KPiA+ICsgKg0KPiA+ICsgKiBUaGUgcG9z
c2libGUgcmV0dXJuIHZhbHVlcyBvZiB0aGlzIGZ1bmN0aW9uIGlzIHplcm8gb3IgbmVnYXRpdmUg
dmFsdWUuDQo+ID4gKyAqIHplcm86DQo+ID4gKyAqICAgIC0gaXQgbWVhbnMgc3VjY2VzcyBhbmQg
dGhlIHN0YXR1cyB3aWxsIHN0b3JlIHRoZSByZXN1bWUgb3BlcmF0aW9uDQo+IHN0YXR1cw0KPiA+
ICsgKiAgICAgIGlmIG5lZWRlZCwgdGhlIHJ1bnRpbWUgUE0gdXNhZ2UgY291bnRlciBvZiBAZGV2
IHJlbWFpbnMNCj4gaW5jcmVtZW50ZWQuDQo+ID4gKyAqIG5lZ2F0aXZlOg0KPiA+ICsgKiAgICAt
IGl0IG1lYW5zIGZhaWx1cmUgYW5kIHRoZSBydW50aW1lIFBNIHVzYWdlIGNvdW50ZXIgb2YgQGRl
diBoYXMNCj4gYmVlbg0KPiA+ICsgKiAgICAgIGRlY3JlYXNlZC4NCj4gPiArICogcG9zaXRpdmU6
DQo+ID4gKyAqICAgIC0gaXQgbWVhbnMgdGhlIHJ1bnRpbWUgb2YgdGhlIGRldmljZSBpcyBhbHJl
YWR5IGFjdGl2ZSBiZWZvcmUgdGhhdC4gSWYNCj4gPiArICogICAgICBjYWxsZXIgc2V0IGZvcmNl
IHRvIHRydWUsIHdlIHN0aWxsIG5lZWQgdG8gZGVjcmVhc2UgdGhlIHVzYWdlDQo+IGNvdW50ZXIu
DQo+IA0KPiBXaHkgaXMgdGhpcyBuZWVkZWQ/DQoNCigyKSBJZiBjYWxsZXIgc2V0IGZvcmNlLCBp
dCBtZWFucyBjYWxsZXIgd2lsbCByZXR1cm4gZXZlbiB0aGUgZGV2aWNlIGhhcyBhbHJlYWR5IGJl
ZW4gYWN0aXZlDQooX19wbV9ydW50aW1lX3Jlc3VtZSByZXR1cm4gcG9zaXRpdmUgdmFsdWUpIGFm
dGVyIGNhbGxpbmcgZ2VuZV9wbV9ydW50aW1lX2dldF9zeW5jLA0Kd2Ugc3RpbGwgbmVlZCB0byBk
ZWNyZWFzZSB0aGUgdXNhZ2UgY291bnQuDQoNCj4gDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgaW5s
aW5lIGludCBnZW5lX3BtX3J1bnRpbWVfZ2V0X3N5bmMoc3RydWN0IGRldmljZSAqZGV2LCBib29s
DQo+ID4gK2ZvcmNlKQ0KPiANCj4gVGhlIG5hbWUgaXMgbm90IHJlYWxseSBhIGdvb2Qgb25lIGFu
ZCBub3RlIHRoYXQgcG1fcnVudGltZV9nZXQoKSBoYXMgdGhlDQo+IHNhbWUgcHJvYmxlbSBhcyBf
Z2V0X3N5bmMoKSAoaWUuIHRoZSB1c2FnZSBjb3VudGVyIGlzIGluY3JlbWVudGVkIHJlZ2FyZGxl
c3MNCj4gb2YgdGhlIHJldHVybiB2YWx1ZSkuDQo+IA0KDQooMykgSSBoYXZlIG5vdCB0aG91Z2h0
IGEgZ29vZCBuYW1lIG5vdywgaWYgeW91IGhhdmUgZ29vZCBpZGVhcywgd2VsY29tZS4NCg0KDQpU
aGFua3MsIA0KWmhhbmcNCg0KPiA+ICt7DQo+ID4gKyAgICAgICBpbnQgcmV0ID0gMDsNCj4gPiAr
DQo+ID4gKyAgICAgICByZXQgPSBfX3BtX3J1bnRpbWVfcmVzdW1lKGRldiwgUlBNX0dFVF9QVVQp
Ow0KPiA+ICsgICAgICAgaWYgKHJldCA8IDAgfHwgKHJldCA+IDAgJiYgZm9yY2UpKQ0KPiA+ICsg
ICAgICAgICAgICAgICBwbV9ydW50aW1lX3B1dF9ub2lkbGUoZGV2KTsNCj4gPiArDQo+ID4gKyAg
ICAgICByZXR1cm4gcmV0Ow0KPiA+ICt9DQo+ID4gKw0KPiA+ICAvKioNCj4gPiAgICogcG1fcnVu
dGltZV9wdXQgLSBEcm9wIGRldmljZSB1c2FnZSBjb3VudGVyIGFuZCBxdWV1ZSB1cCAiaWRsZSBj
aGVjayINCj4gaWYgMC4NCj4gPiAgICogQGRldjogVGFyZ2V0IGRldmljZS4NCj4gPiAtLQ0KPiAN
Cj4gVGhhbmtzIQ0K
