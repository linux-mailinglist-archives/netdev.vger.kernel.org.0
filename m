Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3256A65A9CD
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 12:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjAALnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 06:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjAALnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 06:43:11 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 934D1B85;
        Sun,  1 Jan 2023 03:43:07 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 301BfUAk9005608, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 301BfUAk9005608
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Sun, 1 Jan 2023 19:41:30 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Sun, 1 Jan 2023 19:42:25 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Sun, 1 Jan 2023 19:42:25 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Sun, 1 Jan 2023 19:42:25 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Topic: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Index: AQHZGsFtJHlbRNsmYUOpTa0F4ufSPq6EmMnggAOg+qCAALbHgA==
Date:   Sun, 1 Jan 2023 11:42:25 +0000
Message-ID: <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
         <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
         <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
         <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
In-Reply-To: <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [111.252.181.16]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvMSDkuIrljYggMDk6MDE6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E40070A16ABB8409F2891B6505F5676@realtek.com>
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

T24gU2F0LCAyMDIyLTEyLTMxIGF0IDE2OjU3ICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+
IEZyb206IFBpbmctS2UgU2hpaA0KPiA+IFNlbnQ6IDI5IERlY2VtYmVyIDIwMjIgMDk6MjUNCj4g
PiANCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBNYXJ0aW4g
Qmx1bWVuc3RpbmdsIDxtYXJ0aW4uYmx1bWVuc3RpbmdsQGdvb2dsZW1haWwuY29tPg0KPiA+ID4g
U2VudDogV2VkbmVzZGF5LCBEZWNlbWJlciAyOCwgMjAyMiA5OjM2IFBNDQo+ID4gPiBUbzogbGlu
dXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+ID4gPiBDYzogdG9ueTA2MjBlbW1hQGdtYWls
LmNvbTsga3ZhbG9Aa2VybmVsLm9yZzsgUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+
Ow0KPiA+IHRlaHVhbmdAcmVhbHRlay5jb207DQo+ID4gPiBzLmhhdWVyQHBlbmd1dHJvbml4LmRl
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBN
YXJ0aW4NCj4gPiA+IEJsdW1lbnN0aW5nbA0KPiA+ID4gPG1hcnRpbi5ibHVtZW5zdGluZ2xAZ29v
Z2xlbWFpbC5jb20+DQo+ID4gPiBTdWJqZWN0OiBbUEFUQ0ggMS80XSBydHc4ODogQWRkIHBhY2tl
ZCBhdHRyaWJ1dGUgdG8gdGhlIGVGdXNlIHN0cnVjdHMNCj4gPiA+IA0KPiA+ID4gVGhlIGVGdXNl
IGRlZmluaXRpb25zIGluIHRoZSBydHc4OCBhcmUgdXNpbmcgc3RydWN0cyB0byBkZXNjcmliZSB0
aGUNCj4gPiA+IGVGdXNlIGNvbnRlbnRzLiBBZGQgdGhlIHBhY2tlZCBhdHRyaWJ1dGUgdG8gYWxs
IHN0cnVjdHMgdXNlZCBmb3IgdGhlDQo+ID4gPiBlRnVzZSBkZXNjcmlwdGlvbiBzbyB0aGUgY29t
cGlsZXIgZG9lc24ndCBhZGQgZ2FwcyBvciByZS1vcmRlcg0KPiA+ID4gYXR0cmlidXRlcy4NCj4g
PiA+IA0KPiA+ID4gQWxzbyBjaGFuZ2UgdGhlIHR5cGUgb2YgdGhlIHJlczIuLnJlczMgZUZ1c2Ug
ZmllbGRzIHRvIHUxNiB0byBhdm9pZCB0aGUNCj4gPiA+IGZvbGxvd2luZyB3YXJuaW5nLCBub3cg
dGhhdCB0aGVpciBzdXJyb3VuZGluZyBzdHJ1Y3QgaGFzIHRoZSBwYWNrZWQNCj4gPiA+IGF0dHJp
YnV0ZToNCj4gPiA+ICAgbm90ZTogb2Zmc2V0IG9mIHBhY2tlZCBiaXQtZmllbGQgJ3JlczInIGhh
cyBjaGFuZ2VkIGluIEdDQyA0LjQNCj4gPiA+IA0KPiA+ID4gRml4ZXM6IGUzMDM3NDg1YzY4ZSAo
InJ0dzg4OiBuZXcgUmVhbHRlayA4MDIuMTFhYyBkcml2ZXIiKQ0KPiA+ID4gRml4ZXM6IGFiMGEw
MzFlY2YyOSAoInJ0dzg4OiA4NzIzZDogQWRkIHJlYWRfZWZ1c2UgdG8gcmVjb2duaXplIGVmdXNl
IGluZm8gZnJvbSBtYXAiKQ0KPiA+ID4gRml4ZXM6IDc2OWEyOWNlMmFmNCAoInJ0dzg4OiA4ODIx
YzogYWRkIGJhc2ljIGZ1bmN0aW9ucyIpDQo+ID4gPiBGaXhlczogODdjYWVlZjAzMmZjICgid2lm
aTogcnR3ODg6IEFkZCBydHc4NzIzZHUgY2hpcHNldCBzdXBwb3J0IikNCj4gPiA+IEZpeGVzOiBh
ZmY1ZmZkNzE4ZGUgKCJ3aWZpOiBydHc4ODogQWRkIHJ0dzg4MjFjdSBjaGlwc2V0IHN1cHBvcnQi
KQ0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTWFydGluIEJsdW1lbnN0aW5nbCA8bWFydGluLmJsdW1l
bnN0aW5nbEBnb29nbGVtYWlsLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMvbmV0L3dp
cmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5oICAgICB8ICA2ICsrKy0tLQ0KPiA+ID4gIGRyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2QuaCB8ICA2ICsrKy0tLQ0KPiA+
ID4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMWMuaCB8IDIwICsr
KysrKysrKy0tLS0tLS0tLS0NCj4gPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0
dzg4L3J0dzg4MjJiLmggfCAyMCArKysrKysrKystLS0tLS0tLS0tDQo+ID4gPiAgZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIyYy5oIHwgMjAgKysrKysrKysrLS0tLS0t
LS0tLQ0KPiA+ID4gIDUgZmlsZXMgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKSwgMzYgZGVsZXRp
b25zKC0pDQo+ID4gPiANCj4gPiANCj4gPiBbLi4uXQ0KPiA+IA0KPiA+ID4gQEAgLTQzLDEzICs0
MywxMyBAQCBzdHJ1Y3QgcnR3ODgyMWNlX2VmdXNlIHsNCj4gPiA+ICAJdTggbGlua19jYXBbNF07
DQo+ID4gPiAgCXU4IGxpbmtfY29udHJvbFsyXTsNCj4gPiA+ICAJdTggc2VyaWFsX251bWJlcls4
XTsNCj4gPiA+IC0JdTggcmVzMDoyOwkJCS8qIDB4ZjQgKi8NCj4gPiA+IC0JdTggbHRyX2VuOjE7
DQo+ID4gPiAtCXU4IHJlczE6MjsNCj4gPiA+IC0JdTggb2JmZjoyOw0KPiA+ID4gLQl1OCByZXMy
OjM7DQo+ID4gPiAtCXU4IG9iZmZfY2FwOjI7DQo+ID4gPiAtCXU4IHJlczM6NDsNCj4gPiA+ICsJ
dTE2IHJlczA6MjsJCQkvKiAweGY0ICovDQo+ID4gPiArCXUxNiBsdHJfZW46MTsNCj4gPiA+ICsJ
dTE2IHJlczE6MjsNCj4gPiA+ICsJdTE2IG9iZmY6MjsNCj4gPiA+ICsJdTE2IHJlczI6MzsNCj4g
PiA+ICsJdTE2IG9iZmZfY2FwOjI7DQo+ID4gPiArCXUxNiByZXMzOjQ7DQo+ID4gDQo+ID4gVGhl
c2Ugc2hvdWxkIGJlIF9fbGUxNi4gVGhvdWdoIGJpdCBmaWVsZHMgYXJlIHN1aXRhYmxlIHRvIGVm
dXNlIGxheW91dCwNCj4gPiB3ZSBkb24ndCBhY2Nlc3MgdGhlc2UgZmllbGRzIGZvciBub3cuIEl0
IHdvdWxkIGJlIHdlbGwuDQoNClVoLiBJIHR5cG8gdGhlIHNlbnRlbmNlLiBPcmlnaW5hbGx5LCBJ
IHdvdWxkIGxpa2UgdG8gdHlwZQ0KIi4uLmJpdCBmaWVsZHMgYXJlIE5PVCBzdWl0YWJsZS4uLiIu
DQoNCkluIHRoaXMgZHJpdmVyLCBlZnVzZSBpcyByZWFkIGludG8gYSB1OCBhcnJheSwgYW5kIGNh
c3QgdG8gdGhpcyBzdHJ1Y3QNCnBvaW50ZXIgdG8gYWNjZXNzIHRoZSBmaWVsZC4gDQoNCj4gDQo+
IElJUkMgdGhlIGFzc2lnbm1lbnQgb2YgYWN0dWFsIGJpdHMgdG8gYml0LWZpZWxkcyBpcyAoYXQg
YmVzdCkNCj4gYXJjaGl0ZWN0dXJhbGx5IGRlZmluZWQgLSBzbyBpc24ndCByZWFsbHkgc3VpdGFi
bGUgZm9yIGFueXRoaW5nDQo+IHdoZXJlIHRoZSBiaXRzIGhhdmUgdG8gbWF0Y2ggYSBwb3J0YWJs
ZSBtZW1vcnkgYnVmZmVyLg0KPiBUaGUgYml0IGFsbG9jYXRpb24gaXNuJ3QgdGllZCB0byB0aGUg
Ynl0ZSBlbmRpYW5uZXNzLg0KDQpZZXMsIHRoaXMga2luZCBvZiBzdHJ1Y3QgaGFzIGVuZGlhbiBw
cm9ibGVtLiBGb3J0dW5hdGVseSwgd2UgZG9uJ3QNCmFjdHVhbGx5IGFjY2VzcyB2YWx1ZXMgdmlh
IGJpdCBmaWVsZHMuDQoNCj4gDQo+IFRvIGdldCBhbiBleHBsaWNpdCBsYXlvdXQgeW91IGhhdmUg
dG8gZG8gZXhwbGljaXQgbWFza2luZy4NCg0KSWYgd2UgYWN0dWFsbHkgd2FudCB0byBhY2Nlc3Mg
dGhlc2UgdmFsdWVzLCB3ZSB3aWxsIGRlZmluZSBtYXNrcw0KYW5kIHVzZSB7dTgsX2xlMTYsbGUz
Mn1fZ2V0X2JpdHMoKSBvciBiYXJlICcmJyBiaXQgb3BlcmF0aW9uIHRvIGFjY2VzcyANCnRoZW0u
DQoNCj4gDQo+IFlvdSBhbHNvIGRvbid0IG5lZWQgX19wYWNrZWQgdW5sZXNzIHRoZSAnbmF0dXJh
bCcgYWxpZ25tZW50DQo+IG9mIGZpZWxkcyB3b3VsZCBuZWVkIGdhcHMgb3IgdGhlIGFjdHVhbCBz
dHJ1Y3R1cmUgaXRzZWxmIG1pZ2h0DQo+IGJlIG1pc2FsaWduZWQgaW4gbWVtb3J5Lg0KPiBXaGls
ZSBDIGNvbXBpbGVycyBhcmUgYWxsb3dlZCB0byBhZGQgYXJiaXRyYXJ5IHBhZGRpbmcgdGhlIExp
bnV4IGtlcm5lbA0KPiByZXF1aXJlcyB0aGF0IHRoZXkgZG9uJ3QuDQo+IEknbSBhbHNvIHByZXR0
eSBzdXJlIHRoYXQgY29tcGlsZXJzIGFyZSBub3QgYWxsb3dlZCB0byByZW9yZGVyIGZpZWxkcy4N
Cj4gDQo+IFNwZWNpZnlpbmcgX19wYWNrZWQgY2FuIGFkZCBjb25zaWRlcmFibGUgcnVuLXRpbWUg
KGFuZCBjb2RlIHNpemUpDQo+IG92ZXJoZWFkIG9uIHNvbWUgYXJjaGl0ZWN0dXJlcyAtIGl0IHNo
b3VsZCBvbmx5IGJlIHVzZWQgaWYgYWN0dWFsbHkNCj4gbmVlZGVkLg0KPiANCg0KVW5kZXJzdG9v
ZC4gV2Ugb25seSBhZGQgX19wYWNrZWQgdG8gdGhlIHN0cnVjdCB3aGljaCBpcyB1c2VkIHRvDQph
Y2Nlc3MgcHJlZGVmaW5lZCBmb3JtYXQsIGxpa2UgZWZ1c2UgY29udGVudCBkZWZpbmVkIGJ5IHZl
bmRvci4NCg0KUGluZy1LZQ0KDQo=
