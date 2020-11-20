Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50DF2BA054
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 03:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKTCZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 21:25:11 -0500
Received: from mailgw02.mediatek.com ([1.203.163.81]:18855 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726549AbgKTCZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 21:25:10 -0500
X-UUID: 114c18dc7e44412bad972cfabfcc6587-20201120
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=tK3LSMVAjG6d7GMpXdDRnIvlzSI8hJUSp1hQeVKgOdA=;
        b=huamlgbA5F8dI9GYIzEy3ZIKHD2zs3Xnip6PQAwElMwHJZomIbqYxKxf/hsjVHn3S3QkO8KJQloSkdOe6edeHyJl650FfBcROfHB70ER0/SXfet2IWSg9WKypv71SnmujlLhjApctMUcaw8STiE0TfTlyKZPygh1ZF+08ZO7/Z8=;
X-UUID: 114c18dc7e44412bad972cfabfcc6587-20201120
Received: from mtkcas36.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1560120825; Fri, 20 Nov 2020 10:25:04 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31N1.mediatek.inc
 (172.27.4.69) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Nov
 2020 10:25:00 +0800
Received: from [10.17.3.153] (10.17.3.153) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 20 Nov 2020 10:25:00 +0800
Message-ID: <1605839100.32484.0.camel@mhfsdcap03>
Subject: Re: [PATCH v3 06/11] dt-bindings: phy: convert HDMI PHY binding to
 YAML schema
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
Date:   Fri, 20 Nov 2020 10:25:00 +0800
In-Reply-To: <CAAOTY_9dNyySJkyX78tHDQZPaqD+5Jqixbdbohp319FyXO1X5Q@mail.gmail.com>
References: <20201118082126.42701-1-chunfeng.yun@mediatek.com>
         <20201118082126.42701-6-chunfeng.yun@mediatek.com>
         <CAAOTY_9dNyySJkyX78tHDQZPaqD+5Jqixbdbohp319FyXO1X5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
X-TM-SNTS-SMTP: EEFA5D895C9CCDBC05A08A02EA921E7502A2D2C166CFEA2145249A566CC53CBB2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTExLTIwIGF0IDA3OjQyICswODAwLCBDaHVuLUt1YW5nIEh1IHdyb3RlOg0K
PiBIaSwgQ2h1bmZlbmc6DQo+IA0KPiBDaHVuZmVuZyBZdW4gPGNodW5mZW5nLnl1bkBtZWRpYXRl
ay5jb20+IOaWvCAyMDIw5bm0MTHmnIgxOOaXpSDpgLHkuIkg5LiL5Y2INDoyMeWvq+mBk++8mg0K
PiA+DQo+ID4gQ29udmVydCBIRE1JIFBIWSBiaW5kaW5nIHRvIFlBTUwgc2NoZW1hIG1lZGlhdGVr
LGhkbWktcGh5LnlhbWwNCj4gPg0KPiA+IENjOiBDaHVuLUt1YW5nIEh1IDxjaHVua3VhbmcuaHVA
a2VybmVsLm9yZz4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBDaHVuZmVuZyBZdW4gPGNodW5mZW5nLnl1
bkBtZWRpYXRlay5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IFJvYiBIZXJyaW5nIDxyb2JoQGtlcm5l
bC5vcmc+DQo+ID4gLS0tDQo+ID4gdjM6IGFkZCBSZXZpZXdlZC1ieSBSb2INCj4gPiB2MjogZml4
IGJpbmRpbmcgY2hlY2sgd2FybmluZyBvZiByZWcgaW4gZXhhbXBsZQ0KPiA+IC0tLQ0KPiA+ICAu
Li4vZGlzcGxheS9tZWRpYXRlay9tZWRpYXRlayxoZG1pLnR4dCAgICAgICAgfCAxOCArLS0tDQo+
ID4gIC4uLi9iaW5kaW5ncy9waHkvbWVkaWF0ZWssaGRtaS1waHkueWFtbCAgICAgICB8IDkxICsr
KysrKysrKysrKysrKysrKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA5MiBpbnNlcnRpb25zKCsp
LCAxNyBkZWxldGlvbnMoLSkNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9waHkvbWVkaWF0ZWssaGRtaS1waHkueWFtbA0KPiA+DQo+ID4g
ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9kaXNwbGF5L21l
ZGlhdGVrL21lZGlhdGVrLGhkbWkudHh0IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL2Rpc3BsYXkvbWVkaWF0ZWsvbWVkaWF0ZWssaGRtaS50eHQNCj4gPiBpbmRleCA2YjFjNTg2
NDAzZTQuLmIyODRjYTUxYjkxMyAxMDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvZGlzcGxheS9tZWRpYXRlay9tZWRpYXRlayxoZG1pLnR4dA0KPiA+ICsr
KyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9kaXNwbGF5L21lZGlhdGVrL21l
ZGlhdGVrLGhkbWkudHh0DQo+ID4gQEAgLTUzLDIzICs1Myw3IEBAIFJlcXVpcmVkIHByb3BlcnRp
ZXM6DQo+ID4NCj4gPiAgSERNSSBQSFkNCj4gPiAgPT09PT09PT0NCj4gPiAtDQo+ID4gLVRoZSBI
RE1JIFBIWSBzZXJpYWxpemVzIHRoZSBIRE1JIGVuY29kZXIncyB0aHJlZSBjaGFubmVsIDEwLWJp
dCBwYXJhbGxlbA0KPiA+IC1vdXRwdXQgYW5kIGRyaXZlcyB0aGUgSERNSSBwYWRzLg0KPiA+IC0N
Cj4gPiAtUmVxdWlyZWQgcHJvcGVydGllczoNCj4gPiAtLSBjb21wYXRpYmxlOiAibWVkaWF0ZWss
PGNoaXA+LWhkbWktcGh5Ig0KPiA+IC0tIHRoZSBzdXBwb3J0ZWQgY2hpcHMgYXJlIG10MjcwMSwg
bXQ3NjIzIGFuZCBtdDgxNzMNCj4gPiAtLSByZWc6IFBoeXNpY2FsIGJhc2UgYWRkcmVzcyBhbmQg
bGVuZ3RoIG9mIHRoZSBtb2R1bGUncyByZWdpc3RlcnMNCj4gPiAtLSBjbG9ja3M6IFBMTCByZWZl
cmVuY2UgY2xvY2sNCj4gPiAtLSBjbG9jay1uYW1lczogbXVzdCBjb250YWluICJwbGxfcmVmIg0K
PiA+IC0tIGNsb2NrLW91dHB1dC1uYW1lczogbXVzdCBiZSAiaGRtaXR4X2RpZ19jdHMiIG9uIG10
ODE3Mw0KPiA+IC0tICNwaHktY2VsbHM6IG11c3QgYmUgPDA+DQo+ID4gLS0gI2Nsb2NrLWNlbGxz
OiBtdXN0IGJlIDwwPg0KPiA+IC0NCj4gPiAtT3B0aW9uYWwgcHJvcGVydGllczoNCj4gPiAtLSBt
ZWRpYXRlayxpYmlhczogVFggRFJWIGJpYXMgY3VycmVudCBmb3IgPDEuNjVHYnBzLCBkZWZhdWx0
cyB0byAweGENCj4gPiAtLSBtZWRpYXRlayxpYmlhc191cDogVFggRFJWIGJpYXMgY3VycmVudCBm
b3IgPjEuNjVHYnBzLCBkZWZhdWx0cyB0byAweDFjDQo+ID4gK1NlZSBwaHkvbWVkaWF0ZWssaGRt
aS1waHkueWFtbA0KPiA+DQo+ID4gIEV4YW1wbGU6DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3BoeS9tZWRpYXRlayxoZG1pLXBoeS55YW1s
IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3BoeS9tZWRpYXRlayxoZG1pLXBo
eS55YW1sDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwMDAwMDAu
Ljk2NzAwYmI4YmMwMA0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvcGh5L21lZGlhdGVrLGhkbWktcGh5LnlhbWwNCj4gPiBAQCAt
MCwwICsxLDkxIEBADQo+ID4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChHUEwtMi4wLW9u
bHkgT1IgQlNELTItQ2xhdXNlKQ0KPiA+ICsjIENvcHlyaWdodCAoYykgMjAyMCBNZWRpYVRlaw0K
PiA+ICslWUFNTCAxLjINCj4gPiArLS0tDQo+ID4gKyRpZDogaHR0cDovL2RldmljZXRyZWUub3Jn
L3NjaGVtYXMvcGh5L21lZGlhdGVrLGhkbWktcGh5LnlhbWwjDQo+ID4gKyRzY2hlbWE6IGh0dHA6
Ly9kZXZpY2V0cmVlLm9yZy9tZXRhLXNjaGVtYXMvY29yZS55YW1sIw0KPiA+ICsNCj4gPiArdGl0
bGU6IE1lZGlhVGVrIEhpZ2ggRGVmaW5pdGlvbiBNdWx0aW1lZGlhIEludGVyZmFjZSAoSERNSSkg
UEhZIGJpbmRpbmcNCj4gPiArDQo+ID4gK21haW50YWluZXJzOg0KPiA+ICsgIC0gQ2h1bi1LdWFu
ZyBIdSA8Y2h1bmt1YW5nLmh1QGtlcm5lbC5vcmc+DQo+ID4gKyAgLSBDaHVuZmVuZyBZdW4gPGNo
dW5mZW5nLnl1bkBtZWRpYXRlay5jb20+DQo+IA0KPiBQbGVhc2UgYWRkIFBoaWxpcHAgWmFiZWwg
YmVjYXVzZSBoZSBpcyBNZWRpYXRlayBEUk0gZHJpdmVyIG1haW50YWluZXIuDQpPaywgd2lsbCBk
byBpdA0KDQpUaGFua3MgYSBsb3QNCg0KPiANCj4gRFJNIERSSVZFUlMgRk9SIE1FRElBVEVLDQo+
IE06IENodW4tS3VhbmcgSHUgPGNodW5rdWFuZy5odSBhdCBrZXJuZWwub3JnPg0KPiBNOiBQaGls
aXBwIFphYmVsIDxwLnphYmVsIGF0IHBlbmd1dHJvbml4LmRlPg0KPiBMOiBkcmktZGV2ZWwgYXQg
bGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+IFM6IFN1cHBvcnRlZA0KPiBGOiBEb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvZGlzcGxheS9tZWRpYXRlay8NCj4gDQo+IFJlZ2FyZHMsDQo+
IENodW4tS3VhbmcuDQo+IA0KPiA+ICsNCj4gPiArZGVzY3JpcHRpb246IHwNCj4gPiArICBUaGUg
SERNSSBQSFkgc2VyaWFsaXplcyB0aGUgSERNSSBlbmNvZGVyJ3MgdGhyZWUgY2hhbm5lbCAxMC1i
aXQgcGFyYWxsZWwNCj4gPiArICBvdXRwdXQgYW5kIGRyaXZlcyB0aGUgSERNSSBwYWRzLg0KPiA+
ICsNCj4gPiArcHJvcGVydGllczoNCj4gPiArICAkbm9kZW5hbWU6DQo+ID4gKyAgICBwYXR0ZXJu
OiAiXmhkbWktcGh5QFswLTlhLWZdKyQiDQo+ID4gKw0KPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4g
KyAgICBlbnVtOg0KPiA+ICsgICAgICAtIG1lZGlhdGVrLG10MjcwMS1oZG1pLXBoeQ0KPiA+ICsg
ICAgICAtIG1lZGlhdGVrLG10NzYyMy1oZG1pLXBoeQ0KPiA+ICsgICAgICAtIG1lZGlhdGVrLG10
ODE3My1oZG1pLXBoeQ0KPiA+ICsNCj4gPiArICByZWc6DQo+ID4gKyAgICBtYXhJdGVtczogMQ0K
PiA+ICsNCj4gPiArICBjbG9ja3M6DQo+ID4gKyAgICBpdGVtczoNCj4gPiArICAgICAgLSBkZXNj
cmlwdGlvbjogUExMIHJlZmVyZW5jZSBjbG9jaw0KPiA+ICsNCj4gPiArICBjbG9jay1uYW1lczoN
Cj4gPiArICAgIGl0ZW1zOg0KPiA+ICsgICAgICAtIGNvbnN0OiBwbGxfcmVmDQo+ID4gKw0KPiA+
ICsgIGNsb2NrLW91dHB1dC1uYW1lczoNCj4gPiArICAgIGl0ZW1zOg0KPiA+ICsgICAgICAtIGNv
bnN0OiBoZG1pdHhfZGlnX2N0cw0KPiA+ICsNCj4gPiArICAiI3BoeS1jZWxscyI6DQo+ID4gKyAg
ICBjb25zdDogMA0KPiA+ICsNCj4gPiArICAiI2Nsb2NrLWNlbGxzIjoNCj4gPiArICAgIGNvbnN0
OiAwDQo+ID4gKw0KPiA+ICsgIG1lZGlhdGVrLGliaWFzOg0KPiA+ICsgICAgZGVzY3JpcHRpb246
DQo+ID4gKyAgICAgIFRYIERSViBiaWFzIGN1cnJlbnQgZm9yIDwgMS42NUdicHMNCj4gPiArICAg
ICRyZWY6IC9zY2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3VpbnQzMg0KPiA+ICsgICAg
bWluaW11bTogMA0KPiA+ICsgICAgbWF4aW11bTogNjMNCj4gPiArICAgIGRlZmF1bHQ6IDB4YQ0K
PiA+ICsNCj4gPiArICBtZWRpYXRlayxpYmlhc191cDoNCj4gPiArICAgIGRlc2NyaXB0aW9uOg0K
PiA+ICsgICAgICBUWCBEUlYgYmlhcyBjdXJyZW50IGZvciA+PSAxLjY1R2Jwcw0KPiA+ICsgICAg
JHJlZjogL3NjaGVtYXMvdHlwZXMueWFtbCMvZGVmaW5pdGlvbnMvdWludDMyDQo+ID4gKyAgICBt
aW5pbXVtOiAwDQo+ID4gKyAgICBtYXhpbXVtOiA2Mw0KPiA+ICsgICAgZGVmYXVsdDogMHgxYw0K
PiA+ICsNCj4gPiArcmVxdWlyZWQ6DQo+ID4gKyAgLSBjb21wYXRpYmxlDQo+ID4gKyAgLSByZWcN
Cj4gPiArICAtIGNsb2Nrcw0KPiA+ICsgIC0gY2xvY2stbmFtZXMNCj4gPiArICAtIGNsb2NrLW91
dHB1dC1uYW1lcw0KPiA+ICsgIC0gIiNwaHktY2VsbHMiDQo+ID4gKyAgLSAiI2Nsb2NrLWNlbGxz
Ig0KPiA+ICsNCj4gPiArYWRkaXRpb25hbFByb3BlcnRpZXM6IGZhbHNlDQo+ID4gKw0KPiA+ICtl
eGFtcGxlczoNCj4gPiArICAtIHwNCj4gPiArICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9jbG9j
ay9tdDgxNzMtY2xrLmg+DQo+ID4gKyAgICBoZG1pX3BoeTogaGRtaS1waHlAMTAyMDkxMDAgew0K
PiA+ICsgICAgICAgIGNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ4MTczLWhkbWktcGh5IjsNCj4g
PiArICAgICAgICByZWcgPSA8MHgxMDIwOTEwMCAweDI0PjsNCj4gPiArICAgICAgICBjbG9ja3Mg
PSA8JmFwbWl4ZWRzeXMgQ0xLX0FQTUlYRURfSERNSV9SRUY+Ow0KPiA+ICsgICAgICAgIGNsb2Nr
LW5hbWVzID0gInBsbF9yZWYiOw0KPiA+ICsgICAgICAgIGNsb2NrLW91dHB1dC1uYW1lcyA9ICJo
ZG1pdHhfZGlnX2N0cyI7DQo+ID4gKyAgICAgICAgbWVkaWF0ZWssaWJpYXMgPSA8MHhhPjsNCj4g
PiArICAgICAgICBtZWRpYXRlayxpYmlhc191cCA9IDwweDFjPjsNCj4gPiArICAgICAgICAjY2xv
Y2stY2VsbHMgPSA8MD47DQo+ID4gKyAgICAgICAgI3BoeS1jZWxscyA9IDwwPjsNCj4gPiArICAg
IH07DQo+ID4gKw0KPiA+ICsuLi4NCj4gPiAtLQ0KPiA+IDIuMTguMA0KPiA+DQoNCg==

