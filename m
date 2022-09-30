Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658715F0AE6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiI3LpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiI3Lor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:44:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0D597ECA;
        Fri, 30 Sep 2022 04:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70A15B8283D;
        Fri, 30 Sep 2022 11:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28F96C433C1;
        Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664538018;
        bh=Z6RXl0HRHfczjUwX9S9z2ImtaFz1bZwRRi/GsGwvGfQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pckuA5oED7g+6G9XXmBAcS5Bb8pigeR92fo2FoOShGOV/pknY1amgWTb9nLHvNvnZ
         g7idw1rEZiawOpj/uJ6lPwc3K1gd/4UbRqF/MFiNnKIxCofnervuNhMYiEZuyBZlng
         tKy6LYKT8zlH8qFFOFPrN8eImTqA5udyh+wmMY92W6rHTIBvJz6JycjaRz+mW2/Jnw
         uzyATxwkA4mfiOwpBrQZNaG9ZhWChSnN13l1v0vbQat3SwRAf/Re+Ot1QhLvgL8dTQ
         FPdL4BzJm8RA5zt4C3B++QJmLOVeyrJz9DfKvuSlfzONm5tIE0AmzoNTHGGsF4SjMH
         nZOOqHmNVZO1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14B4AC395DA;
        Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2: Fix spelling mistake "bufferred" -> "buffered"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453801807.4225.16891835315380023791.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 11:40:18 +0000
References: <20220928213753.64396-1-colin.i.king@gmail.com>
In-Reply-To: <20220928213753.64396-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     rmody@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 28 Sep 2022 22:37:53 +0100 you wrote:
> There are spelling mistakes in two literal strings. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - bnx2: Fix spelling mistake "bufferred" -> "buffered"
    https://git.kernel.org/netdev/net-next/c/ea9b9a985d58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


