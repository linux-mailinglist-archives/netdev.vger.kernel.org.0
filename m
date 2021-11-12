Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD1A44DFF0
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhKLBuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:50:32 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:37020 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231470AbhKLBuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 20:50:32 -0500
X-UUID: 90d1e70834bd4ed7bbc780b50d3b8901-20211112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=FsPSBY4kE9j2LqywphopQINupDGKsKOuuiiMQfxWJjs=;
        b=rTtWc29ZVadOEIJKiHfF8btthiJhwuWbag7WgmNWt8BvdCAwGu9fXE/2XW4PgLGG4MJ+pOFrrRrA1G5eK/O6Z9xow8ESXlodDltTfSLUp2+KA1p9kQpVaqYz/tcQNKKHY2OFBZ/RVxU2syqa3xh1x6cNor/T4IMuzhreZY/C6mw=;
X-UUID: 90d1e70834bd4ed7bbc780b50d3b8901-20211112
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1034506641; Fri, 12 Nov 2021 09:47:37 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 12 Nov 2021 09:47:37 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Nov 2021 09:47:36 +0800
Message-ID: <9df428e1f09fd25573eac78646d74699bd2c5712.camel@mediatek.com>
Subject: Re: [PATCH v2 4/5] dt-bindings: net: dwmac: Convert mediatek-dwmac
 to DT schema
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
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>
Date:   Fri, 12 Nov 2021 09:47:36 +0800
In-Reply-To: <4214b222-6c43-3132-bcfe-07c43d29f5f9@collabora.com>
References: <20211111071214.21027-1-biao.huang@mediatek.com>
         <20211111071214.21027-5-biao.huang@mediatek.com>
         <4214b222-6c43-3132-bcfe-07c43d29f5f9@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBBbmdlbG9HaW9hY2NoaW5vLA0KCVRoYW5rcyBmb3IgeW91ciBjb21tZW50c34NCg0KT24g
VGh1LCAyMDIxLTExLTExIGF0IDE0OjMwICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdu
byB3cm90ZToNCj4gSWwgMTEvMTEvMjEgMDg6MTIsIEJpYW8gSHVhbmcgaGEgc2NyaXR0bzoNCj4g
PiBDb252ZXJ0IG1lZGlhdGVrLWR3bWFjIHRvIERUIHNjaGVtYSwgYW5kIGRlbGV0ZSBvbGQgbWVk
aWF0ZWstDQo+ID4gZHdtYWMudHh0Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpYW8gSHVh
bmcgPGJpYW8uaHVhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICAgLi4uL2JpbmRpbmdz
L25ldC9tZWRpYXRlay1kd21hYy50eHQgICAgICAgICAgIHwgIDkxIC0tLS0tLS0tDQo+ID4gICAu
Li4vYmluZGluZ3MvbmV0L21lZGlhdGVrLWR3bWFjLnlhbWwgICAgICAgICAgfCAyMTENCj4gPiAr
KysrKysrKysrKysrKysrKysNCj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgMjExIGluc2VydGlvbnMo
KyksIDkxIGRlbGV0aW9ucygtKQ0KPiA+ICAgZGVsZXRlIG1vZGUgMTAwNjQ0DQo+ID4gRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRlay1kd21hYy50eHQNCj4gPiAg
IGNyZWF0ZSBtb2RlIDEwMDY0NA0KPiA+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvbWVkaWF0ZWstZHdtYWMueWFtbA0KPiA+IA0KPiANCj4gVGhhbmtzIGZvciB0aGUgRFQg
c2NoZW1hIGNvbnZlcnNpb24hDQo+IA0KPiBBbnl3YXksIHlvdSBzaG91bGQgc3BsaXQgdGhpcyBp
biB0d28gY29tbWl0czogaW4gdGhlIGZpcnN0IG9uZSwgeW91DQo+IGNvbnZlcnQgdGhlDQo+IHR4
dCBkb2N1bWVudGF0aW9uIHRvIHNjaGVtYSwgYXMgaXQgaXMuLi4gYW5kIGluIHRoZSBzZWNvbmQg
b25lLCB5b3UNCj4gYWRkIG10ODE5NQ0KPiBiaW5kaW5ncy4NCk9LLCBJJ2xsIHNwbGl0IGl0IGlu
IG5leHQgc2VuZC4NCg==

