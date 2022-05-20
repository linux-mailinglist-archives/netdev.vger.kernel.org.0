Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAF052E6E5
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbiETIEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiETIEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:04:07 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F8B149D8E;
        Fri, 20 May 2022 01:04:05 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24K83V7e8005202, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24K83V7e8005202
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 May 2022 16:03:31 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 16:03:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 20 May 2022 16:03:30 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Fri, 20 May 2022 16:03:30 +0800
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
Subject: Re: [PATCH 10/10] rtw88: Add rtw8822cu chipset support
Thread-Topic: [PATCH 10/10] rtw88: Add rtw8822cu chipset support
Thread-Index: AQHYapDZWf6gD+YASkKjG/mcB1uml60m5OcA
Date:   Fri, 20 May 2022 08:03:30 +0000
Message-ID: <b19fcc328a8e436d27579bbf9e217a2be71b57b5.camel@realtek.com>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <20220518082318.3898514-11-s.hauer@pengutronix.de>
In-Reply-To: <20220518082318.3898514-11-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.17.21]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMjAg5LiK5Y2IIDA2OjM0OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A7F4BDA5022A641A7589E45466CD6E0@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
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
IEFkZCBzdXBwb3J0IGZvciB0aGUgcnR3ODgyMmN1IGNoaXBzZXQgYmFzZWQgb24NCj4gaHR0cHM6
Ly9naXRodWIuY29tL3VsbGkta3JvbGwvcnR3ODgtdXNiLmdpdA0KPiANCj4gU2lnbmVkLW9mZi1i
eTogU2FzY2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRlPg0KPiAtLS0NCj4gIGRyaXZl
cnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvS2NvbmZpZyAgICB8IDExICsrKysrDQo+ICBk
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L01ha2VmaWxlICAgfCAgMyArKw0KPiAg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIyYy5jIHwgMjQgKysrKysr
KysrKysNCj4gIC4uLi9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIyY3UuYyAgICB8
IDQwICsrKysrKysrKysrKysrKysrKysNCj4gIC4uLi9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4
OC9ydHc4ODIyY3UuaCAgICB8IDE1ICsrKysrKysNCj4gIDUgZmlsZXMgY2hhbmdlZCwgOTMgaW5z
ZXJ0aW9ucygrKQ0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnR3ODgvcnR3ODgyMmN1LmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjJjdS5oDQo+IA0KPiANCg0KWy4uLl0NCg0K
PiArTU9EVUxFX0FVVEhPUigiUmVhbHRlayBDb3Jwb3JhdGlvbiIpOw0KDQpPdXQgb2YgY3VyaW9z
aXR5LCB0aGVyZSBhcmUgbWFueSBhdXRob3JzIGluIHlvdXIgcGF0Y2hzZXQuDQpEbyB5b3UgY29s
bGVjdCB0aGVzZSBkcml2ZXIgZnJvbSB2YXJpb3VzIHBsYWNlcz8NCg0KcnR3ODcyM2R1LmM6TU9E
VUxFX0FVVEhPUigiSGFucyBVbGxpIEtyb2xsIDxsaW51eEB1bGxpLWtyb2xsLmRlPiIpOw0KcnR3
ODgyMWN1LmM6TU9EVUxFX0FVVEhPUigiSGFucyBVbGxpIEtyb2xsIDxsaW51eEB1bGxpLWtyb2xs
LmRlPiIpOw0KcnR3ODgyMmJ1LmM6TU9EVUxFX0FVVEhPUigiUmVhbHRlayBDb3Jwb3JhdGlvbiIp
Ow0KcnR3ODgyMmN1LmM6TU9EVUxFX0FVVEhPUigiUmVhbHRlayBDb3Jwb3JhdGlvbiIpOw0KdXNi
LmM6TU9EVUxFX0FVVEhPUigiUmVhbHRlayBDb3Jwb3JhdGlvbiIpOw0KDQoNCj4gK01PRFVMRV9E
RVNDUklQVElPTigiUmVhbHRlayA4MDIuMTFhYyB3aXJlbGVzcyA4ODIyY3UgZHJpdmVyIik7DQo+
ICtNT0RVTEVfTElDRU5TRSgiRHVhbCBCU0QvR1BMIik7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3J0dzg4MjJjdS5oDQo+IGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIyY3UuaA0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0
NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAwLi4xNmFmZTIyYTgyMTZjDQo+IC0tLSAvZGV2L251bGwN
Cj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9ydHc4ODIyY3UuaA0K
PiBAQCAtMCwwICsxLDE1IEBADQo+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIu
MCBPUiBCU0QtMy1DbGF1c2UgKi8NCj4gKy8qIENvcHlyaWdodChjKSAyMDE4LTIwMTkgIFJlYWx0
ZWsgQ29ycG9yYXRpb24NCj4gKyAqLw0KPiArDQo+ICsjaWZuZGVmIF9fUlRXXzg4MjJDVV9IXw0K
PiArI2RlZmluZSBfX1JUV184ODIyQ1VfSF8NCj4gKw0KPiArLyogVVNCIFZlbmRvci9Qcm9kdWN0
IElEcyAqLw0KPiArI2RlZmluZSBSVFdfVVNCX1ZFTkRPUl9JRF9SRUFMVEVLCQkweDBCREENCg0K
TGlrZSBvdGhlcnMsIG1vdmUgdGhpcyB0byB1c2IuaA0KDQo+ICsjZGVmaW5lIFJUV19VU0JfUFJP
RFVDVF9JRF9SRUFMVEVLXzg4MTJDCTB4QzgxMg0KPiArI2RlZmluZSBSVFdfVVNCX1BST0RVQ1Rf
SURfUkVBTFRFS184ODIyQwkweEM4MkMNCj4gKw0KPiArZXh0ZXJuIHN0cnVjdCBydHdfY2hpcF9p
bmZvIHJ0dzg4MjJjX2h3X3NwZWM7DQo+ICsNCj4gKyNlbmRpZg0KDQoNCi0tDQpQaW5nLUtlDQoN
Cg0K
