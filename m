Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDAD465938D
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 01:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiL3AHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 19:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiL3AHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 19:07:01 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38D7E12AEB;
        Thu, 29 Dec 2022 16:07:00 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BU05qhyE007943, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BU05qhyE007943
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 30 Dec 2022 08:05:52 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Fri, 30 Dec 2022 08:06:46 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 30 Dec 2022 08:06:46 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Fri, 30 Dec 2022 08:06:46 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>
CC:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "macroalpha82@gmail.com" <macroalpha82@gmail.com>,
        "jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
        "nitin.gupta981@gmail.com" <nitin.gupta981@gmail.com>
Subject: Re: [RFC PATCH v1 00/19] rtw88: Add SDIO support
Thread-Topic: [RFC PATCH v1 00/19] rtw88: Add SDIO support
Thread-Index: AQHZGks+1Xp5+2HTNk6lcrww/IAcmq6EK72QgADRVICAAA1igA==
Date:   Fri, 30 Dec 2022 00:06:46 +0000
Message-ID: <a681e5a2b660be3de96985628f1ab3a8acfa593f.camel@realtek.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
         <8fe9b10318994be18934ec41e792af56@realtek.com>
         <CAFBinCBcurqiHJRSyaFpweYmrgaaUhpy632QQNWcrd3UHRtZbQ@mail.gmail.com>
In-Reply-To: <CAFBinCBcurqiHJRSyaFpweYmrgaaUhpy632QQNWcrd3UHRtZbQ@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.22.50]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzI5IOS4i+WNiCAxMDozODowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <424B7CB421765E4AB163B8D90C048094@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTEyLTMwIGF0IDAwOjE4ICswMTAwLCBNYXJ0aW4gQmx1bWVuc3RpbmdsIHdy
b3RlOg0KPiBIaSBQaW5nLUtlLA0KPiANCj4gdGhhbmtzIGFnYWluIGZvciBhbGwgeW91ciBpbnB1
dCENCj4gDQo+IE9uIFRodSwgRGVjIDI5LCAyMDIyIGF0IDU6MTkgQU0gUGluZy1LZSBTaGloIDxw
a3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiBbLi4uXQ0KPiA+ID4gLSBSWCB0aHJvdWdocHV0
IG9uIGEgNUdIeiBuZXR3b3JrIGlzIGF0IDE5IE1iaXQvcw0KPiA+IA0KPiA+IEkgaGF2ZSBhIHN1
Z2dlc3Rpb24gYWJvdXQgUlggdGhyb3VnaHB1dCwgcGxlYXNlIGNoZWNrIGJlbG93IHJlZ2lzdGVy
cyB3aXRoDQo+ID4gdmVuZG9yIGRyaXZlcjoNCj4gPiANCj4gPiBSRUdfUlhETUFfQUdHX1BHX1RI
DQo+ID4gUkVHX1RYRE1BX1BRX01BUCgweDEwYykgQklUX1JYRE1BX0FHR19FTiAoYml0MikNCj4g
PiBSRUdfUlhETUFfTU9ERSgwMjkwKSAgQklUX0RNQV9NT0RFIChiaXQxKQ0KPiBVbmZvcnR1bmF0
ZWx5IEkgZGlkbid0IG1hbmFnZSB0byBnZXQgdGhlIHZlbmRvciBkcml2ZXIgdG8gd29yayB3aXRo
DQo+IG1haW5saW5lIExpbnV4Lg0KPiBUaGUgQW5kcm9pZCBpbnN0YWxsYXRpb24gb24gbXkgYm9h
cmQgKHdoaWNoIGlzIGhvdyBpdCB3YXMgc2hpcHBlZCkNCj4gdXNlcyB0aGUgdmVuZG9yIGRyaXZl
ciBidXQgdW5saWtlIHNvbWUgQW1sb2dpYyBjb2RlIHRoZSBSZWFsdGVrDQo+ICh2ZW5kb3IpIHdp
cmVsZXNzIGRyaXZlciBkb2VzIG5vdCBhbGxvdyByZWFkaW5nIGFyYml0cmFyeSByZWdpc3RlcnMN
Cj4gdGhyb3VnaCBzeXNmcy4NCj4gU28gSSBjYW4ndCBjaGVjayB0aGUgdmFsdWVzIHRoYXQgdGhl
IHZlbmRvciBkcml2ZXIgdXNlcy4NCj4gDQo+ID4gVHJ5IHRvIGFkanVzdCBBR0dfUEdfVEggdG8g
c2VlIGlmIGl0IGNhbiBoZWxwLg0KPiBJIHRyaWVkIGEgZmV3IHZhbHVlcyBhbmQgSSBjYW4gc2F5
IHRoYXQgaXQgZG9lcyBjaGFuZ2UgdGhlIFJYDQo+IHRocm91Z2hwdXQsIGJ1dCB0aGUgcmVzdWx0
IGlzIGFsd2F5cyBsb3dlciB0aGFuIDE5IE1iaXQvcywgbWVhbmluZw0KPiB0aGF0IGl0J3Mgd29y
c2UgdGhhbiBSWCBhZ2dyZWdhdGlvbiBkaXNhYmxlZCAob24gbXkgUlRMODgyMkNTKS4NCj4gQ3Vy
cmVudGx5IHdlJ3JlIGRpc2FibGluZyBSWCBhZ2dyZWdhdGlvbiBpbiB0aGUgZHJpdmVyLiBCdXQg
SmVybmVqDQo+IG1lbnRpb25lZCBwcmV2aW91c2x5IHRoYXQgZm9yIGhpcyBSVEw4ODIyQlMgaGUg
Zm91bmQgdGhhdCBSWA0KPiBhZ2dyZWdhdGlvbiBzZWVtcyB0byBpbXByb3ZlIHBlcmZvcm1hbmNl
Lg0KPiANCj4gSW5kZXBlbmRlbnQgb2YgdGhpcyBJIGRpZCBzb21lIGludmVzdGlnYXRpb24gb24g
bXkgb3duIGFuZCBmb3VuZCB0aGF0DQo+IHdoZW4gcmVkdWNpbmcgdGhlIFRYIHRocm91Z2hwdXQg
dGhlIFJYIHRocm91Z2hwdXQgaW5jcmVhc2VzLg0KPiBGb3IgdGhpcyBJIHRyaWVkIHVzaW5nIGll
ZWU4MDIxMV97c3RvcCx3YWtlfV9xdWV1ZSgpIGluIHRoZSBzZGlvLmMgSENJDQo+IHN1Yi1kcml2
ZXIuDQo+IFJYIHRocm91Z2hwdXQgaXMgbm93IGF0IDIzLjUgTWJpdC9zICh0aGF0ICsyNSUgY29t
cGFyZWQgdG8gYmVmb3JlKSBvbg0KPiBteSBSVEw4ODIyQ1MgKHdpdGggUlggYWdncmVnYXRpb24g
c3RpbGwgZGlzYWJsZWQsIGp1c3QgbGlrZSBpbiB0aGUgMTkNCj4gTWJpdC9zIHRlc3QpLg0KPiBV
bmZvcnR1bmF0ZWx5IFRYIHRocm91Z2hwdXQgaXMgbm93IHdheSBiZWxvdyAxMCBNYml0L3MuDQo+
IA0KPiBBZGRpdGlvbmFsbHkgSSB0aGluayB0aGF0IHRoZSBhbnRlbm5hIG9mIG15IGJvYXJkIGlz
IHdvcnNlIHRoYW4gbXkNCj4gYWNjZXNzIHBvaW50J3MgYW50ZW5uYS4gU28gVFggZnJvbSBydHc4
OCB0byBteSBBUCBtYXkgYmUgZmFzdGVyDQo+IChiZWNhdXNlIHRoZSBBUCBjYW4gImhlYXIgYmV0
dGVyIikgdGhhbiBSWCAocnR3ODggImhlYXJpbmcgaXMgd29yc2UiKS4NCj4gDQoNCldpdGhvdXQg
ZXF1aXBtZW50IGxpa2UgQ0FULUMsIGl0IGlzIGhhcmQgdG8gaW52ZXN0aWdhdGUgU0RJTyB1c2IN
CmFnZ3JlZ2F0aW9uLCBzbyBJIHN1Z2dlc3QgdG8gY2FwdHVyZSBXaUZpIHBhY2tldHMgaW4gdGhl
IGFpciB0byBtYWtlDQpzdXJlIHRoaW5ncyB3b3JrIGFzIGV4cGVjdGVkLiBBZnRlciB0aGF0LCB3
ZSBjYW4gZm9jdXMgb24gYnVzDQphZ2dyZWdhdGlvbiB0dW5pbmcuDQoNClRoZSBpbnN0cnVjdGlv
bnMgdG8gdXNlIGFub3RoZXIgV2lGaSBjYXJkIHRvIGNhcHR1cmUgcGFja2V0cyBhcmU6DQoxLiBz
dWRvIGl3IGRldiB3bGFuMCBpbnRlcmZhY2UgYWRkIG1vbjAgdHlwZSBtb25pdG9yDQoyLiBzdWRv
IHdpcmVzaGFyayAgLy8gc2VsZWN0IG1vbjAgdG8gY2FwdHVyZQ0KDQpQbGVhc2UgY2hlY2sgQU1Q
RFUgYW5kIEFNU0RVIHNpemUgZHVyaW5nIGRvaW5nIFRYL1JYIHRocm91Z2hwdXQgdGVzdC4NCk5v
cm1hbGx5LCBleHBlY3RlZCBBTVNEVSBzaXplIGlzIDMwMDArIGJ5dGVzLCBhbmQgQU1QRFUgbnVt
YmVyIGlzDQphcm91bmQgMzIgTVNEVXMuIElmIFJYIGlzIHRvbyBzbG93IHJlc3VsdGluZyBpbiBi
dWZmZXIgb3ZlcmZsb3csIA0KQVAgY291bGQgcmVzZW5kIChjaGVjayBzZXF1ZW5jZSBudW1iZXIg
YW5kICdSJyBiaXQsIG9yIEJBIG9mIDg4MjJDUykuDQoNCkFsc28sIGNoZWNrIFRYL1JYIHJhdGVz
IHRvIGtub3cgaWYgUkYgY2FsaWJyYXRpb24gYW5kIFBIWSBkeW5hbWljDQptZWNoYW5pc20gd29y
ayB3ZWxsLiBOb3JtYWxseSwgd2l0aCA1MGNtIGRpc3RhbmNlIGxvbmcgZnJvbSBBUCwNCml0IG11
c3QgeWllbGQgdGhlIGhpZ2hlc3QgcmF0ZSwgbm8gZG91YnQuDQoNCkkgaG9wZSB0aGlzIGNhbiBu
YXJyb3cgZG93biB0aGUgcHJvYmxlbXMgeW91IG1ldC4gDQoNCi0tLQ0KUGluZy1LZQ0KDQo=
