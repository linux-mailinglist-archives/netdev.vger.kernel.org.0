Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37ECC339886
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbhCLUk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:40:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234758AbhCLUkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 15:40:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6AA2E64F80;
        Fri, 12 Mar 2021 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615581608;
        bh=zUnBh1LJXDjvo1lRxiLrNImJ/t1xjRJUFEl0/aSLkrU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MY7zdqhntJ7wZZVnND17NSxNE7cWTqJhRRts16H2HAluTAdZLtmyVYHcSTpUw1nXE
         VR3C2Hk6cLvi1rK1A1lmRvMejsJ4PZJNAKRcLQM0DZ6jaS+IWr3EXQ7D6L4o/gfUb/
         dUbPEPXhMultCHS0h7cla6qdIDDdRKYiy5JRLhNBNU110d6DDR7SENa/F3vbiK8/0x
         keF7/qJzinKjTC2kIpy1dtXVEd2o+OuwgpurTq/8Lo1M2DoAoyhBSKaqLkKx2u7mi3
         gDYafrkD/NFtqUl3LpxuaSHwoj2D/9+HsNHrste6Yi0dZla9DVKRskxy2ff3kQezIm
         Jiax1w7p23geQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 619C5609E7;
        Fri, 12 Mar 2021 20:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] tcp: better deal with delayed TX completions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161558160839.26333.8175306349376028801.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 20:40:08 +0000
References: <20210311203506.3450792-1-eric.dumazet@gmail.com>
In-Reply-To: <20210311203506.3450792-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, ncardwell@google.com, ycheng@google.com,
        ntspring@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 12:35:03 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Jakub and Neil reported an increase of RTO timers whenever
> TX completions are delayed a bit more (by increasing
> NIC TX coalescing parameters)
> 
> While problems have been there forever, second patch might
> introduce some regressions so I prefer not backport
> them to stable releases before things settle.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] tcp: plug skb_still_in_host_queue() to TSQ
    https://git.kernel.org/netdev/net-next/c/f4dae54e486d
  - [net-next,2/3] tcp: consider using standard rtx logic in tcp_rcv_fastopen_synack()
    https://git.kernel.org/netdev/net-next/c/a7abf3cd76e1
  - [net-next,3/3] tcp: remove obsolete check in __tcp_retransmit_skb()
    https://git.kernel.org/netdev/net-next/c/ac3959fd0dcc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


