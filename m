Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1951F65BD01
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbjACJUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236974AbjACJUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5185E093;
        Tue,  3 Jan 2023 01:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAA7E61225;
        Tue,  3 Jan 2023 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A783C433EF;
        Tue,  3 Jan 2023 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672737617;
        bh=6QgKqylJ+5BN+0NqWZtdwbppn3nOLhfI3IAnachdJiU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y6tPZLlQLEQ9BgqWu0O/xBi+wSLsc5bLYO0UA+sMtbs6OBmCbzB2JQ6aSNpfPASCf
         hEnCIALcsV7fNbxWUyGJVLFuaEZzoutl+foqJmbWycwZiyb4Ja/hPf8AiEacDhbzop
         7E5IYjfh21zkysdb/LHtII/czSBWVenw5NbYwx3iRBm4zcaivTfoRQrhkjNjidSMt6
         wJKds3EUbSE18H/pWquH4AJz+wGaimjGFEYQP6xnFQlB/oBEXm6FvsnYT+WX3oCkHH
         ZIZyhS/UpHb/4tPiPXGHMHuFXUf/aWYu9tlxShjbWgjBYz9eMnRypS99laOuclAQRl
         mUpXBVUJVV9vg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13C4DE5724E;
        Tue,  3 Jan 2023 09:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] netfilter: conntrack: fix ipv6 exthdr error check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167273761707.18098.539724287702844656.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Jan 2023 09:20:17 +0000
References: <20230102164025.125995-2-pablo@netfilter.org>
In-Reply-To: <20230102164025.125995-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon,  2 Jan 2023 17:40:19 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> smatch warnings:
> net/netfilter/nf_conntrack_proto.c:167 nf_confirm() warn: unsigned 'protoff' is never less than zero.
> 
> We need to check if ipv6_skip_exthdr() returned an error, but protoff is
> unsigned.  Use a signed integer for this.
> 
> [...]

Here is the summary with links:
  - [net,1/7] netfilter: conntrack: fix ipv6 exthdr error check
    https://git.kernel.org/netdev/net/c/5eb119da94ac
  - [net,2/7] netfilter: nf_tables: consolidate set description
    https://git.kernel.org/netdev/net/c/bed4a63ea4ae
  - [net,3/7] netfilter: nf_tables: add function to create set stateful expressions
    https://git.kernel.org/netdev/net/c/a8fe4154fa5a
  - [net,4/7] netfilter: nf_tables: perform type checking for existing sets
    https://git.kernel.org/netdev/net/c/f6594c372afd
  - [net,5/7] netfilter: nf_tables: honor set timeout and garbage collection updates
    https://git.kernel.org/netdev/net/c/123b99619cca
  - [net,6/7] netfilter: ipset: fix hash:net,port,net hang with /0 subnet
    https://git.kernel.org/netdev/net/c/a31d47be64b9
  - [net,7/7] netfilter: ipset: Rework long task execution when adding/deleting entries
    https://git.kernel.org/netdev/net/c/5e29dc36bd5e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


