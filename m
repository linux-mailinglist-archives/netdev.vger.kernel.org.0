Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EF757FF04
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 14:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbiGYMaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 08:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbiGYMaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 08:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A331639D
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 05:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D62F6103C
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE8CFC341C6;
        Mon, 25 Jul 2022 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658752216;
        bh=3KyFO6KPtqu8gFVJ03726WvqOw6YL1glgmg22t5Z1B4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QY0Zx6J4hdAScWaMwbczzb/ni7TBtaEdkdmHXYNNv1JpjYCx04oXR6K/8JISb+Sin
         Hvpkn9q7U0VYYiP+D8bFC8+3HgKwjhMAzBJjaA/huUxcI/hJBVONdjFhAhBBFOq7y1
         jqBF3DSO1nyacCCAaJ6UvZYmtUPYz+mz3cTbbEvUt71DsqHrYvKINBcuPGmNODo1mo
         gCOKlpQy5LPxNQueavQ7a4eJyH3gP2TT6HNtawHjterw6FlVReS4ZbMX88EVvapk2Y
         Ce5lhEZn7a3sc9vCQdARmHcjPg0eO4dE1QiFV1IJd99zTSNM+LBj1URIHh1hRAWuSF
         frh/7Aiarsl0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CFA06E450B5;
        Mon, 25 Jul 2022 12:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 0/7] sysctl: Fix data-races around ipv4_net_table
 (Round 6, Final).
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165875221584.16726.2228439622878004930.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 12:30:15 +0000
References: <20220722182205.96838-1-kuniyu@amazon.com>
In-Reply-To: <20220722182205.96838-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Jul 2022 11:21:58 -0700 you wrote:
> This series fixes data-races around 11 knobs after tcp_pacing_ss_ratio
> ipv4_net_table, and this is the final round for ipv4_net_table.
> 
> While at it, other data-races around these related knobs are fixed.
> 
>   - decnet_mem
>   - decnet_rmem
>   - tipc_rmem
> 
> [...]

Here is the summary with links:
  - [v1,net,1/7] tcp: Fix data-races around sk_pacing_rate.
    https://git.kernel.org/netdev/net/c/59bf6c65a09f
  - [v1,net,2/7] net: Fix data-races around sysctl_[rw]mem(_offset)?.
    https://git.kernel.org/netdev/net/c/02739545951a
  - [v1,net,3/7] tcp: Fix a data-race around sysctl_tcp_comp_sack_delay_ns.
    https://git.kernel.org/netdev/net/c/4866b2b0f767
  - [v1,net,4/7] tcp: Fix a data-race around sysctl_tcp_comp_sack_slack_ns.
    https://git.kernel.org/netdev/net/c/22396941a7f3
  - [v1,net,5/7] tcp: Fix a data-race around sysctl_tcp_comp_sack_nr.
    https://git.kernel.org/netdev/net/c/79f55473bfc8
  - [v1,net,6/7] tcp: Fix data-races around sysctl_tcp_reflect_tos.
    https://git.kernel.org/netdev/net/c/870e3a634b6a
  - [v1,net,7/7] ipv4: Fix data-races around sysctl_fib_notify_on_flag_change.
    https://git.kernel.org/netdev/net/c/96b9bd8c6d12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


