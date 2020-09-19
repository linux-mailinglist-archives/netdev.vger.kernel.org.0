Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DD5270A53
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 05:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgISDI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 23:08:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3613 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISDI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 23:08:59 -0400
Received: from dggeme759-chm.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 31A60BE72618CD898B52;
        Sat, 19 Sep 2020 11:08:58 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme759-chm.china.huawei.com (10.3.19.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 19 Sep 2020 11:08:57 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.1913.007;
 Sat, 19 Sep 2020 11:08:57 +0800
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
Thread-Index: AQHWji3w2avWQB7gDEqtRhEuUp+Os6lvR5WA
Date:   Sat, 19 Sep 2020 03:08:57 +0000
Message-ID: <34c5c342e3bb4b778ba39d5535377da3@huawei.com>
References: <20200919023909.23716-1-zhengyongjun3@huawei.com>
In-Reply-To: <20200919023909.23716-1-zhengyongjun3@huawei.com>
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

VGhpcyBpcyB0aGUgYmFkIHBhdGNoLCBteSBmYXVsdCwgSSBmb3JnZXQgdG8gY2hlY2sgcGF0Y2gg
dGl0bGUsIHBsZWFzZSBpZ25vcmUgaXQsIHRoYW5rIHlvdSB2ZXJ5IG11Y2guDQoNCi0tLS0t6YKu
5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogemhlbmd5b25nanVuIA0K5Y+R6YCB5pe26Ze0OiAy
MDIw5bm0OeaciDE55pelIDEwOjM5DQrmlLbku7bkuro6IGJyeWFuLndoaXRlaGVhZEBtaWNyb2No
aXAuY29tOyBVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0
OyBrdWJhQGtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmcNCuaKhOmAgTogemhlbmd5b25nanVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdl
aS5jb20+DQrkuLvpopg6IFtQQVRDSCBuZXQtbmV4dF0gbmV0OiBtaWNyb2NoaXA6IFJlbW92ZSBz
ZXQgYnV0IG5vdCB1c2VkIHZhcmlhYmxlDQoNCkZpeGVzIGdjYyAnLVd1bnVzZWQtYnV0LXNldC12
YXJpYWJsZScgd2FybmluZzoNCg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjc0
M3hfbWFpbi5jOiBJbiBmdW5jdGlvbiBsYW43NDN4X3BtX3N1c3BlbmQ6DQpkcml2ZXJzL25ldC9l
dGhlcm5ldC9taWNyb2NoaXAvbGFuNzQzeF9tYWluLmM6MzA0MTo2OiB3YXJuaW5nOiB2YXJpYWJs
ZSDigJhyZXTigJkgc2V0IGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZV0N
Cg0KYHJldGAgaXMgc2V0IGJ1dCBub3QgdXNlZCwgc28gY2hlY2sgaXQncyB2YWx1ZS4NCg0KU2ln
bmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KLS0t
DQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjc0M3hfbWFpbi5jIHwgMiArLQ0K
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjc0M3hfbWFpbi5jIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjc0M3hfbWFpbi5jDQppbmRleCBkZTkzY2M2
ZWJjMWEuLjU2YTFiNTkyOGY5YSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21p
Y3JvY2hpcC9sYW43NDN4X21haW4uYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9j
aGlwL2xhbjc0M3hfbWFpbi5jDQpAQCAtMzA1Myw3ICszMDUzLDcgQEAgc3RhdGljIGludCBsYW43
NDN4X3BtX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2KQ0KIAkvKiBIb3N0IHNldHMgUE1FX0Vu
LCBwdXQgRDNob3QgKi8NCiAJcmV0ID0gcGNpX3ByZXBhcmVfdG9fc2xlZXAocGRldik7DQogDQot
CXJldHVybiAwOw0KKwlyZXR1cm4gcmV0Ow0KIH0NCiANCiBzdGF0aWMgaW50IGxhbjc0M3hfcG1f
cmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRldikNCi0tIA0KMi4xNy4xDQoNCg==
