Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419F72AC09D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbgKIQPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:15:32 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2491 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730042AbgKIQPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:15:32 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CVGKq56PqzQpth;
        Tue, 10 Nov 2020 00:14:55 +0800 (CST)
Received: from dggema708-chm.china.huawei.com (10.3.20.72) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 10 Nov 2020 00:15:01 +0800
Received: from dggema755-chm.china.huawei.com (10.1.198.197) by
 dggema708-chm.china.huawei.com (10.3.20.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 10 Nov 2020 00:15:01 +0800
Received: from dggema755-chm.china.huawei.com ([10.1.198.197]) by
 dggema755-chm.china.huawei.com ([10.1.198.197]) with mapi id 15.01.1913.007;
 Tue, 10 Nov 2020 00:15:00 +0800
From:   zhangqilong <zhangqilong3@huawei.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
CC:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjIgMS8yXSBQTTogcnVudGltZTogQWRkIGEgZ2Vu?=
 =?utf-8?B?ZXJhbCBydW50aW1lIGdldCBzeW5jIG9wZXJhdGlvbiB0byBkZWFsIHdpdGgg?=
 =?utf-8?Q?usage_counter?=
Thread-Topic: [PATCH v2 1/2] PM: runtime: Add a general runtime get sync
 operation to deal with usage counter
Thread-Index: AQHWtqv1B+TjDPAbxUWMos63Wa+mCqm/8etg//99doCAAIj1YA==
Date:   Mon, 9 Nov 2020 16:15:00 +0000
Message-ID: <446df7a9d66f4eb08f5971fba7dca1db@huawei.com>
References: <20201109150416.1877878-1-zhangqilong3@huawei.com>
 <20201109150416.1877878-2-zhangqilong3@huawei.com>
 <CAJZ5v0gGG4FeVfrFOYe1+axv78yh9vA4FAOsbLughbsQosP9-w@mail.gmail.com>
 <5acb71f82f144a35b2a5c6bcd73af5a8@huawei.com>
 <CAJZ5v0g1uzLEUA7uC8QwfFK6TU2=Ngcwcp35bfUwVg-WoTXprg@mail.gmail.com>
In-Reply-To: <CAJZ5v0g1uzLEUA7uC8QwfFK6TU2=Ngcwcp35bfUwVg-WoTXprg@mail.gmail.com>
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

SGkNCg0KPiANCj4gT24gTW9uLCBOb3YgOSwgMjAyMCBhdCA0OjUwIFBNIHpoYW5ncWlsb25nIDx6
aGFuZ3FpbG9uZzNAaHVhd2VpLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiA+IG9wZXJhdGlvbiB0
byBkZWFsIHdpdGggdXNhZ2UgY291bnRlcg0KPiA+ID4NCj4gPiA+IE9uIE1vbiwgTm92IDksIDIw
MjAgYXQgNDowMCBQTSBaaGFuZyBRaWxvbmcNCj4gPiA+IDx6aGFuZ3FpbG9uZzNAaHVhd2VpLmNv
bT4NCj4gPiA+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBJbiBtYW55IGNhc2UsIHdlIG5lZWQg
dG8gY2hlY2sgcmV0dXJuIHZhbHVlIG9mDQo+ID4gPiA+IHBtX3J1bnRpbWVfZ2V0X3N5bmMsIGJ1
dCBpdCBicmluZ3MgYSB0cm91YmxlIHRvIHRoZSB1c2FnZSBjb3VudGVyDQo+ID4gPiA+IHByb2Nl
c3NpbmcuIE1hbnkgY2FsbGVycyBmb3JnZXQgdG8gZGVjcmVhc2UgdGhlIHVzYWdlIGNvdW50ZXIg
d2hlbg0KPiA+ID4gPiBpdCBmYWlsZWQuIEl0IGhhcyBiZWVuIGRpc2N1c3NlZCBhIGxvdFswXVsx
XS4gU28gd2UgYWRkIGEgZnVuY3Rpb24NCj4gPiA+ID4gdG8gZGVhbCB3aXRoIHRoZSB1c2FnZSBj
b3VudGVyIGZvciBiZXR0ZXIgY29kaW5nLg0KPiA+ID4gPg0KPiA+ID4gPiBbMF1odHRwczovL2xr
bWwub3JnL2xrbWwvMjAyMC82LzE0Lzg4DQo+ID4gPiA+IFsxXWh0dHBzOi8vcGF0Y2h3b3JrLm96
bGFicy5vcmcvcHJvamVjdC9saW51eC10ZWdyYS9wYXRjaC8yMDIwMDUyMA0KPiA+ID4gPiAwOTUx
IDQ4LjEwOTk1LTEtZGluZ2hhby5saXVAemp1LmVkdS5jbi8NCj4gPiA+ID4gU2lnbmVkLW9mZi1i
eTogWmhhbmcgUWlsb25nIDx6aGFuZ3FpbG9uZzNAaHVhd2VpLmNvbT4NCj4gPiA+ID4gLS0tDQo+
ID4gPiA+ICBpbmNsdWRlL2xpbnV4L3BtX3J1bnRpbWUuaCB8IDMwICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKw0KPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKykN
Cj4gPiA+ID4NCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcG1fcnVudGltZS5o
DQo+ID4gPiA+IGIvaW5jbHVkZS9saW51eC9wbV9ydW50aW1lLmggaW5kZXggNGI3MDhmNGU4ZWVk
Li42NTQ5Y2U3NjQ0MDANCj4gPiA+ID4gMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2luY2x1ZGUvbGlu
dXgvcG1fcnVudGltZS5oDQo+ID4gPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvcG1fcnVudGltZS5o
DQo+ID4gPiA+IEBAIC0zODYsNiArMzg2LDM2IEBAIHN0YXRpYyBpbmxpbmUgaW50IHBtX3J1bnRp
bWVfZ2V0X3N5bmMoc3RydWN0DQo+ID4gPiA+IGRldmljZQ0KPiA+ID4gKmRldikNCj4gPiA+ID4g
ICAgICAgICByZXR1cm4gX19wbV9ydW50aW1lX3Jlc3VtZShkZXYsIFJQTV9HRVRfUFVUKTsgIH0N
Cj4gPiA+ID4NCj4gPiA+ID4gKy8qKg0KPiA+ID4gPiArICogcG1fcnVudGltZV9nZW5lcmFsX2dl
dCAtIEJ1bXAgdXAgdXNhZ2UgY291bnRlciBvZiBhIGRldmljZSBhbmQNCj4gPiA+IHJlc3VtZSBp
dC4NCj4gPiA+ID4gKyAqIEBkZXY6IFRhcmdldCBkZXZpY2UuDQo+ID4gPiA+ICsgKg0KPiA+ID4g
PiArICogSW5jcmVhc2UgcnVudGltZSBQTSB1c2FnZSBjb3VudGVyIG9mIEBkZXYgZmlyc3QsIGFu
ZCBjYXJyeSBvdXQNCj4gPiA+ID4gK3J1bnRpbWUtcmVzdW1lDQo+ID4gPiA+ICsgKiBvZiBpdCBz
eW5jaHJvbm91c2x5LiBJZiBfX3BtX3J1bnRpbWVfcmVzdW1lIHJldHVybiBuZWdhdGl2ZQ0KPiA+
ID4gPiArdmFsdWUoZGV2aWNlIGlzIGluDQo+ID4gPiA+ICsgKiBlcnJvciBzdGF0ZSksIHdlIHRv
IG5lZWQgZGVjcmVhc2UgdGhlIHVzYWdlIGNvdW50ZXIgYmVmb3JlIGl0DQo+ID4gPiA+ICtyZXR1
cm4uIElmDQo+ID4gPiA+ICsgKiBfX3BtX3J1bnRpbWVfcmVzdW1lIHJldHVybiBwb3NpdGl2ZSB2
YWx1ZSwgaXQgbWVhbnMgdGhlDQo+ID4gPiA+ICtydW50aW1lIG9mIGRldmljZSBoYXMNCj4gPiA+
ID4gKyAqIGFscmVhZHkgYmVlbiBpbiBhY3RpdmUgc3RhdGUsIGFuZCB3ZSBsZXQgdGhlIG5ldyB3
cmFwcGVyDQo+ID4gPiA+ICtyZXR1cm4gemVybw0KPiA+ID4gaW5zdGVhZC4NCj4gPiA+ID4gKyAq
DQo+ID4gPiA+ICsgKiBUaGUgcG9zc2libGUgcmV0dXJuIHZhbHVlcyBvZiB0aGlzIGZ1bmN0aW9u
IGlzIHplcm8gb3IgbmVnYXRpdmUgdmFsdWUuDQo+ID4gPiA+ICsgKiB6ZXJvOg0KPiA+ID4gPiAr
ICogICAgLSBpdCBtZWFucyByZXN1bWUgc3VjY2VlZWQgb3IgcnVudGltZSBvZiBkZXZpY2UgaGFz
IGFscmVhZHkgYmVlbg0KPiA+ID4gYWN0aXZlLCB0aGUNCj4gPiA+ID4gKyAqICAgICAgcnVudGlt
ZSBQTSB1c2FnZSBjb3VudGVyIG9mIEBkZXYgcmVtYWlucyBpbmNyZW1lbnRlZC4NCj4gPiA+ID4g
KyAqIG5lZ2F0aXZlOg0KPiA+ID4gPiArICogICAgLSBpdCBtZWFucyBmYWlsdXJlIGFuZCB0aGUg
cnVudGltZSBQTSB1c2FnZSBjb3VudGVyIG9mIEBkZXYgaGFzDQo+ID4gPiBiZWVuIGJhbGFuY2Vk
Lg0KPiA+ID4NCj4gPiA+IFRoZSBrZXJuZWxkb2MgYWJvdmUgaXMga2luZCBvZiBub2lzeSBhbmQg
aXQgaXMgaGFyZCB0byBmaWd1cmUgb3V0DQo+ID4gPiB3aGF0IHRoZSBoZWxwZXIgcmVhbGx5IGRv
ZXMgZnJvbSBpdC4NCj4gPiA+DQo+ID4gPiBZb3UgY291bGQgYmFzaWNhbGx5IHNheSBzb21ldGhp
bmcgbGlrZSAiUmVzdW1lIEBkZXYgc3luY2hyb25vdXNseQ0KPiA+ID4gYW5kIGlmIHRoYXQgaXMg
c3VjY2Vzc2Z1bCwgaW5jcmVtZW50IGl0cyBydW50aW1lIFBNIHVzYWdlIGNvdW50ZXIuDQo+ID4g
PiBSZXR1cm4NCj4gPiA+IDAgaWYgdGhlIHJ1bnRpbWUgUE0gdXNhZ2UgY291bnRlciBvZiBAZGV2
IGhhcyBiZWVuIGluY3JlbWVudGVkIG9yIGENCj4gPiA+IG5lZ2F0aXZlIGVycm9yIGNvZGUgb3Ro
ZXJ3aXNlLiINCj4gPiA+DQo+ID4NCj4gPiBIb3cgYWJvdXQgdGhlIGZvbGxvd2luZyBkZXNjcmlw
dGlvbi4NCj4gPiAvKioNCj4gPiAzOTAgICogcG1fcnVudGltZV9nZW5lcmFsX2dldCAtIEJ1bXAg
dXAgdXNhZ2UgY291bnRlciBvZiBhIGRldmljZSBhbmQNCj4gcmVzdW1lIGl0Lg0KPiA+IDM5MSAg
KiBAZGV2OiBUYXJnZXQgZGV2aWNlLg0KPiA+IDM5MiAgKg0KPiA+IDM5MyAgKiBJbmNyZWFzZSBy
dW50aW1lIFBNIHVzYWdlIGNvdW50ZXIgb2YgQGRldiBmaXJzdCwgYW5kIGNhcnJ5IG91dA0KPiA+
IHJ1bnRpbWUtcmVzdW1lDQo+ID4gMzk0ICAqIG9mIGl0IHN5bmNocm9ub3VzbHkuIElmIF9fcG1f
cnVudGltZV9yZXN1bWUgcmV0dXJuIG5lZ2F0aXZlDQo+ID4gdmFsdWUoZGV2aWNlIGlzIGluDQo+
ID4gMzk1ICAqIGVycm9yIHN0YXRlKSwgd2UgdG8gbmVlZCBkZWNyZWFzZSB0aGUgdXNhZ2UgY291
bnRlciBiZWZvcmUgaXQNCj4gPiByZXR1cm4uIElmDQo+ID4gMzk2ICAqIF9fcG1fcnVudGltZV9y
ZXN1bWUgcmV0dXJuIHBvc2l0aXZlIHZhbHVlLCBpdCBtZWFucyB0aGUgcnVudGltZQ0KPiA+IG9m
IGRldmljZSBoYXMNCj4gPiAzOTcgICogYWxyZWFkeSBiZWVuIGluIGFjdGl2ZSBzdGF0ZSwgYW5k
IHdlIGxldCB0aGUgbmV3IHdyYXBwZXIgcmV0dXJuIHplcm8NCj4gaW5zdGVhZC4NCj4gPiAzOTgg
ICoNCj4gDQo+IElmIHlvdSBhZGQgdGhlIHBhcmFncmFwaCBiZWxvdywgdGhlIG9uZSBhYm92ZSBi
ZWNvbWVzIHJlZHVuZGFudCBJTVYuDQo+IA0KPiA+IDM5OSAgKiBSZXN1bWUgQGRldiBzeW5jaHJv
bm91c2x5IGFuZCBpZiB0aGF0IGlzIHN1Y2Nlc3NmdWwsIGFuZA0KPiA+IGluY3JlbWVudCBpdHMg
cnVudGltZQ0KPiANCj4gIlJlc3VtZSBAZGV2IHN5bmNocm9ub3VzbHkgYW5kIGlmIHRoYXQgaXMg
c3VjY2Vzc2Z1bCwgaW5jcmVtZW50IGl0cyBydW50aW1lIg0KPiANCj4gKGRyb3AgdGhlIGV4dHJh
ICJhbmQiKS4NCj4gDQo+ID4gNDAwICAqIFBNIHVzYWdlIGNvdW50ZXIgaWYgaXQgdHVybiBvdXQg
dG8gZXF1YWwgdG8gMC4gVGhlIHJ1bnRpbWUgUE0NCj4gPiB1c2FnZSBjb3VudGVyIG9mDQo+IA0K
PiBUaGUgImlmIGl0IHR1cm4gb3V0IHRvIGVxdWFsIHRvIDAiIHBocmFzZSBpcyByZWR1bmRhbnQg
KGFuZCB0aGUgZ3JhbW1hciBpbiBpdCBpcw0KPiBpbmNvcnJlY3QpLg0KPiANCj4gPiA0MDEgICog
QGRldiBoYXMgYmVlbiBpbmNyZW1lbnRlZCBvciBhIG5lZ2F0aXZlIGVycm9yIGNvZGUgb3RoZXJ3
aXNlLg0KPiA+IDQwMiAgKi8NCj4gDQo+IFdoeSBkb24ndCB5b3UgdXNlIHdoYXQgSSBzYWlkIHZl
cmJhdGltPw0KDQpJIGhhZCBtaXN1bmRlcnN0YW5kIGp1c3Qgbm93LCBzb3JyeSBmb3IgdGhhdC4g
VGhlIGRlc2NyaXB0aW9uIGlzIGFzIGZvbGxvd3M6DQozODkgLyoqDQozOTAgICogcG1fcnVudGlt
ZV9yZXN1bWVfYW5kX2dldCAtIEJ1bXAgdXAgdXNhZ2UgY291bnRlciBvZiBhIGRldmljZSBhbmQg
cmVzdW1lIGl0Lg0KMzkxICAqIEBkZXY6IFRhcmdldCBkZXZpY2UuDQozOTIgICoNCjM5MyAgKiBS
ZXN1bWUgQGRldiBzeW5jaHJvbm91c2x5IGlmIHRoYXQgaXMgc3VjY2Vzc2Z1bCwgaW5jcmVtZW50
IGl0cyBydW50aW1lIFBNDQozOTQgICogdXNhZ2UgY291bnRlci4gIFJldHVybiAwIGlmIHRoZSBy
dW50aW1lIFBNIHVzYWdlIGNvdW50ZXIgb2YgQGRldiBoYXMgYmVlbg0KMzk1ICAqIGluY3JlbWVu
dGVkIG9yIGEgbmVnYXRpdmUgZXJyb3IgY29kZSBvdGhlcndpc2UuDQozOTYgICovDQoNCkRvIHlv
dSB0aGluayBpdCdzIE9LPw0KDQpUaGFua3MsDQpaaGFuZw0K
