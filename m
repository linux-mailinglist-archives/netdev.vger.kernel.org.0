Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806EE440772
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 06:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhJ3Ecj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 00:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231683AbhJ3Eci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 00:32:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9A20A60FC3;
        Sat, 30 Oct 2021 04:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635568208;
        bh=MDX3pkLIBG9fp1ekrHVU3y3Y7ugRJK6r2YntCpk+G7c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IGIfaGNheSfVfuFijssc5CEb06Aur9JGOxoHRy/oRJG9cpTdUgHX/2XO2fK1GwZs9
         9X97SgJu3CvvIloVoSU9FX1g2MqJRcl2P1tibXofNk/qRb/5DBm+BvydOrqUQWVuON
         TE7xeOkLzqbUR9QxJpvY2J1FkJvvsyEOQAn/lXfBp/jxfhjLE6B2BNEVdZTbea46vY
         el5Sfq5ZVW3lh5qkhovttYJrN2/w+n2R970XyLjoWxNHWI6hUBea/UHo2CLdhiMvzv
         jkgVuPWTOJQqmSs0nqZdAZngaz43AQO7SXHFaNGvW80yabWmR6YTCdpZH4Bd7HvC6K
         dz9+03k7WRHlw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8516C60AA4;
        Sat, 30 Oct 2021 04:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-10-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163556820853.7002.8683509351173768268.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Oct 2021 04:30:08 +0000
References: <20211029164641.2714265-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211029164641.2714265-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 29 Oct 2021 09:46:38 -0700 you wrote:
> This series contains updates to i40e, ice, igb, and ixgbevf drivers.
> 
> Yang Li simplifies return statements of bool values for i40e and ice.
> 
> Jan Kundrát corrects problems with I2C bit-banging for igb.
> 
> Colin Ian King removes unneeded variable initialization for ixgbevf.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] intel: Simplify bool conversion
    https://git.kernel.org/netdev/net-next/c/3c6f3ae3bb2e
  - [net-next,v2,2/3] igb: unbreak I2C bit-banging on i350
    https://git.kernel.org/netdev/net-next/c/a97f8783a937
  - [net-next,v2,3/3] net: ixgbevf: Remove redundant initialization of variable ret_val
    https://git.kernel.org/netdev/net-next/c/1b9abade3e75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


