Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85898471F1C
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 02:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhLMB1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 20:27:52 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:42228 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230479AbhLMB1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 20:27:52 -0500
X-UUID: 3ce7ed3cdc4d494ba5463edf988ea11c-20211213
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=+BSlGe5nShYWaOrfcwxn1EcTMN8sIOIVC8J0cDgjA+Q=;
        b=og15oVrA1++7iFNNaUc6yzzFJVka+gHTg6Aup5jq3z463LnSYiC7EWU7hqQWEh4NVQJ/+6lhi1rP8gBwWXEfJNmOVMj25XuzlDMA6rCLQnqPxIwd0Inkf5eV1R+ibunFl0WhSOj/evsbZjdMPQpy5zyP2rWSE4bO7lfAaalKmK4=;
X-UUID: 3ce7ed3cdc4d494ba5463edf988ea11c-20211213
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1930732897; Mon, 13 Dec 2021 09:27:48 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Mon, 13 Dec 2021 09:27:47 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Dec 2021 09:27:46 +0800
Message-ID: <5cf063709dad8ff57bdfb3fa742f5f784217f353.camel@mediatek.com>
Subject: Re: [PATCH net-next v8 6/6] net: dt-bindings: dwmac: add support
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
Date:   Mon, 13 Dec 2021 09:27:47 +0800
In-Reply-To: <YbOh4hZfc+QKA/hO@robh.at.kernel.org>
References: <20211210013129.811-1-biao.huang@mediatek.com>
         <20211210013129.811-7-biao.huang@mediatek.com>
         <YbOh4hZfc+QKA/hO@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBSb2IsDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnR+DQpPbiBGcmksIDIwMjEtMTItMTAg
YXQgMTI6NTIgLTA2MDAsIFJvYiBIZXJyaW5nIHdyb3RlOg0KPiBPbiBGcmksIERlYyAxMCwgMjAy
MSBhdCAwOTozMToyOUFNICswODAwLCBCaWFvIEh1YW5nIHdyb3RlOg0KPiA+IEFkZCBiaW5kaW5n
IGRvY3VtZW50IGZvciB0aGUgZXRoZXJuZXQgb24gbXQ4MTk1Lg0KPiA+IA0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEJpYW8gSHVhbmcgPGJpYW8uaHVhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+
ICAuLi4vYmluZGluZ3MvbmV0L21lZGlhdGVrLWR3bWFjLnlhbWwgICAgICAgICAgfCA4Ng0KPiA+
ICsrKysrKysrKysrKysrKy0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDcwIGluc2VydGlvbnMo
KyksIDE2IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21lZGlhdGVrLQ0KPiA+IGR3bWFjLnlhbWwgYi9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21lZGlhdGVrLQ0KPiA+IGR3bWFjLnlh
bWwNCj4gPiBpbmRleCA5MjA3MjY2YTZlNjkuLmZiMDQxNjY0MDRkOCAxMDA2NDQNCj4gPiAtLS0g
YS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21lZGlhdGVrLWR3bWFjLnlh
bWwNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21lZGlh
dGVrLWR3bWFjLnlhbWwNCj4gPiBAQCAtMTksMTEgKzE5LDY3IEBAIHNlbGVjdDoNCj4gPiAgICAg
ICAgY29udGFpbnM6DQo+ID4gICAgICAgICAgZW51bToNCj4gPiAgICAgICAgICAgIC0gbWVkaWF0
ZWssbXQyNzEyLWdtYWMNCj4gPiArICAgICAgICAgIC0gbWVkaWF0ZWssbXQ4MTk1LWdtYWMNCj4g
PiAgICByZXF1aXJlZDoNCj4gPiAgICAgIC0gY29tcGF0aWJsZQ0KPiA+ICANCj4gPiAgYWxsT2Y6
DQo+ID4gICAgLSAkcmVmOiAic25wcyxkd21hYy55YW1sIyINCj4gPiArICAtIGlmOg0KPiA+ICsg
ICAgICBwcm9wZXJ0aWVzOg0KPiA+ICsgICAgICAgIGNvbXBhdGlibGU6DQo+ID4gKyAgICAgICAg
ICBjb250YWluczoNCj4gPiArICAgICAgICAgICAgZW51bToNCj4gPiArICAgICAgICAgICAgICAt
IG1lZGlhdGVrLG10MjcxMi1nbWFjDQo+ID4gKw0KPiA+ICsgICAgdGhlbjoNCj4gPiArICAgICAg
cHJvcGVydGllczoNCj4gPiArICAgICAgICBjbG9ja3M6DQo+ID4gKyAgICAgICAgICBtaW5JdGVt
czogNQ0KPiA+ICsgICAgICAgICAgaXRlbXM6DQo+ID4gKyAgICAgICAgICAgIC0gZGVzY3JpcHRp
b246IEFYSSBjbG9jaw0KPiA+ICsgICAgICAgICAgICAtIGRlc2NyaXB0aW9uOiBBUEIgY2xvY2sN
Cj4gPiArICAgICAgICAgICAgLSBkZXNjcmlwdGlvbjogTUFDIE1haW4gY2xvY2sNCj4gPiArICAg
ICAgICAgICAgLSBkZXNjcmlwdGlvbjogUFRQIGNsb2NrDQo+ID4gKyAgICAgICAgICAgIC0gZGVz
Y3JpcHRpb246IFJNSUkgcmVmZXJlbmNlIGNsb2NrIHByb3ZpZGVkIGJ5IE1BQw0KPiA+ICsNCj4g
PiArICAgICAgICBjbG9jay1uYW1lczoNCj4gPiArICAgICAgICAgIG1pbkl0ZW1zOiA1DQo+ID4g
KyAgICAgICAgICBpdGVtczoNCj4gPiArICAgICAgICAgICAgLSBjb25zdDogYXhpDQo+ID4gKyAg
ICAgICAgICAgIC0gY29uc3Q6IGFwYg0KPiA+ICsgICAgICAgICAgICAtIGNvbnN0OiBtYWNfbWFp
bg0KPiA+ICsgICAgICAgICAgICAtIGNvbnN0OiBwdHBfcmVmDQo+ID4gKyAgICAgICAgICAgIC0g
Y29uc3Q6IHJtaWlfaW50ZXJuYWwNCj4gPiArDQo+ID4gKyAgLSBpZjoNCj4gPiArICAgICAgcHJv
cGVydGllczoNCj4gPiArICAgICAgICBjb21wYXRpYmxlOg0KPiA+ICsgICAgICAgICAgY29udGFp
bnM6DQo+ID4gKyAgICAgICAgICAgIGVudW06DQo+ID4gKyAgICAgICAgICAgICAgLSBtZWRpYXRl
ayxtdDgxOTUtZ21hYw0KPiA+ICsNCj4gPiArICAgIHRoZW46DQo+ID4gKyAgICAgIHByb3BlcnRp
ZXM6DQo+ID4gKyAgICAgICAgY2xvY2tzOg0KPiA+ICsgICAgICAgICAgbWluSXRlbXM6IDYNCj4g
PiArICAgICAgICAgIGl0ZW1zOg0KPiA+ICsgICAgICAgICAgICAtIGRlc2NyaXB0aW9uOiBBWEkg
Y2xvY2sNCj4gPiArICAgICAgICAgICAgLSBkZXNjcmlwdGlvbjogQVBCIGNsb2NrDQo+ID4gKyAg
ICAgICAgICAgIC0gZGVzY3JpcHRpb246IE1BQyBjbG9jayBnYXRlDQo+IA0KPiBBZGQgbmV3IGNs
b2NrcyBvbiB0byB0aGUgZW5kIG9mIGV4aXN0aW5nIGNsb2Nrcy4gVGhhdCB3aWxsIHNpbXBsaWZ5
DQo+IHRoZSANCj4gYmluZGluZyBhcyBoZXJlIHlvdSB3aWxsIGp1c3QgbmVlZCAnbWluSXRlbXM6
IDYnLg0KVGhlICJybWlpX2ludGVybmFsIiBjbG9jayBpcyBhIHNwZWNpYWwgb25lIHdlIHB1dCBp
dCB0byB0aGUgZW5kIG9uDQpwdXJwb3NlLCBhbmQgd2lsbCB0dXJuIGl0IG9uL29mZiBpbiBkcml2
ZXIgYWNjb3JkaW5nIHRvIHdoZXRoZXINCnBoeV9tb2RlIGlzIHJtaWkgb3Igbm90Lg0KDQpTbyB0
aGUgIm1hY19jZyIgY2xvY2ssIHdoaWNoIGlzIG5ldyBmb3IgbXQ4MTk1LCBhbmQgbm90IHVzZWQg
aW4gbXQyNzEyLA0KY2FuJ3QgcHV0IGl0IHRvIHRoZSBlbmQgZm9yIHNpbXBsaWNpdHkuDQoNCkNh
biB3ZSBqdXN0IGtlZXAgaXQgdGhpcyB3YXk/IG9yIG90aGVyIHN1Z2dlc3Rpb25zPw0KDQpbdjMg
cmVwbHldDQoNCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL3BpcGVybWFpbC9saW51eC1tZWRp
YXRlay8yMDIxLU5vdmVtYmVyLzAzMTk1MS5odG1sDQo+ID4gKyAgICAgICAgICAgIC0gZGVzY3Jp
cHRpb246IE1BQyBNYWluIGNsb2NrDQo+ID4gKyAgICAgICAgICAgIC0gZGVzY3JpcHRpb246IFBU
UCBjbG9jaw0KPiA+ICsgICAgICAgICAgICAtIGRlc2NyaXB0aW9uOiBSTUlJIHJlZmVyZW5jZSBj
bG9jayBwcm92aWRlZCBieSBNQUMNCj4gPiArDQo+ID4gKyAgICAgICAgY2xvY2stbmFtZXM6DQo+
ID4gKyAgICAgICAgICBtaW5JdGVtczogNg0KPiA+ICsgICAgICAgICAgaXRlbXM6DQo+ID4gKyAg
ICAgICAgICAgIC0gY29uc3Q6IGF4aQ0KPiA+ICsgICAgICAgICAgICAtIGNvbnN0OiBhcGINCj4g
PiArICAgICAgICAgICAgLSBjb25zdDogbWFjX2NnDQo+ID4gKyAgICAgICAgICAgIC0gY29uc3Q6
IG1hY19tYWluDQo+ID4gKyAgICAgICAgICAgIC0gY29uc3Q6IHB0cF9yZWYNCj4gPiArICAgICAg
ICAgICAgLSBjb25zdDogcm1paV9pbnRlcm5hbA0KPiA+ICANCj4gPiAgcHJvcGVydGllczoNCj4g
PiAgICBjb21wYXRpYmxlOg0KPiA+IEBAIC0zMiwyMiArODgsMTAgQEAgcHJvcGVydGllczoNCj4g
PiAgICAgICAgICAgIC0gZW51bToNCj4gPiAgICAgICAgICAgICAgICAtIG1lZGlhdGVrLG10Mjcx
Mi1nbWFjDQo+ID4gICAgICAgICAgICAtIGNvbnN0OiBzbnBzLGR3bWFjLTQuMjBhDQo+ID4gLQ0K
PiA+IC0gIGNsb2NrczoNCj4gPiAtICAgIGl0ZW1zOg0KPiA+IC0gICAgICAtIGRlc2NyaXB0aW9u
OiBBWEkgY2xvY2sNCj4gPiAtICAgICAgLSBkZXNjcmlwdGlvbjogQVBCIGNsb2NrDQo+ID4gLSAg
ICAgIC0gZGVzY3JpcHRpb246IE1BQyBNYWluIGNsb2NrDQo+ID4gLSAgICAgIC0gZGVzY3JpcHRp
b246IFBUUCBjbG9jaw0KPiA+IC0gICAgICAtIGRlc2NyaXB0aW9uOiBSTUlJIHJlZmVyZW5jZSBj
bG9jayBwcm92aWRlZCBieSBNQUMNCj4gPiAtDQo+ID4gLSAgY2xvY2stbmFtZXM6DQo+ID4gLSAg
ICBpdGVtczoNCj4gPiAtICAgICAgLSBjb25zdDogYXhpDQo+ID4gLSAgICAgIC0gY29uc3Q6IGFw
Yg0KPiA+IC0gICAgICAtIGNvbnN0OiBtYWNfbWFpbg0KPiA+IC0gICAgICAtIGNvbnN0OiBwdHBf
cmVmDQo+ID4gLSAgICAgIC0gY29uc3Q6IHJtaWlfaW50ZXJuYWwNCj4gPiArICAgICAgLSBpdGVt
czoNCj4gPiArICAgICAgICAgIC0gZW51bToNCj4gPiArICAgICAgICAgICAgICAtIG1lZGlhdGVr
LG10ODE5NS1nbWFjDQo+ID4gKyAgICAgICAgICAtIGNvbnN0OiBzbnBzLGR3bWFjLTUuMTBhDQo+
ID4gIA0KPiA+ICAgIG1lZGlhdGVrLHBlcmljZmc6DQo+ID4gICAgICAkcmVmOiAvc2NoZW1hcy90
eXBlcy55YW1sIy9kZWZpbml0aW9ucy9waGFuZGxlDQo+ID4gQEAgLTYyLDYgKzEwNiw4IEBAIHBy
b3BlcnRpZXM6DQo+ID4gICAgICAgIG9yIHdpbGwgcm91bmQgZG93bi4gUmFuZ2UgMH4zMSoxNzAu
DQo+ID4gICAgICAgIEZvciBNVDI3MTIgUk1JSS9NSUkgaW50ZXJmYWNlLCBBbGxvd2VkIHZhbHVl
IG5lZWQgdG8gYmUgYQ0KPiA+IG11bHRpcGxlIG9mIDU1MCwNCj4gPiAgICAgICAgb3Igd2lsbCBy
b3VuZCBkb3duLiBSYW5nZSAwfjMxKjU1MC4NCj4gPiArICAgICAgRm9yIE1UODE5NSBSR01JSS9S
TUlJL01JSSBpbnRlcmZhY2UsIEFsbG93ZWQgdmFsdWUgbmVlZCB0bw0KPiA+IGJlIGEgbXVsdGlw
bGUgb2YgMjkwLA0KPiA+ICsgICAgICBvciB3aWxsIHJvdW5kIGRvd24uIFJhbmdlIDB+MzEqMjkw
Lg0KPiA+ICANCj4gPiAgICBtZWRpYXRlayxyeC1kZWxheS1wczoNCj4gPiAgICAgIGRlc2NyaXB0
aW9uOg0KPiA+IEBAIC03MCw2ICsxMTYsOCBAQCBwcm9wZXJ0aWVzOg0KPiA+ICAgICAgICBvciB3
aWxsIHJvdW5kIGRvd24uIFJhbmdlIDB+MzEqMTcwLg0KPiA+ICAgICAgICBGb3IgTVQyNzEyIFJN
SUkvTUlJIGludGVyZmFjZSwgQWxsb3dlZCB2YWx1ZSBuZWVkIHRvIGJlIGENCj4gPiBtdWx0aXBs
ZSBvZiA1NTAsDQo+ID4gICAgICAgIG9yIHdpbGwgcm91bmQgZG93bi4gUmFuZ2UgMH4zMSo1NTAu
DQo+ID4gKyAgICAgIEZvciBNVDgxOTUgUkdNSUkvUk1JSS9NSUkgaW50ZXJmYWNlLCBBbGxvd2Vk
IHZhbHVlIG5lZWQgdG8NCj4gPiBiZSBhIG11bHRpcGxlDQo+ID4gKyAgICAgIG9mIDI5MCwgb3Ig
d2lsbCByb3VuZCBkb3duLiBSYW5nZSAwfjMxKjI5MC4NCj4gPiAgDQo+ID4gICAgbWVkaWF0ZWss
cm1paS1yeGM6DQo+ID4gICAgICB0eXBlOiBib29sZWFuDQo+ID4gQEAgLTEwMyw2ICsxNTEsMTIg
QEAgcHJvcGVydGllczoNCj4gPiAgICAgICAgMy4gdGhlIGluc2lkZSBjbG9jaywgd2hpY2ggYmUg
c2VudCB0byBNQUMsIHdpbGwgYmUgaW52ZXJzZWQNCj4gPiBpbiBSTUlJIGNhc2Ugd2hlbg0KPiA+
ICAgICAgICAgICB0aGUgcmVmZXJlbmNlIGNsb2NrIGlzIGZyb20gTUFDLg0KPiA+ICANCj4gPiAr
ICBtZWRpYXRlayxtYWMtd29sOg0KPiA+ICsgICAgdHlwZTogYm9vbGVhbg0KPiA+ICsgICAgZGVz
Y3JpcHRpb246DQo+ID4gKyAgICAgIElmIHByZXNlbnQsIGluZGljYXRlcyB0aGF0IE1BQyBzdXBw
b3J0cyBXT0woV2FrZS1Pbi1MQU4pLA0KPiA+IGFuZCBNQUMgV09MIHdpbGwgYmUgZW5hYmxlZC4N
Cj4gPiArICAgICAgT3RoZXJ3aXNlLCBQSFkgV09MIGlzIHBlcmZlcnJlZC4NCj4gPiArDQo+ID4g
IHJlcXVpcmVkOg0KPiA+ICAgIC0gY29tcGF0aWJsZQ0KPiA+ICAgIC0gcmVnDQo+ID4gLS0gDQo+
ID4gMi4yNS4xDQo+ID4gDQo+ID4gDQo=

