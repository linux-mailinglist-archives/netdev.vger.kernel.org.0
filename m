Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80C2524A7F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 12:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352753AbiELKkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 06:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352754AbiELKkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 06:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ABC229FE9;
        Thu, 12 May 2022 03:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9903EB8271F;
        Thu, 12 May 2022 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D99DC385CB;
        Thu, 12 May 2022 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652352012;
        bh=4WOAJEDFWkl0XQDS7GAUPGwoYhNmfkWAl2nGUkdF/mY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A9T7X+MTMlsnpzhdEqnxyRsFE3xDBHVpkujufNLrkkBlE3j0yeOhBCNHi6OyLRcnU
         AbX3staFyMlot8wYf/BbvBWUKU0fjb9rxx/rNwjeVAPg/bKmNoIxz1OXZaDXVkJ9+A
         6S5pmxTtVS09wrahssd/NY/Bmhoe5Lvo+qukeCnKtKeq+K4Fh1HvORFvs+OTxJ0lVi
         hSH0DKcHV9Nrcpeb2yEpw2TVrWIfsHN5HEio/gyMspSqjdHp1p4Xr58YKdmtXNfPG0
         O9alsAYdwPzErRgQhwhk5ycs13iik4Ddfa9UzPQrBFQXxH7rEgC1GCvo/aoz+jv48j
         NehfC+hwHd3Og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 309F7F0393A;
        Thu, 12 May 2022 10:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: ethernet: SP7021: Fix spelling mistake "Interrput"
 -> "Interrupt"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165235201219.27484.11040061538399474855.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 10:40:12 +0000
References: <20220511104448.150800-1-colin.i.king@gmail.com>
In-Reply-To: <20220511104448.150800-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     wellslutw@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 11 May 2022 11:44:48 +0100 you wrote:
> There is a spelling mistake in a dev_dbg message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/sunplus/spl2sw_int.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] net: ethernet: SP7021: Fix spelling mistake "Interrput" -> "Interrupt"
    https://git.kernel.org/netdev/net-next/c/982c97eede13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


