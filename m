Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F6E65AA10
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 14:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjAANJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 08:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjAANJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 08:09:25 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01F6B1088;
        Sun,  1 Jan 2023 05:09:19 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 301D7sitE025943, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 301D7sitE025943
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Sun, 1 Jan 2023 21:07:54 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Sun, 1 Jan 2023 21:08:49 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sun, 1 Jan 2023 21:08:49 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Sun, 1 Jan 2023 21:08:48 +0800
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
Thread-Index: AQHZGsFtJHlbRNsmYUOpTa0F4ufSPq6EmMnggAOg+qCAALbHgIAAiEwg//+P14A=
Date:   Sun, 1 Jan 2023 13:08:48 +0000
Message-ID: <5c0c77240e7ddfdffbd771ee7e50d36ef3af9c84.camel@realtek.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
         <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
         <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
         <87da8c82dec749dc826b5a1b4c4238aa@AcuMS.aculab.com>
         <eee17e2f4e44a2f38021a839dc39fedc1c1a4141.camel@realtek.com>
         <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com>
In-Reply-To: <a86893f11fe64930897473a38226a9a8@AcuMS.aculab.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [111.252.181.16]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvMSDkuIrljYggMDk6MDE6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <89194A346201C548A306FA16203AA520@realtek.com>
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

T24gU3VuLCAyMDIzLTAxLTAxIGF0IDExOjU0ICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+
IEZyb206IFBpbmctS2UgU2hpaA0KPiA+IFNlbnQ6IDAxIEphbnVhcnkgMjAyMyAxMTo0Mg0KPiA+
IA0KPiA+IE9uIFNhdCwgMjAyMi0xMi0zMSBhdCAxNjo1NyArMDAwMCwgRGF2aWQgTGFpZ2h0IHdy
b3RlOg0KPiA+ID4gRnJvbTogUGluZy1LZSBTaGloDQo+ID4gPiA+IFNlbnQ6IDI5IERlY2VtYmVy
IDIwMjIgMDk6MjUNCj4gPiA+ID4gDQo+ID4gPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gPiA+ID4gPiBGcm9tOiBNYXJ0aW4gQmx1bWVuc3RpbmdsIDxtYXJ0aW4uYmx1bWVuc3Rp
bmdsQGdvb2dsZW1haWwuY29tPg0KPiA+ID4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgRGVjZW1iZXIg
MjgsIDIwMjIgOTozNiBQTQ0KPiA+ID4gPiA+IFRvOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5l
bC5vcmcNCj4gPiA+ID4gPiBDYzogdG9ueTA2MjBlbW1hQGdtYWlsLmNvbTsga3ZhbG9Aa2VybmVs
Lm9yZzsgUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+Ow0KPiA+ID4gPiB0ZWh1YW5n
QHJlYWx0ZWsuY29tOw0KPiA+ID4gPiA+IHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU7IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IE1hcnRpbg0KPiA+
ID4gPiA+IEJsdW1lbnN0aW5nbA0KPiA+ID4gPiA+IDxtYXJ0aW4uYmx1bWVuc3RpbmdsQGdvb2ds
ZW1haWwuY29tPg0KPiA+ID4gPiA+IFN1YmplY3Q6IFtQQVRDSCAxLzRdIHJ0dzg4OiBBZGQgcGFj
a2VkIGF0dHJpYnV0ZSB0byB0aGUgZUZ1c2Ugc3RydWN0cw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+
IFRoZSBlRnVzZSBkZWZpbml0aW9ucyBpbiB0aGUgcnR3ODggYXJlIHVzaW5nIHN0cnVjdHMgdG8g
ZGVzY3JpYmUgdGhlDQo+ID4gPiA+ID4gZUZ1c2UgY29udGVudHMuIEFkZCB0aGUgcGFja2VkIGF0
dHJpYnV0ZSB0byBhbGwgc3RydWN0cyB1c2VkIGZvciB0aGUNCj4gPiA+ID4gPiBlRnVzZSBkZXNj
cmlwdGlvbiBzbyB0aGUgY29tcGlsZXIgZG9lc24ndCBhZGQgZ2FwcyBvciByZS1vcmRlcg0KPiA+
ID4gPiA+IGF0dHJpYnV0ZXMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gQWxzbyBjaGFuZ2UgdGhl
IHR5cGUgb2YgdGhlIHJlczIuLnJlczMgZUZ1c2UgZmllbGRzIHRvIHUxNiB0byBhdm9pZCB0aGUN
Cj4gPiA+ID4gPiBmb2xsb3dpbmcgd2FybmluZywgbm93IHRoYXQgdGhlaXIgc3Vycm91bmRpbmcg
c3RydWN0IGhhcyB0aGUgcGFja2VkDQo+ID4gPiA+ID4gYXR0cmlidXRlOg0KPiA+ID4gPiA+ICAg
bm90ZTogb2Zmc2V0IG9mIHBhY2tlZCBiaXQtZmllbGQgJ3JlczInIGhhcyBjaGFuZ2VkIGluIEdD
QyA0LjQNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBGaXhlczogZTMwMzc0ODVjNjhlICgicnR3ODg6
IG5ldyBSZWFsdGVrIDgwMi4xMWFjIGRyaXZlciIpDQo+ID4gPiA+ID4gRml4ZXM6IGFiMGEwMzFl
Y2YyOSAoInJ0dzg4OiA4NzIzZDogQWRkIHJlYWRfZWZ1c2UgdG8gcmVjb2duaXplIGVmdXNlIGlu
Zm8gZnJvbSBtYXAiKQ0KPiA+ID4gPiA+IEZpeGVzOiA3NjlhMjljZTJhZjQgKCJydHc4ODogODgy
MWM6IGFkZCBiYXNpYyBmdW5jdGlvbnMiKQ0KPiA+ID4gPiA+IEZpeGVzOiA4N2NhZWVmMDMyZmMg
KCJ3aWZpOiBydHc4ODogQWRkIHJ0dzg3MjNkdSBjaGlwc2V0IHN1cHBvcnQiKQ0KPiA+ID4gPiA+
IEZpeGVzOiBhZmY1ZmZkNzE4ZGUgKCJ3aWZpOiBydHc4ODogQWRkIHJ0dzg4MjFjdSBjaGlwc2V0
IHN1cHBvcnQiKQ0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBCbHVtZW5zdGluZ2wg
PG1hcnRpbi5ibHVtZW5zdGluZ2xAZ29vZ2xlbWFpbC5jb20+DQo+ID4gPiA+ID4gLS0tDQo+ID4g
PiA+ID4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5oICAgICB8ICA2
ICsrKy0tLQ0KPiA+ID4gPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0
dzg3MjNkLmggfCAgNiArKystLS0NCj4gPiA+ID4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydHc4OC9ydHc4ODIxYy5oIHwgMjAgKysrKysrKysrLS0tLS0tLS0tLQ0KPiA+ID4gPiA+
ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjJiLmggfCAyMCArKysr
KysrKystLS0tLS0tLS0tDQo+ID4gPiA+ID4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnR3ODgvcnR3ODgyMmMuaCB8IDIwICsrKysrKysrKy0tLS0tLS0tLS0NCj4gPiA+ID4gPiAgNSBm
aWxlcyBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspLCAzNiBkZWxldGlvbnMoLSkNCj4gPiA+ID4g
PiANCj4gPiA+ID4gDQo+ID4gPiA+IFsuLi5dDQo+ID4gPiA+IA0KPiA+ID4gPiA+IEBAIC00Mywx
MyArNDMsMTMgQEAgc3RydWN0IHJ0dzg4MjFjZV9lZnVzZSB7DQo+ID4gPiA+ID4gIAl1OCBsaW5r
X2NhcFs0XTsNCj4gPiA+ID4gPiAgCXU4IGxpbmtfY29udHJvbFsyXTsNCj4gPiA+ID4gPiAgCXU4
IHNlcmlhbF9udW1iZXJbOF07DQo+ID4gPiA+ID4gLQl1OCByZXMwOjI7CQkJLyogMHhmNCAqLw0K
PiA+ID4gPiA+IC0JdTggbHRyX2VuOjE7DQo+ID4gPiA+ID4gLQl1OCByZXMxOjI7DQo+ID4gPiA+
ID4gLQl1OCBvYmZmOjI7DQo+ID4gPiA+ID4gLQl1OCByZXMyOjM7DQo+ID4gPiA+ID4gLQl1OCBv
YmZmX2NhcDoyOw0KPiA+ID4gPiA+IC0JdTggcmVzMzo0Ow0KPiA+ID4gPiA+ICsJdTE2IHJlczA6
MjsJCQkvKiAweGY0ICovDQo+ID4gPiA+ID4gKwl1MTYgbHRyX2VuOjE7DQo+ID4gPiA+ID4gKwl1
MTYgcmVzMToyOw0KPiA+ID4gPiA+ICsJdTE2IG9iZmY6MjsNCj4gPiA+ID4gPiArCXUxNiByZXMy
OjM7DQo+ID4gPiA+ID4gKwl1MTYgb2JmZl9jYXA6MjsNCj4gPiA+ID4gPiArCXUxNiByZXMzOjQ7
DQo+ID4gPiA+IA0KPiA+ID4gPiBUaGVzZSBzaG91bGQgYmUgX19sZTE2LiBUaG91Z2ggYml0IGZp
ZWxkcyBhcmUgc3VpdGFibGUgdG8gZWZ1c2UgbGF5b3V0LA0KPiA+ID4gPiB3ZSBkb24ndCBhY2Nl
c3MgdGhlc2UgZmllbGRzIGZvciBub3cuIEl0IHdvdWxkIGJlIHdlbGwuDQo+ID4gDQo+ID4gVWgu
IEkgdHlwbyB0aGUgc2VudGVuY2UuIE9yaWdpbmFsbHksIEkgd291bGQgbGlrZSB0byB0eXBlDQo+
ID4gIi4uLmJpdCBmaWVsZHMgYXJlIE5PVCBzdWl0YWJsZS4uLiIuDQo+ID4gDQo+ID4gSW4gdGhp
cyBkcml2ZXIsIGVmdXNlIGlzIHJlYWQgaW50byBhIHU4IGFycmF5LCBhbmQgY2FzdCB0byB0aGlz
IHN0cnVjdA0KPiA+IHBvaW50ZXIgdG8gYWNjZXNzIHRoZSBmaWVsZC4NCj4gDQo+IFRoZW4gZGVm
aW5lIGl0IGFzIHN1Y2guDQo+IFRoZSAxNmJpdCBlbmRpYW5uZXNzIGFuZCBiaXQtb3JkZXIgZGVw
ZW5kYW50IGJpdGZpZWxkcyBzZXJ2ZQ0KPiBubyBwdXJwb3NlLiANCj4gDQo+ID4gPiBJSVJDIHRo
ZSBhc3NpZ25tZW50IG9mIGFjdHVhbCBiaXRzIHRvIGJpdC1maWVsZHMgaXMgKGF0IGJlc3QpDQo+
ID4gPiBhcmNoaXRlY3R1cmFsbHkgZGVmaW5lZCAtIHNvIGlzbid0IHJlYWxseSBzdWl0YWJsZSBm
b3IgYW55dGhpbmcNCj4gPiA+IHdoZXJlIHRoZSBiaXRzIGhhdmUgdG8gbWF0Y2ggYSBwb3J0YWJs
ZSBtZW1vcnkgYnVmZmVyLg0KPiA+ID4gVGhlIGJpdCBhbGxvY2F0aW9uIGlzbid0IHRpZWQgdG8g
dGhlIGJ5dGUgZW5kaWFubmVzcy4NCj4gPiANCj4gPiBZZXMsIHRoaXMga2luZCBvZiBzdHJ1Y3Qg
aGFzIGVuZGlhbiBwcm9ibGVtLiBGb3J0dW5hdGVseSwgd2UgZG9uJ3QNCj4gPiBhY3R1YWxseSBh
Y2Nlc3MgdmFsdWVzIHZpYSBiaXQgZmllbGRzLg0KPiA+IA0KPiA+ID4gVG8gZ2V0IGFuIGV4cGxp
Y2l0IGxheW91dCB5b3UgaGF2ZSB0byBkbyBleHBsaWNpdCBtYXNraW5nLg0KPiA+IA0KPiA+IElm
IHdlIGFjdHVhbGx5IHdhbnQgdG8gYWNjZXNzIHRoZXNlIHZhbHVlcywgd2Ugd2lsbCBkZWZpbmUg
bWFza3MNCj4gPiBhbmQgdXNlIHt1OCxfbGUxNixsZTMyfV9nZXRfYml0cygpIG9yIGJhcmUgJyYn
IGJpdCBvcGVyYXRpb24gdG8gYWNjZXNzDQo+ID4gdGhlbS4NCj4gDQo+IEJ1dCB5b3UgY2FuJ3Qg
dGFrZSB0aGUgYWRkcmVzcyBvZiBiaXRmaWVsZCBtZW1iZXJzLg0KPiBEZWZpbmUgdGhlIGRhdGEg
cHJvcGVybHkuDQoNClllcywgaXQgc2hvdWxkIG5vdCB1c2UgYml0IGZpbGVkLiBJbnN0ZWFkLCB1
c2UgYSBfX2xlMTYgZm9yIGFsbCBmaWVsZHMsIHN1Y2ggYXMNCg0Kc3RydWN0IHJ0dzg4MjFjZV9l
ZnVzZSB7DQogICAgLi4uDQogICAgX19sZTE2IGNhcHM7DQogICAgLi4uDQp9DQoNCg0KI2RlZmlu
ZSBDQVBTX1JFUzAgR0VOTUFTSygxLCAwKQ0KI2RlZmluZSBDQVBTX0xUUl9FTiBCSVQoMikNCiNk
ZWZpbmUgQ0FQU19SRVMxIEdFTk1BU0soNCwgMykNCiNkZWZpbmUgQ0FQU19PQkZGIEdFTk1BU0so
NiwgNSkNCi4uLg0KDQoNCkFzc3VtZSB0aGUgcG9pbnRlciBvZiBlZnVzZSBjb250ZW50IGlzICdj
b25zdCB1OCAqZWZ1c2VfcmF3OycNCg0KICAgY29uc3Qgc3RydWN0IHJ0dzg4MjFjZV9lZnVzZSAq
ZWZ1c2UgPSAoY29uc3Qgc3RydWN0IHJ0dzg4MjFjZV9lZnVzZSAqKWVmdXNlX3JhdzsNCg0KVGhl
biwgZ2V0IGx0cl9lbg0KDQogICBsdHJfZW4gPSBsZTE2X2dldF9iaXRzKGVmdXNlLT5jYXBzLCBD
QVBTX0xUUl9FTik7DQoNCg0KPiANCj4gPiA+IFlvdSBhbHNvIGRvbid0IG5lZWQgX19wYWNrZWQg
dW5sZXNzIHRoZSAnbmF0dXJhbCcgYWxpZ25tZW50DQo+ID4gPiBvZiBmaWVsZHMgd291bGQgbmVl
ZCBnYXBzIG9yIHRoZSBhY3R1YWwgc3RydWN0dXJlIGl0c2VsZiBtaWdodA0KPiA+ID4gYmUgbWlz
YWxpZ25lZCBpbiBtZW1vcnkuDQo+ID4gPiBXaGlsZSBDIGNvbXBpbGVycyBhcmUgYWxsb3dlZCB0
byBhZGQgYXJiaXRyYXJ5IHBhZGRpbmcgdGhlIExpbnV4IGtlcm5lbA0KPiA+ID4gcmVxdWlyZXMg
dGhhdCB0aGV5IGRvbid0Lg0KPiA+ID4gSSdtIGFsc28gcHJldHR5IHN1cmUgdGhhdCBjb21waWxl
cnMgYXJlIG5vdCBhbGxvd2VkIHRvIHJlb3JkZXIgZmllbGRzLg0KPiA+ID4gDQo+ID4gPiBTcGVj
aWZ5aW5nIF9fcGFja2VkIGNhbiBhZGQgY29uc2lkZXJhYmxlIHJ1bi10aW1lIChhbmQgY29kZSBz
aXplKQ0KPiA+ID4gb3ZlcmhlYWQgb24gc29tZSBhcmNoaXRlY3R1cmVzIC0gaXQgc2hvdWxkIG9u
bHkgYmUgdXNlZCBpZiBhY3R1YWxseQ0KPiA+ID4gbmVlZGVkLg0KPiA+ID4gDQo+ID4gDQo+ID4g
VW5kZXJzdG9vZC4gV2Ugb25seSBhZGQgX19wYWNrZWQgdG8gdGhlIHN0cnVjdCB3aGljaCBpcyB1
c2VkIHRvDQo+ID4gYWNjZXNzIHByZWRlZmluZWQgZm9ybWF0LCBsaWtlIGVmdXNlIGNvbnRlbnQg
ZGVmaW5lZCBieSB2ZW5kb3IuDQo+IA0KPiBObyAtIHRoYXQgZG9lc24ndCBtZWFuIHlvdSBuZWVk
IHRvIHVzZSBfX3BhY2tlZC4NCj4gSXQgZG9lcyBtZWFuIHRoYXQgeW91IHNob3VsZG4ndCB1c2Ug
Yml0ZmllbGRzLg0KPiBMb29rIGF0IGFsbCB0aGUgaGFyZHdhcmUgZHJpdmVycywgdGhleSB1c2Ug
c3RydWN0cyB0byBtYXAgZGV2aWNlDQo+IHJlZ2lzdGVycyBhbmQgYWJzb2x1dGVseSByZXF1aXJl
IHRoZSBjb21waWxlIG5vdCBhZGQgcGFkZGluZy4NCj4gDQoNCkkgdGhpbmsgdGhlIG9yaWdpbmFs
IHN0cnVjdCBoYXMgdHdvIHByb2JsZW0gLS0gZW5kaWFuIGFuZCBfX3BhY2tlZC4NCg0KSSBtZW50
aW9uZWQgZW5kaWFuIHBhcnQgYWJvdmUuIA0KDQpUYWtpbmcgYmVsb3cgYXMgZXhhbXBsZSB0byBl
eHBsYWluIHdoeSBJIG5lZWQgX19wYWNrZWQsIA0KDQpzdHJ1Y3QgcnR3ODgyMWNlX2VmdXNlIHsN
CiAgIC4uLg0KICAgdTggZGF0YTE7ICAgICAgIC8vIG9mZnNldCAweDEwMA0KICAgX19sZTE2IGRh
dGEyOyAgIC8vIG9mZnNldCAweDEwMS0weDEwMg0KICAgLi4uDQp9IF9fcGFja2VkOw0KDQpXaXRo
b3V0IF9fcGFja2VkLCBjb21waWxlciBjb3VsZCBoYXMgcGFkIGJldHdlZW4gZGF0YTEgYW5kIGRh
dGEyLA0KYW5kIHRoZW4gZ2V0IHdyb25nIHJlc3VsdC4NCg0KSW4gdGhpcyBwYXRjaCwgc3RydWN0
IGlzbid0IHRvIG1hcCByZWdpc3RlcnMuIEluc3RlYWQgaXQgaXMgdXNlZCB0bw0KYWNjZXNzIGVm
dXNlIGNvbnRlbnQgb2YgYSB1OCBhcnJheSBleGlzdGluZyBpbiBtZW1vcnkuDQoNClBpbmctS2UN
Cg0KDQo=
