Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B112ABD73
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388119AbgKINqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:46:08 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2427 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730171AbgKINqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:46:04 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CVC1f3SNZz4yH0;
        Mon,  9 Nov 2020 21:45:42 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 9 Nov 2020 21:45:45 +0800
Received: from dggema755-chm.china.huawei.com (10.1.198.197) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 9 Nov 2020 21:45:45 +0800
Received: from dggema755-chm.china.huawei.com ([10.1.198.197]) by
 dggema755-chm.china.huawei.com ([10.1.198.197]) with mapi id 15.01.1913.007;
 Mon, 9 Nov 2020 21:45:45 +0800
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
Thread-Index: AQHWtphPrqJtWpRvSU6cZd2kwaKEi6m/yHOA//98uoCAAIaQcA==
Date:   Mon, 9 Nov 2020 13:45:45 +0000
Message-ID: <bf9325b7c3e04691a215fb16a133d536@huawei.com>
References: <20201109080938.4174745-1-zhangqilong3@huawei.com>
 <20201109080938.4174745-2-zhangqilong3@huawei.com>
 <CAJZ5v0gZp_R60FN+ZrKmEn+m0F4yjt_MB+N8uGG=fxKUnZdknQ@mail.gmail.com>
 <d05e3d35a68e41e2ac36acfcd577ad47@huawei.com>
 <CAJZ5v0hpNNAyRuQyMbOE2Lwer_uJbC0uTpnpCBpPNTv54_fxRg@mail.gmail.com>
In-Reply-To: <CAJZ5v0hpNNAyRuQyMbOE2Lwer_uJbC0uTpnpCBpPNTv54_fxRg@mail.gmail.com>
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

SGksDQoNCj4gDQo+IE9uIE1vbiwgTm92IDksIDIwMjAgYXQgMjoyNCBQTSB6aGFuZ3FpbG9uZyA8
emhhbmdxaWxvbmczQGh1YXdlaS5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gSGkNCj4gPiA+DQo+
ID4gPiBPbiBNb24sIE5vdiA5LCAyMDIwIGF0IDk6MDUgQU0gWmhhbmcgUWlsb25nDQo+ID4gPiA8
emhhbmdxaWxvbmczQGh1YXdlaS5jb20+DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4g
SW4gbWFueSBjYXNlLCB3ZSBuZWVkIHRvIGNoZWNrIHJldHVybiB2YWx1ZSBvZg0KPiA+ID4gPiBw
bV9ydW50aW1lX2dldF9zeW5jLCBidXQgaXQgYnJpbmdzIGEgdHJvdWJsZSB0byB0aGUgdXNhZ2Ug
Y291bnRlcg0KPiA+ID4gPiBwcm9jZXNzaW5nLiBNYW55IGNhbGxlcnMgZm9yZ2V0IHRvIGRlY3Jl
YXNlIHRoZSB1c2FnZSBjb3VudGVyIHdoZW4NCj4gPiA+ID4gaXQgZmFpbGVkLiBJdCBoYXMgYmVl
biBkaXNjdXNzZWQgYSBsb3RbMF1bMV0uIFNvIHdlIGFkZCBhIGZ1bmN0aW9uDQo+ID4gPiA+IHRv
IGRlYWwgd2l0aCB0aGUgdXNhZ2UgY291bnRlciBmb3IgYmV0dGVyIGNvZGluZy4NCj4gPiA+ID4N
Cj4gPiA+ID4gWzBdaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMjAvNi8xNC84OA0KPiA+ID4gPiBb
MV1odHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3Byb2plY3QvbGludXgtdGVncmEvcGF0Y2gv
MjAyMDA1MjANCj4gPiA+ID4gMDk1MSA0OC4xMDk5NS0xLWRpbmdoYW8ubGl1QHpqdS5lZHUuY24v
DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFpoYW5nIFFpbG9uZyA8emhhbmdxaWxvbmczQGh1YXdl
aS5jb20+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiAgaW5jbHVkZS9saW51eC9wbV9ydW50aW1lLmgg
fCAzMg0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gPiAgMSBmaWxl
IGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKykNCj4gPiA+ID4NCj4gPiA+ID4gZGlmZiAtLWdpdCBh
L2luY2x1ZGUvbGludXgvcG1fcnVudGltZS5oDQo+ID4gPiA+IGIvaW5jbHVkZS9saW51eC9wbV9y
dW50aW1lLmggaW5kZXggNGI3MDhmNGU4ZWVkLi4yYjBhZjViMWRmZmQNCj4gPiA+ID4gMTAwNjQ0
DQo+ID4gPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvcG1fcnVudGltZS5oDQo+ID4gPiA+ICsrKyBi
L2luY2x1ZGUvbGludXgvcG1fcnVudGltZS5oDQo+ID4gPiA+IEBAIC0zODYsNiArMzg2LDM4IEBA
IHN0YXRpYyBpbmxpbmUgaW50IHBtX3J1bnRpbWVfZ2V0X3N5bmMoc3RydWN0DQo+ID4gPiA+IGRl
dmljZQ0KPiA+ID4gKmRldikNCj4gPiA+ID4gICAgICAgICByZXR1cm4gX19wbV9ydW50aW1lX3Jl
c3VtZShkZXYsIFJQTV9HRVRfUFVUKTsgIH0NCj4gPiA+ID4NCj4gPiA+ID4gKy8qKg0KPiA+ID4g
PiArICogZ2VuZV9wbV9ydW50aW1lX2dldF9zeW5jIC0gQnVtcCB1cCB1c2FnZSBjb3VudGVyIG9m
IGEgZGV2aWNlDQo+ID4gPiA+ICthbmQNCj4gPiA+IHJlc3VtZSBpdC4NCj4gPiA+ID4gKyAqIEBk
ZXY6IFRhcmdldCBkZXZpY2UuDQo+ID4gPg0KPiA+ID4gVGhlIGZvcmNlIGFyZ3VtZW50IGlzIG5v
dCBkb2N1bWVudGVkLg0KPiA+DQo+ID4gKDEpIEdvb2QgY2F0Y2gsIEkgd2lsbCBhZGQgaXQgaW4g
bmV4dCB2ZXJzaW9uLg0KPiA+DQo+ID4gPg0KPiA+ID4gPiArICoNCj4gPiA+ID4gKyAqIEluY3Jl
YXNlIHJ1bnRpbWUgUE0gdXNhZ2UgY291bnRlciBvZiBAZGV2IGZpcnN0LCBhbmQgY2Fycnkgb3V0
DQo+ID4gPiA+ICsgcnVudGltZS1yZXN1bWUNCj4gPiA+ID4gKyAqIG9mIGl0IHN5bmNocm9ub3Vz
bHkuIElmIF9fcG1fcnVudGltZV9yZXN1bWUgcmV0dXJuIG5lZ2F0aXZlDQo+ID4gPiA+ICsgdmFs
dWUoZGV2aWNlIGlzIGluDQo+ID4gPiA+ICsgKiBlcnJvciBzdGF0ZSkgb3IgcmV0dXJuIHBvc2l0
aXZlIHZhbHVlKHRoZSBydW50aW1lIG9mIGRldmljZSBpcw0KPiA+ID4gPiArIGFscmVhZHkgYWN0
aXZlKQ0KPiA+ID4gPiArICogd2l0aCBmb3JjZSBpcyB0cnVlLCBpdCBuZWVkIGRlY3JlYXNlIHRo
ZSB1c2FnZSBjb3VudGVyIG9mIHRoZQ0KPiA+ID4gPiArIGRldmljZSB3aGVuDQo+ID4gPiA+ICsg
KiByZXR1cm4uDQo+ID4gPiA+ICsgKg0KPiA+ID4gPiArICogVGhlIHBvc3NpYmxlIHJldHVybiB2
YWx1ZXMgb2YgdGhpcyBmdW5jdGlvbiBpcyB6ZXJvIG9yIG5lZ2F0aXZlIHZhbHVlLg0KPiA+ID4g
PiArICogemVybzoNCj4gPiA+ID4gKyAqICAgIC0gaXQgbWVhbnMgc3VjY2VzcyBhbmQgdGhlIHN0
YXR1cyB3aWxsIHN0b3JlIHRoZSByZXN1bWUgb3BlcmF0aW9uDQo+ID4gPiBzdGF0dXMNCj4gPiA+
ID4gKyAqICAgICAgaWYgbmVlZGVkLCB0aGUgcnVudGltZSBQTSB1c2FnZSBjb3VudGVyIG9mIEBk
ZXYgcmVtYWlucw0KPiA+ID4gaW5jcmVtZW50ZWQuDQo+ID4gPiA+ICsgKiBuZWdhdGl2ZToNCj4g
PiA+ID4gKyAqICAgIC0gaXQgbWVhbnMgZmFpbHVyZSBhbmQgdGhlIHJ1bnRpbWUgUE0gdXNhZ2Ug
Y291bnRlciBvZiBAZGV2IGhhcw0KPiA+ID4gYmVlbg0KPiA+ID4gPiArICogICAgICBkZWNyZWFz
ZWQuDQo+ID4gPiA+ICsgKiBwb3NpdGl2ZToNCj4gPiA+ID4gKyAqICAgIC0gaXQgbWVhbnMgdGhl
IHJ1bnRpbWUgb2YgdGhlIGRldmljZSBpcyBhbHJlYWR5IGFjdGl2ZSBiZWZvcmUgdGhhdC4NCj4g
SWYNCj4gPiA+ID4gKyAqICAgICAgY2FsbGVyIHNldCBmb3JjZSB0byB0cnVlLCB3ZSBzdGlsbCBu
ZWVkIHRvIGRlY3JlYXNlIHRoZSB1c2FnZQ0KPiA+ID4gY291bnRlci4NCj4gPiA+DQo+ID4gPiBX
aHkgaXMgdGhpcyBuZWVkZWQ/DQo+ID4NCj4gPiAoMikgSWYgY2FsbGVyIHNldCBmb3JjZSwgaXQg
bWVhbnMgY2FsbGVyIHdpbGwgcmV0dXJuIGV2ZW4gdGhlIGRldmljZQ0KPiA+IGhhcyBhbHJlYWR5
IGJlZW4gYWN0aXZlIChfX3BtX3J1bnRpbWVfcmVzdW1lIHJldHVybiBwb3NpdGl2ZSB2YWx1ZSkN
Cj4gPiBhZnRlciBjYWxsaW5nIGdlbmVfcG1fcnVudGltZV9nZXRfc3luYywgd2Ugc3RpbGwgbmVl
ZCB0byBkZWNyZWFzZSB0aGUNCj4gdXNhZ2UgY291bnQuDQo+IA0KPiBCdXQgd2hvIG5lZWRzIHRo
aXM/DQo+IA0KPiBJIGRvbid0IHRoaW5rIHRoYXQgaXQgaXMgYSBnb29kIGlkZWEgdG8gY29tcGxp
Y2F0ZSB0aGUgQVBJIHRoaXMgd2F5Lg0KDQpUaGUgY2FsbGVycyBsaWtlOg0KcmV0ID0gcG1fcnVu
dGltZV9nZXRfc3luYyhkZXYpOw0KaWYgKHJldCkgew0KCS4uLg0KCXJldHVybiAoeHh4KTsNCn0N
CmRyaXZlcnMvc3BpL3NwaS1pbWctc3BmaS5jOjczNCBpbWdfc3BmaV9yZXN1bWUoKSB3YXJuOiBw
bV9ydW50aW1lX2dldF9zeW5jKCkgYWxzbyByZXR1cm5zIDEgb24gc3VjY2Vzcw0KZHJpdmVycy9t
ZmQvYXJpem9uYS1jb3JlLmM6NDkgYXJpem9uYV9jbGszMmtfZW5hYmxlKCkgd2FybjogcG1fcnVu
dGltZV9nZXRfc3luYygpIGFsc28gcmV0dXJucyAxIG9uIHN1Y2Nlc3MNCmRyaXZlcnMvdXNiL2R3
YzMvZHdjMy1wY2kuYzoyMTIgZHdjM19wY2lfcmVzdW1lX3dvcmsoKSB3YXJuOiBwbV9ydW50aW1l
X2dldF9zeW5jKCkgYWxzbyByZXR1cm5zIDEgb24gc3VjY2Vzcw0KZHJpdmVycy9pbnB1dC9rZXli
b2FyZC9vbWFwNC1rZXlwYWQuYzoyNzkgb21hcDRfa2V5cGFkX3Byb2JlKCkgd2FybjogcG1fcnVu
dGltZV9nZXRfc3luYygpIGFsc28gcmV0dXJucyAxIG9uIHN1Y2Nlc3MNCmRyaXZlcnMvZ3B1L2Ry
bS92YzQvdmM0X2RzaS5jOjgzOSB2YzRfZHNpX2VuY29kZXJfZW5hYmxlKCkgd2FybjogcG1fcnVu
dGltZV9nZXRfc3luYygpIGFsc28gcmV0dXJucyAxIG9uIHN1Y2Nlc3MNCmRyaXZlcnMvZ3B1L2Ry
bS9pOTE1L3NlbGZ0ZXN0cy9tb2NrX2dlbV9kZXZpY2UuYzoxNTcgbW9ja19nZW1fZGV2aWNlKCkg
d2FybjogJ3BtX3J1bnRpbWVfZ2V0X3N5bmMoJnBkZXYtPmRldiknIHJldHVybnMgcG9zaXRpdmUg
YW5kIG5lZ2F0aXZlDQpkcml2ZXJzL3dhdGNoZG9nL3J0aV93ZHQuYzoyMzAgcnRpX3dkdF9wcm9i
ZSgpIHdhcm46IHBtX3J1bnRpbWVfZ2V0X3N5bmMoKSBhbHNvIHJldHVybnMgMSBvbiBzdWNjZXNz
DQpkcml2ZXJzL21lZGlhL3BsYXRmb3JtL2V4eW5vczQtaXMvbWlwaS1jc2lzLmM6NTEzIHM1cGNz
aXNfc19zdHJlYW0oKSB3YXJuOiBwbV9ydW50aW1lX2dldF9zeW5jKCkgYWxzbyByZXR1cm5zIDEg
b24gc3VjY2Vzcw0KZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9tdGstdmNvZGVjL210a192Y29kZWNf
ZGVjX3BtLmM6ODkgbXRrX3Zjb2RlY19kZWNfcHdfb24oKSB3YXJuOiBwbV9ydW50aW1lX2dldF9z
eW5jKCkgYWxzbyByZXR1cm5zIDEgb24gc3VjY2Vzcw0KZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS90
aS12cGUvY2FsLmM6Nzk0IGNhbF9wcm9iZSgpIHdhcm46IHBtX3J1bnRpbWVfZ2V0X3N5bmMoKSBh
bHNvIHJldHVybnMgMSBvbiBzdWNjZXNzDQpkcml2ZXJzL21lZGlhL3BsYXRmb3JtL3RpLXZwZS92
cGUuYzoyNDc4IHZwZV9ydW50aW1lX2dldCgpIHdhcm46IHBtX3J1bnRpbWVfZ2V0X3N5bmMoKSBh
bHNvIHJldHVybnMgMSBvbiBzdWNjZXNzDQpkcml2ZXJzL21lZGlhL2kyYy9zbWlhcHAvc21pYXBw
LWNvcmUuYzoxNTI5IHNtaWFwcF9wbV9nZXRfaW5pdCgpIHdhcm46IHBtX3J1bnRpbWVfZ2V0X3N5
bmMoKSBhbHNvIHJldHVybnMgMSBvbiBzdWNjZXNzDQouLi4NCnRoZXkgbmVlZCBpdCB0byBzaW1w
bGlmeSB0aGUgZnVuY3Rpb24uDQoNCklmIHdlIG9ubHkgd2FudCB0byBzaW1wbGlmeSBsaWtlDQpy
ZXQgPSBwbV9ydW50aW1lX2dldF9zeW5jKGRldik7DQppZiAocmV0IDwgMCkgew0KCS4uLg0KCVJl
dHVybiAoeHh4KQ0KfQ0KVGhlIHBhcmFtZXRlciBmb3JjZSBjb3VsZCBiZSByZW1vdmVkLg0KDQpU
aGFua3MsDQpaaGFuZw0K
