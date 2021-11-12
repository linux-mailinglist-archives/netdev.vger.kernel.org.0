Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983AF44DFAF
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 02:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhKLBZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 20:25:45 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:38292 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229952AbhKLBZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 20:25:45 -0500
X-UUID: 8d362d5021e548f182ca0bafda93cf03-20211112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=TtsxtXZ5jRLUQ4PRm4V/CvWh/SoHbjgXn3ntlYhdugA=;
        b=QZUULZPMPnjJkhdhSfGfPNNnGzIFxsVOpmfm75ZzlDf6w4r5upmSGRDJb+3u/+8ez+1zvTVHnvUkxLocUZbK3UVlidN7BX7fcR8al9WjXk1dbB23EIzer0rpBI4HwhS/beNF89lTmk9s8dm4SSZXsfUN56S1Yf95LohSs4ukYh0=;
X-UUID: 8d362d5021e548f182ca0bafda93cf03-20211112
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1707439807; Fri, 12 Nov 2021 09:22:49 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 12 Nov 2021 09:22:48 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Nov 2021 09:22:47 +0800
Message-ID: <52eeec07d0b909f652716e24ab360de353480484.camel@mediatek.com>
Subject: Re: [PATCH v2 0/5] MediaTek Ethernet Patches on MT8195
From:   Biao Huang <biao.huang@mediatek.com>
To:     Denis Kirjanov <dkirjanov@suse.de>, <davem@davemloft.net>,
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
Date:   Fri, 12 Nov 2021 09:22:47 +0800
In-Reply-To: <c2d3c746-ab32-eb99-0408-1409f43248cd@suse.de>
References: <20211111071214.21027-1-biao.huang@mediatek.com>
         <c2d3c746-ab32-eb99-0408-1409f43248cd@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBEZW5pcywNCglUaGFua3MgZm9yIHlvdXIgY29tbWVudHN+DQoNCk9uIFRodSwgMjAyMS0x
MS0xMSBhdCAxNDozNSArMDMwMCwgRGVuaXMgS2lyamFub3Ygd3JvdGU6DQo+IA0KPiAxMS8xMS8y
MSAxMDoxMiBBTSwgQmlhbyBIdWFuZyDQv9C40YjQtdGCOg0KPiA+IENoYW5nZXMgaW4gdjI6DQo+
ID4gMS4gZml4IGVycm9ycy93YXJuaW5ncyBpbiBtZWRpYXRlay1kd21hYy55YW1sIHdpdGggdXBn
cmFkZWQNCj4gPiBkdHNjaGVtYSB0b29scw0KPiA+IA0KPiA+IFRoaXMgc2VyaWVzIGluY2x1ZGUg
NSBwYXRjaGVzOg0KPiA+IDEuIGFkZCBwbGF0Zm9ybSBsZXZlbCBjbG9ja3MgbWFuYWdlbWVudCBm
b3IgZHdtYWMtbWVkaWF0ZWsNCj4gPiAyLiByZXN1ZSBtb3JlIGNvbW1vbiBmZWF0dXJlcyBkZWZp
bmVkIGluIHN0bW1hY19wbGF0Zm9ybS5jDQo+ID4gMy4gYWRkIGV0aGVybmV0IGVudHJ5IGZvciBt
dDgxOTUNCj4gPiA0LiBjb252ZXJ0IG1lZGlhdGVrLWR3bWFjLnR4dCB0byBtZWRpYXRlay1kd21h
Yy55YW1sDQo+ID4gNS4gYWRkIGV0aGVybmV0IGRldmljZSBub2RlIGZvciBtdDgxOTUNCj4gDQo+
IGFsbCBuZXcgZmVhdHVyZSBzaG91bGQgYmUgc2VudCBwcmVmaXhlZCB3aXRoIG5ldC1uZXh0DQpP
SywgSSdsbCBmaXggaXQgaW4gbmV4dCB2ZXJzaW9uLg0KPiA+IA0KPiA+IEJpYW8gSHVhbmcgKDUp
Og0KPiA+ICAgIG5ldDogc3RtbWFjOiBkd21hYy1tZWRpYXRlazogYWRkIHBsYXRmb3JtIGxldmVs
IGNsb2Nrcw0KPiA+IG1hbmFnZW1lbnQNCj4gPiAgICBuZXQ6IHN0bW1hYzogZHdtYWMtbWVkaWF0
ZWs6IFJldXNlIG1vcmUgY29tbW9uIGZlYXR1cmVzDQo+ID4gICAgbmV0OiBzdG1tYWM6IGR3bWFj
LW1lZGlhdGVrOiBhZGQgc3VwcG9ydCBmb3IgbXQ4MTk1DQo+ID4gICAgZHQtYmluZGluZ3M6IG5l
dDogZHdtYWM6IENvbnZlcnQgbWVkaWF0ZWstZHdtYWMgdG8gRFQgc2NoZW1hDQo+ID4gICAgYXJt
NjQ6IGR0czogbXQ4MTk1OiBhZGQgZXRoZXJuZXQgZGV2aWNlIG5vZGUNCj4gPiANCj4gPiAgIC4u
Li9iaW5kaW5ncy9uZXQvbWVkaWF0ZWstZHdtYWMudHh0ICAgICAgICAgICB8ICA5MSAtLS0tLQ0K
PiA+ICAgLi4uL2JpbmRpbmdzL25ldC9tZWRpYXRlay1kd21hYy55YW1sICAgICAgICAgIHwgMjEx
ICsrKysrKysrKysrKw0KPiA+ICAgYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDgxOTUt
ZXZiLmR0cyAgIHwgIDkyICsrKysrDQo+ID4gICBhcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVr
L210ODE5NS5kdHNpICAgICAgfCAgNzAgKysrKw0KPiA+ICAgLi4uL2V0aGVybmV0L3N0bWljcm8v
c3RtbWFjL2R3bWFjLW1lZGlhdGVrLmMgIHwgMzEzDQo+ID4gKysrKysrKysrKysrKysrKy0tDQo+
ID4gICA1IGZpbGVzIGNoYW5nZWQsIDY2NCBpbnNlcnRpb25zKCspLCAxMTMgZGVsZXRpb25zKC0p
DQo+ID4gICBkZWxldGUgbW9kZSAxMDA2NDQNCj4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvbmV0L21lZGlhdGVrLWR3bWFjLnR4dA0KPiA+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0
DQo+ID4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRlay1kd21h
Yy55YW1sDQo+ID4gDQo+ID4gLS0NCj4gPiAyLjE4LjANCj4gPiANCj4gPiANCg==

