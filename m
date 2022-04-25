Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24ED850D61C
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 02:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbiDYAH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 20:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239977AbiDYAHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 20:07:42 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F365DA76;
        Sun, 24 Apr 2022 17:04:35 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 23P045Xu8013998, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 23P045Xu8013998
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 25 Apr 2022 08:04:05 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 08:04:05 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 08:04:04 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Mon, 25 Apr 2022 08:04:04 +0800
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
Subject: Re: [PATCH] rtlwifi: btcoex: fix if == else warning
Thread-Topic: [PATCH] rtlwifi: btcoex: fix if == else warning
Thread-Index: AQHYV7Dd+j7wndhchkemQ0oNT8VaVKz/OmeA
Date:   Mon, 25 Apr 2022 00:04:04 +0000
Message-ID: <0355f52ad7bf46454af4d5cb28fd6d59f678c25f.camel@realtek.com>
References: <20220424075548.1544-1-guozhengkui@vivo.com>
In-Reply-To: <20220424075548.1544-1-guozhengkui@vivo.com>
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
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzQvMjQg5LiL5Y2IIDA3OjE0OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <B42B2D14FBD8064FA116E8942F656421@realtek.com>
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

T24gU3VuLCAyMDIyLTA0LTI0IGF0IDE1OjU1ICswODAwLCBHdW8gWmhlbmdrdWkgd3JvdGU6DQo+
IEZpeCB0aGUgZm9sbG93aW5nIGNvY2NpY2hlY2sgd2FybmluZzoNCj4gDQo+IGRyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9idGNvZXhpc3QvaGFsYnRjODgyMWExYW50LmM6MTYw
NDoyLTQ6DQo+IFdBUk5JTkc6IHBvc3NpYmxlIGNvbmRpdGlvbiB3aXRoIG5vIGVmZmVjdCAoaWYg
PT0gZWxzZSkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBHdW8gWmhlbmdrdWkgPGd1b3poZW5na3Vp
QHZpdm8uY29tPg0KPiAtLS0NCj4gIC4uLi9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0
Yzg4MjFhMWFudC5jICAgfCAxNSArKysrLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9idGNvZXhpc3QvaGFsYnRjODgyMWExYW50
LmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hh
bGJ0Yzg4MjFhMWFudC5jDQo+IGluZGV4IGExOGRmZmM4NzUzYS4uMmY0YzZhMzdhMmU4IDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0
L2hhbGJ0Yzg4MjFhMWFudC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnRsd2lmaS9idGNvZXhpc3QvaGFsYnRjODgyMWExYW50LmMNCj4gQEAgLTE2MDEsMTcgKzE2MDEs
MTAgQEAgc3RhdGljIHZvaWQgYnRjODgyMWExYW50X2FjdF93aWZpX2Nvbl9idF9hY2xfYnVzeShz
dHJ1Y3QgYnRjX2NvZXhpc3QNCj4gKmJ0Y29leGlzdCwNCj4gIAkJfQ0KPiAgCX0gZWxzZSBpZiAo
YnRfbGlua19pbmZvLT5oaWRfZXhpc3QgJiYgYnRfbGlua19pbmZvLT5hMmRwX2V4aXN0KSB7DQo+
ICAJCS8qIEhJRCtBMkRQICovDQo+IC0JCWlmICgoYnRfcnNzaV9zdGF0ZSA9PSBCVENfUlNTSV9T
VEFURV9ISUdIKSB8fA0KPiAtCQkgICAgKGJ0X3Jzc2lfc3RhdGUgPT0gQlRDX1JTU0lfU1RBVEVf
U1RBWV9ISUdIKSkgew0KPiAtCQkJYnRjODgyMWExYW50X3BzX3RkbWEoYnRjb2V4aXN0LCBOT1JN
QUxfRVhFQywNCj4gLQkJCQkJICAgICB0cnVlLCAxNCk7DQo+IC0JCQljb2V4X2RtLT5hdXRvX3Rk
bWFfYWRqdXN0ID0gZmFsc2U7DQo+IC0JCX0gZWxzZSB7DQo+IC0JCQkvKmZvciBsb3cgQlQgUlNT
SSovDQo+IC0JCQlidGM4ODIxYTFhbnRfcHNfdGRtYShidGNvZXhpc3QsIE5PUk1BTF9FWEVDLA0K
PiAtCQkJCQkgICAgIHRydWUsIDE0KTsNCj4gLQkJCWNvZXhfZG0tPmF1dG9fdGRtYV9hZGp1c3Qg
PSBmYWxzZTsNCj4gLQkJfQ0KPiArCQkvKiBmb3IgbG93IEJUIFJTU0kgKi8NCg0KVGhlIGNvbW1l
bnQgc2h1b2xkIGJlIHJlbW92ZWQsIG9yICJObyBuZWVkIHRvIGNvbnNpZGVyIEJUIFJTU0kiLg0K
DQo+ICsJCWJ0Yzg4MjFhMWFudF9wc190ZG1hKGJ0Y29leGlzdCwgTk9STUFMX0VYRUMsDQo+ICsJ
CQkJICAgICB0cnVlLCAxNCk7DQo+ICsJCWNvZXhfZG0tPmF1dG9fdGRtYV9hZGp1c3QgPSBmYWxz
ZTsNCj4gIA0KPiAgCQlidGM4ODIxYTFhbnRfY29leF90YWJsZV93aXRoX3R5cGUoYnRjb2V4aXN0
LCBOT1JNQUxfRVhFQywgMSk7DQo+ICAJfSBlbHNlIGlmICgoYnRfbGlua19pbmZvLT5wYW5fb25s
eSkgfHwNCj4gDQoNClRoZSBjb2RlIGlzIHRvIHByZXNlcnZlIGEgcm9vbSB0byBmaW5lIHR1bmUg
QlQgY29leGlzdGVuY2UgdG8gZ2V0DQpiZXR0ZXIgdXNlciBleHBlcmllbmNlIGZvciBjZXJ0YWlu
IGNhc2VzLiBTaW5jZSBpdCB3b3JrcyB3ZWxsLA0KSSB0aGluayB0aGV5IGNhbiBiZSByZW1vdmVk
IG5vdy4NCg0KLS0NClBpbmctS2UNCg0K
