Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC0E367229
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245117AbhDUSAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235658AbhDUSAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 14:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 91E5161428;
        Wed, 21 Apr 2021 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619028009;
        bh=tiMyA8uflJsNUltyx2Mx3G9j+bLWDuEnLCalQhQEUk4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XHPVoz9VqaBLJ0eKMzyI9cjNF7yWlm1h1H0l0bK34yMTSDQalYc2nCmpkUFCFAm1z
         stq41NXBSJNtybG57XWHCHwS/a3mJv8dvl30gGYKeiZccg9G0tAQyvXNQV79Y+nnvt
         uLIjHEhl3zWJnkX9+N5t9GEjg3uBGzJ+bIopxch6hzf20V0H2Edc0cWJinW5IWn81I
         iP1U9//STJxFYsYe1XX3rga0QaT9Pgi0opx3U1Cz9utIVpB/vbEIeCOrYqA3w98MFN
         a+lHZBKlEWWRofaJn+ZKMnO3wp5xMhPgTauyDz9ANsugjbUlS6J/XnU155UeXk3mLJ
         uMe2InCkaWx6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 85D4E60A2A;
        Wed, 21 Apr 2021 18:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: stmmac: fix TSO and TBS feature enabling during
 driver open
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902800954.24373.14896291622755574691.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 18:00:09 +0000
References: <20210421091149.5035-1-boon.leong.ong@intel.com>
In-Reply-To: <20210421091149.5035-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Apr 2021 17:11:49 +0800 you wrote:
> TSO and TBS cannot co-exist and current implementation requires two
> fixes:
> 
>  1) stmmac_open() does not need to call stmmac_enable_tbs() because
>     the MAC is reset in stmmac_init_dma_engine() anyway.
>  2) Inside stmmac_hw_setup(), we should call stmmac_enable_tso() for
>     TX Q that is _not_ configured for TBS.
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: stmmac: fix TSO and TBS feature enabling during driver open
    https://git.kernel.org/netdev/net/c/5e6038b88a57

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


