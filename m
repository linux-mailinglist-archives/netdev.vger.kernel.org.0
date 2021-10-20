Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABB8434826
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhJTJso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:48:44 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39147 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhJTJsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 05:48:43 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 19K9kAowD011478, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 19K9kAowD011478
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 20 Oct 2021 17:46:10 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 20 Oct 2021 17:46:10 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 20 Oct 2021 05:46:10 -0400
Received: from RTEXMBS04.realtek.com.tw ([fe80::5cc6:b604:a3b5:9abe]) by
 RTEXMBS04.realtek.com.tw ([fe80::5cc6:b604:a3b5:9abe%5]) with mapi id
 15.01.2308.008; Wed, 20 Oct 2021 17:46:09 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "cgel.zte@gmail.com" <cgel.zte@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "lv.ruyi@zte.com.cn" <lv.ruyi@zte.com.cn>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>
Subject: RE: [PATCH] rtw89: fix error function parameter
Thread-Topic: [PATCH] rtw89: fix error function parameter
Thread-Index: AQHXxJzcl/L9Ey4To0qT1Twz/99G66vbD7qAgAAPjTA=
Date:   Wed, 20 Oct 2021 09:46:09 +0000
Message-ID: <3aa076f0e39a485ca090f8c14682b694@realtek.com>
References: <20211019035311.974706-1-lv.ruyi@zte.com.cn>
 <163471982441.1743.9901035714649893101.kvalo@codeaurora.org>
In-Reply-To: <163471982441.1743.9901035714649893101.kvalo@codeaurora.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEwLzIwIOS4iuWNiCAwNjoxMjowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/20/2021 09:28:46
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 166841 [Oct 20 2021]
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
X-KSE-Antiphishing-Bases: 10/20/2021 09:31:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGt2YWxvPWNvZGVhdXJvcmEu
b3JnQG1nLmNvZGVhdXJvcmEub3JnIDxrdmFsbz1jb2RlYXVyb3JhLm9yZ0BtZy5jb2RlYXVyb3Jh
Lm9yZz4gT24gQmVoYWxmIE9mIEthbGxlDQo+IFZhbG8NCj4gU2VudDogV2VkbmVzZGF5LCBPY3Rv
YmVyIDIwLCAyMDIxIDQ6NTAgUE0NCj4gVG86IGNnZWwuenRlQGdtYWlsLmNvbQ0KPiBDYzogZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBQa3NoaWggPHBrc2hpaEByZWFsdGVr
LmNvbT47IGx2LnJ1eWlAenRlLmNvbS5jbjsNCj4gbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwu
b3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBaZWFsIFJvYm90DQo+IDx6ZWFsY2lAenRlLmNvbS5jbj4NCj4gU3ViamVjdDogUmU6IFtQQVRD
SF0gcnR3ODk6IGZpeCBlcnJvciBmdW5jdGlvbiBwYXJhbWV0ZXINCj4gDQo+IGNnZWwuenRlQGdt
YWlsLmNvbSB3cm90ZToNCj4gDQo+ID4gRnJvbTogTHYgUnV5aSA8bHYucnV5aUB6dGUuY29tLmNu
Pg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBmaXhlcyB0aGUgZm9sbG93aW5nIENvY2NpbmVsbGUgd2Fy
bmluZzoNCj4gPiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg5L3J0dzg4NTJhLmM6
NzUzOg0KPiA+IFdBUk5JTkcgIHBvc3NpYmxlIGNvbmRpdGlvbiB3aXRoIG5vIGVmZmVjdCAoaWYg
PT0gZWxzZSkNCj4gPg0KPiA+IFJlcG9ydGVkLWJ5OiBaZWFsIFJvYm90IDx6ZWFsY2lAenRlLmNv
bS5jbj4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBMdiBSdXlpIDxsdi5ydXlpQHp0ZS5jb20uY24+DQo+
ID4gQWNrZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KPiANCj4gRmFp
bGVkIHRvIGFwcGx5LCBwbGVhc2UgcmViYXNlIG9uIHRvcCBvZiB3aXJlbGVzcy1kcml2ZXJzLW5l
eHQuDQo+IA0KPiBlcnJvcjogcGF0Y2ggZmFpbGVkOiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0dzg5L3J0dzg4NTJhLmM6NzUzDQo+IGVycm9yOiBkcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0dzg5L3J0dzg4NTJhLmM6IHBhdGNoIGRvZXMgbm90IGFwcGx5DQo+IGVycm9yOiBE
aWQgeW91IGhhbmQgZWRpdCB5b3VyIHBhdGNoPw0KPiBJdCBkb2VzIG5vdCBhcHBseSB0byBibG9i
cyByZWNvcmRlZCBpbiBpdHMgaW5kZXguDQo+IGhpbnQ6IFVzZSAnZ2l0IGFtIC0tc2hvdy1jdXJy
ZW50LXBhdGNoJyB0byBzZWUgdGhlIGZhaWxlZCBwYXRjaA0KPiBBcHBseWluZzogcnR3ODk6IGZp
eCBlcnJvciBmdW5jdGlvbiBwYXJhbWV0ZXINCj4gVXNpbmcgaW5kZXggaW5mbyB0byByZWNvbnN0
cnVjdCBhIGJhc2UgdHJlZS4uLg0KPiBQYXRjaCBmYWlsZWQgYXQgMDAwMSBydHc4OTogZml4IGVy
cm9yIGZ1bmN0aW9uIHBhcmFtZXRlcg0KPiANCj4gUGF0Y2ggc2V0IHRvIENoYW5nZXMgUmVxdWVz
dGVkLg0KPiANCg0KSSB0aGluayB0aGlzIGlzIGJlY2F1c2UgdGhlIHBhdGNoIGlzIHRyYW5zbGF0
ZWQgaW50byBzcGFjZXMgaW5zdGVhZCBvZiB0YWJzLCANCmluIHRoaXMgYW5kIGZvbGxvd2luZyBz
dGF0ZW1lbnRzLg0KIiAgICAgICAgICAgICAgICBpZiAoaXNfMmcpIg0KDQotLQ0KUGluZy1LZQ0K
DQoNCg==
