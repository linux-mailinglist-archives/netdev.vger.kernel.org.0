Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CFB5BAF80
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 16:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiIPOkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 10:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiIPOkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 10:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F4A36DFB;
        Fri, 16 Sep 2022 07:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D24AD62C1E;
        Fri, 16 Sep 2022 14:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39D14C433D7;
        Fri, 16 Sep 2022 14:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663339215;
        bh=BMgQBKNJt/brrMvAlgA6oyjbl+rWt/iab8EHKpRf06M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CiGtpE9mOyb+CgnWFA6VOOMy4xKG26cXtDCNpvWZCNY83XaZCooWP0WcxqIfoviub
         1ZQ60ure++mQKwPfklJh5biO9+vht9aZtdx7YoR36ZOvEg7yT0OuMN6nGvTdh4GSmo
         5USZCr9fZJHnKUoO8gVgSzpiYajXwy+Y/dJ7plhhXqElWtIFqaB/mk3GsvhOn+kHGm
         xJ2gWgU2ZW37twisubr3i4Z4aIOyAnlug+UNEhnEyqDf57q+vCj31W1x9YO9mgBJ3h
         iz54nW3B6EJXiJyGS2J4wHknABymek/j5CSIeJ7dKbqGSl3z+9wf2f+BdS6tfHTWJK
         beEvmG9GW4g6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 160F8C59A58;
        Fri, 16 Sep 2022 14:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: Use WARN_ON_ONCE() in tcp_read_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166333921508.20219.3065242215536407480.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 14:40:15 +0000
References: <20220908231523.8977-1-yepeilin.cs@gmail.com>
In-Reply-To: <20220908231523.8977-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        peilin.ye@bytedance.com, cong.wang@bytedance.com,
        jakub@cloudflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  8 Sep 2022 16:15:23 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Prevent tcp_read_skb() from flooding the syslog.
> 
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [net] tcp: Use WARN_ON_ONCE() in tcp_read_skb()
    https://git.kernel.org/netdev/net/c/96628951869c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


