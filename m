Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1220035D3D7
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344060AbhDLXUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243377AbhDLXU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 19:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0283A61042;
        Mon, 12 Apr 2021 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618269610;
        bh=R7LZJ0bz6hN5ntE8kWtaGizsiQpP92lVCtyRQTxNMAA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EMH5G0doq6n5LIEENeCCoQvTEmFWuUQ/ttpAOE0Izx5KX30eCo7pK/K+sgGxWsOQu
         HYnl37IGv9yU8TY1oHO+3MW/Fi9Ep6ScZGX2l6ruqjOC4N7eR2t2UmBsfUYSJ79Rkr
         jJUK4irnBtV6WMJTBBJsnheFU7+VktQ486U1/+Jh2U9BZU9jSPw8hEOAu16okPJ9Dw
         goaS3tk0fQeHMvJ89yzxitKYT7CgBI0JJ4Mp9YhMnHUv4oUmxORwn6rNFWHnY4Rx7C
         XLnmxmHc+UT0q4L1Ul1ME082K6UWttk6VXNOtu9pltozSfTKLKDPB1HkA7bfhU6poe
         OlxYoI/MwoIOA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E4B2D60CCF;
        Mon, 12 Apr 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] netfilter: flowtable: fix NAT IPv6 offload mangling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161826960993.11202.9189060537973250262.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 23:20:09 +0000
References: <20210412223059.20841-2-pablo@netfilter.org>
In-Reply-To: <20210412223059.20841-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 13 Apr 2021 00:30:53 +0200 you wrote:
> Fix out-of-bound access in the address array.
> 
> Fixes: 5c27d8d76ce8 ("netfilter: nf_flow_table_offload: add IPv6 support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_flow_table_offload.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net,1/7] netfilter: flowtable: fix NAT IPv6 offload mangling
    https://git.kernel.org/netdev/net/c/0e07e25b481a
  - [net,2/7] netfilter: conntrack: do not print icmpv6 as unknown via /proc
    https://git.kernel.org/netdev/net/c/fbea31808ca1
  - [net,3/7] netfilter: nft_limit: avoid possible divide error in nft_limit_init
    https://git.kernel.org/netdev/net/c/b895bdf5d643
  - [net,4/7] netfilter: bridge: add pre_exit hooks for ebtable unregistration
    https://git.kernel.org/netdev/net/c/7ee3c61dcd28
  - [net,5/7] netfilter: arp_tables: add pre_exit hook for table unregister
    https://git.kernel.org/netdev/net/c/d163a925ebbc
  - [net,6/7] netfilter: x_tables: fix compat match/target pad out-of-bound write
    https://git.kernel.org/netdev/net/c/b29c457a6511
  - [net,7/7] netfilter: nftables: clone set element expression template
    https://git.kernel.org/netdev/net/c/4d8f9065830e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


