Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746B63C2A94
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 23:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhGIVCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 17:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhGIVCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 17:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D02F56135D;
        Fri,  9 Jul 2021 21:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625864403;
        bh=8aFM6pDAK6KG6i8atHvsv+LwR+yDNpO/T59kU/u6VxI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sbeKiFqg7kqrAJHuNKuutfzwcO3kVkTT0gks11PSd7C8FygPaXJDDqIbiasbgZTII
         ygNJ6ZfGr6HyByR6hGnZjDo5jffFcR/vrKQ+cZJ6wIVVs5nQha1kMAgWELEkuFq7NC
         z+b+9hblS09gOXVhOjYkNKw8T4YEgqEEdldsrGqQnf/Sr9dZquoPaeROBqHBnJzQle
         MXFiHwUQohQOgKixhINZZ07ZOF0lG3pcKB1KW2zj0tDGzxWKe9E9htWIeLjf+V681P
         EYPcsLaOSO3UQj/uzXQOULHMyT0r16jZg7WwFpduQs8YasDBZfGm6NXPsjbQW0S0w0
         Mw3Do+T8N/UvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C3B7D60A54;
        Fri,  9 Jul 2021 21:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: validate lwtstate->data before returning from
 skb_tunnel_info()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162586440379.29766.5538397287024449704.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Jul 2021 21:00:03 +0000
References: <20210709173518.24696-1-ap420073@gmail.com>
In-Reply-To: <20210709173518.24696-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, tgraf@suug.ch, roopa@cumulusnetworks.com,
        jbenc@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Jul 2021 17:35:18 +0000 you wrote:
> skb_tunnel_info() returns pointer of lwtstate->data as ip_tunnel_info
> type without validation. lwtstate->data can have various types such as
> mpls_iptunnel_encap, etc and these are not compatible.
> So skb_tunnel_info() should validate before returning that pointer.
> 
> Splat looks like:
> BUG: KASAN: slab-out-of-bounds in vxlan_get_route+0x418/0x4b0 [vxlan]
> Read of size 2 at addr ffff888106ec2698 by task ping/811
> 
> [...]

Here is the summary with links:
  - [net] net: validate lwtstate->data before returning from skb_tunnel_info()
    https://git.kernel.org/netdev/net/c/67a9c9431740

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


