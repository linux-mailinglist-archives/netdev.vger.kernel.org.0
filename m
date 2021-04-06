Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD72355F6F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245064AbhDFXaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229734AbhDFXaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CC321613A0;
        Tue,  6 Apr 2021 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617751808;
        bh=JHO+C+Eagiemn0G8v3+ve+A5LcnAn8jDCVzQBK+tUYU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G/X6JFDJ8BemJyvBKRgAMeihBkhyuEGe4nAILQdCyGzAqjdeLUtViSUQsuyyeGRI/
         m2EEPkv5VL/5tFCzixHnZy3QqTokctorzK81zhlsg8Um34jABLRJ8tu23UoO8FscUg
         bZWL8x7axQ4QqIr+m0xNDdJBQoBsQ2pgxzusw/XCqT8SHLrfx6Wxs7m+Dk+LvLc5Pf
         54MAjRF/osGF+DFCbMRNSI9WKar9C/g51w2HBM1XDqECppwl3yMXFegKqqELEp+Y+e
         4UwkSuEjizPUbMI92vR6MkDiytSNzTxLwUDl51JTzkL/fY1JqPTatSfQgtrvaMlERc
         6AzQucvtPfkkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BD26260978;
        Tue,  6 Apr 2021 23:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: increment the tmp aead refcnt before attaching it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775180876.15996.5049343066547076569.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:30:08 +0000
References: <c273cb4165a007c0125fac044def1416bd302fc7.1617677123.git.lucien.xin@gmail.com>
In-Reply-To: <c273cb4165a007c0125fac044def1416bd302fc7.1617677123.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, kuba@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com, tuong.t.lien@dektech.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  6 Apr 2021 10:45:23 +0800 you wrote:
> Li Shuang found a NULL pointer dereference crash in her testing:
> 
>   [] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
>   [] RIP: 0010:tipc_crypto_rcv_complete+0xc8/0x7e0 [tipc]
>   [] Call Trace:
>   []  <IRQ>
>   []  tipc_crypto_rcv+0x2d9/0x8f0 [tipc]
>   []  tipc_rcv+0x2fc/0x1120 [tipc]
>   []  tipc_udp_recv+0xc6/0x1e0 [tipc]
>   []  udpv6_queue_rcv_one_skb+0x16a/0x460
>   []  udp6_unicast_rcv_skb.isra.35+0x41/0xa0
>   []  ip6_protocol_deliver_rcu+0x23b/0x4c0
>   []  ip6_input+0x3d/0xb0
>   []  ipv6_rcv+0x395/0x510
>   []  __netif_receive_skb_core+0x5fc/0xc40
> 
> [...]

Here is the summary with links:
  - [net] tipc: increment the tmp aead refcnt before attaching it
    https://git.kernel.org/netdev/net/c/2a2403ca3add

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


