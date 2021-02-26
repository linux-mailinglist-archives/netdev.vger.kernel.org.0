Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FE0326A75
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBZXky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhBZXkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E099064EF0;
        Fri, 26 Feb 2021 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614382808;
        bh=xCvjUBc5VUij8jonxtwZB3XDWm4jaT87HNwDr6hvw2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IT6HKtS97fVmmD0LBovxU+lmukJkrIQIQWkwa96zFWWG9X0k4x5tB+omYEuLRVvTH
         QCzPwCboBh/PP2l8hlWsl45J5o7ajgJl8aKuCiLnSzX70wGTZ6Hvu0NnFF5a9SNI9U
         OPE2piJpvK7MITUN3Viqz06hj0vPWNo+YeZEm+9jQNBYxhdnlmu0R/Qoxta5K2I/XI
         P/UcNr7ZQ37jCRyH29VE9e3/e5oBXffVDal/nJkcPbHbVbzwVlE6WP5gVuibG9eJKL
         9A1IL/7ECro9tJP827Vcrs4S+MpC4HzNeFANwrUfzwthcpl7J0WrYVC1C+ZqcQ/CU5
         Y+CYJdg6gHUXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D23B860A16;
        Fri, 26 Feb 2021 23:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V5 net 0/5] ethernet: fixes for stmmac driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161438280885.26339.4460672214202838280.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Feb 2021 23:40:08 +0000
References: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Feb 2021 17:01:09 +0800 you wrote:
> Fixes for stmmac driver.
> 
> ---
> ChangeLogs:
> V1->V2:
> 	* subject prefix: ethernet: stmmac: -> net: stmmac:
> 	* use dma_addr_t instead of unsigned int for physical address
> 	* use cpu_to_le32()
> V2->V3:
> 	* fix the build issue pointed out by kbuild bot.
> 	* add error handling for stmmac_reinit_rx_buffers() function.
> V3->V4:
> 	* remove patch (net: stmmac: remove redundant null check for ptp clock),
> 	  reviewer thinks it should target net-next.
> V4->V5:
> 	* use %pad format to print dma_addr_t.
> 	* extend dwmac4_display_ring() to support all descriptor types.
> 	* while() -> do-while()
> 
> [...]

Here is the summary with links:
  - [V5,net,1/5] net: stmmac: stop each tx channel independently
    https://git.kernel.org/netdev/net/c/a3e860a83397
  - [V5,net,2/5] net: stmmac: fix watchdog timeout during suspend/resume stress test
    https://git.kernel.org/netdev/net/c/c511819d138d
  - [V5,net,3/5] net: stmmac: fix dma physical address of descriptor when display ring
    https://git.kernel.org/netdev/net/c/bfaf91ca848e
  - [V5,net,4/5] net: stmmac: fix wrongly set buffer2 valid when sph unsupport
    https://git.kernel.org/netdev/net/c/396e13e11577
  - [V5,net,5/5] net: stmmac: re-init rx buffers when mac resume back
    https://git.kernel.org/netdev/net/c/9c63faaa931e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


