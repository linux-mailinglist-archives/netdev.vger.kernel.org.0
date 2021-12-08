Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C870E46CD34
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbhLHFiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:38:07 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:60758 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231911AbhLHFiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:38:06 -0500
X-UUID: cf248f2ca8064c1ebb4fe1e09bec9971-20211208
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=cREHopv2I0vmXpVmvz4oR9TOg4BtDWc6c9ra60cPwdA=;
        b=on6EpM+AbDWjXT9jBYfizWJCj0ANlmQ2lRClcyvzjau6jLEswATkMDxC2n+Jf7eH/Hn8wFNaxc50vr5dX8Lrf297nDFRa3C5Qd1a9FV3ISNodXlBbTdJ8gy8GPRzWkCG4DBeeTDDIroPg6tDvqyLOBm6Ak72pvuDJdQXpcMjwKM=;
X-UUID: cf248f2ca8064c1ebb4fe1e09bec9971-20211208
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 736930027; Wed, 08 Dec 2021 13:34:29 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 8 Dec 2021 13:34:28 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Dec 2021 13:34:27 +0800
Message-ID: <9d559afc6ae7c5f85bff222aa0c326f3f3e46fcf.camel@mediatek.com>
Subject: Re: [PATCH net-next v6 5/6] stmmac: dwmac-mediatek: add support for
 mt8195
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
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
Date:   Wed, 8 Dec 2021 13:34:23 +0800
In-Reply-To: <20211207200450.093f94a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211208030354.31877-1-biao.huang@mediatek.com>
         <20211208030354.31877-6-biao.huang@mediatek.com>
         <20211207200450.093f94a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBKYWt1YiwNCglUaGFua3MgZm9yIHlvdXIgY29tbWVudHMuDQpPbiBUdWUsIDIwMjEtMTIt
MDcgYXQgMjA6MDQgLTA4MDAsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBXZWQsIDggRGVj
IDIwMjEgMTE6MDM6NTMgKzA4MDAgQmlhbyBIdWFuZyB3cm90ZToNCj4gPiBBZGQgRXRoZXJuZXQg
c3VwcG9ydCBmb3IgTWVkaWFUZWsgU29DcyBmcm9tIHRoZSBtdDgxOTUgZmFtaWx5Lg0KPiA+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IEJpYW8gSHVhbmcgPGJpYW8uaHVhbmdAbWVkaWF0ZWsuY29tPg0K
PiA+IEFja2VkLWJ5OiBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdubyA8DQo+ID4gYW5nZWxvZ2lv
YWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29tPg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJu
ZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsuYzo0Mzk6Mzogd2FybmluZzoNCj4gdmFy
aWFibGUgJ2d0eGNfZGVsYXlfdmFsJyBpcyB1bmluaXRpYWxpemVkIHdoZW4gdXNlZCBoZXJlIFst
DQo+IFd1bmluaXRpYWxpemVkXQ0KPiAgICAgICAgICAgICAgICAgZ3R4Y19kZWxheV92YWwgfD0g
RklFTERfUFJFUChNVDgxOTVfRExZX0dUWENfRU5BQkxFLA0KPiAhIW1hY19kZWxheS0+dHhfZGVs
YXkpOw0KPiAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn4NCj4gZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsuYzozNjk6MjA6IG5vdGU6DQo+IGlu
aXRpYWxpemUgdGhlIHZhcmlhYmxlICdndHhjX2RlbGF5X3ZhbCcgdG8gc2lsZW5jZSB0aGlzIHdh
cm5pbmcNCj4gICAgICAgICB1MzIgZ3R4Y19kZWxheV92YWwsIGRlbGF5X3ZhbCA9IDAsIHJtaWlf
ZGVsYXlfdmFsID0gMDsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICBeDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgID0gMA0KPiAxIHdhcm5pbmcgZ2VuZXJhdGVkLg0KPiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYy1tZWRpYXRlay5jOjQzOTozOiB3YXJu
aW5nOg0KPiB2YXJpYWJsZSAnZ3R4Y19kZWxheV92YWwnIGlzIHVuaW5pdGlhbGl6ZWQgd2hlbiB1
c2VkIGhlcmUgWy0NCj4gV3VuaW5pdGlhbGl6ZWRdDQo+ICAgICAgICAgICAgICAgICBndHhjX2Rl
bGF5X3ZhbCB8PSBGSUVMRF9QUkVQKE1UODE5NV9ETFlfR1RYQ19FTkFCTEUsDQo+ICEhbWFjX2Rl
bGF5LT50eF9kZWxheSk7DQo+ICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fg0KPiBkcml2
ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYy1tZWRpYXRlay5jOjM2OToyMDog
bm90ZToNCj4gaW5pdGlhbGl6ZSB0aGUgdmFyaWFibGUgJ2d0eGNfZGVsYXlfdmFsJyB0byBzaWxl
bmNlIHRoaXMgd2FybmluZw0KPiAgICAgICAgIHUzMiBndHhjX2RlbGF5X3ZhbCwgZGVsYXlfdmFs
ID0gMCwgcm1paV9kZWxheV92YWwgPSAwOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgIF4N
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAwDQpJJ2xsIGZpeCB0aGUgdW5pbml0aWFs
aXplZCB3YXJuaW5nIGluIG5leHQgc2VuZC4NCg==

