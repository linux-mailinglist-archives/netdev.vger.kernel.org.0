Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB8B46AFDF
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhLGBlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:41:36 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:40606 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229734AbhLGBlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:41:36 -0500
X-UUID: 32177f0f9dad488fbfee9df3ac98470c-20211207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=a+w0KP+ZqAlkYFHTZ/XSFagOIiGrcVHtihSDas+AcT4=;
        b=j7qV0gIriJWgPSxvYACBe8xuOczSgbVqyG/FuluiK26Nirbkr6b06MvSYIOKdMVjGDjvTG7gZ3dbOk5KreLcGcxX9gsfSAeFJZRA76heLXi2Se9Ezi4BibkTbjBtxLpNGA15obNHQgh5SW8iHjZE+Ilt0b2DZf4Lw+JA/jgW5bc=;
X-UUID: 32177f0f9dad488fbfee9df3ac98470c-20211207
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1468461342; Tue, 07 Dec 2021 09:38:02 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 7 Dec 2021 09:38:02 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 7 Dec 2021 09:38:01 +0800
Message-ID: <183a86f912ba28930845847c0b19b4118e3db80a.camel@mediatek.com>
Subject: Re: [PATCH v4 1/7] net-next: stmmac: dwmac-mediatek: add platform
 level clocks management
From:   Biao Huang <biao.huang@mediatek.com>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <dkirjanov@suse.de>
Date:   Tue, 7 Dec 2021 09:38:00 +0800
In-Reply-To: <9dc0cbc3-8de0-f1ed-cfc9-852b7e69ab3c@collabora.com>
References: <20211203063418.14892-1-biao.huang@mediatek.com>
         <20211203063418.14892-2-biao.huang@mediatek.com>
         <9dc0cbc3-8de0-f1ed-cfc9-852b7e69ab3c@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBBbmdlbG8sDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzfg0KDQpPbiBNb24sIDIwMjEt
MTItMDYgYXQgMTY6MTQgKzAxMDAsIEFuZ2Vsb0dpb2FjY2hpbm8gRGVsIFJlZ25vIHdyb3RlOg0K
PiBJbCAwMy8xMi8yMSAwNzozNCwgQmlhbyBIdWFuZyBoYSBzY3JpdHRvOg0KPiA+IFRoaXMgcGF0
Y2ggaW1wbGVtZW50cyBjbGtzX2NvbmZpZyBjYWxsYmFjayBmb3IgZHdtYWMtbWVkaWF0ZWsNCj4g
PiBwbGF0Zm9ybSwNCj4gPiB3aGljaCBjb3VsZCBzdXBwb3J0IHBsYXRmb3JtIGxldmVsIGNsb2Nr
cyBtYW5hZ2VtZW50Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpYW8gSHVhbmcgPGJpYW8u
aHVhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICAgLi4uL2V0aGVybmV0L3N0bWljcm8v
c3RtbWFjL2R3bWFjLW1lZGlhdGVrLmMgIHwgMjQNCj4gPiArKysrKysrKysrKysrKy0tLS0tDQo+
ID4gICAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMv
ZHdtYWMtbWVkaWF0ZWsuYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1t
YWMvZHdtYWMtbWVkaWF0ZWsuYw0KPiA+IGluZGV4IDU4YzBmZWFhODEzMS4uMTU3ZmY2NTVjODVl
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3
bWFjLW1lZGlhdGVrLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0
bW1hYy9kd21hYy1tZWRpYXRlay5jDQo+ID4gQEAgLTM1OSw5ICszNTksNiBAQCBzdGF0aWMgaW50
IG1lZGlhdGVrX2R3bWFjX2luaXQoc3RydWN0DQo+ID4gcGxhdGZvcm1fZGV2aWNlICpwZGV2LCB2
b2lkICpwcml2KQ0KPiA+ICAgCQlyZXR1cm4gcmV0Ow0KPiA+ICAgCX0NCj4gPiAgIA0KPiA+IC0J
cG1fcnVudGltZV9lbmFibGUoJnBkZXYtPmRldik7DQo+ID4gLQlwbV9ydW50aW1lX2dldF9zeW5j
KCZwZGV2LT5kZXYpOw0KPiA+IC0NCj4gPiAgIAlyZXR1cm4gMDsNCj4gPiAgIH0NCj4gPiAgIA0K
PiA+IEBAIC0zNzAsMTEgKzM2NywyNSBAQCBzdGF0aWMgdm9pZCBtZWRpYXRla19kd21hY19leGl0
KHN0cnVjdA0KPiA+IHBsYXRmb3JtX2RldmljZSAqcGRldiwgdm9pZCAqcHJpdikNCj4gPiAgIAlz
dHJ1Y3QgbWVkaWF0ZWtfZHdtYWNfcGxhdF9kYXRhICpwbGF0ID0gcHJpdjsNCj4gPiAgIA0KPiA+
ICAgCWNsa19idWxrX2Rpc2FibGVfdW5wcmVwYXJlKHBsYXQtPm51bV9jbGtzX3RvX2NvbmZpZywg
cGxhdC0NCj4gPiA+Y2xrcyk7DQo+ID4gLQ0KPiA+IC0JcG1fcnVudGltZV9wdXRfc3luYygmcGRl
di0+ZGV2KTsNCj4gPiAtCXBtX3J1bnRpbWVfZGlzYWJsZSgmcGRldi0+ZGV2KTsNCj4gPiAgIH0N
Cj4gPiAgIA0KPiA+ICtzdGF0aWMgaW50IG1lZGlhdGVrX2R3bWFjX2Nsa3NfY29uZmlnKHZvaWQg
KnByaXYsIGJvb2wgZW5hYmxlZCkNCj4gPiArew0KPiA+ICsJc3RydWN0IG1lZGlhdGVrX2R3bWFj
X3BsYXRfZGF0YSAqcGxhdCA9IHByaXY7DQo+ID4gKwlpbnQgcmV0ID0gMDsNCj4gPiArDQo+ID4g
KwlpZiAoZW5hYmxlZCkgew0KPiA+ICsJCXJldCA9IGNsa19idWxrX3ByZXBhcmVfZW5hYmxlKHBs
YXQtPm51bV9jbGtzX3RvX2NvbmZpZywgDQo+ID4gcGxhdC0+Y2xrcyk7DQo+ID4gKwkJaWYgKHJl
dCkgew0KPiA+ICsJCQlkZXZfZXJyKHBsYXQtPmRldiwgImZhaWxlZCB0byBlbmFibGUgY2xrcywg
ZXJyDQo+ID4gPSAlZFxuIiwgcmV0KTsNCj4gPiArCQkJcmV0dXJuIHJldDsNCj4gPiArCQl9DQo+
ID4gKwl9IGVsc2Ugew0KPiA+ICsJCWNsa19idWxrX2Rpc2FibGVfdW5wcmVwYXJlKHBsYXQtPm51
bV9jbGtzX3RvX2NvbmZpZywNCj4gPiBwbGF0LT5jbGtzKTsNCj4gPiArCX0NCj4gPiArDQo+ID4g
KwlyZXR1cm4gcmV0Ow0KPiA+ICt9DQo+ID4gICBzdGF0aWMgaW50IG1lZGlhdGVrX2R3bWFjX3By
b2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ID4gICB7DQo+ID4gICAJc3RydWN0
IG1lZGlhdGVrX2R3bWFjX3BsYXRfZGF0YSAqcHJpdl9wbGF0Ow0KPiA+IEBAIC00MjAsNiArNDMx
LDcgQEAgc3RhdGljIGludCBtZWRpYXRla19kd21hY19wcm9iZShzdHJ1Y3QNCj4gPiBwbGF0Zm9y
bV9kZXZpY2UgKnBkZXYpDQo+ID4gICAJcGxhdF9kYXQtPmJzcF9wcml2ID0gcHJpdl9wbGF0Ow0K
PiA+ICAgCXBsYXRfZGF0LT5pbml0ID0gbWVkaWF0ZWtfZHdtYWNfaW5pdDsNCj4gPiAgIAlwbGF0
X2RhdC0+ZXhpdCA9IG1lZGlhdGVrX2R3bWFjX2V4aXQ7DQo+ID4gKwlwbGF0X2RhdC0+Y2xrc19j
b25maWcgPSBtZWRpYXRla19kd21hY19jbGtzX2NvbmZpZzsNCj4gPiAgIAltZWRpYXRla19kd21h
Y19pbml0KHBkZXYsIHByaXZfcGxhdCk7DQo+ID4gICANCj4gPiAgIAlyZXQgPSBzdG1tYWNfZHZy
X3Byb2JlKCZwZGV2LT5kZXYsIHBsYXRfZGF0LCAmc3RtbWFjX3Jlcyk7DQo+ID4gDQo+IA0KPiBI
ZWxsbyBCaWFvLA0KPiANCj4geW91J3JlIHJlbW92aW5nIGFsbCBjYWxscyB0byBwbV9ydW50aW1l
XyogZnVuY3Rpb25zLCBzbyB0aGVyZSBpcyBubw0KPiBtb3JlIHJlYXNvbg0KPiB0byBpbmNsdWRl
IGxpbnV4L3BtX3J1bnRpbWUuaCBpbiB0aGlzIGZpbGU6IHBsZWFzZSBhbHNvIHJlbW92ZSB0aGUN
Cj4gaW5jbHVzaW9uLg0KPiANCj4gVGhhbmtzIQ0KWWVzLCBJJ2xsIHJlbW92ZSB0aGUgaW5jbHVz
aW9uIGluIHRoZSBuZXh0IHNlbmQuDQo=

