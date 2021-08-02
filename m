Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B943DD1AC
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhHBIFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:05:08 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:47912 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbhHBIFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 04:05:06 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 17284hFrA004362, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 17284hFrA004362
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 2 Aug 2021 16:04:43 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 2 Aug 2021 16:04:43 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 2 Aug 2021 16:04:43 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 2 Aug 2021 16:04:43 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] rtlwifi: rtl8192de: Remove redundant variable initializations
Thread-Topic: [PATCH 1/2] rtlwifi: rtl8192de: Remove redundant variable
 initializations
Thread-Index: AQHXhglPFTpvsnSxFECKhSLcmGDwpatfV88A
Date:   Mon, 2 Aug 2021 08:04:42 +0000
Message-ID: <1edfe34cb706b9c395cd8a6a84d4d98d209f1b56.camel@realtek.com>
References: <20210731124044.101927-1-colin.king@canonical.com>
In-Reply-To: <20210731124044.101927-1-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.21.121]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzgvMiDkuIrljYggMDY6MDE6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <441C8F02C7F0C54EBCBC3441363F9F12@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/02/2021 07:47:40
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165336 [Aug 02 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/02/2021 07:49:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTA3LTMxIGF0IDEzOjQwICswMTAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gVGhl
IHZhcmlhYmxlcyBydHN0YXR1cyBhbmQgcGxhY2UgYXJlIGJlaW5nIGluaXRpYWxpemVkIHdpdGgg
YSB2YWx1ZXMNCj4gdGhhdA0KPiBhcmUgbmV2ZXIgcmVhZCwgdGhlIGluaXRpYWxpemF0aW9ucyBh
cmUgcmVkdW5kYW50IGFuZCBjYW4gYmUgcmVtb3ZlZC4NCj4gDQo+IEFkZHJlc3Nlcy1Db3Zlcml0
eTogKCJVbnVzZWQgdmFsdWUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29s
aW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnRsd2lmaS9ydGw4MTkyZGUvcGh5LmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJkZS9waHkuYw0KPiBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyZGUvcGh5LmMNCj4gaW5k
ZXggNzZkZDg4MWVmOWJiLi40ZWFhNDBkNzNiYWYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyZGUvcGh5LmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJkZS9waHkuYw0KPiBAQCAtNjgx
LDcgKzY4MSw3IEBAIHN0YXRpYyBib29sIF9ydGw5MmRfcGh5X2JiX2NvbmZpZyhzdHJ1Y3QNCj4g
aWVlZTgwMjExX2h3ICpodykNCj4gIAlzdHJ1Y3QgcnRsX3ByaXYgKnJ0bHByaXYgPSBydGxfcHJp
dihodyk7DQo+ICAJc3RydWN0IHJ0bF9waHkgKnJ0bHBoeSA9ICYocnRscHJpdi0+cGh5KTsNCj4g
IAlzdHJ1Y3QgcnRsX2VmdXNlICpydGxlZnVzZSA9IHJ0bF9lZnVzZShydGxfcHJpdihodykpOw0K
PiAtCWJvb2wgcnRzdGF0dXMgPSB0cnVlOw0KPiArCWJvb2wgcnRzdGF0dXM7DQo+ICANCj4gIAly
dGxfZGJnKHJ0bHByaXYsIENPTVBfSU5JVCwgREJHX1RSQUNFLCAiPT0+XG4iKTsNCj4gIAlydHN0
YXR1cyA9IF9ydGw5MmRfcGh5X2NvbmZpZ19iYl93aXRoX2hlYWRlcmZpbGUoaHcsDQo+IEBAIC0x
MzYyLDcgKzEzNjIsNyBAQCB1OCBydGw5MmRfZ2V0X3JpZ2h0Y2hubHBsYWNlX2Zvcl9pcWsodTgg
Y2hubCkNCj4gIAkJMTMyLCAxMzQsIDEzNiwgMTM4LCAxNDAsIDE0OSwgMTUxLCAxNTMsIDE1NSwN
Cj4gIAkJMTU3LCAxNTksIDE2MSwgMTYzLCAxNjUNCj4gIAl9Ow0KPiAtCXU4IHBsYWNlID0gY2hu
bDsNCj4gKwl1OCBwbGFjZTsNCj4gIA0KPiAgCWlmIChjaG5sID4gMTQpIHsNCj4gIAkJZm9yIChw
bGFjZSA9IDE0OyBwbGFjZSA8IHNpemVvZihjaGFubmVsX2FsbCk7IHBsYWNlKyspDQo+IHsNCj4g
LS0gDQo+IDIuMzEuMQ0KPiANCj4gLS0tLS0tUGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVu
dCBiZWZvcmUgcHJpbnRpbmcgdGhpcyBlLW1haWwuDQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWgg
PHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KDQo=
