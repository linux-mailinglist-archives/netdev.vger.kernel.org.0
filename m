Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9167A573666
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 14:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiGMMaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 08:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiGMMaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 08:30:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21505EA16B;
        Wed, 13 Jul 2022 05:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1D09B81E9C;
        Wed, 13 Jul 2022 12:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 740F3C3411E;
        Wed, 13 Jul 2022 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657715417;
        bh=z+L2ToGiFTJupu7Yhz4NCUZ6QHX9gsvVXZR6jaSO6oY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tXZRKPYEK1VSkZFCCfdkOS1b6Es0ZssSUw71DM3M05TkYQta/NrYB53p1GavCc+ee
         oSR1SBMV7NGH8FS/SBfNW+TzwpeKn8hReYhujhF/iemgR/z1eWc853Jp/S8LHXJ1C2
         tacZCl2qNb/lTnSKg9Nt4fIYwC43+z9y203aR3YlBqGqHbCuVbGmVJl3XEgHc0M6y1
         O9TAooHfP4PA5nad9AxHNxTsBf2wCkyMvMlxU2P9I5WBQ1dtJKAReY0ha5HQgOFh/B
         JDEHmL1C9c1Cuk8ZBCS9Faql0kb+cj/LOO2AZVoGQpANqHDux79HVQ6+t+1iO20GXf
         Lrh0My5X90Hkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54B00E45227;
        Wed, 13 Jul 2022 12:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table
 (Round 1).
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165771541734.30030.5319187042476768216.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 12:30:17 +0000
References: <20220712001533.89927-1-kuniyu@amazon.com>
In-Reply-To: <20220712001533.89927-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, yzaikin@google.com, kuni1840@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Jul 2022 17:15:18 -0700 you wrote:
> This series fixes data-races around the first 13 knobs and
> nexthop_compat_mode in ipv4_net_table.
> 
> I will post another patch for three early_demux knobs later,
> so the next round will start from ip_default_ttl.
> 
> 
> [...]

Here is the summary with links:
  - [v1,net,01/15] sysctl: Fix data-races in proc_dou8vec_minmax().
    https://git.kernel.org/netdev/net/c/7dee5d7747a6
  - [v1,net,02/15] sysctl: Fix data-races in proc_dointvec_ms_jiffies().
    https://git.kernel.org/netdev/net/c/7d1025e55978
  - [v1,net,03/15] tcp: Fix a data-race around sysctl_max_tw_buckets.
    https://git.kernel.org/netdev/net/c/6f605b57f378
  - [v1,net,04/15] icmp: Fix a data-race around sysctl_icmp_echo_ignore_all.
    https://git.kernel.org/netdev/net/c/bb7bb35a63b4
  - [v1,net,05/15] icmp: Fix data-races around sysctl_icmp_echo_enable_probe.
    https://git.kernel.org/netdev/net/c/4a2f7083cc6c
  - [v1,net,06/15] icmp: Fix a data-race around sysctl_icmp_echo_ignore_broadcasts.
    https://git.kernel.org/netdev/net/c/66484bb98ed2
  - [v1,net,07/15] icmp: Fix a data-race around sysctl_icmp_ignore_bogus_error_responses.
    https://git.kernel.org/netdev/net/c/b04f9b7e85c7
  - [v1,net,08/15] icmp: Fix a data-race around sysctl_icmp_errors_use_inbound_ifaddr.
    https://git.kernel.org/netdev/net/c/d2efabce81db
  - [v1,net,09/15] icmp: Fix a data-race around sysctl_icmp_ratelimit.
    https://git.kernel.org/netdev/net/c/2a4eb714841f
  - [v1,net,10/15] icmp: Fix a data-race around sysctl_icmp_ratemask.
    https://git.kernel.org/netdev/net/c/1ebcb25ad6fc
  - [v1,net,11/15] raw: Fix a data-race around sysctl_raw_l3mdev_accept.
    https://git.kernel.org/netdev/net/c/1dace014928e
  - [v1,net,12/15] tcp: Fix data-races around sysctl_tcp_ecn.
    https://git.kernel.org/netdev/net/c/4785a66702f0
  - [v1,net,13/15] tcp: Fix a data-race around sysctl_tcp_ecn_fallback.
    https://git.kernel.org/netdev/net/c/12b8d9ca7e67
  - [v1,net,14/15] ipv4: Fix data-races around sysctl_ip_dynaddr.
    https://git.kernel.org/netdev/net/c/e49e4aff7ec1
  - [v1,net,15/15] nexthop: Fix data-races around nexthop_compat_mode.
    https://git.kernel.org/netdev/net/c/bdf00bf24bef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


