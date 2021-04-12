Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90F735CA3D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbhDLPk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242847AbhDLPk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 11:40:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5D1C461362;
        Mon, 12 Apr 2021 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618242009;
        bh=0FNWF2f7ojL+5qr6sp6WYba6r6Kpsk8delYYW2j1REI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jBABLOCk0C/s8IP7asrzC/C7T+OrBOZGrgkXx6Yo8Pij4WLkCGhqgZGqP2KwBghwU
         1ME59bHRm9cecIfqxWIYV1gooIMCi8P509LLmpkr2Dzp7CMBwob4yWi0ivHJ4Dls+d
         90QtwL0I/y3fjKCTS1DvcwFK0hn2L5KFruiwZCGfeq8fN95iBAl4G7JH1t04PZAykN
         D90H5m3WkHeWspuZvMbxFz+S6LrKOnlY4thIaZFp/Jif5OjbcnZRsskotmYp34dVDo
         VnbecVd8be6PLSasTjv1dSggwtlrh5DjJpjzhtqflsckXK3fa1EasAxoFSUuxT3Xv2
         uCDl4qE9kMCXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5525360A22;
        Mon, 12 Apr 2021 15:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch bpf-next] skmsg: pass psock pointer to
 ->psock_update_sk_prot()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161824200934.5298.13769733038332592467.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 15:40:09 +0000
References: <20210407032111.33398-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210407032111.33398-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com,
        syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com,
        john.fastabend@gmail.com, edumazet@google.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue,  6 Apr 2021 20:21:11 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Using sk_psock() to retrieve psock pointer from sock requires
> RCU read lock, but we already get psock pointer before calling
> ->psock_update_sk_prot() in both cases, so we can just pass it
> without bothering sk_psock().
> 
> [...]

Here is the summary with links:
  - [bpf-next] skmsg: pass psock pointer to ->psock_update_sk_prot()
    https://git.kernel.org/bpf/bpf-next/c/51e0158a5432

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


