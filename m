Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD6745A271
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbhKWMXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:23:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237072AbhKWMXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:23:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 21E4761075;
        Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670012;
        bh=VBjIFxrGD9A7dcrlPZYa4W2JLZXpNX1g3hjYEmAlG9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LrKCoqzjRdMtayXI0bvfLQ8Brb7RBw9pI/QNl/u/XQd2YEuSGvXoJiRb2SC6HbKyF
         Q9EAIUnvZZMAxr6W+AW1cKLm6oHMJ3QQs/tRsz2NlpQ3h1ppazN2jB968pLCvTVwGY
         lSUqeMfa9oJaeMc3fCM5nLpUI++CDC1KfZbtB3l4t1SMYXKALXbYnKf+zBHl3MQtit
         lHbCiRwSHyeWYterEYRAfxmR+xIDT31psjrZ+/hBB4UH39zJU5NISXRZ1oexj24wmM
         8IE+E1pJJnlDWOIgVwDhoXfZ3j2e6ufXZfC28ttOR9rmoTNI8cqbHDu6GcredWptHj
         vbV2Iny02bJIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19A3B60A4E;
        Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] neigh: introduce neigh_confirm() helper function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767001210.10565.116108700872450172.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:20:12 +0000
References: <20211123025430.22254-1-yajun.deng@linux.dev>
In-Reply-To: <20211123025430.22254-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, eric.dumazet@gmail.com,
        dsahern@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Nov 2021 10:54:30 +0800 you wrote:
> Add neigh_confirm() for the confirmed member in struct neighbour,
> it can be called as an independent unit by other functions.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  include/net/arp.h       |  8 +-------
>  include/net/ndisc.h     | 16 ++--------------
>  include/net/neighbour.h | 11 +++++++++++
>  include/net/sock.h      |  5 +----
>  4 files changed, 15 insertions(+), 25 deletions(-)

Here is the summary with links:
  - [net-next,v2] neigh: introduce neigh_confirm() helper function
    https://git.kernel.org/netdev/net-next/c/1e84dc6b7bbf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


