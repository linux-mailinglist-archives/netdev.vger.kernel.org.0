Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D96476821
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 03:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhLPCeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 21:34:10 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:54512 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229972AbhLPCeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 21:34:09 -0500
X-UUID: 2645b85d949c4af4a8a6da26b151cd62-20211216
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Llo3GNG3LefL9fq8uRh9hI0WF+b/t4xEI+BOfK4DeHc=;
        b=HMgEGaV9Han0/KxGAR7ODIaZNrIu14oy5fs0Fui+RN0059hw6ekKTN5X+UxCAkTodbosAJZb6lPyTzOA5tpdhCBOUKdXAqi9DNyk4KjkE/Z6883SxcuQdLm5bRT6sN7C6036BJzlgMbVxSvBqaHH6rxT+EKWmwmics4D31ok7CU=;
X-UUID: 2645b85d949c4af4a8a6da26b151cd62-20211216
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 245205377; Thu, 16 Dec 2021 10:34:05 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 16 Dec 2021 10:34:04 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Dec 2021 10:34:03 +0800
Message-ID: <151fc4556ba03703dffa30aeb8f24aee489c855c.camel@mediatek.com>
Subject: Re: [PATCH net-next v9 6/6] net: dt-bindings: dwmac: add support
 for mt8195
From:   Biao Huang <biao.huang@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
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
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Date:   Thu, 16 Dec 2021 10:34:04 +0800
In-Reply-To: <YbpobIscSDPKuxxY@robh.at.kernel.org>
References: <20211215021652.7270-1-biao.huang@mediatek.com>
         <20211215021652.7270-7-biao.huang@mediatek.com>
         <YbpobIscSDPKuxxY@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBSb2IsDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzfg0KT24gV2VkLCAyMDIxLTEyLTE1
IGF0IDE2OjEzIC0wNjAwLCBSb2IgSGVycmluZyB3cm90ZToNCj4gT24gV2VkLCBEZWMgMTUsIDIw
MjEgYXQgMTA6MTY6NTJBTSArMDgwMCwgQmlhbyBIdWFuZyB3cm90ZToNCj4gPiBBZGQgYmluZGlu
ZyBkb2N1bWVudCBmb3IgdGhlIGV0aGVybmV0IG9uIG10ODE5NS4NCj4gPiANCj4gPiBTaWduZWQt
b2ZmLWJ5OiBCaWFvIEh1YW5nIDxiaWFvLmh1YW5nQG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4g
PiAgLi4uL2JpbmRpbmdzL25ldC9tZWRpYXRlay1kd21hYy55YW1sICAgICAgICAgIHwgNDIgKysr
KysrKysrKysrKystDQo+ID4gLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMzIgaW5zZXJ0aW9u
cygrKSwgMTAgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstDQo+ID4gZHdtYWMueWFtbCBiL0Rv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstDQo+ID4gZHdtYWMu
eWFtbA0KPiA+IGluZGV4IDhhZDZlMTk2NjFiOC4uNDRkNTUxNDZkZWY0IDEwMDY0NA0KPiA+IC0t
LSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstZHdtYWMu
eWFtbA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVk
aWF0ZWstZHdtYWMueWFtbA0KPiA+IEBAIC0xOSw2ICsxOSw3IEBAIHNlbGVjdDoNCj4gPiAgICAg
ICAgY29udGFpbnM6DQo+ID4gICAgICAgICAgZW51bToNCj4gPiAgICAgICAgICAgIC0gbWVkaWF0
ZWssbXQyNzEyLWdtYWMNCj4gPiArICAgICAgICAgIC0gbWVkaWF0ZWssbXQ4MTk1LWdtYWMNCj4g
PiAgICByZXF1aXJlZDoNCj4gPiAgICAgIC0gY29tcGF0aWJsZQ0KPiA+ICANCj4gPiBAQCAtMjcs
MjYgKzI4LDM3IEBAIGFsbE9mOg0KPiA+ICANCj4gPiAgcHJvcGVydGllczoNCj4gPiAgICBjb21w
YXRpYmxlOg0KPiA+IC0gICAgaXRlbXM6DQo+ID4gLSAgICAgIC0gZW51bToNCj4gPiAtICAgICAg
ICAgIC0gbWVkaWF0ZWssbXQyNzEyLWdtYWMNCj4gPiAtICAgICAgLSBjb25zdDogc25wcyxkd21h
Yy00LjIwYQ0KPiA+ICsgICAgb25lT2Y6DQo+ID4gKyAgICAgIC0gaXRlbXM6DQo+ID4gKyAgICAg
ICAgICAtIGVudW06DQo+ID4gKyAgICAgICAgICAgICAgLSBtZWRpYXRlayxtdDI3MTItZ21hYw0K
PiA+ICsgICAgICAgICAgLSBjb25zdDogc25wcyxkd21hYy00LjIwYQ0KPiA+ICsgICAgICAtIGl0
ZW1zOg0KPiA+ICsgICAgICAgICAgLSBlbnVtOg0KPiA+ICsgICAgICAgICAgICAgIC0gbWVkaWF0
ZWssbXQ4MTk1LWdtYWMNCj4gPiArICAgICAgICAgIC0gY29uc3Q6IHNucHMsZHdtYWMtNS4xMGEN
Cj4gPiAgDQo+ID4gICAgY2xvY2tzOg0KPiA+ICsgICAgbWluSXRlbXM6IDUNCj4gDQo+IEFzIGJl
Zm9yZSwgeW91IG5lZWQgJ21pbkl0ZW1zOiA0JyBpbiB0aGUgcHJldmlvdXMgcGF0Y2guDQo+IA0K
PiBJZiB5b3UgYXJlbid0IGNsZWFyIHdoYXQncyBuZWVkZWQsIHJ1biAnbWFrZSBkdGJzX2NoZWNr
cycgeW91cnNlbGYgDQo+IGJlZm9yZSBzdWJtaXR0aW5nIGFnYWluLg0KDQpCdXQgYXMgbW9kaWZp
ZWQgaW4gIltQQVRDSCBuZXQtbmV4dCB2OSAzLzZdIGFybTY0OiBkdHM6IG10MjcxMjogdXBkYXRl
DQpldGhlcm5ldCBkZXZpY2Ugbm9kZSIsIHdlIGV4cGVjdCAibWluSXRlbXM6IDUiLg0KDQpydW4g
J21ha2UgZHRic19jaGVja3MnIHdpdGggIltQQVRDSCBuZXQtbmV4dCB2OSAzLzZdIGFybTY0OiBk
dHM6DQptdDI3MTI6IHVwZGF0ZSBldGhlcm5ldCBkZXZpY2Ugbm9kZSIgYXBwbGllZCwgd2lsbCBu
b3QgcmVwb3J0IGxvZ3Mgc3VjaA0KYXMgImV0aGVybmV0QDExMDFjMDAwOiBjbG9jay1uYW1lczog
WydheGknLCAnYXBiJywgJ21hY19tYWluJywNCidwdHBfcmVmJ10gaXMgdG9vIHNob3J0Ii4NCg0K
U2hvdWxkIGl0IGJlIGZpbmUgaWYgSSBrZWVwICJtaW5JdGVtczo1Ij8NCj4gDQo+ID4gICAgICBp
dGVtczoNCj4gPiAgICAgICAgLSBkZXNjcmlwdGlvbjogQVhJIGNsb2NrDQo+ID4gICAgICAgIC0g
ZGVzY3JpcHRpb246IEFQQiBjbG9jaw0KPiA+ICAgICAgICAtIGRlc2NyaXB0aW9uOiBNQUMgTWFp
biBjbG9jaw0KPiA+ICAgICAgICAtIGRlc2NyaXB0aW9uOiBQVFAgY2xvY2sNCj4gPiAgICAgICAg
LSBkZXNjcmlwdGlvbjogUk1JSSByZWZlcmVuY2UgY2xvY2sgcHJvdmlkZWQgYnkgTUFDDQo+ID4g
KyAgICAgIC0gZGVzY3JpcHRpb246IE1BQyBjbG9jayBnYXRlDQo+ID4gIA0KPiA+ICAgIGNsb2Nr
LW5hbWVzOg0KPiA+IC0gICAgaXRlbXM6DQo+ID4gLSAgICAgIC0gY29uc3Q6IGF4aQ0KPiA+IC0g
ICAgICAtIGNvbnN0OiBhcGINCj4gPiAtICAgICAgLSBjb25zdDogbWFjX21haW4NCj4gPiAtICAg
ICAgLSBjb25zdDogcHRwX3JlZg0KPiA+IC0gICAgICAtIGNvbnN0OiBybWlpX2ludGVybmFsDQo+
ID4gKyAgICBtaW5JdGVtczogNQ0KPiA+ICsgICAgbWF4SXRlbXM6IDYNCj4gPiArICAgIGNvbnRh
aW5zOg0KPiANCj4gTm8sIHlvdSBqdXN0IHRocmV3IG91dCB0aGUgb3JkZXIgcmVxdWlyZW1lbnRz
LiBBbmQgdGhpcyBzY2hlbWEgd2lsbA0KPiBiZSANCj4gdHJ1ZSB3aXRoIGp1c3QgMSBvZiB0aGUg
c3RyaW5ncyBiZWxvdyBwbHVzIGFueSBvdGhlciBzdHJpbmdzLiBGb3IgDQo+IGV4YW1wbGUsIHRo
aXMgd2lsbCBwYXNzOg0KPiANCj4gY2xvY2stbmFtZXMgPSAiZm9vIiwgImJhciIsICJheGkiLCAi
YmF6IiwgInJvYiI7DQpJIG1pc3VuZGVyc3Rvb2QgdGhpcyBzY2hlbWEsIA0KYW5kIGhvdyBhYm91
dCB0aGUgZm9sbG93aW5nIGRlc2NyaXB0aW9uOg0KDQpjbG9jay1uYW1lczoNCiAgbWluSXRlbXM6
IDUNCiAgbWF4SXRlbXM6IDYNCiAgaXRlbXM6DQogICAgLSBjb25zdDogYXhpDQogICAgLSBjb25z
dDogYXBiDQogICAgLSBjb25zdDogbWFjX21haW4NCiAgICAtIGNvbnN0OiBwdHBfcmVmDQogICAg
LSBjb25zdDogcm1paV9pbnRlcm5hbA0KICAgIC0gY29uc3Q6IG1hY19jZw0KDQpSZWdhcmRzIQ0K
PiANCj4gPiArICAgICAgZW51bToNCj4gPiArICAgICAgICAtIGF4aQ0KPiA+ICsgICAgICAgIC0g
YXBiDQo+ID4gKyAgICAgICAgLSBtYWNfbWFpbg0KPiA+ICsgICAgICAgIC0gcHRwX3JlZg0KPiA+
ICsgICAgICAgIC0gcm1paV9pbnRlcm5hbA0KPiA+ICsgICAgICAgIC0gbWFjX2NnDQo+ID4gIA0K
PiA+ICAgIG1lZGlhdGVrLHBlcmljZmc6DQo+ID4gICAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55
YW1sIy9kZWZpbml0aW9ucy9waGFuZGxlDQo+ID4gQEAgLTYxLDYgKzczLDggQEAgcHJvcGVydGll
czoNCj4gPiAgICAgICAgb3Igd2lsbCByb3VuZCBkb3duLiBSYW5nZSAwfjMxKjE3MC4NCj4gPiAg
ICAgICAgRm9yIE1UMjcxMiBSTUlJL01JSSBpbnRlcmZhY2UsIEFsbG93ZWQgdmFsdWUgbmVlZCB0
byBiZSBhDQo+ID4gbXVsdGlwbGUgb2YgNTUwLA0KPiA+ICAgICAgICBvciB3aWxsIHJvdW5kIGRv
d24uIFJhbmdlIDB+MzEqNTUwLg0KPiA+ICsgICAgICBGb3IgTVQ4MTk1IFJHTUlJL1JNSUkvTUlJ
IGludGVyZmFjZSwgQWxsb3dlZCB2YWx1ZSBuZWVkIHRvDQo+ID4gYmUgYSBtdWx0aXBsZSBvZiAy
OTAsDQo+ID4gKyAgICAgIG9yIHdpbGwgcm91bmQgZG93bi4gUmFuZ2UgMH4zMSoyOTAuDQo+ID4g
IA0KPiA+ICAgIG1lZGlhdGVrLHJ4LWRlbGF5LXBzOg0KPiA+ICAgICAgZGVzY3JpcHRpb246DQo+
ID4gQEAgLTY5LDYgKzgzLDggQEAgcHJvcGVydGllczoNCj4gPiAgICAgICAgb3Igd2lsbCByb3Vu
ZCBkb3duLiBSYW5nZSAwfjMxKjE3MC4NCj4gPiAgICAgICAgRm9yIE1UMjcxMiBSTUlJL01JSSBp
bnRlcmZhY2UsIEFsbG93ZWQgdmFsdWUgbmVlZCB0byBiZSBhDQo+ID4gbXVsdGlwbGUgb2YgNTUw
LA0KPiA+ICAgICAgICBvciB3aWxsIHJvdW5kIGRvd24uIFJhbmdlIDB+MzEqNTUwLg0KPiA+ICsg
ICAgICBGb3IgTVQ4MTk1IFJHTUlJL1JNSUkvTUlJIGludGVyZmFjZSwgQWxsb3dlZCB2YWx1ZSBu
ZWVkIHRvDQo+ID4gYmUgYSBtdWx0aXBsZQ0KPiA+ICsgICAgICBvZiAyOTAsIG9yIHdpbGwgcm91
bmQgZG93bi4gUmFuZ2UgMH4zMSoyOTAuDQo+ID4gIA0KPiA+ICAgIG1lZGlhdGVrLHJtaWktcnhj
Og0KPiA+ICAgICAgdHlwZTogYm9vbGVhbg0KPiA+IEBAIC0xMDIsNiArMTE4LDEyIEBAIHByb3Bl
cnRpZXM6DQo+ID4gICAgICAgIDMuIHRoZSBpbnNpZGUgY2xvY2ssIHdoaWNoIGJlIHNlbnQgdG8g
TUFDLCB3aWxsIGJlIGludmVyc2VkDQo+ID4gaW4gUk1JSSBjYXNlIHdoZW4NCj4gPiAgICAgICAg
ICAgdGhlIHJlZmVyZW5jZSBjbG9jayBpcyBmcm9tIE1BQy4NCj4gPiAgDQo+ID4gKyAgbWVkaWF0
ZWssbWFjLXdvbDoNCj4gPiArICAgIHR5cGU6IGJvb2xlYW4NCj4gPiArICAgIGRlc2NyaXB0aW9u
Og0KPiA+ICsgICAgICBJZiBwcmVzZW50LCBpbmRpY2F0ZXMgdGhhdCBNQUMgc3VwcG9ydHMgV09M
KFdha2UtT24tTEFOKSwNCj4gPiBhbmQgTUFDIFdPTCB3aWxsIGJlIGVuYWJsZWQuDQo+ID4gKyAg
ICAgIE90aGVyd2lzZSwgUEhZIFdPTCBpcyBwZXJmZXJyZWQuDQo+ID4gKw0KPiA+ICByZXF1aXJl
ZDoNCj4gPiAgICAtIGNvbXBhdGlibGUNCj4gPiAgICAtIHJlZw0KPiA+IC0tIA0KPiA+IDIuMjUu
MQ0KPiA+IA0KPiA+IA0K

