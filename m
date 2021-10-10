Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1543B42807B
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 12:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhJJKcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 06:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231466AbhJJKcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 06:32:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6126F60F43;
        Sun, 10 Oct 2021 10:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633861808;
        bh=n8/yTPrUs7wyfgr2hZqCn0gsynl1fTgZpBM1UeDaC0c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WIASyrbFRpcjhBnnWM9Eu2Pe9Kf69UlLliXUxEOy6X5ST09UrthDcC3s9XiWBazdt
         S44Vv+kTp/0EINNKj+XquWQuQAhq2JQl+0ov9AmcgISuNywo1uIDwAu4RXWorL5c/c
         07dkB+vfjI0Uh6fN7qjQUkzPablJ/m62MY/COZugaHHSjlvcYTp7Q+lp0P/vMXu5ee
         sEuPcSmRUpflxbWSZ/YeS7ZIrHymBhQiNS6CIcEV6aLOmI8MpAP617GIXNaLb7I3g/
         aAtwnQ9puKwOXqS6O0M8/3ske56HD3cq/wfRw7yvDP8DY1CcrCFfn/FTCgcNkH0gnb
         2d0OqJEXSmN6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 53F8760A88;
        Sun, 10 Oct 2021 10:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 1/4] net: phy: at803x: fix resume for QCA8327 phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163386180833.17785.1226506407127383897.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Oct 2021 10:30:08 +0000
References: <20211009224618.4988-1-ansuelsmth@gmail.com>
In-Reply-To: <20211009224618.4988-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 10 Oct 2021 00:46:15 +0200 you wrote:
> From Documentation phy resume triggers phy reset and restart
> auto-negotiation. Add a dedicated function to wait reset to finish as
> it was notice a regression where port sometime are not reliable after a
> suspend/resume session. The reset wait logic is copied from phy_poll_reset.
> Add dedicated suspend function to use genphy_suspend only with QCA8337
> phy and set only additional debug settings for QCA8327. With more test
> it was reported that QCA8327 doesn't proprely support this mode and
> using this cause the unreliability of the switch ports, especially the
> malfunction of the port0.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: phy: at803x: fix resume for QCA8327 phy
    https://git.kernel.org/netdev/net-next/c/ba3c01ee02ed
  - [net-next,2/4] net: phy: at803x: add DAC amplitude fix for 8327 phy
    https://git.kernel.org/netdev/net-next/c/1ca8311949ae
  - [net-next,3/4] net: phy: at803x: enable prefer master for 83xx internal phy
    https://git.kernel.org/netdev/net-next/c/9d1c29b40285
  - [net-next,4/4] net: phy: at803x: better describe debug regs
    https://git.kernel.org/netdev/net-next/c/67999555ff42

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


