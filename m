Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA00410B7C
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhISMLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229572AbhISMLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 56EE261268;
        Sun, 19 Sep 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632053408;
        bh=VSb5hNaJwWMS+OAmqPn8iI/reBAoCRECl6qFmcAcZ18=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pbfzm6flTF+XFpcl/qdsGr+1jEXUCivNtMWc19K5lWVXNfA4AMufpyZ/sTzxeXg89
         rk7KMdn72zNC+qjJig+OMTjvhluM+rhK0Dh82Ok1CuX0hZ7c1I4IPY316yYkHkPLQL
         I8s5UMHYP9ZFTOLQPXcmlZYfcOjkFZ3jJHnUc/DtXuwDbIA2jwljErR+hyVWr9+lRg
         rce9uGy9SYQU44aX6GUzPsTQq9bEwtpAVk26zcxR2d21liX3boFRHMFYfO0vvTu3Dy
         TQN1F1NZ0hrOmzIrK1Dt4/VXS8PYLIn+ET9XZiPJv30T4UvSuXpzR6czrt/Yj57VVX
         EdlGFUUgL3k1A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F235608B9;
        Sun, 19 Sep 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch] net: core: Correct the sock::sk_lock.owned lockdep
 annotations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205340825.3254.11987805094738440197.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 12:10:08 +0000
References: <20210918114626.399467843@linutronix.de>
In-Reply-To: <20210918114626.399467843@linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        mingo@kernel.org, peterz@infradead.org, bigeasy@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 18 Sep 2021 14:42:35 +0200 (CEST) you wrote:
> lock_sock_fast() and lock_sock_nested() contain lockdep annotations for the
> sock::sk_lock.owned 'mutex'. sock::sk_lock.owned is not a regular mutex. It
> is just lockdep wise equivalent. In fact it's an open coded trivial mutex
> implementation with some interesting features.
> 
> sock::sk_lock.slock is a regular spinlock protecting the 'mutex'
> representation sock::sk_lock.owned which is a plain boolean. If 'owned' is
> true, then some other task holds the 'mutex', otherwise it is uncontended.
> As this locking construct is obviously endangered by lock ordering issues as
> any other locking primitive it got lockdep annotated via a dedicated
> dependency map sock::sk_lock.dep_map which has to be updated at the lock
> and unlock sites.
> 
> [...]

Here is the summary with links:
  - net: core: Correct the sock::sk_lock.owned lockdep annotations
    https://git.kernel.org/netdev/net/c/2dcb96bacce3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


