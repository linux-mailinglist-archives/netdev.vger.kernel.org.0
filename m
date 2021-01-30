Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2D23092C7
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhA3I7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 03:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230281AbhA3FMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:12:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 47A9464E05;
        Sat, 30 Jan 2021 05:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611983407;
        bh=U5XpYQ2t9jX27WsYu5OzSRNqV9TQob2l2Tmxqh0i93A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pHji9Onmp+8zDcUzAXpWIdM4iOx2vC3UWX2Ovozc0BWmbaUXWTVjFmqAN59l66StD
         Aab05eXgc5i4MCU6ZG2jCR0zdadh3qxuVAh0ZrP3de/3zPsro33QK8sGSg4lZ73pVq
         z9niV11TllCw+PeHfZ2to5GeL18axch4DqwwjaZIy2PTm1FUIADIfmNUeQ9i/7SB+b
         Rul4hcGsqokrvePQgjDyT1F9D4DSB7FgLcKeFm/HQ0W3VLEvi3l3wl6qLzLO5ddxL3
         T6vYCNxV2ZMR25715GitnqymfY4sAdvK4TfFtMDG2SA+7+gzFqLCy/0B7Ew0EMpbat
         w3KssLx1f9slQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 36DD960986;
        Sat, 30 Jan 2021 05:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Add missing TAPRIO dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161198340721.22188.12829255088382984894.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 05:10:07 +0000
References: <20210128163338.22665-1-kurt@linutronix.de>
In-Reply-To: <20210128163338.22665-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 28 Jan 2021 17:33:38 +0100 you wrote:
> Add missing dependency to TAPRIO to avoid build failures such as:
> 
> |ERROR: modpost: "taprio_offload_get" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
> |ERROR: modpost: "taprio_offload_free" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
> 
> Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: hellcreek: Add missing TAPRIO dependency
    https://git.kernel.org/netdev/net-next/c/6c13d75beee5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


