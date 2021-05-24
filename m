Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E5738DEF6
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 03:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhEXBuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 21:50:23 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5741 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhEXBuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 21:50:23 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FpKlz2czszncRq;
        Mon, 24 May 2021 09:45:19 +0800 (CST)
Received: from nkgeml706-chm.china.huawei.com (10.98.57.153) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 09:48:53 +0800
Received: from nkgeml708-chm.china.huawei.com (10.98.57.160) by
 nkgeml706-chm.china.huawei.com (10.98.57.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 09:48:53 +0800
Received: from nkgeml708-chm.china.huawei.com ([10.98.57.160]) by
 nkgeml708-chm.china.huawei.com ([10.98.57.160]) with mapi id 15.01.2176.012;
 Mon, 24 May 2021 09:48:53 +0800
From:   "Guodeqing (A)" <geffrey.guo@huawei.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
Thread-Topic: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
Thread-Index: AQHXTuG8V0ZK8eJ5BEC9fbKUzqGeOarwJXsAgAG2WPA=
Date:   Mon, 24 May 2021 01:48:53 +0000
Message-ID: <9e95be43a1c14065b9f339ee39cecd3c@huawei.com>
References: <20210522080231.54760-1-geffrey.guo@huawei.com>
 <6f7b729d-38df-9bf8-f023-bc1986da9a9e@nvidia.com>
In-Reply-To: <6f7b729d-38df-9bf8-f023-bc1986da9a9e@nvidia.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.115.169]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWF4IEd1cnRvdm95IFtt
YWlsdG86bWd1cnRvdm95QG52aWRpYS5jb21dDQo+IFNlbnQ6IFN1bmRheSwgTWF5IDIzLCAyMDIx
IDE1OjI1DQo+IFRvOiBHdW9kZXFpbmcgKEEpIDxnZWZmcmV5Lmd1b0BodWF3ZWkuY29tPjsgbXN0
QHJlZGhhdC5jb20NCj4gQ2M6IGphc293YW5nQHJlZGhhdC5jb207IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRh
dGlvbi5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0g
dmlydGlvLW5ldDogZml4IHRoZSBremFsbG9jL2tmcmVlIG1pc21hdGNoIHByb2JsZW0NCj4gDQo+
IA0KPiBPbiA1LzIyLzIwMjEgMTE6MDIgQU0sIGd1b2RlcWluZyB3cm90ZToNCj4gPiBJZiB0aGUg
dmlydGlvX25ldCBkZXZpY2UgZG9lcyBub3Qgc3VwcHVydCB0aGUgY3RybCBxdWV1ZSBmZWF0dXJl
LCB0aGUNCj4gPiB2aS0+Y3RybCB3YXMgbm90IGFsbG9jYXRlZCwgc28gdGhlcmUgaXMgbm8gbmVl
ZCB0byBmcmVlIGl0Lg0KPiANCj4geW91IGRvbid0IG5lZWQgdGhpcyBjaGVjay4NCj4gDQo+IGZy
b20ga2ZyZWUgZG9jOg0KPiANCj4gIklmIEBvYmpwIGlzIE5VTEwsIG5vIG9wZXJhdGlvbiBpcyBw
ZXJmb3JtZWQuIg0KPiANCj4gVGhpcyBpcyBub3QgYSBidWcuIEkndmUgc2V0IHZpLT5jdHJsIHRv
IGJlIE5VTEwgaW4gY2FzZSAhdmktPmhhc19jdnEuDQo+IA0KPiANCiAgeWVzLCAgdGhpcyBpcyBu
b3QgYSBidWcsIHRoZSBwYXRjaCBpcyBqdXN0IGEgb3B0aW1pemF0aW9uLCBiZWNhdXNlIHRoZSB2
aS0+Y3RybCBtYXliZSANCiAgYmUgZnJlZWQgd2hpY2ggIHdhcyBub3QgYWxsb2NhdGVkLCB0aGlz
IG1heSBnaXZlIHBlb3BsZSBhIG1pc3VuZGVyc3RhbmRpbmcuIA0KICBUaGFua3MuDQo+ID4NCj4g
PiBIZXJlIEkgYWRqdXN0IHRoZSBpbml0aWFsaXphdGlvbiBzZXF1ZW5jZSBhbmQgdGhlIGNoZWNr
IG9mIHZpLT5oYXNfY3ZxDQo+ID4gdG8gc2xvdmUgdGhpcyBwcm9ibGVtLg0KPiA+DQo+ID4gRml4
ZXM6IAkxMjJiODRhMTI2N2EgKCJ2aXJ0aW8tbmV0OiBkb24ndCBhbGxvY2F0ZSBjb250cm9sX2J1
ZiBpZiBub3QNCj4gc3VwcG9ydGVkIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBndW9kZXFpbmcgPGdl
ZmZyZXkuZ3VvQGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL25ldC92aXJ0aW9f
bmV0LmMgfCAyMCArKysrKysrKysrLS0tLS0tLS0tLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDEw
IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L3ZpcnRpb19uZXQuYyBiL2RyaXZlcnMvbmV0L3ZpcnRpb19uZXQuYyBpbmRleA0K
PiA+IDliNmE0YTg3NWM1NS4uODk0Zjg5NGQzYTI5IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
bmV0L3ZpcnRpb19uZXQuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3ZpcnRpb19uZXQuYw0KPiA+
IEBAIC0yNjkxLDcgKzI2OTEsOCBAQCBzdGF0aWMgdm9pZCB2aXJ0bmV0X2ZyZWVfcXVldWVzKHN0
cnVjdA0KPiA+IHZpcnRuZXRfaW5mbyAqdmkpDQo+ID4NCj4gPiAgIAlrZnJlZSh2aS0+cnEpOw0K
PiA+ICAgCWtmcmVlKHZpLT5zcSk7DQo+ID4gLQlrZnJlZSh2aS0+Y3RybCk7DQo+ID4gKwlpZiAo
dmktPmhhc19jdnEpDQo+ID4gKwkJa2ZyZWUodmktPmN0cmwpOw0KPiA+ICAgfQ0KPiA+DQo+ID4g
ICBzdGF0aWMgdm9pZCBfZnJlZV9yZWNlaXZlX2J1ZnMoc3RydWN0IHZpcnRuZXRfaW5mbyAqdmkp
IEBAIC0yODcwLDEzDQo+ID4gKzI4NzEsNiBAQCBzdGF0aWMgaW50IHZpcnRuZXRfYWxsb2NfcXVl
dWVzKHN0cnVjdCB2aXJ0bmV0X2luZm8gKnZpKQ0KPiA+ICAgew0KPiA+ICAgCWludCBpOw0KPiA+
DQo+ID4gLQlpZiAodmktPmhhc19jdnEpIHsNCj4gPiAtCQl2aS0+Y3RybCA9IGt6YWxsb2Moc2l6
ZW9mKCp2aS0+Y3RybCksIEdGUF9LRVJORUwpOw0KPiA+IC0JCWlmICghdmktPmN0cmwpDQo+ID4g
LQkJCWdvdG8gZXJyX2N0cmw7DQo+ID4gLQl9IGVsc2Ugew0KPiA+IC0JCXZpLT5jdHJsID0gTlVM
TDsNCj4gPiAtCX0NCj4gPiAgIAl2aS0+c3EgPSBrY2FsbG9jKHZpLT5tYXhfcXVldWVfcGFpcnMs
IHNpemVvZigqdmktPnNxKSwgR0ZQX0tFUk5FTCk7DQo+ID4gICAJaWYgKCF2aS0+c3EpDQo+ID4g
ICAJCWdvdG8gZXJyX3NxOw0KPiA+IEBAIC0yODg0LDYgKzI4NzgsMTIgQEAgc3RhdGljIGludCB2
aXJ0bmV0X2FsbG9jX3F1ZXVlcyhzdHJ1Y3QNCj4gdmlydG5ldF9pbmZvICp2aSkNCj4gPiAgIAlp
ZiAoIXZpLT5ycSkNCj4gPiAgIAkJZ290byBlcnJfcnE7DQo+ID4NCj4gPiArCWlmICh2aS0+aGFz
X2N2cSkgew0KPiA+ICsJCXZpLT5jdHJsID0ga3phbGxvYyhzaXplb2YoKnZpLT5jdHJsKSwgR0ZQ
X0tFUk5FTCk7DQo+ID4gKwkJaWYgKCF2aS0+Y3RybCkNCj4gPiArCQkJZ290byBlcnJfY3RybDsN
Cj4gPiArCX0NCj4gPiArDQo+ID4gICAJSU5JVF9ERUxBWUVEX1dPUksoJnZpLT5yZWZpbGwsIHJl
ZmlsbF93b3JrKTsNCj4gPiAgIAlmb3IgKGkgPSAwOyBpIDwgdmktPm1heF9xdWV1ZV9wYWlyczsg
aSsrKSB7DQo+ID4gICAJCXZpLT5ycVtpXS5wYWdlcyA9IE5VTEw7DQo+ID4gQEAgLTI5MDIsMTEg
KzI5MDIsMTEgQEAgc3RhdGljIGludCB2aXJ0bmV0X2FsbG9jX3F1ZXVlcyhzdHJ1Y3QNCj4gPiB2
aXJ0bmV0X2luZm8gKnZpKQ0KPiA+DQo+ID4gICAJcmV0dXJuIDA7DQo+ID4NCj4gPiArZXJyX2N0
cmw6DQo+ID4gKwlrZnJlZSh2aS0+cnEpOw0KPiA+ICAgZXJyX3JxOg0KPiA+ICAgCWtmcmVlKHZp
LT5zcSk7DQo+ID4gICBlcnJfc3E6DQo+ID4gLQlrZnJlZSh2aS0+Y3RybCk7DQo+ID4gLWVycl9j
dHJsOg0KPiA+ICAgCXJldHVybiAtRU5PTUVNOw0KPiA+ICAgfQ0KPiA+DQo=
