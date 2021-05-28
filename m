Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFC4394172
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 12:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbhE1K7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 06:59:41 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5132 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236450AbhE1K7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 06:59:40 -0400
Received: from dggeme709-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fs1mn07VmzYmwY;
        Fri, 28 May 2021 18:55:21 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggeme709-chm.china.huawei.com (10.1.199.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 18:58:01 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2176.012;
 Fri, 28 May 2021 18:58:01 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        dingxiaoxiong <dingxiaoxiong@huawei.com>
Subject: RE: [PATCH net-next] virtio_net: set link state down when virtqueue
 is broken
Thread-Topic: [PATCH net-next] virtio_net: set link state down when virtqueue
 is broken
Thread-Index: AQHXUiPuxqZ0kftZNUuaGRJYw289Yar2NWAAgAJoQrA=
Date:   Fri, 28 May 2021 10:58:01 +0000
Message-ID: <d18383f7e675452d9392321506db6fa0@huawei.com>
References: <79907bf6c835572b4af92f16d9a3ff2822b1c7ea.1622028946.git.wangyunjian@huawei.com>
 <03c68dd1-a636-9d3b-1dec-5e11c8025ccc@redhat.com>
In-Reply-To: <03c68dd1-a636-9d3b-1dec-5e11c8025ccc@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.243.60]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+IEZyb206IFl1bmppYW4gV2FuZyA8d2Fu
Z3l1bmppYW5AaHVhd2VpLmNvbT4NCj4gPg0KPiA+IFRoZSBOSUMgY2FuJ3QgcmVjZWl2ZS9zZW5k
IHBhY2tldHMgaWYgYSByeC90eCB2aXJ0cXVldWUgaXMgYnJva2VuLg0KPiA+IEhvd2V2ZXIsIHRo
ZSBsaW5rIHN0YXRlIG9mIHRoZSBOSUMgaXMgc3RpbGwgbm9ybWFsLiBBcyBhIHJlc3VsdCwgdGhl
DQo+ID4gdXNlciBjYW5ub3QgZGV0ZWN0IHRoZSBOSUMgZXhjZXB0aW9uLg0KPiANCj4gDQo+IERv
ZXNuJ3Qgd2UgaGF2ZToNCj4gDQo+ICDCoMKgwqDCoMKgwqAgLyogVGhpcyBzaG91bGQgbm90IGhh
cHBlbiEgKi8NCj4gIMKgwqDCoMKgwqDCoMKgIGlmICh1bmxpa2VseShlcnIpKSB7DQo+ICDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV2LT5zdGF0cy50eF9maWZvX2Vycm9ycysrOw0K
PiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChuZXRfcmF0ZWxpbWl0KCkpDQo+
ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl93YXJu
KCZkZXYtPmRldiwNCj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIlVuZXhwZWN0ZWQgVFhRICglZCkgcXVldWUNCj4gZmFp
bHVyZTogJWRcbiIsDQo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHFudW0sIGVycik7DQo+ICDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgZGV2LT5zdGF0cy50eF9kcm9wcGVkKys7DQo+ICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgZGV2X2tmcmVlX3NrYl9hbnkoc2tiKTsNCj4gIMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gTkVUREVWX1RYX09LOw0KPiAgwqDCoMKgwqDCoMKg
wqAgfQ0KPiANCj4gV2hpY2ggc2hvdWxkIGJlIHN1ZmZpY2llbnQ/DQoNClRoZXJlIG1heSBiZSBv
dGhlciByZWFzb25zIGZvciB0aGlzIGVycm9yLCBlLmcgLUVOT1NQQyhubyBmcmVlIGRlc2MpLg0K
QW5kIGlmIHJ4IHZpcnRxdWV1ZSBpcyBicm9rZW4sIHRoZXJlIGlzIG5vIGVycm9yIHN0YXRpc3Rp
Y3MuDQoNCj4gDQo+IA0KPiA+DQo+ID4gVGhlIGRyaXZlciBjYW4gc2V0IHRoZSBsaW5rIHN0YXRl
IGRvd24gd2hlbiB0aGUgdmlydHF1ZXVlIGlzIGJyb2tlbi4NCj4gPiBJZiB0aGUgc3RhdGUgaXMg
ZG93biwgdGhlIHVzZXIgY2FuIHN3aXRjaCBvdmVyIHRvIGFub3RoZXIgTklDLg0KPiANCj4gDQo+
IE5vdGUgdGhhdCwgd2UgcHJvYmFibHkgbmVlZCB0aGUgd2F0Y2hkb2cgZm9yIHZpcnRpby1uZXQg
aW4gb3JkZXIgdG8gYmUgYQ0KPiBjb21wbGV0ZSBzb2x1dGlvbi4NCg0KWWVzLCBJIGNhbiB0aGlu
ayBvZiBpcyB0aGF0IHRoZSB2aXJ0cXVldWUncyBicm9rZW4gZXhjZXB0aW9uIGlzIGRldGVjdGVk
IG9uIHdhdGNoZG9nLg0KSXMgdGhlcmUgYW55dGhpbmcgZWxzZSB0aGF0IG5lZWRzIHRvIGJlIGRv
bmU/DQoNClRoYW5rcw0KDQo+IA0KPiBUaGFua3MNCj4gDQo+IA0KPiA+DQoNCg==
