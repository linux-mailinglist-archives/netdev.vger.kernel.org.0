Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62F25AADAC
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiIBLcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236008AbiIBLbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:31:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52CE1B796;
        Fri,  2 Sep 2022 04:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65893B82A6A;
        Fri,  2 Sep 2022 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 234C3C433D7;
        Fri,  2 Sep 2022 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662118215;
        bh=zoti2kKA3bbsMGqfbXuXVT5vouoxM2PrYt0FaDB3J18=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jkOP2Y/zXyBQZ6leq9LvmqFZ3foUo944n+ww2XzBSPOjY7SarTSE1YTsqq6xygVio
         lLaOedqufyy5UBldiVY3OdAppXqYgQaYI2TEj+KQOBWT/d2IFKxFNSl/8EivpWLigQ
         EwcaxY/+MCX49b5uiLfB2H8UyVj60vTRmx2oEe1vcft8caT0ViGAIOoOwEjWAJr5JY
         Nfls7mcC9OhEE+6R7b3Hk2WJTXoZK6tbm6u2kYPI6Q6raE1DNH1NXvuH7+HJx9yLlh
         p2X89gNUMqOpbSp/OJhJ7Y34/wDPpObWz+LoX6p3+0LPTW/5ZXXVLQyP4F5t7uEL44
         M9+p33RKyqCSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0878CE924E4;
        Fri,  2 Sep 2022 11:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: fix shift wrapping bug in map_get()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166211821502.29115.5957721175008629537.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 11:30:15 +0000
References: <Yw90nHF82AyG35Mk@kili>
In-Reply-To: <Yw90nHF82AyG35Mk@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 31 Aug 2022 17:47:56 +0300 you wrote:
> There is a shift wrapping bug in this code so anything thing above
> 31 will return false.
> 
> Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I have no idea why I didn't fix this back in 2016 when I fixed map_set().
> 
> [...]

Here is the summary with links:
  - [net] tipc: fix shift wrapping bug in map_get()
    https://git.kernel.org/netdev/net/c/e2b224abd9bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


