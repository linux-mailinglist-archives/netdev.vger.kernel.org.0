Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75CE3A7027
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbhFNUWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:22:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233356AbhFNUWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4FF5C61356;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623702006;
        bh=XOJ3V4TTGOTaNvJ/moAVHGooICyKoo2oFs2dvhRYbdo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dw/3WhgnC5kqsYSdedfqedS+a+v1Coo7MXZGGQwR0amcs6rDA0o3I60TljQW4r54Z
         AZJEpK/Zd7cFHxUSTDBKoIl1yznyAEFmperHBkJff+zDCP7BVXHHEi2DIViMKTN3Lc
         J2Uezqsc0UsFEcbr//WAvT39jeZ+QfuctvlFQdiexoJ/C91rM70McFFTTL8U0ufjPQ
         w25Ms7XPMwXxzzbkaWMES2rQ3W5LPtfTUQlPfDVsoYH0Bx2bk0rshmZKVOvDdb6olO
         i9gAWaXSeKB5MdARn9IAlh1WwaqZoCTqn/yfepFv9c9f5TB+WZt+4jZaI668owdsrN
         o5lQ8UEMTNfUg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4010060BE1;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/2] Add Ingenic SoCs MAC support.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370200625.25455.5879439335776203648.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 20:20:06 +0000
References: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com>
In-Reply-To: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com>
To:     =?utf-8?b?5ZGo55Cw5p2wIChaaG91IFlhbmppZSkgPHpob3V5YW5qaWVAd2FueWVldGVjaC5j?=@ci.codeaurora.org,
        =?utf-8?b?b20+?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com, alexandre.torgue@st.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 01:15:35 +0800 you wrote:
> v2->v3:
> 1.Add "ingenic,mac.yaml" for Ingenic SoCs.
> 2.Change tx clk delay and rx clk delay from hardware value to ps.
> 3.return -EINVAL when a unsupported value is encountered when
>   parsing the binding.
> 4.Simplify the code of the RGMII part of X2000 SoC according to
>   Andrew Lunn’s suggestion.
> 5.Follow the example of "dwmac-mediatek.c" to improve the code
>   that handles delays according to Andrew Lunn’s suggestion.
> 
> [...]

Here is the summary with links:
  - [v3,1/2] dt-bindings: dwmac: Add bindings for new Ingenic SoCs.
    https://git.kernel.org/netdev/net-next/c/3b8401066e5a
  - [v3,2/2] net: stmmac: Add Ingenic SoCs MAC support.
    https://git.kernel.org/netdev/net-next/c/2bb4b98b60d7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


