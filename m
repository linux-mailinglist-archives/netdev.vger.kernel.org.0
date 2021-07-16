Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFFB3CBEA8
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 23:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbhGPVoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 17:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhGPVoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 17:44:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B9E6D613F1;
        Fri, 16 Jul 2021 21:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626471677;
        bh=a4QG/vwBN54xD3dRQk+feEgOcJYHGoMBvErBwbNWf8Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WKtowTSlKvlnu9yyLjgp8s4ODUvP1rAqR1VxIdOYhDeDuL/Ck5Jw4BuH4ptGn0QyC
         6G3XgJlEvMWAZUCLgz9Txpi7iP+rAg+Nrd+bES1Of3f5ogzQtjynVINU/CCl+7hz8b
         Ehocqckpt0R5qIzmmftslkAFHbA16tb90SFn6ixN8cPfWCqyaxJJA7YLhAdyVWZT8I
         mTog1iKMZJCyZgb7cKi1LiaFdgCo/mow4sKZKY3vwlmVJJKIbrajVgZaRzh38qcU+N
         vi2uNuqQe/uM64LnLdpZjoFvUxnEl6OqxU0+raEEdVXN9akjQZE1riDYFvfiPdeJQ0
         tQ8foLbQbBXUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AEEAC609EA;
        Fri, 16 Jul 2021 21:41:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: decnet: Fix sleeping inside in af_decnet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162647167770.767.8656877264744231343.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 21:41:17 +0000
References: <20210714091320.20718-1-yajun.deng@linux.dev>
In-Reply-To: <20210714091320.20718-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        matthieu.baerts@tessares.net, usuraj35@gmail.com,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Jul 2021 17:13:20 +0800 you wrote:
> The release_sock() is blocking function, it would change the state
> after sleeping. use wait_woken() instead.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/decnet/af_decnet.c | 27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)

Here is the summary with links:
  - net: decnet: Fix sleeping inside in af_decnet
    https://git.kernel.org/netdev/net/c/5f119ba1d577

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


