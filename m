Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E8A3CC9F2
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 18:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhGRQx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 12:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhGRQxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 12:53:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 584E3611BE;
        Sun, 18 Jul 2021 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626627005;
        bh=LKkk6pWJq/YxrxkO/nLSQM56/Je/+jo2kQjihofOsv4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lAGqJp0RVIRcUYviadsJJb4h7jA6pFAz+Mp+lIyQABREIpTOa6zm88HQUilsRcKbZ
         SyKSLvjC7cWfcHT2Hlo0EaNtJplceVR50HL+e1ii0MvtBjd7tHTj6myktXJY5rMwrN
         GlAB3ApKhlPvuxJFiXrqPLX51RcujCSSW3WQ5KfoqOwOAFexYAwycNHKBKCVUwSuGl
         b7wXsx2MmVHTmg8z9W5OBY52o11zAiFuEGa7epwvUHkf2q+bEJtXXtsxfgQz7bzwny
         ojR8e9lzsNyLYiffErSe57FGbLNeeqL1EvKpWRclCm7AnerON+yHucXOrfP3YQnyjw
         U/ZhwQMo5duhQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5327C60A37;
        Sun, 18 Jul 2021 16:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: Fix data type in DP83822 dp8382x_disable_wol()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162662700533.19662.6627443948663842990.git-patchwork-notify@kernel.org>
Date:   Sun, 18 Jul 2021 16:50:05 +0000
References: <20210717123249.56505-1-marex@denx.de>
In-Reply-To: <20210717123249.56505-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 17 Jul 2021 14:32:49 +0200 you wrote:
> The last argument of phy_clear_bits_mmd(..., u16 val); is u16 and not
> int, just inline the value into the function call arguments.
> 
> No functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> 
> [...]

Here is the summary with links:
  - net: phy: Fix data type in DP83822 dp8382x_disable_wol()
    https://git.kernel.org/netdev/net-next/c/0d6835ffe50c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


