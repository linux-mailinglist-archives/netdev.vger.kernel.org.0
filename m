Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8027E3BB9B5
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 10:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhGEJBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 05:01:47 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:46623 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhGEJBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 05:01:46 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1658wqKV3029644, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1658wqKV3029644
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 5 Jul 2021 16:58:52 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 5 Jul 2021 16:58:52 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 5 Jul 2021 16:58:51 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::a0a3:e64a:34ad:fe28]) by
 RTEXMBS04.realtek.com.tw ([fe80::a0a3:e64a:34ad:fe28%5]) with mapi id
 15.01.2106.013; Mon, 5 Jul 2021 16:58:51 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Brian Norris <briannorris@chromium.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: RE: [PATCH 04/24] rtw89: add debug files
Thread-Topic: [PATCH 04/24] rtw89: add debug files
Thread-Index: AQHXZA3L/KWeN+OUEEWYUAFkKlwvy6su1/4AgACjqICAAA2hAIAAC2QAgAQ53oA=
Date:   Mon, 5 Jul 2021 08:58:51 +0000
Message-ID: <f74caecfafa6479abe09bede01e801ec@realtek.com>
References: <20210618064625.14131-1-pkshih@realtek.com>
 <20210618064625.14131-5-pkshih@realtek.com>
 <20210702072308.GA4184@pengutronix.de>
 <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
 <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de>
 <CA+ASDXP0_Y1x_1OixJFWDCeZX3txV+xbwXcXfTbw1ZiGjSFiCQ@mail.gmail.com>
In-Reply-To: <CA+ASDXP0_Y1x_1OixJFWDCeZX3txV+xbwXcXfTbw1ZiGjSFiCQ@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvNSDkuIrljYggMDQ6MjM6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/05/2021 08:44:49
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164833 [Jul 05 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_exist}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/05/2021 08:48:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJyaWFuIE5vcnJpcyBbbWFp
bHRvOmJyaWFubm9ycmlzQGNocm9taXVtLm9yZ10NCj4gU2VudDogU2F0dXJkYXksIEp1bHkgMDMs
IDIwMjEgMjozOCBBTQ0KPiBUbzogT2xla3NpaiBSZW1wZWwNCj4gQ2M6IFBrc2hpaDsgS2FsbGUg
VmFsbzsgbGludXgtd2lyZWxlc3M7IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgU2FzY2hhIEhh
dWVyDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMDQvMjRdIHJ0dzg5OiBhZGQgZGVidWcgZmlsZXMN
Cj4gDQo+IE9uIEZyaSwgSnVsIDIsIDIwMjEgYXQgMTA6NTcgQU0gT2xla3NpaiBSZW1wZWwgPG8u
cmVtcGVsQHBlbmd1dHJvbml4LmRlPiB3cm90ZToNCj4gPiBPbiBGcmksIEp1bCAwMiwgMjAyMSBh
dCAxMDowODo1M0FNIC0wNzAwLCBCcmlhbiBOb3JyaXMgd3JvdGU6DQo+ID4gPiBPbiBGcmksIEp1
bCAyLCAyMDIxIGF0IDEyOjIzIEFNIE9sZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRyb25p
eC5kZT4gd3JvdGU6DQo+ID4gPiA+IEZvciBkeW5hbWljIGRlYnVnZ2luZyB3ZSB1c3VhbGx5IHVz
ZSBldGh0b29sIG1zZ2x2bC4NCj4gPiA+ID4gUGxlYXNlLCBjb252ZXJ0IGFsbCBkZXZfZXJyL3dh
cm4vaW5mLi4uLiB0byBuZXRpZl8gY291bnRlcnBhcnRzDQo+ID4gPg0KPiA+ID4gSGF2ZSB5b3Ug
ZXZlciBsb29rZWQgYXQgYSBXaUZpIGRyaXZlcj8NCj4gPg0KPiA+IFllcy4gWW91IGNhbiBwYXJz
ZSB0aGUga2VybmVsIGxvZyBmb3IgbXkgY29tbWl0cy4NCj4gDQo+IE9LISBTbyBJIHNlZSB5b3Un
dmUgdG91Y2hlZCBhIGxvdCBvZiBhdGg5aywgPjMgeWVhcnMgYWdvLiBZb3UgbWlnaHQNCj4gbm90
aWNlIHRoYXQgaXQgaXMgb25lIHN1Y2ggZXhhbXBsZSAtLSBpdCBzdXBwb3J0cyBleGFjdGx5IHRo
ZSBzYW1lDQo+IGtpbmQgb2YgZGVidWdmcyBmaWxlLCB3aXRoIGEgc2V0IG9mIGF0aF9kYmcoKSBs
b2cgdHlwZXMuIFdoeSBkb2Vzbid0DQo+IGl0IHVzZSB0aGlzIG5ldGlmIGRlYnVnIGxvZ2dpbmc/
DQo+IA0KPiA+ID4gSSBoYXZlbid0IHNlZW4gYSBzaW5nbGUgb25lIHRoYXQgdXNlcyBuZXRpZl8q
KCkgZm9yIGxvZ2dpbmcuDQo+ID4gPiBPbiB0aGUgb3RoZXIgaGFuZCwgYWxtb3N0IGV2ZXJ5DQo+
ID4gPiBzaW5nbGUgb25lIGhhcyBhIHNpbWlsYXIgbW9kdWxlIHBhcmFtZXRlciBvciBkZWJ1Z2Zz
IGtub2IgZm9yIGVuYWJsaW5nDQo+ID4gPiBkaWZmZXJlbnQgdHlwZXMgb2YgZGVidWcgbWVzc2Fn
ZXMuDQo+ID4gPg0KPiA+ID4gQXMgaXQgc3RhbmRzLCB0aGUgTkVUSUZfKiBjYXRlZ29yaWVzIGRv
bid0IHJlYWxseSBhbGlnbiBhdCBhbGwgd2l0aA0KPiA+ID4gdGhlIGtpbmRzIG9mIG1lc3NhZ2Ug
Y2F0ZWdvcmllcyBtb3N0IFdpRmkgZHJpdmVycyBzdXBwb3J0LiBEbyB5b3UNCj4gPiA+IHByb3Bv
c2UgYWRkaW5nIGEgYnVuY2ggb2YgbmV3IG9wdGlvbnMgdG8gdGhlIG5ldGlmIGRlYnVnIGZlYXR1
cmU/DQo+ID4NCj4gPiBXaHkgbm90PyBJdCBtYWtlIG5vIHNlbnNlIG9yIGl0IGlzIGp1c3QgIml0
IGlzIHRyYWRpdGlvbiwgd2UgbmV2ZXIgZG8NCj4gPiBpdCEiID8NCj4gDQo+IFdlbGwgbWFpbmx5
LCBJIGRvbid0IHJlYWxseSBsaWtlIHBlb3BsZSBkcmVhbWluZyB1cCBhcmJpdHJhcnkgcnVsZXMN
Cj4gYW5kIGVuZm9yY2luZyB0aGVtIG9ubHkgb24gbmV3IHN1Ym1pc3Npb25zLiBJZiBzdWNoIGEg
Y2hhbmdlIHdhcw0KPiBSZWNvbW1lbmRlZCwgaXQgc2VlbXMgbGlrZSBhIGJldHRlciBmaXJzdCBz
dGVwIHdvdWxkIGJlIHRvIHByb3ZlIHRoYXQNCj4gZXhpc3RpbmcgZHJpdmVycyAod2hlcmUgdGhl
cmUgYXJlIG51bWVyb3VzIGV4YW1wbGVzKSBjYW4gYmUgY29udmVydGVkDQo+IG5pY2VseSwgaW5z
dGVhZCBvZiBwdXNoaW5nIHRoZSB3b3JrIHRvIG5ldyBjb250cmlidXRvcnMgYXJiaXRyYXJpbHku
DQo+IE90aGVyd2lzZSwgdGhlIGJhciBmb3IgbmV3IGNvbnRyaWJ1dGlvbnMgZ2V0cyBleGNlZWRp
bmdseSBoaWdoIC0tIHRoaXMNCj4gb25lIGhhcyBhbHJlYWR5IHNhdCBmb3IgbW9yZSB0aGFuIDYg
bW9udGhzIHdpdGggZGVwcmVzc2luZ2x5IGxpdHRsZQ0KPiB1c2VmdWwgZmVlZGJhY2suDQo+IA0K
PiBJIGFsc28ga25vdyB2ZXJ5IGxpdHRsZSBhYm91dCB0aGlzIG5ldGlmIGxvZyBsZXZlbCBmZWF0
dXJlLCBidXQgaWYgaXQNCj4gcmVhbGx5IGRlcGVuZHMgb24gZXRodG9vbCAoc2VlbXMgbGlrZSBp
dCBkb2VzPykgLS0gSSBkb24ndCBldmVuIGJvdGhlcg0KPiBpbnN0YWxsaW5nIGV0aHRvb2wgb24g
bW9zdCBvZiBteSBzeXN0ZW1zLiBJdCdzIG11Y2ggZWFzaWVyIHRvIHBva2UgYXQNCj4gZGVidWdm
cywgc3lzZnMsIGV0Yy4sIHRoYW4gdG8gY29uc3RydWN0IHRoZSByZWxldmFudCBldGh0b29sIGlv
Y3RsKClzDQo+IG9yIG5ldGxpbmsgbWVzc2FnZXMuIEl0IGFsc28gc2VlbXMgdGhhdCB0aGVzZSBk
ZWJ1ZyBrbm9icyBjYW4ndCBiZSBzZXQNCj4gYmVmb3JlIHRoZSBkcml2ZXIgZmluaXNoZXMgY29t
aW5nIHVwLCBzbyBvbmUgd291bGQgc3RpbGwgbmVlZCBhIG1vZHVsZQ0KPiBwYXJhbWV0ZXIgdG8g
bWlycm9yIHNvbWUgb2YgdGhlIHNhbWUgZmVhdHVyZXMuIEFkZGl0aW9uYWxseSwgYSBXaUZpDQo+
IGRyaXZlciBkb2Vzbid0IGV2ZW4gaGF2ZSBhIG5ldGRldiB0byBzcGVhayBvZiB1bnRpbCBhZnRl
ciBhIGxvdCBvZiB0aGUNCj4gaW50ZXJlc3Rpbmcgc3R1ZmYgY29tZXMgdXAgKG11Y2ggb2YgdGhl
IG1hYzgwMjExIGZyYW1ld29yayBmb2N1c2VzIG9uDQo+IGEgfHN0cnVjdCBpZWVlODAyMTFfaHd8
IGFuZCBhIHxzdHJ1Y3Qgd2lwaHl8KSwgc28gSSdtIG5vdCBzdXJlIHlvdXINCj4gc3VnZ2VzdGlv
biByZWFsbHkgZml0cyB0aGVzZSBzb3J0cyBvZiBkcml2ZXJzIChhbmQgdGhlIHRoaW5ncyB0aGV5
DQo+IG1pZ2h0IGxpa2UgdG8gc3VwcG9ydCBkZWJ1Zy1sb2dnaW5nIGZvcikgYXQgYWxsLg0KPiAN
Cj4gQW55d2F5LCBpZiBQaW5nLUtlIHdhbnRzIHRvIHBhaW50IHRoaXMgYmlrZXNoZWQgZm9yIHlv
dSwgSSB3b24ndCBzdG9wIGhpbS4NCg0KSSBlbmNvdW50ZXIgdGhlIHByb2JsZW1zIHlvdSBtZW50
aW9uZWQgbW9zdGx5Og0KMS4gbm8gbmV0ZGV2IHRvIGJlIHRoZSBwYXJhbWV0ZXIgJ2Rldicgb2Yg
J25ldGlmX2RiZyhwcml2LCB0eXBlLCBkZXYsIGZvcm1hdCwgYXJncy4uLiknDQoyLiBwcmVkZWZp
bmVkICd0eXBlJyBpc24ndCBlbm91Z2ggZm9yIHdpZmkgYXBwbGljYXRpb24uIFRoZXJlJ3JlIG1h
bnkgd2lmaS0gb3IgdmVuZG9yLQ0KICAgc3BlY2lmaWMgY29tcG9uZW50cywgc3VjaCBhcyBSRiBj
YWxpYnJhdGlvbiwgQlQgY29leGlzdGVuY2UsIERJRywgQ0ZPIGFuZCBzbyBvbi4NCg0KU28sIEkg
ZG9uJ3QgcGxhbiB0byBjaGFuZ2UgdGhlbSBmb3Igbm93Lg0KDQotLQ0KUGluZy1LZQ0KDQoNCg==
