Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34223386D39
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344133AbhEQWvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237058AbhEQWv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 18:51:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A40161244;
        Mon, 17 May 2021 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621291811;
        bh=SiPzTsIqJmGUCqbaAmc3M2Z1x9Mwcu3ibWitf4T1ldA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WFLJDhmx5geOwnIh9qeL/X6f9CcAgfG/BARGyvIYCjt6gwfVM35ycW6nGVvHj5nKx
         xt/TO/4fJ/edgQejZSgLXC5dsW1tr9Gk8VVT8HPhRVhEL50x1QJvXgI93aNwHeh+Ku
         SLq2nWdP61lycH1iGwLc4W1xHEMjbDmZLIa8KNpbSc813F4vWFdEoDpw9gOg03hRuP
         DGxvF2Lw964Y/ROKpP3FBWKcZ7i8z9XkUJtCrt5FAjQFWnCIc6L5GtooJUUPHsW4IE
         V0RyXRHfl2nq4Z7gMjGeCleL0bzZBdkAkyOpJxXcmo6rGVFlmb1JLum086v/I3EVS2
         DeALc6ATvvyww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2F6CB60A35;
        Mon, 17 May 2021 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/4] net: stmmac: RK3568
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129181118.15707.9043302436761903769.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 22:50:11 +0000
References: <20210517154037.37946-1-ezequiel@collabora.com>
In-Reply-To: <20210517154037.37946-1-ezequiel@collabora.com>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, joabreu@synopsys.com, heiko@sntech.de,
        davem@davemloft.net, kuba@kernel.org, pgwipeout@gmail.com,
        kever.yang@rock-chips.com, david.wu@rock-chips.com,
        robh+dt@kernel.org, jbx6244@gmail.com, wens213@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 17 May 2021 12:40:33 -0300 you wrote:
> Here's the third version of this patchset, taking
> the feedback from Heiko and Chen-Yu Tsai.
> 
> Although this solution is a tad ugly as it hardcodes
> the register addresses, we believe it's the most robust approach.
> 
> See:
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/4] net: stmmac: Don't set has_gmac if has_gmac4 is set
    https://git.kernel.org/netdev/net-next/c/d6b0625163a8
  - [v3,net-next,2/4] net: stmmac: dwmac-rk: Check platform-specific ops
    https://git.kernel.org/netdev/net-next/c/37c80d15ff4b
  - [v3,net-next,3/4] dt-bindings: net: rockchip-dwmac: add rk3568 compatible string
    https://git.kernel.org/netdev/net-next/c/f9da1c9d7fb5
  - [v3,net-next,4/4] net: stmmac: Add RK3566/RK3568 SoC support
    https://git.kernel.org/netdev/net-next/c/3bb3d6b1c195

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


