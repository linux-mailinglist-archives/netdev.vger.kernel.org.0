Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4AF3E14BA
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbhHEMaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240009AbhHEMaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:30:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D783B6113C;
        Thu,  5 Aug 2021 12:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628166606;
        bh=GZ2Jy/6iEb4dlJpi73YaSiwro78S2UBi5mHHzVSZfIM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lK08tk7MATn2Ix1D3ZkfV+sMFvGtfevERIrYCQXKPcU+SABNjze9gCIgrZaflGH/v
         ThDgsKnb8A1OOAhqPorC24+fXwkLn6T5/CUk9MxQw09Pm9mdWpJa+HGN7PWqkBD5He
         uhj21FwsRmc8XY+fihxkzfcHiS7qhjFiMYwYJshI7oPCkI484FkQS62KgUXeflQXWU
         ea+WeuERTEmqwwLQAReNYqDP+uufHWhNRU+dXSbGjPZL/v/XKoDI4WMqbBylgOe+oG
         gB6ncCSnTHxmqOgo4LVf7RAgff5WuTOYL/c0pHN/X49hXGYMUgimXNfN3FibHHWfM1
         3tHlPK919RHEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD40460A88;
        Thu,  5 Aug 2021 12:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Remove redundant if statements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162816660683.5517.6056843504159587831.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 12:30:06 +0000
References: <20210805115527.19435-1-yajun.deng@linux.dev>
In-Reply-To: <20210805115527.19435-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  5 Aug 2021 19:55:27 +0800 you wrote:
> The 'if (dev)' statement already move into dev_{put , hold}, so remove
> redundant if statements.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/batman-adv/bridge_loop_avoidance.c |  6 ++----
>  net/batman-adv/distributed-arp-table.c |  3 +--
>  net/batman-adv/gateway_client.c        |  3 +--
>  net/batman-adv/multicast.c             |  9 +++------
>  net/batman-adv/originator.c            | 12 ++++--------
>  net/batman-adv/translation-table.c     |  9 +++------
>  net/can/raw.c                          |  8 ++------
>  net/core/dev.c                         |  6 ++----
>  net/core/drop_monitor.c                |  6 ++----
>  net/core/dst.c                         |  6 ++----
>  net/core/neighbour.c                   | 15 +++++----------
>  net/decnet/dn_dev.c                    |  6 ++----
>  net/decnet/dn_fib.c                    |  3 +--
>  net/decnet/dn_route.c                  | 18 ++++++------------
>  net/ethtool/netlink.c                  |  6 ++----
>  net/ieee802154/nl-phy.c                |  3 +--
>  net/ieee802154/nl802154.c              |  3 +--
>  net/ieee802154/socket.c                |  3 +--
>  net/ipv4/fib_semantics.c               |  4 +---
>  net/ipv4/icmp.c                        |  3 +--
>  net/ipv4/route.c                       |  3 +--
>  net/ipv6/addrconf.c                    |  6 ++----
>  net/ipv6/ip6mr.c                       |  3 +--
>  net/ipv6/route.c                       |  3 +--
>  net/llc/af_llc.c                       |  6 ++----
>  net/netfilter/nf_flow_table_offload.c  |  3 +--
>  net/netfilter/nf_queue.c               | 24 ++++++++----------------
>  net/netlabel/netlabel_unlabeled.c      |  6 ++----
>  net/netrom/nr_loopback.c               |  3 +--
>  net/netrom/nr_route.c                  |  3 +--
>  net/packet/af_packet.c                 | 15 +++++----------
>  net/phonet/af_phonet.c                 |  3 +--
>  net/phonet/pn_dev.c                    |  6 ++----
>  net/phonet/socket.c                    |  3 +--
>  net/sched/act_mirred.c                 |  6 ++----
>  net/smc/smc_ib.c                       |  3 +--
>  net/smc/smc_pnet.c                     |  3 +--
>  net/wireless/nl80211.c                 | 16 +++++-----------
>  net/wireless/scan.c                    |  3 +--
>  39 files changed, 82 insertions(+), 168 deletions(-)

Here is the summary with links:
  - [net-next] net: Remove redundant if statements
    https://git.kernel.org/netdev/net-next/c/1160dfa178eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


