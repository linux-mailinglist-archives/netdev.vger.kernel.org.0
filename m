Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D1C6A0267
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 06:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbjBWFkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 00:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBWFkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 00:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F40925946;
        Wed, 22 Feb 2023 21:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B69AB818F2;
        Thu, 23 Feb 2023 05:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B57B0C4339B;
        Thu, 23 Feb 2023 05:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677130818;
        bh=XbhHPgXv/0qCSAofz6j37Q1zqlXNQJ/228qdd6aKSzo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gDO0p/BYkdCAKLGYLWKPmyNUYf045i06fFQMBQfunEsAjT3G6rgQXHMRvrKPcflKi
         EYWQdW2ungSZOxP6kEoyDv9V3uPt1P9pv4uOR5OFPWrCDh5BEmAPEWXhmR6BpRCWLv
         ClJ/wHVlNXLbUJ9u7C/C+D4mBgZ/uk96i0N6y5nrkQt+yePTlRu8FRqHyPeQhWHweB
         FhtXESVuyXxqBTITDVM0Lr+Z5zhNxbCvpqAgeXcr2j1Jnb9K5EmVr9uW02f/hVgseE
         WGxs6Dl8ZL4s8k9u9ZN5VQ9P+z3igiar9XrGrveEbpqpAIXH5k7IEnbffl3DhhUp6+
         Keev3PSEklMFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93C82E270CF;
        Thu, 23 Feb 2023 05:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: nf_tables: allow to fetch set elements
 when table has an owner
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167713081859.3934.13685548895471250126.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Feb 2023 05:40:18 +0000
References: <20230222092137.88637-2-pablo@netfilter.org>
In-Reply-To: <20230222092137.88637-2-pablo@netfilter.org>
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

On Wed, 22 Feb 2023 10:21:30 +0100 you wrote:
> NFT_MSG_GETSETELEM returns -EPERM when fetching set elements that belong
> to table that has an owner. This results in empty set/map listing from
> userspace.
> 
> Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: nf_tables: allow to fetch set elements when table has an owner
    https://git.kernel.org/netdev/net/c/92f3e96d642f
  - [net,2/8] netfilter: ctnetlink: fix possible refcount leak in ctnetlink_create_conntrack()
    https://git.kernel.org/netdev/net/c/ac4893980bbe
  - [net,3/8] netfilter: conntrack: fix rmmod double-free race
    https://git.kernel.org/netdev/net/c/e6d57e9ff0ae
  - [net,4/8] netfilter: ip6t_rpfilter: Fix regression with VRF interfaces
    https://git.kernel.org/netdev/net/c/efb056e5f1f0
  - [net,5/8] netfilter: ebtables: fix table blob use-after-free
    https://git.kernel.org/netdev/net/c/e58a171d35e3
  - [net,6/8] netfilter: xt_length: use skb len to match in length_mt6
    https://git.kernel.org/netdev/net/c/05c07c0c6cc8
  - [net,7/8] netfilter: ctnetlink: make event listener tracking global
    https://git.kernel.org/netdev/net/c/fdf6491193e4
  - [net,8/8] netfilter: x_tables: fix percpu counter block leak on error path when creating new netns
    https://git.kernel.org/netdev/net/c/0af8c09c8968

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


