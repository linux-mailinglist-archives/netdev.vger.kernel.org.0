Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624613A36AC
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFJVwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhFJVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E8A1D61410;
        Thu, 10 Jun 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623361806;
        bh=LvuQsBnSe9WZnRXYiUWNOCJCvRy57VtzSJp+0CPuQm0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iSa9mRPSRaWPjpG2YS9362rndqNmqueillHBqF4iEdPmgRbhnPNOBz1dCxF/F1T+2
         eXN4ysRnY0HmwKhTK8lR6KfloULlaB8hwGt1C0ItjG/oCGLS/1KRUH61AlMQg/rtR4
         aeFdBp3YHkJOcmNEvh/QYQ/QG1l/G7u/ADMj+HTnRtawtK5UQQwv8iJpsEEnkDGPTV
         wnp7vrdTdJWa/HeWaEEPptiiNiyrrl475mEypk22qTER3B+jd/ShBaf0eDTDO8fsVX
         cSYpKZTGUe5vSPzHocJ1XNXy6u/A1GroMk3YnCstf9HQZ2Bnheiol1IGbTwthI+ycW
         7NkSkr9G/3MXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DE2D060D07;
        Thu, 10 Jun 2021 21:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nf_tables: initialize set before
 expression setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162336180590.29138.15815701768531267437.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:50:05 +0000
References: <20210610165458.23071-2-pablo@netfilter.org>
In-Reply-To: <20210610165458.23071-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 10 Jun 2021 18:54:56 +0200 you wrote:
> nft_set_elem_expr_alloc() needs an initialized set if expression sets on
> the NFT_EXPR_GC flag. Move set fields initialization before expression
> setup.
> 
> [4512935.019450] ==================================================================
> [4512935.019456] BUG: KASAN: null-ptr-deref in nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
> [4512935.019487] Read of size 8 at addr 0000000000000070 by task nft/23532
> [4512935.019494] CPU: 1 PID: 23532 Comm: nft Not tainted 5.12.0-rc4+ #48
> [...]
> [4512935.019502] Call Trace:
> [4512935.019505]  dump_stack+0x89/0xb4
> [4512935.019512]  ? nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
> [4512935.019536]  ? nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
> [4512935.019560]  kasan_report.cold.12+0x5f/0xd8
> [4512935.019566]  ? nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
> [4512935.019590]  nft_set_elem_expr_alloc+0x84/0xd0 [nf_tables]
> [4512935.019615]  nf_tables_newset+0xc7f/0x1460 [nf_tables]
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nf_tables: initialize set before expression setup
    https://git.kernel.org/netdev/net/c/ad9f151e560b
  - [net,2/3] selftests: netfilter: add fib test case
    https://git.kernel.org/netdev/net/c/82944421243e
  - [net,3/3] netfilter: nft_fib_ipv6: skip ipv6 packets from any to link-local
    https://git.kernel.org/netdev/net/c/12f36e9bf678

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


