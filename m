Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8949488D7C
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 01:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbiAJAaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 19:30:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41966 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236630AbiAJAaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 19:30:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE114B80F3B;
        Mon, 10 Jan 2022 00:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AA5AC36AEF;
        Mon, 10 Jan 2022 00:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641774616;
        bh=QoD4KURo2A6KSv4CW1koui6V9S+KGn6YwbhbVjqntVM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u5OQstUT5PWv+fiqj8Taw5Recy7QFRNJEB0WMc7s7sMXSAKhfwZKD8VdijNWzXc4M
         zG/30sbJho853xnPi8kheCS9N5p3GYG1QCwMlcfDN9+goUbFcGjVEAEJvU39NA01+e
         Rk74unXcFqK76Zazd+NBZFLbptZywsl0FZn1qFZHl01GtT3cxGxNJOZ0ZqIDytmKi9
         LerRmKf92P8gCLlWqzbvAOgpWYUOo4Gi7tzpzRsSwnwLmdSf/61HN+3F/CXG9KFOFi
         T1zicuXM/PSoyeTkVK+XCRKVvPPUp/kaPatcLZ3ecAaFqHWDp/ncHceqd5ETNOQnN8
         j8Kc3vPG95/ag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78B86F6078E;
        Mon, 10 Jan 2022 00:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/32] netfilter: nfnetlink: add netns refcount
 tracker to struct nfulnl_instance
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177461648.5269.3129860481078933201.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 00:30:16 +0000
References: <20220109231640.104123-2-pablo@netfilter.org>
In-Reply-To: <20220109231640.104123-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 10 Jan 2022 00:16:09 +0100 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> If compiled with CONFIG_NET_NS_REFCNT_TRACKER=y,
> using put_net_track() in nfulnl_instance_free_rcu()
> and get_net_track() in instance_create()
> might help us finding netns refcount imbalances.
> 
> [...]

Here is the summary with links:
  - [net-next,01/32] netfilter: nfnetlink: add netns refcount tracker to struct nfulnl_instance
    https://git.kernel.org/netdev/net-next/c/a9382d9389a0
  - [net-next,02/32] netfilter: nf_nat_masquerade: add netns refcount tracker to masq_dev_work
    https://git.kernel.org/netdev/net-next/c/fc0d026a2fad
  - [net-next,03/32] netfilter: nf_tables: remove rcu read-size lock
    https://git.kernel.org/netdev/net-next/c/0d1873a52289
  - [net-next,04/32] netfilter: nft_payload: WARN_ON_ONCE instead of BUG
    https://git.kernel.org/netdev/net-next/c/8801d791b487
  - [net-next,05/32] netfilter: nf_tables: consolidate rule verdict trace call
    https://git.kernel.org/netdev/net-next/c/4765473fefd4
  - [net-next,06/32] netfilter: nf_tables: replace WARN_ON by WARN_ON_ONCE for unknown verdicts
    https://git.kernel.org/netdev/net-next/c/690d541739a3
  - [net-next,07/32] netfilter: nf_tables: make counter support built-in
    https://git.kernel.org/netdev/net-next/c/023223dfbfb3
  - [net-next,08/32] netfilter: conntrack: tag conntracks picked up in local out hook
    https://git.kernel.org/netdev/net-next/c/4a6fbdd801e8
  - [net-next,09/32] netfilter: nat: force port remap to prevent shadowing well-known ports
    https://git.kernel.org/netdev/net-next/c/878aed8db324
  - [net-next,10/32] netfilter: flowtable: remove ipv4/ipv6 modules
    https://git.kernel.org/netdev/net-next/c/c42ba4290b21
  - [net-next,11/32] netfilter: nft_set_pipapo_avx2: remove redundant pointer lt
    https://git.kernel.org/netdev/net-next/c/2b71e2c7b56c
  - [net-next,12/32] netfilter: conntrack: Use max() instead of doing it manually
    https://git.kernel.org/netdev/net-next/c/613a0c67d12f
  - [net-next,13/32] netfilter: conntrack: convert to refcount_t api
    https://git.kernel.org/netdev/net-next/c/719774377622
  - [net-next,14/32] netfilter: core: move ip_ct_attach indirection to struct nf_ct_hook
    https://git.kernel.org/netdev/net-next/c/3fce16493dc1
  - [net-next,15/32] netfilter: make function op structures const
    https://git.kernel.org/netdev/net-next/c/285c8a7a5815
  - [net-next,16/32] netfilter: conntrack: avoid useless indirection during conntrack destruction
    https://git.kernel.org/netdev/net-next/c/6ae7989c9af0
  - [net-next,17/32] net: prefer nf_ct_put instead of nf_conntrack_put
    https://git.kernel.org/netdev/net-next/c/408bdcfce8df
  - [net-next,18/32] netfilter: egress: avoid a lockdep splat
    https://git.kernel.org/netdev/net-next/c/6316136ec6e3
  - [net-next,19/32] netfilter: nft_connlimit: move stateful fields out of expression data
    https://git.kernel.org/netdev/net-next/c/37f319f37d90
  - [net-next,20/32] netfilter: nft_last: move stateful fields out of expression data
    https://git.kernel.org/netdev/net-next/c/33a24de37e81
  - [net-next,21/32] netfilter: nft_quota: move stateful fields out of expression data
    https://git.kernel.org/netdev/net-next/c/ed0a0c60f0e5
  - [net-next,22/32] netfilter: nft_numgen: move stateful fields out of expression data
    https://git.kernel.org/netdev/net-next/c/567882eb3d44
  - [net-next,23/32] netfilter: nft_limit: rename stateful structure
    https://git.kernel.org/netdev/net-next/c/369b6cb5d391
  - [net-next,24/32] netfilter: nft_limit: move stateful fields out of expression data
    https://git.kernel.org/netdev/net-next/c/3b9e2ea6c11b
  - [net-next,25/32] netfilter: nf_tables: add rule blob layout
    https://git.kernel.org/netdev/net-next/c/2c865a8a28a1
  - [net-next,26/32] netfilter: nf_tables: add NFT_REG32_NUM
    https://git.kernel.org/netdev/net-next/c/642c8eff5c60
  - [net-next,27/32] netfilter: nf_tables: add register tracking infrastructure
    https://git.kernel.org/netdev/net-next/c/12e4ecfa244b
  - [net-next,28/32] netfilter: nft_payload: track register operations
    https://git.kernel.org/netdev/net-next/c/a7c176bf9f0e
  - [net-next,29/32] netfilter: nft_meta: track register operations
    https://git.kernel.org/netdev/net-next/c/9b17afb2c88b
  - [net-next,30/32] netfilter: nft_bitwise: track register operations
    https://git.kernel.org/netdev/net-next/c/be5650f8f47e
  - [net-next,31/32] netfilter: nft_payload: cancel register tracking after payload update
    https://git.kernel.org/netdev/net-next/c/cc003c7ee609
  - [net-next,32/32] netfilter: nft_meta: cancel register tracking after meta update
    https://git.kernel.org/netdev/net-next/c/4a80e026981b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


