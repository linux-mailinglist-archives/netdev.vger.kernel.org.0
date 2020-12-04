Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D7C2CE63F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgLDC6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:58:39 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:60608 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbgLDC6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 21:58:38 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0B42vbW13003556, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb05.realtek.com.tw[172.21.6.98])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0B42vbW13003556
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 4 Dec 2020 10:57:37 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 4 Dec 2020 10:57:36 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Fri, 4 Dec 2020 10:57:36 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        DeanKu <ku920601@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH][next] rtw88: coex: fix missing unitialization of variable 'interval'
Thread-Topic: [PATCH][next] rtw88: coex: fix missing unitialization of
 variable 'interval'
Thread-Index: AQHWyZz6BmIbttp/AEO1y1b2WLtmZKnluRcA
Date:   Fri, 4 Dec 2020 02:57:36 +0000
Message-ID: <1607050654.5824.0.camel@realtek.com>
References: <20201203175142.1071738-1-colin.king@canonical.com>
In-Reply-To: <20201203175142.1071738-1-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <824F9D3980CFE44680F4CAE6AF052B8E@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEyLTAzIGF0IDE3OjUxICswMDAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gQ3Vy
cmVudGx5IHRoZSB2YXJpYWJsZSAnaW50ZXJ2YWwnIGlzIG5vdCBpbml0aWFsaXplZCBhbmQgaXMg
b25seSBzZXQNCj4gdG8gMSB3aGVuIG9leF9zdGF0LT5idF80MThfaGlkX2V4aXN0aSBpcyB0cnVl
LsKgwqBGaXggdGhpcyBieSBpbmludGlhbGl6aW5nDQo+IHZhcmlhYmxlIGludGVydmFsIHRvIDAg
KHdoaWNoIEknbSBhc3N1bWluZyBpcyB0aGUgaW50ZW5kZWQgZGVmYXVsdCkuDQo+IA0KPiBBZGRy
ZXNzZXMtQ292ZXJpdHk6ICgiVW5pbml0YWxpemVkIHNjYWxhciB2YXJpYWJsZSIpDQo+IEZpeGVz
OiA1YjJlOWEzNWU0NTYgKCJydHc4ODogY29leDogYWRkIGZlYXR1cmUgdG8gZW5oYW5jZSBISUQg
Y29leGlzdGVuY2UNCj4gcGVyZm9ybWFuY2UiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4g
S2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KDQpUaGFua3MgZm9yIHlvdXIgZml4Lg0K
DQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQoNCj4gLS0tDQo+
IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9jb2V4LmMgfCAyICstDQo+IMKg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9jb2V4LmMNCj4gYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L2NvZXguYw0KPiBpbmRleCBjNzA0YzY4
ODVhMTguLjI0NTMwY2FmY2JhNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydHc4OC9jb2V4LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydHc4OC9jb2V4LmMNCj4gQEAgLTIwNTEsNyArMjA1MSw3IEBAIHN0YXRpYyB2b2lkIHJ0d19j
b2V4X2FjdGlvbl9idF9hMmRwX2hpZChzdHJ1Y3QgcnR3X2Rldg0KPiAqcnR3ZGV2KQ0KPiDCoAlz
dHJ1Y3QgcnR3X2NvZXhfZG0gKmNvZXhfZG0gPSAmY29leC0+ZG07DQo+IMKgCXN0cnVjdCBydHdf
ZWZ1c2UgKmVmdXNlID0gJnJ0d2Rldi0+ZWZ1c2U7DQo+IMKgCXN0cnVjdCBydHdfY2hpcF9pbmZv
ICpjaGlwID0gcnR3ZGV2LT5jaGlwOw0KPiAtCXU4IHRhYmxlX2Nhc2UsIHRkbWFfY2FzZSwgaW50
ZXJ2YWw7DQo+ICsJdTggdGFibGVfY2FzZSwgdGRtYV9jYXNlLCBpbnRlcnZhbCA9IDA7DQo+IMKg
CXUzMiBzbG90X3R5cGUgPSAwOw0KPiDCoAlib29sIGlzX3RvZ2dsZV90YWJsZSA9IGZhbHNlOw0K
PiDCoA0KPiAtLcKgDQo+IDIuMjkuMg0KPiANCj4gDQo+IC0tLS0tLVBsZWFzZSBjb25zaWRlciB0
aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0KDQoNCg==
