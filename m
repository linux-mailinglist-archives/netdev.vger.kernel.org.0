Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C66658C40
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 12:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiL2LgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 06:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiL2LgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 06:36:18 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 021BD10BF;
        Thu, 29 Dec 2022 03:36:17 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BTBZ5l94031187, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BTBZ5l94031187
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 29 Dec 2022 19:35:05 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 29 Dec 2022 19:35:59 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 29 Dec 2022 19:35:59 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 29 Dec 2022 19:35:59 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Topic: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Index: AQHZGsFtJHlbRNsmYUOpTa0F4ufSPq6EmMng//+OnoCAABBdgA==
Date:   Thu, 29 Dec 2022 11:35:59 +0000
Message-ID: <a04c0a270ca095495e24af6950a462142aa199b8.camel@realtek.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
         <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
         <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
         <CAFBinCBKuTsK21CxEhth5js4Quyy0iUg6ctZwEQwwarePgghaQ@mail.gmail.com>
In-Reply-To: <CAFBinCBKuTsK21CxEhth5js4Quyy0iUg6ctZwEQwwarePgghaQ@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.22.50]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzI5IOS4iuWNiCAwNzoyNTowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <2951F09D4012FF4B97A1C877A34719AF@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTI5IGF0IDExOjM3ICswMTAwLCBNYXJ0aW4gQmx1bWVuc3RpbmdsIHdy
b3RlOg0KPiBIaSBQaW5nLUtlLA0KPiANCj4gT24gVGh1LCBEZWMgMjksIDIwMjIgYXQgMTA6MjUg
QU0gUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiBbLi4uXQ0KPiA+
ID4gQEAgLTQzLDEzICs0MywxMyBAQCBzdHJ1Y3QgcnR3ODgyMWNlX2VmdXNlIHsNCj4gPiA+ICAg
ICAgIHU4IGxpbmtfY2FwWzRdOw0KPiA+ID4gICAgICAgdTggbGlua19jb250cm9sWzJdOw0KPiA+
ID4gICAgICAgdTggc2VyaWFsX251bWJlcls4XTsNCj4gPiA+IC0gICAgIHU4IHJlczA6MjsgICAg
ICAgICAgICAgICAgICAgICAgLyogMHhmNCAqLw0KPiA+ID4gLSAgICAgdTggbHRyX2VuOjE7DQo+
ID4gPiAtICAgICB1OCByZXMxOjI7DQo+ID4gPiAtICAgICB1OCBvYmZmOjI7DQo+ID4gPiAtICAg
ICB1OCByZXMyOjM7DQo+ID4gPiAtICAgICB1OCBvYmZmX2NhcDoyOw0KPiA+ID4gLSAgICAgdTgg
cmVzMzo0Ow0KPiA+ID4gKyAgICAgdTE2IHJlczA6MjsgICAgICAgICAgICAgICAgICAgICAvKiAw
eGY0ICovDQo+ID4gPiArICAgICB1MTYgbHRyX2VuOjE7DQo+ID4gPiArICAgICB1MTYgcmVzMToy
Ow0KPiA+ID4gKyAgICAgdTE2IG9iZmY6MjsNCj4gPiA+ICsgICAgIHUxNiByZXMyOjM7DQo+ID4g
PiArICAgICB1MTYgb2JmZl9jYXA6MjsNCj4gPiA+ICsgICAgIHUxNiByZXMzOjQ7DQo+ID4gDQo+
ID4gVGhlc2Ugc2hvdWxkIGJlIF9fbGUxNi4gVGhvdWdoIGJpdCBmaWVsZHMgYXJlIHN1aXRhYmxl
IHRvIGVmdXNlIGxheW91dCwNCj4gPiB3ZSBkb24ndCBhY2Nlc3MgdGhlc2UgZmllbGRzIGZvciBu
b3cuIEl0IHdvdWxkIGJlIHdlbGwuDQo+IE15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCBpdCBzaG91
bGQgbG9vayBsaWtlIHRoaXMgKHJlcGxhY2luZyBhbGwgb2YgcmVzMC4ucmVzMyk6DQo+ICAgICBf
X2xlMTYgc29tZV9maWVsZF9uYW1lOyAgICAgICAgICAgICAgICAgICAgIC8qIDB4ZjQgKi8NCj4g
SG93IHRvIGNhbGwgdGhhdCBzaW5nbGUgX19sZTE2IGZpZWxkIHRoZW4/DQoNCllvdSBhcmUgcmln
aHQuIE1heWJlLCB3ZSBjYW4gbmFtZSBpdCAncGNpZV9jYXAnLg0KQnV0LCB3ZSBkb24ndCB1c2Ug
dGhlbSBmb3Igbm93LCBzbyBpdCBpcyBoYXJtbGVzcyB0byBwcmVzZXJ2ZSB0aGVtIGFzIGlzLiAN
Cg0KDQo+IA0KPiBJIGFsc28gdHJpZWQgdXNpbmcgYml0LWZpZWxkcyBmb3IgYW4gX19sZTE2IChz
byBiYXNpY2FsbHkgdGhlIHNhbWUgYXMNCj4gbXkgcGF0Y2ggYnV0IHVzaW5nIF9fbGUxNiBpbnN0
ZWFkIG9mIHUxNikgYnV0IHRoYXQgbWFrZXMgc3BhcnNlDQo+IGNvbXBsYWluOg0KPiAgIGVycm9y
OiBpbnZhbGlkIGJpdGZpZWxkIHNwZWNpZmllciBmb3IgdHlwZSByZXN0cmljdGVkIF9fbGUxNg0K
PiANCj4gDQoNCldlIGNhbiBmaXggaXQgYnk6IA0KDQogICAgICB1OCByZXMwOjI7ICAgICAgICAg
ICAgICAgICAgICAgIC8qIDB4ZjQgKi8NCiAgICAgIHU4IGx0cl9lbjoxOw0KICAgICAgdTggcmVz
MToyOw0KICAgICAgdTggb2JmZjoyOw0KLSAgICAgdTggcmVzMjozOw0KKyAgICAgdTggcmVzMl8x
OjE7DQorICAgICB1OCByZXMyXzI6MjsNCiAgICAgIHU4IG9iZmZfY2FwOjI7DQogICAgICB1OCBy
ZXMzOjQ7DQoNCkknbSBub3Qgc3VyZSB3aHkgcGVvcGxlIG1lcmdlIGJpdCBmaWVsZHMgcmVzMl8x
OjEgYW5kIHJlczJfMjoyIHRoYXQNCnNob3VsZCBiZSBpbiBkaWZmZXJlbnQgdTguIEkgaGF2ZSBj
b25maXJtZWQgdGhpcyB3aXRoIGludGVybmFsIGRhdGEuDQoNCi0tDQpQaW5nLUtlDQoNCg==
