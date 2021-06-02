Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8710039835F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhFBHpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:45:14 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3506 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhFBHpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 03:45:08 -0400
Received: from dggeme761-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fw1Ck6THzzYrFn;
        Wed,  2 Jun 2021 15:40:34 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme761-chm.china.huawei.com (10.3.19.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 15:43:19 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Wed, 2 Jun 2021 15:43:19 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     Joe Perches <joe@perches.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "opendmb@gmail.com" <opendmb@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogbWRpbzogRml4IGEgdHlw?=
 =?utf-8?Q?o?=
Thread-Topic: [PATCH net-next] net: mdio: Fix a typo
Thread-Index: AQHXV3gaawUnSyvcRk+Lf+9GzB7O+ar/y9EAgACJjOA=
Date:   Wed, 2 Jun 2021 07:43:19 +0000
Message-ID: <264010307fb24b0193cfd451152bd71d@huawei.com>
References: <20210602063914.89177-1-zhengyongjun3@huawei.com>
 <76fd35fe623867c3be3f93b51d5d3461a2eabed9.camel@perches.com>
In-Reply-To: <76fd35fe623867c3be3f93b51d5d3461a2eabed9.camel@perches.com>
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

UnVzc2VsbCBLaW5nIHRvbGQgbWUgdG8gZG8gc28uLi4gIERpZCBJIHVuZGVyc3RhbmQgaXQgd3Jv
bmc/ICANCkJ1dCBmcm9tIHlvdXIgb3BpbmlvbiwgSSB0aGluayAiSHoiIGlzIG1vcmUgYXBwcm9w
cmlhdGUgOikNCg0KYGBgDQpSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51az4NCg0K
T24gVHVlLCBKdW4gMDEsIDIwMjEgYXQgMTA6MTg6NTlQTSArMDgwMCwgWmhlbmcgWW9uZ2p1biB3
cm90ZToNCj4gaW5mb3JtYXRpb25zICA9PT4gaW5mb3JtYXRpb24NCj4gdHlwaWNhbHkgID09PiB0
eXBpY2FsbHkNCj4gZGVycml2ZSAgPT0+IGRlcml2ZQ0KPiBldmVudGhvdWdoICA9PT4gZXZlbiB0
aG91Z2gNCg0KSWYgeW91J3JlIGRvaW5nIHRoaXMsIHRoZW4gcGxlYXNlIGFsc28gY2hhbmdlICJo
eiIgdG8gIkh6Ii4gVGhlIHVuaXQgb2YgZnJlcXVlbmN5IGlzIHRoZSBsYXR0ZXIsIG5vdCB0aGUg
Zm9ybWVyLiBUaGFua3MuDQoNCi0tDQpSTUsncyBQYXRjaCBzeXN0ZW06IGh0dHBzOi8vd3d3LmFy
bWxpbnV4Lm9yZy51ay9kZXZlbG9wZXIvcGF0Y2hlcy8NCkZUVFAgaXMgaGVyZSEgNDBNYnBzIGRv
d24gMTBNYnBzIHVwLiBEZWNlbnQgY29ubmVjdGl2aXR5IGF0IGxhc3QhDQpgYGANCg0KLS0tLS3p
gq7ku7bljp/ku7YtLS0tLQ0K5Y+R5Lu25Lq6OiBKb2UgUGVyY2hlcyBbbWFpbHRvOmpvZUBwZXJj
aGVzLmNvbV0gDQrlj5HpgIHml7bpl7Q6IDIwMjHlubQ25pyIMuaXpSAxNToyNQ0K5pS25Lu25Lq6
OiB6aGVuZ3lvbmdqdW4gPHpoZW5neW9uZ2p1bjNAaHVhd2VpLmNvbT47IGFuZHJld0BsdW5uLmNo
OyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwu
b3JnOyBiY20ta2VybmVsLWZlZWRiYWNrLWxpc3RAYnJvYWRjb20uY29tOyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQrmioTpgIE6IG9wZW5kbWJA
Z21haWwuY29tOyBmLmZhaW5lbGxpQGdtYWlsLmNvbTsgbGludXhAYXJtbGludXgub3JnLnVrDQrk
uLvpopg6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogbWRpbzogRml4IGEgdHlwbw0KDQpPbiBX
ZWQsIDIwMjEtMDYtMDIgYXQgMTQ6MzkgKzA4MDAsIFpoZW5nIFlvbmdqdW4gd3JvdGU6DQo+IEh6
ICA9PT4gaHoNCltdDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9tZGlvL21kaW8tYmNtLXVu
aW1hYy5jIGIvZHJpdmVycy9uZXQvbWRpby9tZGlvLWJjbS11bmltYWMuYw0KW10NCj4gQEAgLTIw
Myw3ICsyMDMsNyBAQCBzdGF0aWMgdm9pZCB1bmltYWNfbWRpb19jbGtfc2V0KHN0cnVjdCB1bmlt
YWNfbWRpb19wcml2ICpwcml2KQ0KPiDCoAkJcmV0dXJuOw0KPiDCoAl9DQo+IA0KPiAtCS8qIFRo
ZSBNRElPIGNsb2NrIGlzIHRoZSByZWZlcmVuY2UgY2xvY2sgKHR5cGljYWxseSAyNTBNSHopIGRp
dmlkZWQgYnkNCj4gKwkvKiBUaGUgTURJTyBjbG9jayBpcyB0aGUgcmVmZXJlbmNlIGNsb2NrICh0
eXBpY2FsbHkgMjUwTWh6KSBkaXZpZGVkIGJ5DQoNCk5vIHRoYW5rcy4NCg0KTUh6IGlzIHR5cGlj
YWwsIE1oeiBpcyBub3QuDQoNCiQgZ2l0IGdyZXAgLXcgLWkgLW8gLWggbWh6IHwgc29ydCB8dW5p
cSAtYyB8IHNvcnQgLXJuDQogICA1MDQyIE1Ieg0KICAgIDU3MSBNSFoNCiAgICAzOTggTWh6DQog
ICAgMzUzIG1oeg0KICAgICAxMCBtSHoNCg0KDQo=
