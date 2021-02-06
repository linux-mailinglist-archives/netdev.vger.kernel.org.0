Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5D6311FE4
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 21:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhBFUUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 15:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhBFUUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 15:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A43F64E2A;
        Sat,  6 Feb 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612642808;
        bh=N+jRu8zebf2tPkNrZE21gR/d5oHuBaTsFluzx10OMuQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZBrZQEj4zvfIh3Jln3MXGM51ivOguONfjnmOxtr0wxmlLo2EKIcHx5O9+9UP5Ngh/
         rzjQACAgosRH6KEJQz9IVxdiHxd6mhCDiR39IURDPmJhmn9G+xTh65Eg1NDTUi9vw8
         449SVen/T0rL8I+OIPazXyq+z1Jb+YfiZRTGcB2bF+gdpu0tQ/TpLL+NP7hFylfAc1
         FaPuc8kXhVPlZpBZQqOue+jk9wbWQoMwajfcqGsgHBQCvjJ7SD0d0JSUjmZTfvMajG
         vTX0eqi2bJU+yQff04gBhS9Oq/vHuEymznxG7SzVNw8QsjgW+mvKdTc9wDu9iwYqLr
         x06kXaKzP5gQw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2A4ED609F7;
        Sat,  6 Feb 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] net: Avoid the memory waste in some Ethernet
 drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161264280816.16096.15077244983898630684.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 20:20:08 +0000
References: <20210204105638.1584-1-haokexin@gmail.com>
In-Reply-To: <20210204105638.1584-1-haokexin@gmail.com>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-mm@kvack.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu,  4 Feb 2021 18:56:34 +0800 you wrote:
> Hi,
> 
> v3:
>   - Adjust patch 1 and 2 according to Alexander's suggestion.
>   - Add Tested-by from Subbaraya.
>   - Add Reviewed-by from Ioana.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] mm: page_frag: Introduce page_frag_alloc_align()
    https://git.kernel.org/netdev/net-next/c/b358e2122b9d
  - [net-next,v3,2/4] net: Introduce {netdev,napi}_alloc_frag_align()
    https://git.kernel.org/netdev/net-next/c/3f6e687dff39
  - [net-next,v3,3/4] net: octeontx2: Use napi_alloc_frag_align() to avoid the memory waste
    https://git.kernel.org/netdev/net-next/c/1b041601c798
  - [net-next,v3,4/4] net: dpaa2: Use napi_alloc_frag_align() to avoid the memory waste
    https://git.kernel.org/netdev/net-next/c/d0dfbb9912d9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


