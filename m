Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E602120379
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 12:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfLPLOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 06:14:41 -0500
Received: from mx24.baidu.com ([111.206.215.185]:43474 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727086AbfLPLOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 06:14:39 -0500
X-Greylist: delayed 990 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2019 06:14:35 EST
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 564AF822F6FF138C1EBE;
        Mon, 16 Dec 2019 18:57:56 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Mon, 16 Dec 2019 18:57:56 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Mon, 16 Dec 2019 18:57:56 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF1bdjJdIHBhZ2VfcG9vbDogaGFuZGxl?=
 =?utf-8?B?IHBhZ2UgcmVjeWNsZSBmb3IgTlVNQV9OT19OT0RFIGNvbmRpdGlvbg==?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBwYWdlX3Bvb2w6IGhhbmRsZSBwYWdlIHJl?=
 =?utf-8?B?Y3ljbGUgZm9yIE5VTUFfTk9fTk9ERSBjb25kaXRpb24=?=
Thread-Index: AQHVsZIrr0J3dgd4XE+VTzKxYVWGCKe7fWqAgACmZRD//+X1AIAAAL8AgACP7CA=
Date:   Mon, 16 Dec 2019 10:57:56 +0000
Message-ID: <718ac129c8584066ba12f4538c5bad41@baidu.com>
References: <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191212111831.2a9f05d3@carbon>
 <7c555cb1-6beb-240d-08f8-7044b9087fe4@huawei.com>
 <1d4f10f4c0f1433bae658df8972a904f@baidu.com>
 <079a0315-efea-9221-8538-47decf263684@huawei.com>
 <20191213094845.56fb42a4@carbon>
 <15be326d-1811-329c-424c-6dd22b0604a8@huawei.com>
 <a5dea60221d84886991168781361b591@baidu.com>
 <20191216101350.GA6939@apalos.home> <20191216101630.GA7102@apalos.home>
In-Reply-To: <20191216101630.GA7102@apalos.home>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.6]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex14_2019-12-16 18:57:56:366
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex14_GRAY_Inside_WithoutAtta_2019-12-16
 18:57:56:335
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IElsaWFzIEFwYWxvZGlt
YXMgW21haWx0bzppbGlhcy5hcGFsb2RpbWFzQGxpbmFyby5vcmddDQo+IOWPkemAgeaXtumXtDog
MjAxOeW5tDEy5pyIMTbml6UgMTg6MTcNCj4g5pS25Lu25Lq6OiBMaSxSb25ncWluZyA8bGlyb25n
cWluZ0BiYWlkdS5jb20+DQo+IOaKhOmAgTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3
ZWkuY29tPjsgSmVzcGVyIERhbmdhYXJkIEJyb3Vlcg0KPiA8YnJvdWVyQHJlZGhhdC5jb20+OyBT
YWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT47DQo+IGpvbmF0aGFuLmxlbW9uQGdt
YWlsLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbWhvY2tvQGtlcm5lbC5vcmc7DQo+IHBl
dGVyekBpbmZyYWRlYWQub3JnOyBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5k
YXRpb24ub3JnPjsNCj4gYmhlbGdhYXNAZ29vZ2xlLmNvbTsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZzsgQmrDtnJuIFTDtnBlbA0KPiA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiDkuLvp
opg6IFJlOiDnrZTlpI06IFtQQVRDSF1bdjJdIHBhZ2VfcG9vbDogaGFuZGxlIHBhZ2UgcmVjeWNs
ZSBmb3INCj4gTlVNQV9OT19OT0RFIGNvbmRpdGlvbg0KPiANCj4gPiA+ID4NCj4gPiA+ID4gU2lt
cGx5IGNsZWFyaW5nIHRoZSBwb29sLT5hbGxvYy5jYWNoZSB3aGVuIGNhbGxpbmcNCj4gPiA+ID4g
cGFnZV9wb29sX3VwZGF0ZV9uaWQoKSBzZWVtcyBiZXR0ZXIuDQo+ID4gPiA+DQo+ID4gPg0KPiA+
ID4gSG93IGFib3V0IHRoZSBiZWxvdyBjb2RlcywgdGhlIGRyaXZlciBjYW4gY29uZmlndXJlIHAu
bmlkIHRvIGFueSwgd2hpY2ggd2lsbA0KPiBiZSBhZGp1c3RlZCBpbiBOQVBJIHBvbGxpbmcsIGly
cSBtaWdyYXRpb24gd2lsbCBub3QgYmUgcHJvYmxlbSwgYnV0IGl0IHdpbGwgYWRkIGENCj4gY2hl
Y2sgaW50byBob3QgcGF0aC4NCj4gPg0KPiA+IFdlJ2xsIGhhdmUgdG8gY2hlY2sgdGhlIGltcGFj
dCBvbiBzb21lIGhpZ2ggc3BlZWQgKGkuZSAxMDBnYml0KQ0KPiA+IGludGVyZmFjZSBiZXR3ZWVu
IGRvaW5nIGFueXRoaW5nIGxpa2UgdGhhdC4gU2FlZWQncyBjdXJyZW50IHBhdGNoIHJ1bnMNCj4g
PiBvbmNlIHBlciBOQVBJLiBUaGlzIHJ1bnMgb25jZSBwZXIgcGFja2V0LiBUaGUgbG9hZCBtaWdo
dCBiZSBtZWFzdXJhYmxlLg0KPiA+IFRoZSBSRUFEX09OQ0UgaXMgbmVlZGVkIGluIGNhc2UgYWxs
IHByb2R1Y2Vycy9jb25zdW1lcnMgcnVuIG9uIHRoZQ0KPiA+IHNhbWUgQ1BVDQo+IA0KPiBJIG1l
YW50IGRpZmZlcmVudCBjcHVzIQ0KPiANCg0KSWYgbm8gUkVBRF9PTkNFLCBwb29sLT5wLm5pZCB3
aWxsIGJlIGFsd2F5cyB3cml0dGVuIGFuZCBiZWNvbWUgZGlydHkgYWx0aG91Z2ggaXQgaXMgdW5z
aGFyZWQgYnkgbXVsdGlwbGUgY3B1cw0KDQpTZWUgRXJpYycgcGF0Y2g6DQoNCmh0dHBzOi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9j
b21taXQvP2lkPTUwMzk3OGFjYTQ2MTI0Y2Q3MTQ3MDNlMTgwYjljODI5MmJhNTBiYTcNCg0KLUxp
IA0KPiA+IHJpZ2h0Pw0KPiA+DQo+ID4NCj4gPiBUaGFua3MNCj4gPiAvSWxpYXMNCj4gPiA+DQo+
ID4gPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvcGFnZV9wb29sLmMgYi9uZXQvY29yZS9wYWdlX3Bv
b2wuYyBpbmRleA0KPiA+ID4gYTZhZWZlOTg5MDQzLi40Mzc0YTYyMzlkMTcgMTAwNjQ0DQo+ID4g
PiAtLS0gYS9uZXQvY29yZS9wYWdlX3Bvb2wuYw0KPiA+ID4gKysrIGIvbmV0L2NvcmUvcGFnZV9w
b29sLmMNCj4gPiA+IEBAIC0xMDgsNiArMTA4LDEwIEBAIHN0YXRpYyBzdHJ1Y3QgcGFnZQ0KPiAq
X19wYWdlX3Bvb2xfZ2V0X2NhY2hlZChzdHJ1Y3QgcGFnZV9wb29sICpwb29sKQ0KPiA+ID4gICAg
ICAgICAgICAgICAgIGlmIChsaWtlbHkocG9vbC0+YWxsb2MuY291bnQpKSB7DQo+ID4gPiAgICAg
ICAgICAgICAgICAgICAgICAgICAvKiBGYXN0LXBhdGggKi8NCj4gPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgIHBhZ2UgPQ0KPiA+ID4gcG9vbC0+YWxsb2MuY2FjaGVbLS1wb29sLT5hbGxvYy5j
b3VudF07DQo+ID4gPiArDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICBpZiAodW5saWtl
bHkoUkVBRF9PTkNFKHBvb2wtPnAubmlkKSAhPQ0KPiBudW1hX21lbV9pZCgpKSkNCj4gPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgV1JJVEVfT05DRShwb29sLT5wLm5pZCwNCj4g
PiA+ICsgbnVtYV9tZW1faWQoKSk7DQo+ID4gPiArDQo+ID4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICByZXR1cm4gcGFnZTsNCj4gPiA+ICAgICAgICAgICAgICAgICB9DQo+ID4gPiAgICAgICAg
ICAgICAgICAgcmVmaWxsID0gdHJ1ZTsNCj4gPiA+IEBAIC0xNTUsNiArMTU5LDEwIEBAIHN0YXRp
YyBzdHJ1Y3QgcGFnZQ0KPiAqX19wYWdlX3Bvb2xfYWxsb2NfcGFnZXNfc2xvdyhzdHJ1Y3QgcGFn
ZV9wb29sICpwb29sLA0KPiA+ID4gICAgICAgICBpZiAocG9vbC0+cC5vcmRlcikNCj4gPiA+ICAg
ICAgICAgICAgICAgICBnZnAgfD0gX19HRlBfQ09NUDsNCj4gPiA+DQo+ID4gPiArDQo+ID4gPiAr
ICAgICAgIGlmICh1bmxpa2VseShSRUFEX09OQ0UocG9vbC0+cC5uaWQpICE9IG51bWFfbWVtX2lk
KCkpKQ0KPiA+ID4gKyAgICAgICAgICAgICAgIFdSSVRFX09OQ0UocG9vbC0+cC5uaWQsIG51bWFf
bWVtX2lkKCkpOw0KPiA+ID4gKw0KPiA+ID4gICAgICAgICAvKiBGVVRVUkUgZGV2ZWxvcG1lbnQ6
DQo+ID4gPiAgICAgICAgICAqDQo+ID4gPiAgICAgICAgICAqIEN1cnJlbnQgc2xvdy1wYXRoIGVz
c2VudGlhbGx5IGZhbGxzIGJhY2sgdG8gc2luZ2xlIHBhZ2UNCj4gPiA+IFRoYW5rcw0KPiA+ID4N
Cj4gPiA+IC1MaQ0KPiA+ID4gPiA+DQo+ID4gPg0K
