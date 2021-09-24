Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1642A417577
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344473AbhIXNYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346460AbhIXNVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ACC6E61164;
        Fri, 24 Sep 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632489608;
        bh=umQ/aWH0n5HNkBX4QVVcUNCjeyb/avW+McQa0zophyk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RL6PkACew5+xXMe5xT2YueQKATP2ravt1deDCW3PAciqoeq/xwu9fTkOQSpvjuL5m
         I5XsSRVXGsjOlBJRq/2xVBkkRaKT77pnE9e0wMUPV8MoE7NU8a2oBCopmhTAIctuSc
         6sDOWGAxCFpqs4NbXq5zfyEhoiQ6gjDLn86EnOVU6y2CaR0/laTKOyA4xJaCc7e4sH
         jsZYjayba/5xKQw2Era4D52N8dSHonJVPCffnxEqhLON+r6NMDZbc/fLdUlmigRvvN
         dmlKKoWF1VRVoIRq/9lUg2knB72bV5fo4O1n4EHxm40gb017RuQ1tSTZwSBIyvzUbX
         WSKMizyn5GhEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A60DE60A6B;
        Fri, 24 Sep 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: broadcom: Fix PHY_BRCM_IDDQ_SUSPEND
 definition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163248960867.28971.15800289797333096687.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 13:20:08 +0000
References: <20210923205732.507795-1-f.fainelli@gmail.com>
In-Reply-To: <20210923205732.507795-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, justinpopo6@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 23 Sep 2021 13:57:32 -0700 you wrote:
> An extraneous number was added during the inclusion of that change,
> correct that such that we use a single bit as is expected by the PHY
> driver.
> 
> Reported-by: Justin Chen <justinpopo6@gmail.com>
> Fixes: d6da08ed1425 ("net: phy: broadcom: Add IDDQ-SR mode")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: broadcom: Fix PHY_BRCM_IDDQ_SUSPEND definition
    https://git.kernel.org/netdev/net-next/c/ae98f40d32cd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


