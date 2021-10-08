Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F404266F2
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 11:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237487AbhJHJfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 05:35:41 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:36629 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhJHJfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 05:35:40 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1989XRspC006558, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1989XRspC006558
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 8 Oct 2021 17:33:27 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 8 Oct 2021 17:33:27 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 8 Oct 2021 17:33:26 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Fri, 8 Oct 2021 17:33:26 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtlwifi: rtl8192ee: Remove redundant initialization of variable version
Thread-Topic: [PATCH] rtlwifi: rtl8192ee: Remove redundant initialization of
 variable version
Thread-Index: AQHXu5mg/+PJRzRY4UCjzqpRjbSbYavI1rEA
Date:   Fri, 8 Oct 2021 09:33:26 +0000
Message-ID: <e16b11a8d8f640d9be4ae2be21370d8a@realtek.com>
References: <20211007163722.20165-1-colin.king@canonical.com>
In-Reply-To: <20211007163722.20165-1-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEwLzgg5LiK5Y2IIDA4OjMwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/08/2021 09:18:19
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 166594 [Oct 08 2021]
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
X-KSE-Antiphishing-Bases: 10/08/2021 09:22:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ29saW4gS2luZyA8Y29s
aW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiBTZW50OiBGcmlkYXksIE9jdG9iZXIgOCwgMjAyMSAx
MjozNyBBTQ0KPiBUbzogUGtzaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBLYWxsZSBWYWxvIDxr
dmFsb0Bjb2RlYXVyb3JhLm9yZz47IERhdmlkIFMgLiBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgbGludXgtd2lyZWxlc3NA
dmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBrZXJuZWwt
amFuaXRvcnNAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFtQQVRDSF0gcnRsd2lmaTogcnRsODE5MmVlOiBSZW1vdmUgcmVkdW5kYW50IGlu
aXRpYWxpemF0aW9uIG9mIHZhcmlhYmxlIHZlcnNpb24NCj4gDQo+IEZyb206IENvbGluIElhbiBL
aW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiBUaGUgdmFyaWFibGUgdmVyc2lv
biBpcyBiZWluZyBpbml0aWFsaXplZCB3aXRoIGEgdmFsdWUgdGhhdCBpcw0KPiBuZXZlciByZWFk
LCBpdCBpcyBiZWluZyB1cGRhdGVkIGFmdGVyd2FyZHMgaW4gYm90aCBicmFuY2hlcyBvZg0KPiBh
biBpZiBzdGF0ZW1lbnQuIFRoZSBhc3NpZ25tZW50IGlzIHJlZHVuZGFudCBhbmQgY2FuIGJlIHJl
bW92ZWQuDQo+IA0KPiBBZGRyZXNzZXMtQ292ZXJpdHk6ICgiVW51c2VkIHZhbHVlIikNCj4gU2ln
bmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4g
LS0tDQo+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MmVlL2h3
LmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvcnRsODE5MmVlL2h3LmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvcnRsODE5MmVlL2h3LmMNCj4gaW5kZXggODhmYTJlNTkzZmVmLi43NjE4OTI4MzEwNGMgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTky
ZWUvaHcuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRs
ODE5MmVlL2h3LmMNCj4gQEAgLTE0MzAsNyArMTQzMCw3IEBAIHN0YXRpYyBlbnVtIHZlcnNpb25f
ODE5MmUgX3J0bDkyZWVfcmVhZF9jaGlwX3ZlcnNpb24oc3RydWN0IGllZWU4MDIxMV9odw0KPiAq
aHcpDQo+ICB7DQo+ICAJc3RydWN0IHJ0bF9wcml2ICpydGxwcml2ID0gcnRsX3ByaXYoaHcpOw0K
PiAgCXN0cnVjdCBydGxfcGh5ICpydGxwaHkgPSAmcnRscHJpdi0+cGh5Ow0KPiAtCWVudW0gdmVy
c2lvbl84MTkyZSB2ZXJzaW9uID0gVkVSU0lPTl9VTktOT1dOOw0KPiArCWVudW0gdmVyc2lvbl84
MTkyZSB2ZXJzaW9uOw0KPiAgCXUzMiB2YWx1ZTMyOw0KPiANCj4gIAlydGxwaHktPnJmX3R5cGUg
PSBSRl8yVDJSOw0KPiAtLQ0KPiAyLjMyLjANCj4gDQo+IC0tLS0tLVBsZWFzZSBjb25zaWRlciB0
aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0KDQoNCkFja2VkLWJ5
OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KDQo=
