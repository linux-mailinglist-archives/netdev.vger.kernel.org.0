Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B70F50D778
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240591AbiDYDYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240588AbiDYDYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:24:02 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDC619A;
        Sun, 24 Apr 2022 20:20:58 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 23P3KUlqC001722, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 23P3KUlqC001722
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 25 Apr 2022 11:20:30 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 11:20:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 11:20:30 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Mon, 25 Apr 2022 11:20:30 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "guozhengkui@vivo.com" <guozhengkui@vivo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "zhengkui_guo@outlook.com" <zhengkui_guo@outlook.com>
Subject: Re: [PATCH v2] rtlwifi: btcoex: fix if == else warning
Thread-Topic: [PATCH v2] rtlwifi: btcoex: fix if == else warning
Thread-Index: AQHYWFMSYioLZF5z0kqUPwFdtHEht6z/cAWA
Date:   Mon, 25 Apr 2022 03:20:29 +0000
Message-ID: <aac189b6207e76fa1c1551c3424f295ee532547e.camel@realtek.com>
References: <0355f52ad7bf46454af4d5cb28fd6d59f678c25f.camel@realtek.com>
         <20220425031725.5808-1-guozhengkui@vivo.com>
In-Reply-To: <20220425031725.5808-1-guozhengkui@vivo.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [125.224.87.177]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzQvMjQg5LiL5Y2IIDExOjQxOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <C24627702B3BA44282035DD74F663F59@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
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

T24gTW9uLCAyMDIyLTA0LTI1IGF0IDExOjE3ICswODAwLCBHdW8gWmhlbmdrdWkgd3JvdGU6DQo+
IEZpeCB0aGUgZm9sbG93aW5nIGNvY2NpY2hlY2sgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9idGNvZXhpc3QvaGFsYnRjODgyMWExYW50LmM6MTYw
NDoyLTQ6DQo+IFdBUk5JTkc6IHBvc3NpYmxlIGNvbmRpdGlvbiB3aXRoIG5vIGVmZmVjdCAoaWYg
PT0gZWxzZSkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBHdW8gWmhlbmdrdWkgPGd1b3poZW5na3Vp
QHZpdm8uY29tPg0KDQpBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+
DQoNClRoYW5rIHlvdQ0KDQo+IC0tLQ0KPiB2MSAtPiB2MjogTW9kaWZ5IHRoZSBjb21tZW50IGFj
Y29yZGluZyB0byBQaW5nLUtlJ3Mgc3VnZ2VzdGlvbi4NCj4gDQo+ICAuLi4vcmVhbHRlay9ydGx3
aWZpL2J0Y29leGlzdC9oYWxidGM4ODIxYTFhbnQuYyAgfCAxNiArKysrLS0tLS0tLS0tLS0tDQo+
ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4
aXN0L2hhbGJ0Yzg4MjFhMWFudC5jDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9y
dGx3aWZpL2J0Y29leGlzdC9oYWxidGM4ODIxYTFhbnQuYw0KPiBpbmRleCBhMThkZmZjODc1M2Eu
LjY3ZDBiOWFlZTA2NCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydGx3aWZpL2J0Y29leGlzdC9oYWxidGM4ODIxYTFhbnQuYw0KPiArKysgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0Yzg4MjFhMWFudC5jDQo+
IEBAIC0xNjAwLDE4ICsxNjAwLDEwIEBAIHN0YXRpYyB2b2lkIGJ0Yzg4MjFhMWFudF9hY3Rfd2lm
aV9jb25fYnRfYWNsX2J1c3koc3RydWN0IGJ0Y19jb2V4aXN0DQo+ICpidGNvZXhpc3QsDQo+ICAJ
CQljb2V4X2RtLT5hdXRvX3RkbWFfYWRqdXN0ID0gZmFsc2U7DQo+ICAJCX0NCj4gIAl9IGVsc2Ug
aWYgKGJ0X2xpbmtfaW5mby0+aGlkX2V4aXN0ICYmIGJ0X2xpbmtfaW5mby0+YTJkcF9leGlzdCkg
ew0KPiAtCQkvKiBISUQrQTJEUCAqLw0KPiAtCQlpZiAoKGJ0X3Jzc2lfc3RhdGUgPT0gQlRDX1JT
U0lfU1RBVEVfSElHSCkgfHwNCj4gLQkJICAgIChidF9yc3NpX3N0YXRlID09IEJUQ19SU1NJX1NU
QVRFX1NUQVlfSElHSCkpIHsNCj4gLQkJCWJ0Yzg4MjFhMWFudF9wc190ZG1hKGJ0Y29leGlzdCwg
Tk9STUFMX0VYRUMsDQo+IC0JCQkJCSAgICAgdHJ1ZSwgMTQpOw0KPiAtCQkJY29leF9kbS0+YXV0
b190ZG1hX2FkanVzdCA9IGZhbHNlOw0KPiAtCQl9IGVsc2Ugew0KPiAtCQkJLypmb3IgbG93IEJU
IFJTU0kqLw0KPiAtCQkJYnRjODgyMWExYW50X3BzX3RkbWEoYnRjb2V4aXN0LCBOT1JNQUxfRVhF
QywNCj4gLQkJCQkJICAgICB0cnVlLCAxNCk7DQo+IC0JCQljb2V4X2RtLT5hdXRvX3RkbWFfYWRq
dXN0ID0gZmFsc2U7DQo+IC0JCX0NCj4gKwkJLyogSElEK0EyRFAgKG5vIG5lZWQgdG8gY29uc2lk
ZXIgQlQgUlNTSSkgKi8NCj4gKwkJYnRjODgyMWExYW50X3BzX3RkbWEoYnRjb2V4aXN0LCBOT1JN
QUxfRVhFQywNCj4gKwkJCQkgICAgIHRydWUsIDE0KTsNCj4gKwkJY29leF9kbS0+YXV0b190ZG1h
X2FkanVzdCA9IGZhbHNlOw0KPiAgDQo+ICAJCWJ0Yzg4MjFhMWFudF9jb2V4X3RhYmxlX3dpdGhf
dHlwZShidGNvZXhpc3QsIE5PUk1BTF9FWEVDLCAxKTsNCj4gIAl9IGVsc2UgaWYgKChidF9saW5r
X2luZm8tPnBhbl9vbmx5KSB8fA0KDQoNCg==
