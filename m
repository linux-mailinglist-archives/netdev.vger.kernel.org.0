Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03EA22E5B7
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 08:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgG0GHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 02:07:39 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:40850 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgG0GHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 02:07:39 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 06R67FSJ0030013, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 06R67FSJ0030013
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Jul 2020 14:07:15 +0800
Received: from RTEXMB05.realtek.com.tw (172.21.6.98) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 27 Jul 2020 14:07:15 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 27 Jul 2020 14:07:14 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44]) by
 RTEXMB04.realtek.com.tw ([fe80::941:6388:7d34:5c44%3]) with mapi id
 15.01.1779.005; Mon, 27 Jul 2020 14:07:14 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "joe@perches.com" <joe@perches.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg uses
Thread-Topic: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
Thread-Index: AQHWYr2nd/FEJBO53EeTfs6a/wfURqkabMAA
Date:   Mon, 27 Jul 2020 06:07:14 +0000
Message-ID: <1595830034.12227.7.camel@realtek.com>
References: <cover.1595706419.git.joe@perches.com>
         <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
In-Reply-To: <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.213]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F409961BE03B7F4E8FA9124B20F9B9CC@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTA3LTI1IGF0IDEyOjU1IC0wNzAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
TWFrZSB0aGVzZSBzdGF0ZW1lbnRzIGEgbGl0dGxlIHNpbXBsZXIuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBKb2UgUGVyY2hlcyA8am9lQHBlcmNoZXMuY29tPg0KPiAtLS0NCj4gwqBkcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYmFzZS5jwqDCoMKgfCAxNCArKysrKy0tLS0tLQ0K
PiDCoC4uLi9ydGx3aWZpL2J0Y29leGlzdC9oYWxidGM4MTkyZTJhbnQuY8KgwqDCoMKgwqDCoMKg
fCAyMyArKysrKysrKysrLS0tLS0tLS0tDQo+IMKgLi4uL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0
Yzg4MjFhMmFudC5jwqDCoMKgwqDCoMKgwqB8IDEyICsrKysrLS0tLS0NCj4gwqAuLi4vcmVhbHRl
ay9ydGx3aWZpL2J0Y29leGlzdC9oYWxidGNvdXRzcmMuY8KgwqB8wqDCoDkgKysrKy0tLS0NCj4g
wqBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvcGNpLmPCoMKgwqDCoHzCoMKg
MiArLQ0KPiDCoDUgZmlsZXMgY2hhbmdlZCwgMzAgaW5zZXJ0aW9ucygrKSwgMzAgZGVsZXRpb25z
KC0pDQo+IA0KPiANCg0KWy4uLl0NCg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydGx3aWZpL2J0Y29leGlzdC9oYWxidGNvdXRzcmMuYw0KPiBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9idGNvZXhpc3QvaGFsYnRjb3V0c3JjLmMNCj4g
aW5kZXggOGQyOGM2OGYwODNlLi5mOWEyZDhhNjczMGMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9idGNvZXhpc3QvaGFsYnRjb3V0c3JjLmMNCj4g
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2J0Y29leGlzdC9oYWxi
dGNvdXRzcmMuYw0KPiBAQCAtODc0LDExICs4NzQsMTAgQEAgc3RhdGljIHZvaWQgaGFsYnRjX2Rp
c3BsYXlfd2lmaV9zdGF0dXMoc3RydWN0DQo+IGJ0Y19jb2V4aXN0ICpidGNvZXhpc3QsDQo+IMKg
CXNlcV9wcmludGYobSwgIlxuICUtMzVzID0gJXMgLyAlcy8gJXMvIEFQPSVkICIsDQo+IMKgCQnC
oMKgwqAiV2lmaSBmcmVxLyBidy8gdHJhZmZpYyIsDQo+IMKgCQnCoMKgwqBnbF9idGNfd2lmaV9m
cmVxX3N0cmluZ1t3aWZpX2ZyZXFdLA0KPiAtCQnCoMKgwqAoKHdpZmlfdW5kZXJfYl9tb2RlKSA/
ICIxMWIiIDoNCj4gLQkJwqDCoMKgwqBnbF9idGNfd2lmaV9id19zdHJpbmdbd2lmaV9id10pLA0K
PiAtCQnCoMKgwqAoKCF3aWZpX2J1c3kpID8gImlkbGUiIDogKChCVENfV0lGSV9UUkFGRklDX1RY
ID09DQo+IC0JCQkJCcKgwqDCoMKgwqDCoHdpZmlfdHJhZmZpY19kaXIpID8gInVwbGluayIgOg0K
PiAtCQkJCQnCoMKgwqDCoMKgImRvd25saW5rIikpLA0KPiArCQnCoMKgwqB3aWZpX3VuZGVyX2Jf
bW9kZSA/ICIxMWIiIDogZ2xfYnRjX3dpZmlfYndfc3RyaW5nW3dpZmlfYnddLA0KPiArCQnCoMKg
wqAoIXdpZmlfYnVzeSA/ICJpZGxlIiA6DQo+ICsJCcKgwqDCoMKgd2lmaV90cmFmZmljX2RpciA9
PSBCVENfV0lGSV9UUkFGRklDX1RYID8gInVwbGluayIgOg0KPiArCQnCoMKgwqDCoCJkb3dubGlu
ayIpLA0KDQpJIHRoaW5rIHRoaXMgd291bGQgYmUgYmV0dGVyDQoNCisJCcKgIMKgIXdpZmlfYnVz
eSA/ICJpZGxlIiA6DQorCQnCoCDCoCh3aWZpX3RyYWZmaWNfZGlyID09IEJUQ19XSUZJX1RSQUZG
SUNfVFggPyAidXBsaW5rIiA6DQorCQnCoMKgwqDCoCJkb3dubGluayIpLA0KDQoNCg0KPiDCoAkJ
wqDCoMKgYXBfbnVtKTsNCj4gwqANCj4gwqAJLyogcG93ZXIgc3RhdHVzCcKgKi8NCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9wY2kuYw0KPiBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9wY2kuYw0KPiBpbmRleCAxZDBhZjcy
ZWU3ODAuLjMxODlkMWM1MGQ1MiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
cmVhbHRlay9ydGx3aWZpL3BjaS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnRsd2lmaS9wY2kuYw0KPiBAQCAtNTU3LDcgKzU1Nyw3IEBAIHN0YXRpYyB2b2lkIF9ydGxf
cGNpX3R4X2lzcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgaW50DQo+IHByaW8pDQo+IMKgCQlp
ZiAocnRscHJpdi0+cnRsaGFsLmVhcmx5bW9kZV9lbmFibGUpDQo+IMKgCQkJc2tiX3B1bGwoc2ti
LCBFTV9IRFJfTEVOKTsNCj4gwqANCj4gLQkJcnRsX2RiZyhydGxwcml2LCAoQ09NUF9JTlRSIHwg
Q09NUF9TRU5EKSwgREJHX1RSQUNFLA0KPiArCQlydGxfZGJnKHJ0bHByaXYsIENPTVBfSU5UUiB8
IENPTVBfU0VORCwgREJHX1RSQUNFLA0KPiDCoAkJCSJuZXcgcmluZy0+aWR4OiVkLCBmcmVlOiBz
a2JfcXVldWVfbGVuOiVkLCBmcmVlOg0KPiBzZXE6JXhcbiIsDQo+IMKgCQkJcmluZy0+aWR4LA0K
PiDCoAkJCXNrYl9xdWV1ZV9sZW4oJnJpbmctPnF1ZXVlKSwNCg==
