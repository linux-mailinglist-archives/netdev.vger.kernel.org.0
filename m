Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7165641F74D
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhJAWLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhJAWLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:11:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D766061AA3;
        Fri,  1 Oct 2021 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633126206;
        bh=0fdjRO3IrPUVDCCjDfphwAI8uQM+NCokASDeEoUn+n0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=stbw1PQOqjVm4zeZV8wV6TKx8M7/4JpVhIRe4XbMhoz98kR/vITsDfpMB1IUqJpnt
         z+2KtPAh3aFmhajxCghC5ByKezLHBAMH4sWqt1N4dHOYeMazUP7ZmTnAgiJan1lg4F
         DsWuI8JHfJyWuN01Lgb0eQecJb4M1kazL+U5ZMvgqv6rMfBaf+XqXQWx3J5JPj7eVi
         pIpI7mk/M8rtvW1B1JDhT8Uxy21F98RY6a8BPmviG6lUB/InofmUF8ZWt0tMHeVj1l
         ny/6jXRP4HvIi3dRhm77waUi3Zi0+D7a8API94wmfjrFt8kXi2Jkn84ldOxYzyHqsM
         eCqvKwLbvSaPQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C6A7460A69;
        Fri,  1 Oct 2021 22:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net_sched: fix NULL deref in fifo_set_limit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163312620680.1491.6092676781691638992.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 22:10:06 +0000
References: <20210930212239.3430364-1-eric.dumazet@gmail.com>
In-Reply-To: <20210930212239.3430364-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 30 Sep 2021 14:22:39 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reported another NULL deref in fifo_set_limit() [1]
> 
> I could repro the issue with :
> 
> unshare -n
> tc qd add dev lo root handle 1:0 tbf limit 200000 burst 70000 rate 100Mbit
> tc qd replace dev lo parent 1:0 pfifo_fast
> tc qd change dev lo root handle 1:0 tbf limit 300000 burst 70000 rate 100Mbit
> 
> [...]

Here is the summary with links:
  - [net] net_sched: fix NULL deref in fifo_set_limit()
    https://git.kernel.org/netdev/net/c/560ee196fe9e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


