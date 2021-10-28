Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A1743D90F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 04:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhJ1CCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 22:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhJ1CCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 22:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E2F3961186;
        Thu, 28 Oct 2021 02:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635386407;
        bh=cefboX0W/AQMjPVZ2afR/4/N4Av1D/eEJnhsuF9fSjo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=URYppFUcRXmV3qNvws/aFFKvgEBoleSgsA2FSN5NoTvMSYq0AybUAm6vkjkgg5UcQ
         NvDEpJFELuCeSUzKKirlvPqgH0DKoOlt7FFV1WN2zdsI8oTZ7rE1TEG8TqnT9miluR
         gQNTAyhwbIuoC0o4zb6GubhdGVgsla6Q8j/GbGdSAT+ip5uCWYGXn0jq9yUyjz8lFQ
         5dDCg56bHfXcjOX+O6VKcL2gyMT2/m2GyAwOhAFueUBKSntK/whmTmpq/QZMeiYSlS
         0Whk9h6WnrG4HsG8l7Ra9TLccViqo7FiYH2tezmg+CZgxJTXp9+IdAz2nRdlEWxYSt
         PdQvSA7uWbTZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D52C7609CD;
        Thu, 28 Oct 2021 02:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mptcp: Rework fwd memory allocation and one
 cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163538640786.25351.1482828021523711017.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 02:00:07 +0000
References: <20211026232916.179450-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20211026232916.179450-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 16:29:12 -0700 you wrote:
> These patches from the MPTCP tree rework forward memory allocation for
> MPTCP (with some supporting changes in the net core), and also clean up
> an unused function parameter.
> 
> 
> Patch 1 updates TCP code but does not change any behavior, and creates
> some macros for reclaim thresholds that will be reused in the MPTCP
> code.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] tcp: define macros for a couple reclaim thresholds
    https://git.kernel.org/netdev/net-next/c/5823fc96d754
  - [net-next,2/4] net: introduce sk_forward_alloc_get()
    https://git.kernel.org/netdev/net-next/c/292e6077b040
  - [net-next,3/4] mptcp: allocate fwd memory separately on the rx and tx path
    https://git.kernel.org/netdev/net-next/c/6511882cdd82
  - [net-next,4/4] mptcp: drop unused sk in mptcp_push_release
    https://git.kernel.org/netdev/net-next/c/b8e0def397d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


