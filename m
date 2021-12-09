Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA30546E714
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbhLIKzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbhLIKzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 05:55:11 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947D2C061746;
        Thu,  9 Dec 2021 02:51:38 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id A67C31F45FD3
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1639047097; bh=yDtQlqleMTCGJ2UJdUDxkZCymbk8Fpf4x8QbZvJtjOs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NfyMpnzCtqpvhQwzmB4pHOQ/YwSSqt2ZGRhy5odR+OMpvByMEo1sFwC7rvYMqXNxb
         BHbqzq3PPKvySzejU7kbkdqnLbMjv/neugoUxTCeRYNINPPkf0PZCrWtbPqeoCdtmy
         KIBqseVsM9zS8vRqEhFFYGlQlo7VR/p+cv4AGLhY7OWCFFKVSrlINkePNqeh1ZHzvK
         +mRznjk/whIyYvknMIE43vutB+79VGfcPzFiAgCWaL5uG8vpF87vRseRXr9F5QIO2S
         Uv2AtBjdef+t1+J1QWSew0jiHnXvq5kpsew+U+gaKhlb5iJzczdhUUEtMYC9g0vApI
         E2nuz88DdqksQ==
Subject: Re: [PATCH net-next v7 1/6] stmmac: dwmac-mediatek: add platform
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
References: <20211208054716.603-1-biao.huang@mediatek.com>
 <20211208054716.603-2-biao.huang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Message-ID: <2e8ccd43-bba0-9695-8d6d-d37e0b71fa7d@collabora.com>
Date:   Thu, 9 Dec 2021 11:51:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211208054716.603-2-biao.huang@mediatek.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 08/12/21 06:47, Biao Huang ha scritto:
> This patch implements clks_config callback for dwmac-mediatek platform,
> which could support platform level clocks management.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>

Sorry, I've sent my ack on v6. Sending it on v7.

Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
