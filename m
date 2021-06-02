Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53408398119
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhFBG1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:27:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2944 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhFBG1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:27:11 -0400
Received: from dggeme710-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvzTd1CrYz693w;
        Wed,  2 Jun 2021 14:22:29 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme710-chm.china.huawei.com (10.1.199.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:25:26 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Wed, 2 Jun 2021 14:25:26 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "rjui@broadcom.com" <rjui@broadcom.com>,
        "sbranden@broadcom.com" <sbranden@broadcom.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "khilman@baylibre.com" <khilman@baylibre.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>
CC:     "opendmb@gmail.com" <opendmb@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "jbrunet@baylibre.com" <jbrunet@baylibre.com>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjIgbmV0LW5leHRdIG5ldDogbWRpbzogRml4IHNw?=
 =?utf-8?Q?elling_mistakes?=
Thread-Topic: [PATCH v2 net-next] net: mdio: Fix spelling mistakes
Thread-Index: AQHXV0/0yeESSU45Zkat1EPmshxhFKr/kyaAgACuOKA=
Date:   Wed, 2 Jun 2021 06:25:26 +0000
Message-ID: <8f437442d492476bbb0a9d7c4672a65b@huawei.com>
References: <20210602015151.4135891-1-zhengyongjun3@huawei.com>
 <ce8d1b78-47ce-9211-d948-093d316ea647@gmail.com>
In-Reply-To: <ce8d1b78-47ce-9211-d948-093d316ea647@gmail.com>
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

RmluZSwgSSB3aWxsIHNlbmQgdGhlIHBhdGNoIHJpZ2h0IG5vdyA6KQ0KDQotLS0tLemCruS7tuWO
n+S7ti0tLS0tDQrlj5Hku7bkuro6IEZsb3JpYW4gRmFpbmVsbGkgW21haWx0bzpmLmZhaW5lbGxp
QGdtYWlsLmNvbV0gDQrlj5HpgIHml7bpl7Q6IDIwMjHlubQ25pyIMuaXpSAxMjowMQ0K5pS25Lu2
5Lq6OiB6aGVuZ3lvbmdqdW4gPHpoZW5neW9uZ2p1bjNAaHVhd2VpLmNvbT47IGFuZHJld0BsdW5u
LmNoOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJu
ZWwub3JnOyByanVpQGJyb2FkY29tLmNvbTsgc2JyYW5kZW5AYnJvYWRjb20uY29tOyBiY20ta2Vy
bmVsLWZlZWRiYWNrLWxpc3RAYnJvYWRjb20uY29tOyBuYXJtc3Ryb25nQGJheWxpYnJlLmNvbTsg
a2hpbG1hbkBiYXlsaWJyZS5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFtbG9naWNAbGlzdHMuaW5mcmFkZWFkLm9yZw0K5oqE
6YCBOiBvcGVuZG1iQGdtYWlsLmNvbTsgZi5mYWluZWxsaUBnbWFpbC5jb207IGxpbnV4QGFybWxp
bnV4Lm9yZy51azsgamJydW5ldEBiYXlsaWJyZS5jb207IG1hcnRpbi5ibHVtZW5zdGluZ2xAZ29v
Z2xlbWFpbC5jb20NCuS4u+mimDogUmU6IFtQQVRDSCB2MiBuZXQtbmV4dF0gbmV0OiBtZGlvOiBG
aXggc3BlbGxpbmcgbWlzdGFrZXMNCg0KDQoNCk9uIDYvMS8yMDIxIDY6NTEgUE0sIFpoZW5nIFlv
bmdqdW4gd3JvdGU6DQo+IGluZm9ybWF0aW9ucyAgPT0+IGluZm9ybWF0aW9uDQo+IHR5cGljYWx5
ICA9PT4gdHlwaWNhbGx5DQo+IGRlcnJpdmUgID09PiBkZXJpdmUNCj4gZXZlbnRob3VnaCAgPT0+
IGV2ZW4gdGhvdWdoDQo+IGh6ID09PiBIeg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9u
Z2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KDQpZb3VyIHYxIHdhcyBhcHBsaWVkIGFs
cmVhZHk6DQoNCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvbmV0ZGV2L25ldC1uZXh0L2MvZTY1YzI3
OTM4ZDhlDQoNCnNvIHlvdSB3b3VsZCBuZWVkIHRvIHN1Ym1pdCBhbiBpbmNyZW1lbnRhbCBwYXRj
aCB0aGFua3MhDQotLSANCkZsb3JpYW4NCg==
