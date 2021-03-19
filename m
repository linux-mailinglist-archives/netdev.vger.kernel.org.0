Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73A03425D8
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhCSTKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhCSTKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 47E5D61941;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616181009;
        bh=4t2/3Kr3BpvM0Jb98+UCslREF1A4odq10adRJcbceaE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GRkFFN86/f/2iwMX1qMEYmX9RVkRg5eOagrAiqu1A2Z/buRbhDIlOWhA61M34VTrK
         gLuZGXjvgHabtMcxmiYv9kZwFtzHLNDEXcRacxEKibaxvhdkUcfbmKK/U2kAu0i1Ou
         3IcyDwmozJvwOgNRWJrozPb3WMToxlaCCqUrir4YZ1QzLwvtALvTcD3TpZVE6xsudZ
         5ulqQDPuBd2fOtgwKacE9vJOahExsktA3aEm46X11uJ4cVo3frPojlv/s4o4Zemivp
         3j2CVUM4YyZCDygv19pMnVbiyOXG1IOCTBP2KN8FL+FEL8P6dlXaU81+lw0LRWdzbs
         kIiLQ/fRqJ1nw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 36359626EB;
        Fri, 19 Mar 2021 19:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: phy: at803x: remove at803x_aneg_done()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618100921.534.1735321032544105619.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 19:10:09 +0000
References: <20210318194431.14811-1-michael@walle.cc>
In-Reply-To: <20210318194431.14811-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 20:44:31 +0100 you wrote:
> Here is what Vladimir says about it:
> 
>   at803x_aneg_done() keeps the aneg reporting as "not done" even when
>   the copper-side link was reported as up, but the in-band autoneg has
>   not finished.
> 
>   That was the _intended_ behavior when that code was introduced, and
>   Heiner have said about it [1]:
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: phy: at803x: remove at803x_aneg_done()
    https://git.kernel.org/netdev/net-next/c/5b6b827413e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


