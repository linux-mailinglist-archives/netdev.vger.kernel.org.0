Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919F644D73E
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhKKNdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 08:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhKKNdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 08:33:17 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BACC061766;
        Thu, 11 Nov 2021 05:30:28 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id 2763C1F45C19
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1636637426; bh=Q3uCANzvE9+cRG6QMf3K+KvzdaN3OYug4xiZOrBZ+iM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=rZzbQShwGj5gN7VirvGPcA6smFvOgJNJVxSZ/0tDPh9PcbO0sUcLPRcA7VYW4ImPS
         GhLtFxP2CKI2VHngQb15P/IdUO5b8lYSRD6m1vWcP7BI2axvDlU6Bu70t6OXMKGhR6
         7Ej4t7rl/haFWR2eEkl+oaO+836qD68UZNwafVYWKv4m3jpPTjEQe6mzpTPg9hs3sH
         sWb/3CorRa2b3Nako7IelthlBb+c632oUym8PYVP5MpuP+rAtIu+NBVz1aw3YzKcRq
         Pjz2+f4d3JzMSewpQvqJ0le+NkCaTlWURLnD0Of3JHjhH1pXrcc8eoEBI9xNiCobNs
         79pcEOuCWX4HA==
Subject: Re: [PATCH v2 4/5] dt-bindings: net: dwmac: Convert mediatek-dwmac to
 DT schema
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
 <20211111071214.21027-5-biao.huang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Message-ID: <4214b222-6c43-3132-bcfe-07c43d29f5f9@collabora.com>
Date:   Thu, 11 Nov 2021 14:30:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211111071214.21027-5-biao.huang@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 11/11/21 08:12, Biao Huang ha scritto:
> Convert mediatek-dwmac to DT schema, and delete old mediatek-dwmac.txt.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>   .../bindings/net/mediatek-dwmac.txt           |  91 --------
>   .../bindings/net/mediatek-dwmac.yaml          | 211 ++++++++++++++++++
>   2 files changed, 211 insertions(+), 91 deletions(-)
>   delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>   create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 

Thanks for the DT schema conversion!

Anyway, you should split this in two commits: in the first one, you convert the
txt documentation to schema, as it is... and in the second one, you add mt8195
bindings.
