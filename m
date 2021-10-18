Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422E7430D81
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 03:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344999AbhJRBdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 21:33:21 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:42233 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344984AbhJRBdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 21:33:20 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 19I1UvbnE003571, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 19I1UvbnE003571
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 Oct 2021 09:30:57 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 18 Oct 2021 09:30:56 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 09:30:56 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Mon, 18 Oct 2021 09:30:56 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] rtw89: Remove redundant check of ret after call to rtw89_mac_enable_bb_rf
Thread-Topic: [PATCH][next] rtw89: Remove redundant check of ret after call to
 rtw89_mac_enable_bb_rf
Thread-Index: AQHXwdhPDlA3YyhjVkeaAkBOHtLbNqvX+9Ag
Date:   Mon, 18 Oct 2021 01:30:56 +0000
Message-ID: <d136802937c24fca9e4823ace692a57a@realtek.com>
References: <20211015152113.33179-1-colin.king@canonical.com>
In-Reply-To: <20211015152113.33179-1-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
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
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/18/2021 01:22:07
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
X-KSE-Antiphishing-Bases: 10/18/2021 01:24:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbGluIEtpbmcgPGNvbGlu
LmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDE1LCAyMDIxIDEx
OjIxIFBNDQo+IFRvOiBLYWxsZSBWYWxvIDxrdmFsb0Bjb2RlYXVyb3JhLm9yZz47IERhdmlkIFMg
LiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraQ0KPiA8a3ViYUBr
ZXJuZWwub3JnPjsgUGtzaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBsaW51eC13aXJlbGVzc0B2
Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtlcm5lbC1q
YW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
U3ViamVjdDogW1BBVENIXVtuZXh0XSBydHc4OTogUmVtb3ZlIHJlZHVuZGFudCBjaGVjayBvZiBy
ZXQgYWZ0ZXIgY2FsbCB0byBydHc4OV9tYWNfZW5hYmxlX2JiX3JmDQo+IA0KPiBGcm9tOiBDb2xp
biBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gVGhlIGZ1bmN0aW9u
IHJ0dzg5X21hY19lbmFibGVfYmJfcmYgaXMgYSB2b2lkIHJldHVybiB0eXBlLCBzbyB0aGVyZSBp
cw0KPiBubyByZXR1cm4gZXJyb3IgY29kZSB0byByZXQsIHNvIHRoZSBmb2xsb3dpbmcgY2hlY2sg
Zm9yIGFuIGVycm9yIGluIHJldA0KPiBpcyByZWR1bmRhbnQgZGVhZCBjb2RlIGFuZCBjYW4gYmUg
cmVtb3ZlZC4NCj4gDQo+IEFkZHJlc3Nlcy1Db3Zlcml0eTogKCJMb2dpY2FsbHkgZGVhZCBjb2Rl
IikNCj4gRml4ZXM6IGUzZWM3MDE3ZjZhMiAoInJ0dzg5OiBhZGQgUmVhbHRlayA4MDIuMTFheCBk
cml2ZXIiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5v
bmljYWwuY29tPg0KDQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+
DQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L21hYy5jIHwg
MiAtLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9tYWMuYw0KPiBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODkvbWFjLmMNCj4gaW5kZXggMDE3MWE1YTdiMWRlLi42
OTM4NGM0M2MwNDYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnR3ODkvbWFjLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9t
YWMuYw0KPiBAQCAtMjY1Niw4ICsyNjU2LDYgQEAgaW50IHJ0dzg5X21hY19pbml0KHN0cnVjdCBy
dHc4OV9kZXYgKnJ0d2RldikNCj4gIAkJZ290byBmYWlsOw0KPiANCj4gIAlydHc4OV9tYWNfZW5h
YmxlX2JiX3JmKHJ0d2Rldik7DQo+IC0JaWYgKHJldCkNCj4gLQkJZ290byBmYWlsOw0KPiANCj4g
IAlyZXQgPSBydHc4OV9tYWNfc3lzX2luaXQocnR3ZGV2KTsNCj4gIAlpZiAocmV0KQ0KPiAtLQ0K
PiAyLjMyLjANCj4gDQo+IC0tLS0tLVBsZWFzZSBjb25zaWRlciB0aGUgZW52aXJvbm1lbnQgYmVm
b3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
