Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598B93813AE
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhENWV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhENWVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:21:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5480461440;
        Fri, 14 May 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621030810;
        bh=bN6ZhnJyMojIp9seq7zVzzHT/C7j3keiCK+LEFp2cOQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YAZEd86fnNFL+tBmNptR7uPbSwB6PZ1AlkBwQsfsdYg48WQ2cw43sdbPugnCH2umN
         KoTCz1f3EdDesA3By+NnuU2P6owvhqGZDhUhFx+Tim1BUBKYHKROWKFxvFVC0x5IxB
         I0bf5oyn+ruzdKT1YY0ErUvOZPqndfOVR1UjxyMXrFabWuF0GFwMtAs7meZhyA2Vwu
         JjHxtLnzHJoTtNNMmr39a4BilVNHXz2SuhBNG6U8rkTeFy7MxvjwgiJhsgL3wH4zbO
         fEaSBj2jRxLK1QkbQQg+t7qdAUsIhxCSFVXG1qOQd90efQqfo/d3GTRb8jAWZjC46F
         6bEcwmE4EuZZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43AD060972;
        Fri, 14 May 2021 22:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v8 0/3] fix packet stuck problem for lockless qdisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103081027.6483.17994151706527065595.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:20:10 +0000
References: <1620962221-40131-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1620962221-40131-1-git-send-email-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, olteanv@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        edumazet@google.com, weiwan@google.com, cong.wang@bytedance.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        mkl@pengutronix.de, linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com, hdanton@sina.com, jgross@suse.com,
        JKosina@suse.com, mkubecek@suse.cz, bjorn@kernel.org,
        alobakin@pm.me
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 14 May 2021 11:16:58 +0800 you wrote:
> This patchset fixes the packet stuck problem mentioned in [1].
> 
> Patch 1: Add STATE_MISSED flag to fix packet stuck problem.
> Patch 2: Fix a tx_action rescheduling problem after STATE_MISSED
>          flag is added in patch 1.
> Patch 3: Fix the significantly higher CPU consumption problem when
>          multiple threads are competing on a saturated outgoing
>          device.
> 
> [...]

Here is the summary with links:
  - [net,v8,1/3] net: sched: fix packet stuck problem for lockless qdisc
    https://git.kernel.org/netdev/net/c/a90c57f2cedd
  - [net,v8,2/3] net: sched: fix tx action rescheduling issue during deactivation
    https://git.kernel.org/netdev/net/c/102b55ee92f9
  - [net,v8,3/3] net: sched: fix tx action reschedule issue with stopped queue
    https://git.kernel.org/netdev/net/c/dcad9ee9e066

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


