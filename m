Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0EB52E6BE
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346754AbiETH7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346737AbiETH7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:59:01 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9376415AB30;
        Fri, 20 May 2022 00:59:00 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24K7wZEs9003479, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24K7wZEs9003479
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 May 2022 15:58:35 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 15:58:35 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 15:58:35 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Fri, 20 May 2022 15:58:35 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 09/10] rtw88: Add rtw8822bu chipset support
Thread-Topic: [PATCH 09/10] rtw88: Add rtw8822bu chipset support
Thread-Index: AQHYapDkSUSPgT6yp0uu/6R2ZMJcV60m44iA
Date:   Fri, 20 May 2022 07:58:35 +0000
Message-ID: <69be9d5fd2c173ee45d011f40a07fe31c53d0928.camel@realtek.com>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <20220518082318.3898514-10-s.hauer@pengutronix.de>
In-Reply-To: <20220518082318.3898514-10-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.17.21]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMjAg5LiK5Y2IIDA2OjAwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <B72DB886C9375545B07F6DC8941B7B57@realtek.com>
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

T24gV2VkLCAyMDIyLTA1LTE4IGF0IDEwOjIzICswMjAwLCBTYXNjaGEgSGF1ZXIgd3JvdGU6DQo+
IEFkZCBzdXBwb3J0IGZvciB0aGUgcnR3ODgyMmJ1IGNoaXBzZXQgYmFzZWQgb24NCj4gaHR0cHM6
Ly9naXRodWIuY29tL3VsbGkta3JvbGwvcnR3ODgtdXNiLmdpdA0KPiANCj4gU2lnbmVkLW9mZi1i
eTogU2FzY2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRlPg0KPiAtLS0NCj4gIGRyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvS2NvbmZpZyAgICB8IDExICsrKysNCj4gIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvTWFrZWZpbGUgICB8ICAzICsNCj4gIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMmIuYyB8IDE5ICsrKysrKw0K
PiAgLi4uL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjJidS5jICAgIHwgNjIgKysr
KysrKysrKysrKysrKysrKw0KPiAgLi4uL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4
MjJidS5oICAgIHwgMTUgKysrKysNCj4gIDUgZmlsZXMgY2hhbmdlZCwgMTEwIGluc2VydGlvbnMo
KykNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0
dzg4L3J0dzg4MjJidS5jDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydHc4OC9ydHc4ODIyYnUuaA0KPiANCj4gDQoNClsuLl0NCg0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIyYnUuaA0KPiBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMmJ1LmgNCj4gbmV3IGZp
bGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwMC4uMjBmMDFlY2Q3NDQxNQ0KPiAt
LS0gL2Rldi9udWxsDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgv
cnR3ODgyMmJ1LmgNCj4gQEAgLTAsMCArMSwxNSBAQA0KPiArLyogU1BEWC1MaWNlbnNlLUlkZW50
aWZpZXI6IEdQTC0yLjAgT1IgQlNELTMtQ2xhdXNlICovDQo+ICsvKiBDb3B5cmlnaHQoYykgMjAx
OC0yMDE5ICBSZWFsdGVrIENvcnBvcmF0aW9uDQo+ICsgKi8NCj4gKw0KPiArI2lmbmRlZiBfX1JU
V184ODIyQlVfSF8NCj4gKyNkZWZpbmUgX19SVFdfODgyMkJVX0hfDQo+ICsNCj4gKy8qIFVTQiBW
ZW5kb3IvUHJvZHVjdCBJRHMgKi8NCj4gKyNkZWZpbmUgUlRXX1VTQl9WRU5ET1JfSURfUkVBTFRF
SwkJMHgwQkRBDQoNCmxpa2Ugb3RoZXJzLCBtb3ZlIHRoaXMgdG8gdXNiLmgNCg0KDQotLQ0KUGlu
Zy1LZQ0KDQoNCg==
