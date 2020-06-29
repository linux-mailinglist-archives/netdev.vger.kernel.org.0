Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E927C20CBAB
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 04:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgF2CJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 22:09:51 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:51967 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgF2CJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 22:09:51 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 05T29OexC021234, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 05T29OexC021234
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 10:09:24 +0800
Received: from RTEXMB01.realtek.com.tw (172.21.6.94) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 29 Jun 2020 10:09:24 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 29 Jun 2020 10:09:24 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44]) by
 RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44%3]) with mapi id
 15.01.1779.005; Mon, 29 Jun 2020 10:09:24 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "joe@perches.com" <joe@perches.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi/*/dm.c: Use const in swing_table declarations
Thread-Topic: [PATCH] rtlwifi/*/dm.c: Use const in swing_table declarations
Thread-Index: AQHWTTVpFYNDXI1US0K76Im0pij3zqjuU+2A
Date:   Mon, 29 Jun 2020 02:09:24 +0000
Message-ID: <1593396529.11412.6.camel@realtek.com>
References: <0f24268338756bb54b4e44674db4aaf90f8a9fca.camel@perches.com>
In-Reply-To: <0f24268338756bb54b4e44674db4aaf90f8a9fca.camel@perches.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C60DE3664BCAF343A683245842115205@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTA2LTI4IGF0IDAzOjE3IC0wNzAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCg0K
VXNlICdydGx3aWZpOicgYXMgc3ViamVjdCB0aXRsZSBwcmVmaXggaXMgZW5vdWdoLCBsaWtlcw0K
wqAgcnRsd2lmaTogVXNlIGNvbnN0IGluIHN3aW5nX3RhYmxlIGRlY2xhcmF0aW9ucw0KDQo+IFJl
ZHVjZSBkYXRhIHVzYWdlIGFib3V0IDFLQiBieSB1c2luZyBjb25zdC4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEpvZSBQZXJjaGVzIDxqb2VAcGVyY2hlcy5jb20+DQo+IC0tLQ0KPiDCoC4uLi9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDgxODhlZS9kbS5jwqDCoMKgwqB8wqDCoDQgKy0N
Cj4gwqAuLi4vbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYmUvZG0uY8KgwqDC
oMKgfMKgwqA0ICstDQo+IMKgLi4uL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODgy
MWFlL2RtLmPCoMKgwqDCoHwgOTggKysrKysrKysrKysrLS0tLS0tLS0tDQo+IC0NCj4gwqAzIGZp
bGVzIGNoYW5nZWQsIDU2IGluc2VydGlvbnMoKyksIDUwIGRlbGV0aW9ucygtKQ0KPiANCj4gDQpb
Li4uXQ0KPsKgDQo+IMKgDQo+IMKgc3RhdGljIHZvaWQgcnRsODgxMmFlX2dldF9kZWx0YV9zd2lu
Z190YWJsZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCj4gLQkJCQkJwqDCoMKgwqB1OCAqKnVw
X2EsIHU4ICoqZG93bl9hLA0KPiAtCQkJCQnCoMKgwqDCoHU4ICoqdXBfYiwgdTggKipkb3duX2Ip
DQo+ICsJCQkJCcKgwqDCoMKgY29uc3QgdTggKip1cF9hLA0KPiArCQkJCQnCoMKgwqDCoGNvbnN0
IHU4ICoqZG93bl9hLA0KPiArCQkJCQnCoMKgwqDCoGNvbnN0IHU4ICoqdXBfYiwNCj4gKwkJCQkJ
wqDCoMKgwqBjb25zdCB1OCAqKmRvd25fYikNCj4gwqB7DQo+IMKgCXN0cnVjdCBydGxfcHJpdiAq
cnRscHJpdiA9IHJ0bF9wcml2KGh3KTsNCj4gwqAJc3RydWN0IHJ0bF9waHkgKnJ0bHBoeSA9ICZy
dGxwcml2LT5waHk7DQo+IA0KDQpQbGVhc2UgcmVtb3ZlIGJlbG93IHR5cGUgY2FzdGluZzrCoA0K
DQpAQCAtMTg3MiwxMCArMTg3MiwxMCBAQCBzdGF0aWMgdm9pZCBydGw4ODIxYWVfZ2V0X2RlbHRh
X3N3aW5nX3RhYmxlKHN0cnVjdA0KaWVlZTgwMjExX2h3ICpodywNCsKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgKnVwX2IgPSBydGw4ODIxYWVfZGVsdGFfc3dpbmdfdGFibGVfaWR4XzVn
Yl9wWzJdOw0KwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqZG93bl9iID0gcnRsODgy
MWFlX2RlbHRhX3N3aW5nX3RhYmxlX2lkeF81Z2JfblsyXTsNCsKgwqDCoMKgwqDCoMKgwqB9IGVs
c2Ugew0KLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqdXBfYSA9ICh1OCAqKXJ0bDg4MThlX2RlbHRh
X3N3aW5nX3RhYmxlX2lkeF8yNGdiX3A7DQotwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpkb3duX2Eg
PSAodTggKilydGw4ODE4ZV9kZWx0YV9zd2luZ190YWJsZV9pZHhfMjRnYl9uOw0KLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAqdXBfYiA9ICh1OCAqKXJ0bDg4MThlX2RlbHRhX3N3aW5nX3RhYmxlX2lk
eF8yNGdiX3A7DQotwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpkb3duX2IgPSAodTggKilydGw4ODE4
ZV9kZWx0YV9zd2luZ190YWJsZV9pZHhfMjRnYl9uOw0KK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCp1cF9hID0gcnRsODgxOGVfZGVsdGFfc3dpbmdfdGFibGVfaWR4XzI0Z2JfcDsNCivC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqZG93bl9hID0gcnRsODgxOGVfZGVsdGFfc3dp
bmdfdGFibGVfaWR4XzI0Z2JfbjsNCivCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqdXBf
YiA9IHJ0bDg4MThlX2RlbHRhX3N3aW5nX3RhYmxlX2lkeF8yNGdiX3A7DQorwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgKmRvd25fYiA9IHJ0bDg4MThlX2RlbHRhX3N3aW5nX3RhYmxlX2lk
eF8yNGdiX247DQrCoMKgwqDCoMKgwqDCoMKgfQ0KwqDCoMKgwqDCoMKgwqDCoHJldHVybjsNCsKg
fQ0KDQoNClsuLi5d
