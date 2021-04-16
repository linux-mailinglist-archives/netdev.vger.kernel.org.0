Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E66362B18
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbhDPWar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233995AbhDPWah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6A59B613C7;
        Fri, 16 Apr 2021 22:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618612212;
        bh=+uvh7D0gOyH3/N9iSRwtAwQhn0xf12OhXPB9ehBF9ko=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TgQz1NkIz83T+vluKDnQd+ZMT7QoKgV6cMeTq9Tb8MziESnbc98uKx3CqOzseifQC
         +uBfQ4UENr8YnxFdMpMEPlfDfvXmZH3uWO3ckaJB68/o1AW9g/3fLSAZy0V7n0zbbY
         fIOVjtdKh0nWOj8edj7FCRSv9CPGvIPrrI3bQ7RzZEHkEdKa9Zst2MB7h8D11AR+Hn
         KRYbs9KlS4ETabA6+KlvTg3Nd2rWeh1lSVMCicjJDkOLQ474f2yEsV9ktf1/xCbeTw
         99wYHqApCPm5GKVr03rt+GcwmMrCs24vSg5iGwyYNPvNbcASy2O0Ky8gCnj7hBpQia
         3sBuMUXnsp1Bg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 601DA60CD8;
        Fri, 16 Apr 2021 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v3] net: ethernet: mediatek: ppe: fix busy wait loop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861221238.19916.9391393406931701740.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 22:30:12 +0000
References: <20210416003747.340041-1-ilya.lipnitskiy@gmail.com>
In-Reply-To: <20210416003747.340041-1-ilya.lipnitskiy@gmail.com>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, pablo@netfilter.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Apr 2021 17:37:48 -0700 you wrote:
> The intention is for the loop to timeout if the body does not succeed.
> The current logic calls time_is_before_jiffies(timeout) which is false
> until after the timeout, so the loop body never executes.
> 
> Fix by using readl_poll_timeout as a more standard and less error-prone
> solution.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: ethernet: mediatek: ppe: fix busy wait loop
    https://git.kernel.org/netdev/net-next/c/c5d66587b890

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


