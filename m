Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8E346E70D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbhLIKx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbhLIKx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 05:53:59 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60FDC0617A1;
        Thu,  9 Dec 2021 02:50:25 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id 4A65E1F4669E
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1639047023; bh=jpV2faF9STe0Dya2ebi8w8EQUm8n1ukAxXF7F9Yrrs8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AXOqV41vE8eCmDRtOEz3SChd6H81t0HFy6zOo3cyocR398C6rjX7ciwPGav50Aa/u
         RbvtaZancKo031NhFYGsCbV2Jr7OfdDylbPPamsyizxPEPThrtXluyl/XQtKvrgy+G
         W2dIIonE67L9TD7EC3p9Wns/UMK4TtBDpMHpJwom6Db6ySw60Mtol2ceEIafEhP+x5
         ms2ztLK1WEYz//gdYeCdHxvKw09r5erQ6yfR6VfGen0l4qN019ugn3axQuH9qtwJPP
         RW5OTS8I8wgl/kgbQqVq7Z6fWHzowFs2pB2NalPIN4i02bBH6vyeRG7oalc4wa2QZU
         r2bhthL8txXtw==
Subject: Re: [PATCH net-next v6 1/6] stmmac: dwmac-mediatek: add platform
 level clocks management
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
References: <20211208030354.31877-1-biao.huang@mediatek.com>
 <20211208030354.31877-2-biao.huang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Message-ID: <327a3c2f-505b-5b85-30f6-99556b96cfa5@collabora.com>
Date:   Thu, 9 Dec 2021 11:50:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211208030354.31877-2-biao.huang@mediatek.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 08/12/21 04:03, Biao Huang ha scritto:
> This patch implements clks_config callback for dwmac-mediatek platform,
> which could support platform level clocks management.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>

Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
