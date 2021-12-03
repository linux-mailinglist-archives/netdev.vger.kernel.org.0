Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2AD467952
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381439AbhLCOXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:23:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51144 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381426AbhLCOXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:23:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D188F62B79
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 385D2C53FCE;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638541210;
        bh=lOedOwbNjB2FmumxmNS9PBnfviVvVpRt95cmgEIhG2s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B/QBit2gC8zx/KNpSvPRunlQ4ZB5KBYzeLSF4juVmkZffHSVO7mvGx4kkI0wWq+5T
         UANzt2w6lHuaOxxwcaiJiZhknIt3IqZkHmMZUc0j0VbCzo0j/ZA1/SbAQwl2C6f74P
         9jB8l3sHNfbHF+FwM9tTRR0yzi9VNU8ljKsr7W1cBl0bG06rhPizcxGoJbGBrzIfVr
         uwiIExj3It0eI3bGNR2M/CyiI1S6jkYWDVs46wt43gJiAFL1eFxYX9Vu85SZo8gIp/
         wenP+zciHMldEOfpcsvluaRp6k7MebD3wlVRqgy1ENBAnJD0+Wp4RI5WlYHokOGmdW
         HfQccz6cCFXTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1E84260A88;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] inet: use #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING
 consistently
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163854121011.27426.2448863594323346955.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 14:20:10 +0000
References: <20211202224218.269441-1-eric.dumazet@gmail.com>
In-Reply-To: <20211202224218.269441-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, kuniyu@amazon.co.jp, daniel@iogearbox.net,
        kafai@fb.com, tariqt@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  2 Dec 2021 14:42:18 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Since commit 4e1beecc3b58 ("net/sock: Add kernel config
> SOCK_RX_QUEUE_MAPPING"),
> sk_rx_queue_mapping access is guarded by CONFIG_SOCK_RX_QUEUE_MAPPING.
> 
> Fixes: 54b92e841937 ("tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] inet: use #ifdef CONFIG_SOCK_RX_QUEUE_MAPPING consistently
    https://git.kernel.org/netdev/net/c/a9418924552e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


