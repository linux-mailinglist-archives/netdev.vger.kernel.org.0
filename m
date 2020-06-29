Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44C820CC2C
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 05:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgF2Deo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 23:34:44 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:36384 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgF2Deo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 23:34:44 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 05T3YTIZ0001786, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 05T3YTIZ0001786
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jun 2020 11:34:29 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 29 Jun 2020 11:34:29 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 29 Jun 2020 11:34:28 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44]) by
 RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44%3]) with mapi id
 15.01.1779.005; Mon, 29 Jun 2020 11:34:28 +0800
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
Thread-Index: AQHWTTVpFYNDXI1US0K76Im0pij3zqjuU+2AgAALz4CAAAX4gIAABgSA
Date:   Mon, 29 Jun 2020 03:34:28 +0000
Message-ID: <1593401639.12786.10.camel@realtek.com>
References: <0f24268338756bb54b4e44674db4aaf90f8a9fca.camel@perches.com>
         <1593396529.11412.6.camel@realtek.com>
         <45c908b9b55000dc7b0cf9438c8e6e44@perches.com>
         <1593400347.12786.8.camel@realtek.com>
In-Reply-To: <1593400347.12786.8.camel@realtek.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEC65D84A847A54D88AF8BD74C77E733@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA2LTI5IGF0IDExOjEyICswODAwLCBQa3NoaWggd3JvdGU6DQo+IE9uIFN1
biwgMjAyMC0wNi0yOCBhdCAxOTo1MSAtMDcwMCwgam9lQHBlcmNoZXMuY29tIHdyb3RlOg0KPiA+
IE9uIDIwMjAtMDYtMjggMTk6MDksIFBrc2hpaCB3cm90ZToNCj4gPiA+IE9uIFN1biwgMjAyMC0w
Ni0yOCBhdCAwMzoxNyAtMDcwMCwgSm9lIFBlcmNoZXMgd3JvdGU6DQo+ID4gPsKgDQo+ID4gPiBV
c2UgJ3J0bHdpZmk6JyBhcyBzdWJqZWN0IHRpdGxlIHByZWZpeCBpcyBlbm91Z2gsIGxpa2VzDQo+
ID4gPiDCoCBydGx3aWZpOiBVc2UgY29uc3QgaW4gc3dpbmdfdGFibGUgZGVjbGFyYXRpb25zDQo+
ID7CoA0KPiA+IFdlIGRpc2FncmVlLg0KPiA+wqANCj4gPiBJIGxpa2Uga25vd2luZyB3aGF0IGNv
bnRlbnQgaXMgY2hhbmdlZCB2aWEgcGF0Y2ggc3ViamVjdCBsaW5lcw0KPiA+IGFzIHRoZXJlIGFy
ZSAzIHJ0bHdpZmkgZHJpdmVycyBiZWluZyBjaGFuZ2VkIGJ5IHRoaXMgb25lIHBhdGNoLg0KPiAN
Cj4gSWYgMyBkcml2ZXJzIGFyZSBuZWVkZWQgdG8gYmUgbGlzdGVkLCBJJ2QgdXNlIGJlbG93IHN1
YmplY3QNCj4gDQo+ICJydGx3aWZpOiBVc2UgY29uc3QgaW4gcnRsODE4OGVlL3J0bDg3MjNiZS9y
dGw4ODIxYWUgc3dpbmdfdGFibGUgZGVjbGFyYXRpb25zIg0KPiANCj4gPsKgDQo+ID4gQnV0IHlv
dXIgY2hvaWNlLCB5b3UgY2FuIGNoYW5nZSBpdCBpZiB5b3UgY2hvb3NlLg0KPiA+wqANCj4gPiA+
PiBSZWR1Y2UgZGF0YSB1c2FnZSBhYm91dCAxS0IgYnkgdXNpbmcgY29uc3QuDQo+ID4gW10NCj4g
PiA+IFBsZWFzZSByZW1vdmUgYmVsb3cgdHlwZSBjYXN0aW5nOsKgDQo+ID4gPsKgDQo+ID4gPiBA
QCAtMTg3MiwxMCArMTg3MiwxMCBAQCBzdGF0aWMgdm9pZMKgDQo+ID4gPiBydGw4ODIxYWVfZ2V0
X2RlbHRhX3N3aW5nX3RhYmxlKHN0cnVjdA0KPiA+ID4gaWVlZTgwMjExX2h3ICpodywNCj4gPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKnVwX2IgPSBydGw4ODIxYWVfZGVsdGFf
c3dpbmdfdGFibGVfaWR4XzVnYl9wWzJdOw0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAqZG93bl9iID0gcnRsODgyMWFlX2RlbHRhX3N3aW5nX3RhYmxlX2lkeF81Z2Jfblsy
XTsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqB9IGVsc2Ugew0KPiA+ID4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAqdXBfYSA9ICh1OCAqKXJ0bDg4MThlX2RlbHRhX3N3aW5nX3RhYmxlX2lkeF8yNGdi
X3A7DQo+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpkb3duX2EgPSAodTggKilydGw4ODE4
ZV9kZWx0YV9zd2luZ190YWJsZV9pZHhfMjRnYl9uOw0KPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAqdXBfYiA9ICh1OCAqKXJ0bDg4MThlX2RlbHRhX3N3aW5nX3RhYmxlX2lkeF8yNGdiX3A7
DQo+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpkb3duX2IgPSAodTggKilydGw4ODE4ZV9k
ZWx0YV9zd2luZ190YWJsZV9pZHhfMjRnYl9uOw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCp1cF9hID0gcnRsODgxOGVfZGVsdGFfc3dpbmdfdGFibGVfaWR4XzI0Z2JfcDsN
Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAqZG93bl9hID0gcnRsODgxOGVf
ZGVsdGFfc3dpbmdfdGFibGVfaWR4XzI0Z2JfbjsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAqdXBfYiA9IHJ0bDg4MThlX2RlbHRhX3N3aW5nX3RhYmxlX2lkeF8yNGdiX3A7
DQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKmRvd25fYiA9IHJ0bDg4MThl
X2RlbHRhX3N3aW5nX3RhYmxlX2lkeF8yNGdiX247DQo+ID7CoA0KPiA+IFRoZSBjb21waWxlciBp
cyBxdWlldCBhYm91dCB0aGlzIHNvIEkgYmVsaWV2ZSB0aGlzIHRvIGJlDQo+ID4gYW4gdW5yZWxh
dGVkIGNoYW5nZSBhbmQgd2hpdGVzcGFjZSBjb3JyZWN0aW9uLg0KPiANCj4gSSBrbm93IGNvbXBp
bGVyIGRvZXNuJ3Qgd2FybiB0aGlzLCBidXQgaXQgbG9va3Mgd2lyZWQgdG8gY2FzdCAnY29uc3Qg
dTggKicNCj4gdG8gJ3U4IConIHRvICdjb25zdCB1OCAqJy4NCj4gDQo+IA0KPiA+wqANCj4gPiBP
ZiBjb3Vyc2UgeW91IGNvdWxkIG1vZGlmeSBpdCBpZiB5b3UgY2hvb3NlLg0KPiA+wqANCj4gPiBi
dHc6IFRoZXJlJ3MgYW4gdW5uZWNlc3NhcnkgcmV0dXJuIGF0IHRoZSAybmQgaW5zdGFuY2UNCj4g
PiDCoMKgwqDCoMKgwqBvZiB0aGlzIGNhc3QgcmVtb3ZhbCB0b28uDQo+IA0KPiBJdCBzZWVtcyBs
aWtlIHRvIGNvcHkgZnJvbcKgcnRsODgxMmFlX2dldF9kZWx0YV9zd2luZ190YWJsZSgpLCBzbw0K
PiBJIGNhbiByZW1vdmUgaXQgYnkgYW5vdGhlciBwYXRjaC4NCj4gDQoNClR3byBwYXRjaGVzIGFy
ZSBzZW50Og0KDQpydGx3aWZpOiA4ODIxYWU6IHJlbW92ZSB1bnVzZWQgcGF0aCBCIHBhcmFtZXRl
cnMgZnJvbSBzd2luZyB0YWJsZQ0KcnRsd2lmaTogVXNlIGNvbnN0IGluIDgxODhlZS84NzIzYmUv
ODgyMWFlIHN3aW5nX3RhYmxlIGRlY2xhcmF0aW9ucw0KDQotLS0NClRoYW5rcw0KUEsNCg==
