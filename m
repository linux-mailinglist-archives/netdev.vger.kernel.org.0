Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52DB692E3F
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 05:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjBKEKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 23:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKEKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 23:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543921ABD0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 20:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2A6EB826E4
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 04:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FF22C433D2;
        Sat, 11 Feb 2023 04:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676088619;
        bh=Fm5/LnXtfD9yIVBgxlbgdQgUEQ9rauUMEtkZ1FZZgpw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jboQgr4nFhjM1RzH+nY1x+GUseyK7ty9cHA2m8TBZ5eEe7/Ux4CllGUoxbDRCun0L
         tjdML8+9fme67nBw4ajt+rg/JG6Is7W/m3Ctm8pb+EXr2usEiXBLuAlFyZqr0ebGAR
         Yhipwq33SzAQn7bXqrFh8I7JtTll7QSnGr2TQWhwQK8LnA5eYpEJDcLW5nqRfJZ6Al
         7MdKkbfOWaJlRpSYwkokaFLmwrf5/jNsWy+XYuyC7mIdZJUpIpBOIdvEQZbRzfKji1
         QzltQPfVQDsvZXxs1FbIE9LC5lBOuCOuPXoRDAKFvbwIaKcdjr4eNHZGoZZ7ricVAz
         LNNbvOK3fWPvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74998E55EFD;
        Sat, 11 Feb 2023 04:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 0/2] sk->sk_forward_alloc fixes.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608861947.12011.13542330757551428353.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 04:10:19 +0000
References: <20230210002202.81442-1-kuniyu@amazon.com>
In-Reply-To: <20230210002202.81442-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 9 Feb 2023 16:22:00 -0800 you wrote:
> The first patch fixes a negative sk_forward_alloc by adding
> sk_rmem_schedule() before skb_set_owner_r(), and second patch
> removes an unnecessary WARN_ON_ONCE().
> 
> Changes:
>   v3:
>     * Factorise a common pattern in Patch 1 as suggested by Eric
> 
> [...]

Here is the summary with links:
  - [v3,net,1/2] dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.
    https://git.kernel.org/netdev/net/c/ca43ccf41224
  - [v3,net,2/2] net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().
    https://git.kernel.org/netdev/net/c/62ec33b44e0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


