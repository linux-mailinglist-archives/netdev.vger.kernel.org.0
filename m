Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACBC4590BF
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbhKVPDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:03:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239830AbhKVPDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DBE4760F90;
        Mon, 22 Nov 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637593209;
        bh=BQMUYfgxvHuKhtHTvckVjjDJIIVI3WAO5M2thersOks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h+e/TqlnTlsTY1Q747KrbzYdM3woqO3AcWUEdWJersSkR17wursekjGXvKj/Onw2S
         nkKqDu5cONvVIaziUE96iB9ZRrYgxKumHWSs1Tv0sJgUv9fU1YmOYisX3X2pJitTJd
         34s/6rImBj9obFWr7KzDAg0Qz1uh10NoQRGbXVE3g1GRjr6+Rc29GBuXY2Ye+i9hOH
         CW8uOphAhlf6mr+dXmeaBd/GWQnjfkj5zWTNZREh930s4GBeJ1SPT8aMMdAtZ06aZv
         Z0W47O2ZAQ9EtB2Vm8sq23VbZCzYqCYh6dznMJhvBKatDTb97g/K2KN+iNCEsNzdo4
         9aoRmnecdXwtA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D1E6160AA4;
        Mon, 22 Nov 2021 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net-sysfs: Slightly optimize 'xps_queue_show()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759320985.11926.1138967261274770267.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 15:00:09 +0000
References: <498b1a0a7a0cba019c9d95693cd489827168b79e.1637517554.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <498b1a0a7a0cba019c9d95693cd489827168b79e.1637517554.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, atenart@kernel.org,
        alexanderduyck@fb.com, pabeni@redhat.com, weiwan@google.com,
        lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 21 Nov 2021 19:01:03 +0100 you wrote:
> The 'mask' bitmap is local to this function. So the non-atomic
> '__set_bit()' can be used to save a few cycles.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/core/net-sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net-sysfs: Slightly optimize 'xps_queue_show()'
    https://git.kernel.org/netdev/net-next/c/08a7abf4aff1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


