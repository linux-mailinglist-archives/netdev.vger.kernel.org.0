Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF27F34F20C
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhC3UU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhC3UUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E689461883;
        Tue, 30 Mar 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617135608;
        bh=8Rr5rht8BU1NXR5spILZKqkILrtTO6kantTYozrDWpM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z5GrzaelxYfTd8XrUty7GXZmLFuF0fKjPQHtsebXLfmDt0ovOMi8jY51a+8Xe5SXG
         esmPI1mqKA8bC5Ad0YNAoeeSgnEh8VMZPmUqqlvd1AwtUaPffwCYDUVw4ZsoGwwUM5
         U2UN8KoHet8LwUIiXO1+NS7FkRzdj0msp6snqghtltnNQpk4xe80j8vjadumSU/SiI
         a1ySUFMChD3IBCE0HGNVKuXEPTUdJRDLyyIJoZ4oSuT9fFLPBXSNjvVSu10A6CuGAj
         wdvA3qME5bH0Pg5v/JwuVQVGOJuvQj1KKGqM+bzzfjT0PyMdXAitO3/KjHPcBoN7E4
         c54uAPwHAnXmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D767460A5B;
        Tue, 30 Mar 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/ncsi: Avoid channel_monitor hrtimer deadlock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713560887.2790.12767006562896839365.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 20:20:08 +0000
References: <20210329152039.15189-1-eajames@linux.ibm.com>
In-Reply-To: <20210329152039.15189-1-eajames@linux.ibm.com>
To:     Eddie James <eajames@linux.ibm.com>
Cc:     sam@mendozajonas.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        miltonm@us.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 29 Mar 2021 10:20:39 -0500 you wrote:
> From: Milton Miller <miltonm@us.ibm.com>
> 
> Calling ncsi_stop_channel_monitor from channel_monitor is a guaranteed
> deadlock on SMP because stop calls del_timer_sync on the timer that
> inoked channel_monitor as its timer function.
> 
> Recognise the inherent race of marking the monitor disabled before
> deleting the timer by just returning if enable was cleared.  After
> a timeout (the default case -- reset to START when response received)
> just mark the monitor.enabled false.
> 
> [...]

Here is the summary with links:
  - net/ncsi: Avoid channel_monitor hrtimer deadlock
    https://git.kernel.org/netdev/net/c/03cb4d05b4ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


