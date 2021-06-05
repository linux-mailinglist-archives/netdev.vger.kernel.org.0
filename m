Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1FD39C68C
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 09:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFEHMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 03:12:25 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3068 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhFEHMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 03:12:24 -0400
Received: from dggeme710-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FxrJB3l43zWpfq;
        Sat,  5 Jun 2021 15:05:46 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggeme710-chm.china.huawei.com (10.1.199.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 5 Jun 2021 15:10:32 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2176.012;
 Sat, 5 Jun 2021 15:10:32 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jcfaracco@gmail.com" <jcfaracco@gmail.com>
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
Thread-Index: AQHXUiPuxqZ0kftZNUuaGRJYw289Yar2NWAAgAJoQrCAA9IngIAFwL5wgAB6NQCAAmNsEA==
Date:   Sat, 5 Jun 2021 07:10:32 +0000
Message-ID: <5d6fdd5c8e62498ba804aa22d71eb6a8@huawei.com>
References: <79907bf6c835572b4af92f16d9a3ff2822b1c7ea.1622028946.git.wangyunjian@huawei.com>
 <03c68dd1-a636-9d3b-1dec-5e11c8025ccc@redhat.com>
 <d18383f7e675452d9392321506db6fa0@huawei.com>
 <0fcc1413-cb20-7a17-bdcd-6f9994990432@redhat.com>
 <20a5f1bd8a5a49fa8c0f90875a49631b@huawei.com>
 <1cc933e6-cde4-ba20-3c54-7391db93a9a1@redhat.com>
In-Reply-To: <1cc933e6-cde4-ba20-3c54-7391db93a9a1@redhat.com>
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86
amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gU2VudDogRnJpZGF5LCBKdW5lIDQsIDIwMjEgMTA6Mzgg
QU0NCj4gVG86IHdhbmd5dW5qaWFuIDx3YW5neXVuamlhbkBodWF3ZWkuY29tPjsgbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZw0KPiBDYzoga3ViYUBrZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0
OyBtc3RAcmVkaGF0LmNvbTsNCj4gdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRhdGlv
bi5vcmc7IGRpbmd4aWFveGlvbmcNCj4gPGRpbmd4aWFveGlvbmdAaHVhd2VpLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dF0gdmlydGlvX25ldDogc2V0IGxpbmsgc3RhdGUgZG93
biB3aGVuIHZpcnRxdWV1ZSBpcw0KPiBicm9rZW4NCj4gDQo+IA0KPiDlnKggMjAyMS82LzMg5LiL
5Y2INzozNCwgd2FuZ3l1bmppYW4g5YaZ6YGTOg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+PiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86amFzb3dhbmdAcmVkaGF0LmNvbV0N
Cj4gPj4gU2VudDogTW9uZGF5LCBNYXkgMzEsIDIwMjEgMTE6MjkgQU0NCj4gPj4gVG86IHdhbmd5
dW5qaWFuIDx3YW5neXVuamlhbkBodWF3ZWkuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0K
PiA+PiBDYzoga3ViYUBrZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBtc3RAcmVkaGF0
LmNvbTsNCj4gPj4gdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7IGRp
bmd4aWFveGlvbmcNCj4gPj4gPGRpbmd4aWFveGlvbmdAaHVhd2VpLmNvbT4NCj4gPj4gU3ViamVj
dDogUmU6IFtQQVRDSCBuZXQtbmV4dF0gdmlydGlvX25ldDogc2V0IGxpbmsgc3RhdGUgZG93biB3
aGVuDQo+ID4+IHZpcnRxdWV1ZSBpcyBicm9rZW4NCj4gPj4NCj4gPj4NCj4gPj4g5ZyoIDIwMjEv
NS8yOCDkuIvljYg2OjU4LCB3YW5neXVuamlhbiDlhpnpgZM6DQo+ID4+Pj4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gPj4+Pj4gRnJvbTogWXVuamlhbiBXYW5nIDx3YW5neXVuamlhbkBo
dWF3ZWkuY29tPg0KPiA+Pj4+Pg0KPiA+Pj4+PiBUaGUgTklDIGNhbid0IHJlY2VpdmUvc2VuZCBw
YWNrZXRzIGlmIGEgcngvdHggdmlydHF1ZXVlIGlzIGJyb2tlbi4NCj4gPj4+Pj4gSG93ZXZlciwg
dGhlIGxpbmsgc3RhdGUgb2YgdGhlIE5JQyBpcyBzdGlsbCBub3JtYWwuIEFzIGEgcmVzdWx0LA0K
PiA+Pj4+PiB0aGUgdXNlciBjYW5ub3QgZGV0ZWN0IHRoZSBOSUMgZXhjZXB0aW9uLg0KPiA+Pj4+
IERvZXNuJ3Qgd2UgaGF2ZToNCj4gPj4+Pg0KPiA+Pj4+ICAgIMKgwqDCoMKgwqDCoCAvKiBUaGlz
IHNob3VsZCBub3QgaGFwcGVuISAqLw0KPiA+Pj4+ICAgIMKgwqDCoMKgwqDCoMKgIGlmICh1bmxp
a2VseShlcnIpKSB7DQo+ID4+Pj4gICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRl
di0+c3RhdHMudHhfZmlmb19lcnJvcnMrKzsNCj4gPj4+PiAgICDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgaWYgKG5ldF9yYXRlbGltaXQoKSkNCj4gPj4+PiAgICDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl93YXJuKCZkZXYtPmRldiwNCj4g
Pj4+PiAgICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICJVbmV4cGVjdGVkIFRYUSAoJWQpDQo+ID4+IHF1ZXVlDQo+ID4+Pj4g
ZmFpbHVyZTogJWRcbiIsDQo+ID4+Pj4gICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBxbnVtLCBlcnIpOw0KPiA+Pj4+ICAg
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZXYtPnN0YXRzLnR4X2Ryb3BwZWQrKzsN
Cj4gPj4+PiAgICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV2X2tmcmVlX3NrYl9h
bnkoc2tiKTsNCj4gPj4+PiAgICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJu
IE5FVERFVl9UWF9PSzsNCj4gPj4+PiAgICDCoMKgwqDCoMKgwqDCoCB9DQo+ID4+Pj4NCj4gPj4+
PiBXaGljaCBzaG91bGQgYmUgc3VmZmljaWVudD8NCj4gPj4+IFRoZXJlIG1heSBiZSBvdGhlciBy
ZWFzb25zIGZvciB0aGlzIGVycm9yLCBlLmcgLUVOT1NQQyhubyBmcmVlIGRlc2MpLg0KPiA+Pg0K
PiA+PiBUaGlzIHNob3VsZCBub3QgaGFwcGVuIHVubGVzcyB0aGUgZGV2aWNlIG9yIGRyaXZlciBp
cyBidWdneS4gV2UNCj4gPj4gYWx3YXlzIHJlc2VydmVkIHN1ZmZpY2llbnQgc2xvdHM6DQo+ID4+
DQo+ID4+ICAgwqDCoMKgwqDCoMKgwqAgaWYgKHNxLT52cS0+bnVtX2ZyZWUgPCAyK01BWF9TS0Jf
RlJBR1MpIHsNCj4gPj4gICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbmV0aWZfc3Rv
cF9zdWJxdWV1ZShkZXYsIHFudW0pOyAuLi4NCj4gPj4NCj4gPj4NCj4gPj4+IEFuZCBpZiByeCB2
aXJ0cXVldWUgaXMgYnJva2VuLCB0aGVyZSBpcyBubyBlcnJvciBzdGF0aXN0aWNzLg0KPiA+Pg0K
PiA+PiBGZWVsIGZyZWUgdG8gYWRkIG9uZSBpZiBpdCdzIG5lY2Vzc2FyeS4NCj4gPiBDdXJyZW50
bHkgcmVjZWl2aW5nIHNjZW5hcmlvLCBpdCBpcyBpbXBvc3NpYmxlIHRvIGRpc3Rpbmd1aXNoIHdo
ZXRoZXINCj4gPiB0aGUgcmVhc29uIGZvciBub3QgcmVjZWl2aW5nIHBhY2tldCBpcyB2aXJ0cXVl
dWUncyBicm9rZW4gb3Igbm8gcGFja2V0Lg0KPiANCj4gDQo+IENhbiB3ZSBpbnRyb2R1Y2Ugcnhf
Zmlmb19lcnJvcnMgZm9yIHRoYXQ/DQo+IA0KPiANCj4gPg0KPiA+PiBMZXQncyBsZWF2ZSB0aGUg
cG9saWN5IGRlY2lzaW9uIChsaW5rIGRvd24pIHRvIHVzZXJzcGFjZS4NCj4gPj4NCj4gPj4NCj4g
Pj4+Pj4gVGhlIGRyaXZlciBjYW4gc2V0IHRoZSBsaW5rIHN0YXRlIGRvd24gd2hlbiB0aGUgdmly
dHF1ZXVlIGlzIGJyb2tlbi4NCj4gPj4+Pj4gSWYgdGhlIHN0YXRlIGlzIGRvd24sIHRoZSB1c2Vy
IGNhbiBzd2l0Y2ggb3ZlciB0byBhbm90aGVyIE5JQy4NCj4gPj4+PiBOb3RlIHRoYXQsIHdlIHBy
b2JhYmx5IG5lZWQgdGhlIHdhdGNoZG9nIGZvciB2aXJ0aW8tbmV0IGluIG9yZGVyIHRvDQo+ID4+
Pj4gYmUgYSBjb21wbGV0ZSBzb2x1dGlvbi4NCj4gPj4+IFllcywgSSBjYW4gdGhpbmsgb2YgaXMg
dGhhdCB0aGUgdmlydHF1ZXVlJ3MgYnJva2VuIGV4Y2VwdGlvbiBpcw0KPiA+Pj4gZGV0ZWN0ZWQg
b24NCj4gPj4gd2F0Y2hkb2cuDQo+ID4+PiBJcyB0aGVyZSBhbnl0aGluZyBlbHNlIHRoYXQgbmVl
ZHMgdG8gYmUgZG9uZT8NCj4gPj4NCj4gPj4gQmFzaWNhbGx5LCBpdCdzIGFsbCBhYm91dCBUWCBz
dGFsbCB3aGljaCB3YXRjaGRvZyB0cmllcyB0byBjYXRjaC4NCj4gPj4gQnJva2VuIHZxIGlzIG9u
bHkgb25lIG9mIHRoZSBwb3NzaWJsZSByZWFzb24uDQo+ID4gQXJlIHRoZXJlIGFueSBwbGFucyBm
b3IgdGhlIHdhdGNoZG9nPw0KPiANCj4gDQo+IFNvbWVib2R5IHBvc3RlZCBhIHByb3RvdHlwZSAz
IG9yIDQgeWVhcnMgYWdvLCB5b3UgY2FuIHNlYXJjaCBpdCBhbmQgbWF5YmUgd2UNCj4gY2FuIHN0
YXJ0IGZyb20gdGhlcmUuDQoNCkkgZmluZCB0aGUgcGF0Y2ggKGh0dHBzOi8vcGF0Y2h3b3JrLm96
bGFicy5vcmcvcHJvamVjdC9uZXRkZXYvcGF0Y2gvMjAxOTExMjYyMDA2MjguMjIyNTEtMy1qY2Zh
cmFjY29AZ21haWwuY29tLykNCg0KVGhlIHBhdGNoIGNoZWNrcyBvbmx5IHRoZSBzY2VuYXJpbyB3
aGVyZSB0aGUgc2VuZGluZyBxdWV1ZSBpcyBhYm5vcm1hbCwgYnV0IGNhbg0Kbm90IGRldGVjdCB0
aGUgZXhjZXB0aW9uIGluIHRoZSByZWNlaXZpbmcgcXVldWUuDQoNCkFuZCB0aGUgcGF0Y2ggcmVz
dG9yZXMgdGhlIE5JQyBieSByZXNldCwgd2hpY2ggaXMgaW5hcHByb3ByaWF0ZSBiZWNhdXNlIHRo
ZSBicm9rZW4NCnN0YXRlIG1heSBiZSBjYXVzZWQgYnkgYSBmcm9udC1lbmQgb3IgYmFjay1lbmQg
YnVnLiBXZSBzaG91bGQga2VlcCB0aGUgc2NlbmUgdG8NCmxvY2F0ZSBidWdzLg0KDQpUaGFua3MN
Cg0KPiANCj4gVGhhbmtzDQo+IA0KPiANCj4gPg0KPiA+IFRoYW5rcw0KPiA+DQo+ID4+IFRoYW5r
cw0KPiA+Pg0KPiA+Pg0KPiA+Pj4gVGhhbmtzDQo+ID4+Pg0KPiA+Pj4+IFRoYW5rcw0KPiA+Pj4+
DQo+ID4+Pj4NCg0K
