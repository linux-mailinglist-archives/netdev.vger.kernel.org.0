Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76953460C57
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 02:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhK2Bku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 20:40:50 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:36650 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S238916AbhK2Bip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 20:38:45 -0500
X-UUID: 5298a3b35ca940f89135246985ea8080-20211129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=yoJLhePLzBo3wM2e/RjTt9dvCDe07O0xX3v3BLWirxQ=;
        b=g7DLTaIr1MBqoiAi1Y9CaATeLuSu+ACuXzzLa8ZbW9w1HkEz1ts5AASQYyVlg3N7z0oHyqy2ZX7DYilB+vUx7VGiB50RDwUQG27DDKyQ0Cgs3LYD/PAthGk8mmmFqvSmToHxzmYmVbVvgO2oXk2sQvUT2rxpgM+vqmTXt5SzZMQ=;
X-UUID: 5298a3b35ca940f89135246985ea8080-20211129
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 208505581; Mon, 29 Nov 2021 09:35:24 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Mon, 29 Nov 2021 09:35:23 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Nov 2021 09:35:22 +0800
Message-ID: <a7e33e13b24ee98c37a822105ae9d78c44f437ab.camel@mediatek.com>
Subject: Re: [PATCH v3 7/7] net-next: dt-bindings: dwmac: add support for
 mt8195
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
Date:   Mon, 29 Nov 2021 09:35:22 +0800
In-Reply-To: <YaQZOS54BawtWkGO@robh.at.kernel.org>
References: <20211112093918.11061-1-biao.huang@mediatek.com>
         <20211112093918.11061-8-biao.huang@mediatek.com>
         <YaQZOS54BawtWkGO@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBSb2IsDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzfg0KDQpPbiBTdW4sIDIwMjEtMTEt
MjggYXQgMTg6MDUgLTA2MDAsIFJvYiBIZXJyaW5nIHdyb3RlOg0KPiBPbiBGcmksIE5vdiAxMiwg
MjAyMSBhdCAwNTozOToxOFBNICswODAwLCBCaWFvIEh1YW5nIHdyb3RlOg0KPiA+IEFkZCBiaW5k
aW5nIGRvY3VtZW50IGZvciB0aGUgZXRoZXJuZXQgb24gbXQ4MTk1Lg0KPiA+IA0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEJpYW8gSHVhbmcgPGJpYW8uaHVhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0K
PiA+ICAuLi4vYmluZGluZ3MvbmV0L21lZGlhdGVrLWR3bWFjLnlhbWwgICAgICAgICAgfCA4Ng0K
PiA+ICsrKysrKysrKysrKysrKy0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDcwIGluc2VydGlv
bnMoKyksIDE2IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21lZGlhdGVrLQ0KPiA+IGR3bWFjLnlhbWwgYi9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21lZGlhdGVrLQ0KPiA+IGR3bWFj
LnlhbWwNCj4gPiBpbmRleCAyZWI0NzgxNTM2ZjcuLmIyNzU2NmVkMDFjNiAxMDA2NDQNCj4gPiAt
LS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21lZGlhdGVrLWR3bWFj
LnlhbWwNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21l
ZGlhdGVrLWR3bWFjLnlhbWwNCj4gPiBAQCAtMTksMTIgKzE5LDY4IEBAIHNlbGVjdDoNCj4gPiAg
ICAgICAgY29udGFpbnM6DQo+ID4gICAgICAgICAgZW51bToNCj4gPiAgICAgICAgICAgIC0gbWVk
aWF0ZWssbXQyNzEyLWdtYWMNCj4gPiArICAgICAgICAgIC0gbWVkaWF0ZWssbXQ4MTk1LWdtYWMN
Cj4gPiAgICByZXF1aXJlZDoNCj4gPiAgICAgIC0gY29tcGF0aWJsZQ0KPiA+ICANCj4gPiAgYWxs
T2Y6DQo+ID4gICAgLSAkcmVmOiAic25wcyxkd21hYy55YW1sIyINCj4gPiAgICAtICRyZWY6ICJl
dGhlcm5ldC1jb250cm9sbGVyLnlhbWwjIg0KPiA+ICsgIC0gaWY6DQo+ID4gKyAgICAgIHByb3Bl
cnRpZXM6DQo+ID4gKyAgICAgICAgY29tcGF0aWJsZToNCj4gPiArICAgICAgICAgIGNvbnRhaW5z
Og0KPiA+ICsgICAgICAgICAgICBlbnVtOg0KPiA+ICsgICAgICAgICAgICAgIC0gbWVkaWF0ZWss
bXQyNzEyLWdtYWMNCj4gPiArDQo+ID4gKyAgICB0aGVuOg0KPiA+ICsgICAgICBwcm9wZXJ0aWVz
Og0KPiA+ICsgICAgICAgIGNsb2NrczoNCj4gPiArICAgICAgICAgIG1pbkl0ZW1zOiA1DQo+ID4g
KyAgICAgICAgICBpdGVtczoNCj4gPiArICAgICAgICAgICAgLSBkZXNjcmlwdGlvbjogQVhJIGNs
b2NrDQo+ID4gKyAgICAgICAgICAgIC0gZGVzY3JpcHRpb246IEFQQiBjbG9jaw0KPiA+ICsgICAg
ICAgICAgICAtIGRlc2NyaXB0aW9uOiBNQUMgTWFpbiBjbG9jaw0KPiA+ICsgICAgICAgICAgICAt
IGRlc2NyaXB0aW9uOiBQVFAgY2xvY2sNCj4gPiArICAgICAgICAgICAgLSBkZXNjcmlwdGlvbjog
Uk1JSSByZWZlcmVuY2UgY2xvY2sgcHJvdmlkZWQgYnkgTUFDDQo+ID4gKw0KPiA+ICsgICAgICAg
IGNsb2NrLW5hbWVzOg0KPiA+ICsgICAgICAgICAgbWluSXRlbXM6IDUNCj4gPiArICAgICAgICAg
IGl0ZW1zOg0KPiA+ICsgICAgICAgICAgICAtIGNvbnN0OiBheGkNCj4gPiArICAgICAgICAgICAg
LSBjb25zdDogYXBiDQo+ID4gKyAgICAgICAgICAgIC0gY29uc3Q6IG1hY19tYWluDQo+ID4gKyAg
ICAgICAgICAgIC0gY29uc3Q6IHB0cF9yZWYNCj4gPiArICAgICAgICAgICAgLSBjb25zdDogcm1p
aV9pbnRlcm5hbA0KPiA+ICsNCj4gPiArICAtIGlmOg0KPiA+ICsgICAgICBwcm9wZXJ0aWVzOg0K
PiA+ICsgICAgICAgIGNvbXBhdGlibGU6DQo+ID4gKyAgICAgICAgICBjb250YWluczoNCj4gPiAr
ICAgICAgICAgICAgZW51bToNCj4gPiArICAgICAgICAgICAgICAtIG1lZGlhdGVrLG10ODE5NS1n
bWFjDQo+ID4gKw0KPiA+ICsgICAgdGhlbjoNCj4gPiArICAgICAgcHJvcGVydGllczoNCj4gPiAr
ICAgICAgICBjbG9ja3M6DQo+ID4gKyAgICAgICAgICBtaW5JdGVtczogNg0KPiA+ICsgICAgICAg
ICAgaXRlbXM6DQo+ID4gKyAgICAgICAgICAgIC0gZGVzY3JpcHRpb246IEFYSSBjbG9jaw0KPiA+
ICsgICAgICAgICAgICAtIGRlc2NyaXB0aW9uOiBBUEIgY2xvY2sNCj4gPiArICAgICAgICAgICAg
LSBkZXNjcmlwdGlvbjogTUFDIGNsb2NrIGdhdGUNCj4gPiArICAgICAgICAgICAgLSBkZXNjcmlw
dGlvbjogTUFDIE1haW4gY2xvY2sNCj4gPiArICAgICAgICAgICAgLSBkZXNjcmlwdGlvbjogUFRQ
IGNsb2NrDQo+ID4gKyAgICAgICAgICAgIC0gZGVzY3JpcHRpb246IFJNSUkgcmVmZXJlbmNlIGNs
b2NrIHByb3ZpZGVkIGJ5IE1BQw0KPiANCj4gUHV0IG1hY19jZyBhdCB0aGUgZW5kIGFuZCB0aGVu
IHRoZSBkaWZmZXJlbmNlIGlzIGp1c3QgNSBvciA2IGNsb2Nrcw0KPiBhbmQgDQo+IHlvdSBkb24n
dCBoYXZlIHRvIGR1cGxpY2F0ZSBldmVyeXRoaW5nLg0KPiANClRoZXJlIGlzIGEgc3BlY2lhbCBj
bG9jayAtLSBybWlpX2ludGVybmFsIGF0IHRoZSBlbmQgbm93LCBhbmQgd2UnbGwNCmVuYWJsZS9k
aXNhYmxlIGl0IGluIG91ciBkcml2ZXIsIGFjY29yZGluZyB0byB3aGV0aGVyIHBoeSBpbnRlcmZh
Y2UgaXMNClJNSUksIHdoaWNoIG1lYW5zIGludm9raW5nIGNsa19idWxrX3h4eCgpIHdpdGggcGFy
YW1lbnQ6DQpzaXplb2YoY2xvY2tfbGlzdCkgb3IgKHNpemVvZihjbG9ja19saXN0KSAtIDEpLg0K
DQpBbmQgdGhlIEV0aGVybmV0IHJlbGF0ZWQgY2xvY2sgbGlzdCBtYXkgYmUgZGlmZmVyZW50IGR1
ZSB0byBzb21lDQpsaW1pdGF0aW9uIG9yIHJ1bGUgaW4gZGlmZmVyZW50IElDLCB3ZSB0aGluayBj
dXJyZW50IGFycmFuZ2VtZW50IHdpbGwNCm1ha2UgaXQgY2xlYXIuKElmIHNvbWUgSUNzIHNoYXJl
IHRoZSBzYW1lIGNsb2NrIGxpc3QsIHB1dCB0aGVtIGluIHRoZQ0Kc2FtZSBpZiBjb25kaXRpb24p
DQoNClRoYW5rc34NCj4gDQo+ID4gKw0KPiA+ICsgICAgICAgIGNsb2NrLW5hbWVzOg0KPiA+ICsg
ICAgICAgICAgbWluSXRlbXM6IDYNCj4gPiArICAgICAgICAgIGl0ZW1zOg0KPiA+ICsgICAgICAg
ICAgICAtIGNvbnN0OiBheGkNCj4gPiArICAgICAgICAgICAgLSBjb25zdDogYXBiDQo+ID4gKyAg
ICAgICAgICAgIC0gY29uc3Q6IG1hY19jZw0KPiA+ICsgICAgICAgICAgICAtIGNvbnN0OiBtYWNf
bWFpbg0KPiA+ICsgICAgICAgICAgICAtIGNvbnN0OiBwdHBfcmVmDQo+ID4gKyAgICAgICAgICAg
IC0gY29uc3Q6IHJtaWlfaW50ZXJuYWwNCj4gPiAgDQo+ID4gIHByb3BlcnRpZXM6DQo+ID4gICAg
Y29tcGF0aWJsZToNCj4gPiBAQCAtMzMsMjIgKzg5LDEwIEBAIHByb3BlcnRpZXM6DQo+ID4gICAg
ICAgICAgICAtIGVudW06DQo+ID4gICAgICAgICAgICAgICAgLSBtZWRpYXRlayxtdDI3MTItZ21h
Yw0KPiA+ICAgICAgICAgICAgLSBjb25zdDogc25wcyxkd21hYy00LjIwYQ0KPiA+IC0NCj4gPiAt
ICBjbG9ja3M6DQo+ID4gLSAgICBpdGVtczoNCj4gPiAtICAgICAgLSBkZXNjcmlwdGlvbjogQVhJ
IGNsb2NrDQo+ID4gLSAgICAgIC0gZGVzY3JpcHRpb246IEFQQiBjbG9jaw0KPiA+IC0gICAgICAt
IGRlc2NyaXB0aW9uOiBNQUMgTWFpbiBjbG9jaw0KPiA+IC0gICAgICAtIGRlc2NyaXB0aW9uOiBQ
VFAgY2xvY2sNCj4gPiAtICAgICAgLSBkZXNjcmlwdGlvbjogUk1JSSByZWZlcmVuY2UgY2xvY2sg
cHJvdmlkZWQgYnkgTUFDDQo+ID4gLQ0KPiA+IC0gIGNsb2NrLW5hbWVzOg0KPiA+IC0gICAgaXRl
bXM6DQo+ID4gLSAgICAgIC0gY29uc3Q6IGF4aQ0KPiA+IC0gICAgICAtIGNvbnN0OiBhcGINCj4g
PiAtICAgICAgLSBjb25zdDogbWFjX21haW4NCj4gPiAtICAgICAgLSBjb25zdDogcHRwX3JlZg0K
PiA+IC0gICAgICAtIGNvbnN0OiBybWlpX2ludGVybmFsDQo+ID4gKyAgICAgIC0gaXRlbXM6DQo+
ID4gKyAgICAgICAgICAtIGVudW06DQo+ID4gKyAgICAgICAgICAgICAgLSBtZWRpYXRlayxtdDgx
OTUtZ21hYw0KPiA+ICsgICAgICAgICAgLSBjb25zdDogc25wcyxkd21hYy01LjEwYQ0KPiA+ICAN
Cj4gPiAgICBtZWRpYXRlayxwZXJpY2ZnOg0KPiA+ICAgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMu
eWFtbCMvZGVmaW5pdGlvbnMvcGhhbmRsZQ0KPiA+IEBAIC02Myw2ICsxMDcsOCBAQCBwcm9wZXJ0
aWVzOg0KPiA+ICAgICAgICBvciB3aWxsIHJvdW5kIGRvd24uIFJhbmdlIDB+MzEqMTcwLg0KPiA+
ICAgICAgICBGb3IgTVQyNzEyIFJNSUkvTUlJIGludGVyZmFjZSwgQWxsb3dlZCB2YWx1ZSBuZWVk
IHRvIGJlIGENCj4gPiBtdWx0aXBsZSBvZiA1NTAsDQo+ID4gICAgICAgIG9yIHdpbGwgcm91bmQg
ZG93bi4gUmFuZ2UgMH4zMSo1NTAuDQo+ID4gKyAgICAgIEZvciBNVDgxOTUgUkdNSUkvUk1JSS9N
SUkgaW50ZXJmYWNlLCBBbGxvd2VkIHZhbHVlIG5lZWQgdG8NCj4gPiBiZSBhIG11bHRpcGxlIG9m
IDI5MCwNCj4gPiArICAgICAgb3Igd2lsbCByb3VuZCBkb3duLiBSYW5nZSAwfjMxKjI5MC4NCj4g
PiAgDQo+ID4gICAgbWVkaWF0ZWsscngtZGVsYXktcHM6DQo+ID4gICAgICBkZXNjcmlwdGlvbjoN
Cj4gPiBAQCAtNzEsNiArMTE3LDggQEAgcHJvcGVydGllczoNCj4gPiAgICAgICAgb3Igd2lsbCBy
b3VuZCBkb3duLiBSYW5nZSAwfjMxKjE3MC4NCj4gPiAgICAgICAgRm9yIE1UMjcxMiBSTUlJL01J
SSBpbnRlcmZhY2UsIEFsbG93ZWQgdmFsdWUgbmVlZCB0byBiZSBhDQo+ID4gbXVsdGlwbGUgb2Yg
NTUwLA0KPiA+ICAgICAgICBvciB3aWxsIHJvdW5kIGRvd24uIFJhbmdlIDB+MzEqNTUwLg0KPiA+
ICsgICAgICBGb3IgTVQ4MTk1IFJHTUlJL1JNSUkvTUlJIGludGVyZmFjZSwgQWxsb3dlZCB2YWx1
ZSBuZWVkIHRvDQo+ID4gYmUgYSBtdWx0aXBsZQ0KPiA+ICsgICAgICBvZiAyOTAsIG9yIHdpbGwg
cm91bmQgZG93bi4gUmFuZ2UgMH4zMSoyOTAuDQo+ID4gIA0KPiA+ICAgIG1lZGlhdGVrLHJtaWkt
cnhjOg0KPiA+ICAgICAgdHlwZTogYm9vbGVhbg0KPiA+IEBAIC0xMDQsNiArMTUyLDEyIEBAIHBy
b3BlcnRpZXM6DQo+ID4gICAgICAgIDMuIHRoZSBpbnNpZGUgY2xvY2ssIHdoaWNoIGJlIHNlbnQg
dG8gTUFDLCB3aWxsIGJlIGludmVyc2VkDQo+ID4gaW4gUk1JSSBjYXNlIHdoZW4NCj4gPiAgICAg
ICAgICAgdGhlIHJlZmVyZW5jZSBjbG9jayBpcyBmcm9tIE1BQy4NCj4gPiAgDQo+ID4gKyAgbWVk
aWF0ZWssbWFjLXdvbDoNCj4gPiArICAgIHR5cGU6IGJvb2xlYW4NCj4gPiArICAgIGRlc2NyaXB0
aW9uOg0KPiA+ICsgICAgICBJZiBwcmVzZW50LCBpbmRpY2F0ZXMgdGhhdCBNQUMgc3VwcG9ydHMg
V09MKFdha2UtT24tTEFOKSwNCj4gPiBhbmQgTUFDIFdPTCB3aWxsIGJlIGVuYWJsZWQuDQo+ID4g
KyAgICAgIE90aGVyd2lzZSwgUEhZIFdPTCBpcyBwZXJmZXJyZWQuDQo+ID4gKw0KPiA+ICByZXF1
aXJlZDoNCj4gPiAgICAtIGNvbXBhdGlibGUNCj4gPiAgICAtIHJlZw0KPiA+IC0tIA0KPiA+IDIu
MjUuMQ0KPiA+IA0KPiA+IA0K

