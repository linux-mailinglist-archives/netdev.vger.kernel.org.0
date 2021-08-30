Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699CD3FAFAC
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 04:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbhH3CCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 22:02:02 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:48675 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbhH3CCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 22:02:01 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 17U20muI6026661, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 17U20muI6026661
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Aug 2021 10:00:48 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 30 Aug 2021 10:00:47 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 30 Aug 2021 10:00:46 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Mon, 30 Aug 2021 10:00:46 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] rtlwifi: rtl8192de: Fix uninitialized variable place
Thread-Topic: [PATCH][next] rtlwifi: rtl8192de: Fix uninitialized variable
 place
Thread-Index: AQHXnQBql2HJfhVS0UOTvovudWzUtauLSmYw
Date:   Mon, 30 Aug 2021 02:00:46 +0000
Message-ID: <9f09efe170cb450aa7a1927af58f005e@realtek.com>
References: <20210829180503.533934-1-colin.king@canonical.com>
In-Reply-To: <20210829180503.533934-1-colin.king@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzgvMjkg5LiL5Y2IIDExOjE4OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/30/2021 01:49:33
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165836 [Aug 29 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 457 457 f9912fc467375383fbac52a53ade5bbe1c769e2a
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;patchwork.kernel.org:7.1.1;127.0.0.199:7.1.2;realtek.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/30/2021 01:51:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbGluIEtpbmcgW21haWx0
bzpjb2xpbi5raW5nQGNhbm9uaWNhbC5jb21dDQo+IFNlbnQ6IE1vbmRheSwgQXVndXN0IDMwLCAy
MDIxIDI6MDUgQU0NCj4gVG86IFBrc2hpaDsgS2FsbGUgVmFsbzsgRGF2aWQgUyAuIE1pbGxlcjsg
SmFrdWIgS2ljaW5za2k7IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2
QHZnZXIua2VybmVsLm9yZw0KPiBDYzoga2VybmVsLWphbml0b3JzQHZnZXIua2VybmVsLm9yZzsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0hdW25leHRdIHJ0
bHdpZmk6IHJ0bDgxOTJkZTogRml4IHVuaW5pdGlhbGl6ZWQgdmFyaWFibGUgcGxhY2UNCj4gDQo+
IEZyb206IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiBJ
biB0aGUgY2FzZSB3aGVyZSBjaG5sIDw9IDE0IHZhcmlhYmxlIHBsYWNlIGlzIG5vdCBpbml0aWFs
aXplZCBhbmQNCj4gdGhlIGZ1bmN0aW9uIHJldHVybnMgYW4gdW5pbml0aWFsaXplZCB2YWx1ZS4g
VGhpcyBmaXhlcyBhbiBlYXJsaWVyDQo+IGNsZWFudXAgd2hlcmUgSSBpbnRyb2R1Y2VkIHRoaXMg
YnVnLiBNeSBiYWQuDQo+IA0KPiBBZGRyZXNzZXMtQ292ZXJpdHk6ICgiVW5pbml0aWFsaXplZCBz
Y2FsYXIgdmFyaWFibGUiKQ0KPiBGaXhlczogMzY5OTU2YWU1NzIwICgicnRsd2lmaTogcnRsODE5
MmRlOiBSZW1vdmUgcmVkdW5kYW50IHZhcmlhYmxlIGluaXRpYWxpemF0aW9ucyIpDQo+IFNpZ25l
ZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IC0t
LQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxOTJkZS9waHku
YyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lm
aS9ydGw4MTkyZGUvcGh5LmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvcnRsODE5MmRlL3BoeS5jDQo+IGluZGV4IDhhZTY5ZDkxNDMxMi4uYjMyZmE3YTc1ZjE3IDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5
MmRlL3BoeS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9y
dGw4MTkyZGUvcGh5LmMNCj4gQEAgLTg5Niw3ICs4OTYsNyBAQCBzdGF0aWMgdm9pZCBfcnRsOTJk
X2NjeHBvd2VyX2luZGV4X2NoZWNrKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KPiANCj4gIHN0
YXRpYyB1OCBfcnRsOTJjX3BoeV9nZXRfcmlnaHRjaG5scGxhY2UodTggY2hubCkNCj4gIHsNCj4g
LQl1OCBwbGFjZTsNCj4gKwl1OCBwbGFjZSA9IGNobmw7DQo+IA0KPiAgCWlmIChjaG5sID4gMTQp
IHsNCj4gIAkJZm9yIChwbGFjZSA9IDE0OyBwbGFjZSA8IHNpemVvZihjaGFubmVsNWcpOyBwbGFj
ZSsrKSB7DQoNCk5hdGhhbiBDaGFuY2VsbG9yIGhhcyBzZW50IGEgcGF0Y2ggWzFdIHRvIGZpeCB0
aGlzLCBhbmQgdGhlIHBhdGNoIA0KaGFzIGJlZW4gbWVyZ2VkLg0KDQpbMV0gaHR0cHM6Ly9wYXRj
aHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LXdpcmVsZXNzL3BhdGNoLzIwMjEwODIzMjIy
MDE0Ljc2NDU1Ny0xLW5hdGhhbkBrZXJuZWwub3JnLw0KDQotLQ0KUGluZy1LZQ0KDQo=
