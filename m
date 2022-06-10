Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE8D545BC0
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243950AbiFJFkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243357AbiFJFkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C66201B8
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 22:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9B2DB830F4
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 05:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58F42C385A5;
        Fri, 10 Jun 2022 05:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654839616;
        bh=8r00J7Hb0mPZ2fpcx9cx9iOgBkd9dUSMNV+YG3niuVI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qaZDHePt5x59nbCNIdFhLNkfzRAQTx5tTWRTxnLLLbfku+hTjzqPKrgqJ2E22Nsmo
         g0aq6TXuGC4Tho9B9qYQd1A1EWeQ3pXspwyYL+4XDcPhlYbWu8FiwLFLDBFUgxuD/O
         f3El7GTgl3UUqfYtYENyIreYwvjqGvs3eKUPvYYnb60jCQOV2Kj4J2sHlluMTz7Jem
         PfIteQ5K/WHzsezbfKRj+rCZnek7Dqj4/FpvIvLkXsuv5+jmHgnC/1l0UlFbNtRRkf
         gzMc9WPax25LZldrRkjE/xYXu4hEYbBsA3FMtV+XckfFUQBJ1IZjtq563w7EFeQfsB
         2OD4QkX9f3ptQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E304E737EE;
        Fri, 10 Jun 2022 05:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/8] net: few debug refinements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165483961625.13976.11759906381831486873.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 05:40:16 +0000
References: <20220608160438.1342569-1-eric.dumazet@gmail.com>
In-Reply-To: <20220608160438.1342569-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Jun 2022 09:04:30 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Adopt DEBUG_NET_WARN_ON_ONCE() or WARN_ON_ONCE()
> in some places where it makes sense.
> 
> Add checks in napi_consume_skb() and __napi_alloc_skb()
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/8] net: use DEBUG_NET_WARN_ON_ONCE() in __release_sock()
    https://git.kernel.org/netdev/net-next/c/63fbdd3c77ec
  - [v2,net-next,2/8] net: use DEBUG_NET_WARN_ON_ONCE() in dev_loopback_xmit()
    https://git.kernel.org/netdev/net-next/c/76458faeb285
  - [v2,net-next,3/8] net: use WARN_ON_ONCE() in inet_sock_destruct()
    https://git.kernel.org/netdev/net-next/c/3e7f2b8d3088
  - [v2,net-next,4/8] net: use WARN_ON_ONCE() in sk_stream_kill_queues()
    https://git.kernel.org/netdev/net-next/c/c59f02f84867
  - [v2,net-next,5/8] af_unix: use DEBUG_NET_WARN_ON_ONCE()
    https://git.kernel.org/netdev/net-next/c/dd29c67dbbbf
  - [v2,net-next,6/8] net: use DEBUG_NET_WARN_ON_ONCE() in skb_release_head_state()
    https://git.kernel.org/netdev/net-next/c/7890e2f09d43
  - [v2,net-next,7/8] net: add debug checks in napi_consume_skb and __napi_alloc_skb()
    https://git.kernel.org/netdev/net-next/c/ee2640df2393
  - [v2,net-next,8/8] net: add napi_get_frags_check() helper
    https://git.kernel.org/netdev/net-next/c/fd9ea57f4e95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


