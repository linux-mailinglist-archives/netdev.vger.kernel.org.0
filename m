Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E727352E42C
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345508AbiETFAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236697AbiETFAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7903D14AF57;
        Thu, 19 May 2022 22:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F15C961D53;
        Fri, 20 May 2022 05:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 558ABC34100;
        Fri, 20 May 2022 05:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653022813;
        bh=jmtn27BXEgcwGfpd9ZXXmKaPubR9A2l5eZklyWAT/fI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=to6lX0oT8bXTXxqcQJJ6792hSgRKI9WUghQOWHtxF2YlLc7P1o+bK/1IRcrNT7EtA
         dr3u4o0PhEPKLewwcb/pAc7B88YB1ytxSfAdcJUiTvd60QQtCLVGKnrwQcXkMP4FZs
         yKv+n6BojZOSOaEXfwNDyPgruLpZ8wd/1UO02vuuPfugHBdQMcz8ELc4qtuoFILlJP
         XsgaYETTVIJ7ziKDAd7yOUK/a4gGiG+VuQGtCRW8tA6SBVUjAmdkTmenP0Q5OUtoXA
         Q0BG2SnlkRGvQMSOPJpdphQ+7Knwlq+MdTStvqbeXIfUn2OYKr0xyYW/0Nl61FnhlS
         ZDlUU3EfCjdag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3472EF0389D;
        Fri, 20 May 2022 05:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/11] netfilter: Use l3mdev flow key when re-routing
 mangled packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165302281321.27183.13734335483401570366.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 05:00:13 +0000
References: <20220519220206.722153-2-pablo@netfilter.org>
In-Reply-To: <20220519220206.722153-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Florian Westphal <fw@strlen.de>:

On Fri, 20 May 2022 00:01:56 +0200 you wrote:
> From: Martin Willi <martin@strongswan.org>
> 
> Commit 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif
> reset for port devices") introduces a flow key specific for layer 3
> domains, such as a VRF master device. This allows for explicit VRF domain
> selection instead of abusing the oif flow key.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] netfilter: Use l3mdev flow key when re-routing mangled packets
    https://git.kernel.org/netdev/net-next/c/2c50fc04757f
  - [net-next,02/11] netfilter: nf_conncount: reduce unnecessary GC
    https://git.kernel.org/netdev/net-next/c/d265929930e2
  - [net-next,03/11] netfilter: conntrack: remove pr_debug callsites from tcp tracker
    https://git.kernel.org/netdev/net-next/c/f74360d3440c
  - [net-next,04/11] netfilter: ctnetlink: fix up for "netfilter: conntrack: remove unconfirmed list"
    https://git.kernel.org/netdev/net-next/c/58a94a62a53f
  - [net-next,05/11] net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
    (no matching commit)
  - [net-next,06/11] netfilter: nf_flow_table: count and limit hw offloaded entries
    (no matching commit)
  - [net-next,07/11] netfilter: nf_flow_table: count pending offload workqueue tasks
    (no matching commit)
  - [net-next,08/11] netfilter: nfnetlink: fix warn in nfnetlink_unbind
    (no matching commit)
  - [net-next,09/11] netfilter: conntrack: re-fetch conntrack after insertion
    (no matching commit)
  - [net-next,10/11] netfilter: cttimeout: fix slab-out-of-bounds read in cttimeout_net_exit
    (no matching commit)
  - [net-next,11/11] netfilter: nf_tables: set element extended ACK reporting support
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


