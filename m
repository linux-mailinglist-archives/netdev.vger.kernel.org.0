Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80AD2F31B3
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbhALN0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:26:42 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:34829 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbhALN0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 08:26:41 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 10CDPnxqE013993, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 10CDPnxqE013993
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 21:25:49 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 21:25:48 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833]) by
 RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833%12]) with mapi id
 15.01.2106.006; Tue, 12 Jan 2021 21:25:48 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "abaci-bugfix@linux.alibaba.com" <abaci-bugfix@linux.alibaba.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] wireless: realtek: Simplify bool comparison
Thread-Topic: [PATCH] wireless: realtek: Simplify bool comparison
Thread-Index: AQHW6L5udHFk7cb9x0SUx7ByFdTlkqojdRmA
Date:   Tue, 12 Jan 2021 13:25:48 +0000
Message-ID: <1610457909.2793.7.camel@realtek.com>
References: <1610440751-79543-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1610440751-79543-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [125.224.66.71]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6ABC9E9D818E3D4E89EE9F83E8EEF54D@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTEyIGF0IDE2OjM5ICswODAwLCBZQU5HIExJIHdyb3RlOg0KPiBGaXgg
dGhlIGZvbGxvd2luZyBjb2NjaWNoZWNrIHdhcm5pbmc6DQo+IC4vZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydGx3aWZpL3BzLmM6ODAzOjctMjE6IFdBUk5JTkc6DQo+IENvbXBhcmlzb24g
dG8gYm9vbA0KPiANCj4gUmVwb3J0ZWQtYnk6IEFiYWNpIFJvYm90IDxhYmFjaUBsaW51eC5hbGli
YWJhLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWUFORyBMSSA8YWJhY2ktYnVnZml4QGxpbnV4LmFs
aWJhYmEuY29tPg0KPiAtLS0NCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvcHMuYyB8IDQgKystLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydGx3aWZpL3BzLmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdp
ZmkvcHMuYw0KPiBpbmRleCBmOTk4ODIyNS4uNjI5YzAzMiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3BzLmMNCj4gKysrIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3BzLmMNCj4gQEAgLTc5OCw5ICs3OTgsOSBAQCBzdGF0
aWMgdm9pZCBydGxfcDJwX25vYV9pZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgdm9pZA0KPiAq
ZGF0YSwNCj4gwqAJCWllICs9IDMgKyBub2FfbGVuOw0KPiDCoAl9DQo+IMKgDQo+IC0JaWYgKGZp
bmRfcDJwX2llID09IHRydWUpIHsNCj4gKwlpZiAoZmluZF9wMnBfaWUpIHsNCj4gwqAJCWlmICgo
cDJwaW5mby0+cDJwX3BzX21vZGUgPiBQMlBfUFNfTk9ORSkgJiYNCj4gLQkJwqDCoMKgwqAoZmlu
ZF9wMnBfcHNfaWUgPT0gZmFsc2UpKQ0KPiArCQnCoMKgwqDCoCghZmluZF9wMnBfcHNfaWUpKQ0K
PiDCoAkJCXJ0bF9wMnBfcHNfY21kKGh3LCBQMlBfUFNfRElTQUJMRSk7DQo+IMKgCX0NCj4gwqB9
DQoNClRoZSBzdWJqZWN0IHByZWZpeCBzaG91bGQgYmUgInJ0bHdpZmk6Ii4NCkFuZCwgSSB0aGlu
ayBpdCdzIG9rIHRvIG1lcmdlIHRoaXMgcGF0Y2ggd2l0aCBhbm90aGVyIHBhdGNowqANCigicnRs
d2lmaTogcnRsODgyMWFlOiBzdHlsZTogU2ltcGxpZnkgYm9vbCBjb21wYXJpc29uIikuDQpCZWNh
dXNlIGJvdGggb2YgdGhlbSBhcmUgdHJpdmlhbCBmaXhlcyBhbmQgYmVsb25nIHRvIHJ0bHdpZmku
DQoNCi0tLQ0KUGluZy1LZQ0KDQo=
