Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78BB430D7E
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 03:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344987AbhJRBco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 21:32:44 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:42021 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242964AbhJRBcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 21:32:43 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 19I1UDZQ0002952, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 19I1UDZQ0002952
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 Oct 2021 09:30:13 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 18 Oct 2021 09:30:13 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 18 Oct 2021 09:30:12 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Mon, 18 Oct 2021 09:30:12 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] rtw89: Fix two spelling mistakes in debug messages
Thread-Topic: [PATCH][next] rtw89: Fix two spelling mistakes in debug messages
Thread-Index: AQHXwbJu+EF38qr9qUWm8IqllLnmGKvX+6QQ
Date:   Mon, 18 Oct 2021 01:30:12 +0000
Message-ID: <0b5a4db2102f418a8f6e2e9ca3fde07d@realtek.com>
References: <20211015105004.11817-1-colin.king@canonical.com>
In-Reply-To: <20211015105004.11817-1-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEwLzE3IOS4i+WNiCAwNzozOTowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/18/2021 01:10:06
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 166777 [Oct 17 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 463 463 5854868460de3f0d8e8c0a4df98aeb05fb764a09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/18/2021 01:13:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbGluIEtpbmcgPGNvbGlu
LmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDE1LCAyMDIxIDY6
NTAgUE0NCj4gVG86IEthbGxlIFZhbG8gPGt2YWxvQGNvZGVhdXJvcmEub3JnPjsgRGF2aWQgUyAu
IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpDQo+IDxrdWJhQGtl
cm5lbC5vcmc+OyBQa3NoaWggPHBrc2hpaEByZWFsdGVrLmNvbT47IGxpbnV4LXdpcmVsZXNzQHZn
ZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzoga2VybmVsLWph
bml0b3JzQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBT
dWJqZWN0OiBbUEFUQ0hdW25leHRdIHJ0dzg5OiBGaXggdHdvIHNwZWxsaW5nIG1pc3Rha2VzIGlu
IGRlYnVnIG1lc3NhZ2VzDQo+IA0KPiBGcm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0Bj
YW5vbmljYWwuY29tPg0KPiANCj4gVGhlcmUgYXJlIHR3byBzcGVsbGluZyBtaXN0YWtlcyBpbiBy
dHc4OV9kZWJ1ZyBtZXNzYWdlcy4gRml4IHRoZW0uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xp
biBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KDQpBY2tlZC1ieTogUGluZy1L
ZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0dzg5L3BoeS5jIHwgNCArKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvcGh5LmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0dzg5L3BoeS5jDQo+IGluZGV4IDUzYzM2Y2M4MmM1Ny4uYWIxMzQ4NTZiYWFj
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L3BoeS5j
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvcGh5LmMNCj4gQEAg
LTE3MTUsNyArMTcxNSw3IEBAIHN0YXRpYyBzMzIgcnR3ODlfcGh5X211bHRpX3N0YV9jZm9fY2Fs
YyhzdHJ1Y3QgcnR3ODlfZGV2ICpydHdkZXYpDQo+ICAJCQl0YXJnZXRfY2ZvID0gY2xhbXAoY2Zv
X2F2ZywgbWF4X2Nmb19sYiwgbWluX2Nmb191Yik7DQo+ICAJCX0gZWxzZSB7DQo+ICAJCQlydHc4
OV9kZWJ1ZyhydHdkZXYsIFJUVzg5X0RCR19DRk8sDQo+IC0JCQkJICAgICJObyBpbnRlcnNlY3Rp
b24gb2YgY2ZvIHRvcmxlbmNlIHdpbmRvd3NcbiIpOw0KPiArCQkJCSAgICAiTm8gaW50ZXJzZWN0
aW9uIG9mIGNmbyB0b2xlcmFuY2Ugd2luZG93c1xuIik7DQo+ICAJCQl0YXJnZXRfY2ZvID0gcGh5
X2RpdihjZm9fa2h6X2FsbCwgKHMzMilzdGFfY250KTsNCj4gIAkJfQ0KPiAgCQlmb3IgKGkgPSAw
OyBpIDwgQ0ZPX1RSQUNLX01BWF9VU0VSOyBpKyspDQo+IEBAIC0yNzQ5LDcgKzI3NDksNyBAQCBz
dGF0aWMgdm9pZCBydHc4OV9waHlfZGlnX2R5bl9wZF90aChzdHJ1Y3QgcnR3ODlfZGV2ICpydHdk
ZXYsIHU4IHJzc2ksDQo+ICAJCQkgICAgZGlnLT5pZ2lfcnNzaSwgZmluYWxfcnNzaSwgdW5kZXJf
cmVnaW9uLCB2YWwpOw0KPiAgCX0gZWxzZSB7DQo+ICAJCXJ0dzg5X2RlYnVnKHJ0d2RldiwgUlRX
ODlfREJHX0RJRywNCj4gLQkJCSAgICAiRHluYW1pYyBQRCB0aCBkc2lhYmxlZCwgU2V0IFBEX2xv
d19iZD0wXG4iKTsNCj4gKwkJCSAgICAiRHluYW1pYyBQRCB0aCBkaXNhYmxlZCwgU2V0IFBEX2xv
d19iZD0wXG4iKTsNCj4gIAl9DQo+IA0KPiAgCXJ0dzg5X3BoeV93cml0ZTMyX21hc2socnR3ZGV2
LCBSX1NFRzBSX1BELCBCX1NFRzBSX1BEX0xPV0VSX0JPVU5EX01TSywNCj4gLS0NCj4gMi4zMi4w
DQo+IA0KPiAtLS0tLS1QbGVhc2UgY29uc2lkZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmlu
dGluZyB0aGlzIGUtbWFpbC4NCg==
