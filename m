Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E2D3DED30
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhHCLuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235549AbhHCLuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6921E60F35;
        Tue,  3 Aug 2021 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991406;
        bh=M2o3Ah9SMsWpUTDqUTuSQ8RNoFUL9F1PzuQkHYD3NkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZHejh+YwXfXu9WlXCV64etVryTr34HfIoPzonHqOd28QcaSZuAZR8IPLQbxXW8+Xe
         MS62+cwkvrZlRmTGbhIqC/AsfWGkI6y2VeBap/c+axs1UF60PoNsociwZ+vL+YTT8N
         RL7sFH/TPzNlwQFGGHZAP/9yvf2P1K+EtgDDilT1+2LT3EkO/bmqbZ71g3bnpMi7Xh
         oMwZKKqp8VT/FNRVX6nAp+QZokzoCCap2OTgUF8N2mpXbh/JnOZV5Sr8BvP4NjuHMA
         0zLNBQdG4a7cuJ8k7LfYbdhhdhhGP7vaRfljW3VRNJzA3578vbZNeQ92WqSzYO22pZ
         H6ySeB/wyJhtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5EBCC60A6A;
        Tue,  3 Aug 2021 11:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] virtio-net: realign page_to_skb() after merges
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162799140638.31863.5292721687964827323.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 11:50:06 +0000
References: <20210802175729.2042133-1-kuba@kernel.org>
In-Reply-To: <20210802175729.2042133-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        xuanzhuo@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  2 Aug 2021 10:57:29 -0700 you wrote:
> We ended up merging two versions of the same patch set:
> 
> commit 8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")
> commit 5c37711d9f27 ("virtio-net: fix for unable to handle page fault for address")
> 
> into net, and
> 
> [...]

Here is the summary with links:
  - [net-next] virtio-net: realign page_to_skb() after merges
    https://git.kernel.org/netdev/net-next/c/c32325b8fdf2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


