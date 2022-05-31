Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED37538963
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 03:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242534AbiEaBBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 21:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238350AbiEaBBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 21:01:06 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F7A70924;
        Mon, 30 May 2022 18:01:03 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24V10OybC030273, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24V10OybC030273
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 31 May 2022 09:00:24 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 31 May 2022 09:00:24 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 31 May 2022 09:00:23 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Tue, 31 May 2022 09:00:23 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
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
Subject: Re: [PATCH v2 07/10] rtw88: Add rtw8821cu chipset support
Thread-Topic: [PATCH v2 07/10] rtw88: Add rtw8821cu chipset support
Thread-Index: AQHYdDPNfhsNNxWggUmawvqBEIgmQa03pQ4A
Date:   Tue, 31 May 2022 01:00:23 +0000
Message-ID: <0db09b608192b1d8d93b3034962bd322041aaeef.camel@realtek.com>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
         <20220530135457.1104091-8-s.hauer@pengutronix.de>
In-Reply-To: <20220530135457.1104091-8-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.20.31]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMzAg5LiL5Y2IIDEwOjE3OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <6EB704338A3C4F40B3376E6FDB65B00F@realtek.com>
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

T24gTW9uLCAyMDIyLTA1LTMwIGF0IDE1OjU0ICswMjAwLCBTYXNjaGEgSGF1ZXIgd3JvdGU6DQo+
IEFkZCBzdXBwb3J0IGZvciB0aGUgcnR3ODgyMWN1IGNoaXBzZXQgYmFzZWQgb24NCj4gaHR0cHM6
Ly9naXRodWIuY29tL3VsbGkta3JvbGwvcnR3ODgtdXNiLmdpdA0KPiANCj4gU2lnbmVkLW9mZi1i
eTogU2FzY2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRlPg0KPiANCg0KWy4uLl0NCg0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIx
Y3UuaA0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODgyMWN1LmgN
Cj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwMC4uYzg5Njc5MjI0
MDAxMQ0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnR3ODgvcnR3ODgyMWN1LmgNCj4gQEAgLTAsMCArMSwxMCBAQA0KPiArLyogU1BEWC1MaWNl
bnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgT1IgQlNELTMtQ2xhdXNlICovDQo+ICsvKiBDb3B5cmln
aHQoYykgMjAxOC0yMDE5ICBSZWFsdGVrIENvcnBvcmF0aW9uDQo+ICsgKi8NCj4gKw0KPiArI2lm
bmRlZiBfX1JUV184ODIxQ1VfSF8NCj4gKyNkZWZpbmUgX19SVFdfODgyMUNVX0hfDQo+ICsNCj4g
K2V4dGVybiBzdHJ1Y3QgcnR3X2NoaXBfaW5mbyBydHc4ODIxY19od19zcGVjOw0KDQpUaGlzIGV4
dGVybiBoYXMgbW92ZWQgdG8gcnR3ODgyMWMuaCBbMV0sIHNvIHdlIGRvbid0IG5lZWQgcnR3ODgy
MWN1LmguDQpBcyB3ZWxsIGFzIDg4MjJidS5oIGFuZCA4ODIyY3UuaC4NCg0KDQpbMV0gDQpodHRw
czovL2xvcmUua2VybmVsLm9yZy9saW51eC13aXJlbGVzcy8yMDIyMDUyNDE1MzYyMS4xOTAyNy0y
LUxhcnJ5LkZpbmdlckBsd2Zpbmdlci5uZXQvVC8jbTJlZGNjMzQ3ZGFhMDhkMTMzMDcxZWViMzQz
NzcwMTEwMDA1NGFmN2YNCg0KLS0NClBpbmctS2UNCg0KDQo=
