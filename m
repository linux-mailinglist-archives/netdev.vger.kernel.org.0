Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C498469D17
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 16:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355302AbhLFP2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 10:28:08 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52014 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385676AbhLFPZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 10:25:37 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id D414B1F448BD
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1638804126; bh=ux40/LC0D3LdxvH8CUOyRevnqGZQpDWpUZPhHgMMiiU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=UNGhVTAxhT2aSUwjSANNqykn4+1GineOgwgoSHquBuYDW5iqjva5ToheZb47waOxk
         Tqd5NtT2NhHBAMAWoWhwRMERBN//nwuuewSMD2V6f/EOHffUZs43Bt9yBsGCgrDTYW
         w4Hh0SOKRfML6f5wtAIf7bOgE30QvCGVKpfxt87xifBuc14jj7GVMef9YCNWjhtFhh
         xp3nr5bizuUgCUlK69CNW595ZkFNsOUO/uqNbEQoax+qtsX1vkCPaMY8fz8PyZHhzH
         C46q+hPllY0i1z8AeleH1/vQh7mB2Rcrt5YFEg5wm6gSaG1aDiiClYMGlvcayEuykv
         /guBZe13EOy2w==
Subject: Re: [PATCH v4 5/7] net-next: stmmac: dwmac-mediatek: add support for
 mt8195
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
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com,
        dkirjanov@suse.de
References: <20211203063418.14892-1-biao.huang@mediatek.com>
 <20211203063418.14892-6-biao.huang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Message-ID: <0efc7cfd-f048-3c69-0ef3-5904c245f914@collabora.com>
Date:   Mon, 6 Dec 2021 16:22:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211203063418.14892-6-biao.huang@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 03/12/21 07:34, Biao Huang ha scritto:
> Add Ethernet support for MediaTek SoCs from the mt8195 family.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>

Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
