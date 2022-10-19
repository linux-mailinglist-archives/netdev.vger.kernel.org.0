Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BA3604656
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiJSNHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiJSNHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:07:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDEC188AAF;
        Wed, 19 Oct 2022 05:51:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF1F26188A;
        Wed, 19 Oct 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B2C5C433D6;
        Wed, 19 Oct 2022 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666183816;
        bh=9epptH69fJvteUYhFlt8CngtsafZMh5Sbjp6tWTQBDY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pBhRKVYtM1VEbkjtvM41NT5ucV7O6khCLyyut6+qPBa+kFocSpdNkaTc9S9S3Rwmj
         q8g80OiUUOt3YTpBJEwMSZbufQTqnp2gZg3vEg2+swLrg/nKF7y1d/m8QfCClzSyOl
         x5uL7DjK0SFZu/QF/WXzF8A7fa6z/AT0yYWVup1pSPAifr+cNEfv4VgWK1XjxoI9of
         PFrnjMYe1dUmIaByMhGNu+scQJxyam+QHW6tqtvWKJMBrvvd4TzkoFomwC7FRp8PKu
         q67wNiYxaFT6Sx6dlpvpN19JglE4su2GJVVfLt0MctWlWgyMkaf3Teyor3D6GZ3KTW
         2yIqWYtUiQefg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E3B3E29F37;
        Wed, 19 Oct 2022 12:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ethernet: marvell: octeontx2 Fix resource not freed after
 malloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166618381611.9029.4115155196191452345.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 12:50:16 +0000
References: <20221018053317.18900-1-pmanank200502@gmail.com>
In-Reply-To: <20221018053317.18900-1-pmanank200502@gmail.com>
To:     Manank Patel <pmanank200502@gmail.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sundeep.lkml@gmail.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 18 Oct 2022 11:03:18 +0530 you wrote:
> fix rxsc and txsc not getting freed before going out of scope
> 
> Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
> 
> Signed-off-by: Manank Patel <pmanank200502@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [v2] ethernet: marvell: octeontx2 Fix resource not freed after malloc
    https://git.kernel.org/netdev/net/c/7b55c2ed2ba0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


