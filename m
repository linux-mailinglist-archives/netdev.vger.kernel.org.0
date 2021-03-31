Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3087B350A23
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhCaWUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhCaWUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8E3C46108F;
        Wed, 31 Mar 2021 22:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617229218;
        bh=XSmuN106aaV+AqT0mtuIsmBJ41e+6AihbKe01wfVE5M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ohlXWtl49M0T522iLujPf216eoJ0Dd2o3h4sKDNe6QyKIh9lN5a3zlYfVxgyEBcXu
         y3faM+egtBWOMef8r8Vb3zZWSDF9ji4ZPGXbGM1Djz7Km7CVJIL4ToSOL+QhORwJuZ
         bbI+P6sMpn4Jufg1up36CLg9rvS+xvXWPCV6wCPj5R1eW+6COKmu6oqkaAtfeEQV8l
         61jz2Ziy7MsZ2905iZDBleupXdcuIqLZ8SRblMIIMVZMQq3UcHvNlWivKrt03GFNXv
         KBMi++tq613P8lVE7nVJPiWrf/uZXKSIo3c7Cy6nbhUvqHpFQtT29oFdH9TcjQNGLP
         GAbEMW7bi4d3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8957760283;
        Wed, 31 Mar 2021 22:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] inet: shrink netns_ipv{4|6}
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722921855.2890.9491267738601986034.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 22:20:18 +0000
References: <20210331175213.691460-1-eric.dumazet@gmail.com>
In-Reply-To: <20210331175213.691460-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 31 Mar 2021 10:52:04 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This patch series work on reducing footprint of netns_ipv4
> and netns_ipv6. Some sysctls are converted to bytes,
> and some fields are moves to reduce number of holes
> and paddings.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] inet: shrink inet_timewait_death_row by 48 bytes
    https://git.kernel.org/netdev/net-next/c/1caf8d39c58f
  - [net-next,2/9] inet: shrink netns_ipv4 by another cache line
    https://git.kernel.org/netdev/net-next/c/490f33c4e704
  - [net-next,3/9] ipv4: convert fib_notify_on_flag_change sysctl to u8
    https://git.kernel.org/netdev/net-next/c/b2908fac5b7b
  - [net-next,4/9] ipv4: convert udp_l3mdev_accept sysctl to u8
    https://git.kernel.org/netdev/net-next/c/cd04bd022258
  - [net-next,5/9] ipv4: convert fib_multipath_{use_neigh|hash_policy} sysctls to u8
    https://git.kernel.org/netdev/net-next/c/be205fe6ec4f
  - [net-next,6/9] ipv4: convert igmp_link_local_mcast_reports sysctl to u8
    https://git.kernel.org/netdev/net-next/c/7d4b37ebb934
  - [net-next,7/9] tcp: convert tcp_comp_sack_nr sysctl to u8
    https://git.kernel.org/netdev/net-next/c/1c3289c93174
  - [net-next,8/9] ipv6: convert elligible sysctls to u8
    https://git.kernel.org/netdev/net-next/c/a6175633a2af
  - [net-next,9/9] ipv6: move ip6_dst_ops first in netns_ipv6
    https://git.kernel.org/netdev/net-next/c/0dd39d952f75

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


