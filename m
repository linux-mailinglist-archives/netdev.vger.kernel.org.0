Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280C252E686
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346625AbiETHsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344998AbiETHsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:48:15 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CBE76298;
        Fri, 20 May 2022 00:48:14 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24K7liLyB032652, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24K7liLyB032652
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 May 2022 15:47:44 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 15:47:44 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 15:47:44 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Fri, 20 May 2022 15:47:44 +0800
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
Subject: Re: [PATCH 07/10] rtw88: Add rtw8723du chipset support
Thread-Topic: [PATCH 07/10] rtw88: Add rtw8723du chipset support
Thread-Index: AQHYapDwy2YQk6wsf0GnqUewCAHU660m4IAA
Date:   Fri, 20 May 2022 07:47:44 +0000
Message-ID: <819189eb24ecece40e9d0c2a51f54d4084bb9493.camel@realtek.com>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <20220518082318.3898514-8-s.hauer@pengutronix.de>
In-Reply-To: <20220518082318.3898514-8-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.17.21]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMjAg5LiK5Y2IIDA2OjAwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C6B64D70F560F459474FACE1023442B@realtek.com>
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
IEFkZCBzdXBwb3J0IGZvciB0aGUgcnR3ODcyM2R1IGNoaXBzZXQgYmFzZWQgb24NCj4gaHR0cHM6
Ly9naXRodWIuY29tL3VsbGkta3JvbGwvcnR3ODgtdXNiLmdpdA0KPiANCj4gU2lnbmVkLW9mZi1i
eTogU2FzY2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRlPg0KPiAtLS0NCj4gIGRyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvS2NvbmZpZyAgICB8IDExICsrKysrDQo+ICBk
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L01ha2VmaWxlICAgfCAgMyArKw0KPiAg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4NzIzZC5jIHwgMTkgKysrKysr
KysrDQo+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg3MjNkLmggfCAg
MSArDQo+ICAuLi4vbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2R1LmMgICAgfCA0
MCArKysrKysrKysrKysrKysrKysrDQo+ICAuLi4vbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgv
cnR3ODcyM2R1LmggICAgfCAxMyArKysrKysNCj4gIDYgZmlsZXMgY2hhbmdlZCwgODcgaW5zZXJ0
aW9ucygrKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnR3ODgvcnR3ODcyM2R1LmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93
aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg3MjNkdS5oDQo+IA0KPiANCg0KWy4uLl0NCg0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4NzIzZHUu
Yw0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2R1LmMNCj4g
bmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwMC4uOTEwZjY0YzE2ODEz
MQ0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnR3ODgvcnR3ODcyM2R1LmMNCj4gQEAgLTAsMCArMSw0MCBAQA0KPiArLy8gU1BEWC1MaWNlbnNl
LUlkZW50aWZpZXI6IEdQTC0yLjAgT1IgQlNELTMtQ2xhdXNlDQo+ICsvKiBDb3B5cmlnaHQoYykg
MjAxOC0yMDE5ICBSZWFsdGVrIENvcnBvcmF0aW9uDQo+ICsgKi8NCj4gKw0KPiArI2luY2x1ZGUg
PGxpbnV4L21vZHVsZS5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L3VzYi5oPg0KPiArI2luY2x1ZGUg
Im1haW4uaCINCj4gKyNpbmNsdWRlICJydHc4NzIzZHUuaCINCj4gKyNpbmNsdWRlICJ1c2IuaCIN
Cj4gKw0KPiArc3RhdGljIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkIHJ0d184NzIzZHVfaWRf
dGFibGVbXSA9IHsNCj4gKwkvKg0KPiArCSAqIFVMTEkgOg0KPiArCSAqIElEIGZvdW5kIGluIHJ0
dzg4MjJidSBzb3VyY2VzDQo+ICsJICovDQoNCmNoZWNrcGF0Y2gucGwgd2lsbCB0ZWxsIHVzIHRo
aXMgY29tbWVudCBibG9jayBzaG91bGQgYmUNCg0KLyogVUxMSSA6DQogKiBJRCBmb3VuZCBpbiBy
dHc4ODIyYnUgc291cmNlcw0KICovDQoNCkJ1dCwgSSB0aGluayB3ZSBjYW4ganVzdCAiLyogVUxM
STogSUQgZm91bmQgaW4gcnR3ODgyMmJ1IHNvdXJjZXMgKi8iIA0KaWYgd2UgcmVhbGx5IHdhbnQg
dG8ga2VlcCB0aGlzIGNvbW1lbnQuDQoNCg0KWy4uLl0NCg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4NzIzZHUuaA0KPiBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2R1LmgNCj4gbmV3IGZpbGUgbW9kZSAxMDA2
NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwMC4uMmUwNjlmNjVjMDU1MQ0KPiAtLS0gL2Rldi9udWxs
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcnR3ODcyM2R1LmgN
Cj4gQEAgLTAsMCArMSwxMyBAQA0KPiArLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0y
LjAgT1IgQlNELTMtQ2xhdXNlICovDQo+ICsvKiBDb3B5cmlnaHQoYykgMjAxOC0yMDE5ICBSZWFs
dGVrIENvcnBvcmF0aW9uDQo+ICsgKi8NCj4gKw0KPiArI2lmbmRlZiBfX1JUV184NzIzRFVfSF8N
Cj4gKyNkZWZpbmUgX19SVFdfODcyM0RVX0hfDQo+ICsNCj4gKy8qIFVTQiBWZW5kb3IvUHJvZHVj
dCBJRHMgKi8NCj4gKyNkZWZpbmUgUlRXX1VTQl9WRU5ET1JfSURfUkVBTFRFSwkJMHgwQkRBDQoN
CnJ0dzg4MjFjdS5oIGFuZCBydHc4ODIyYnUuaCBkZWZpbmUgdGhpcyB0b28uDQpDYW4gd2UgbW92
ZSBpdCB0byB1c2IuaD8NCg0KDQo+ICsNCj4gK2V4dGVybiBzdHJ1Y3QgcnR3X2NoaXBfaW5mbyBy
dHc4NzIzZF9od19zcGVjOw0KPiArDQo+ICsjZW5kaWYNCg0KDQpQaW5nLUtlDQoNCg0K
