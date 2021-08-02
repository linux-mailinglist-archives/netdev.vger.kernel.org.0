Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5D73DD1AB
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhHBIFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:05:07 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:47913 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbhHBIFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 04:05:06 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 17284essE004354, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 17284essE004354
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 2 Aug 2021 16:04:40 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 2 Aug 2021 16:04:39 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 2 Aug 2021 16:04:39 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 2 Aug 2021 16:04:39 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] rtlwifi: rtl8192de:  make arrays static const, makes object smaller
Thread-Topic: [PATCH 2/2] rtlwifi: rtl8192de:  make arrays static const, makes
 object smaller
Thread-Index: AQHXhglPZ/ESYtMDUkW/OHc1Y6F+hatfV8oA
Date:   Mon, 2 Aug 2021 08:04:39 +0000
Message-ID: <3f972eb809700581ff912d3dabd237bcb9708776.camel@realtek.com>
References: <20210731124044.101927-1-colin.king@canonical.com>
         <20210731124044.101927-2-colin.king@canonical.com>
In-Reply-To: <20210731124044.101927-2-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.21.121]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzgvMiDkuIrljYggMDY6MDE6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <DDBC3F7A0DC4AE4CA3D928E0A25A47E1@realtek.com>
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
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gRG9u
J3QgcG9wdWxhdGUgYXJyYXlzIHRoZSBzdGFjayBidXQgaW5zdGVhZCBtYWtlIHRoZW0gc3RhdGlj
IGNvbnN0DQo+IE1ha2VzIHRoZSBvYmplY3QgY29kZSBzbWFsbGVyIGJ5IDg1MiBieXRlcy4NCj4g
DQo+IEJlZm9yZToNCj4gICAgdGV4dAkgICBkYXRhCSAgICBic3MJICAgIGRlYwkgICAgaGV4CWZp
bGVuYW1lDQo+ICAxMjgyMTEJICA0NDI1MAkgICAxMDI0CSAxNzM0ODUJICAyYTVhZAkuLi9yZWFs
dGVrL3J0bHdpZmkvcnQNCj4gbDgxOTJkZS9waHkubw0KPiANCj4gQWZ0ZXI6DQo+ICAgIHRleHQJ
ICAgZGF0YQkgICAgYnNzCSAgICBkZWMJICAgIGhleAlmaWxlbmFtZQ0KPiAgMTI3MTk5CSAgNDQ0
MTAJICAgMTAyNAkgMTcyNjMzCSAgMmEyNTkJLi4vcmVhbHRlay9ydGx3aWZpL3J0DQo+IGw4MTky
ZGUvcGh5Lm8NCj4gDQo+IChnY2MgdmVyc2lvbiAxMC4yLjApDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiAtLS0NCj4gIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyZGUvcGh5LmMgfCA0ICsr
LS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0
bDgxOTJkZS9waHkuYw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9y
dGw4MTkyZGUvcGh5LmMNCj4gaW5kZXggNGVhYTQwZDczYmFmLi43OTk1NjI1NGY3OTggMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyZGUv
cGh5LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgx
OTJkZS9waHkuYw0KPiBAQCAtMTM1NCw3ICsxMzU0LDcgQEAgc3RhdGljIHZvaWQNCj4gX3J0bDky
ZF9waHlfc3dpdGNoX3JmX3NldHRpbmcoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHU4IGNoYW5u
ZWwpDQo+ICANCj4gIHU4IHJ0bDkyZF9nZXRfcmlnaHRjaG5scGxhY2VfZm9yX2lxayh1OCBjaG5s
KQ0KPiAgew0KPiAtCXU4IGNoYW5uZWxfYWxsWzU5XSA9IHsNCj4gKwlzdGF0aWMgY29uc3QgdTgg
Y2hhbm5lbF9hbGxbNTldID0gew0KPiAgCQkxLCAyLCAzLCA0LCA1LCA2LCA3LCA4LCA5LCAxMCwg
MTEsIDEyLCAxMywgMTQsDQo+ICAJCTM2LCAzOCwgNDAsIDQyLCA0NCwgNDYsIDQ4LCA1MCwgNTIs
IDU0LCA1NiwgNTgsDQo+ICAJCTYwLCA2MiwgNjQsIDEwMCwgMTAyLCAxMDQsIDEwNiwgMTA4LCAx
MTAsIDExMiwNCj4gQEAgLTMyMjAsNyArMzIyMCw3IEBAIHZvaWQgcnRsOTJkX3BoeV9jb25maWdf
bWFjcGh5bW9kZV9pbmZvKHN0cnVjdA0KPiBpZWVlODAyMTFfaHcgKmh3KQ0KPiAgdTggcnRsOTJk
X2dldF9jaG5sZ3JvdXBfZnJvbWFycmF5KHU4IGNobmwpDQo+ICB7DQo+ICAJdTggZ3JvdXA7DQo+
IC0JdTggY2hhbm5lbF9pbmZvWzU5XSA9IHsNCj4gKwlzdGF0aWMgY29uc3QgdTggY2hhbm5lbF9p
bmZvWzU5XSA9IHsNCj4gIAkJMSwgMiwgMywgNCwgNSwgNiwgNywgOCwgOSwgMTAsIDExLCAxMiwg
MTMsIDE0LA0KPiAgCQkzNiwgMzgsIDQwLCA0MiwgNDQsIDQ2LCA0OCwgNTAsIDUyLCA1NCwgNTYs
DQo+ICAJCTU4LCA2MCwgNjIsIDY0LCAxMDAsIDEwMiwgMTA0LCAxMDYsIDEwOCwNCj4gLS0gDQo+
IDIuMzEuMQ0KPiANCj4gLS0tLS0tUGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZv
cmUgcHJpbnRpbmcgdGhpcyBlLW1haWwuDQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hp
aEByZWFsdGVrLmNvbT4NCg0KDQo=
