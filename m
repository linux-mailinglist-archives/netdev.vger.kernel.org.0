Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0918460C70
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 02:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbhK2Bvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 20:51:53 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:37280 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S238572AbhK2Btw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 20:49:52 -0500
X-UUID: 7504e7f034de4da189b34954e687bfe6-20211129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=UuTnIeAjwYA5dUirlDhuBq9UUSsnxYbAfHAqvOTbTpA=;
        b=I2oQAZ1pNpftqI/YHBXqWOkrXkxevQHfZJhpddfyAdJblNPZeDpdpNMlPRCty2Emh0cDDmUqF1ssdkMyFsIq+COoV6+1ozT4bHPW4WIsdvsI8mZZzm/tr9JcCGYzgzyTmSslAs2c9BpR1oSYrUix9hJbJwNlyq76A3tClloL6bE=;
X-UUID: 7504e7f034de4da189b34954e687bfe6-20211129
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 78232290; Mon, 29 Nov 2021 09:46:32 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Mon, 29 Nov 2021 09:46:31 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Nov 2021 09:46:30 +0800
Message-ID: <833463899b37856804b45521adf1b335368f8286.camel@mediatek.com>
Subject: Re: [PATCH v3 4/7] net-next: dt-bindings: dwmac: Convert
 mediatek-dwmac to DT schema
From:   Biao Huang <biao.huang@mediatek.com>
To:     Rob Herring <robh@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>, <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
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
Date:   Mon, 29 Nov 2021 09:46:30 +0800
In-Reply-To: <YaQXdaXzJ3LD7ab2@robh.at.kernel.org>
References: <20211112093918.11061-1-biao.huang@mediatek.com>
         <20211112093918.11061-5-biao.huang@mediatek.com>
         <04051f18-a955-9397-d94e-0c61fc8f595b@gmail.com>
         <5f6fec21ef9f2bca6007283b37e35301cfe745ed.camel@mediatek.com>
         <YaQXdaXzJ3LD7ab2@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBSb2IsDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzfg0KDQpPbiBTdW4sIDIwMjEtMTEt
MjggYXQgMTc6NTcgLTA2MDAsIFJvYiBIZXJyaW5nIHdyb3RlOg0KPiBPbiBUaHUsIE5vdiAxOCwg
MjAyMSBhdCAxMTowOTo1NUFNICswODAwLCBCaWFvIEh1YW5nIHdyb3RlOg0KPiA+IERlYXIgTWF0
dGhpYXMsDQo+ID4gCUFncmVlLCBjb252ZXJ0aW5nIGFuZCBjaGFuZ2VzIHNob3VsZCBiZSBzZXBl
cmF0ZWQuDQo+ID4gDQo+ID4gCVRoZXJlIGFyZSBzb21lIGNoYW5nZXMgaW4gdGhlIGRyaXZlciwg
YnV0IG1lZGlhdGVrLWR3bWFjLnR4dA0KPiA+IAkNCj4gPiBpcyBub3QgdXBkYXRlZCBmb3IgYSBs
b25nIHRpbWUsIGFuZCBpcyBub3QgYWNjdXJhdGUgZW5vdWdoLg0KPiA+IA0KPiA+IAlTbyB0aGlz
IHBhdGNoIGlzIG1vcmUgbGlrZSBhIG5ldyB5YW1sIHJlcGxhY2UgdGhlIG9sZCB0eHQsDQo+ID4g
CXRoYW4gYSB3b3JkLXRvLXdvcmQgY29udmVydGluZy4NCj4gPiANCj4gPiAJDQo+ID4gQW55d2F5
LCBvbmx5IDMgbGl0dGxlIGNoYW5nZXMgY29tcGFyZSB0byBvbGQgbWVkaWF0ZS1kd21hYy50eHQs
IAkNCj4gPiBvdGhlcnMNCj4gPiBhbG1vc3Qga2VlcCB0aGUgc2FtZToNCj4gPiAJMS4gY29tcGF0
aWJsZSAiIGNvbnN0OiBzbnBzLGR3bWFjLTQuMjAiDQo+ID4gCTIuIGRlbGV0ZSAic25wcyxyZXNl
dC1hY3RpdmUtbG93OyIgaW4gZXhhbXBsZSwgc2luY2UgZHJpdmVyDQo+ID4gcmVtb3ZlIHRoaXMg
cHJvcGVydHkgbG9uZyBhZ28uDQo+ID4gCTMuIGFkZCAic25wcyxyZXNldC1kZWxheXMtdXMgPSA8
MCAxMDAwMCAxMDAwMD47IiBpbiBleGFtcGxlLCANCj4gPiANCj4gPiAJU2hvdWxkIEkgc3BsaXQg
dGhpcyBwYXRjaD8gDQo+ID4gCUlmIHllcywgSSdsbCBzcGxpdCBpbiBuZXh0IHNlbmQuDQo+ID4g
CVRoYW5rcy4NCj4gDQo+IEl0J3MgZmluZSB3aXRoIG9uZSBwYXRjaCwgYnV0IGRlc2NyaWJlIHRo
ZSBjaGFuZ2VzIGluIHRoZSBjb21taXQgbXNnLg0KPiANCj4gUm9iDQo+IA0KT0ssIEknbGwgYWRk
IHRoZSBjaGFuZ2VzIGluIHRoZSBjb21taXQgbWVzc2FnZSBpbiBuZXh0IHNlbmQuDQpUaGFua3N+
DQo=

