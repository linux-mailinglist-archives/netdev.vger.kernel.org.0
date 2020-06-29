Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42E420CC0C
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 05:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgF2DNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 23:13:19 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:34405 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgF2DNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 23:13:19 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 05T3Cv0L2020611, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 05T3Cv0L2020611
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 11:12:57 +0800
Received: from RTEXMB02.realtek.com.tw (172.21.6.95) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 29 Jun 2020 11:12:57 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 29 Jun 2020 11:12:56 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44]) by
 RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44%3]) with mapi id
 15.01.1779.005; Mon, 29 Jun 2020 11:12:56 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "joe@perches.com" <joe@perches.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi/*/dm.c: Use const in swing_table declarations
Thread-Topic: [PATCH] rtlwifi/*/dm.c: Use const in swing_table declarations
Thread-Index: AQHWTTVpFYNDXI1US0K76Im0pij3zqjuU+2AgAALz4CAAAX4gA==
Date:   Mon, 29 Jun 2020 03:12:56 +0000
Message-ID: <1593400347.12786.8.camel@realtek.com>
References: <0f24268338756bb54b4e44674db4aaf90f8a9fca.camel@perches.com>
         <1593396529.11412.6.camel@realtek.com>
         <45c908b9b55000dc7b0cf9438c8e6e44@perches.com>
In-Reply-To: <45c908b9b55000dc7b0cf9438c8e6e44@perches.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B202493E2F2C84395EEEFC9BEC3ABA1@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTA2LTI4IGF0IDE5OjUxIC0wNzAwLCBqb2VAcGVyY2hlcy5jb20gd3JvdGU6
DQo+IE9uIDIwMjAtMDYtMjggMTk6MDksIFBrc2hpaCB3cm90ZToNCj4gPiBPbiBTdW4sIDIwMjAt
MDYtMjggYXQgMDM6MTcgLTA3MDAsIEpvZSBQZXJjaGVzIHdyb3RlOg0KPiA+wqANCj4gPiBVc2Ug
J3J0bHdpZmk6JyBhcyBzdWJqZWN0IHRpdGxlIHByZWZpeCBpcyBlbm91Z2gsIGxpa2VzDQo+ID4g
wqAgcnRsd2lmaTogVXNlIGNvbnN0IGluIHN3aW5nX3RhYmxlIGRlY2xhcmF0aW9ucw0KPiANCj4g
V2UgZGlzYWdyZWUuDQo+IA0KPiBJIGxpa2Uga25vd2luZyB3aGF0IGNvbnRlbnQgaXMgY2hhbmdl
ZCB2aWEgcGF0Y2ggc3ViamVjdCBsaW5lcw0KPiBhcyB0aGVyZSBhcmUgMyBydGx3aWZpIGRyaXZl
cnMgYmVpbmcgY2hhbmdlZCBieSB0aGlzIG9uZSBwYXRjaC4NCg0KSWYgMyBkcml2ZXJzIGFyZSBu
ZWVkZWQgdG8gYmUgbGlzdGVkLCBJJ2QgdXNlIGJlbG93IHN1YmplY3QNCg0KInJ0bHdpZmk6IFVz
ZSBjb25zdCBpbiBydGw4MTg4ZWUvcnRsODcyM2JlL3J0bDg4MjFhZSBzd2luZ190YWJsZSBkZWNs
YXJhdGlvbnMiDQoNCj4gDQo+IEJ1dCB5b3VyIGNob2ljZSwgeW91IGNhbiBjaGFuZ2UgaXQgaWYg
eW91IGNob29zZS4NCj4gDQo+ID4+IFJlZHVjZSBkYXRhIHVzYWdlIGFib3V0IDFLQiBieSB1c2lu
ZyBjb25zdC4NCj4gW10NCj4gPiBQbGVhc2UgcmVtb3ZlIGJlbG93IHR5cGUgY2FzdGluZzrCoA0K
PiA+wqANCj4gPiBAQCAtMTg3MiwxMCArMTg3MiwxMCBAQCBzdGF0aWMgdm9pZMKgDQo+ID4gcnRs
ODgyMWFlX2dldF9kZWx0YV9zd2luZ190YWJsZShzdHJ1Y3QNCj4gPiBpZWVlODAyMTFfaHcgKmh3
LA0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKnVwX2IgPSBydGw4ODIxYWVf
ZGVsdGFfc3dpbmdfdGFibGVfaWR4XzVnYl9wWzJdOw0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgKmRvd25fYiA9IHJ0bDg4MjFhZV9kZWx0YV9zd2luZ190YWJsZV9pZHhfNWdi
X25bMl07DQo+ID4gwqDCoMKgwqDCoMKgwqDCoH0gZWxzZSB7DQo+ID4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAqdXBfYSA9ICh1OCAqKXJ0bDg4MThlX2RlbHRhX3N3aW5nX3RhYmxlX2lkeF8yNGdi
X3A7DQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqZG93bl9hID0gKHU4ICopcnRsODgxOGVf
ZGVsdGFfc3dpbmdfdGFibGVfaWR4XzI0Z2JfbjsNCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCp1cF9iID0gKHU4ICopcnRsODgxOGVfZGVsdGFfc3dpbmdfdGFibGVfaWR4XzI0Z2JfcDsNCj4g
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpkb3duX2IgPSAodTggKilydGw4ODE4ZV9kZWx0YV9z
d2luZ190YWJsZV9pZHhfMjRnYl9uOw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAqdXBfYSA9IHJ0bDg4MThlX2RlbHRhX3N3aW5nX3RhYmxlX2lkeF8yNGdiX3A7DQo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpkb3duX2EgPSBydGw4ODE4ZV9kZWx0YV9zd2lu
Z190YWJsZV9pZHhfMjRnYl9uOw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAq
dXBfYiA9IHJ0bDg4MThlX2RlbHRhX3N3aW5nX3RhYmxlX2lkeF8yNGdiX3A7DQo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpkb3duX2IgPSBydGw4ODE4ZV9kZWx0YV9zd2luZ190
YWJsZV9pZHhfMjRnYl9uOw0KPiANCj4gVGhlIGNvbXBpbGVyIGlzIHF1aWV0IGFib3V0IHRoaXMg
c28gSSBiZWxpZXZlIHRoaXMgdG8gYmUNCj4gYW4gdW5yZWxhdGVkIGNoYW5nZSBhbmQgd2hpdGVz
cGFjZSBjb3JyZWN0aW9uLg0KDQpJIGtub3cgY29tcGlsZXIgZG9lc24ndCB3YXJuIHRoaXMsIGJ1
dCBpdCBsb29rcyB3aXJlZCB0byBjYXN0ICdjb25zdCB1OCAqJw0KdG8gJ3U4IConIHRvICdjb25z
dCB1OCAqJy4NCg0KDQo+IA0KPiBPZiBjb3Vyc2UgeW91IGNvdWxkIG1vZGlmeSBpdCBpZiB5b3Ug
Y2hvb3NlLg0KPiANCj4gYnR3OiBUaGVyZSdzIGFuIHVubmVjZXNzYXJ5IHJldHVybiBhdCB0aGUg
Mm5kIGluc3RhbmNlDQo+IMKgwqDCoMKgwqDCoG9mIHRoaXMgY2FzdCByZW1vdmFsIHRvby4NCg0K
SXQgc2VlbXMgbGlrZSB0byBjb3B5IGZyb23CoHJ0bDg4MTJhZV9nZXRfZGVsdGFfc3dpbmdfdGFi
bGUoKSwgc28NCkkgY2FuIHJlbW92ZSBpdCBieSBhbm90aGVyIHBhdGNoLg0KDQo+IA0KPiBjaGVl
cnMsIEpvZQ0KPiANCj4gLS0tLS0tUGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZv
cmUgcHJpbnRpbmcgdGhpcyBlLW1haWwuDQo=
