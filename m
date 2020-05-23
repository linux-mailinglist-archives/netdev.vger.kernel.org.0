Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5AE1DF5BB
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 09:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbgEWHq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 03:46:28 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:44571 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725294AbgEWHq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 03:46:27 -0400
X-UUID: 03777e6e78bf4d788124720909527d9b-20200523
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=K1YlH6sKupJLxMJK8vacs2+pPTOSyNUkbRTASPYPs78=;
        b=RT9OPW5J7GOUkmUxh8d8R8DlL7KcSaC82yN9fWOcLe2ZzJmmp6tpKUvjSpYM45kMHs1TWbyJ6zp3x7YSv7LpcijMZifvfT6OPnlCgVWDnW0M0cKwVZ1cm8HrNYXoep2cjI4NSI+fFZj8lQCpyghTsW0AatR/d0T3y+jpJUQu314=;
X-UUID: 03777e6e78bf4d788124720909527d9b-20200523
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1500851635; Sat, 23 May 2020 15:46:20 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkexhb02.mediatek.inc (172.21.101.103) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 23 May 2020 15:46:19 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 23 May 2020 15:46:18 +0800
Message-ID: <1590219979.19657.2.camel@mtkswgap22>
Subject: Re: [PATCH] mt76: mt7915: Use proper enum type in
 __mt7915_mcu_msg_send
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
CC:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
Date:   Sat, 23 May 2020 15:46:19 +0800
In-Reply-To: <20200523041923.3332257-1-natechancellor@gmail.com>
References: <20200523041923.3332257-1-natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTIyIGF0IDIxOjE5IC0wNzAwLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90
ZToNCj4gQ2xhbmcgd2FybnM6DQo+IA0KPiBkcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9t
dDc2L210NzkxNS9tY3UuYzoyMzI6OTogd2FybmluZzogaW1wbGljaXQNCj4gY29udmVyc2lvbiBm
cm9tIGVudW1lcmF0aW9uIHR5cGUgJ2VudW0gbXQ3Nl90eHFfaWQnIHRvIGRpZmZlcmVudA0KPiBl
bnVtZXJhdGlvbiB0eXBlICdlbnVtIG10NzkxNV90eHFfaWQnIFstV2VudW0tY29udmVyc2lvbl0N
Cj4gICAgICAgICAgICAgICAgIHR4cSA9IE1UX1RYUV9GV0RMOw0KPiAgICAgICAgICAgICAgICAg
ICAgIH4gXn5+fn5+fn5+fn4NCj4gZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9t
dDc5MTUvbWN1LmM6MjM5Ojk6IHdhcm5pbmc6IGltcGxpY2l0DQo+IGNvbnZlcnNpb24gZnJvbSBl
bnVtZXJhdGlvbiB0eXBlICdlbnVtIG10NzZfdHhxX2lkJyB0byBkaWZmZXJlbnQNCj4gZW51bWVy
YXRpb24gdHlwZSAnZW51bSBtdDc5MTVfdHhxX2lkJyBbLVdlbnVtLWNvbnZlcnNpb25dDQo+ICAg
ICAgICAgICAgICAgICB0eHEgPSBNVF9UWFFfTUNVX1dBOw0KPiAgICAgICAgICAgICAgICAgICAg
IH4gXn5+fn5+fn5+fn5+fg0KPiBkcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2L210
NzkxNS9tY3UuYzoyNDM6OTogd2FybmluZzogaW1wbGljaXQNCj4gY29udmVyc2lvbiBmcm9tIGVu
dW1lcmF0aW9uIHR5cGUgJ2VudW0gbXQ3Nl90eHFfaWQnIHRvIGRpZmZlcmVudA0KPiBlbnVtZXJh
dGlvbiB0eXBlICdlbnVtIG10NzkxNV90eHFfaWQnIFstV2VudW0tY29udmVyc2lvbl0NCj4gICAg
ICAgICAgICAgICAgIHR4cSA9IE1UX1RYUV9NQ1U7DQo+ICAgICAgICAgICAgICAgICAgICAgfiBe
fn5+fn5+fn5+DQo+IGRyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYvbXQ3OTE1L21j
dS5jOjI4NzozNjogd2FybmluZzoNCj4gaW1wbGljaXQgY29udmVyc2lvbiBmcm9tIGVudW1lcmF0
aW9uIHR5cGUgJ2VudW0gbXQ3OTE1X3R4cV9pZCcgdG8NCj4gZGlmZmVyZW50IGVudW1lcmF0aW9u
IHR5cGUgJ2VudW0gbXQ3Nl90eHFfaWQnIFstV2VudW0tY29udmVyc2lvbl0NCj4gICAgICAgICBy
ZXR1cm4gbXQ3Nl90eF9xdWV1ZV9za2JfcmF3KGRldiwgdHhxLCBza2IsIDApOw0KPiAgICAgICAg
ICAgICAgICB+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5efn5+fn5+fn5+fn4NCj4gDQo+IHR4
cSBzaG91bGQgYmUgYSAiZW51bSBtdDc2X3R4cV9pZCIgYXMgdmFsdWVzIG9mIHRoYXQgdHlwZSBh
cmUgdGhlIG9ubHkNCj4gb25lcyBhc3NpZ25lZCB0byBpdCBhbmQgdGhhdCBpcyB0aGUgdHlwZSB0
aGF0IG10NzZfdHhfcXVldWVfc2tiX3Jhdw0KPiBleHBlY3RzLg0KPiANCj4gRml4ZXM6IGU1N2I3
OTAxNDY5ZiAoIm10NzY6IGFkZCBtYWM4MDIxMSBkcml2ZXIgZm9yIE1UNzkxNSBQQ0llLWJhc2Vk
IGNoaXBzZXRzIikNCj4gTGluazogaHR0cHM6Ly9naXRodWIuY29tL0NsYW5nQnVpbHRMaW51eC9s
aW51eC9pc3N1ZXMvMTAzNQ0KPiBTaWduZWQtb2ZmLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0
ZWNoYW5jZWxsb3JAZ21haWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21l
ZGlhdGVrL210NzYvbXQ3OTE1L21jdS5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni9tdDc5MTUvbWN1LmMgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9tZWRpYXRlay9tdDc2L210NzkxNS9tY3UuYw0KPiBpbmRleCBmMDBhZDJiNjY3NjEuLjkxNmY2
NjRlOTY0ZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3
Ni9tdDc5MTUvbWN1LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3
Ni9tdDc5MTUvbWN1LmMNCj4gQEAgLTIyMCw3ICsyMjAsNyBAQCBzdGF0aWMgaW50IF9fbXQ3OTE1
X21jdV9tc2dfc2VuZChzdHJ1Y3QgbXQ3OTE1X2RldiAqZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2ti
LA0KPiAgew0KPiAgCXN0cnVjdCBtdDc5MTVfbWN1X3R4ZCAqbWN1X3R4ZDsNCj4gIAl1OCBzZXEs
IHBrdF9mbXQsIHFpZHg7DQo+IC0JZW51bSBtdDc5MTVfdHhxX2lkIHR4cTsNCj4gKwllbnVtIG10
NzZfdHhxX2lkIHR4cTsNCj4gIAlfX2xlMzIgKnR4ZDsNCj4gIAl1MzIgdmFsOw0KPiAgDQo+IA0K
PiBiYXNlLWNvbW1pdDogYzExZDI4YWI0YTY5MTczNmUzMGI0OTgxM2ZiODAxODQ3YmQ0NGU4Mw0K
DQpUaGFua3MuIEkgaGF2ZSBwb3N0ZWQgdGhlIGZpeCBoZXJlOg0KaHR0cHM6Ly9wYXRjaHdvcmsu
a2VybmVsLm9yZy9wYXRjaC8xMTU1MzQxNS8NClRoaXMgaXMgYWxyZWFkeSBpbiBGZWxpeCdzIHRy
ZWUuDQo=

