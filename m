Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293DB65E256
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 02:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjAEBNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 20:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjAEBNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 20:13:05 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BEC72F7B1;
        Wed,  4 Jan 2023 17:13:04 -0800 (PST)
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3050tK461028570, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3050tK461028570
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 5 Jan 2023 08:55:20 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 5 Jan 2023 08:56:16 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 5 Jan 2023 08:56:16 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 5 Jan 2023 08:56:16 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        David Laight <David.Laight@aculab.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Topic: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Index: AQHZGsFtJHlbRNsmYUOpTa0F4ufSPq6EmMnggAOg+qCAALbHgIAAiEwg//+P14CABN6NgIAABnmAgAAEBACAAAa7gIAAFZaAgAD7MIA=
Date:   Thu, 5 Jan 2023 00:56:15 +0000
Message-ID: <27e2909a0bc94177af1afe56da618fba@realtek.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
 <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
 <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
 <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
 <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com>
 <5c0c77240e7ddfdffbd771ee7e50d36ef3af9c84.camel@realtek.com>
 <CAFBinCC+1jGJx1McnBY+kr3RTQ-UpxW6JYNpHzStUTredDuCug@mail.gmail.com>
 <ec6a0988f3f943128e0122d50959185a@AcuMS.aculab.com>
 <CAFBinCC9sNvQJcu-SOSrFmo4sCx29K6KwXnc-O6MX9TJEHtXYg@mail.gmail.com>
 <662e2f820e7a478096dd6e09725c093a@AcuMS.aculab.com>
 <CAFBinCCTa47SRjNHbMB3t2zjiE5Vh1ZQrgT3G38g9g_-mzvh6w@mail.gmail.com>
In-Reply-To: <CAFBinCCTa47SRjNHbMB3t2zjiE5Vh1ZQrgT3G38g9g_-mzvh6w@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvNCDkuIvljYggMTE6Mjg6MDA=?=
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

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcnRpbiBCbHVtZW5zdGlu
Z2wgPG1hcnRpbi5ibHVtZW5zdGluZ2xAZ29vZ2xlbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5
LCBKYW51YXJ5IDUsIDIwMjMgMTo0OSBBTQ0KPiBUbzogRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWln
aHRAYWN1bGFiLmNvbT4NCj4gQ2M6IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPjsg
bGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBrdmFsb0BrZXJuZWwub3JnOw0KPiB0ZWh1
YW5nQHJlYWx0ZWsuY29tOyBzLmhhdWVyQHBlbmd1dHJvbml4LmRlOyB0b255MDYyMGVtbWFAZ21h
aWwuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS80XSBydHc4ODogQWRkIHBhY2tlZCBhdHRy
aWJ1dGUgdG8gdGhlIGVGdXNlIHN0cnVjdHMNCj4gDQo+IE9uIFdlZCwgSmFuIDQsIDIwMjMgYXQg
NTozMSBQTSBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBhY3VsYWIuY29tPiB3cm90ZToNCj4g
Wy4uLl0NCj4gPiA+ID4gV2hhdCB5b3UgbWF5IHdhbnQgdG8gZG8gaXMgYWRkIGNvbXBpbGUtdGlt
ZSBhc3NlcnRzIGZvciB0aGUNCj4gPiA+ID4gc2l6ZXMgb2YgdGhlIHN0cnVjdHVyZXMuDQo+ID4g
PiBEbyBJIGdldCB5b3UgcmlnaHQgdGhhdCBzb21ldGhpbmcgbGlrZToNCj4gPiA+ICAgQlVJTERf
QlVHX09OKHNpemVvZihydHc4ODIxY19lZnVzZSkgIT0gMjU2KTsNCj4gPiA+IGlzIHdoYXQgeW91
IGhhdmUgaW4gbWluZD8NCj4gPg0KPiA+IFRoYXQgbG9va3MgbGlrZSB0aGUgb25lLi4uDQo+IEkg
dHJpZWQgdGhpcyAoc2VlIHRoZSBhdHRhY2hlZCBwYXRjaCAtIGl0J3MganVzdCBtZWFudCB0byBz
aG93IHdoYXQgSQ0KPiBkaWQsIGl0J3Mgbm90IG1lYW50IHRvIGJlIGFwcGxpZWQgdXBzdHJlYW0p
Lg0KPiBXaXRoIHRoZSBhdHRhY2hlZCBwYXRjaCBidXQgbm8gb3RoZXIgcGF0Y2hlcyB0aGlzIG1h
a2VzIHRoZSBydHc4OA0KPiBkcml2ZXIgY29tcGlsZSBmaW5lIG9uIDYuMi1yYzIuDQoNCkkgcHJl
ZmVyIHRvIHVzZSBzdGF0aWNfYXNzZXJ0KCkgYmVsb3cgdGhlIHN0cnVjdCBpZiB3ZSByZWFsbHkg
bmVlZCBpdC4NCkluIGZhY3QsIHdlIG9ubHkgbGlzdCBmaWVsZHMgb2YgZWZ1c2UgbWFwIHdlIG5l
ZWQgaW4gdGhlIHN0cnVjdCwgbm90DQpmdWxsIG1hcC4gDQoNCj4gDQo+IEFkZGluZyBfX3BhY2tl
ZCB0byBzdHJ1Y3QgcnR3ODcyM2RfZWZ1c2UgY2hhbmdlcyB0aGUgc2l6ZSBvZiB0aGF0DQo+IHN0
cnVjdCBmb3IgbWUgKEknbSBjb21waWxpbmcgZm9yIEFBcmNoNjQgLyBBUk02NCkuDQo+IFdpdGgg
dGhlIHBhY2tlZCBhdHRyaWJ1dGUgaXQgaGFzIDI2NyBieXRlcywgd2l0aG91dCAyNjggYnl0ZXMu
DQoNClRyeSANCg0Kc3RhdGljX2Fzc2VydChvZmZzZXRvZihzdHJ1Y3QgcnR3ODcyM2RfZWZ1c2Us
IHJmX2FudGVubmFfb3B0aW9uKSA9PSAweGM5KTsNCg0KYW5kIG90aGVyIGZpZWxkcyB0byBiaXNl
Y3Qgd2hpY2ggZmllbGQgZ2V0cyB3cm9uZy4NCg0KUGluZy1LZQ0KDQo=
