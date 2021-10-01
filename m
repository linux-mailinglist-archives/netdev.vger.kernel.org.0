Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE8441F7C4
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356037AbhJAWvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355937AbhJAWvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:51:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8670561AF7;
        Fri,  1 Oct 2021 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633128607;
        bh=Ie/lPpWKEMc3IvBjjWDEbnIKFqnh0g98KuBk8LfRQmo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RB2BE7OqpznsJ+CEpyPQkI7WccQdewf5Ocb9oqNgduZ/mWffjsmbTG1xkGKpcfaTn
         3egapdsT6c+tK79HXwKhvVlK3uGu1YNKLvB6HLtOzyeVYCCQUzhnVO42Kr/TrOsCql
         b803Gxdk4mcV/oasjQbJV/hNeC83NZSpZq63XYlMcay9Qd3wKyGIzhuX8MrDFfNA09
         kuuSBN420urQQiFt+qVtDwXeeC/KVBlC2Oc+pyvmLuGItt8YJdVQ4b6wgAwTw/omPa
         NOIzzJZxP4c28xYPV/3QFgIOQcYCxlQRdfiUn4eaTcK0C6QuPeW2aUycAZ+6A8Fzg9
         djqFMpcPO13PQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 75F3460A69;
        Fri,  1 Oct 2021 22:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/core: disable NET_RX_BUSY_POLL on PREEMPT_RT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163312860747.19403.5188764825013993670.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 22:50:07 +0000
References: <20211001145841.2308454-1-bigeasy@linutronix.de>
In-Reply-To: <20211001145841.2308454-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tglx@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  1 Oct 2021 16:58:41 +0200 you wrote:
> napi_busy_loop() disables preemption and performs a NAPI poll. We can't acquire
> sleeping locks with disabled preemption which would be required while
> __napi_poll() invokes the callback of the driver.
> 
> A threaded interrupt performing the NAPI-poll can be preempted on PREEMPT_RT.
> A RT thread on another CPU may observe NAPIF_STATE_SCHED bit set and busy-spin
> until it is cleared or its spin time runs out. Given it is the task with the
> highest priority it will never observe the NEED_RESCHED bit set.
> In this case the time is better spent by simply sleeping.
> 
> [...]

Here is the summary with links:
  - [net-next] net/core: disable NET_RX_BUSY_POLL on PREEMPT_RT
    https://git.kernel.org/netdev/net-next/c/20ab39d13e2e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


