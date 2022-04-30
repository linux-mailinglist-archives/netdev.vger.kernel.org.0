Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D09515E23
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 16:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382828AbiD3OXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 10:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382832AbiD3OXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 10:23:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F334BE37
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 07:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E47B860F47
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 455A5C385AF;
        Sat, 30 Apr 2022 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651328411;
        bh=5f0obqavuUlsI7KnESCYMoAZ/Egm/IqXrRp1awe0cYU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cuE1YqU7Hwe7TKpqtT5+JUmH/i8fr3YCEzWAa5XKrukTI7fLqhJcIgn+W+YiV39Az
         iAHo4h9cvdVST/ZvkSxOSuvpK6LybiGkL2J0yXCTgin1eXn2hRVJlfngkL+bWCR1fP
         J1PxIsUPiZDbvzYQ2HNNtAVcYW3nxiWgaA+XQSD21OGcdTGiHx5TYWmoAnft/GIozm
         d5PCoxd43tsn+mcC1k7rCSMpamYHW1fif2ERWcbLpz1tVBrGX7HYmvz86qtUB0JzG/
         BZi4xohIJIE2aQsUNg1Lgmm4AfOUHJcG+wEvx96OxFNBGwCftbRjJvDI04X69Cg6K4
         dyH0sl8F511Ug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C211F03847;
        Sat, 30 Apr 2022 14:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mld: respect RCU rules in ip6_mc_source() and
 ip6_mc_msfilter()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165132841117.7113.8034294528388741753.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 14:20:11 +0000
References: <20220429162036.2226133-1-eric.dumazet@gmail.com>
In-Reply-To: <20220429162036.2226133-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        ap420073@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 09:20:36 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Whenever RCU protected list replaces an object,
> the pointer to the new object needs to be updated
> _before_ the call to kfree_rcu() or call_rcu()
> 
> Also ip6_mc_msfilter() needs to update the pointer
> before releasing the mc_lock mutex.
> 
> [...]

Here is the summary with links:
  - [net] mld: respect RCU rules in ip6_mc_source() and ip6_mc_msfilter()
    https://git.kernel.org/netdev/net/c/a9384a4c1d25

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


