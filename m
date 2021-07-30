Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED223DBC56
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 17:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbhG3PaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 11:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239198AbhG3PaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 11:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0088960F4A;
        Fri, 30 Jul 2021 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627659006;
        bh=hImccpSxL6BYwXPJskDx4goMDCok7meKnheg0QpjEKE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IysnK8TrEKI+0SPTk0/ByX37mLstDHlx101/Nv6itPlYqojAlMbubrTUUi9RE+VMO
         EwSkqLeOaSGsFBjdUWa095a90x1YEjZD1YaCM5l9rpCgGSq1QKdhgPf7ZBZopWk8+F
         qJHzd9gj6M5XBjVkW3bdZ1zymhpXgQFgbt+2pdXvaGWC+D4ZUExwyvvJvx3ztcI45l
         A4j2HxqgrrqQkyuB/JP9SAGn6M1FxviE5hweeiW4GKvn4MQdtzBtWAJkTn6+XHCeRm
         KitlPxEnn6XPJbXYT7W8cRGBtyriOoMVY1UBzPI1lxcNTIql89SZcJNWjLVUFm2wjt
         o3f24TI33U8eQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E8BD560A85;
        Fri, 30 Jul 2021 15:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: convert fib_treeref from int to refcount_t
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162765900594.32649.14140002027294915015.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Jul 2021 15:30:05 +0000
References: <20210729071350.28919-1-yajun.deng@linux.dev>
In-Reply-To: <20210729071350.28919-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 15:13:50 +0800 you wrote:
> refcount_t type should be used instead of int when fib_treeref is used as
> a reference counter,and avoid use-after-free risks.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  include/net/dn_fib.h     | 2 +-
>  include/net/ip_fib.h     | 2 +-
>  net/decnet/dn_fib.c      | 6 +++---
>  net/ipv4/fib_semantics.c | 8 ++++----
>  4 files changed, 9 insertions(+), 9 deletions(-)

Here is the summary with links:
  - net: convert fib_treeref from int to refcount_t
    https://git.kernel.org/netdev/net-next/c/79976892f7ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


