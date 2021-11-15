Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AAA44FCC4
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 02:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhKOBml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 20:42:41 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:34552 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229453AbhKOBmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 20:42:40 -0500
X-UUID: 4ea61d22a0674b3eaf17b791f61cfc37-20211115
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=m7CZhzDmIxIx57bHGNSmwup8iYmTNmCUfIGDVzGXVbI=;
        b=ZqA1CGpDxe00eLHYI80qrx8SXmFhx7ISGC+Z0v02SS09MY/ebnzk08QRoVyPGiMZX7DR8ZHkmp4VvPHwLm4vkpy/KlK6F29mm29CW5qJolilbUosI7G2bwpx+IBoHOg8Xhf0c5HcTuExB3X9rL3+Smee34i08ukk8qI4QsWcOeI=;
X-UUID: 4ea61d22a0674b3eaf17b791f61cfc37-20211115
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1421660592; Mon, 15 Nov 2021 09:39:41 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Mon, 15 Nov 2021 09:39:39 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Nov 2021 09:39:38 +0800
Message-ID: <ec7c46b2846a42e18bbaea2f811386bacdd26985.camel@mediatek.com>
Subject: Re: [PATCH v3 4/7] net-next: dt-bindings: dwmac: Convert
 mediatek-dwmac to DT schema
From:   Biao Huang <biao.huang@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <davem@davemloft.net>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <netdev@vger.kernel.org>, "Jose Abreu" <joabreu@synopsys.com>,
        <macpaul.lin@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <angelogioacchino.delregno@collabora.com>,
        <srv_heupstream@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Rob Herring <robh+dt@kernel.org>, <dkirjanov@suse.de>,
        <devicetree@vger.kernel.org>
Date:   Mon, 15 Nov 2021 09:39:38 +0800
In-Reply-To: <1636724917.159298.2463374.nullmailer@robh.at.kernel.org>
References: <20211112093918.11061-1-biao.huang@mediatek.com>
         <20211112093918.11061-5-biao.huang@mediatek.com>
         <1636724917.159298.2463374.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBSb2IsDQoNClRoZXJlIGlzIGEgcGF0Y2ggbmFtZWQgIltQQVRDSCB2MyAzLzddIGFybTY0
OiBkdHM6IG10MjcxMjogdXBkYXRlDQpldGhlcm5ldCBkZXZpY2Ugbm9kZSIgdG8gZml4IHRoZXNl
IHdhcm5pbmdzIGluIHRoaXMgc2VyaWVzLg0KDQpDb3VsZCB5b3UgZ2l2ZSBtZSBzb21lIGhpbnRz
IHdoeSB0aGVzZSB3YXJuaW5ncyBzdGlsbCB0aGVyZSwgb3IgaG93IHRvDQpmaXggdGhlbT8NCg0K
QmVzdCBSZWdhcmRzIQ0KDQpPbiBGcmksIDIwMjEtMTEtMTIgYXQgMDc6NDggLTA2MDAsIFJvYiBI
ZXJyaW5nIHdyb3RlOg0KPiBPbiBGcmksIDEyIE5vdiAyMDIxIDE3OjM5OjE1ICswODAwLCBCaWFv
IEh1YW5nIHdyb3RlOg0KPiA+IENvbnZlcnQgbWVkaWF0ZWstZHdtYWMgdG8gRFQgc2NoZW1hLCBh
bmQgZGVsZXRlIG9sZCBtZWRpYXRlay0NCj4gPiBkd21hYy50eHQuDQo+ID4gDQo+ID4gU2lnbmVk
LW9mZi1ieTogQmlhbyBIdWFuZyA8Ymlhby5odWFuZ0BtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+
ID4gIC4uLi9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstZHdtYWMudHh0ICAgICAgICAgICB8ICA5MSAt
LS0tLS0tLS0tDQo+ID4gIC4uLi9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstZHdtYWMueWFtbCAgICAg
ICAgICB8IDE1Nw0KPiA+ICsrKysrKysrKysrKysrKysrKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQs
IDE1NyBpbnNlcnRpb25zKCspLCA5MSBkZWxldGlvbnMoLSkNCj4gPiAgZGVsZXRlIG1vZGUgMTAw
NjQ0IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstDQo+ID4g
ZHdtYWMudHh0DQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvbmV0L21lZGlhdGVrLQ0KPiA+IGR3bWFjLnlhbWwNCj4gPiANCj4gDQo+IFJ1
bm5pbmcgJ21ha2UgZHRic19jaGVjaycgd2l0aCB0aGUgc2NoZW1hIGluIHRoaXMgcGF0Y2ggZ2l2
ZXMgdGhlDQo+IGZvbGxvd2luZyB3YXJuaW5ncy4gQ29uc2lkZXIgaWYgdGhleSBhcmUgZXhwZWN0
ZWQgb3IgdGhlIHNjaGVtYSBpcw0KPiBpbmNvcnJlY3QuIFRoZXNlIG1heSBub3QgYmUgbmV3IHdh
cm5pbmdzLg0KPiANCj4gTm90ZSB0aGF0IGl0IGlzIG5vdCB5ZXQgYSByZXF1aXJlbWVudCB0byBo
YXZlIDAgd2FybmluZ3MgZm9yDQo+IGR0YnNfY2hlY2suDQo+IFRoaXMgd2lsbCBjaGFuZ2UgaW4g
dGhlIGZ1dHVyZS4NCj4gDQo+IEZ1bGwgbG9nIGlzIGF2YWlsYWJsZSBoZXJlOiANCj4gaHR0cHM6
Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wYXRjaC8xNTU0MjI4DQo+IA0KPiANCj4gZXRoZXJuZXRA
MTEwMWMwMDA6IGNsb2NrLW5hbWVzOiBbJ2F4aScsICdhcGInLCAnbWFjX21haW4nLCAncHRwX3Jl
ZiddDQo+IGlzIHRvbyBzaG9ydA0KPiAJYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDI3
MTItZXZiLmR0LnlhbWwNCj4gDQo+IGV0aGVybmV0QDExMDFjMDAwOiBjbG9ja3M6IFtbMjcsIDM0
XSwgWzI3LCAzN10sIFs2LCAxNTRdLCBbNiwgMTU1XV0NCj4gaXMgdG9vIHNob3J0DQo+IAlhcmNo
L2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210MjcxMi1ldmIuZHQueWFtbA0KPiANCj4gZXRoZXJu
ZXRAMTEwMWMwMDA6IGNvbXBhdGlibGU6IFsnbWVkaWF0ZWssbXQyNzEyLWdtYWMnXSBkb2VzIG5v
dA0KPiBjb250YWluIGl0ZW1zIG1hdGNoaW5nIHRoZSBnaXZlbiBzY2hlbWENCj4gCWFyY2gvYXJt
NjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQyNzEyLWV2Yi5kdC55YW1sDQo+IA0KPiBldGhlcm5ldEAx
MTAxYzAwMDogY29tcGF0aWJsZTogJ29uZU9mJyBjb25kaXRpb25hbCBmYWlsZWQsIG9uZSBtdXN0
DQo+IGJlIGZpeGVkOg0KPiAJYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDI3MTItZXZi
LmR0LnlhbWwNCj4gDQo=

