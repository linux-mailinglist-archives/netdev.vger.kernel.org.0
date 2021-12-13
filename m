Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC878472C97
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236993AbhLMMuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:50:14 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53246 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbhLMMuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:50:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D4779CE0FB5;
        Mon, 13 Dec 2021 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 054D2C34603;
        Mon, 13 Dec 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639399810;
        bh=DQf3QvLEOaqcdHPAVObxLCxmaxqzlmQ7qY/VJyHZMlM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hjg3NP9ScoDtrk0G0F0T4lnCCvGTEy9unNAcRRBoEmHzzxDOI2O//0+n9X8oIN1W0
         2DrU3uLqvVNXv3zOxmcptYq3GGbzV/Xb+MCsdwempGzF5s8uB2a/gbVOJ+dUcv8Npi
         hbWiZdvz92Bkgx+oHADuN40wyMfgsdxndPN9qDLYz1QSs8blRRiTIJKs3WR0Ar7Itr
         k3yPtdevCI4dq61hTbjX7K3wtofAmiMCU/qhcUWoWeAaPAWyig69K+1RxY2KOO3A7S
         sWD+0PFUPqzwOcpxx2f2GnwAKJIM8E+l6S8nsoMSg9xo/thFrcrtchNR9iJoGE4Hd0
         6dOjXk8mc3hrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DDE40609D6;
        Mon, 13 Dec 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] u64_stats: Disable preemption on 32bit UP+SMP
 PREEMPT_RT during updates.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163939980990.30215.13552444074431867461.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 12:50:09 +0000
References: <YbO4x7vRoDGUWxrv@linutronix.de>
In-Reply-To: <YbO4x7vRoDGUWxrv@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, kuba@kernel.org,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Dec 2021 21:29:59 +0100 you wrote:
> On PREEMPT_RT the seqcount_t for synchronisation is required on 32bit
> architectures even on UP because the softirq (and the threaded IRQ handler) can
> be preempted.
> 
> With the seqcount_t for synchronisation, a reader with higher priority can
> preempt the writer and then spin endlessly in read_seqcount_begin() while the
> writer can't make progress.
> 
> [...]

Here is the summary with links:
  - [net-next] u64_stats: Disable preemption on 32bit UP+SMP PREEMPT_RT during updates.
    https://git.kernel.org/netdev/net-next/c/3c118547f87e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


