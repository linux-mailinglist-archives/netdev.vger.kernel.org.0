Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE7B37FED4
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhEMUVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232710AbhEMUVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 16:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 71AFB61440;
        Thu, 13 May 2021 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620937210;
        bh=Uptf5dAiE7HARnD9cJTh9N5kGpyxjkY2cZVavxMejI4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eN274Za9C+6yNVUF4BGmxONVHT8EGhZd87QXwd46u2C7O/p3nRgqDTorRQ55hgJVy
         qmK4ICcDNB9BG3dYluLDSHuGKbQWcquiEIB8srd7AI3zpV54TlAC7F7q/toULSpH8v
         hHpPd0TyqezRtNye40K7nIdhfo/K77iFwunF/2yqjvdy7pFkeoPdaaB7hmLBPWR1Cg
         1ncKmM7A2XZ+abwAA3WFW5xrjycOMwJRuTsWKN/ClXmUWXuodWucZsuqdGQuTYx+zd
         zikB9UXWGFLJQn0jITtc3R56LBmN6xb+lWV0a+I5pcA1hBLAdRLUj6ZBUg+EnVotx4
         b4X9krg7NvIwA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6834360A56;
        Thu, 13 May 2021 20:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Treat __napi_schedule_irqoff() as
 __napi_schedule() on PREEMPT_RT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162093721042.5649.1489711837264906533.git-patchwork-notify@kernel.org>
Date:   Thu, 13 May 2021 20:20:10 +0000
References: <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
In-Reply-To: <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, juri.lelli@redhat.com, tglx@linutronix.de,
        linux-rt-users@vger.kernel.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, sassmann@redhat.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 12 May 2021 23:43:24 +0200 you wrote:
> __napi_schedule_irqoff() is an optimized version of __napi_schedule()
> which can be used where it is known that interrupts are disabled,
> e.g. in interrupt-handlers, spin_lock_irq() sections or hrtimer
> callbacks.
> 
> On PREEMPT_RT enabled kernels this assumptions is not true. Force-
> threaded interrupt handlers and spinlocks are not disabling interrupts
> and the NAPI hrtimer callback is forced into softirq context which runs
> with interrupts enabled as well.
> 
> [...]

Here is the summary with links:
  - [net-next] net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT
    https://git.kernel.org/netdev/net-next/c/8380c81d5c4f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


