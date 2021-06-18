Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E813AD2D4
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbhFRTcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233369AbhFRTcO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0BECE613EE;
        Fri, 18 Jun 2021 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044605;
        bh=r3OztoIjza7rnjMi2OIZFzTtkEZDiluelL8pnC7FZ0E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SVneP4YGK6Vs/JggmU0y42vPTHa4TgZbiGDtv5TBgtKFd4aZCdS9sOpuGWLcmmV+W
         1cQ7bU5zsvRj6eTeL1hc7E/8vU+iD0iz3/JnPGfDokaJ630LBMfxxQhFRKpP51Sz6d
         okJkDW/yLyYQrcWW/c7H4ksdaoIEUMXwRhYJCwWj8kRYOfKqH03mM06N2DnZ8uCDWo
         zHsdk/fszrp642xbLp/Tbp9/fF7+AJdDxncEQODUYzm96FPCLHszQO/uVc1tcRzg7d
         nNcbXAmgK8f59LV4UaR4ajOc1VULVu+M298XqCKi2U1De2/gUC2qBFxALfPS7Zwuyq
         OAJThY4R4OsGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02CB9609EA;
        Fri, 18 Jun 2021 19:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: properly power down the
 microcontroller clock for SJA1110
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404460500.16989.17206886514874274502.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:30:05 +0000
References: <20210618115254.2830880-1-olteanv@gmail.com>
In-Reply-To: <20210618115254.2830880-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 14:52:54 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It turns out that powering down the BASE_TIMER_CLK does not turn off the
> microcontroller, just its timers, including the one for the watchdog.
> So the embedded microcontroller is still running, and potentially still
> doing things.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: sja1105: properly power down the microcontroller clock for SJA1110
    https://git.kernel.org/netdev/net-next/c/cb5a82d2b9aa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


