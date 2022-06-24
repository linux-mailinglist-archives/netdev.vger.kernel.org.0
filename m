Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4BE558F63
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 06:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiFXEAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiFXEAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A7F527D3;
        Thu, 23 Jun 2022 21:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03962620CE;
        Fri, 24 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46261C341CD;
        Fri, 24 Jun 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656043214;
        bh=qnqrFmMBrysn7Dj6WoBUUrNk+jt9ds1EIjFdBoWj2uY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OjJklqpXMZfZj1d621H4OnjHnUggkdsB0XxGFiu3V5hqfz6KlJiMRywbv3Lh56vrZ
         2svgoOWhPPFZLsm2u6fbozU6JVobLBqFkjQdCsDzyf4yi6tY1UnesX4B15G5ZynsTj
         YcOmh7X202nsdGeWL8rVZ0TXNtmzQS3k2dizxOUt5allK7MHr9XK32p74LpjtEGz5+
         sWusF4/5wRpKr7hoxN41nCgg70uIfUVHiySdAe70XxQut/ltF7PuMcDK1gPnFtF+YH
         gLC7RKl5MYz2XMAMtUvdiuScZ3SAJY+Y1B8SMUwxP2autknD37/gUMlxsBdOgTCcP1
         7PNb1Ba3jQezA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2EFDCE8DBEE;
        Fri, 24 Jun 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb4/cxgb4vf: Fix typo in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604321418.27108.18379693074401286822.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 04:00:14 +0000
References: <20220622144841.21274-1-jiangjian@cdjrlc.com>
In-Reply-To: <20220622144841.21274-1-jiangjian@cdjrlc.com>
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michael.chan@broadcom.com,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 22:48:41 +0800 you wrote:
> Remove the repeated word 'and' from comments
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - cxgb4/cxgb4vf: Fix typo in comments
    https://git.kernel.org/netdev/net-next/c/7747de17f750

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


