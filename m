Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C782243E4EF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJ1PWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhJ1PWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A464600CC;
        Thu, 28 Oct 2021 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635434407;
        bh=N9HATU/RdE4AmqtUtNfUazbOOw/U/4C+n+1rwZWqR3M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GmLOdYuLikleKZlcCAx1KQ7yp4LS57v/8nmAZGaUMgVyyD7SLxbVMnB8GdMpqCsUG
         p6rVIHTxcpQ2MYuSp1NmECD6Dwa/Dpg6BKsvwIRAVs7bM+PzFUrT5zaDsMwgdmmpfF
         5schoG4i1YxqTqib0Spta33SikleV3l/qzbEHzFtD3H7Wt022wnHT91ZDZYYwaMItU
         ngCS+xc/+dXT2aEUF9Jhp1oVVwpnbor/Vl6hyOt8gzHWywsRqvdPj0KMXXbzIyrxjO
         ZcLJ6zOCOB0yyotNpbEAdNbNHeAmptRBHY6l6+CgTDbW1I1K97mGqz4CgRa3KQkkbA
         s9BkyIwFv5jWw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1A9E060A1B;
        Thu, 28 Oct 2021 15:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: virtio: use eth_hw_addr_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163543440710.20393.2773877623899316813.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 15:20:07 +0000
References: <20211027152012.3393077-1-kuba@kernel.org>
In-Reply-To: <20211027152012.3393077-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Oct 2021 08:20:12 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.
> 
> Even though the current code uses dev->addr_len the we can switch
> to eth_hw_addr_set() instead of dev_addr_set(). The netdev is
> always allocated by alloc_etherdev_mq() and there are at least two
> places which assume Ethernet address:
>  - the line below calling eth_hw_addr_random()
>  - virtnet_set_mac_address() -> eth_commit_mac_addr_change()
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: virtio: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/f2edaa4ad5d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


