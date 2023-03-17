Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EF16BE265
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjCQIA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjCQIA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:00:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339663A870;
        Fri, 17 Mar 2023 01:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B56BB824AF;
        Fri, 17 Mar 2023 08:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C5E6C433EF;
        Fri, 17 Mar 2023 08:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679040019;
        bh=/hmOKOzZYq85m0ewfPobFD3jYGLlptDBfOFlU6K+PKA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eAblrDL8M4HlFkCP+eqnty/bC2K6i8zGHhnCrAcIJrt7gQNJbtykl/YM5zE3xONGv
         JY2l+WvtS6l5XSySzzUPGSXLBoHf/YrJ2mG8i/ELzbxYR34iGfExMJbNwQh2zR0VVt
         m9uqcKtCgz2s5HsyokQSoygSGn9YSA/NGyJJ3CNaAPN7/jnaIEkYD75/FuT4CV00RG
         1uY8lwG37g00DyeoF10Uy6lx3FW+TEt808pJANZj62b2bdEhqIfwrDnkxDzI/Cy6r4
         dDL+KdByvytSAKMV9eTM6bOolh10UyzQ6BWjIkaY1Il/UI7rtSR++rEaepkE5hc8g5
         t89CXe648DbuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6A77E21EE6;
        Fri, 17 Mar 2023 08:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: renesas: rswitch: Fix rx and timestamp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904001894.28626.17243909236933656574.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 08:00:18 +0000
References: <20230315070424.1088877-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230315070424.1088877-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 16:04:22 +0900 you wrote:
> I got reports locally about issues on the rswitch driver.
> So, fix the issues.
> 
> Yoshihiro Shimoda (2):
>   net: renesas: rswitch: Fix the output value of quote from rswitch_rx()
>   net: renesas: rswitch: Fix GWTSDIE register handling
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: renesas: rswitch: Fix the output value of quote from rswitch_rx()
    https://git.kernel.org/netdev/net/c/e05bb97d9c9d
  - [net,2/2] net: renesas: rswitch: Fix GWTSDIE register handling
    https://git.kernel.org/netdev/net/c/2c59e993c86a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


