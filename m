Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EABD22E85E
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgG0JFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:05:05 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:57414 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgG0JFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:05:05 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 06R94WDj8029226, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 06R94WDj8029226
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Jul 2020 17:04:32 +0800
Received: from RTEXMB05.realtek.com.tw (172.21.6.98) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 27 Jul 2020 17:04:32 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 27 Jul 2020 17:04:32 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44]) by
 RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44%3]) with mapi id
 15.01.1779.005; Mon, 27 Jul 2020 17:04:32 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "joe@perches.com" <joe@perches.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg uses
Thread-Topic: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
Thread-Index: AQHWYr2nd/FEJBO53EeTfs6a/wfURqkabMAAgAAnRYCAAApCAA==
Date:   Mon, 27 Jul 2020 09:04:31 +0000
Message-ID: <1595840670.17671.4.camel@realtek.com>
References: <cover.1595706419.git.joe@perches.com>
         <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
         <1595830034.12227.7.camel@realtek.com>
         <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
In-Reply-To: <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.239.103]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D079F2225DFB045A56F9FC874DE8311@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA3LTI3IGF0IDAxOjI3IC0wNzAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
T24gTW9uLCAyMDIwLTA3LTI3IGF0IDA2OjA3ICswMDAwLCBQa3NoaWggd3JvdGU6DQo+ID4gT24g
U2F0LCAyMDIwLTA3LTI1IGF0IDEyOjU1IC0wNzAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4gPiA+
IE1ha2UgdGhlc2Ugc3RhdGVtZW50cyBhIGxpdHRsZSBzaW1wbGVyLg0KPiBbXQ0KPiA+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9idGNvZXhpc3Qv
aGFsYnRjb3V0c3JjLmMNCj4gW10NCj4gPiA+IEBAIC04NzQsMTEgKzg3NCwxMCBAQCBzdGF0aWMg
dm9pZCBoYWxidGNfZGlzcGxheV93aWZpX3N0YXR1cyhzdHJ1Y3QNCj4gPiA+IGJ0Y19jb2V4aXN0
ICpidGNvZXhpc3QsDQo+ID4gPsKgwqAJc2VxX3ByaW50ZihtLCAiXG4gJS0zNXMgPSAlcyAvICVz
LyAlcy8gQVA9JWQgIiwNCj4gPiA+wqDCoAkJwqDCoMKgIldpZmkgZnJlcS8gYncvIHRyYWZmaWMi
LA0KPiA+ID7CoMKgCQnCoMKgwqBnbF9idGNfd2lmaV9mcmVxX3N0cmluZ1t3aWZpX2ZyZXFdLA0K
PiA+ID4gLQkJwqDCoMKgKCh3aWZpX3VuZGVyX2JfbW9kZSkgPyAiMTFiIiA6DQo+ID4gPiAtCQnC
oMKgwqDCoGdsX2J0Y193aWZpX2J3X3N0cmluZ1t3aWZpX2J3XSksDQo+ID4gPiAtCQnCoMKgwqAo
KCF3aWZpX2J1c3kpID8gImlkbGUiIDogKChCVENfV0lGSV9UUkFGRklDX1RYID09DQo+ID4gPiAt
CQkJCQnCoMKgwqDCoMKgwqB3aWZpX3RyYWZmaWNfZGlyKSA/DQo+ICJ1cGxpbmsiIDoNCj4gPiA+
IC0JCQkJCcKgwqDCoMKgwqAiZG93bmxpbmsiKSksDQo+ID4gPiArCQnCoMKgwqB3aWZpX3VuZGVy
X2JfbW9kZSA/ICIxMWIiIDoNCj4gZ2xfYnRjX3dpZmlfYndfc3RyaW5nW3dpZmlfYnddLA0KPiA+
ID4gKwkJwqDCoMKgKCF3aWZpX2J1c3kgPyAiaWRsZSIgOg0KPiA+ID4gKwkJwqDCoMKgwqB3aWZp
X3RyYWZmaWNfZGlyID09IEJUQ19XSUZJX1RSQUZGSUNfVFggPyAidXBsaW5rIiA6DQo+ID4gPiAr
CQnCoMKgwqDCoCJkb3dubGluayIpLA0KPiA+wqANCj4gPiBJIHRoaW5rIHRoaXMgd291bGQgYmUg
YmV0dGVyDQo+ID7CoA0KPiA+ICsJCcKgwqDCoCF3aWZpX2J1c3kgPyAiaWRsZSIgOg0KPiA+ICsJ
CcKgwqDCoCh3aWZpX3RyYWZmaWNfZGlyID09IEJUQ19XSUZJX1RSQUZGSUNfVFggPyAidXBsaW5r
IiA6DQo+ID4gKwkJwqDCoMKgwqAiZG93bmxpbmsiKSwNCj4gDQo+IEl0IHNlZW1zIG1vc3QgcmVw
ZWF0ZWQgdGVzdDEgPyA6IHRlc3QyID8gOiB0ZXN0MyA/Og0KPiB1c2VzIGRvIG5vdCBoYXZlIHRo
ZSBzdHlsZSB5b3Ugc3VnZ2VzdCBpbiB0aGUga2VybmVsLg0KPiANCg0KWW91ciBjaGFuZ2UgaXPC
oA0KKHRlc3QxID8gOiB0ZXN0MiA/IDopDQoNClNvLCBJIHRoaW5rIHlvdSB3b3VsZCBsaWtlIHRv
IGhhdmUgcGFyZW50aGVzaXMgaW50ZW50aW9uYWxseS4NCklmIHNvLMKgDQp0ZXN0MSA/IDogKHRl
c3QyID8gOikNCndvdWxkIGJlIGJldHRlci4NCg0KDQpJZiBub3QsDQp0ZXN0MSA/IDogdGVzdDIg
PyA6DQptYXkgYmUgd2hhdCB5b3Ugd2FudCAod2l0aG91dCBhbnkgcGFyZW50aGVzaXMpLg0KDQo=
