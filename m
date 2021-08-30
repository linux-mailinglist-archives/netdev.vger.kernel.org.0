Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69653FB2E5
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhH3JLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234714AbhH3JLA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 05:11:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F12161039;
        Mon, 30 Aug 2021 09:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630314607;
        bh=Ql/24jVWHfzyIP7hIDEAjqGpn9WD6ikv4rVld9s9f1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=huXuTLTlNPXY7Acy0f7nabUyGGydQj5W2Xx1UvgvDPuY28JMxmH52bKJZ5TIA/Gg4
         fWWQbJVWu8ZwlJVu+cH0WIKtsL04Eo9YiBWR04moF529EZy0nr3zOJ5OnsYczmdmwO
         TQTKzPtkbSrWVRPNdu9ZqiiHsNHTkjET+w+7aoJH0zVP/0xqGvYNcAhO+6Bg+wkh0D
         WzBMh8BFpuTazleCesznUijyM4+qfjqDBeQkihgqdR50Fv5kzxlKNm4JoUX1F4lkk5
         nmB4Cd6A9IiIEeFtSENXL05qpdldbZ+i6MSQrhp4YXZxMbLkf34YvQQVlccko9KrTh
         dJLZuaKHHszWw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3269960A5B;
        Mon, 30 Aug 2021 09:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5 v3] IXP46x PTP Timer clean-up and DT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163031460720.20104.18428502213271867294.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Aug 2021 09:10:07 +0000
References: <20210828171548.143057-1-linus.walleij@linaro.org>
In-Reply-To: <20210828171548.143057-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        kaloz@openwrt.org, khalasa@piap.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 28 Aug 2021 19:15:43 +0200 you wrote:
> ChangeLog v2->v3:
> 
> - Dropped the patch enabling compile tests: we are still dependent
>   on some machine-specific headers. The plan is to get rid of this
>   after device tree conversion. We include one of the compile testing
>   fixes anyway, because it is nice to have fixed.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5,v3] ixp4xx_eth: make ptp support a platform driver
    https://git.kernel.org/netdev/net-next/c/9055a2f59162
  - [net-next,2/5,v3] ixp4xx_eth: fix compile-testing
    https://git.kernel.org/netdev/net-next/c/f52749a28564
  - [net-next,3/5,v3] ixp4xx_eth: Stop referring to GPIOs
    https://git.kernel.org/netdev/net-next/c/13dc931918ac
  - [net-next,4/5,v3] ixp4xx_eth: Add devicetree bindings
    https://git.kernel.org/netdev/net-next/c/323fb75dae28
  - [net-next,5/5,v3] ixp4xx_eth: Probe the PTP module from the device tree
    https://git.kernel.org/netdev/net-next/c/e9e506221b42

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


