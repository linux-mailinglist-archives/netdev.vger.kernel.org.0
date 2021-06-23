Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AD43B2158
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhFWTm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhFWTmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 15:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 14E9561185;
        Wed, 23 Jun 2021 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624477205;
        bh=qG8Dz7xCYCRaCEx8smnmPiLHy47Tu04o245/KfjoHCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PeHS3PIBlimzoxtUkiQD9NTzvuy1aWGKqZGFOvQ0I3Fa/BWA8DLFisH2/3QMAiHoo
         WTbMbuSfVjJ/Jjq9kVWFtn3XglwZc8AvbLh1zdor5FCC76vxTOl0FKN1sGXyZO+I5l
         fiVz9Ccr220pCfxJmbxYfTY2FqN0UJCe4hRfj/v3nG56GorZGZeZv8Q+QmSLBxaRHS
         9rKwNNna/UT8wHCAG90Zqumvs5dK6iqp0CeDTISRZqNJa5XMXkoayt5ZkOYCGZ8puu
         oI9fqhgMGUFWoqOz2ZYHlccRVIuUt8VOA8iimuua23SUWyYw4t6Q6s960C2cEzUIuY
         XeBztIsZ3l+hw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02C8760A02;
        Wed, 23 Jun 2021 19:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/6] netfilter: nft_exthdr: Search chunks in SCTP
 packets only
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162447720500.16324.8020996383683688261.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 19:40:05 +0000
References: <20210623170301.59973-2-pablo@netfilter.org>
In-Reply-To: <20210623170301.59973-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 23 Jun 2021 19:02:56 +0200 you wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Since user space does not generate a payload dependency, plain sctp
> chunk matches cause searching in non-SCTP packets, too. Avoid this
> potential mis-interpretation of packet data by checking pkt->tprot.
> 
> Fixes: 133dc203d77df ("netfilter: nft_exthdr: Support SCTP chunks")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] netfilter: nft_exthdr: Search chunks in SCTP packets only
    https://git.kernel.org/netdev/net-next/c/5acc44f39458
  - [net-next,2/6] netfilter: nft_extdhr: Drop pointless check of tprot_set
    https://git.kernel.org/netdev/net-next/c/06e95f0a2aa2
  - [net-next,3/6] netfilter: nf_tables: add last expression
    https://git.kernel.org/netdev/net-next/c/836382dc2471
  - [net-next,4/6] netfilter: conntrack: pass hook state to log functions
    https://git.kernel.org/netdev/net-next/c/62eec0d73393
  - [net-next,5/6] docs: networking: Update connection tracking offload sysctl parameters
    https://git.kernel.org/netdev/net-next/c/3078d964c0fe
  - [net-next,6/6] netfilter: nfnetlink_hook: fix check for snprintf() overflow
    https://git.kernel.org/netdev/net-next/c/24610ed80df6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


