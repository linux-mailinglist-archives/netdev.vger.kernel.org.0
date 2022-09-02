Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBC05AA663
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 05:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiIBDaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 23:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiIBDaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 23:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330B82B60E
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 20:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BDE361E9F
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 03:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8550C433D6;
        Fri,  2 Sep 2022 03:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662089414;
        bh=4huHqQhfzjPxJgTO7fa2l4HOzvg7YcI+IjOpF894bqA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G+JazTRaQY3ntX1aqD4a+D2kNhGwNr5fURRaUIuElhASi7LNvHITi+mCh6b89ALn6
         Msi94o3otzZq+DJzx4e4d5rAnzkckiTBtLtBktZUIdfXAdbxnx1nmDBayDoC3qQWzc
         Xtl8FXexfxHXZUiEsPwaRDdFimSSzW8773SIyS6csjwrO8j2xFDesfDmGbWmNG42gy
         ICHiQskND/cgzdqnhj9rxPBh2i5aVcN0OYmwmxmG80CnUiY3tFmLlf/wzd1f24xyzZ
         rAHPWvEI7SDNvG1Yd5dDQS9T/bk3eHCUaVFXjRViok6WbTSRkmE4gDsEIhWoQTQ0qn
         g9DDofdL21grg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AABFCE924D6;
        Fri,  2 Sep 2022 03:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: rtnetlink: use netif_oper_up instead of open code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166208941469.631.13967537392748274642.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 03:30:14 +0000
References: <20220831125845.1333-1-claudiajkang@gmail.com>
In-Reply-To: <20220831125845.1333-1-claudiajkang@gmail.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 Aug 2022 21:58:45 +0900 you wrote:
> The open code is defined as a new helper function(netif_oper_up) on netdev.h,
> the code is dev->operstate == IF_OPER_UP || dev->operstate == IF_OPER_UNKNOWN.
> Thus, replace the open code to netif_oper_up. This patch doesn't change logic.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
>  net/core/rtnetlink.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - net: rtnetlink: use netif_oper_up instead of open code
    https://git.kernel.org/netdev/net-next/c/abbc79280abc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


