Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60BF44E09D
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 04:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbhKLDEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 22:04:39 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:37526 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233920AbhKLDEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 22:04:39 -0500
X-UUID: df2fc82293ee4f5fb34c6c04b26d38c8-20211112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=VcNEpCuXHbGjzxYQZ8fWTghPoSSE5d5qJMlyOwvGVLU=;
        b=Apw+BjyOhwLGw7ZwzAGczT5WI1WK7v3KzXv4EClm9RxNj9CjqjsZpG78wy0DpzNC+ZY3hlyCnMR4jEpIZK1CD0W5rXn6V+4aFDhnVqkVPDC3DE55WzkYbGAWYjMLDwd9urkfz0Eu9PtEwG5/MLNMHnJrjWwOOliFTb6yUOZSA0w=;
X-UUID: df2fc82293ee4f5fb34c6c04b26d38c8-20211112
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1913137450; Fri, 12 Nov 2021 11:01:46 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 12 Nov 2021 11:01:45 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 12 Nov 2021 11:01:44 +0800
Message-ID: <1c762a13ee1c73142771c4b409d7d678240ace67.camel@mediatek.com>
Subject: Re: [PATCH v2 2/5] net: stmmac: dwmac-mediatek: Reuse more common
 features
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
Date:   Fri, 12 Nov 2021 11:01:44 +0800
In-Reply-To: <71620d46-c9d5-07cc-befd-da838f0dcd1f@collabora.com>
References: <20211111071214.21027-1-biao.huang@mediatek.com>
         <20211111071214.21027-3-biao.huang@mediatek.com>
         <71620d46-c9d5-07cc-befd-da838f0dcd1f@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBBbmdlbG8sDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzLg0KT24gVGh1LCAyMDIxLTEx
LTExIGF0IDE0OjI4ICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdubyB3cm90ZToNCj4g
SWwgMTEvMTEvMjEgMDg6MTIsIEJpYW8gSHVhbmcgaGEgc2NyaXR0bzoNCj4gPiBUaGlzIHBhdGNo
IG1ha2VzIGR3bWFjLW1lZGlhdGVrIHJldXNlIG1vcmUgZmVhdHVyZXMNCj4gPiBzdXBwb3J0ZWQg
Ynkgc3RtbWFjX3BsYXRmb3JtLmMuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQmlhbyBIdWFu
ZyA8Ymlhby5odWFuZ0BtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gICAuLi4vZXRoZXJuZXQv
c3RtaWNyby9zdG1tYWMvZHdtYWMtbWVkaWF0ZWsuYyAgfCAzMiArKysrKysrKystLS0tLQ0KPiA+
IC0tLS0tDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRp
b25zKC0pDQo+ID4gDQo+IA0KPiBBY2tlZC1ieTogQW5nZWxvR2lvYWNjaGlubyBEZWwgUmVnbm8g
PA0KPiBhbmdlbG9naW9hY2NoaW5vLmRlbHJlZ25vQGNvbGxhYm9yYS5jb20+DQpPSywgd2lsbCBh
ZGQgdGhpcyBpbmZvIGluIG5leHQgc2VuZC4NCg==

