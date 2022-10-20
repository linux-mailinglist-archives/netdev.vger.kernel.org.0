Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806EC6059AD
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 10:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiJTI0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 04:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiJTI0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 04:26:11 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78AE5BC61F;
        Thu, 20 Oct 2022 01:26:07 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 29K8P8KM0007657, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 29K8P8KM0007657
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 20 Oct 2022 16:25:08 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 20 Oct 2022 16:25:40 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 20 Oct 2022 16:25:39 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb]) by
 RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb%5]) with mapi id
 15.01.2375.007; Thu, 20 Oct 2022 16:25:39 +0800
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
Subject: RE: [PATCH][next] wifi: rtw89: 8852b: Fix spelling mistake KIP_RESOTRE -> KIP_RESTORE
Thread-Topic: [PATCH][next] wifi: rtw89: 8852b: Fix spelling mistake
 KIP_RESOTRE -> KIP_RESTORE
Thread-Index: AQHY5FVYzEwt5nqXEUGEagTPXukM1q4W8X9g
Date:   Thu, 20 Oct 2022 08:25:39 +0000
Message-ID: <bef9e90fb8bd44eb8fc3acb26103314a@realtek.com>
References: <20221020072646.1513307-1-colin.i.king@gmail.com>
In-Reply-To: <20221020072646.1513307-1-colin.i.king@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEwLzIwIOS4iuWNiCAwNjozNjowMA==?=
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
b2xpbi5pLmtpbmdAZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgT2N0b2JlciAyMCwgMjAy
MiAzOjI3IFBNDQo+IFRvOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT47IEthbGxl
IFZhbG8gPGt2YWxvQGtlcm5lbC5vcmc+OyBEYXZpZCBTIC4gTWlsbGVyDQo+IDxkYXZlbUBkYXZl
bWxvZnQubmV0PjsgRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIgS2lj
aW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFiZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNv
bT47IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
Zw0KPiBDYzoga2VybmVsLWphbml0b3JzQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0hdW25leHRdIHdpZmk6IHJ0dzg5OiA4ODUy
YjogRml4IHNwZWxsaW5nIG1pc3Rha2UgS0lQX1JFU09UUkUgLT4gS0lQX1JFU1RPUkUNCj4gDQo+
IFRoZXIgaXMgYSBzcGVsbGluZyBtaXN0YWtlIGluIGEgcnR3ODlfZGVidWcgbWVzc2FnZS4gRml4
IGl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmkua2luZ0Bn
bWFpbC5jb20+DQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4N
Cg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvcnR3ODg1MmJf
cmZrLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRp
b24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0
dzg5L3J0dzg4NTJiX3Jmay5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4
OS9ydHc4ODUyYl9yZmsuYw0KPiBpbmRleCA4ZmQwMTUwMmFjNWIuLjcyMmFlMzRiMDljMSAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9ydHc4ODUyYl9y
ZmsuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L3J0dzg4NTJi
X3Jmay5jDQo+IEBAIC0xNzU0LDcgKzE3NTQsNyBAQCBzdGF0aWMgdm9pZCBfZHBrX29uZV9zaG90
KHN0cnVjdCBydHc4OV9kZXYgKnJ0d2RldiwgZW51bSBydHc4OV9waHlfaWR4IHBoeSwNCj4gIAkJ
ICAgIGlkID09IDB4MTQgPyAiUFdSX0NBTCIgOg0KPiAgCQkgICAgaWQgPT0gMHgxNSA/ICJEUEtf
UlhBR0MiIDoNCj4gIAkJICAgIGlkID09IDB4MTYgPyAiS0lQX1BSRVNFVCIgOg0KPiAtCQkgICAg
aWQgPT0gMHgxNyA/ICJLSVBfUkVTT1RSRSIgOiAiRFBLX1RYQUdDIiwNCj4gKwkJICAgIGlkID09
IDB4MTcgPyAiS0lQX1JFU1RPUkUiIDogIkRQS19UWEFHQyIsDQo+ICAJCSAgICBkcGtfY21kKTsN
Cj4gIH0NCj4gDQo+IC0tDQo+IDIuMzcuMw0KPiANCj4gDQo+IC0tLS0tLVBsZWFzZSBjb25zaWRl
ciB0aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
