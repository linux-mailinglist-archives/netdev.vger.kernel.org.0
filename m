Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8810531D381
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhBQBAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhBQBAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 20:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8F5A164E76;
        Wed, 17 Feb 2021 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613523607;
        bh=ome4O1s429bOPzZ2gA36GLqGrtXr22tT8ZEcy5CjB/E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ofPF6UXguvCqLttukDAhUhRYRMvrEJEADB4ItS2Qm+BfZcMvkZ21GbS7CRzhIDice
         utbIP2W7bd9CskcZWVWoecwY9xToddZONE2tN3hxQtulb4OBX8KSxDNhjE7VJY7s4S
         HxxQlt8ywtVUemVxQyaw7y27AljwmvLfKSOaU3zV9GyEEDIuuC4uPp0lLtlaGOGogN
         L8kcxw2Nm7R3dINPBcixEJh+2kvDihFznZdLjQA4dPQFPy6usprqmV8Jn4Jd5mYDFE
         VjncIjBwAqs1QDD2BUo9xYaW5gSITNT0n2ABsTZEcXIq4yiwzwIxFheGL+BySz1m/k
         5yRziYLvrn4eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 77C1760A17;
        Wed, 17 Feb 2021 01:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161352360748.27993.16056070788425010106.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Feb 2021 01:00:07 +0000
References: <20210216235542.2718128-1-linus.walleij@linaro.org>
In-Reply-To: <20210216235542.2718128-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, sandberg@mailfence.com, dqfext@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Feb 2021 00:55:42 +0100 you wrote:
> Support also transmitting frames using the custom "8899 A"
> 4 byte tag.
> 
> Qingfang came up with the solution: we need to pad the
> ethernet frame to 60 bytes using eth_skb_pad(), then the
> switch will happily accept frames with custom tags.
> 
> [...]

Here is the summary with links:
  - net: dsa: tag_rtl4_a: Support also egress tags
    https://git.kernel.org/netdev/net-next/c/86dd9868b878

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


