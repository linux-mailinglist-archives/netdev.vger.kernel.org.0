Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1932C5F06
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 04:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388691AbgK0DfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 22:35:16 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:43973 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbgK0DfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 22:35:16 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0AR3YxYjA015114, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0AR3YxYjA015114
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Nov 2020 11:34:59 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.34) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 27 Nov 2020 11:34:59 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 27 Nov 2020 11:34:59 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Fri, 27 Nov 2020 11:34:59 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
CC:     Tony Chuang <yhchuang@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe, .remove and .shutdown
Thread-Topic: [PATCH 17/17] realtek: rtw88: pci: Add prototypes for .probe,
 .remove and .shutdown
Thread-Index: AQHWw/kLX1PwJPIhYEea5OlYi0Fw16nazioA
Date:   Fri, 27 Nov 2020 03:34:59 +0000
Message-ID: <1606448026.14483.4.camel@realtek.com>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
         <20201126133152.3211309-18-lee.jones@linaro.org>
In-Reply-To: <20201126133152.3211309-18-lee.jones@linaro.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <49DDB1AC13524F4EB2755A4D8B720B98@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpUaGUgc3ViamVjdCBwcmVmaXggZG9lc24ndCBuZWVkICdyZWFsdGVrOic7IHVzZSAncnR3ODg6
Jy4NCg0KT24gVGh1LCAyMDIwLTExLTI2IGF0IDEzOjMxICswMDAwLCBMZWUgSm9uZXMgd3JvdGU6
DQo+IEFsc28gc3RyaXAgb3V0IG90aGVyIGR1cGxpY2F0ZXMgZnJvbSBkcml2ZXIgc3BlY2lmaWMg
aGVhZGVycy4NCj4gDQo+IEVuc3VyZSAnbWFpbi5oJyBpcyBleHBsaWNpdGx5IGluY2x1ZGVkIGlu
ICdwY2kuaCcgc2luY2UgdGhlIGxhdHRlcg0KPiB1c2VzIHNvbWUgZGVmaW5lcyBmcm9tIHRoZSBm
b3JtZXIuwqDCoEl0IGF2b2lkcyBpc3N1ZXMgbGlrZToNCj4gDQo+IMKgZnJvbSBkcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjJiZS5jOjU6DQo+IMKgZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydHc4OC9wY2kuaDoyMDk6Mjg6IGVycm9yOg0KPiDigJhSVEtfTUFY
X1RYX1FVRVVFX05VTeKAmSB1bmRlY2xhcmVkIGhlcmUgKG5vdCBpbiBhIGZ1bmN0aW9uKTsgZGlk
IHlvdSBtZWFuDQo+IOKAmFJUS19NQVhfUlhfREVTQ19OVU3igJk/DQo+IMKgMjA5IHwgREVDTEFS
RV9CSVRNQVAodHhfcXVldWVkLCBSVEtfTUFYX1RYX1FVRVVFX05VTSk7DQo+IMKgfCBefn5+fn5+
fn5+fn5+fn5+fn5+fg0KPiANCj4gRml4ZXMgdGhlIGZvbGxvd2luZyBXPTEga2VybmVsIGJ1aWxk
IHdhcm5pbmcocyk6DQo+IA0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgv
cGNpLmM6MTQ4ODo1OiB3YXJuaW5nOiBubyBwcmV2aW91cw0KPiBwcm90b3R5cGUgZm9yIOKAmHJ0
d19wY2lfcHJvYmXigJkgWy1XbWlzc2luZy1wcm90b3R5cGVzXQ0KPiDCoDE0ODggfCBpbnQgcnR3
X3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwNCj4gwqB8IF5+fn5+fn5+fn5+fn4NCj4g
wqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5jOjE1Njg6Njogd2Fybmlu
Zzogbm8gcHJldmlvdXMNCj4gcHJvdG90eXBlIGZvciDigJhydHdfcGNpX3JlbW92ZeKAmSBbLVdt
aXNzaW5nLXByb3RvdHlwZXNdDQo+IMKgMTU2OCB8IHZvaWQgcnR3X3BjaV9yZW1vdmUoc3RydWN0
IHBjaV9kZXYgKnBkZXYpDQo+IMKgfCBefn5+fn5+fn5+fn5+fg0KPiDCoGRyaXZlcnMvbmV0L3dp
cmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGNpLmM6MTU5MDo2OiB3YXJuaW5nOiBubyBwcmV2aW91cw0K
PiBwcm90b3R5cGUgZm9yIOKAmHJ0d19wY2lfc2h1dGRvd27igJkgWy1XbWlzc2luZy1wcm90b3R5
cGVzXQ0KPiDCoDE1OTAgfCB2b2lkIHJ0d19wY2lfc2h1dGRvd24oc3RydWN0IHBjaV9kZXYgKnBk
ZXYpDQo+IMKgfCBefn5+fn5+fn5+fn5+fn5+DQo+IA0KPiBDYzogWWFuLUhzdWFuIENodWFuZyA8
eWhjaHVhbmdAcmVhbHRlay5jb20+DQo+IENjOiBLYWxsZSBWYWxvIDxrdmFsb0Bjb2RlYXVyb3Jh
Lm9yZz4NCj4gQ2M6ICJEYXZpZCBTLiBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBD
YzogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gQ2M6IGxpbnV4LXdpcmVsZXNz
QHZnZXIua2VybmVsLm9yZw0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQt
b2ZmLWJ5OiBMZWUgSm9uZXMgPGxlZS5qb25lc0BsaW5hcm8ub3JnPg0KPiAtLS0NCj4gwqBkcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5owqDCoMKgwqDCoMKgwqB8IDggKysr
KysrKysNCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg3MjNkZS5j
IHwgMSArDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4NzIzZGUu
aCB8IDQgLS0tLQ0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgy
MWNlLmMgfCAxICsNCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4
MjFjZS5oIHwgNCAtLS0tDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9y
dHc4ODIyYmUuYyB8IDEgKw0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgv
cnR3ODgyMmJlLmggfCA0IC0tLS0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0
dzg4L3J0dzg4MjJjZS5jIHwgMSArDQo+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9y
dHc4OC9ydHc4ODIyY2UuaCB8IDQgLS0tLQ0KPiDCoDkgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0
aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydHc4OC9wY2kuaA0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnR3ODgvcGNpLmgNCj4gaW5kZXggY2ExN2FhOWNmN2RjNy4uY2RhNTY5MTlhNWYwZiAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9wY2kuaA0K
PiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5oDQo+IEBAIC01
LDYgKzUsOCBAQA0KPiDCoCNpZm5kZWYgX19SVEtfUENJX0hfDQo+IMKgI2RlZmluZSBfX1JUS19Q
Q0lfSF8NCj4gwqANCj4gKyNpbmNsdWRlICJtYWluLmgiDQo+ICsNCg0KUGxlYXNlICNpbmNsdWRl
ICJtYWluLmgiIGFoZWFkIG9mICJwY2kuaCIgaW4gZWFjaCBvZsKgcnR3OHh4eHhlLmMuDQoNCj4g
wqAjZGVmaW5lIFJUS19ERUZBVUxUX1RYX0RFU0NfTlVNIDEyOA0KPiDCoCNkZWZpbmUgUlRLX0JF
UV9UWF9ERVNDX05VTQkyNTYNCj4gwqANCj4gQEAgLTIxMiw2ICsyMTQsMTIgQEAgc3RydWN0IHJ0
d19wY2kgew0KPiDCoAl2b2lkIF9faW9tZW0gKm1tYXA7DQo+IMKgfTsNCj4gwqANCj4gK2NvbnN0
IHN0cnVjdCBkZXZfcG1fb3BzIHJ0d19wbV9vcHM7DQo+ICsNCj4gK2ludCBydHdfcGNpX3Byb2Jl
KHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpOw0K
PiArdm9pZCBydHdfcGNpX3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqcGRldik7DQo+ICt2b2lkIHJ0
d19wY2lfc2h1dGRvd24oc3RydWN0IHBjaV9kZXYgKnBkZXYpOw0KPiArDQo+IMKgc3RhdGljIGlu
bGluZSB1MzIgbWF4X251bV9vZl90eF9xdWV1ZSh1OCBxdWV1ZSkNCj4gwqB7DQo+IMKgCXUzMiBt
YXhfbnVtOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4
OC9ydHc4NzIzZGUuYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3
ODcyM2RlLmMNCj4gaW5kZXggYzgxZWI0YzMzNjQyNS4uMmRkNjg5NDQxZThkYyAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4NzIzZGUuYw0KPiAr
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg3MjNkZS5jDQo+IEBA
IC00LDYgKzQsNyBAQA0KPiDCoA0KPiDCoCNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gwqAj
aW5jbHVkZSA8bGludXgvcGNpLmg+DQoNCkkgbWVhbiBoZXJlOg0KI2luY2x1ZGUgIm1haW4uaCIN
Cg0KPiArI2luY2x1ZGUgInBjaS5oIg0KPiDCoCNpbmNsdWRlICJydHc4NzIzZGUuaCINCj4gwqAN
Cj4gwqBzdGF0aWMgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgcnR3Xzg3MjNkZV9pZF90YWJs
ZVtdID0gew0KPiANCg0KW3NuaXBdDQoNCi0tLQ0KUGluZy1LZQ0KDQoNCg==
