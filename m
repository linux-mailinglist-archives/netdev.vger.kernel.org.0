Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9871A5B30F5
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 09:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiIIHxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 03:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbiIIHww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 03:52:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7B596771;
        Fri,  9 Sep 2022 00:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53887B8236A;
        Fri,  9 Sep 2022 07:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0CB60C43470;
        Fri,  9 Sep 2022 07:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662709223;
        bh=7Px0r7bQOUber1oDPazQ3nhoUpK7kSL/1s3eWNs9xI8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kz2s1uE3pxOW3kWRt8KjFimJil/Go8F7xGKlbpuVgXOsaUlX9Jpy9x/Z3i9A8yO/9
         BgwdHdq/AsFYTFOHK8KC+XwhiGdiRz1zBR5+Hut555VhpfYkwvzj6FhIln7m/CN8md
         X76UzmuvYC/tDkH586uTg6jefV8he3AlVMysJvT4IRY7mvTBaccOvbZcgb95F3pK82
         uFrZUomaayP2VfiGi9kOfWS+CN/NRr0tzfQAU2R8tGF6tHgPkgESOssePqXKerWS8B
         mkg0GtvjVxda1t8vlZGBbCeveOYp5+GzZ5kgW9kHQ02cokXFQkg6V+bWvib7ettmIT
         ZqCwu2Vaf9yfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4E59C73FF1;
        Fri,  9 Sep 2022 07:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/8] netfilter: conntrack: prepare tcp_in_window for
 ternary return value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166270922293.30497.13371085701072223276.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Sep 2022 07:40:22 +0000
References: <20220907154110.8898-2-fw@strlen.de>
In-Reply-To: <20220907154110.8898-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        pabeni@redhat.com, kuba@kernel.org, netfilter-devel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  7 Sep 2022 17:41:03 +0200 you wrote:
> tcp_in_window returns true if the packet is in window and false if it is
> not.
> 
> If its outside of window, packet will be treated as INVALID.
> 
> There are corner cases where the packet should still be tracked, because
> rulesets may drop or log such packets, even though they can occur during
> normal operation, such as overly delayed acks.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] netfilter: conntrack: prepare tcp_in_window for ternary return value
    https://git.kernel.org/netdev/net-next/c/d9a6f0d0df18
  - [net-next,2/8] netfilter: conntrack: ignore overly delayed tcp packets
    https://git.kernel.org/netdev/net-next/c/6e250dcbff1d
  - [net-next,3/8] netfilter: conntrack: remove unneeded indent level
    https://git.kernel.org/netdev/net-next/c/09a59001b0d6
  - [net-next,4/8] netfilter: conntrack: reduce timeout when receiving out-of-window fin or rst
    https://git.kernel.org/netdev/net-next/c/628d694344a0
  - [net-next,5/8] netfilter: remove NFPROTO_DECNET
    https://git.kernel.org/netdev/net-next/c/a0a4de4d897f
  - [net-next,6/8] netfilter: move from strlcpy with unused retval to strscpy
    https://git.kernel.org/netdev/net-next/c/8556bceb9c40
  - [net-next,7/8] netfilter: nat: move repetitive nat port reserve loop to a helper
    https://git.kernel.org/netdev/net-next/c/c92c27171040
  - [net-next,8/8] netfilter: nat: avoid long-running port range loop
    https://git.kernel.org/netdev/net-next/c/adda60cc2bb0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


