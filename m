Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731792F9049
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 04:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbhAQDKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 22:10:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbhAQDKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 22:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EA22C22CAD;
        Sun, 17 Jan 2021 03:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610853008;
        bh=A10bUHNwPQbFfEF6e7sKvgF8uTKUzGPK6H6pqguOLXs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gmJrVA8MhNdebI4PBlg9FG7k3s5sx49iIRhbeI+azu9ciZZFvKdTj115ppo6Cz17P
         tNJWyrun2gnhHE0lXgnTIcr6cQAEuK1hKoBxBDoTVqoSNq9aij4rSzt/l8fZSzfJsl
         MtOmfc79WkFlihNaHqFc0vKko/7yHKdBg4jqQt8oCKsr8xl9ZaZPM8KZ5L/MiOwyH5
         5vdZxyrsI1k/3p9p+NfM/9CCMziMvpILUKu0QsKszKy4t2pBeDFTyZ07uaKv1Lf1vg
         CNmWpVloBBmwRFBzwP/ZeWsDmKu0W0rxT+224NAzOtY/45zuYUxD/WLxqG594Ma2Iy
         gvhZUguPtclew==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id DCDB760658;
        Sun, 17 Jan 2021 03:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] skbuff: back tiny skbs with kmalloc() in
 __netdev_alloc_skb() too
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161085300789.5035.6945893821776961084.git-patchwork-notify@kernel.org>
Date:   Sun, 17 Jan 2021 03:10:07 +0000
References: <20210115150354.85967-1-alobakin@pm.me>
In-Reply-To: <20210115150354.85967-1-alobakin@pm.me>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     davem@davemloft.net, kuba@kernel.org, willemb@google.com,
        linmiaohe@huawei.com, edumazet@google.com, fw@strlen.de,
        linyunsheng@huawei.com, steffen.klassert@secunet.com,
        gnault@redhat.com, dseok.yi@samsung.com, kyk.segfault@gmail.com,
        viro@zeniv.linux.org.uk, elver@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 15 Jan 2021 15:04:40 +0000 you wrote:
> Commit 3226b158e67c ("net: avoid 32 x truesize under-estimation for
> tiny skbs") ensured that skbs with data size lower than 1025 bytes
> will be kmalloc'ed to avoid excessive page cache fragmentation and
> memory consumption.
> However, the fix adressed only __napi_alloc_skb() (primarily for
> virtio_net and napi_get_frags()), but the issue can still be achieved
> through __netdev_alloc_skb(), which is still used by several drivers.
> Drivers often allocate a tiny skb for headers and place the rest of
> the frame to frags (so-called copybreak).
> Mirror the condition to __netdev_alloc_skb() to handle this case too.
> 
> [...]

Here is the summary with links:
  - [v2,net] skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too
    https://git.kernel.org/netdev/net/c/66c556025d68

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


