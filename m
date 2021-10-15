Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCBE42EEC5
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbhJOKcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237984AbhJOKcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 06:32:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A7FC961053;
        Fri, 15 Oct 2021 10:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634293811;
        bh=DHLh6FSnH4QrHqAuKEUFUCXthCz94ImsyAK5Mc9UgGc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gbs/1Da0V275uZF0HfEtIkXz3JNE6m0LL3Y/XLON93VJ8I+qmIsi0hkCXiu7+aVwJ
         BidiixWMSN1LsGCZ1b+3+dq/U0LM1YZkjT8JPicOE2TF1x1ag1u43H0vRtXQFVaHVb
         PW+qSKgsbmItz2nWdoEcylgw/buPvyIPBjoOaUpzR2S32p9LAR40SHiCeSej5ZAyDK
         kZRWpQgvo3XehzIoiYol7VB+0Gz4GIEybLp/Ba/N6oN84gZt7eO5SZv12z0MvNFwJf
         jXde+XrCu45Pf88bT2tC81OaejRYKUSHkzF4cuYVC9IKM7mhDJ5jEHcGUk4mhLGEeM
         hwepOuywgW77A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C23D609ED;
        Fri, 15 Oct 2021 10:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] tcp: switch orphan_count to bare per-cpu counters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163429381163.2368.12610989324854729622.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 10:30:11 +0000
References: <20211014134126.3998932-1-eric.dumazet@gmail.com>
In-Reply-To: <20211014134126.3998932-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, sfb@google.com, ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Oct 2021 06:41:26 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Use of percpu_counter structure to track count of orphaned
> sockets is causing problems on modern hosts with 256 cpus
> or more.
> 
> Stefan Bach reported a serious spinlock contention in real workloads,
> that I was able to reproduce with a netfilter rule dropping
> incoming FIN packets.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] tcp: switch orphan_count to bare per-cpu counters
    https://git.kernel.org/netdev/net-next/c/19757cebf0c5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


