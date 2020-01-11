Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC3B137CCC
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 10:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgAKJuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 04:50:16 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2985 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728759AbgAKJuQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 04:50:16 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id B6A7D6195E8CA0ACD33A;
        Sat, 11 Jan 2020 17:50:13 +0800 (CST)
Received: from dggeme764-chm.china.huawei.com (10.3.19.110) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 11 Jan 2020 17:50:13 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme764-chm.china.huawei.com (10.3.19.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 11 Jan 2020 17:50:13 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Sat, 11 Jan 2020 17:50:13 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Colin King <colin.king@canonical.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] ath11k: avoid null pointer dereference when pointer
 band is null
Thread-Topic: [PATCH][next] ath11k: avoid null pointer dereference when
 pointer band is null
Thread-Index: AdXIZDUYESk9sMb86Em1GlFaBBmLPA==
Date:   Sat, 11 Jan 2020 09:50:12 +0000
Message-ID: <05d5d54e035e4d69ad4ffb4a835a495a@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPiB3cm90Ze+8mg0KPkZy
b206IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+DQo+SW4gdGhl
IHVubGlrZWx5IGV2ZW50IHRoYXQgY2FwLT5zdXBwb3J0ZWRfYmFuZHMgaGFzIG5laXRoZXIgV01J
X0hPU1RfV0xBTl8yR19DQVAgc2V0IG9yIFdNSV9IT1NUX1dMQU5fNUdfQ0FQIHNldCB0aGVuIHBv
aW50ZXIgYmFuZCBpcyBudWxsIGFuZCBhIG51bGwgZGVyZWZlcmVuY2Ugb2NjdXJzIHdoZW4gYXNz
aWduaW5nDQo+YmFuZC0+bl9pZnR5cGVfZGF0YS4gIE1vdmUgdGhlIGFzc2lnbm1lbnQgdG8gdGhl
IGlmIGJsb2NrcyB0bw0KPmF2b2lkIHRoaXMuICBDbGVhbnMgdXAgc3RhdGljIGFuYWx5c2lzIHdh
cm5pbmdzLg0KPg0KPkFkZHJlc3Nlcy1Db3Zlcml0eTogKCJFeHBsaWNpdCBudWxsIGRlcmVmZXJl
bmNlIikNCj5GaXhlczogOWYwNTZlZDhlZTAxICgiYXRoMTFrOiBhZGQgSEUgc3VwcG9ydCIpDQo+
U2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4N
Cj4tLS0NCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDExay9tYWMuYyB8IDggKysrKy0t
LS0NCj4gMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCg0K
SXQgbG9va3MgZmluZSBmb3IgbWUuIFRoYW5rcy4NClJldmlld2VkLWJ5OiBNaWFvaGUgTGluIDxs
aW5taWFvaGVAaHVhd2VpLmNvbT4NCg==
