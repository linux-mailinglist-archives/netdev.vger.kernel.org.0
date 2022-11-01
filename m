Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4B36144C1
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 07:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiKAGld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 02:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiKAGlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 02:41:32 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48EF0FD10;
        Mon, 31 Oct 2022 23:41:30 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2A16eP5o9016308, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2A16eP5o9016308
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 1 Nov 2022 14:40:25 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Tue, 1 Nov 2022 14:41:01 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 1 Nov 2022 14:41:00 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb]) by
 RTEXMBS04.realtek.com.tw ([fe80::add3:284:fd3d:8adb%5]) with mapi id
 15.01.2375.007; Tue, 1 Nov 2022 14:41:00 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Colin Ian King <colin.i.king@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtlwifi: rtl8192ee: remove static variable stop_report_cnt
Thread-Topic: [PATCH] rtlwifi: rtl8192ee: remove static variable
 stop_report_cnt
Thread-Index: AQHY7UFi7CO5kegy5EyHq0HjTYwI4a4pNVXQgABpbtA=
Date:   Tue, 1 Nov 2022 06:41:00 +0000
Message-ID: <8c501b46825a4579a88ff16f53e9bcc4@realtek.com>
References: <20221031155637.871164-1-colin.i.king@gmail.com> 
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzExLzEg5LiK5Y2IIDA0OjU5OjAw?=
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

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBpbmctS2UgU2hpaA0KPiBT
ZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAxLCAyMDIyIDg6MjIgQU0NCj4gVG86ICdDb2xpbiBJYW4g
S2luZycgPGNvbGluLmkua2luZ0BnbWFpbC5jb20+OyBLYWxsZSBWYWxvIDxrdmFsb0BrZXJuZWwu
b3JnPjsgRGF2aWQgUyAuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVt
YXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5v
cmc+OyBQYW9sbyBBYmVuaQ0KPiA8cGFiZW5pQHJlZGhhdC5jb20+OyBsaW51eC13aXJlbGVzc0B2
Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtlcm5lbC1qYW5p
dG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3Vi
amVjdDogUkU6IFtQQVRDSF0gcnRsd2lmaTogcnRsODE5MmVlOiByZW1vdmUgc3RhdGljIHZhcmlh
YmxlIHN0b3BfcmVwb3J0X2NudA0KPiANCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gPiBGcm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT4NCj4g
PiBTZW50OiBNb25kYXksIE9jdG9iZXIgMzEsIDIwMjIgMTE6NTcgUE0NCj4gPiBUbzogUGluZy1L
ZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBLYWxsZSBWYWxvIDxrdmFsb0BrZXJuZWwub3Jn
PjsgRGF2aWQgUyAuIE1pbGxlcg0KPiA+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRXJpYyBEdW1h
emV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9y
Zz47IFBhb2xvIEFiZW5pDQo+ID4gPHBhYmVuaUByZWRoYXQuY29tPjsgbGludXgtd2lyZWxlc3NA
dmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4gQ2M6IGtlcm5lbC1q
YW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
PiBTdWJqZWN0OiBbUEFUQ0hdIHJ0bHdpZmk6IHJ0bDgxOTJlZTogcmVtb3ZlIHN0YXRpYyB2YXJp
YWJsZSBzdG9wX3JlcG9ydF9jbnQNCg0KU3ViamVjdCBwcmVmaXggc2hvdWxkIGJlICJ3aWZpOiBy
dGx3aWZpOiAuLi4iDQoNCkknbSBub3Qgc3VyZSBpZiBLYWxsZSBjYW4gaGVscCB0aGlzLCBvciB5
b3UgY2FuIHNlbmQgdjIgdG8gYWRkIHByZWZpeC4NCg0KPiA+DQo+ID4gVmFyaWFibGUgc3RvcF9y
ZXBvcnRfY250IGlzIGJlaW5nIHNldCBvciBpbmNyZW1lbnRlZCBidXQgaXMgbmV2ZXINCj4gPiBi
ZWluZyB1c2VkIGZvciBhbnl0aGluZyBtZWFuaW5nZnVsLiBUaGUgdmFyaWFibGUgYW5kIGNvZGUg
cmVsYXRpbmcNCj4gPiB0byBpdCdzIHVzZSBpcyByZWR1bmRhbnQgYW5kIGNhbiBiZSByZW1vdmVk
Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmkua2luZ0Bn
bWFpbC5jb20+DQo+IA0KPiBBY2tlZC1ieTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5j
b20+DQo+IA0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvcnRsODE5MmVlL3RyeC5jIHwgOCAtLS0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgOCBk
ZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0bHdpZmkvcnRsODE5MmVlL3RyeC5jDQo+ID4gYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0bHdpZmkvcnRsODE5MmVlL3RyeC5jDQo+ID4gaW5kZXggODA0M2Q4MTlmYjg1
Li5hMTgyY2RlYjU4ZTIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGx3aWZpL3J0bDgxOTJlZS90cnguYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4MTkyZWUvdHJ4LmMNCj4gPiBAQCAtOTk3LDcgKzk5Nyw2
IEBAIGJvb2wgcnRsOTJlZV9pc190eF9kZXNjX2Nsb3NlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywgdTggaHdfcXVldWUsIHUxNiBpbmRleCkNCj4gPiAgCXN0cnVjdCBydGxfcHJpdiAqcnRscHJp
diA9IHJ0bF9wcml2KGh3KTsNCj4gPiAgCXUxNiByZWFkX3BvaW50LCB3cml0ZV9wb2ludDsNCj4g
PiAgCWJvb2wgcmV0ID0gZmFsc2U7DQo+ID4gLQlzdGF0aWMgdTggc3RvcF9yZXBvcnRfY250Ow0K
PiA+ICAJc3RydWN0IHJ0bDgxOTJfdHhfcmluZyAqcmluZyA9ICZydGxwY2ktPnR4X3JpbmdbaHdf
cXVldWVdOw0KPiA+DQo+ID4gIAl7DQo+ID4gQEAgLTEwMzgsMTMgKzEwMzcsNiBAQCBib29sIHJ0
bDkyZWVfaXNfdHhfZGVzY19jbG9zZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHU4IGh3X3F1
ZXVlLCB1MTYgaW5kZXgpDQo+ID4gIAkgICAgcnRscHJpdi0+cHNjLnJmb2ZmX3JlYXNvbiA+IFJG
X0NIQU5HRV9CWV9QUykNCj4gPiAgCQlyZXQgPSB0cnVlOw0KPiA+DQo+ID4gLQlpZiAoaHdfcXVl
dWUgPCBCRUFDT05fUVVFVUUpIHsNCj4gPiAtCQlpZiAoIXJldCkNCj4gPiAtCQkJc3RvcF9yZXBv
cnRfY250Kys7DQo+ID4gLQkJZWxzZQ0KPiA+IC0JCQlzdG9wX3JlcG9ydF9jbnQgPSAwOw0KPiA+
IC0JfQ0KPiA+IC0NCj4gPiAgCXJldHVybiByZXQ7DQo+ID4gIH0NCj4gPg0KPiA+IC0tDQo+ID4g
Mi4zNy4zDQo+ID4NCj4gPg0KPiA+IC0tLS0tLVBsZWFzZSBjb25zaWRlciB0aGUgZW52aXJvbm1l
bnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
