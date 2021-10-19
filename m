Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A99743357D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhJSMMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230129AbhJSMMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:12:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 85ECB6115B;
        Tue, 19 Oct 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634645408;
        bh=EwZRvJnCszVQ44JnJffy29m+a7HL1Huzi17+KrmGPV4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nTpWXSEkCmxFlITm0IPluR2gyrCuHg6iMxADXpBMCS8AloOYCjWXhZY8CTgl9SJmM
         3RTfQv+5S8damDkb6g1n9S8q7kr3L4oQaYox34BKTA35cWrbbXP3PIVTnxm7FYWRbj
         VfTRLO9u1rwrujLmlJ0pNNsR2pc6QZUwi1OAG7PWDtj04JGeZZj5o7Jh+zwOVJs6Lq
         +lv1dnDXrCKAZtTal5DB2Acky01jK1DSv0zVB0N1WQMXNih6DBANBkZvC8w12SH+6g
         1rwpgsqIvZTtI+W7nhA4YCdx6+GJbfbun15ORXd0MM/Wh9eSPGgWX8/Y8HR+sQyUkK
         cxbx1gJ3W6NuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 795CB609D7;
        Tue, 19 Oct 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: Allow statistics reads from softirq.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464540849.1998.7367449316991483244.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 12:10:08 +0000
References: <20211019101204.4a7m2i3u5uoqrc6b@linutronix.de>
In-Reply-To: <20211019101204.4a7m2i3u5uoqrc6b@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, a.darwish@linutronix.de, edumazet@google.com,
        tglx@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 12:12:04 +0200 you wrote:
> Eric reported that the rate estimator reads statics from the softirq
> which in turn triggers a warning introduced in the statistics rework.
> 
> The warning is too cautious. The updates happen in the softirq context
> so reads from softirq are fine since the writes can not be preempted.
> The updates/writes happen during qdisc_run() which ensures one writer
> and the softirq context.
> The remaining bad context for reading statistics remains in hard-IRQ
> because it may preempt a writer.
> 
> [...]

Here is the summary with links:
  - [net-next] net: sched: Allow statistics reads from softirq.
    https://git.kernel.org/netdev/net-next/c/e22db7bd552f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


