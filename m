Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283E33EEA4A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbhHQJuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235293AbhHQJui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 05:50:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E0D6860FD8;
        Tue, 17 Aug 2021 09:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629193805;
        bh=WQX0BCwBBi0BanWhcJOHT8kEIcG78AYiwR4T8oK12Yo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KeRd5stfjiHhaJ12hyEkdeBe3rF+Z7QpC4tji/HREixKCBJG/T8lxwONd2mTHwDX4
         3hbYBDGSSq44kPgzein7fgYut7xBFCtOZ1fq/+1DXS2d8FiGXSZzWAfaV/svuXU5V/
         +Cjql747tMR8dSQD2sK0etnEavioCZH0KsGNWZr4ioe8Oq/FDPcgEm4M+dZ1e2f/3D
         NvzjmPRh1YKTjmA0bOqB6abpohvr1th5J9vJu4UmjgO1S4v0gtMriDLXCb82y9aOrq
         vAG9v6+Nr0cj7AHS8ZFZRRDcpujcGBH3Ht3aPup6eLDsCPF7I9NJVtUXJXPrFRFZ2L
         9HxgP3UBGzmXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D0A43609CF;
        Tue, 17 Aug 2021 09:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net] virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162919380584.31873.3841510899077711786.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 09:50:05 +0000
References: <20210817080659.16223-1-jasowang@redhat.com>
In-Reply-To: <20210817080659.16223-1-jasowang@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ivan@prestigetransportation.com,
        xiangxia.m.yue@gmail.com, willemb@google.com, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Aug 2021 16:06:59 +0800 you wrote:
> Commit a02e8964eaf92 ("virtio-net: ethtool configurable LRO")
> maps LRO to virtio guest offloading features and allows the
> administrator to enable and disable those features via ethtool.
> 
> This leads to several issues:
> 
> - For a device that doesn't support control guest offloads, the "LRO"
>   can't be disabled triggering WARN in dev_disable_lro() when turning
>   off LRO or when enabling forwarding bridging etc.
> 
> [...]

Here is the summary with links:
  - [V2,net] virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
    https://git.kernel.org/netdev/net/c/dbcf24d15388

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


