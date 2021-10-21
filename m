Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F44F4360CF
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 13:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhJULwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 07:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230347AbhJULwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 07:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ED43061221;
        Thu, 21 Oct 2021 11:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634817019;
        bh=sVDvQ1ZxQLoeujN9G3l7GDrhXRKOKxA4BjyR6L+ybD8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KfoNrYgqPFlLcaAAMs0wsl50RV35RfcGjNxlTL8tktIlXNLlYEgLa8aT3BziBfnQM
         wW6Jv/NqgsBVox5sdte9DzoCmoObWipdcTyB3n1EVx03+8ni4nnYbyrWdVDz8SL9pc
         cuiHo7B/xu5iZI7K60degyy4SdWzbtwsTlATnUnHob+OJ02FuC2UoANZ1+sdhIDSPj
         1CyV8x231rVfodVybvPm9cWVqMghwZByMBb6vEnmjvPgioUw84pBgmhzYp6SpIYIUo
         1BruhzWQ6dIogAcmxLDf7yA8bsH882T036nK7qZ5HTKFhoytZPtNlpRZRSZ2f3jIJr
         Z+UiW/lXHNHCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E0006609E7;
        Thu, 21 Oct 2021 11:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stats: Read the statistics in
 ___gnet_stats_copy_basic() instead of adding.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163481701891.17414.17028188432816254517.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 11:50:18 +0000
References: <20211021095919.bi3szpt3c2kcoiso@linutronix.de>
In-Reply-To: <20211021095919.bi3szpt3c2kcoiso@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     naresh.kamboju@linaro.org, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        lkft-triage@lists.linaro.org, davem@davemloft.net, kuba@kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        tglx@linutronix.de, a.darwish@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Oct 2021 11:59:19 +0200 you wrote:
> Since the rework, the statistics code always adds up the byte and packet
> value(s). On 32bit architectures a seqcount_t is used in
> gnet_stats_basic_sync to ensure that the 64bit values are not modified
> during the read since two 32bit loads are required. The usage of a
> seqcount_t requires a lock to ensure that only one writer is active at a
> time. This lock leads to disabled preemption during the update.
> 
> [...]

Here is the summary with links:
  - [net-next] net: stats: Read the statistics in ___gnet_stats_copy_basic() instead of adding.
    https://git.kernel.org/netdev/net-next/c/c5c6e589a8c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


