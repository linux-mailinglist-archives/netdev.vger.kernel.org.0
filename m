Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D3F41314E
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhIUKLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231560AbhIUKLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 06:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1127A61168;
        Tue, 21 Sep 2021 10:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632219009;
        bh=aZFYOL/rso75rMq1lBkAHmhorE6xRdvah6ZfFNb3UiY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HrNG5KB6p2UfhCZeI8SC040lYzKOQDbi939cUq53PQLwbhmFCiEWg1FX1WvQcEdna
         aT7M6AlKrT0ffJcasznSvnYBP15NfROutDG0uSUZVtLNGbdcpuKjWGEQ4OcvQGb9fA
         yqf6iF47+67sb/f9+8Pq0Juz9guQ4exxxqHfrTXlJ409e0Ld9+eYeHfb/DFf5bpfcN
         hjo1FUD0cT4dTXL1bEUIDsQLB3UH2aFxkNR3lnRjTrZWkKmgevQOYfr5hIwvKQYurJ
         wj67Muxr/ge2qHA1REtcuXaKfhDWWQCpGQtFGGMXWnQeDCGw6fopRSTMAAZcK99D66
         R8yHUeYQxLMoA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0B23860A7C;
        Tue, 21 Sep 2021 10:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] net/ipv4/sysctl_net_ipv4.c: remove superfluous
 header files from sysctl_net_ipv4.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163221900904.14288.5816993289291693603.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Sep 2021 10:10:09 +0000
References: <20210921074751.6182-1-liumh1@shanghaitech.edu.cn>
In-Reply-To: <20210921074751.6182-1-liumh1@shanghaitech.edu.cn>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 21 Sep 2021 15:47:51 +0800 you wrote:
> sysctl_net_ipv4.c hasn't use any macro or function declared in igmp.h,
> inetdevice.h, mm.h, module.h, nsproxy.h, swap.h, inet_frag.h, route.h
> and snmp.h. Thus, these files can be removed from sysctl_net_ipv4.c
> safely without affecting the compilation of the net module.
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> [...]

Here is the summary with links:
  - [-next,v2] net/ipv4/sysctl_net_ipv4.c: remove superfluous header files from sysctl_net_ipv4.c
    https://git.kernel.org/netdev/net-next/c/07b855628c22

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


