Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FE62D2073
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgLHCBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:01:23 -0500
Received: from Mailgw01.mediatek.com ([1.203.163.78]:51429 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725877AbgLHCBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 21:01:23 -0500
X-UUID: 8a664c262b164f2bb78d63554f53e19a-20201208
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=AnfMsxCsqIaWPXAofU2Qh3nt/yEpA1Nncyh3grmr2Hs=;
        b=a2h/GOb3tMmj4tVWWW0Z8TUR3FBZ3HuPCXErjJgQio5LqJUJMEZR1tVd2u1BuMDPlmDLv2O+NDJZ8PcqVt24FAPKEqv1uNg6UFJa56TTUYvo2315Fqbm9h8UgU9F6hHw+HODvloC9Xj/ab+g8IgGqFF1/2dzNy25Nb0tHM+TMbc=;
X-UUID: 8a664c262b164f2bb78d63554f53e19a-20201208
Received: from mtkcas35.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1168966895; Tue, 08 Dec 2020 10:00:35 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by MTKMBS31DR.mediatek.inc
 (172.27.6.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Dec
 2020 10:00:23 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Dec 2020 10:00:26 +0800
Message-ID: <1607392825.23328.5.camel@mhfsdcap03>
Subject: Re: [PATCH v3 07/11] dt-bindings: phy: convert MIP DSI PHY binding
 to YAML schema
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "David Airlie" <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Kishon Vijay Abraham I" <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Min Guo" <min.guo@mediatek.com>,
        <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>
Date:   Tue, 8 Dec 2020 10:00:25 +0800
In-Reply-To: <20201207211920.GA841059@robh.at.kernel.org>
References: <20201118082126.42701-1-chunfeng.yun@mediatek.com>
         <20201118082126.42701-7-chunfeng.yun@mediatek.com>
         <20201207211920.GA841059@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: BA25879DABC571C822341F4AC2ABA120CA9AACE0D97F7DEA60AC1AC6A1D432792000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEyLTA3IGF0IDE1OjE5IC0wNjAwLCBSb2IgSGVycmluZyB3cm90ZToNCj4g
T24gV2VkLCBOb3YgMTgsIDIwMjAgYXQgMDQ6MjE6MjJQTSArMDgwMCwgQ2h1bmZlbmcgWXVuIHdy
b3RlOg0KPiA+IENvbnZlcnQgTUlQSSBEU0kgUEhZIGJpbmRpbmcgdG8gWUFNTCBzY2hlbWEgbWVk
aWF0ZWssZHNpLXBoeS55YW1sDQo+ID4gDQo+ID4gQ2M6IENodW4tS3VhbmcgSHUgPGNodW5rdWFu
Zy5odUBrZXJuZWwub3JnPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENodW5mZW5nIFl1biA8Y2h1bmZl
bmcueXVuQG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4gPiB2MzogbmV3IHBhdGNoDQo+ID4gLS0t
DQo+ID4gIC4uLi9kaXNwbGF5L21lZGlhdGVrL21lZGlhdGVrLGRzaS50eHQgICAgICAgICB8IDE4
ICstLS0NCj4gPiAgLi4uL2JpbmRpbmdzL3BoeS9tZWRpYXRlayxkc2ktcGh5LnlhbWwgICAgICAg
IHwgODMgKysrKysrKysrKysrKysrKysrKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDg0IGluc2Vy
dGlvbnMoKyksIDE3IGRlbGV0aW9ucygtKQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3BoeS9tZWRpYXRlayxkc2ktcGh5LnlhbWwNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2Rp
c3BsYXkvbWVkaWF0ZWsvbWVkaWF0ZWssZHNpLnR4dCBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9kaXNwbGF5L21lZGlhdGVrL21lZGlhdGVrLGRzaS50eHQNCj4gPiBpbmRleCBm
MDZmMjRkNDA1YTUuLjgyMzhhODY2ODZiZSAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvZGlzcGxheS9tZWRpYXRlay9tZWRpYXRlayxkc2kudHh0DQo+
ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2Rpc3BsYXkvbWVkaWF0
ZWsvbWVkaWF0ZWssZHNpLnR4dA0KPiA+IEBAIC0yMiwyMyArMjIsNyBAQCBSZXF1aXJlZCBwcm9w
ZXJ0aWVzOg0KPiA+ICBNSVBJIFRYIENvbmZpZ3VyYXRpb24gTW9kdWxlDQo+ID4gID09PT09PT09
PT09PT09PT09PT09PT09PT09PT0NCj4gPiAgDQo+ID4gLVRoZSBNSVBJIFRYIGNvbmZpZ3VyYXRp
b24gbW9kdWxlIGNvbnRyb2xzIHRoZSBNSVBJIEQtUEhZLg0KPiA+IC0NCj4gPiAtUmVxdWlyZWQg
cHJvcGVydGllczoNCj4gPiAtLSBjb21wYXRpYmxlOiAibWVkaWF0ZWssPGNoaXA+LW1pcGktdHgi
DQo+ID4gLS0gdGhlIHN1cHBvcnRlZCBjaGlwcyBhcmUgbXQyNzAxLCA3NjIzLCBtdDgxNzMgYW5k
IG10ODE4My4NCj4gPiAtLSByZWc6IFBoeXNpY2FsIGJhc2UgYWRkcmVzcyBhbmQgbGVuZ3RoIG9m
IHRoZSBjb250cm9sbGVyJ3MgcmVnaXN0ZXJzDQo+ID4gLS0gY2xvY2tzOiBQTEwgcmVmZXJlbmNl
IGNsb2NrDQo+ID4gLS0gY2xvY2stb3V0cHV0LW5hbWVzOiBuYW1lIG9mIHRoZSBvdXRwdXQgY2xv
Y2sgbGluZSB0byB0aGUgRFNJIGVuY29kZXINCj4gPiAtLSAjY2xvY2stY2VsbHM6IG11c3QgYmUg
PDA+Ow0KPiA+IC0tICNwaHktY2VsbHM6IG11c3QgYmUgPDA+Lg0KPiA+IC0NCj4gPiAtT3B0aW9u
YWwgcHJvcGVydGllczoNCj4gPiAtLSBkcml2ZS1zdHJlbmd0aC1taWNyb2FtcDogYWRqdXN0IGRy
aXZpbmcgY3VycmVudCwgc2hvdWxkIGJlIDMwMDAgfiA2MDAwLiBBbmQNCj4gPiAtCQkJCQkJICAg
dGhlIHN0ZXAgaXMgMjAwLg0KPiA+IC0tIG52bWVtLWNlbGxzOiBBIHBoYW5kbGUgdG8gdGhlIGNh
bGlicmF0aW9uIGRhdGEgcHJvdmlkZWQgYnkgYSBudm1lbSBkZXZpY2UuIElmDQo+ID4gLSAgICAg
ICAgICAgICAgIHVuc3BlY2lmaWVkIGRlZmF1bHQgdmFsdWVzIHNoYWxsIGJlIHVzZWQuDQo+ID4g
LS0gbnZtZW0tY2VsbC1uYW1lczogU2hvdWxkIGJlICJjYWxpYnJhdGlvbi1kYXRhIg0KPiA+ICtT
ZWUgcGh5L21lZGlhdGVrLGRzaS1waHkueWFtbA0KPiA+ICANCj4gPiAgRXhhbXBsZToNCj4gPiAg
DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9waHkv
bWVkaWF0ZWssZHNpLXBoeS55YW1sIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L3BoeS9tZWRpYXRlayxkc2ktcGh5LnlhbWwNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+
IGluZGV4IDAwMDAwMDAwMDAwMC4uODdmOGRmMjUxYWIwDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+
ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9waHkvbWVkaWF0ZWssZHNp
LXBoeS55YW1sDQo+ID4gQEAgLTAsMCArMSw4MyBAQA0KPiA+ICsjIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiAoR1BMLTIuMC1vbmx5IE9SIEJTRC0yLUNsYXVzZSkNCj4gPiArIyBDb3B5cmlnaHQg
KGMpIDIwMjAgTWVkaWFUZWsNCj4gPiArJVlBTUwgMS4yDQo+ID4gKy0tLQ0KPiA+ICskaWQ6IGh0
dHA6Ly9kZXZpY2V0cmVlLm9yZy9zY2hlbWFzL3BoeS9tZWRpYXRlayxkc2ktcGh5LnlhbWwjDQo+
ID4gKyRzY2hlbWE6IGh0dHA6Ly9kZXZpY2V0cmVlLm9yZy9tZXRhLXNjaGVtYXMvY29yZS55YW1s
Iw0KPiA+ICsNCj4gPiArdGl0bGU6IE1lZGlhVGVrIE1JUEkgRGlzcGxheSBTZXJpYWwgSW50ZXJm
YWNlIChEU0kpIFBIWSBiaW5kaW5nDQo+ID4gKw0KPiA+ICttYWludGFpbmVyczoNCj4gPiArICAt
IENodW4tS3VhbmcgSHUgPGNodW5rdWFuZy5odUBrZXJuZWwub3JnPg0KPiA+ICsgIC0gQ2h1bmZl
bmcgWXVuIDxjaHVuZmVuZy55dW5AbWVkaWF0ZWsuY29tPg0KPiA+ICsNCj4gPiArZGVzY3JpcHRp
b246IFRoZSBNSVBJIERTSSBQSFkgc3VwcG9ydHMgdXAgdG8gNC1sYW5lIG91dHB1dC4NCj4gPiAr
DQo+ID4gK3Byb3BlcnRpZXM6DQo+ID4gKyAgJG5vZGVuYW1lOg0KPiA+ICsgICAgcGF0dGVybjog
Il5kc2ktcGh5QFswLTlhLWZdKyQiDQo+ID4gKw0KPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4gKyAg
ICBlbnVtOg0KPiA+ICsgICAgICAtIG1lZGlhdGVrLG10MjcwMS1taXBpLXR4DQo+ID4gKyAgICAg
IC0gbWVkaWF0ZWssbXQ3NjIzLW1pcGktdHgNCj4gPiArICAgICAgLSBtZWRpYXRlayxtdDgxNzMt
bWlwaS10eA0KPiA+ICsNCj4gPiArICByZWc6DQo+ID4gKyAgICBtYXhJdGVtczogMQ0KPiA+ICsN
Cj4gPiArICBjbG9ja3M6DQo+ID4gKyAgICBpdGVtczoNCj4gPiArICAgICAgLSBkZXNjcmlwdGlv
bjogUExMIHJlZmVyZW5jZSBjbG9jaw0KPiA+ICsNCj4gPiArICBjbG9jay1vdXRwdXQtbmFtZXM6
DQo+ID4gKyAgICBtYXhJdGVtczogMQ0KPiA+ICsNCj4gPiArICAiI3BoeS1jZWxscyI6DQo+ID4g
KyAgICBjb25zdDogMA0KPiA+ICsNCj4gPiArICAiI2Nsb2NrLWNlbGxzIjoNCj4gPiArICAgIGNv
bnN0OiAwDQo+ID4gKw0KPiA+ICsgIG52bWVtLWNlbGxzOg0KPiA+ICsgICAgbWF4SXRlbXM6IDEN
Cj4gPiArICAgIGRlc2NyaXB0aW9uOiBBIHBoYW5kbGUgdG8gdGhlIGNhbGlicmF0aW9uIGRhdGEg
cHJvdmlkZWQgYnkgYSBudm1lbSBkZXZpY2UsDQo+ID4gKyAgICAgIGlmIHVuc3BlY2lmaWVkLCBk
ZWZhdWx0IHZhbHVlcyBzaGFsbCBiZSB1c2VkLg0KPiA+ICsNCj4gPiArICBudm1lbS1jZWxsLW5h
bWVzOg0KPiA+ICsgICAgaXRlbXM6DQo+ID4gKyAgICAgIC0gY29uc3Q6IGNhbGlicmF0aW9uLWRh
dGENCj4gPiArDQo+ID4gKyAgZHJpdmUtc3RyZW5ndGgtbWljcm9hbXA6DQo+ID4gKyAgICBkZXNj
cmlwdGlvbjogYWRqdXN0IGRyaXZpbmcgY3VycmVudCwgdGhlIHN0ZXAgaXMgMjAwLg0KPiANCj4g
bXVsdGlwbGVPZjogMjAwDQpHb3QgaXQuDQo+IA0KPiA+ICsgICAgJHJlZjogL3NjaGVtYXMvdHlw
ZXMueWFtbCMvZGVmaW5pdGlvbnMvdWludDMyDQo+IA0KPiBDYW4gZHJvcC4gU3RhbmRhcmQgdW5p
dCBzdWZmaXhlcyBoYXZlIGEgdHlwZSBhbHJlYWR5Lg0KT2ssIHRoYW5rcyBhIGxvdA0KDQo+IA0K
PiA+ICsgICAgbWluaW11bTogMjAwMA0KPiA+ICsgICAgbWF4aW11bTogNjAwMA0KPiA+ICsgICAg
ZGVmYXVsdDogNDYwMA0KPiA+ICsNCj4gPiArcmVxdWlyZWQ6DQo+ID4gKyAgLSBjb21wYXRpYmxl
DQo+ID4gKyAgLSByZWcNCj4gPiArICAtIGNsb2Nrcw0KPiA+ICsgIC0gY2xvY2stb3V0cHV0LW5h
bWVzDQo+ID4gKyAgLSAiI3BoeS1jZWxscyINCj4gPiArICAtICIjY2xvY2stY2VsbHMiDQo+ID4g
Kw0KPiA+ICthZGRpdGlvbmFsUHJvcGVydGllczogZmFsc2UNCj4gPiArDQo+ID4gK2V4YW1wbGVz
Og0KPiA+ICsgIC0gfA0KPiA+ICsgICAgI2luY2x1ZGUgPGR0LWJpbmRpbmdzL2Nsb2NrL210ODE3
My1jbGsuaD4NCj4gPiArICAgIGRzaS1waHlAMTAyMTUwMDAgew0KPiA+ICsgICAgICAgIGNvbXBh
dGlibGUgPSAibWVkaWF0ZWssbXQ4MTczLW1pcGktdHgiOw0KPiA+ICsgICAgICAgIHJlZyA9IDww
eDEwMjE1MDAwIDB4MTAwMD47DQo+ID4gKyAgICAgICAgY2xvY2tzID0gPCZjbGsyNm0+Ow0KPiA+
ICsgICAgICAgIGNsb2NrLW91dHB1dC1uYW1lcyA9ICJtaXBpX3R4MF9wbGwiOw0KPiA+ICsgICAg
ICAgIGRyaXZlLXN0cmVuZ3RoLW1pY3JvYW1wID0gPDQwMDA+Ow0KPiA+ICsgICAgICAgIG52bWVt
LWNlbGxzPSA8Jm1pcGlfdHhfY2FsaWJyYXRpb24+Ow0KPiA+ICsgICAgICAgIG52bWVtLWNlbGwt
bmFtZXMgPSAiY2FsaWJyYXRpb24tZGF0YSI7DQo+ID4gKyAgICAgICAgI2Nsb2NrLWNlbGxzID0g
PDA+Ow0KPiA+ICsgICAgICAgICNwaHktY2VsbHMgPSA8MD47DQo+ID4gKyAgICB9Ow0KPiA+ICsN
Cj4gPiArLi4uDQo+ID4gLS0gDQo+ID4gMi4xOC4wDQo+ID4gDQoNCg==

