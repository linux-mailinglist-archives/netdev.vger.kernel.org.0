Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8D42F8AB1
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 03:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbhAPCUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 21:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAPCUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 21:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8AE81223C8;
        Sat, 16 Jan 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610763608;
        bh=ULJeD+lx2ZTrSsLM52KKyp4FA2k40TSvapXh40VYSnM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F9iJmUdBK+JcVe5/G9UuPv4E5SrjvVHIyQXXqSRY23qLFs9hwjT2g4N+8IhM/z3pW
         meGBRNvplHfVJF5G46U3RT4ZLgNuP4MfbZ1Un4K9UiQUPI0jHHaWbXcY1gg5JMJH6g
         /u8W2Q9oR0ahMHq9wfOQYI1aDFukRArq5fuUromUkkJ+6QxyrZtlSkbXZKbukS+6d/
         2wCGSCrHTdgVO3GLOIdFUZGxrYCJGufM7C9N0lM7LGvJo1Bf52bI/lh127n/M4r6AN
         jR32eXvRbYU4QcET4gNoH1q6GfHW+/8tr1lvX6Lq3vlmr8GfD8XhQfXIOp4ZnJoiv9
         JADKDqGs4+qWw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 800CC605AB;
        Sat, 16 Jan 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net_sched: gen_estimator: support large ewma log
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161076360851.6674.11390589895904937144.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 02:20:08 +0000
References: <20210114181929.1717985-1-eric.dumazet@gmail.com>
In-Reply-To: <20210114181929.1717985-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 14 Jan 2021 10:19:29 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot report reminded us that very big ewma_log were supported in the past,
> even if they made litle sense.
> 
> tc qdisc replace dev xxx root est 1sec 131072sec ...
> 
> [...]

Here is the summary with links:
  - [net] net_sched: gen_estimator: support large ewma log
    https://git.kernel.org/netdev/net/c/dd5e073381f2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


