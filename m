Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD744E2765
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 14:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347825AbiCUNVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 09:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244257AbiCUNVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 09:21:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE56B66213;
        Mon, 21 Mar 2022 06:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34AD5B815E6;
        Mon, 21 Mar 2022 13:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7E9BC340ED;
        Mon, 21 Mar 2022 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647868813;
        bh=34o4Z0zxKc26j8YymcKkPc0hqxgfQpRNySRnkifWdWs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N1/xbhDN+JfelvbjRFwaXfOr/iWMj1AdfUaMYNySMeQQDU4wXc7Zy7YOrKgqdU2Sw
         nPdtcP7x2gi/jkZfXcLZw6ihK9GFieDsuMrHZBeu55WU8tWLMO67T0RVwMYBrGefVp
         Lk30JBIVTVPCkZA8Gkzsokz0Km7WYSi4tonzFOTXQU9ZsR5bEtQTZch1MoCsycXcNJ
         HmlMv+p7/JNJGLE73ZyzL6H3chi5IoqDo3ngyz5KU+60NRMtiAgAvWN9cJpIBQ+TOM
         gxa7mdynzXPXn5K2M4xHZ044YSzlahjMsjOKBbwqBmGVLUoXe1fDwYEJ3wI61Qt4Jl
         rqx4HKHvV4eoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E78FE6D44B;
        Mon, 21 Mar 2022 13:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/19] netfilter: conntrack: revisit gc autotuning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164786881358.18835.770956245099655767.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 13:20:13 +0000
References: <20220321123052.70553-2-pablo@netfilter.org>
In-Reply-To: <20220321123052.70553-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 21 Mar 2022 13:30:34 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> as of commit 4608fdfc07e1
> ("netfilter: conntrack: collect all entries in one cycle")
> conntrack gc was changed to run every 2 minutes.
> 
> On systems where conntrack hash table is set to large value, most evictions
> happen from gc worker rather than the packet path due to hash table
> distribution.
> 
> [...]

Here is the summary with links:
  - [net-next,01/19] netfilter: conntrack: revisit gc autotuning
    https://git.kernel.org/netdev/net-next/c/2cfadb761d3d
  - [net-next,02/19] netfilter: conntrack: Add and use nf_ct_set_auto_assign_helper_warned()
    https://git.kernel.org/netdev/net-next/c/31d0bb9763ef
  - [net-next,03/19] netfilter: nf_tables: do not reduce read-only expressions
    https://git.kernel.org/netdev/net-next/c/b2d306542ff9
  - [net-next,04/19] netfilter: nf_tables: cancel tracking for clobbered destination registers
    https://git.kernel.org/netdev/net-next/c/34cc9e52884a
  - [net-next,05/19] netfilter: nft_ct: track register operations
    https://git.kernel.org/netdev/net-next/c/03858af0135f
  - [net-next,06/19] netfilter: nft_lookup: only cancel tracking for clobbered dregs
    https://git.kernel.org/netdev/net-next/c/e50ae445fb70
  - [net-next,07/19] netfilter: nft_meta: extend reduce support to bridge family
    https://git.kernel.org/netdev/net-next/c/aaa7b20bd4d6
  - [net-next,08/19] netfilter: nft_numgen: cancel register tracking
    https://git.kernel.org/netdev/net-next/c/4e2b29d88168
  - [net-next,09/19] netfilter: nft_osf: track register operations
    https://git.kernel.org/netdev/net-next/c/ffe6488e624e
  - [net-next,10/19] netfilter: nft_hash: track register operations
    https://git.kernel.org/netdev/net-next/c/5da03b566626
  - [net-next,11/19] netfilter: nft_immediate: cancel register tracking for data destination register
    https://git.kernel.org/netdev/net-next/c/71ef842d73f6
  - [net-next,12/19] netfilter: nft_socket: track register operations
    https://git.kernel.org/netdev/net-next/c/d77a721d212d
  - [net-next,13/19] netfilter: nft_xfrm: track register operations
    https://git.kernel.org/netdev/net-next/c/48f1910326ea
  - [net-next,14/19] netfilter: nft_tunnel: track register operations
    https://git.kernel.org/netdev/net-next/c/611580d2df1f
  - [net-next,15/19] netfilter: nft_fib: add reduce support
    https://git.kernel.org/netdev/net-next/c/3c1eb413a45b
  - [net-next,16/19] netfilter: nft_exthdr: add reduce support
    https://git.kernel.org/netdev/net-next/c/e86dbdb9d461
  - [net-next,17/19] netfilter: nf_nat_h323: eliminate anonymous module_init & module_exit
    https://git.kernel.org/netdev/net-next/c/fd4213929053
  - [net-next,18/19] netfilter: flowtable: remove redundant field in flow_offload_work struct
    https://git.kernel.org/netdev/net-next/c/bb321ed6bbaa
  - [net-next,19/19] netfilter: flowtable: pass flowtable to nf_flow_table_iterate()
    https://git.kernel.org/netdev/net-next/c/217cff36e885

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


