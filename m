Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5E53E3430
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 10:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhHGIu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 04:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231558AbhHGIuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Aug 2021 04:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2777B60EC0;
        Sat,  7 Aug 2021 08:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628326207;
        bh=L03Kf59/VG57iU49qSzYSwXV02Uek8uVwPIGgByYm8Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DXy0hgpBuabZhcZziSBIvvEk+2Iu8Y0q9LCl7kLAIgCeXesyKkbPlPyWwC/krgHqo
         h+WYVwaHSSGDFos/QslVBKrlXGu+exFMAedKLupGObbI5XD0j0C560//WCT3qflbCr
         3LN16IeQfGqzCVhFGI4oJckAXwdBh0c8zY/MvN/LaT2AAG6puKiYKwSuu+v5CxTux8
         yeNsuFH/XSgy2pDRWJnLsuyvHMuyv1jeoNigDJkxb+U8S1lfldkPT2dpKeKRzFrufW
         FOpw+NIYuaK/Lkq0dQk+UATlTBhh+LLcRm0WAiq5h0QDH4T4fYB1e5azEhQ7dUR3Uq
         LUMBkLVkH51Dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0EFDE609F1;
        Sat,  7 Aug 2021 08:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: stmmac: Do not use unreachable() in
 ipq806x_gmac_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162832620705.3915.11584546852979312079.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Aug 2021 08:50:07 +0000
References: <20210806191339.576318-1-nathan@kernel.org>
In-Reply-To: <20210806191339.576318-1-nathan@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, samitolvanen@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  6 Aug 2021 12:13:40 -0700 you wrote:
> When compiling with clang in certain configurations, an objtool warning
> appears:
> 
> drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.o: warning: objtool:
> ipq806x_gmac_probe() falls through to next function phy_modes()
> 
> This happens because the unreachable annotation in the third switch
> statement is not eliminated. The compiler should know that the first
> default case would prevent the second and third from being reached as
> the comment notes but sanitizer options can make it harder for the
> compiler to reason this out.
> 
> [...]

Here is the summary with links:
  - net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()
    https://git.kernel.org/netdev/net-next/c/4367355dd909

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


