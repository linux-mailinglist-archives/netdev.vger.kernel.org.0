Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CFC6B3790
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjCJHlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjCJHks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:40:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324771086AE;
        Thu,  9 Mar 2023 23:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 917D960EE2;
        Fri, 10 Mar 2023 07:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E651EC433D2;
        Fri, 10 Mar 2023 07:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678434021;
        bh=ZdzysiwyCIYfh29jghqFM8f/yP9OfVdUcVhxhaPw43U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J2ENKcf+wYVBibVz+sEh9Quaz8a+hTfhiZueLqw97LM+0ys6hqv29Vit8BdlZ7FoJ
         amUbRHxs1M6LLJ1nkVS5/lK0UswUnb0mPk86wLi7XFVX5JjAyDEqF6Frwwj6OTsP6+
         x6qTav/wiDEyIuZ07m36HZeq/7bsD1ZEIhpcHNcPN2Byxl+1NJa2l8W4A7p2Z+IO9S
         o0SkfijbadaeCse/Rz8GXgrT4oNDC+XP2k9lYUNJmYe+ntcdaBxUL/KgWkoQlkoyv1
         wnM9b2JPUVR+PCR2jjlPEr6VLdfbCWVRQh2EbUej7EDYjhVBd/cncFEZHiaaBXwNKL
         Re8DXBjMkUzQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2732C59A4C;
        Fri, 10 Mar 2023 07:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/9] netfilter: bridge: introduce broute meta
 statement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843402079.26917.17447421405790618845.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:40:20 +0000
References: <20230308193033.13965-2-fw@strlen.de>
In-Reply-To: <20230308193033.13965-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, sriram.yagnaraman@est.tech
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed,  8 Mar 2023 20:30:25 +0100 you wrote:
> From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> 
> nftables equivalent for ebtables -t broute.
> 
> Implement broute meta statement to set br_netfilter_broute flag
> in skb to force a packet to be routed instead of being bridged.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] netfilter: bridge: introduce broute meta statement
    https://git.kernel.org/netdev/net-next/c/4386b9218577
  - [net-next,2/9] netfilter: bridge: call pskb_may_pull in br_nf_check_hbh_len
    https://git.kernel.org/netdev/net-next/c/9ccff83b1322
  - [net-next,3/9] netfilter: bridge: check len before accessing more nh data
    https://git.kernel.org/netdev/net-next/c/a7f1a2f43e68
  - [net-next,4/9] netfilter: bridge: move pskb_trim_rcsum out of br_nf_check_hbh_len
    https://git.kernel.org/netdev/net-next/c/0b24bd71a6c0
  - [net-next,5/9] netfilter: move br_nf_check_hbh_len to utils
    https://git.kernel.org/netdev/net-next/c/28e144cf5f72
  - [net-next,6/9] netfilter: use nf_ip6_check_hbh_len in nf_ct_skb_network_trim
    https://git.kernel.org/netdev/net-next/c/eaafdaa3e922
  - [net-next,7/9] selftests: add a selftest for big tcp
    https://git.kernel.org/netdev/net-next/c/6bb382bcf742
  - [net-next,8/9] netfilter: conntrack: fix typo
    https://git.kernel.org/netdev/net-next/c/e5d015a114da
  - [net-next,9/9] netfilter: nat: fix indentation of function arguments
    https://git.kernel.org/netdev/net-next/c/b0ca200077b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


