Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7791943FC9F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhJ2Mwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230475AbhJ2Mwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:52:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6FBEE61177;
        Fri, 29 Oct 2021 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635511808;
        bh=/X8ZHREa4Z0hbX0kftn7h2GB0VPahD/Cmkuz9Jptb3M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X2pT5hEdx3loTwJnIebQcTdITWqLOKbp5e5ckUhFaUbmse77nZB9J3wUTnTTZQaLP
         t0Z/57qnkrccrXgOcki1lzZAhlRnVb4uEfR0Mw4c4NSj77T5OOoYcNdDjGvxit0jZN
         t+hn00eZ1UNeGc7ZTay5vosSC5Bsv7SPk8hrfXCRvPY/TkeMefKKTpzXaaGzKU1ma7
         6N+zH6Tc//OYVeuVDuwXgpTInykEe0S6ewMVEVjQPPF2U2vptk8sHGWxtjSGMAKNdX
         nMS52f/3KfY+v0DDFi3xGXooQuul5k4rsHdDvG3F0n8HUcWoohDvgtQTUGs8QqbHJJ
         rh+efuGk0M5yg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5478360A5A;
        Fri, 29 Oct 2021 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phylink: avoid mvneta warning when setting pause
 parameters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551180834.32606.4594268126583454143.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:50:08 +0000
References: <E1mg6oY-0020Bg-Td@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mg6oY-0020Bg-Td@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 15:55:34 +0100 you wrote:
> mvneta does not support asymetric pause modes, and it flags this by the
> lack of AsymPause in the supported field. When setting pause modes, we
> check that pause->rx_pause == pause->tx_pause, but only when pause
> autoneg is enabled. When pause autoneg is disabled, we still allow
> pause->rx_pause != pause->tx_pause, which is incorrect when the MAC
> does not support asymetric pause, and causes mvneta to issue a warning.
> 
> [...]

Here is the summary with links:
  - [net] net: phylink: avoid mvneta warning when setting pause parameters
    https://git.kernel.org/netdev/net/c/fd8d9731bcdf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


