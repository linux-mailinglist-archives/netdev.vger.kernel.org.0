Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAE42AAF9C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 03:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgKICvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 21:51:42 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2301 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbgKICvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 21:51:42 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4CTwVh2q0nz13RFM;
        Mon,  9 Nov 2020 10:51:24 +0800 (CST)
Received: from dggema705-chm.china.huawei.com (10.3.20.69) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 9 Nov 2020 10:51:38 +0800
Received: from dggema755-chm.china.huawei.com (10.1.198.197) by
 dggema705-chm.china.huawei.com (10.3.20.69) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 9 Nov 2020 10:51:38 +0800
Received: from dggema755-chm.china.huawei.com ([10.1.198.197]) by
 dggema755-chm.china.huawei.com ([10.1.198.197]) with mapi id 15.01.1913.007;
 Mon, 9 Nov 2020 10:51:38 +0800
From:   zhangqilong <zhangqilong3@huawei.com>
To:     Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBuZXQ6IGZlYzogRml4IHJlZmVyZW5jZSBjb3VudCBs?=
 =?gb2312?Q?eak_in_fec_series_ops?=
Thread-Topic: [PATCH] net: fec: Fix reference count leak in fec series ops
Thread-Index: AQHWtbR0dNnOQKhcrEOwTSi35QjWC6m/CZHwgAAHX3A=
Date:   Mon, 9 Nov 2020 02:51:38 +0000
Message-ID: <deec0b718f894de191a26bbe1015882b@huawei.com>
References: <20201108095310.2892555-1-zhangqilong3@huawei.com>
 <AM8PR04MB731568128C08B0730519E9D3FFEA0@AM8PR04MB7315.eurprd04.prod.outlook.com>
In-Reply-To: <AM8PR04MB731568128C08B0730519E9D3FFEA0@AM8PR04MB7315.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.179.28]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBaaGFuZyBRaWxvbmcgPHpoYW5ncWlsb25nM0BodWF3ZWkuY29tPiBTZW50OiBTdW5k
YXksIE5vdmVtYmVyIDgsDQo+IDIwMjAgNTo1MyBQTQ0KPiA+IHBtX3J1bnRpbWVfZ2V0X3N5bmMo
KSB3aWxsIGluY3JlbWVudCBwbSB1c2FnZSBhdCBmaXJzdCBhbmQgaXQgd2lsbA0KPiA+IHJlc3Vt
ZSB0aGUgZGV2aWNlIGxhdGVyLiBJZiBydW50aW1lIG9mIHRoZSBkZXZpY2UgaGFzIGVycm9yIG9y
IGRldmljZQ0KPiA+IGlzIGluIGluYWNjZXNzaWJsZSBzdGF0ZShvciBvdGhlciBlcnJvciBzdGF0
ZSksIHJlc3VtZSBvcGVyYXRpb24gd2lsbA0KPiA+IGZhaWwuIElmIHdlIGRvIG5vdCBjYWxsIHB1
dCBvcGVyYXRpb24gdG8gZGVjcmVhc2UgdGhlIHJlZmVyZW5jZSwgaXQgd2lsbCByZXN1bHQgaW4N
Cj4gcmVmZXJlbmNlIGNvdW50IGxlYWsuDQo+ID4gTW9yZW92ZXIsIHRoaXMgZGV2aWNlIGNhbm5v
dCBlbnRlciB0aGUgaWRsZSBzdGF0ZSBhbmQgYWx3YXlzIHN0YXkgYnVzeQ0KPiA+IG9yIG90aGVy
IG5vbi1pZGxlIHN0YXRlIGxhdGVyLiBTbyB3ZSBmaXhlZCBpdCB0aHJvdWdoIGFkZGluZw0KPiBw
bV9ydW50aW1lX3B1dF9ub2lkbGUuDQo+ID4NCj4gPiBGaXhlczogOGZmZjc1NWU5ZjhkMCAoIm5l
dDogZmVjOiBFbnN1cmUgY2xvY2tzIGFyZSBlbmFibGVkIHdoaWxlIHVzaW5nDQo+ID4gbWRpbyBi
dXMiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFpoYW5nIFFpbG9uZyA8emhhbmdxaWxvbmczQGh1YXdl
aS5jb20+DQo+IA0KPiBGcm9tIGVhcmx5IGRpc2N1c3Npb24gZm9yIHRoZSB0b3BpYywgV29sZnJh
bSBTYW5nIHdvbmRlciBpZiBzdWNoIGRlLXJlZmVyZW5jZQ0KPiBjYW4gYmUgYmV0dGVyIGhhbmRs
ZWQgYnkgcG0gcnVudGltZSBjb3JlIGNvZGUuDQo+DQpJIGhhdmUgcmVhZCB0aGUgZGlzY3Vzc2lv
biBqdXN0IG5vdywgVGhleSBkaWRuJ3QgZ2l2ZSBhIGRlZmluaXRlIHJlc3VsdC4gSSBhZ3JlZWQN
CndpdGggaW50cm9kdWNpbmcgYSBuZXcgb3IgaGVscCBmdW5jdGlvbiB0byByZXBsYWNlIHRoZSBw
bV9ydW50aW1lX2dldF9zeW5jDQpncmFkdWFsbHkuIEhvdyBkbyB5b3UgdGhpbmsgc28gPw0KDQpS
ZWdhcmRzLA0KWmhhbmcNCg0KPiBodHRwczovL2xrbWwub3JnL2xrbWwvMjAyMC82LzE0Lzc2DQo+
IA0KPiBSZWdhcmRzLA0KPiBBbmR5DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L2ZyZWVzY2FsZS9mZWNfbWFpbi5jIHwgMjIgKysrKysrKysrKysrKysrKy0tLS0tLQ0KPiA+ICAx
IGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0K
PiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gPiBpbmRl
eCBkNzkxOTU1NTI1MGQuLjZjMDJmODg1YzY3ZSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+ID4gQEAgLTE4MDksOCArMTgwOSwxMCBAQCBz
dGF0aWMgaW50IGZlY19lbmV0X21kaW9fcmVhZChzdHJ1Y3QgbWlpX2J1cw0KPiA+ICpidXMsIGlu
dCBtaWlfaWQsIGludCByZWdudW0pDQo+ID4gIAlib29sIGlzX2M0NSA9ICEhKHJlZ251bSAmIE1J
SV9BRERSX0M0NSk7DQo+ID4NCj4gPiAgCXJldCA9IHBtX3J1bnRpbWVfZ2V0X3N5bmMoZGV2KTsN
Cj4gPiAtCWlmIChyZXQgPCAwKQ0KPiA+ICsJaWYgKHJldCA8IDApIHsNCj4gPiArCQlwbV9ydW50
aW1lX3B1dF9ub2lkbGUoZGV2KTsNCj4gPiAgCQlyZXR1cm4gcmV0Ow0KPiA+ICsJfQ0KPiA+DQo+
ID4gIAlpZiAoaXNfYzQ1KSB7DQo+ID4gIAkJZnJhbWVfc3RhcnQgPSBGRUNfTU1GUl9TVF9DNDU7
DQo+ID4gQEAgLTE4NjgsMTAgKzE4NzAsMTIgQEAgc3RhdGljIGludCBmZWNfZW5ldF9tZGlvX3dy
aXRlKHN0cnVjdCBtaWlfYnVzDQo+ID4gKmJ1cywgaW50IG1paV9pZCwgaW50IHJlZ251bSwNCj4g
PiAgCWJvb2wgaXNfYzQ1ID0gISEocmVnbnVtICYgTUlJX0FERFJfQzQ1KTsNCj4gPg0KPiA+ICAJ
cmV0ID0gcG1fcnVudGltZV9nZXRfc3luYyhkZXYpOw0KPiA+IC0JaWYgKHJldCA8IDApDQo+ID4g
KwlpZiAocmV0IDwgMCkgew0KPiA+ICsJCXBtX3J1bnRpbWVfcHV0X25vaWRsZShkZXYpOw0KPiA+
ICAJCXJldHVybiByZXQ7DQo+ID4gLQllbHNlDQo+ID4gKwl9IGVsc2Ugew0KPiA+ICAJCXJldCA9
IDA7DQo+ID4gKwl9DQo+ID4NCj4gPiAgCWlmIChpc19jNDUpIHsNCj4gPiAgCQlmcmFtZV9zdGFy
dCA9IEZFQ19NTUZSX1NUX0M0NTsNCj4gPiBAQCAtMjI3Niw4ICsyMjgwLDEwIEBAIHN0YXRpYyB2
b2lkIGZlY19lbmV0X2dldF9yZWdzKHN0cnVjdCBuZXRfZGV2aWNlDQo+ID4gKm5kZXYsDQo+ID4g
IAlpbnQgcmV0Ow0KPiA+DQo+ID4gIAlyZXQgPSBwbV9ydW50aW1lX2dldF9zeW5jKGRldik7DQo+
ID4gLQlpZiAocmV0IDwgMCkNCj4gPiArCWlmIChyZXQgPCAwKSB7DQo+ID4gKwkJcG1fcnVudGlt
ZV9wdXRfbm9pZGxlKGRldik7DQo+ID4gIAkJcmV0dXJuOw0KPiA+ICsJfQ0KPiA+DQo+ID4gIAly
ZWdzLT52ZXJzaW9uID0gZmVjX2VuZXRfcmVnaXN0ZXJfdmVyc2lvbjsNCj4gPg0KPiA+IEBAIC0y
OTc3LDggKzI5ODMsMTAgQEAgZmVjX2VuZXRfb3BlbihzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikN
Cj4gPiAgCWJvb2wgcmVzZXRfYWdhaW47DQo+ID4NCj4gPiAgCXJldCA9IHBtX3J1bnRpbWVfZ2V0
X3N5bmMoJmZlcC0+cGRldi0+ZGV2KTsNCj4gPiAtCWlmIChyZXQgPCAwKQ0KPiA+ICsJaWYgKHJl
dCA8IDApIHsNCj4gPiArCQlwbV9ydW50aW1lX3B1dF9ub2lkbGUoJmZlcC0+cGRldi0+ZGV2KTsN
Cj4gPiAgCQlyZXR1cm4gcmV0Ow0KPiA+ICsJfQ0KPiA+DQo+ID4gIAlwaW5jdHJsX3BtX3NlbGVj
dF9kZWZhdWx0X3N0YXRlKCZmZXAtPnBkZXYtPmRldik7DQo+ID4gIAlyZXQgPSBmZWNfZW5ldF9j
bGtfZW5hYmxlKG5kZXYsIHRydWUpOyBAQCAtMzc3MSw4ICszNzc5LDEwIEBADQo+ID4gZmVjX2Ry
dl9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gPiAgCWludCByZXQ7DQo+
ID4NCj4gPiAgCXJldCA9IHBtX3J1bnRpbWVfZ2V0X3N5bmMoJnBkZXYtPmRldik7DQo+ID4gLQlp
ZiAocmV0IDwgMCkNCj4gPiArCWlmIChyZXQgPCAwKSB7DQo+ID4gKwkJcG1fcnVudGltZV9wdXRf
bm9pZGxlKCZwZGV2LT5kZXYpOw0KPiA+ICAJCXJldHVybiByZXQ7DQo+ID4gKwl9DQo+ID4NCj4g
PiAgCWNhbmNlbF93b3JrX3N5bmMoJmZlcC0+dHhfdGltZW91dF93b3JrKTsNCj4gPiAgCWZlY19w
dHBfc3RvcChwZGV2KTsNCj4gPiAtLQ0KPiA+IDIuMjUuNA0KDQo=
