Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220D116F2AD
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 23:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbgBYWpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 17:45:16 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:36221 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbgBYWpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 17:45:15 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 12D8C891AA;
        Wed, 26 Feb 2020 11:45:11 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1582670711;
        bh=E2Bfu4fc4j6p7NFg4tTrbd/vXn2tcNQq3rTK3nWshUA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=rKvOBaZx42TAr+6AdLmWawHwTp4RvQhmWTJq/vIWLZsK74PcOBj0RvbxJ/nWYByOb
         tfORMMls9ld6keASQTeH+ZKeX5UoOfSs44Rq/L1v4ZW/7weBHVjmthvMZqCJZNsO7C
         0XY3a4Yh1macwhc1+KhrQHI9uUg3T17PTvCsGDUsBmMemyI6IC+A+Y49sChCxskgBM
         qYpS9IhAT95MVWqfHBVZL5jUxi9baePVy+BEsYUM7J+5aXV0owqwGmEtnZd7djN6vn
         /Y9nbTDruObHG3Odtg8xsMPysSqpHvgjVKvLy4BfArw3gzWPJn82kqegiCN/HrLgzw
         eimT5AJ3JUSrw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e55a3750001>; Wed, 26 Feb 2020 11:45:09 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb 2020 11:45:10 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Wed, 26 Feb 2020 11:45:10 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vadym.kochan@plvision.eu" <vadym.kochan@plvision.eu>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "volodymyr.mytnyk@plvision.eu" <volodymyr.mytnyk@plvision.eu>,
        "oleksandr.mazur@plvision.eu" <oleksandr.mazur@plvision.eu>,
        "andrii.savka@plvision.eu" <andrii.savka@plvision.eu>,
        "taras.chornyi@plvision.eu" <taras.chornyi@plvision.eu>,
        "serhiy.boiko@plvision.eu" <serhiy.boiko@plvision.eu>
Subject: Re: [RFC net-next 0/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX326x (AC3x)
Thread-Topic: [RFC net-next 0/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX326x (AC3x)
Thread-Index: AQHV6/jy7mjUjxYwxkS7hliqOPvXRagrqJaA
Date:   Tue, 25 Feb 2020 22:45:09 +0000
Message-ID: <1810583047af2d41d2521960f7a39f768748f2cb.camel@alliedtelesis.co.nz>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
In-Reply-To: <20200225163025.9430-1-vadym.kochan@plvision.eu>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:7442:d04a:557:a011]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D0BFC321CBCCA4F806DE73A60F64962@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmFkeW0sDQoNCk9uIFR1ZSwgMjAyMC0wMi0yNSBhdCAxNjozMCArMDAwMCwgVmFkeW0gS29j
aGFuIHdyb3RlOg0KPiBNYXJ2ZWxsIFByZXN0ZXJhIDk4RFgzMjZ4IGludGVncmF0ZXMgdXAgdG8g
MjQgcG9ydHMgb2YgMUdiRSB3aXRoIDgNCj4gcG9ydHMgb2YgMTBHYkUgdXBsaW5rcyBvciAyIHBv
cnRzIG9mIDQwR2JwcyBzdGFja2luZyBmb3IgYSBsYXJnZWx5DQo+IHdpcmVsZXNzIFNNQiBkZXBs
b3ltZW50Lg0KPiANCj4gUHJlc3RlcmEgU3dpdGNoZGV2IGlzIGEgZmlybXdhcmUgYmFzZWQgZHJp
dmVyIHdoaWNoIG9wZXJhdGVzIHZpYSBQQ0kNCj4gYnVzLiBUaGUgZHJpdmVyIGlzIHNwbGl0IGlu
dG8gMiBtb2R1bGVzOg0KPiANCj4gICAgIC0gcHJlc3RlcmFfc3cua28gLSBtYWluIGdlbmVyaWMg
U3dpdGNoZGV2IFByZXN0ZXJhIEFTSUMgcmVsYXRlZCBsb2dpYy4NCj4gDQo+ICAgICAtIHByZXN0
ZXJhX3BjaS5rbyAtIGJ1cyBzcGVjaWZpYyBjb2RlIHdoaWNoIGFsc28gaW1wbGVtZW50cyBmaXJt
d2FyZQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICBsb2FkaW5nIGFuZCBsb3ctbGV2ZWwgbWVz
c2FnaW5nIHByb3RvY29sIGJldHdlZW4NCj4gICAgICAgICAgICAgICAgICAgICAgICAgZmlybXdh
cmUgYW5kIHRoZSBzd2l0Y2hkZXYgZHJpdmVyLg0KPiANCj4gVGhpcyBkcml2ZXIgaW1wbGVtZW50
YXRpb24gaW5jbHVkZXMgb25seSBMMSAmIGJhc2ljIEwyIHN1cHBvcnQuDQo+IA0KPiBUaGUgY29y
ZSBQcmVzdGVyYSBzd2l0Y2hpbmcgbG9naWMgaXMgaW1wbGVtZW50ZWQgaW4gcHJlc3RlcmEuYywg
dGhlcmUgaXMNCj4gYW4gaW50ZXJtZWRpYXRlIGh3IGxheWVyIGJldHdlZW4gY29yZSBsb2dpYyBh
bmQgZmlybXdhcmUuIEl0IGlzDQo+IGltcGxlbWVudGVkIGluIHByZXN0ZXJhX2h3LmMsIHRoZSBw
dXJwb3NlIG9mIGl0IGlzIHRvIGVuY2Fwc3VsYXRlIGh3DQo+IHJlbGF0ZWQgbG9naWMsIGluIGZ1
dHVyZSB0aGVyZSBpcyBhIHBsYW4gdG8gc3VwcG9ydCBtb3JlIGRldmljZXMgd2l0aA0KPiBkaWZm
ZXJlbnQgSFcgcmVsYXRlZCBjb25maWd1cmF0aW9ucy4NCg0KVmVyeSBleGNpdGVkIGJ5IHRoaXMg
cGF0Y2ggc2VyaWVzLiBXZSBoYXZlIHNvbWUgY3VzdG9tIGRlc2lnbnMgdXNpbmcNCnRoZSBBQzN4
LiBJJ20gaW4gdGhlIHByb2Nlc3Mgb2YgZ2V0dGluZyB0aGUgYm9hcmQgZHRzZXMgcmVhZHkgZm9y
DQpzdWJtaXR0aW5nIHVwc3RyZWFtLiANCg0KUGxlYXNlIGZlZWwgZnJlZSB0byBhZGQgbWUgdG8g
dGhlIENjIGxpc3QgZm9yIGZ1dHVyZSB2ZXJzaW9ucyBvZiB0aGlzDQpwYXRjaCBzZXQgKGFuZCBy
ZWxlYXRlZCBvbmVzKS4NCg0KSSdsbCBhbHNvIGxvb2sgdG8gc2VlIHdoYXQgd2UgY2FuIGRvIHRv
IHRlc3Qgb24gb3VyIGhhcmR3YXJlIHBsYXRmb3Jtcy4NCg0KPiANCj4gVGhlIGZpcm13YXJlIGhh
cyB0byBiZSBsb2FkZWQgZWFjaCB0aW1lIGRldmljZSBpcyByZXNldC4gVGhlIGRyaXZlciBpcw0K
PiBsb2FkaW5nIGl0IGZyb206DQo+IA0KPiAgICAgL2xpYi9maXJtd2FyZS9tYXJ2ZWxsL3ByZXN0
ZXJhX2Z3X2ltZy5iaW4NCj4gDQo+IFRoZSBmaXJtd2FyZSBpbWFnZSB2ZXJzaW9uIGlzIGxvY2F0
ZWQgd2l0aGluIGludGVybmFsIGhlYWRlciBhbmQgY29uc2lzdHMNCj4gb2YgMyBudW1iZXJzIC0g
TUFKT1IuTUlOT1IuUEFUQ0guIEFkZGl0aW9uYWxseSwgZHJpdmVyIGhhcyBoYXJkLWNvZGVkDQo+
IG1pbmltdW0gc3VwcG9ydGVkIGZpcm13YXJlIHZlcnNpb24gd2hpY2ggaXQgY2FuIHdvcmsgd2l0
aDoNCj4gDQo+ICAgICBNQUpPUiAtIHJlZmxlY3RzIHRoZSBzdXBwb3J0IG9uIEFCSSBsZXZlbCBi
ZXR3ZWVuIGRyaXZlciBhbmQgbG9hZGVkDQo+ICAgICAgICAgICAgIGZpcm13YXJlLCB0aGlzIG51
bWJlciBzaG91bGQgYmUgdGhlIHNhbWUgZm9yIGRyaXZlciBhbmQNCj4gICAgICAgICAgICAgbG9h
ZGVkIGZpcm13YXJlLg0KPiANCj4gICAgIE1JTk9SIC0gdGhpcyBpcyB0aGUgbWluaW1hbCBzdXBw
b3J0ZWQgdmVyc2lvbiBiZXR3ZWVuIGRyaXZlciBhbmQgdGhlDQo+ICAgICAgICAgICAgIGZpcm13
YXJlLg0KPiANCj4gICAgIFBBVENIIC0gaW5kaWNhdGVzIG9ubHkgZml4ZXMsIGZpcm13YXJlIEFC
SSBpcyBub3QgY2hhbmdlZC4NCj4gDQo+IFRoZSBmaXJtd2FyZSBpbWFnZSB3aWxsIGJlIHN1Ym1p
dHRlZCB0byB0aGUgbGludXgtZmlybXdhcmUgYWZ0ZXIgdGhlDQo+IGRyaXZlciBpcyBhY2NlcHRl
ZC4NCj4gDQo+IFRoZSBmb2xsb3dpbmcgU3dpdGNoZGV2IGZlYXR1cmVzIGFyZSBzdXBwb3J0ZWQ6
DQo+IA0KPiAgICAgLSBWTEFOLWF3YXJlIGJyaWRnZSBvZmZsb2FkaW5nDQo+ICAgICAtIFZMQU4t
dW5hd2FyZSBicmlkZ2Ugb2ZmbG9hZGluZw0KPiAgICAgLSBGREIgb2ZmbG9hZGluZyAobGVhcm5p
bmcsIGFnZWluZykNCj4gICAgIC0gU3dpdGNocG9ydCBjb25maWd1cmF0aW9uDQo+IA0KPiBDUFUg
UlgvVFggc3VwcG9ydCB3aWxsIGJlIHByb3ZpZGVkIGluIHRoZSBuZXh0IGNvbnRyaWJ1dGlvbi4N
Cj4gDQo+IFZhZHltIEtvY2hhbiAoMyk6DQo+ICAgbmV0OiBtYXJ2ZWxsOiBwcmVzdGVyYTogQWRk
IFN3aXRjaGRldiBkcml2ZXIgZm9yIFByZXN0ZXJhIGZhbWlseSBBU0lDDQo+ICAgICBkZXZpY2Ug
OThEWDMyNXggKEFDM3gpDQo+ICAgbmV0OiBtYXJ2ZWxsOiBwcmVzdGVyYTogQWRkIFBDSSBpbnRl
cmZhY2Ugc3VwcG9ydA0KPiAgIGR0LWJpbmRpbmdzOiBtYXJ2ZWxsLHByZXN0ZXJhOiBBZGQgYWRk
cmVzcyBtYXBwaW5nIGZvciBQcmVzdGVyYQ0KPiAgICAgU3dpdGNoZGV2IFBDSWUgZHJpdmVyDQo+
IA0KPiAgLi4uL2JpbmRpbmdzL25ldC9tYXJ2ZWxsLHByZXN0ZXJhLnR4dCAgICAgICAgIHwgICAx
MyArDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL0tjb25maWcgICAgICAgICAgfCAg
ICAxICsNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvTWFrZWZpbGUgICAgICAgICB8
ICAgIDEgKw0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9wcmVzdGVyYS9LY29uZmln
IHwgICAyNCArDQo+ICAuLi4vbmV0L2V0aGVybmV0L21hcnZlbGwvcHJlc3RlcmEvTWFrZWZpbGUg
ICAgfCAgICA1ICsNCj4gIC4uLi9uZXQvZXRoZXJuZXQvbWFydmVsbC9wcmVzdGVyYS9wcmVzdGVy
YS5jICB8IDE1MDIgKysrKysrKysrKysrKysrKysNCj4gIC4uLi9uZXQvZXRoZXJuZXQvbWFydmVs
bC9wcmVzdGVyYS9wcmVzdGVyYS5oICB8ICAyNDQgKysrDQo+ICAuLi4vbWFydmVsbC9wcmVzdGVy
YS9wcmVzdGVyYV9kcnZfdmVyLmggICAgICAgfCAgIDIzICsNCj4gIC4uLi9ldGhlcm5ldC9tYXJ2
ZWxsL3ByZXN0ZXJhL3ByZXN0ZXJhX2h3LmMgICB8IDEwOTQgKysrKysrKysrKysrDQo+ICAuLi4v
ZXRoZXJuZXQvbWFydmVsbC9wcmVzdGVyYS9wcmVzdGVyYV9ody5oICAgfCAgMTU5ICsrDQo+ICAu
Li4vZXRoZXJuZXQvbWFydmVsbC9wcmVzdGVyYS9wcmVzdGVyYV9wY2kuYyAgfCAgODQwICsrKysr
KysrKw0KPiAgLi4uL21hcnZlbGwvcHJlc3RlcmEvcHJlc3RlcmFfc3dpdGNoZGV2LmMgICAgIHwg
MTIxNyArKysrKysrKysrKysrDQo+ICAxMiBmaWxlcyBjaGFuZ2VkLCA1MTIzIGluc2VydGlvbnMo
KykNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3By
ZXN0ZXJhL0tjb25maWcNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5l
dC9tYXJ2ZWxsL3ByZXN0ZXJhL01ha2VmaWxlDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWFydmVsbC9wcmVzdGVyYS9wcmVzdGVyYS5jDQo+ICBjcmVhdGUgbW9k
ZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9wcmVzdGVyYS9wcmVzdGVyYS5o
DQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9wcmVz
dGVyYS9wcmVzdGVyYV9kcnZfdmVyLmgNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25l
dC9ldGhlcm5ldC9tYXJ2ZWxsL3ByZXN0ZXJhL3ByZXN0ZXJhX2h3LmMNCj4gIGNyZWF0ZSBtb2Rl
IDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3ByZXN0ZXJhL3ByZXN0ZXJhX2h3
LmgNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3By
ZXN0ZXJhL3ByZXN0ZXJhX3BjaS5jDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWFydmVsbC9wcmVzdGVyYS9wcmVzdGVyYV9zd2l0Y2hkZXYuYw0KPiANCg==
