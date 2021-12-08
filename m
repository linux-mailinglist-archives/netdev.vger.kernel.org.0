Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B9E46CBF3
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbhLHEIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:08:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45954 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244117AbhLHEI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:08:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3838B81F5C;
        Wed,  8 Dec 2021 04:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF090C00446;
        Wed,  8 Dec 2021 04:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638936292;
        bh=1r558GTEUAd1QgB8UN7qYm8RGcn1C0as6rGvCpBhBdg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c01kKm4/EQD7+IVBOaAq4j4UcZQ8YLSq5USj5LOyOi9aX3+mCathluYcIjJ6SABi9
         g6J0suXdmg7hRkpTD9nD0lhFCoZ9yuz+Zha87gSo0B81XoZ5LO2IcTmUehjajCNvuc
         gWt2m4OLGEn4G+74hnr4wyEQsmZFGPgbqs+BzyXw+cYqOnnDz2TV5GBHl/eUIEKH0w
         ZnrENM1w3kmAGUmCml5MsV3rywh3o9w0nWgWiDRJzkVXkx4/Cj2N/skV24SooOyIGW
         vkgg4brNMcg56vFmOwqGqJSy8a5uKsKViW1Bz5YusbPYnG2t6+OaJWJFmi9JoUMoEz
         F8gDOIWeoA5Xw==
Date:   Tue, 7 Dec 2021 20:04:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
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
Subject: Re: [PATCH net-next v6 5/6] stmmac: dwmac-mediatek: add support for
 mt8195
Message-ID: <20211207200450.093f94a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208030354.31877-6-biao.huang@mediatek.com>
References: <20211208030354.31877-1-biao.huang@mediatek.com>
        <20211208030354.31877-6-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 11:03:53 +0800 Biao Huang wrote:
> Add Ethernet support for MediaTek SoCs from the mt8195 family.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:439:3: warning: variable 'gtxc_delay_val' is uninitialized when used here [-Wuninitialized]
                gtxc_delay_val |= FIELD_PREP(MT8195_DLY_GTXC_ENABLE, !!mac_delay->tx_delay);
                ^~~~~~~~~~~~~~
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:369:20: note: initialize the variable 'gtxc_delay_val' to silence this warning
        u32 gtxc_delay_val, delay_val = 0, rmii_delay_val = 0;
                          ^
                           = 0
1 warning generated.
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:439:3: warning: variable 'gtxc_delay_val' is uninitialized when used here [-Wuninitialized]
                gtxc_delay_val |= FIELD_PREP(MT8195_DLY_GTXC_ENABLE, !!mac_delay->tx_delay);
                ^~~~~~~~~~~~~~
drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c:369:20: note: initialize the variable 'gtxc_delay_val' to silence this warning
        u32 gtxc_delay_val, delay_val = 0, rmii_delay_val = 0;
                          ^
                           = 0
