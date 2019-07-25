Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1534F7436F
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 04:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389377AbfGYCvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 22:51:02 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60106 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388165AbfGYCvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 22:51:02 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x6P2oiaj008827, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x6P2oiaj008827
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 25 Jul 2019 10:50:45 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Thu, 25 Jul
 2019 10:50:44 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] rtlwifi: remove unneeded function _rtl_dump_channel_map()
Thread-Topic: [PATCH] rtlwifi: remove unneeded function
 _rtl_dump_channel_map()
Thread-Index: AQHVQimXNtK+8JDVlEmdFowIZ+3GJKbaHRGA
Date:   Thu, 25 Jul 2019 02:50:43 +0000
Message-ID: <1564023043.5006.0.camel@realtek.com>
References: <20190724141020.58800-1-yuehaibing@huawei.com>
In-Reply-To: <20190724141020.58800-1-yuehaibing@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.114]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C8C70C85334E94D81DDDDACE9D684A6@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTI0IGF0IDIyOjEwICswODAwLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBO
b3cgX3J0bF9kdW1wX2NoYW5uZWxfbWFwKCkgZG9lcyBub3QgZG8gYW55IGFjdHVhbA0KPiB0aGlu
ZyB1c2luZyB0aGUgY2hhbm5lbC4gU28gcmVtb3ZlIGl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
WXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KPiAtLS0NCj4gwqBkcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcmVnZC5jIHwgMTggLS0tLS0tLS0tLS0tLS0tLS0t
DQo+IMKgMSBmaWxlIGNoYW5nZWQsIDE4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9yZWdkLmMNCj4gYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcmVnZC5jDQo+IGluZGV4IDZjY2I1YjkuLmMx
MDQzMmMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lm
aS9yZWdkLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3Jl
Z2QuYw0KPiBAQCAtMjc2LDIyICsyNzYsNiBAQCBzdGF0aWMgdm9pZCBfcnRsX3JlZ19hcHBseV93
b3JsZF9mbGFncyhzdHJ1Y3Qgd2lwaHkNCj4gKndpcGh5LA0KPiDCoAlyZXR1cm47DQo+IMKgfQ0K
PiDCoA0KPiAtc3RhdGljIHZvaWQgX3J0bF9kdW1wX2NoYW5uZWxfbWFwKHN0cnVjdCB3aXBoeSAq
d2lwaHkpDQo+IC17DQo+IC0JZW51bSBubDgwMjExX2JhbmQgYmFuZDsNCj4gLQlzdHJ1Y3QgaWVl
ZTgwMjExX3N1cHBvcnRlZF9iYW5kICpzYmFuZDsNCj4gLQlzdHJ1Y3QgaWVlZTgwMjExX2NoYW5u
ZWwgKmNoOw0KPiAtCXVuc2lnbmVkIGludCBpOw0KPiAtDQo+IC0JZm9yIChiYW5kID0gMDsgYmFu
ZCA8IE5VTV9OTDgwMjExX0JBTkRTOyBiYW5kKyspIHsNCj4gLQkJaWYgKCF3aXBoeS0+YmFuZHNb
YmFuZF0pDQo+IC0JCQljb250aW51ZTsNCj4gLQkJc2JhbmQgPSB3aXBoeS0+YmFuZHNbYmFuZF07
DQo+IC0JCWZvciAoaSA9IDA7IGkgPCBzYmFuZC0+bl9jaGFubmVsczsgaSsrKQ0KPiAtCQkJY2gg
PSAmc2JhbmQtPmNoYW5uZWxzW2ldOw0KPiAtCX0NCj4gLX0NCj4gLQ0KPiDCoHN0YXRpYyBpbnQg
X3J0bF9yZWdfbm90aWZpZXJfYXBwbHkoc3RydWN0IHdpcGh5ICp3aXBoeSwNCj4gwqAJCQkJwqDC
oMKgc3RydWN0IHJlZ3VsYXRvcnlfcmVxdWVzdCAqcmVxdWVzdCwNCj4gwqAJCQkJwqDCoMKgc3Ry
dWN0IHJ0bF9yZWd1bGF0b3J5ICpyZWcpDQo+IEBAIC0zMDksOCArMjkzLDYgQEAgc3RhdGljIGlu
dCBfcnRsX3JlZ19ub3RpZmllcl9hcHBseShzdHJ1Y3Qgd2lwaHkgKndpcGh5LA0KPiDCoAkJYnJl
YWs7DQo+IMKgCX0NCj4gwqANCj4gLQlfcnRsX2R1bXBfY2hhbm5lbF9tYXAod2lwaHkpOw0KPiAt
DQo+IMKgCXJldHVybiAwOw0KPiDCoH0NCj4gwqANCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8
cGtzaGloQHJlYWx0ZWsuY29tPg0KDQoNCg==
