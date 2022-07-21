Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F5957C344
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 06:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiGUEK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 00:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiGUEKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 00:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6201710568;
        Wed, 20 Jul 2022 21:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16DD0B82295;
        Thu, 21 Jul 2022 04:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7458EC341C0;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658376617;
        bh=t+yhOIWAaEvGtTSnPkXsAHbiSOupM3jlGuo3tGS+c/E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SdtvX1wRZt8RAZjqFTit+eHZjl+k7RGKLCVme32c/FWS7A3ySswqQzTpnjeiTJ0G3
         maU4jsbWM4xxU6LuKKJTubMfdGxv5P+WeJlKG/uAduJfCtIWkoaPfaHWgoTsgSJn6p
         5TtKoftuDnGI+MVLq8hgG4HvKYbQz/RNl7ydFEZ0Y3ivwXxVYBe4FT52rwk09SntzD
         ezMArA9rb+fTqdZfZqURCkkt7hn+vLWfop5P2wMykucokJ4yeU2HhCra817U0x89wY
         DtV6vIibKscmam/bGKlKw1FMng1vxB/yUmnz6z9nRC1OmB3xQ9LhE/GlKgZ3QtLUMG
         MqUWN4p/gqORg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56C52D9DDDD;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH nf-next 01/18] netfilter: conntrack: use fallthrough to
 cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165837661735.25559.2663046528481309709.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 04:10:17 +0000
References: <20220720230754.209053-2-pablo@netfilter.org>
In-Reply-To: <20220720230754.209053-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 21 Jul 2022 01:07:37 +0200 you wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> These cases all use the same function. we can simplify the code through
> fallthrough.
> 
> $ size net/netfilter/nf_conntrack_core.o
> 
> [...]

Here is the summary with links:
  - [nf-next,01/18] netfilter: conntrack: use fallthrough to cleanup
    https://git.kernel.org/netdev/net-next/c/6be791561212
  - [nf-next,02/18] netfilter: conntrack: use correct format characters
    https://git.kernel.org/netdev/net-next/c/b8acd43148c0
  - [nf-next,03/18] net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
    https://git.kernel.org/netdev/net-next/c/fc54d9065f90
  - [nf-next,04/18] netfilter: nf_flow_table: count pending offload workqueue tasks
    https://git.kernel.org/netdev/net-next/c/b038177636f8
  - [nf-next,05/18] netfilter: nf_conntrack: add missing __rcu annotations
    https://git.kernel.org/netdev/net-next/c/6976890e8998
  - [nf-next,06/18] netfilter: nf_conntrack: use rcu accessors where needed
    https://git.kernel.org/netdev/net-next/c/e14575fa7529
  - [nf-next,07/18] netfilter: h323: merge nat hook pointers into one
    https://git.kernel.org/netdev/net-next/c/d3f2d0a292c2
  - [nf-next,08/18] netfilter: nft_set_bitmap: Fix spelling mistake
    https://git.kernel.org/netdev/net-next/c/f72547473fcd
  - [nf-next,09/18] netfilter: nfnetlink: add missing __be16 cast
    https://git.kernel.org/netdev/net-next/c/ec6f2ff0a398
  - [nf-next,10/18] netfilter: x_tables: use correct integer types
    https://git.kernel.org/netdev/net-next/c/168141f7e0b4
  - [nf-next,11/18] netfilter: nf_tables: use the correct get/put helpers
    https://git.kernel.org/netdev/net-next/c/d86473bf2ff3
  - [nf-next,12/18] netfilter: nf_tables: add and use BE register load-store helpers
    https://git.kernel.org/netdev/net-next/c/7278b3c1e4eb
  - [nf-next,13/18] netfilter: nf_tables: use correct integer types
    https://git.kernel.org/netdev/net-next/c/ffb3d9a30cc6
  - [nf-next,14/18] netfilter: nf_tables: move nft_cmp_fast_mask to where its used
    https://git.kernel.org/netdev/net-next/c/6b77205374fd
  - [nf-next,15/18] netfilter: nf_nat: in nf_nat_initialized(), use const struct nf_conn *
    https://git.kernel.org/netdev/net-next/c/9d2f00fb0a0c
  - [nf-next,16/18] netfilter: ipvs: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/5787db7c9053
  - [nf-next,17/18] netfilter: flowtable: prefer refcount_inc
    https://git.kernel.org/netdev/net-next/c/f02e7dc4cff8
  - [nf-next,18/18] netfilter: xt_TPROXY: remove pr_debug invocations
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


