Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF37041BCE4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 04:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbhI2Clt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 22:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243721AbhI2Clr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 22:41:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 19F50613DB;
        Wed, 29 Sep 2021 02:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632883207;
        bh=Yt+Qqw2yGqDgP3vvoWuiOsVwZIpl/fcjT2xixYQjSj8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jI4X9C46aUTRF2aDz+tdCZwMwNa0IHZEIssMeGG24VgEYEAiyn8/jg+42bjzL66+Z
         /MyPpebKHYDREveM5Q7knkA5vr0dDRVALN6hnld1tWI4wd2hZAR1SniuSPp/pnIH5G
         puKrtHEkbh6joMPwiHKjyCdc9E+/UUscj+ALxJnCqAbpmHf17CXUuIHTjas3grpt7s
         NU89asyS4dCrrQ9fMgL4F8f4+8zJLnzibSbfEpon06+K0u6bRRRPOrlHx0RDlU8btZ
         QWc7dhdowVM+gR0ShCs8kGEAVoZV/NjFFnVBRwroDYCzIAPr3cP7d64XI3+UHcDQo1
         Z+cZ26fW3fbDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0FB77609D9;
        Wed, 29 Sep 2021 02:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bridge: mcast: Associate the seqcount with its
 protecting lock.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163288320705.8381.15834079982725881362.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 02:40:07 +0000
References: <20210928141049.593833-1-bigeasy@linutronix.de>
In-Reply-To: <20210928141049.593833-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, tglx@linutronix.de, efault@gmx.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 28 Sep 2021 16:10:49 +0200 you wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The sequence count bridge_mcast_querier::seq is protected by
> net_bridge::multicast_lock but seqcount_init() does not associate the
> seqcount with the lock. This leads to a warning on PREEMPT_RT because
> preemption is still enabled.
> 
> [...]

Here is the summary with links:
  - [net] net: bridge: mcast: Associate the seqcount with its protecting lock.
    https://git.kernel.org/netdev/net/c/f936bb42aeb9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


