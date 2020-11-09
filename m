Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554882AC03D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgKIPu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:50:26 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2305 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIPuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:50:25 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4CVFn92d1Mz13RL5;
        Mon,  9 Nov 2020 23:50:05 +0800 (CST)
Received: from dggema756-chm.china.huawei.com (10.1.198.198) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 9 Nov 2020 23:50:20 +0800
Received: from dggema755-chm.china.huawei.com (10.1.198.197) by
 dggema756-chm.china.huawei.com (10.1.198.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 9 Nov 2020 23:50:20 +0800
Received: from dggema755-chm.china.huawei.com ([10.1.198.197]) by
 dggema755-chm.china.huawei.com ([10.1.198.197]) with mapi id 15.01.1913.007;
 Mon, 9 Nov 2020 23:50:19 +0800
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
Thread-Index: AQHWtqv1B+TjDPAbxUWMos63Wa+mCqm/8etg
Date:   Mon, 9 Nov 2020 15:50:19 +0000
Message-ID: <5acb71f82f144a35b2a5c6bcd73af5a8@huawei.com>
References: <20201109150416.1877878-1-zhangqilong3@huawei.com>
 <20201109150416.1877878-2-zhangqilong3@huawei.com>
 <CAJZ5v0gGG4FeVfrFOYe1+axv78yh9vA4FAOsbLughbsQosP9-w@mail.gmail.com>
In-Reply-To: <CAJZ5v0gGG4FeVfrFOYe1+axv78yh9vA4FAOsbLughbsQosP9-w@mail.gmail.com>
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

PiBvcGVyYXRpb24gdG8gZGVhbCB3aXRoIHVzYWdlIGNvdW50ZXINCj4gDQo+IE9uIE1vbiwgTm92
IDksIDIwMjAgYXQgNDowMCBQTSBaaGFuZyBRaWxvbmcgPHpoYW5ncWlsb25nM0BodWF3ZWkuY29t
Pg0KPiB3cm90ZToNCj4gPg0KPiA+IEluIG1hbnkgY2FzZSwgd2UgbmVlZCB0byBjaGVjayByZXR1
cm4gdmFsdWUgb2YgcG1fcnVudGltZV9nZXRfc3luYywNCj4gPiBidXQgaXQgYnJpbmdzIGEgdHJv
dWJsZSB0byB0aGUgdXNhZ2UgY291bnRlciBwcm9jZXNzaW5nLiBNYW55IGNhbGxlcnMNCj4gPiBm
b3JnZXQgdG8gZGVjcmVhc2UgdGhlIHVzYWdlIGNvdW50ZXIgd2hlbiBpdCBmYWlsZWQuIEl0IGhh
cyBiZWVuDQo+ID4gZGlzY3Vzc2VkIGEgbG90WzBdWzFdLiBTbyB3ZSBhZGQgYSBmdW5jdGlvbiB0
byBkZWFsIHdpdGggdGhlIHVzYWdlDQo+ID4gY291bnRlciBmb3IgYmV0dGVyIGNvZGluZy4NCj4g
Pg0KPiA+IFswXWh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDIwLzYvMTQvODgNCj4gPiBbMV1odHRw
czovL3BhdGNod29yay5vemxhYnMub3JnL3Byb2plY3QvbGludXgtdGVncmEvcGF0Y2gvMjAyMDA1
MjAwOTUxDQo+ID4gNDguMTA5OTUtMS1kaW5naGFvLmxpdUB6anUuZWR1LmNuLw0KPiA+IFNpZ25l
ZC1vZmYtYnk6IFpoYW5nIFFpbG9uZyA8emhhbmdxaWxvbmczQGh1YXdlaS5jb20+DQo+ID4gLS0t
DQo+ID4gIGluY2x1ZGUvbGludXgvcG1fcnVudGltZS5oIHwgMzAgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCspDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9wbV9ydW50aW1lLmggYi9pbmNsdWRlL2xp
bnV4L3BtX3J1bnRpbWUuaA0KPiA+IGluZGV4IDRiNzA4ZjRlOGVlZC4uNjU0OWNlNzY0NDAwIDEw
MDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvcG1fcnVudGltZS5oDQo+ID4gKysrIGIvaW5j
bHVkZS9saW51eC9wbV9ydW50aW1lLmgNCj4gPiBAQCAtMzg2LDYgKzM4NiwzNiBAQCBzdGF0aWMg
aW5saW5lIGludCBwbV9ydW50aW1lX2dldF9zeW5jKHN0cnVjdCBkZXZpY2UNCj4gKmRldikNCj4g
PiAgICAgICAgIHJldHVybiBfX3BtX3J1bnRpbWVfcmVzdW1lKGRldiwgUlBNX0dFVF9QVVQpOyAg
fQ0KPiA+DQo+ID4gKy8qKg0KPiA+ICsgKiBwbV9ydW50aW1lX2dlbmVyYWxfZ2V0IC0gQnVtcCB1
cCB1c2FnZSBjb3VudGVyIG9mIGEgZGV2aWNlIGFuZA0KPiByZXN1bWUgaXQuDQo+ID4gKyAqIEBk
ZXY6IFRhcmdldCBkZXZpY2UuDQo+ID4gKyAqDQo+ID4gKyAqIEluY3JlYXNlIHJ1bnRpbWUgUE0g
dXNhZ2UgY291bnRlciBvZiBAZGV2IGZpcnN0LCBhbmQgY2Fycnkgb3V0DQo+ID4gK3J1bnRpbWUt
cmVzdW1lDQo+ID4gKyAqIG9mIGl0IHN5bmNocm9ub3VzbHkuIElmIF9fcG1fcnVudGltZV9yZXN1
bWUgcmV0dXJuIG5lZ2F0aXZlDQo+ID4gK3ZhbHVlKGRldmljZSBpcyBpbg0KPiA+ICsgKiBlcnJv
ciBzdGF0ZSksIHdlIHRvIG5lZWQgZGVjcmVhc2UgdGhlIHVzYWdlIGNvdW50ZXIgYmVmb3JlIGl0
DQo+ID4gK3JldHVybi4gSWYNCj4gPiArICogX19wbV9ydW50aW1lX3Jlc3VtZSByZXR1cm4gcG9z
aXRpdmUgdmFsdWUsIGl0IG1lYW5zIHRoZSBydW50aW1lIG9mDQo+ID4gK2RldmljZSBoYXMNCj4g
PiArICogYWxyZWFkeSBiZWVuIGluIGFjdGl2ZSBzdGF0ZSwgYW5kIHdlIGxldCB0aGUgbmV3IHdy
YXBwZXIgcmV0dXJuIHplcm8NCj4gaW5zdGVhZC4NCj4gPiArICoNCj4gPiArICogVGhlIHBvc3Np
YmxlIHJldHVybiB2YWx1ZXMgb2YgdGhpcyBmdW5jdGlvbiBpcyB6ZXJvIG9yIG5lZ2F0aXZlIHZh
bHVlLg0KPiA+ICsgKiB6ZXJvOg0KPiA+ICsgKiAgICAtIGl0IG1lYW5zIHJlc3VtZSBzdWNjZWVl
ZCBvciBydW50aW1lIG9mIGRldmljZSBoYXMgYWxyZWFkeSBiZWVuDQo+IGFjdGl2ZSwgdGhlDQo+
ID4gKyAqICAgICAgcnVudGltZSBQTSB1c2FnZSBjb3VudGVyIG9mIEBkZXYgcmVtYWlucyBpbmNy
ZW1lbnRlZC4NCj4gPiArICogbmVnYXRpdmU6DQo+ID4gKyAqICAgIC0gaXQgbWVhbnMgZmFpbHVy
ZSBhbmQgdGhlIHJ1bnRpbWUgUE0gdXNhZ2UgY291bnRlciBvZiBAZGV2IGhhcw0KPiBiZWVuIGJh
bGFuY2VkLg0KPiANCj4gVGhlIGtlcm5lbGRvYyBhYm92ZSBpcyBraW5kIG9mIG5vaXN5IGFuZCBp
dCBpcyBoYXJkIHRvIGZpZ3VyZSBvdXQgd2hhdCB0aGUgaGVscGVyDQo+IHJlYWxseSBkb2VzIGZy
b20gaXQuDQo+IA0KPiBZb3UgY291bGQgYmFzaWNhbGx5IHNheSBzb21ldGhpbmcgbGlrZSAiUmVz
dW1lIEBkZXYgc3luY2hyb25vdXNseSBhbmQgaWYgdGhhdA0KPiBpcyBzdWNjZXNzZnVsLCBpbmNy
ZW1lbnQgaXRzIHJ1bnRpbWUgUE0gdXNhZ2UgY291bnRlci4gIFJldHVybg0KPiAwIGlmIHRoZSBy
dW50aW1lIFBNIHVzYWdlIGNvdW50ZXIgb2YgQGRldiBoYXMgYmVlbiBpbmNyZW1lbnRlZCBvciBh
IG5lZ2F0aXZlDQo+IGVycm9yIGNvZGUgb3RoZXJ3aXNlLiINCj4gDQoNCkhvdyBhYm91dCB0aGUg
Zm9sbG93aW5nIGRlc2NyaXB0aW9uLg0KLyoqDQozOTAgICogcG1fcnVudGltZV9nZW5lcmFsX2dl
dCAtIEJ1bXAgdXAgdXNhZ2UgY291bnRlciBvZiBhIGRldmljZSBhbmQgcmVzdW1lIGl0Lg0KMzkx
ICAqIEBkZXY6IFRhcmdldCBkZXZpY2UuDQozOTIgICoNCjM5MyAgKiBJbmNyZWFzZSBydW50aW1l
IFBNIHVzYWdlIGNvdW50ZXIgb2YgQGRldiBmaXJzdCwgYW5kIGNhcnJ5IG91dCBydW50aW1lLXJl
c3VtZQ0KMzk0ICAqIG9mIGl0IHN5bmNocm9ub3VzbHkuIElmIF9fcG1fcnVudGltZV9yZXN1bWUg
cmV0dXJuIG5lZ2F0aXZlIHZhbHVlKGRldmljZSBpcyBpbg0KMzk1ICAqIGVycm9yIHN0YXRlKSwg
d2UgdG8gbmVlZCBkZWNyZWFzZSB0aGUgdXNhZ2UgY291bnRlciBiZWZvcmUgaXQgcmV0dXJuLiBJ
Zg0KMzk2ICAqIF9fcG1fcnVudGltZV9yZXN1bWUgcmV0dXJuIHBvc2l0aXZlIHZhbHVlLCBpdCBt
ZWFucyB0aGUgcnVudGltZSBvZiBkZXZpY2UgaGFzDQozOTcgICogYWxyZWFkeSBiZWVuIGluIGFj
dGl2ZSBzdGF0ZSwgYW5kIHdlIGxldCB0aGUgbmV3IHdyYXBwZXIgcmV0dXJuIHplcm8gaW5zdGVh
ZC4NCjM5OCAgKg0KMzk5ICAqIFJlc3VtZSBAZGV2IHN5bmNocm9ub3VzbHkgYW5kIGlmIHRoYXQg
aXMgc3VjY2Vzc2Z1bCwgYW5kIGluY3JlbWVudCBpdHMgcnVudGltZQ0KNDAwICAqIFBNIHVzYWdl
IGNvdW50ZXIgaWYgaXQgdHVybiBvdXQgdG8gZXF1YWwgdG8gMC4gVGhlIHJ1bnRpbWUgUE0gdXNh
Z2UgY291bnRlciBvZg0KNDAxICAqIEBkZXYgaGFzIGJlZW4gaW5jcmVtZW50ZWQgb3IgYSBuZWdh
dGl2ZSBlcnJvciBjb2RlIG90aGVyd2lzZS4NCjQwMiAgKi8NCg0KVGhhbmtzLA0KWmhhbmcNCg0K
PiA+ICsgKi8NCj4gPiArc3RhdGljIGlubGluZSBpbnQgcG1fcnVudGltZV9nZW5lcmFsX2dldChz
dHJ1Y3QgZGV2aWNlICpkZXYpDQo+IA0KPiBXaGF0IGFib3V0IHBtX3J1bnRpbWVfcmVzdW1lX2Fu
ZF9nZXQoKT8NCj4gDQoNCkkgdGhpbmsgaXQncyBPSy4NCg0KPiA+ICt7DQo+ID4gKyAgICAgICBp
bnQgcmV0ID0gMDsNCj4gDQo+IFRoaXMgZXh0cmEgaW5pdGlhbGl6YXRpb24gaXMgbm90IG5lY2Vz
c2FyeS4NCj4gDQo+IFlvdSBjYW4gaW5pdGlhbGl6ZSByZXQgdG8gdGhlIF9fcG1fcnVudGltZV9y
ZXN1bWUoKSByZXR1cm4gdmFsdWUgcmlnaHQgYXdheS4NCj4gDQoNCk9LLCBnb29kIGlkZWEuDQoN
Cj4gPiArDQo+ID4gKyAgICAgICByZXQgPSBfX3BtX3J1bnRpbWVfcmVzdW1lKGRldiwgUlBNX0dF
VF9QVVQpOw0KPiA+ICsgICAgICAgaWYgKHJldCA8IDApIHsNCj4gPiArICAgICAgICAgICAgICAg
cG1fcnVudGltZV9wdXRfbm9pZGxlKGRldik7DQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBy
ZXQ7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgcmV0dXJuIDA7DQo+ID4gK30N
Cj4gPiArDQo+ID4gIC8qKg0KPiA+ICAgKiBwbV9ydW50aW1lX3B1dCAtIERyb3AgZGV2aWNlIHVz
YWdlIGNvdW50ZXIgYW5kIHF1ZXVlIHVwICJpZGxlIGNoZWNrIg0KPiBpZiAwLg0KPiA+ICAgKiBA
ZGV2OiBUYXJnZXQgZGV2aWNlLg0KPiA+IC0tDQo=
