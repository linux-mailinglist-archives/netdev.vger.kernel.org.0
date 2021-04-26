Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE4236AA5A
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 03:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhDZBbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 21:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231652AbhDZBa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 21:30:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F3BAF611F0;
        Mon, 26 Apr 2021 01:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619400616;
        bh=KWx/DXiplZ5N7iCWuJZQw6xMpJL4XWPzxB13YicR0ds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qRp6FOuYul3WstH7Z51X6aTGHMkJu0yzhGSm1iYHvyRRw0gcFNooVWsh2M87adCyJ
         XJAHfCgaiH84GGXn2ogmr4YBf019MVLx+ie4Li7E3/H4EJ0iWbTj34lqQBQafVnXl3
         ZpU7vYn86KrTK0mRIqxZgijTNY+DZEmtjVzgdxdPJjyIeNAGpM2m4HsuA96LNdl9b7
         jLlQGiqYnmwppSzJ0Xl13Sb7XjMxvYSLuQxS6wg9LR6638hsqMJ8IRPD0IjGpAczef
         yvvcqvKj0YVFSkRPbDlVOIW8G7g92F7yDr4ayPQPEBNCSVQ0LWtprf+pV24bghYlpY
         CM1KkOax4eA0A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EE1E860CE0;
        Mon, 26 Apr 2021 01:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3 net-next v4] net: ethernet: ixp4xx: Add DT bindings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161940061597.7794.15882879498463210620.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Apr 2021 01:30:15 +0000
References: <20210425003038.2937498-1-linus.walleij@linaro.org>
In-Reply-To: <20210425003038.2937498-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, wigyori@uid0.hu,
        rayknight@me.com, devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 25 Apr 2021 02:30:36 +0200 you wrote:
> This adds device tree bindings for the IXP4xx ethernet
> controller with optional MDIO bridge.
> 
> Cc: Zoltan HERPAI <wigyori@uid0.hu>
> Cc: Raylynn Knight <rayknight@me.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> [...]

Here is the summary with links:
  - [1/3,net-next,v4] net: ethernet: ixp4xx: Add DT bindings
    https://git.kernel.org/netdev/net-next/c/48ac0b5805dd
  - [2/3,net-next,v4] net: ethernet: ixp4xx: Retire ancient phy retrieveal
    https://git.kernel.org/netdev/net-next/c/3e8047a98553
  - [3/3,net-next,v4] net: ethernet: ixp4xx: Support device tree probing
    https://git.kernel.org/netdev/net-next/c/95aafe911db6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


