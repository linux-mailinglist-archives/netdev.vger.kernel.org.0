Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E39E3D4CFE
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 11:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhGYJJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 05:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhGYJJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 05:09:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D1A5360F3A;
        Sun, 25 Jul 2021 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627206604;
        bh=QlD6/ABz2xaVs2ESNzPp5sEPCjbZndKeKh3o7mAdYfU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t005lI+oCDyZDVMfFjL25lcXEFiXQcdP4NgEsGIxqYkZgarXg7HPHE0UVsfHhnAdY
         LCznzm4T9p1PGijD28Pmertv2tJLVjIatqbNn3LDo9BDy1T1tr7OeHd7AsCT9H28IF
         jYVQo30qnpB86gOorUcu6FagGzn7/DPPYg4MspMCF2GYxpE1TneL2ujBMj58EcCGaS
         QGRu1U1NM0w5jV5Cx2QB7A+gBx9iItsqt7/RFNcVtn378uzxqSpsVIXJJ8rBMW0S8G
         6VTWjuvC/BPxrNTHGQ6BUlsew9sag2qS/v0i00f/jMOGJc71U41rYjvATaIkkXnEOh
         hWw0mdwtJnjDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C9E9C60A39;
        Sun, 25 Jul 2021 09:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tipc: fix an use-after-free issue in tipc_recvmsg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162720660482.12734.3061304983506878022.git-patchwork-notify@kernel.org>
Date:   Sun, 25 Jul 2021 09:50:04 +0000
References: <a60f2c4e9eb8cce9da01c5bd561684011f7fa7da.1627061136.git.lucien.xin@gmail.com>
In-Reply-To: <a60f2c4e9eb8cce9da01c5bd561684011f7fa7da.1627061136.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jmaloy@redhat.com, tipc-discussion@lists.sourceforge.net,
        hoang.h.le@dektech.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Jul 2021 13:25:36 -0400 you wrote:
> syzbot reported an use-after-free crash:
> 
>   BUG: KASAN: use-after-free in tipc_recvmsg+0xf77/0xf90 net/tipc/socket.c:1979
>   Call Trace:
>    tipc_recvmsg+0xf77/0xf90 net/tipc/socket.c:1979
>    sock_recvmsg_nosec net/socket.c:943 [inline]
>    sock_recvmsg net/socket.c:961 [inline]
>    sock_recvmsg+0xca/0x110 net/socket.c:957
>    tipc_conn_rcv_from_sock+0x162/0x2f0 net/tipc/topsrv.c:398
>    tipc_conn_recv_work+0xeb/0x190 net/tipc/topsrv.c:421
>    process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>    worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
> 
> [...]

Here is the summary with links:
  - [net-next] tipc: fix an use-after-free issue in tipc_recvmsg
    https://git.kernel.org/netdev/net-next/c/cc19862ffe45

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


