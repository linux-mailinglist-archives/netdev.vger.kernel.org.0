Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF7D503067
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356153AbiDOVxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356177AbiDOVxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:53:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF1E6FF79
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF920B83003
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 21:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5826FC385A8;
        Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650059413;
        bh=cJJWIRjYEQ/WhL/d8B1YPg4OzraKgUaLReDXqSq7bO0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pnnEZMu/rDr5IJctTeJcCIPjcgnIhpqyAJetYtYDMCuuDKg3TgDXI1UWuWIXuJf7D
         3V9Wt5r2fIXNuHIYIuX5suM5flBf2cqbypBWRYPds9v2GCLJq0RTfm7r940ziTvsH3
         pXFI/rfQ00ldOIDqq7Y4gsR36yGp1pOo+16EzGRawXf+AiL7V1bAgGnyjvYnI2IMX6
         5fYOwtRLmQ2AGq0geSxGlqN4UvskEtlY88Nk3tSGs4oC9iSIuXvwD0KKA4jx9l95H1
         26wFemnXwWY6y6cxmHU1RF2Tq5mEDAxRAQ/3FWTJac0n8J6fEz2iruxmogZAY4tRRJ
         yeTYZe4J6jCyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37A87E8DD67;
        Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/sched: two fixes for cls_u32
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165005941322.21261.9929027704708598517.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 21:50:13 +0000
References: <20220413173542.533060-1-eric.dumazet@gmail.com>
In-Reply-To: <20220413173542.533060-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, edumazet@google.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Apr 2022 10:35:40 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> One syzbot report brought my attention to cls_u32.
> 
> This series addresses the syzbot report, and an additional
> issue discovered in code review.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/sched: cls_u32: fix netns refcount changes in u32_change()
    https://git.kernel.org/netdev/net/c/3db09e762dc7
  - [net,2/2] net/sched: cls_u32: fix possible leak in u32_init_knode()
    https://git.kernel.org/netdev/net/c/ec5b0f605b10

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


