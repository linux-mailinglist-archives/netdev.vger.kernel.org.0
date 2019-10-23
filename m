Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AD8E169A
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404141AbfJWJsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:48:52 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60460 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732648AbfJWJsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:48:51 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9N9mV3W003891, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9N9mV3W003891
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Oct 2019 17:48:31 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0468.000; Wed, 23 Oct 2019 17:48:30 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "pmalani@chromium.org" <pmalani@chromium.org>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: RE: [PATCH net-next] r8152: support request_firmware for RTL8153
Thread-Topic: [PATCH net-next] r8152: support request_firmware for RTL8153
Thread-Index: AQHVg84yG1svvwJLbEa5ZZ4zq0Zj+qdnd3YAgACNnOA=
Date:   Wed, 23 Oct 2019 09:48:28 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18ED3FA@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-329-Taiwan-albertk@realtek.com>
        <CGME20191023091648eucas1p12dcc4e9041169e3c7ae43f4ea525dd7f@eucas1p1.samsung.com>
 <44261242-ff44-0067-bbb9-2241e400ad53@samsung.com>
In-Reply-To: <44261242-ff44-0067-bbb9-2241e400ad53@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWFyZWsgU3p5cHJvd3NraSBbbWFpbHRvOm0uc3p5cHJvd3NraUBzYW1zdW5nLmNvbV0NCj4gU2Vu
dDogV2VkbmVzZGF5LCBPY3RvYmVyIDIzLCAyMDE5IDU6MTcgUE0NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBuZXQtbmV4dF0gcjgxNTI6IHN1cHBvcnQgcmVxdWVzdF9maXJtd2FyZSBmb3IgUlRMODE1
Mw0KPiANCj4gSGkgSGF5ZXMsDQo+IA0KPiBPbiAxNi4xMC4yMDE5IDA1OjAyLCBIYXllcyBXYW5n
IHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggc3VwcG9ydHMgbG9hZGluZyBhZGRpdGlvbmFsIGZpcm13
YXJlIGZpbGUgdGhyb3VnaA0KPiA+IHJlcXVlc3RfZmlybXdhcmUoKS4NCj4gPg0KPiA+IEEgZmly
bXdhcmUgZmlsZSBtYXkgaW5jbHVkZSBhIGhlYWRlciBmb2xsb3dlZCBieSBzZXZlcmFsIGJsb2Nr
cw0KPiA+IHdoaWNoIGhhdmUgZGlmZmVyZW50IHR5cGVzIG9mIGZpcm13YXJlLiBDdXJyZW50bHks
IHRoZSBzdXBwb3J0ZWQNCj4gPiB0eXBlcyBhcmUgUlRMX0ZXX0VORCwgUlRMX0ZXX1BMQSwgYW5k
IFJUTF9GV19VU0IuDQo+ID4NCj4gPiBUaGUgZmlybXdhcmUgaXMgdXNlZCB0byBmaXggc29tZSBj
b21wYXRpYmxlIG9yIGhhcmR3YXJlIGlzc3Vlcy4gRm9yDQo+ID4gZXhhbXBsZSwgdGhlIGRldmlj
ZSBjb3VsZG4ndCBiZSBmb3VuZCBhZnRlciByZWJvb3Rpbmcgc2V2ZXJhbCB0aW1lcy4NCj4gPg0K
PiA+IFRoZSBzdXBwb3J0ZWQgY2hpcHMgYXJlDQo+ID4gCVJUTF9WRVJfMDQgKHJ0bDgxNTNhLTIu
ZncpDQo+ID4gCVJUTF9WRVJfMDUgKHJ0bDgxNTNhLTMuZncpDQo+ID4gCVJUTF9WRVJfMDYgKHJ0
bDgxNTNhLTQuZncpDQo+ID4gCVJUTF9WRVJfMDkgKHJ0bDgxNTNiLTIuZncpDQo+ID4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBIYXllcyBXYW5nIDxoYXllc3dhbmdAcmVhbHRlay5jb20+DQo+ID4gUmV2
aWV3ZWQtYnk6IFByYXNoYW50IE1hbGFuaSA8cG1hbGFuaUBjaHJvbWl1bS5vcmc+DQo+IA0KPiBU
aGlzIHBhdGNoICh3aGljaCBsYW5kZWQgaW4gbGludXgtbmV4dCBsYXN0IGRheXMpIGNhdXNlcyBh
IGZvbGxvd2luZw0KPiBrZXJuZWwgb29wcyBvbiB0aGUgQVJNIDMyYml0IEV4eW5vczU0MjIgU29D
IGJhc2VkIE9kcm9pZCBYVTQgYm9hcmQ6DQoNClBsZWFzZSB0cnkgdGhlIGZvbGxvd2luZyBwYXRj
aC4NCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9yODE1Mi5jIGIvZHJpdmVycy9uZXQv
dXNiL3I4MTUyLmMNCmluZGV4IGQzYzMwY2NjODU3Ny4uMjgzYjM1YTc2Y2YwIDEwMDY0NA0KLS0t
IGEvZHJpdmVycy9uZXQvdXNiL3I4MTUyLmMNCisrKyBiL2RyaXZlcnMvbmV0L3VzYi9yODE1Mi5j
DQpAQCAtNDAwMCw4ICs0MDAwLDggQEAgc3RhdGljIHZvaWQgcnRsODE1Ml9md19tYWNfYXBwbHko
c3RydWN0IHI4MTUyICp0cCwgc3RydWN0IGZ3X21hYyAqbWFjKQ0KIHN0YXRpYyB2b2lkIHJ0bDgx
NTJfYXBwbHlfZmlybXdhcmUoc3RydWN0IHI4MTUyICp0cCkNCiB7DQogCXN0cnVjdCBydGxfZncg
KnJ0bF9mdyA9ICZ0cC0+cnRsX2Z3Ow0KLQljb25zdCBzdHJ1Y3QgZmlybXdhcmUgKmZ3ID0gcnRs
X2Z3LT5mdzsNCi0Jc3RydWN0IGZ3X2hlYWRlciAqZndfaGRyID0gKHN0cnVjdCBmd19oZWFkZXIg
Kilmdy0+ZGF0YTsNCisJY29uc3Qgc3RydWN0IGZpcm13YXJlICpmdzsNCisJc3RydWN0IGZ3X2hl
YWRlciAqZndfaGRyOw0KIAlzdHJ1Y3QgZndfcGh5X3BhdGNoX2tleSAqa2V5Ow0KIAl1MTYga2V5
X2FkZHIgPSAwOw0KIAlpbnQgaTsNCkBAIC00MDA5LDYgKzQwMDksOSBAQCBzdGF0aWMgdm9pZCBy
dGw4MTUyX2FwcGx5X2Zpcm13YXJlKHN0cnVjdCByODE1MiAqdHApDQogCWlmIChJU19FUlJfT1Jf
TlVMTChydGxfZnctPmZ3KSkNCiAJCXJldHVybjsNCiANCisJZncgPSBydGxfZnctPmZ3Ow0KKwlm
d19oZHIgPSAoc3RydWN0IGZ3X2hlYWRlciAqKWZ3LT5kYXRhOw0KKw0KIAlpZiAocnRsX2Z3LT5w
cmVfZncpDQogCQlydGxfZnctPnByZV9mdyh0cCk7DQoNCj4gPiArc3RhdGljIHZvaWQgcnRsODE1
Ml9hcHBseV9maXJtd2FyZShzdHJ1Y3QgcjgxNTIgKnRwKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3Qg
cnRsX2Z3ICpydGxfZncgPSAmdHAtPnJ0bF9mdzsNCj4gPiArCWNvbnN0IHN0cnVjdCBmaXJtd2Fy
ZSAqZncgPSBydGxfZnctPmZ3Ow0KPiA+ICsJc3RydWN0IGZ3X2hlYWRlciAqZndfaGRyID0gKHN0
cnVjdCBmd19oZWFkZXIgKilmdy0+ZGF0YTsNCj4gPiArCWludCBpOw0KPiA+ICsNCj4gPiArCWlm
IChJU19FUlJfT1JfTlVMTChydGxfZnctPmZ3KSkNCj4gPiArCQlyZXR1cm47DQo+ID4gKw0KPiA+
ICsJaWYgKHJ0bF9mdy0+cHJlX2Z3KQ0KPiA+ICsJCXJ0bF9mdy0+cHJlX2Z3KHRwKTsNCj4gPiAr
DQoNCkJlc3QgUmVnYXJkcywNCkhheWVzDQoNCg0K
