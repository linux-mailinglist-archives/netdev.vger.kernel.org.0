Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B53231E1A3
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhBQVvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:51:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232860AbhBQVus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 16:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9BC8964E76;
        Wed, 17 Feb 2021 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613598607;
        bh=BPsVruj+EBKYusbH1p1XsEXCkdB8TgSkbQ0JC3oQrHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rkSxMJopVx5XuzT29baMUwm0BLsEhKzCPLBB19IhWcqynsGlP6b3U6sUwE86G0epQ
         Z8Pv6nPtytK7wDTzsxyo1oYajdwBJmpgxc5i64+ocX3zXmaUb3uHhF8YRs4Yr9h38O
         ux95lTn4dnqMIxwUcEDyHRYE+u9g5b1tLpHsAZWbAMoRDtN65iN4iyDTdOJ/QBcg1o
         fX4uOBwYsfgmJ7ulgLY5QuCsSpdraMzEfMlfExnWfDmpvhzUJJ6pvBqT7RQqcAY4o+
         nqlZ5jmXlon5V9rAs3NS7s5EJETwYAygMgHbWVfUpwHR5LwK/l26/cXz5lm95T2At3
         qfGp9cJLmdu7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8C9C260A21;
        Wed, 17 Feb 2021 21:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] dwmac-sun8i cleanup and shutdown hook
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161359860757.12189.16500274582240019154.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Feb 2021 21:50:07 +0000
References: <20210217042006.54559-1-samuel@sholland.org>
In-Reply-To: <20210217042006.54559-1-samuel@sholland.org>
To:     Samuel Holland <samuel@sholland.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mripard@kernel.org, wens@csie.org, jernej.skrabec@siol.net,
        clabbe@baylibre.com, megous@megous.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 22:20:01 -0600 you wrote:
> These patches clean up some things I noticed while fixing suspend/resume
> behavior. The first four are minor code improvements. The last one adds
> a shutdown hook to minimize power consumption on boards without a PMIC.
> 
> Changes v1 to v2:
>   - Note the assumption of exclusive reset controller access in patch 3
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net: stmmac: dwmac-sun8i: Return void from PHY unpower
    https://git.kernel.org/netdev/net-next/c/557ef2dfb586
  - [net-next,v2,2/5] net: stmmac: dwmac-sun8i: Remove unnecessary PHY power check
    https://git.kernel.org/netdev/net-next/c/afac1d34bfb4
  - [net-next,v2,3/5] net: stmmac: dwmac-sun8i: Use reset_control_reset
    https://git.kernel.org/netdev/net-next/c/1c22f54696be
  - [net-next,v2,4/5] net: stmmac: dwmac-sun8i: Minor probe function cleanup
    https://git.kernel.org/netdev/net-next/c/2743aa245038
  - [net-next,v2,5/5] net: stmmac: dwmac-sun8i: Add a shutdown callback
    https://git.kernel.org/netdev/net-next/c/96be41d74f2e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


