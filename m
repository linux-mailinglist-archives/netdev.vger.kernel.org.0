Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32B62BA04B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 03:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgKTCWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 21:22:51 -0500
Received: from mailgw02.mediatek.com ([1.203.163.81]:14462 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726192AbgKTCWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 21:22:51 -0500
X-UUID: 216d3160d0bd4324af247085d63b5e17-20201120
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=n/aNWIenGoXWcckC883otYqC5MohkTpPEmWjEeDmBgo=;
        b=eDfgehha2hQS7z6W0ARtp8JS7Ksne+uwcFPYdcAOcH2tt/xW/ZtdRUweysSIFf0EXZU6XkjS1pSW8a6mu2vVge79EYx6UFz+zeObFzwa1skerapCl7dS6IgfTB2uiQHq3wQjIMJavifRK0MRrs7PhpJ1fCSnJsKxPHQ/sARBJbQ=;
X-UUID: 216d3160d0bd4324af247085d63b5e17-20201120
Received: from mtkcas35.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1459692923; Fri, 20 Nov 2020 10:22:38 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31DR.mediatek.inc
 (172.27.6.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Nov
 2020 10:22:36 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 20 Nov 2020 10:22:35 +0800
Message-ID: <1605838955.31607.43.camel@mhfsdcap03>
Subject: Re: [PATCH v3 07/11] dt-bindings: phy: convert MIP DSI PHY binding
 to YAML schema
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Chun-Kuang Hu <chunkuang.hu@kernel.org>
CC:     Rob Herring <robh+dt@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "Vinod Koul" <vkoul@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        DTML <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>
Date:   Fri, 20 Nov 2020 10:22:35 +0800
In-Reply-To: <CAAOTY_81uZ7MY1ZyfsyYL_62wkNvG2VCT3+G4Zr1bZBG9_Yg1w@mail.gmail.com>
References: <20201118082126.42701-1-chunfeng.yun@mediatek.com>
         <20201118082126.42701-7-chunfeng.yun@mediatek.com>
         <CAAOTY_81uZ7MY1ZyfsyYL_62wkNvG2VCT3+G4Zr1bZBG9_Yg1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 68FF507287B0184E20B752119AB5D2D9DF0D46B75813DAA2C10B3A66426E71782000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTExLTIwIGF0IDA3OjM4ICswODAwLCBDaHVuLUt1YW5nIEh1IHdyb3RlOg0K
PiBIaSwgQ2h1bmZlbmc6DQo+IA0KPiBDaHVuZmVuZyBZdW4gPGNodW5mZW5nLnl1bkBtZWRpYXRl
ay5jb20+IOaWvCAyMDIw5bm0MTHmnIgxOOaXpSDpgLHkuIkg5LiL5Y2INDoyMeWvq+mBk++8mg0K
PiA+DQo+ID4gQ29udmVydCBNSVBJIERTSSBQSFkgYmluZGluZyB0byBZQU1MIHNjaGVtYSBtZWRp
YXRlayxkc2ktcGh5LnlhbWwNCj4gPg0KPiA+IENjOiBDaHVuLUt1YW5nIEh1IDxjaHVua3Vhbmcu
aHVAa2VybmVsLm9yZz4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBDaHVuZmVuZyBZdW4gPGNodW5mZW5n
Lnl1bkBtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gdjM6IG5ldyBwYXRjaA0KPiA+IC0tLQ0K
PiA+ICAuLi4vZGlzcGxheS9tZWRpYXRlay9tZWRpYXRlayxkc2kudHh0ICAgICAgICAgfCAxOCAr
LS0tDQo+ID4gIC4uLi9iaW5kaW5ncy9waHkvbWVkaWF0ZWssZHNpLXBoeS55YW1sICAgICAgICB8
IDgzICsrKysrKysrKysrKysrKysrKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA4NCBpbnNlcnRp
b25zKCspLCAxNyBkZWxldGlvbnMoLSkNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9waHkvbWVkaWF0ZWssZHNpLXBoeS55YW1sDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2Rpc3Bs
YXkvbWVkaWF0ZWsvbWVkaWF0ZWssZHNpLnR4dCBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9kaXNwbGF5L21lZGlhdGVrL21lZGlhdGVrLGRzaS50eHQNCj4gPiBpbmRleCBmMDZm
MjRkNDA1YTUuLjgyMzhhODY2ODZiZSAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvZGlzcGxheS9tZWRpYXRlay9tZWRpYXRlayxkc2kudHh0DQo+ID4g
KysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2Rpc3BsYXkvbWVkaWF0ZWsv
bWVkaWF0ZWssZHNpLnR4dA0KPiA+IEBAIC0yMiwyMyArMjIsNyBAQCBSZXF1aXJlZCBwcm9wZXJ0
aWVzOg0KPiA+ICBNSVBJIFRYIENvbmZpZ3VyYXRpb24gTW9kdWxlDQo+ID4gID09PT09PT09PT09
PT09PT09PT09PT09PT09PT0NCj4gPg0KPiA+IC1UaGUgTUlQSSBUWCBjb25maWd1cmF0aW9uIG1v
ZHVsZSBjb250cm9scyB0aGUgTUlQSSBELVBIWS4NCj4gPiAtDQo+ID4gLVJlcXVpcmVkIHByb3Bl
cnRpZXM6DQo+ID4gLS0gY29tcGF0aWJsZTogIm1lZGlhdGVrLDxjaGlwPi1taXBpLXR4Ig0KPiA+
IC0tIHRoZSBzdXBwb3J0ZWQgY2hpcHMgYXJlIG10MjcwMSwgNzYyMywgbXQ4MTczIGFuZCBtdDgx
ODMuDQo+ID4gLS0gcmVnOiBQaHlzaWNhbCBiYXNlIGFkZHJlc3MgYW5kIGxlbmd0aCBvZiB0aGUg
Y29udHJvbGxlcidzIHJlZ2lzdGVycw0KPiA+IC0tIGNsb2NrczogUExMIHJlZmVyZW5jZSBjbG9j
aw0KPiA+IC0tIGNsb2NrLW91dHB1dC1uYW1lczogbmFtZSBvZiB0aGUgb3V0cHV0IGNsb2NrIGxp
bmUgdG8gdGhlIERTSSBlbmNvZGVyDQo+ID4gLS0gI2Nsb2NrLWNlbGxzOiBtdXN0IGJlIDwwPjsN
Cj4gPiAtLSAjcGh5LWNlbGxzOiBtdXN0IGJlIDwwPi4NCj4gPiAtDQo+ID4gLU9wdGlvbmFsIHBy
b3BlcnRpZXM6DQo+ID4gLS0gZHJpdmUtc3RyZW5ndGgtbWljcm9hbXA6IGFkanVzdCBkcml2aW5n
IGN1cnJlbnQsIHNob3VsZCBiZSAzMDAwIH4gNjAwMC4gQW5kDQo+ID4gLSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdGhlIHN0ZXAgaXMgMjAwLg0KPiA+
IC0tIG52bWVtLWNlbGxzOiBBIHBoYW5kbGUgdG8gdGhlIGNhbGlicmF0aW9uIGRhdGEgcHJvdmlk
ZWQgYnkgYSBudm1lbSBkZXZpY2UuIElmDQo+ID4gLSAgICAgICAgICAgICAgIHVuc3BlY2lmaWVk
IGRlZmF1bHQgdmFsdWVzIHNoYWxsIGJlIHVzZWQuDQo+ID4gLS0gbnZtZW0tY2VsbC1uYW1lczog
U2hvdWxkIGJlICJjYWxpYnJhdGlvbi1kYXRhIg0KPiA+ICtTZWUgcGh5L21lZGlhdGVrLGRzaS1w
aHkueWFtbA0KPiA+DQo+ID4gIEV4YW1wbGU6DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3BoeS9tZWRpYXRlayxkc2ktcGh5LnlhbWwgYi9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcGh5L21lZGlhdGVrLGRzaS1waHkueWFt
bA0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi44N2Y4
ZGYyNTFhYjANCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL3BoeS9tZWRpYXRlayxkc2ktcGh5LnlhbWwNCj4gPiBAQCAtMCwwICsx
LDgzIEBADQo+ID4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChHUEwtMi4wLW9ubHkgT1Ig
QlNELTItQ2xhdXNlKQ0KPiA+ICsjIENvcHlyaWdodCAoYykgMjAyMCBNZWRpYVRlaw0KPiA+ICsl
WUFNTCAxLjINCj4gPiArLS0tDQo+ID4gKyRpZDogaHR0cDovL2RldmljZXRyZWUub3JnL3NjaGVt
YXMvcGh5L21lZGlhdGVrLGRzaS1waHkueWFtbCMNCj4gPiArJHNjaGVtYTogaHR0cDovL2Rldmlj
ZXRyZWUub3JnL21ldGEtc2NoZW1hcy9jb3JlLnlhbWwjDQo+ID4gKw0KPiA+ICt0aXRsZTogTWVk
aWFUZWsgTUlQSSBEaXNwbGF5IFNlcmlhbCBJbnRlcmZhY2UgKERTSSkgUEhZIGJpbmRpbmcNCj4g
PiArDQo+ID4gK21haW50YWluZXJzOg0KPiA+ICsgIC0gQ2h1bi1LdWFuZyBIdSA8Y2h1bmt1YW5n
Lmh1QGtlcm5lbC5vcmc+DQo+ID4gKyAgLSBDaHVuZmVuZyBZdW4gPGNodW5mZW5nLnl1bkBtZWRp
YXRlay5jb20+DQo+IA0KPiBQbGVhc2UgYWRkIFBoaWxpcHAgWmFiZWwgYmVjYXVzZSBoZSBpcyBN
ZWRpYXRlayBEUk0gZHJpdmVyIG1haW50YWluZXIuDQpPaw0KPiANCj4gRFJNIERSSVZFUlMgRk9S
IE1FRElBVEVLDQo+IE06IENodW4tS3VhbmcgSHUgPGNodW5rdWFuZy5odUBrZXJuZWwub3JnPg0K
PiBNOiBQaGlsaXBwIFphYmVsIDxwLnphYmVsQHBlbmd1dHJvbml4LmRlPg0KPiBMOiBkcmktZGV2
ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+IFM6IFN1cHBvcnRlZA0KPiBGOiBEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvZGlzcGxheS9tZWRpYXRlay8NCj4gDQo+ID4gKw0KPiA+
ICtkZXNjcmlwdGlvbjogVGhlIE1JUEkgRFNJIFBIWSBzdXBwb3J0cyB1cCB0byA0LWxhbmUgb3V0
cHV0Lg0KPiA+ICsNCj4gPiArcHJvcGVydGllczoNCj4gPiArICAkbm9kZW5hbWU6DQo+ID4gKyAg
ICBwYXR0ZXJuOiAiXmRzaS1waHlAWzAtOWEtZl0rJCINCj4gPiArDQo+ID4gKyAgY29tcGF0aWJs
ZToNCj4gPiArICAgIGVudW06DQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQyNzAxLW1pcGktdHgN
Cj4gPiArICAgICAgLSBtZWRpYXRlayxtdDc2MjMtbWlwaS10eA0KPiA+ICsgICAgICAtIG1lZGlh
dGVrLG10ODE3My1taXBpLXR4DQo+IA0KPiBBZGQgbWVkaWF0ZWssbXQ4MTgzLW1pcGktdHgNCk9r
LCB3aWxsIGFkZCBpdA0KDQpUaGFua3MNCg0KPiANCj4gUmVnYXJkcywNCj4gQ2h1bi1LdWFuZy4N
Cj4gDQo+ID4gKw0KPiA+ICsgIHJlZzoNCj4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4gKw0KPiA+
ICsgIGNsb2NrczoNCj4gPiArICAgIGl0ZW1zOg0KPiA+ICsgICAgICAtIGRlc2NyaXB0aW9uOiBQ
TEwgcmVmZXJlbmNlIGNsb2NrDQo+ID4gKw0KPiA+ICsgIGNsb2NrLW91dHB1dC1uYW1lczoNCj4g
PiArICAgIG1heEl0ZW1zOiAxDQo+ID4gKw0KPiA+ICsgICIjcGh5LWNlbGxzIjoNCj4gPiArICAg
IGNvbnN0OiAwDQo+ID4gKw0KPiA+ICsgICIjY2xvY2stY2VsbHMiOg0KPiA+ICsgICAgY29uc3Q6
IDANCj4gPiArDQo+ID4gKyAgbnZtZW0tY2VsbHM6DQo+ID4gKyAgICBtYXhJdGVtczogMQ0KPiA+
ICsgICAgZGVzY3JpcHRpb246IEEgcGhhbmRsZSB0byB0aGUgY2FsaWJyYXRpb24gZGF0YSBwcm92
aWRlZCBieSBhIG52bWVtIGRldmljZSwNCj4gPiArICAgICAgaWYgdW5zcGVjaWZpZWQsIGRlZmF1
bHQgdmFsdWVzIHNoYWxsIGJlIHVzZWQuDQo+ID4gKw0KPiA+ICsgIG52bWVtLWNlbGwtbmFtZXM6
DQo+ID4gKyAgICBpdGVtczoNCj4gPiArICAgICAgLSBjb25zdDogY2FsaWJyYXRpb24tZGF0YQ0K
PiA+ICsNCj4gPiArICBkcml2ZS1zdHJlbmd0aC1taWNyb2FtcDoNCj4gPiArICAgIGRlc2NyaXB0
aW9uOiBhZGp1c3QgZHJpdmluZyBjdXJyZW50LCB0aGUgc3RlcCBpcyAyMDAuDQo+ID4gKyAgICAk
cmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy91aW50MzINCj4gPiArICAgIG1p
bmltdW06IDIwMDANCj4gPiArICAgIG1heGltdW06IDYwMDANCj4gPiArICAgIGRlZmF1bHQ6IDQ2
MDANCj4gPiArDQo+ID4gK3JlcXVpcmVkOg0KPiA+ICsgIC0gY29tcGF0aWJsZQ0KPiA+ICsgIC0g
cmVnDQo+ID4gKyAgLSBjbG9ja3MNCj4gPiArICAtIGNsb2NrLW91dHB1dC1uYW1lcw0KPiA+ICsg
IC0gIiNwaHktY2VsbHMiDQo+ID4gKyAgLSAiI2Nsb2NrLWNlbGxzIg0KPiA+ICsNCj4gPiArYWRk
aXRpb25hbFByb3BlcnRpZXM6IGZhbHNlDQo+ID4gKw0KPiA+ICtleGFtcGxlczoNCj4gPiArICAt
IHwNCj4gPiArICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9jbG9jay9tdDgxNzMtY2xrLmg+DQo+
ID4gKyAgICBkc2ktcGh5QDEwMjE1MDAwIHsNCj4gPiArICAgICAgICBjb21wYXRpYmxlID0gIm1l
ZGlhdGVrLG10ODE3My1taXBpLXR4IjsNCj4gPiArICAgICAgICByZWcgPSA8MHgxMDIxNTAwMCAw
eDEwMDA+Ow0KPiA+ICsgICAgICAgIGNsb2NrcyA9IDwmY2xrMjZtPjsNCj4gPiArICAgICAgICBj
bG9jay1vdXRwdXQtbmFtZXMgPSAibWlwaV90eDBfcGxsIjsNCj4gPiArICAgICAgICBkcml2ZS1z
dHJlbmd0aC1taWNyb2FtcCA9IDw0MDAwPjsNCj4gPiArICAgICAgICBudm1lbS1jZWxscz0gPCZt
aXBpX3R4X2NhbGlicmF0aW9uPjsNCj4gPiArICAgICAgICBudm1lbS1jZWxsLW5hbWVzID0gImNh
bGlicmF0aW9uLWRhdGEiOw0KPiA+ICsgICAgICAgICNjbG9jay1jZWxscyA9IDwwPjsNCj4gPiAr
ICAgICAgICAjcGh5LWNlbGxzID0gPDA+Ow0KPiA+ICsgICAgfTsNCj4gPiArDQo+ID4gKy4uLg0K
PiA+IC0tDQo+ID4gMi4xOC4wDQo+ID4NCg0K

