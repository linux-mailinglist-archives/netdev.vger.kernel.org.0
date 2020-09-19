Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B277270A4D
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 05:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgISDCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 23:02:41 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3526 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISDCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 23:02:41 -0400
Received: from dggeme710-chm.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id D29FD89F2E2DD74390DE;
        Sat, 19 Sep 2020 11:02:39 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme710-chm.china.huawei.com (10.1.199.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 19 Sep 2020 11:02:39 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.1913.007;
 Sat, 19 Sep 2020 11:02:39 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     "bryan.whitehead@microchip.com" <bryan.whitehead@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogbWljcm9jaGlwOiBSZW1v?=
 =?utf-8?Q?ve_set_but_not_used_variable?=
Thread-Topic: [PATCH net-next] net: microchip: Remove set but not used
 variable
Thread-Index: AQHWji24+IG9pS1rNkq81mRmJVzAkKlvRhig
Date:   Sat, 19 Sep 2020 03:02:39 +0000
Message-ID: <874b27fec9d4494a89cbe76e4071b845@huawei.com>
References: <20200919023732.23656-1-zhengyongjun3@huawei.com>
In-Reply-To: <20200919023732.23656-1-zhengyongjun3@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.179.94]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBpcyB0aGUgYmFkIHBhdGNoLCBwbGVhc2UgaWdub3JlIGl0LCB0aGFuayB5b3UgdmVyeSBt
dWNoLg0KDQotLS0tLemCruS7tuWOn+S7ti0tLS0tDQrlj5Hku7bkuro6IHpoZW5neW9uZ2p1biAN
CuWPkemAgeaXtumXtDogMjAyMOW5tDnmnIgxOeaXpSAxMDozOA0K5pS25Lu25Lq6OiBicnlhbi53
aGl0ZWhlYWRAbWljcm9jaGlwLmNvbTsgVU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbTsgZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQrmioTpgIE6IHpoZW5neW9uZ2p1biA8emhl
bmd5b25nanVuM0BodWF3ZWkuY29tPg0K5Li76aKYOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogbWlj
cm9jaGlwOiBSZW1vdmUgc2V0IGJ1dCBub3QgdXNlZCB2YXJpYWJsZQ0KDQpGaXhlcyBnY2MgJy1X
dW51c2VkLWJ1dC1zZXQtdmFyaWFibGUnIHdhcm5pbmc6DQoNCmRyaXZlcnMvbmV0L2V0aGVybmV0
L21pY3JvY2hpcC9sYW43NDN4X21haW4uYzogSW4gZnVuY3Rpb24gbGFuNzQzeF9wbV9zdXNwZW5k
Og0KZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjc0M3hfbWFpbi5jOjMwNDE6Njog
d2FybmluZzogdmFyaWFibGUg4oCYcmV04oCZIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1
dC1zZXQtdmFyaWFibGVdDQoNCmByZXRgIGlzIG5ldmVyIHVzZWQsIHNvIHJlbW92ZSBpdC4NCg0K
U2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0K
LS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjc0M3hfbWFpbi5jIHwgMiAr
LQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjc0M3hfbWFpbi5jIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjc0M3hfbWFpbi5jDQppbmRleCBkZTkz
Y2M2ZWJjMWEuLjU2YTFiNTkyOGY5YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21pY3JvY2hpcC9sYW43NDN4X21haW4uYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWlj
cm9jaGlwL2xhbjc0M3hfbWFpbi5jDQpAQCAtMzA1Myw3ICszMDUzLDcgQEAgc3RhdGljIGludCBs
YW43NDN4X3BtX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2KQ0KIAkvKiBIb3N0IHNldHMgUE1F
X0VuLCBwdXQgRDNob3QgKi8NCiAJcmV0ID0gcGNpX3ByZXBhcmVfdG9fc2xlZXAocGRldik7DQog
DQotCXJldHVybiAwOw0KKwlyZXR1cm4gcmV0Ow0KIH0NCiANCiBzdGF0aWMgaW50IGxhbjc0M3hf
cG1fcmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRldikNCi0tIA0KMi4xNy4xDQoNCg==
