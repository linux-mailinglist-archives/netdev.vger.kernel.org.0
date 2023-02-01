Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35038685EE8
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjBAFaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjBAFaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:30:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2969F2DE64;
        Tue, 31 Jan 2023 21:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7861E610E8;
        Wed,  1 Feb 2023 05:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8354C4339B;
        Wed,  1 Feb 2023 05:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675229419;
        bh=tdL9mzUJ8Bz1xnGM9murtqJVhZLpKpHYDB6K5/aBfOY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vy2EEwpUsqXIShfkJ21K+JHmeizBZX/PUBgg7i9BsQhP2PhzHmVF+LsFA0d7jmVz9
         Rs/5XR2kK+zHjHcLzaeF4e4U0UK9Fn4MRFc1mx2MnzberYdhFRWkk/0axqUjoRfz38
         CeUR7ttlrIbRqtStpAHe2K1pOKfeWuki25KhAd/XRyHeBz6Nt3M9FYCbnUFyFSenKs
         iU2+qe9GPYfuIqWLUFjRKtYYifQdKeKKK5XEjDBh3mXz0SbVYRBwFtna/ysIg/D5OK
         D27SzbIvhZC06xcTsiLciiTLpp416WQK9aDrAWo6BRraGsLnV5kTAd5c0JrgANkOLD
         VrocVcqhmOy+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB237E21EEC;
        Wed,  1 Feb 2023 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: br_netfilter: disable sabotage_in hook
 after first suppression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167522941969.3755.300708187812071635.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 05:30:19 +0000
References: <20230131133158.4052-2-pablo@netfilter.org>
In-Reply-To: <20230131133158.4052-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 31 Jan 2023 14:31:57 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> When using a xfrm interface in a bridged setup (the outgoing device is
> bridged), the incoming packets in the xfrm interface are only tracked
> in the outgoing direction.
> 
> $ brctl show
> bridge name     interfaces
> br_eth1         eth1
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: br_netfilter: disable sabotage_in hook after first suppression
    https://git.kernel.org/netdev/net/c/2b272bb558f1
  - [net,2/2] Revert "netfilter: conntrack: fix bug in for_each_sctp_chunk"
    https://git.kernel.org/netdev/net/c/bd0e06f0def7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


