Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CBC4637B1
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242476AbhK3Ozf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:55:35 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57988 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242752AbhK3Oxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:53:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 917EACE1A46;
        Tue, 30 Nov 2021 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF4F8C53FCD;
        Tue, 30 Nov 2021 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283808;
        bh=qcjOVQoYFRDYhxbeEnbphJ1qf5WhO/w8g+E2V9S8hx8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QEet9Ij0cIhCmRLJmGwiC5Xn2i79YDy5XL1mGhKhQz55/j2OuD+kfLsaZUDquqHPD
         hob6F45GYpkij5AM6OdYj2hQCFRf7hu2Jc6wp4Riw5IHZYluxTwQ4CO9iPquAOAyiZ
         v+LIElmrnIWUshpDFSrVUR9CoyzVkMzLFD8+B9UKwU/NGaXU0lOIsM9+hFf1X7E1Dj
         rNKxk8vqJSkHI+7PlsKiQREWXN9GB7QQfR0Xu1fXp4uzLfuaIFhRj6EOtHwQJxE+Bn
         o4qVMV/fn9XU6mjfTWWdAz8LlOwhpAXQNDj84TajEp7PLiOvSJC1NCYVNSuwvS/xIx
         IaVNqBXJazPvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A907260A94;
        Tue, 30 Nov 2021 14:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] Update non-RT users of migrate_disable().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163828380868.32639.9644324450074262877.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 14:50:08 +0000
References: <20211127163200.10466-1-bigeasy@linutronix.de>
In-Reply-To: <20211127163200.10466-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, peterz@infradead.org, corbet@lwn.net,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, tglx@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Sat, 27 Nov 2021 17:31:58 +0100 you wrote:
> While browsing through code I noticed outdated code/ documentation
> regarding migrate_disable() on non-PREEMPT_RT kernels.
> 
> Sebastian

Here is the summary with links:
  - [doc,1/2] Documentation/locking/locktypes: Update migrate_disable() bits.
    https://git.kernel.org/bpf/bpf/c/6a631c0432dc
  - [net,2/2] bpf: Make sure bpf_disable_instrumentation() is safe vs preemption.
    https://git.kernel.org/bpf/bpf/c/79364031c5b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


