Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16B344D738
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbhKKNbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 08:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhKKNbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 08:31:35 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49061C0613F5;
        Thu, 11 Nov 2021 05:28:46 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id 557401F45C17
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1636637325; bh=hKlJPVIsd3zl1fRS+HP0UR+QSYciJS0/XcKJEC6ReGU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bt6bqF1fNP4inuT+/4OcgZZjROtLEbuwpi5Sb473NqCNEZ7q9PJoNl7vjPkEORvdZ
         pA6vwT0iSzB6cR+3DdoqueSaB4OOLHZW9cy3P/JT2azA1Ukcnp37fst7pVCL+OLDbe
         EY3XvRh7PywUblMcQ4V78VsFsqQsfBOGyibzME5KshpNZVHmQ3AsiDPHz9B1M9HEPf
         w/8nzQtjaOMBJC7o8yqgqoXnL4K3aDau+ZAvdyIMMfO1LZqE2JYqXZbLOBJZGYJwQl
         SUOlAem03Zfb2jQMZKyUliqnRRdwFAYpvOCHBLEx9WYeIael5rYClvZk1PEr6SFxUZ
         n5EX+fwU1LfhA==
Subject: Re: [PATCH v2 2/5] net: stmmac: dwmac-mediatek: Reuse more common
 features
To:     Biao Huang <biao.huang@mediatek.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com
References: <20211111071214.21027-1-biao.huang@mediatek.com>
 <20211111071214.21027-3-biao.huang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Message-ID: <71620d46-c9d5-07cc-befd-da838f0dcd1f@collabora.com>
Date:   Thu, 11 Nov 2021 14:28:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211111071214.21027-3-biao.huang@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 11/11/21 08:12, Biao Huang ha scritto:
> This patch makes dwmac-mediatek reuse more features
> supported by stmmac_platform.c.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>   .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 32 +++++++++----------
>   1 file changed, 15 insertions(+), 17 deletions(-)
> 

Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
