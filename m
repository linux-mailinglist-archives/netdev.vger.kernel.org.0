Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89B239EBA1
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 03:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhFHBt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 21:49:59 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4501 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFHBt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 21:49:58 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzY300zrmzZfpF;
        Tue,  8 Jun 2021 09:45:16 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 09:48:05 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Tue, 8 Jun 2021 09:48:05 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIHBpbmc6IENoZWNrIHJldHVybiB2YWx1ZSBvZiBm?=
 =?utf-8?B?dW5jdGlvbiAncGluZ19xdWV1ZV9yY3Zfc2tiJw==?=
Thread-Topic: [PATCH] ping: Check return value of function
 'ping_queue_rcv_skb'
Thread-Index: AQHXW3shcxGNUsKYH0+azDEUfRIiUqsINpmAgAEipRA=
Date:   Tue, 8 Jun 2021 01:48:05 +0000
Message-ID: <22a948a8b66244e796211eefbf95ac19@huawei.com>
References: <20210607091058.2766648-1-zhengyongjun3@huawei.com>
 <1c31a9fa-6322-cebb-c78c-189c905eaf86@gmail.com>
In-Reply-To: <1c31a9fa-6322-cebb-c78c-189c905eaf86@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.64]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IGZvciB5b3VyIHN1Z2dlc3Rpb24sIGl0IHdpbGwgbWFrZSB0aGUgY29kZSBsb29r
IGNsZWFuZXIgOikgDQpJIHdpbGwgc2VuZCBwYXRjaCB2MiBzb29uLg0KDQotLS0tLemCruS7tuWO
n+S7ti0tLS0tDQrlj5Hku7bkuro6IERhdmlkIEFoZXJuIFttYWlsdG86ZHNhaGVybkBnbWFpbC5j
b21dIA0K5Y+R6YCB5pe26Ze0OiAyMDIx5bm0NuaciDjml6UgMDoyNg0K5pS25Lu25Lq6OiB6aGVu
Z3lvbmdqdW4gPHpoZW5neW9uZ2p1bjNAaHVhd2VpLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
IHlvc2hmdWppQGxpbnV4LWlwdjYub3JnOyBkc2FoZXJuQGtlcm5lbC5vcmc7IGt1YmFAa2VybmVs
Lm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zw0K5Li76aKYOiBSZTogW1BBVENIXSBwaW5nOiBDaGVjayByZXR1cm4gdmFsdWUgb2YgZnVuY3Rp
b24gJ3BpbmdfcXVldWVfcmN2X3NrYicNCg0KT24gNi83LzIxIDM6MTAgQU0sIFpoZW5nIFlvbmdq
dW4gd3JvdGU6DQo+IEZ1bmN0aW9uICdwaW5nX3F1ZXVlX3Jjdl9za2InIG5vdCBhbHdheXMgcmV0
dXJuIHN1Y2Nlc3MsIHdoaWNoIHdpbGwgDQo+IGFsc28gcmV0dXJuIGZhaWwuIElmIG5vdCBjaGVj
ayB0aGUgd3JvbmcgcmV0dXJuIHZhbHVlIG9mIGl0LCBsZWFkIHRvIA0KPiBmdW5jdGlvbiBgcGlu
Z19yY3ZgIHJldHVybiBzdWNjZXNzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1
biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KPiAtLS0NCj4gIG5ldC9pcHY0L3BpbmcuYyB8
IDcgKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlv
bnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvaXB2NC9waW5nLmMgYi9uZXQvaXB2NC9waW5n
LmMgaW5kZXggDQo+IDFjOWY3MWEzNzI1OC4uOGU4NGNkZTk1MDExIDEwMDY0NA0KPiAtLS0gYS9u
ZXQvaXB2NC9waW5nLmMNCj4gKysrIGIvbmV0L2lwdjQvcGluZy5jDQo+IEBAIC05NjgsMTAgKzk2
OCwxMSBAQCBib29sIHBpbmdfcmN2KHN0cnVjdCBza19idWZmICpza2IpDQo+ICAJCXN0cnVjdCBz
a19idWZmICpza2IyID0gc2tiX2Nsb25lKHNrYiwgR0ZQX0FUT01JQyk7DQo+ICANCj4gIAkJcHJf
ZGVidWcoInJjdiBvbiBzb2NrZXQgJXBcbiIsIHNrKTsNCj4gLQkJaWYgKHNrYjIpDQo+IC0JCQlw
aW5nX3F1ZXVlX3Jjdl9za2Ioc2ssIHNrYjIpOw0KPiArCQlpZiAoc2tiMiAmJiAhcGluZ19xdWV1
ZV9yY3Zfc2tiKHNrLCBza2IyKSkgew0KPiArCQkJc29ja19wdXQoc2spOw0KPiArCQkJcmV0dXJu
IHRydWU7DQo+ICsJCX0NCj4gIAkJc29ja19wdXQoc2spOw0KPiAtCQlyZXR1cm4gdHJ1ZTsNCj4g
IAl9DQo+ICAJcHJfZGVidWcoIm5vIHNvY2tldCwgZHJvcHBpbmdcbiIpOw0KPiAgDQo+IA0KDQpk
ZWNsYXJlIGEgZGVmYXVsdCByZXR1cm4gdmFyaWFibGU6DQoNCglib29sIHJjID0gZmFsc2U7DQoN
CnNldCB0byB0byB0cnVlIGlmIHBpbmdfcXVldWVfcmN2X3NrYigpIGZhaWxzIGFuZCBoYXZlIG9u
ZSBleGl0IHBhdGggd2l0aCBvbmUgc29ja19wdXQuDQo=
