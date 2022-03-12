Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C752E4D6D3F
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 08:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiCLHl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 02:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiCLHlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 02:41:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7FCE0CA
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 23:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86CA0B80EB6
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 07:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B364C340F4;
        Sat, 12 Mar 2022 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647070816;
        bh=vwRgiMldAL7czEBBGvfmT7nwTTgzohuZlCLTyndpEdI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j67BxW5XptVjbu39/0tM1FHqM1jLtcttDd2OPySQvq0hmgDJgMd83QS4TDMyDmWLP
         TmDnAAErIT2gwb30tZywr3r6ge4rAvU2b45Or/1wJNsr594yWhtPJYKQqoQAPcQXQL
         KYssFCxVAt+93Rw5efq741Fg2G7KSdE4nHqRVi4Q8PCoLQBaBqOsaMRFdCrTnYhhsy
         aeZavYCA7dwxu+fOMwHhwbnY5Lc4IOnxLuM8VVPTNEhzJg5LrQc52P/mwv3idxMPgx
         3JUf+xMr3O6b1OKZ4gug2qF/MLJKHC5Gl5IyvninAGFq8pBnaNzjfzVQaf+w8Ab+ng
         Hp/CtQyJbLLrA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10B3BF0383F;
        Sat, 12 Mar 2022 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next] net: add per-cpu storage and net->core_stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164707081606.11016.17944080084963197988.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 07:40:16 +0000
References: <20220311051420.2608812-1-eric.dumazet@gmail.com>
In-Reply-To: <20220311051420.2608812-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, jeffreyji@google.com, brianvv@google.com,
        pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Mar 2022 21:14:20 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Before adding yet another possibly contended atomic_long_t,
> it is time to add per-cpu storage for existing ones:
>  dev->tx_dropped, dev->rx_dropped, and dev->rx_nohandler
> 
> Because many devices do not have to increment such counters,
> allocate the per-cpu storage on demand, so that dev_get_stats()
> does not have to spend considerable time folding zero counters.
> 
> [...]

Here is the summary with links:
  - [v4,net-next] net: add per-cpu storage and net->core_stats
    https://git.kernel.org/netdev/net-next/c/625788b58445

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


