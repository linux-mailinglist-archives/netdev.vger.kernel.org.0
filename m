Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1253CAD1E
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 21:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343847AbhGOTxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 15:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245039AbhGOTxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 15:53:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8151E61073;
        Thu, 15 Jul 2021 19:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626378608;
        bh=J8B8kyte9xYblx+j2IA/VbX3JqLwwKqd7792Ryq9GsM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=laVhtac5YmrhtPd75RW8HmVJLvjHGUzYUhXdLpnRRBiVgypCeN8QtD58MrSYX1AJp
         1A4LOHp9Y3s5lgW/W+wXYUC5u1URdz+7Em+E+pMpN8gZNWd9777eowPymkXSP6Cz7d
         EHLxqzNt62ENcWDRxUw4Z8A3aq0NAGP4Cy4hVyubiXAVIW6OItfinol5fYab1w+XKV
         T86OGWlX014zNvqz5D85XInFiTzxq28eRKXs1+YS1iA2phXRyyfS2iUUVaPncu/sYU
         d5zcXWsLYBTX2VQ9kCzQFf4+X9Hc1n7O312nBbkWvix2EENoCqwc6l6KtCHK0Hyxrs
         bXOXcKpqd7saA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 72D36609B8;
        Thu, 15 Jul 2021 19:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637860846.25047.7819900930468592075.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 19:50:08 +0000
References: <20210715080822.14575-1-justin.he@arm.com>
In-Reply-To: <20210715080822.14575-1-justin.he@arm.com>
To:     Jia He <justin.he@arm.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nd@arm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 15 Jul 2021 16:08:21 +0800 you wrote:
> Liajian reported a bug_on hit on a ThunderX2 arm64 server with FastLinQ
> QL41000 ethernet controller:
>  BUG: scheduling while atomic: kworker/0:4/531/0x00000200
>   [qed_probe:488()]hw prepare failed
>   kernel BUG at mm/vmalloc.c:2355!
>   Internal error: Oops - BUG: 0 [#1] SMP
>   CPU: 0 PID: 531 Comm: kworker/0:4 Tainted: G W 5.4.0-77-generic #86-Ubuntu
>   pstate: 00400009 (nzcv daif +PAN -UAO)
>  Call trace:
>   vunmap+0x4c/0x50
>   iounmap+0x48/0x58
>   qed_free_pci+0x60/0x80 [qed]
>   qed_probe+0x35c/0x688 [qed]
>   __qede_probe+0x88/0x5c8 [qede]
>   qede_probe+0x60/0xe0 [qede]
>   local_pci_probe+0x48/0xa0
>   work_for_cpu_fn+0x24/0x38
>   process_one_work+0x1d0/0x468
>   worker_thread+0x238/0x4e0
>   kthread+0xf0/0x118
>   ret_from_fork+0x10/0x18
> 
> [...]

Here is the summary with links:
  - qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()
    https://git.kernel.org/netdev/net/c/6206b7981a36

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


