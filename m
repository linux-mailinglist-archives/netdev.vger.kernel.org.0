Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA095BED40
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 21:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiITTAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 15:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiITTA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 15:00:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CE165543
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 12:00:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22149B82CA5
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 19:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E32F6C4314A;
        Tue, 20 Sep 2022 19:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663700421;
        bh=ingXBgzoyV/GzmzXqQi4XLuNxUYmqWID6OhXK+Jb9go=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RB4l8user+h+uRY5qLWeWlF+P5YSEd8sCV2VF/kFTA88wU1doqef0JjK5ZjXerZ5V
         /jDAv1QiOhSqV/BM6nb6epegvKvhefuROMG409T5vN2v6XmIIM4jbCPkqptIg/SHdZ
         +p+vG4GxmV2E4Rg0eg2Q7qRTbpv7hUzyiuuxQ9nTb0HLDW+JuVUduj7YOAWOsqO4nA
         K0L1CWGdX7zDN5bla1Kj/NQpf/tEAhFh4BZMuHeE3GEMB+Jq7GlTd0/570LCzZcRGa
         G6zg76s5GaXsdFJ7drXOe+fPNYOsU9lUWSSUIpTwh5pAu+AYhSl+gBaipKDB78ufmG
         PwOywERK92unQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE9FEE5250A;
        Tue, 20 Sep 2022 19:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net-next 0/6] tcp: Introduce optional per-netns ehash.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166370042183.20640.3960141192085780845.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 19:00:21 +0000
References: <20220908011022.45342-1-kuniyu@amazon.com>
In-Reply-To: <20220908011022.45342-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 7 Sep 2022 18:10:16 -0700 you wrote:
> The more sockets we have in the hash table, the longer we spend looking
> up the socket.  While running a number of small workloads on the same
> host, they penalise each other and cause performance degradation.
> 
> The root cause might be a single workload that consumes much more
> resources than the others.  It often happens on a cloud service where
> different workloads share the same computing resource.
> 
> [...]

Here is the summary with links:
  - [v6,net-next,1/6] tcp: Clean up some functions.
    https://git.kernel.org/netdev/net-next/c/08eaef904031
  - [v6,net-next,2/6] tcp: Don't allocate tcp_death_row outside of struct netns_ipv4.
    https://git.kernel.org/netdev/net-next/c/e9bd0cca09d1
  - [v6,net-next,3/6] tcp: Set NULL to sk->sk_prot->h.hashinfo.
    https://git.kernel.org/netdev/net-next/c/429e42c1c54e
  - [v6,net-next,4/6] tcp: Access &tcp_hashinfo via net.
    https://git.kernel.org/netdev/net-next/c/4461568aa4e5
  - [v6,net-next,5/6] tcp: Save unnecessary inet_twsk_purge() calls.
    https://git.kernel.org/netdev/net-next/c/edc12f032a5a
  - [v6,net-next,6/6] tcp: Introduce optional per-netns ehash.
    https://git.kernel.org/netdev/net-next/c/d1e5e6408b30

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


