Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1C746AFE9
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243265AbhLGBme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:42:34 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:42078 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S243145AbhLGBmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:42:33 -0500
X-UUID: bcadf9cb14034271b35f83d2687bc5fd-20211207
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=5TqzGfDJSklDX44XMBIA/ykNHsD+dGmD9/tWrIY+fjY=;
        b=PNQuW8hwaV3CPXj/ZdP36tj6CV04V+lESRQjva8hsXj07O3nP25vanoZB/Dv7tkgNVbQKRiGXreNt1IkAEpWBLk9OB6L0Mw1kAFLb1eFvsrVogq7UcVh4AqUF0mXuJ/xM12lS40OOFQdOfW/QNLzFmaqr9oDv7LvznA5wxy+j/8=;
X-UUID: bcadf9cb14034271b35f83d2687bc5fd-20211207
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1146748263; Tue, 07 Dec 2021 09:39:00 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 7 Dec 2021 09:38:59 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 7 Dec 2021 09:38:58 +0800
Message-ID: <d807b5784357ca7656b496b275ef87bf0e4b8100.camel@mediatek.com>
Subject: Re: [PATCH v4 5/7] net-next: stmmac: dwmac-mediatek: add support
 for mt8195
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
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <dkirjanov@suse.de>
Date:   Tue, 7 Dec 2021 09:38:58 +0800
In-Reply-To: <0efc7cfd-f048-3c69-0ef3-5904c245f914@collabora.com>
References: <20211203063418.14892-1-biao.huang@mediatek.com>
         <20211203063418.14892-6-biao.huang@mediatek.com>
         <0efc7cfd-f048-3c69-0ef3-5904c245f914@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBBbmdlbG8sDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzfg0KT24gTW9uLCAyMDIxLTEy
LTA2IGF0IDE2OjIyICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdubyB3cm90ZToNCj4g
SWwgMDMvMTIvMjEgMDc6MzQsIEJpYW8gSHVhbmcgaGEgc2NyaXR0bzoNCj4gPiBBZGQgRXRoZXJu
ZXQgc3VwcG9ydCBmb3IgTWVkaWFUZWsgU29DcyBmcm9tIHRoZSBtdDgxOTUgZmFtaWx5Lg0KPiA+
IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpYW8gSHVhbmcgPGJpYW8uaHVhbmdAbWVkaWF0ZWsuY29t
Pg0KPiANCj4gQWNrZWQtYnk6IEFuZ2Vsb0dpb2FjY2hpbm8gRGVsIFJlZ25vIDwNCj4gYW5nZWxv
Z2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29tPg0KSSdsbCBhZGQgaXQgaW4gbmV4dCBz
ZW5kLg0K

