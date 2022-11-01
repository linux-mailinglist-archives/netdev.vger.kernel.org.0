Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7285614238
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 01:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiKAAWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 20:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiKAAWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 20:22:40 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 726426340;
        Mon, 31 Oct 2022 17:22:37 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2A10LUaX4006352, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2A10LUaX4006352
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 1 Nov 2022 08:21:30 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Tue, 1 Nov 2022 08:22:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Tue, 1 Nov 2022 08:22:05 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb]) by
 RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb%5]) with mapi id
 15.01.2375.007; Tue, 1 Nov 2022 08:22:05 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Colin Ian King <colin.i.king@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtlwifi: rtl8192ee: remove static variable stop_report_cnt
Thread-Topic: [PATCH] rtlwifi: rtl8192ee: remove static variable
 stop_report_cnt
Thread-Index: AQHY7UFi7CO5kegy5EyHq0HjTYwI4a4pNVXQ
Date:   Tue, 1 Nov 2022 00:22:05 +0000
Message-ID: <8d7c8373432747cb9a2a9c698d1cc581@realtek.com>
References: <20221031155637.871164-1-colin.i.king@gmail.com>
In-Reply-To: <20221031155637.871164-1-colin.i.king@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzMxIOS4i+WNiCAxMDowMDowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbGluIElhbiBLaW5nIDxj
b2xpbi5pLmtpbmdAZ21haWwuY29tPg0KPiBTZW50OiBNb25kYXksIE9jdG9iZXIgMzEsIDIwMjIg
MTE6NTcgUE0NCj4gVG86IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPjsgS2FsbGUg
VmFsbyA8a3ZhbG9Aa2VybmVsLm9yZz47IERhdmlkIFMgLiBNaWxsZXINCj4gPGRhdmVtQGRhdmVt
bG9mdC5uZXQ+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBKYWt1YiBLaWNp
bnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkNCj4gPHBhYmVuaUByZWRoYXQuY29t
PjsgbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
DQo+IENjOiBrZXJuZWwtamFuaXRvcnNAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRDSF0gcnRsd2lmaTogcnRsODE5MmVlOiByZW1v
dmUgc3RhdGljIHZhcmlhYmxlIHN0b3BfcmVwb3J0X2NudA0KPiANCj4gVmFyaWFibGUgc3RvcF9y
ZXBvcnRfY250IGlzIGJlaW5nIHNldCBvciBpbmNyZW1lbnRlZCBidXQgaXMgbmV2ZXINCj4gYmVp
bmcgdXNlZCBmb3IgYW55dGhpbmcgbWVhbmluZ2Z1bC4gVGhlIHZhcmlhYmxlIGFuZCBjb2RlIHJl
bGF0aW5nDQo+IHRvIGl0J3MgdXNlIGlzIHJlZHVuZGFudCBhbmQgY2FuIGJlIHJlbW92ZWQuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNv
bT4NCg0KQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQo+IC0t
LQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJlZS90cngu
YyB8IDggLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGRlbGV0aW9ucygtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTky
ZWUvdHJ4LmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5
MmVlL3RyeC5jDQo+IGluZGV4IDgwNDNkODE5ZmI4NS4uYTE4MmNkZWI1OGUyIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MmVlL3RyeC5j
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyZWUv
dHJ4LmMNCj4gQEAgLTk5Nyw3ICs5OTcsNiBAQCBib29sIHJ0bDkyZWVfaXNfdHhfZGVzY19jbG9z
ZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHU4IGh3X3F1ZXVlLCB1MTYgaW5kZXgpDQo+ICAJ
c3RydWN0IHJ0bF9wcml2ICpydGxwcml2ID0gcnRsX3ByaXYoaHcpOw0KPiAgCXUxNiByZWFkX3Bv
aW50LCB3cml0ZV9wb2ludDsNCj4gIAlib29sIHJldCA9IGZhbHNlOw0KPiAtCXN0YXRpYyB1OCBz
dG9wX3JlcG9ydF9jbnQ7DQo+ICAJc3RydWN0IHJ0bDgxOTJfdHhfcmluZyAqcmluZyA9ICZydGxw
Y2ktPnR4X3JpbmdbaHdfcXVldWVdOw0KPiANCj4gIAl7DQo+IEBAIC0xMDM4LDEzICsxMDM3LDYg
QEAgYm9vbCBydGw5MmVlX2lzX3R4X2Rlc2NfY2xvc2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3
LCB1OCBod19xdWV1ZSwgdTE2IGluZGV4KQ0KPiAgCSAgICBydGxwcml2LT5wc2MucmZvZmZfcmVh
c29uID4gUkZfQ0hBTkdFX0JZX1BTKQ0KPiAgCQlyZXQgPSB0cnVlOw0KPiANCj4gLQlpZiAoaHdf
cXVldWUgPCBCRUFDT05fUVVFVUUpIHsNCj4gLQkJaWYgKCFyZXQpDQo+IC0JCQlzdG9wX3JlcG9y
dF9jbnQrKzsNCj4gLQkJZWxzZQ0KPiAtCQkJc3RvcF9yZXBvcnRfY250ID0gMDsNCj4gLQl9DQo+
IC0NCj4gIAlyZXR1cm4gcmV0Ow0KPiAgfQ0KPiANCj4gLS0NCj4gMi4zNy4zDQo+IA0KPiANCj4g
LS0tLS0tUGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZvcmUgcHJpbnRpbmcgdGhp
cyBlLW1haWwuDQo=
