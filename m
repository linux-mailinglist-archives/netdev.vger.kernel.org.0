Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1B5476D41
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 10:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbhLPJTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 04:19:13 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:49730 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S235201AbhLPJTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 04:19:12 -0500
X-UUID: f91818ef3da34782b93f95ad3c737cfc-20211216
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=bTB+d+6540APzNiuwJ5CwBTovmrwX9Xq5yWvw8PCSXY=;
        b=cS9T+nR/oUDhKuj17kXm4Ub8rHufXyrLJAUMRPdXVtAHfbvQpQ2l9Ug65u5OXcNOqmdIXyTf6LQLJoJwf7vl00+DMG1IRYXatZ2LBGxtgaId8ESFEMfReOwFeab1MTBa4VPo3mfXlTExHD3Zyhy0Io5sZVkEyg97Jnw4z1t8BKk=;
X-UUID: f91818ef3da34782b93f95ad3c737cfc-20211216
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1481544654; Thu, 16 Dec 2021 17:19:09 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 16 Dec 2021 17:19:08 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Dec 2021 17:19:06 +0800
Message-ID: <a5f6a29fed9c0c886b4a09cfa258e8d87d0340fd.camel@mediatek.com>
Subject: Re: [PATCH net-next v8 3/6] arm64: dts: mt2712: update ethernet
 device node
From:   Biao Huang <biao.huang@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>, <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Date:   Thu, 16 Dec 2021 17:19:08 +0800
In-Reply-To: <c3f49e45-ccfe-dc11-52c5-c204d6f7a889@gmail.com>
References: <20211210013129.811-1-biao.huang@mediatek.com>
         <20211210013129.811-4-biao.huang@mediatek.com>
         <c3f49e45-ccfe-dc11-52c5-c204d6f7a889@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBNYXR0aGlhcywNCglUaGFua3MgZm9yIHlvdXIgY29tbWVudHN+DQoNCk9uIFdlZCwgMjAy
MS0xMi0xNSBhdCAyMDoyMCArMDEwMCwgTWF0dGhpYXMgQnJ1Z2dlciB3cm90ZToNCj4gDQo+IE9u
IDEwLzEyLzIwMjEgMDI6MzEsIEJpYW8gSHVhbmcgd3JvdGU6DQo+ID4gU2luY2UgdGhlcmUgYXJl
IHNvbWUgY2hhbmdlcyBpbiBldGhlcm5ldCBkcml2ZXIsDQo+ID4gdXBkYXRlIGV0aGVybmV0IGRl
dmljZSBub2RlIGluIGR0cyB0byBhY2NvbW1vZGF0ZSB0byBpdC4NCj4gPiANCj4gDQo+IEkgaGF2
ZSBhIGhhcmQgdGltZSB0byB1bmRlcnN0YW5kIGhvdyB0aGUgY2hhbmdlcyBpbiAxLzYgYW5kIDIv
NiBhcmUNCj4gcmVsYXRlZCB0byANCj4gdGhhdC4NCj4gDQo+IFBsZWFzZSBleHBsYWluIGJldHRl
ciB3aGF0IGhhcyBjaGFuZ2VkLiBBbHNvIGJld2FyZSB0aGF0IHdlIHNob3VsZG4ndA0KPiBpbnRy
b2R1Y2UgDQo+IGFueSBub24tYmFja3dhcmQgY29tcGF0aWJsZSBEVFMgY2hhbmdlcy4gVGhhdCBt
ZWFucywgdGhlIGRldmljZQ0KPiBzaG91bGQgd29yayB3aXRoIA0KPiB0aGUgbmV3IGRyaXZlciBi
dXQgYW4gb2xkZXIgZGV2aWNlIHRyZWUuDQo+IA0KPiBSZWdhcmRzLA0KPiBNYXR0aGlhcw0KPiAN
Cg0KaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvcGlwZXJtYWlsL2xpbnV4LW1lZGlhdGVrLzIw
MjEtRGVjZW1iZXIvMDMyODEyLmh0bWwNCkkndmUgYWRkIG1vcmUgZGV0YWlscyB0byBjb21taXQg
bWVzc2FnZSBpbiB2MTAgc2VuZCwNCnBsZWFzZSBraW5kbHkgcmV2aWV3IGl0Lg0KDQpSZWdhcmRz
IQ0KQmlhbw0KDQo+ID4gU2lnbmVkLW9mZi1ieTogQmlhbyBIdWFuZyA8Ymlhby5odWFuZ0BtZWRp
YXRlay5jb20+DQo+ID4gLS0tDQo+ID4gICBhcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210
MjcxMi1ldmIuZHRzIHwgIDEgKw0KPiA+ICAgYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9t
dDI3MTJlLmR0c2kgICB8IDE0ICsrKysrKysrKy0tLS0tDQo+ID4gICAyIGZpbGVzIGNoYW5nZWQs
IDEwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQyNzEyLWV2Yi5kdHMNCj4gPiBiL2FyY2gv
YXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQyNzEyLWV2Yi5kdHMNCj4gPiBpbmRleCA3ZDM2OWZk
ZDMxMTcuLjExYWExMzVhYTBmMyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL2FybTY0L2Jvb3QvZHRz
L21lZGlhdGVrL210MjcxMi1ldmIuZHRzDQo+ID4gKysrIGIvYXJjaC9hcm02NC9ib290L2R0cy9t
ZWRpYXRlay9tdDI3MTItZXZiLmR0cw0KPiA+IEBAIC0xMTAsNiArMTEwLDcgQEAgJmV0aCB7DQo+
ID4gICAJcGh5LWhhbmRsZSA9IDwmZXRoZXJuZXRfcGh5MD47DQo+ID4gICAJbWVkaWF0ZWssdHgt
ZGVsYXktcHMgPSA8MTUzMD47DQo+ID4gICAJc25wcyxyZXNldC1ncGlvID0gPCZwaW8gODcgR1BJ
T19BQ1RJVkVfTE9XPjsNCj4gPiArCXNucHMscmVzZXQtZGVsYXlzLXVzID0gPDAgMTAwMDAgMTAw
MDA+Ow0KPiA+ICAgCXBpbmN0cmwtbmFtZXMgPSAiZGVmYXVsdCIsICJzbGVlcCI7DQo+ID4gICAJ
cGluY3RybC0wID0gPCZldGhfZGVmYXVsdD47DQo+ID4gICAJcGluY3RybC0xID0gPCZldGhfc2xl
ZXA+Ow0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210Mjcx
MmUuZHRzaQ0KPiA+IGIvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDI3MTJlLmR0c2kN
Cj4gPiBpbmRleCBhOWNjYTljMTQ2ZmQuLjllODUwZTA0ZmZmYiAxMDA2NDQNCj4gPiAtLS0gYS9h
cmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210MjcxMmUuZHRzaQ0KPiA+ICsrKyBiL2FyY2gv
YXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQyNzEyZS5kdHNpDQo+ID4gQEAgLTcyNiw3ICs3MjYs
NyBAQCBxdWV1ZTIgew0KPiA+ICAgCX07DQo+ID4gICANCj4gPiAgIAlldGg6IGV0aGVybmV0QDEx
MDFjMDAwIHsNCj4gPiAtCQljb21wYXRpYmxlID0gIm1lZGlhdGVrLG10MjcxMi1nbWFjIjsNCj4g
PiArCQljb21wYXRpYmxlID0gIm1lZGlhdGVrLG10MjcxMi1nbWFjIiwgInNucHMsZHdtYWMtDQo+
ID4gNC4yMGEiOw0KPiA+ICAgCQlyZWcgPSA8MCAweDExMDFjMDAwIDAgMHgxMzAwPjsNCj4gPiAg
IAkJaW50ZXJydXB0cyA9IDxHSUNfU1BJIDIzNyBJUlFfVFlQRV9MRVZFTF9MT1c+Ow0KPiA+ICAg
CQlpbnRlcnJ1cHQtbmFtZXMgPSAibWFjaXJxIjsNCj4gPiBAQCAtNzM0LDE1ICs3MzQsMTkgQEAg
ZXRoOiBldGhlcm5ldEAxMTAxYzAwMCB7DQo+ID4gICAJCWNsb2NrLW5hbWVzID0gImF4aSIsDQo+
ID4gICAJCQkgICAgICAiYXBiIiwNCj4gPiAgIAkJCSAgICAgICJtYWNfbWFpbiIsDQo+ID4gLQkJ
CSAgICAgICJwdHBfcmVmIjsNCj4gPiArCQkJICAgICAgInB0cF9yZWYiLA0KPiA+ICsJCQkgICAg
ICAicm1paV9pbnRlcm5hbCI7DQo+ID4gICAJCWNsb2NrcyA9IDwmcGVyaWNmZyBDTEtfUEVSSV9H
TUFDPiwNCj4gPiAgIAkJCSA8JnBlcmljZmcgQ0xLX1BFUklfR01BQ19QQ0xLPiwNCj4gPiAgIAkJ
CSA8JnRvcGNrZ2VuIENMS19UT1BfRVRIRVJfMTI1TV9TRUw+LA0KPiA+IC0JCQkgPCZ0b3Bja2dl
biBDTEtfVE9QX0VUSEVSXzUwTV9TRUw+Ow0KPiA+ICsJCQkgPCZ0b3Bja2dlbiBDTEtfVE9QX0VU
SEVSXzUwTV9TRUw+LA0KPiA+ICsJCQkgPCZ0b3Bja2dlbiBDTEtfVE9QX0VUSEVSXzUwTV9STUlJ
X1NFTD47DQo+ID4gICAJCWFzc2lnbmVkLWNsb2NrcyA9IDwmdG9wY2tnZW4gQ0xLX1RPUF9FVEhF
Ul8xMjVNX1NFTD4sDQo+ID4gLQkJCQkgIDwmdG9wY2tnZW4gQ0xLX1RPUF9FVEhFUl81ME1fU0VM
PjsNCj4gPiArCQkJCSAgPCZ0b3Bja2dlbiBDTEtfVE9QX0VUSEVSXzUwTV9TRUw+LA0KPiA+ICsJ
CQkJICA8JnRvcGNrZ2VuDQo+ID4gQ0xLX1RPUF9FVEhFUl81ME1fUk1JSV9TRUw+Ow0KPiA+ICAg
CQlhc3NpZ25lZC1jbG9jay1wYXJlbnRzID0gPCZ0b3Bja2dlbg0KPiA+IENMS19UT1BfRVRIRVJQ
TExfMTI1TT4sDQo+ID4gLQkJCQkJIDwmdG9wY2tnZW4gQ0xLX1RPUF9BUExMMV9EMz47DQo+ID4g
KwkJCQkJIDwmdG9wY2tnZW4gQ0xLX1RPUF9BUExMMV9EMz4sDQo+ID4gKwkJCQkJIDwmdG9wY2tn
ZW4NCj4gPiBDTEtfVE9QX0VUSEVSUExMXzUwTT47DQo+ID4gICAJCXBvd2VyLWRvbWFpbnMgPSA8
JnNjcHN5cyBNVDI3MTJfUE9XRVJfRE9NQUlOX0FVRElPPjsNCj4gPiAgIAkJbWVkaWF0ZWsscGVy
aWNmZyA9IDwmcGVyaWNmZz47DQo+ID4gICAJCXNucHMsYXhpLWNvbmZpZyA9IDwmc3RtbWFjX2F4
aV9zZXR1cD47DQo+ID4gDQo=

