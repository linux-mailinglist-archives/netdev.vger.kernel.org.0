Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8693A5088
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 22:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhFLUWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 16:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230186AbhFLUWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 16:22:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8404561164;
        Sat, 12 Jun 2021 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623529204;
        bh=DIQEqT0PkShpGezk6HpU8lrICEsMabhZy31CHwJWKk4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lfI2se7MJwBGXeSPcB+mQ2XBCdH8C/OhWp1ZLTepMDgxRHibaKhsPGgyOMa+yLYgB
         y1FkKHZbYW2ljk5QghjMYJwoF8zutSPjlX7t9SPCoVe+3hR0wwgS+COF+e9dJ8mExc
         3leWXNSsW3eO36CPLR4suPG03d3O3tY1/Zf3K52SMQ73t6x6/UlAFwnyXb0kXnETmb
         FFDrbxz/0nhfi8lxtQA7VOgr4k9B+8yeZlnbUn59pDParAw+l9zBzh01XVCXlmvmND
         BPNQDx5Gf4yNLhqAC+an6U9iIcS/iYWU2Lj0NOQ77+/xIPcA5irs+8mYn8jK1dKySI
         RXTtbLWAXWEgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 73221609E4;
        Sat, 12 Jun 2021 20:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] stmmac: intel: minor clean-up
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162352920446.6609.10045548501109238922.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Jun 2021 20:20:04 +0000
References: <20210611131609.1685105-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210611131609.1685105-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 21:16:07 +0800 you wrote:
> This patch series include two minor-cleanup patches:
> 
>   1. Move all the hardcoded DEFINEs to dwmac-intel header file.
>   2. Fix the wrong kernel-doc on the intel_eth_pci_remove() function.
> 
> Since the changes are minor, only basic sanity tests are done on a
> Intel TigerLake with Marvell88E2110 PHY:-
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] stmmac: intel: move definitions to dwmac-intel header file
    https://git.kernel.org/netdev/net-next/c/fb9349c4163e
  - [net-next,2/2] stmmac: intel: fix wrong kernel-doc
    https://git.kernel.org/netdev/net-next/c/3c3ea630e87c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


