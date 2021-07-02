Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B383BA4BE
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 22:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhGBUmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 16:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhGBUmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 16:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B9D8461411;
        Fri,  2 Jul 2021 20:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625258404;
        bh=OyQZy/I8dxoOQfJEI6phs2UUBiK8Qq73CK6aBW7MdtU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NnEDHsRQKVQkfreAcKtvD94Vj18WnvdUliS/0J73Iq5xK9DVo7T7BwcY8R4X2KWd5
         KrA24F4DZyjPDNMXAAsY+TNXr0DhJWeLRPLNTL6FykksDnTd70QR45iQdx4WQQ1w7y
         uj0yWT2bFd5WruIc3Ye+UkJ+MAD3peuNVntZU2aX2+w0JaULAi5G0IA59R0dVbkZ9W
         wov/ZEfwhG0xKRjFTQ2H33N7WvdkPHwrWOv4I0v5HndZN8Pl3TVWoS2o5400wMkfYI
         7bIBsN5hnc5HzJF9WJsY4zfOJ8jM72k1bxv4LbUWsMkCxVwv33+86UApYFxwIVu/nT
         dmyU+xAXMb6Zg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AD3B260A56;
        Fri,  2 Jul 2021 20:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: bridge: sync fdb to new unicast-filtering ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162525840470.26489.12119463597617944366.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Jul 2021 20:40:04 +0000
References: <20210702120736.3746-1-w.bumiller@proxmox.com>
In-Reply-To: <20210702120736.3746-1-w.bumiller@proxmox.com>
To:     Wolfgang Bumiller <w.bumiller@proxmox.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net, nikolay@nvidia.com,
        roopa@nvidia.com, vyasevic@redhat.com, mst@redhat.com,
        t.lamprecht@proxmox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  2 Jul 2021 14:07:36 +0200 you wrote:
> Since commit 2796d0c648c9 ("bridge: Automatically manage
> port promiscuous mode.")
> bridges with `vlan_filtering 1` and only 1 auto-port don't
> set IFF_PROMISC for unicast-filtering-capable ports.
> 
> Normally on port changes `br_manage_promisc` is called to
> update the promisc flags and unicast filters if necessary,
> but it cannot distinguish between *new* ports and ones
> losing their promisc flag, and new ports end up not
> receiving the MAC address list.
> 
> [...]

Here is the summary with links:
  - [v3] net: bridge: sync fdb to new unicast-filtering ports
    https://git.kernel.org/netdev/net/c/a019abd80220

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


