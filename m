Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C323EC2CC
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 15:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhHNNKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 09:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhHNNKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 09:10:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C134C60F51;
        Sat, 14 Aug 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628946606;
        bh=RYtYlKZDLFp/vsyM5Zof7b3UUT0n1xGo7+T9ctoG6gE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KPzlRtYLpvoV1Rrb7iAV566H9VBLlsAwapVq4Hf/ArSD35+QWvB2fdwNYKvexz2J3
         4PZVz7WuvyPBubblGnI88M322cHiLI2mqSPHP/5wOvYDa6rUT8LHXCZwHEFb6CXMxu
         JBavG65KcsQ8y2kmu3RRY+AX3fVijziCWWMCKizcHTujLvk1YYErhBbfVUVnX8UBMw
         GqZ3+iOwH9NpAz+dou09KQeAYyszwH+3nLrymSvAAp0e6+1Cpl4ckZmooCbSPMmjq7
         fWj1ey6X4OnUGm/gOhhfxSHpw7WjuU25CnnAsv+E2omku4U1Qs4uegygijLdnTQHsm
         Gj0n+oqRXs9MA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B6DAB60A9F;
        Sat, 14 Aug 2021 13:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: bridge: mcast: dump querier state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162894660674.3097.4333044818411572799.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Aug 2021 13:10:06 +0000
References: <20210813150002.673579-1-razor@blackwall.org>
In-Reply-To: <20210813150002.673579-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Aug 2021 17:59:56 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> This set adds the ability to dump the current multicast querier state.
> This is extremely useful when debugging multicast issues, we've had
> many cases of unexpected queriers causing strange behaviour and mcast
> test failures. The first patch changes the querier struct to record
> a port device's ifindex instead of a pointer to the port itself so we
> can later retrieve it, I chose this way because it's much simpler
> and doesn't require us to do querier port ref counting, it is best
> effort anyway. Then patch 02 makes the querier address/port updates
> consistent via a combination of multicast_lock and seqcount, so readers
> can only use seqcount to get a consistent snapshot of address and port.
> Patch 03 is a minor cleanup in preparation for the dump support, it
> consolidates IPv4 and IPv6 querier selection paths as they share most of
> the logic (except address comparisons of course). Finally the last three
> patches add the new querier state dumping support, for the bridge's
> global multicast context we embed the BRIDGE_QUERIER_xxx attributes
> into IFLA_BR_MCAST_QUERIER_STATE and for the per-vlan global mcast
> contexts we embed them into BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: bridge: mcast: record querier port device ifindex instead of pointer
    https://git.kernel.org/netdev/net-next/c/bb18ef8e7e18
  - [net-next,2/6] net: bridge: mcast: make sure querier port/address updates are consistent
    https://git.kernel.org/netdev/net-next/c/67b746f94ff3
  - [net-next,3/6] net: bridge: mcast: consolidate querier selection for ipv4 and ipv6
    https://git.kernel.org/netdev/net-next/c/c3fb3698f935
  - [net-next,4/6] net: bridge: mcast: dump ipv4 querier state
    https://git.kernel.org/netdev/net-next/c/c7fa1d9b1fb1
  - [net-next,5/6] net: bridge: mcast: dump ipv6 querier state
    https://git.kernel.org/netdev/net-next/c/85b410821174
  - [net-next,6/6] net: bridge: vlan: dump mcast ctx querier state
    https://git.kernel.org/netdev/net-next/c/ddc649d158c5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


