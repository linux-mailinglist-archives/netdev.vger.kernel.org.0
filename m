Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095DC397C5B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbhFAWVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234656AbhFAWVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 50015613C0;
        Tue,  1 Jun 2021 22:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622586004;
        bh=/ydfUa6PlTuoBLvzs5G69/MHkGCrODNyb1/yg31cub0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XJN7RG3e+7wdqZ2nO/AINo+iIlkQy4E5cdIeV+D7O6aA8oR/ynENoVg3GiYgJHEjO
         gUJ9qeKcD1ZVzQSyO490AMaKE3bopS1pScRrpxExkhxMV1tXgprY/R+FwLnH/J3B3j
         L8TWERs1Svpc0CBu/tqyv18nfXor+urNp6x/K2V6+0/F08k31bp+DgWNZo8eecbqLa
         /dGfS+Kc3rQKK6xZhDF2vusa1AROjN9AiM6cQCHyu3GqyJU+Pw+p70m4yxcwta/Zzm
         iNAQ8MbScnPX0ZhfqnaY4vLISAkRAefwoC6UiOpDA8+IHgeOZnGNg1/gXMwNn5t/UN
         hsXUOo02e7zdw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 41C42609F8;
        Tue,  1 Jun 2021 22:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] netpoll: don't require irqs disabled in rt kernels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258600426.8548.922980604449653710.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:20:04 +0000
References: <20210531152325.36671-1-wander@redhat.com>
In-Reply-To: <20210531152325.36671-1-wander@redhat.com>
To:     None <wander@redhat.com>
Cc:     linux-rt-users@vger.kernel.org, bigeasy@linutronix.de,
        tglx@linutronix.de, rostedt@goodmis.org, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 12:23:23 -0300 you wrote:
> From: Wander Lairson Costa <wander@redhat.com>
> 
> write_msg(netconsole.c:836) calls netpoll_send_udp after a call to
> spin_lock_irqsave, which normally disables interrupts; but in PREEMPT_RT
> this call just locks an rt_mutex without disabling irqs. In this case,
> netpoll_send_udp is called with interrupts enabled.
> 
> [...]

Here is the summary with links:
  - netpoll: don't require irqs disabled in rt kernels
    https://git.kernel.org/netdev/net-next/c/b0f6c9ac8088

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


