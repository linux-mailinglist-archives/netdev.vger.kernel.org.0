Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7054DBB82
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 01:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243142AbiCQALi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 20:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiCQALh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 20:11:37 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F8D19C22;
        Wed, 16 Mar 2022 17:10:20 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 22H0A0fnC004517, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 22H0A0fnC004517
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Mar 2022 08:10:00 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 17 Mar 2022 08:10:00 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 08:09:59 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::41d7:1d2e:78a6:ff34]) by
 RTEXMBS04.realtek.com.tw ([fe80::41d7:1d2e:78a6:ff34%5]) with mapi id
 15.01.2308.021; Thu, 17 Mar 2022 08:09:59 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Colin Ian King <colin.i.king@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtw89: Fix spelling mistake "Mis-Match" -> "Mismatch"
Thread-Topic: [PATCH] rtw89: Fix spelling mistake "Mis-Match" -> "Mismatch"
Thread-Index: AQHYOY+MjEpKADeJ1EiR/B9g/alLqKzCs3rQ
Date:   Thu, 17 Mar 2022 00:09:59 +0000
Message-ID: <895366eef1d44540beab3145a36a02bb@realtek.com>
References: <20220316234242.55515-1-colin.i.king@gmail.com>
In-Reply-To: <20220316234242.55515-1-colin.i.king@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzMvMTYg5LiL5Y2IIDA1OjE3OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbGluIElhbiBLaW5nIDxj
b2xpbi5pLmtpbmdAZ21haWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMTcsIDIwMjIg
Nzo0MyBBTQ0KPiBUbzogUGtzaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBLYWxsZSBWYWxvIDxr
dmFsb0BrZXJuZWwub3JnPjsgRGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47
DQo+IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBsaW51eC13aXJlbGVzc0B2Z2Vy
Lmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtlcm5lbC1qYW5pdG9y
c0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVj
dDogW1BBVENIXSBydHc4OTogRml4IHNwZWxsaW5nIG1pc3Rha2UgIk1pcy1NYXRjaCIgLT4gIk1p
c21hdGNoIg0KPiANCj4gVGhlcmUgYXJlIHNvbWUgc3BlbGxpbmcgbWlzdGFrZXMgaW4gc29tZSBs
aXRlcmFsIHN0cmluZ3MuIEZpeCB0aGVtLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFu
IEtpbmcgPGNvbGluLmkua2luZ0BnbWFpbC5jb20+DQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWgg
PHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnR3ODkvY29leC5jIHwgNiArKystLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydHc4OS9jb2V4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0dzg5L2NvZXguYw0KPiBpbmRleCAwN2YyNjcxOGI2NmYuLjk5YWJkMGZlN2YxNSAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9jb2V4LmMNCj4g
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS9jb2V4LmMNCj4gQEAgLTQ2
MjMsMTIgKzQ2MjMsMTIgQEAgc3RhdGljIHZvaWQgX3Nob3dfY3hfaW5mbyhzdHJ1Y3QgcnR3ODlf
ZGV2ICpydHdkZXYsIHN0cnVjdCBzZXFfZmlsZSAqbSkNCj4gIAl2ZXJfaG90Zml4ID0gRklFTERf
R0VUKEdFTk1BU0soMTUsIDgpLCBjaGlwLT53bGN4X2Rlc2lyZWQpOw0KPiAgCXNlcV9wcmludGYo
bSwgIiglcywgZGVzaXJlZDolZC4lZC4lZCksICIsDQo+ICAJCSAgICh3bC0+dmVyX2luZm8uZndf
Y29leCA+PSBjaGlwLT53bGN4X2Rlc2lyZWQgPw0KPiAtCQkgICAiTWF0Y2giIDogIk1pcy1NYXRj
aCIpLCB2ZXJfbWFpbiwgdmVyX3N1YiwgdmVyX2hvdGZpeCk7DQo+ICsJCSAgICJNYXRjaCIgOiAi
TWlzbWF0Y2giKSwgdmVyX21haW4sIHZlcl9zdWIsIHZlcl9ob3RmaXgpOw0KPiANCj4gIAlzZXFf
cHJpbnRmKG0sICJCVF9GV19jb2V4OiVkKCVzLCBkZXNpcmVkOiVkKVxuIiwNCj4gIAkJICAgYnQt
PnZlcl9pbmZvLmZ3X2NvZXgsDQo+ICAJCSAgIChidC0+dmVyX2luZm8uZndfY29leCA+PSBjaGlw
LT5idGN4X2Rlc2lyZWQgPw0KPiAtCQkgICAiTWF0Y2giIDogIk1pcy1NYXRjaCIpLCBjaGlwLT5i
dGN4X2Rlc2lyZWQpOw0KPiArCQkgICAiTWF0Y2giIDogIk1pc21hdGNoIiksIGNoaXAtPmJ0Y3hf
ZGVzaXJlZCk7DQo+IA0KPiAgCWlmIChidC0+ZW5hYmxlLm5vdyAmJiBidC0+dmVyX2luZm8uZncg
PT0gMCkNCj4gIAkJcnR3ODlfYnRjX2Z3X2VuX3JwdChydHdkZXYsIFJQVF9FTl9CVF9WRVJfSU5G
TywgdHJ1ZSk7DQo+IEBAIC01MDc1LDcgKzUwNzUsNyBAQCBzdGF0aWMgdm9pZCBfc2hvd19kbV9p
bmZvKHN0cnVjdCBydHc4OV9kZXYgKnJ0d2Rldiwgc3RydWN0IHNlcV9maWxlICptKQ0KPiAgCXNl
cV9wcmludGYobSwgImxlYWtfYXA6JWQsIGZ3X29mZmxvYWQ6JXMlc1xuIiwgZG0tPmxlYWtfYXAs
DQo+ICAJCSAgIChCVENfQ1hfRldfT0ZGTE9BRCA/ICJZIiA6ICJOIiksDQo+ICAJCSAgIChkbS0+
d2xfZndfY3hfb2ZmbG9hZCA9PSBCVENfQ1hfRldfT0ZGTE9BRCA/DQo+IC0JCSAgICAiIiA6ICIo
TWlzLU1hdGNoISEpIikpOw0KPiArCQkgICAgIiIgOiAiKE1pc21hdGNoISEpIikpOw0KPiANCj4g
IAlpZiAoZG0tPnJmX3RyeF9wYXJhLndsX3R4X3Bvd2VyID09IDB4ZmYpDQo+ICAJCXNlcV9wcmlu
dGYobSwNCj4gLS0NCj4gMi4zNS4xDQo+IA0KPiAtLS0tLS1QbGVhc2UgY29uc2lkZXIgdGhlIGVu
dmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
