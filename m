Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D9631D28B
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhBPWU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:20:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhBPWUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B2B1E64E79;
        Tue, 16 Feb 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613514007;
        bh=oX9goetpqG2nZxoOAohhAAX0CnEN2NZK3yS27Ok8Mf4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pxKiVxBdatulKPCORQbZ9/wUhrFl/8HzSjZgJIrFxHv+vdgjHILKkIGikU8VBta9j
         3B3G0HkdGW/tot/id5kg2XQeJJyDJylivK157I5o6SN83fa9Gw7WLlwpUJa0gGKjsV
         urdgm/1ttYS22cuFa2vQHR19sq699iZTQJNDImsUWGqbLgj68ct26KpfHd06H7vGaa
         SH0CRajFwie4ucIgkLt7A8AwEY4U6TnHIhf+wjRU28Onso36BewrN//1iiBLYXanSr
         6urI44JIkX9mslx11S/ZNLyZlYy8Gp241xxNd47ckme+dI7m6nCxR9ep2ZEMwt1sTq
         gui5gcXa1zxYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC0DD60A15;
        Tue, 16 Feb 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tg3: Remove unused PHY_BRCM flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351400770.20875.8637152778022778666.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 22:20:07 +0000
References: <20210216190837.2555691-1-f.fainelli@gmail.com>
In-Reply-To: <20210216190837.2555691-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 11:08:37 -0800 you wrote:
> The tg3 driver tried to communicate towards the PHY driver whether it
> wanted RGMII in-band signaling enabled or disabled however there is
> nothing that looks at those flags in drivers/net/phy/broadcom.c so this
> does do not anything.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - tg3: Remove unused PHY_BRCM flags
    https://git.kernel.org/netdev/net-next/c/32aeba1f7a98

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


