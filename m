Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF6F33E104
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCPWAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:00:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230035AbhCPWAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8916364F80;
        Tue, 16 Mar 2021 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615932008;
        bh=dlBQQyI1j3pwN3CF6A6vVYRFLIMHHnkb3VOr9qpV3qs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LCD/XLrRtuj2GXQhkMi4DO5IRg68owDwT/yL388Vo6Pd8ML3/0zO1WZjxd7g4Mel6
         tmDqh4Z60bpdWGHDwRvDBTmmOsAfYpQUtb2+I6wPTzE8P8ev1rAFg5hPE4P9Kr6rud
         alPlpObOIR3U4Vqey3P6y3bHjWkf1HqYfXmqG84AG2YRrTYmxFPhukXC8co4Szws6I
         w3Vjkfu0iFsSPNM3SJXNLubzWV6r4mBWb6X3PPJOW2025VlkNAbX7cYA4a2tZsfjRR
         f08sgOgaLaey7UGshibmfbf7V2L0pkibGhmNFjyc3FoJCobj14u91t6Hw3x+vR5il7
         VvwT/RFXs+keQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A13660A60;
        Tue, 16 Mar 2021 22:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net: bridge: mcast: simplify allow/block EHT
 code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593200849.27352.15966391219237051428.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:00:08 +0000
References: <20210315171342.232809-1-razor@blackwall.org>
In-Reply-To: <20210315171342.232809-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 19:13:40 +0200 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> The set does two minor cleanups of the EHT allow/block handling code:
> patch 01 removes code which is unreachable (it was used in initial EHT
> versions, but isn't anymore) and prepares the allow/block functions to be
> factored out. Patch 02 factors out common allow/block handling code.
> There are no functional changes.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: bridge: mcast: remove unreachable EHT code
    https://git.kernel.org/netdev/net-next/c/6aa2c371c729
  - [net-next,v2,2/2] net: bridge: mcast: factor out common allow/block EHT handling
    https://git.kernel.org/netdev/net-next/c/e09cf582059e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


