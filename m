Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8258478206
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhLQB0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:26:12 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45624 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230033AbhLQB0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:26:12 -0500
X-UUID: 58ee2375bc88455bbc7c539db82efa5e-20211217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=cMKFGO50Nijrd/zf0SyWIymRa4cZ18pTctDEuNU+t50=;
        b=BQbQE8dhegxrx5xWHmhb4uiWxRp+otcMVObhgnwrTi15c7IaB9LU/SCee18HMcslmoyw79Hj9FiVmW1L4hrnnr599qX4gKjyliKeRWASQOFh7mXfP7GRNKYp7BYyTYoqzCF1zl5j6dnZ+MhpM+U+5XRXAyR7nUQqalJMKjwHCsw=;
X-UUID: 58ee2375bc88455bbc7c539db82efa5e-20211217
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 804381100; Fri, 17 Dec 2021 09:26:07 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 17 Dec 2021 09:26:06 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Dec 2021 09:26:05 +0800
Message-ID: <c231ad91abe639a200b9a18835280c9ca28c771a.camel@mediatek.com>
Subject: Re: [PATCH net-next v10 4/6] net: dt-bindings: dwmac: Convert
 mediatek-dwmac to DT schema
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
Date:   Fri, 17 Dec 2021 09:26:07 +0800
In-Reply-To: <Ybti2mNfEVNWQWgM@robh.at.kernel.org>
References: <20211216055328.15953-1-biao.huang@mediatek.com>
         <20211216055328.15953-5-biao.huang@mediatek.com>
         <Ybti2mNfEVNWQWgM@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBSb2IsDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzLg0KT24gVGh1LCAyMDIxLTEyLTE2
IGF0IDEwOjAxIC0wNjAwLCBSb2IgSGVycmluZyB3cm90ZToNCj4gT24gVGh1LCBEZWMgMTYsIDIw
MjEgYXQgMDE6NTM6MjZQTSArMDgwMCwgQmlhbyBIdWFuZyB3cm90ZToNCj4gPiBDb252ZXJ0IG1l
ZGlhdGVrLWR3bWFjIHRvIERUIHNjaGVtYSwgYW5kIGRlbGV0ZSBvbGQgbWVkaWF0ZWstDQo+ID4g
ZHdtYWMudHh0Lg0KPiA+IEFuZCB0aGVyZSBhcmUgc29tZSBjaGFuZ2VzIGluIC55YW1sIHRoYW4g
LnR4dCwgb3RoZXJzIGFsbW9zdCBrZWVwDQo+ID4gdGhlIHNhbWU6DQo+ID4gICAxLiBjb21wYXRp
YmxlICJjb25zdDogc25wcyxkd21hYy00LjIwIi4NCj4gPiAgIDIuIGRlbGV0ZSAic25wcyxyZXNl
dC1hY3RpdmUtbG93OyIgaW4gZXhhbXBsZSwgc2luY2UgZHJpdmVyDQo+ID4gcmVtb3ZlIHRoaXMN
Cj4gPiAgICAgIHByb3BlcnR5IGxvbmcgYWdvLg0KPiA+ICAgMy4gYWRkICJzbnBzLHJlc2V0LWRl
bGF5LXVzID0gPDAgMTAwMDAgMTAwMDA+IiBpbiBleGFtcGxlLg0KPiA+ICAgNC4gdGhlIGV4YW1w
bGUgaXMgZm9yIHJnbWlpIGludGVyZmFjZSwga2VlcCByZWxhdGVkIHByb3BlcnRpZXMNCj4gPiBv
bmx5Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpYW8gSHVhbmcgPGJpYW8uaHVhbmdAbWVk
aWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICAuLi4vYmluZGluZ3MvbmV0L21lZGlhdGVrLWR3bWFj
LnR4dCAgICAgICAgICAgfCAgOTEgLS0tLS0tLS0tLQ0KPiA+ICAuLi4vYmluZGluZ3MvbmV0L21l
ZGlhdGVrLWR3bWFjLnlhbWwgICAgICAgICAgfCAxNTUNCj4gPiArKysrKysrKysrKysrKysrKysN
Cj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxNTUgaW5zZXJ0aW9ucygrKSwgOTEgZGVsZXRpb25zKC0p
DQo+ID4gIGRlbGV0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbmV0L21lZGlhdGVrLQ0KPiA+IGR3bWFjLnR4dA0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQg
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZWRpYXRlay0NCj4gPiBkd21h
Yy55YW1sDQo+IA0KPiBSZXZpZXdlZC1ieTogUm9iIEhlcnJpbmcgPHJvYmhAa2VybmVsLm9yZz4N
CkknbGwgYWRkIHJldmlld2VkLWJ5IGluIG5leHQgc2VuZC4NClJlZ2FyZHMhDQo=

