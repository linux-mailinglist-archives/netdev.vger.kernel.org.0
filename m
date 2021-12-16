Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EF547676A
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 02:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbhLPB2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 20:28:18 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:52960 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229548AbhLPB2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 20:28:17 -0500
X-UUID: aba171f221004e379e61fc097ed129d2-20211216
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=lPwZ/wiMhF2SlW3zUGCuz9quzus0l5KZmaU6H+G/S3Y=;
        b=TBs2DTvlLhImgc7m8teAN9YfbsHuZPgnKbbdPUhla142rf0sOnm7ic9YChJu/XOUp5aQW4EduUXlszgipk82dEAH2IKnrbh8keZpZ4v8DftZx8MPzs6DTDI68B8O3+Xr/kLLNyxGYj5YZt22CRu8pd1lxtgNXdFzmxtOwidvKvg=;
X-UUID: aba171f221004e379e61fc097ed129d2-20211216
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1130924326; Thu, 16 Dec 2021 09:28:14 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 16 Dec 2021 09:28:13 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Dec 2021 09:28:12 +0800
Message-ID: <c320d912b4569363514390718e2a81f565f9e225.camel@mediatek.com>
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
Date:   Thu, 16 Dec 2021 09:28:13 +0800
In-Reply-To: <c9b3d31a-1c18-32ec-8077-603bb93fe8d0@gmail.com>
References: <20211210013129.811-1-biao.huang@mediatek.com>
         <20211210013129.811-4-biao.huang@mediatek.com>
         <c9b3d31a-1c18-32ec-8077-603bb93fe8d0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBNYXR0aGlhcywNCglUaGFua3MgZm9yIHlvdXIgY29tbWVudHN+DQpPbiBXZWQsIDIwMjEt
MTItMTUgYXQgMjA6MjIgKzAxMDAsIE1hdHRoaWFzIEJydWdnZXIgd3JvdGU6DQo+IA0KPiBPbiAx
MC8xMi8yMDIxIDAyOjMxLCBCaWFvIEh1YW5nIHdyb3RlOg0KPiA+IFNpbmNlIHRoZXJlIGFyZSBz
b21lIGNoYW5nZXMgaW4gZXRoZXJuZXQgZHJpdmVyLA0KPiA+IHVwZGF0ZSBldGhlcm5ldCBkZXZp
Y2Ugbm9kZSBpbiBkdHMgdG8gYWNjb21tb2RhdGUgdG8gaXQuDQo+ID4gDQo+IA0KPiBJIGhhdmUg
YSBoYXJkIHRpbWUgdG8gdW5kZXJzdGFuZCBob3cgdGhlIGZpcnN0IHR3byBwYXRjaGVzIGFyZQ0K
PiByZWxhdGVkIHRvIHRoaXMgDQo+IG9uZS4gUGxlYXNlIGJlIG1vcmUgc3BlY2lmaWMgaW4geW91
ciBjb21taXQgbWVzc2FnZS4NClRoaXMgZHRzIHBhdGNoIGlzIG5vdCByZWxhdGVkIHRvIHByZXZp
b3VzIHR3byBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLg0KDQpBY3R1YWxseSwgdGhpcyBwYXRjaCBz
aG91bGQgYmUgc2VudCB3aXRoIGNvbW1pdA0KIjcxYTU1YTIzMTViMDQ3MzUyYjNkNjVlMmQyNDcy
NDIwN2JlODVhZTIiLCB3aGljaCBhZGRlZCBleHRyYSBSTUlJDQpzdXBwb3J0IGluIGRyaXZlci4g
QnV0IHVuZm9ydHVuYXRlbHksIHdlIG1pc3NlZCBpdCBvdXQuDQoNCklzIHRoZXJlIGFueSBwcm9w
ZXIgd2F5IHRvIHJlbGF0ZSB0aGlzIHBhdGNoIHRvIGNvbW1pdA0KIjcxYTU1YTIzMTViMDQ3MzUy
YjNkNjVlMmQyNDcyNDIwN2JlODVhZTIiPyAoRml4ZWQgdGFnIHNlZW1zIG5vdCBhIGdvb2QNCmNo
b2ljZSwgb3IganVzdCBhZGQgbW9yZSBkZXRhaWxzIGluIGNvbW1pdCBtZXNzYWdlPykNCj4gIA0K
PiBBbHNvIHBsZWFzZSBiZXdhcmUgdGhhdCB3ZSBzaG91bGQgbWFrZSBzdXJlIHRoYXQgYSBuZXdl
ciBkcml2ZXINCj4gdmVyc2lvbiBzaG91bGQgDQo+IHN0aWxsIHdvcmsgcHJvcGVybHkgd2l0aCBh
biBvbGRlciBkZXZpY2UgdHJlZSwgd2hpY2ggZG9lcyBub3QgaGF2ZQ0KPiB5b3VyIGNoYW5nZXMu
DQo+IA0KPiBSZWdhcmRzLA0KPiBNYXR0aGlhcw0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWFv
IEh1YW5nIDxiaWFvLmh1YW5nQG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGFyY2gvYXJt
NjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQyNzEyLWV2Yi5kdHMgfCAgMSArDQo+ID4gICBhcmNoL2Fy
bTY0L2Jvb3QvZHRzL21lZGlhdGVrL210MjcxMmUuZHRzaSAgIHwgMTQgKysrKysrKysrLS0tLS0N
Cj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkN
Cj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDI3
MTItZXZiLmR0cw0KPiA+IGIvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDI3MTItZXZi
LmR0cw0KPiA+IGluZGV4IDdkMzY5ZmRkMzExNy4uMTFhYTEzNWFhMGYzIDEwMDY0NA0KPiA+IC0t
LSBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQyNzEyLWV2Yi5kdHMNCj4gPiArKysg
Yi9hcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210MjcxMi1ldmIuZHRzDQo+ID4gQEAgLTEx
MCw2ICsxMTAsNyBAQCAmZXRoIHsNCj4gPiAgIAlwaHktaGFuZGxlID0gPCZldGhlcm5ldF9waHkw
PjsNCj4gPiAgIAltZWRpYXRlayx0eC1kZWxheS1wcyA9IDwxNTMwPjsNCj4gPiAgIAlzbnBzLHJl
c2V0LWdwaW8gPSA8JnBpbyA4NyBHUElPX0FDVElWRV9MT1c+Ow0KPiA+ICsJc25wcyxyZXNldC1k
ZWxheXMtdXMgPSA8MCAxMDAwMCAxMDAwMD47DQo+ID4gICAJcGluY3RybC1uYW1lcyA9ICJkZWZh
dWx0IiwgInNsZWVwIjsNCj4gPiAgIAlwaW5jdHJsLTAgPSA8JmV0aF9kZWZhdWx0PjsNCj4gPiAg
IAlwaW5jdHJsLTEgPSA8JmV0aF9zbGVlcD47DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
Ym9vdC9kdHMvbWVkaWF0ZWsvbXQyNzEyZS5kdHNpDQo+ID4gYi9hcmNoL2FybTY0L2Jvb3QvZHRz
L21lZGlhdGVrL210MjcxMmUuZHRzaQ0KPiA+IGluZGV4IGE5Y2NhOWMxNDZmZC4uOWU4NTBlMDRm
ZmZiIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQyNzEy
ZS5kdHNpDQo+ID4gKysrIGIvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDI3MTJlLmR0
c2kNCj4gPiBAQCAtNzI2LDcgKzcyNiw3IEBAIHF1ZXVlMiB7DQo+ID4gICAJfTsNCj4gPiAgIA0K
PiA+ICAgCWV0aDogZXRoZXJuZXRAMTEwMWMwMDAgew0KPiA+IC0JCWNvbXBhdGlibGUgPSAibWVk
aWF0ZWssbXQyNzEyLWdtYWMiOw0KPiA+ICsJCWNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQyNzEy
LWdtYWMiLCAic25wcyxkd21hYy0NCj4gPiA0LjIwYSI7DQo+ID4gICAJCXJlZyA9IDwwIDB4MTEw
MWMwMDAgMCAweDEzMDA+Ow0KPiA+ICAgCQlpbnRlcnJ1cHRzID0gPEdJQ19TUEkgMjM3IElSUV9U
WVBFX0xFVkVMX0xPVz47DQo+ID4gICAJCWludGVycnVwdC1uYW1lcyA9ICJtYWNpcnEiOw0KPiA+
IEBAIC03MzQsMTUgKzczNCwxOSBAQCBldGg6IGV0aGVybmV0QDExMDFjMDAwIHsNCj4gPiAgIAkJ
Y2xvY2stbmFtZXMgPSAiYXhpIiwNCj4gPiAgIAkJCSAgICAgICJhcGIiLA0KPiA+ICAgCQkJICAg
ICAgIm1hY19tYWluIiwNCj4gPiAtCQkJICAgICAgInB0cF9yZWYiOw0KPiA+ICsJCQkgICAgICAi
cHRwX3JlZiIsDQo+ID4gKwkJCSAgICAgICJybWlpX2ludGVybmFsIjsNCj4gPiAgIAkJY2xvY2tz
ID0gPCZwZXJpY2ZnIENMS19QRVJJX0dNQUM+LA0KPiA+ICAgCQkJIDwmcGVyaWNmZyBDTEtfUEVS
SV9HTUFDX1BDTEs+LA0KPiA+ICAgCQkJIDwmdG9wY2tnZW4gQ0xLX1RPUF9FVEhFUl8xMjVNX1NF
TD4sDQo+ID4gLQkJCSA8JnRvcGNrZ2VuIENMS19UT1BfRVRIRVJfNTBNX1NFTD47DQo+ID4gKwkJ
CSA8JnRvcGNrZ2VuIENMS19UT1BfRVRIRVJfNTBNX1NFTD4sDQo+ID4gKwkJCSA8JnRvcGNrZ2Vu
IENMS19UT1BfRVRIRVJfNTBNX1JNSUlfU0VMPjsNCj4gPiAgIAkJYXNzaWduZWQtY2xvY2tzID0g
PCZ0b3Bja2dlbiBDTEtfVE9QX0VUSEVSXzEyNU1fU0VMPiwNCj4gPiAtCQkJCSAgPCZ0b3Bja2dl
biBDTEtfVE9QX0VUSEVSXzUwTV9TRUw+Ow0KPiA+ICsJCQkJICA8JnRvcGNrZ2VuIENMS19UT1Bf
RVRIRVJfNTBNX1NFTD4sDQo+ID4gKwkJCQkgIDwmdG9wY2tnZW4NCj4gPiBDTEtfVE9QX0VUSEVS
XzUwTV9STUlJX1NFTD47DQo+ID4gICAJCWFzc2lnbmVkLWNsb2NrLXBhcmVudHMgPSA8JnRvcGNr
Z2VuDQo+ID4gQ0xLX1RPUF9FVEhFUlBMTF8xMjVNPiwNCj4gPiAtCQkJCQkgPCZ0b3Bja2dlbiBD
TEtfVE9QX0FQTEwxX0QzPjsNCj4gPiArCQkJCQkgPCZ0b3Bja2dlbiBDTEtfVE9QX0FQTEwxX0Qz
PiwNCj4gPiArCQkJCQkgPCZ0b3Bja2dlbg0KPiA+IENMS19UT1BfRVRIRVJQTExfNTBNPjsNCj4g
PiAgIAkJcG93ZXItZG9tYWlucyA9IDwmc2Nwc3lzIE1UMjcxMl9QT1dFUl9ET01BSU5fQVVESU8+
Ow0KPiA+ICAgCQltZWRpYXRlayxwZXJpY2ZnID0gPCZwZXJpY2ZnPjsNCj4gPiAgIAkJc25wcyxh
eGktY29uZmlnID0gPCZzdG1tYWNfYXhpX3NldHVwPjsNCj4gPiANCg==

