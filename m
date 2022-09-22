Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8B45E5774
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiIVAkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIVAkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075F467452
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 17:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92DA863336
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAFD9C43141;
        Thu, 22 Sep 2022 00:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663807216;
        bh=vKpp9EBGuQ/kX/MUt0unUNh+S3/3zRrjT+GFEPc2kvI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HJB/jXIQuA6tEMVacxAtaJ17dxiH6hn8SWcKq3yjmSth0Oq6ELdVQLwmzl9Qkj4WP
         SkhXUP5mJxGwV4uM79NXMAddsl8O84AZrzPvy1226/94vPbGPVNAQpX59ejkgHCZbV
         FLXtLjiAuS2GqIhirt9913wNoZIgcPdKyjt3HMn0XtT6NVwEPhWJHIbV3b7bYNqmaN
         Q3Vu1pnfCU679SWB4vygcK80J7kA1t8CxjU96a38UuDpD9tT1YuGhY0yUPMkxqX8U1
         rTRPRRCcHFkgDAm4SnPwsjeI3ovT+W9BuWXwn3NwkvGuE77P8Y47KznIizCR7NAJfd
         mBCHvlNXoIhhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3242E4D03D;
        Thu, 22 Sep 2022 00:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fjes: Reorder symbols to get rid of a few forward
 declarations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166380721585.7808.1450509908331362021.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 00:40:15 +0000
References: <20220917225142.473770-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20220917225142.473770-1-u.kleine-koenig@pengutronix.de>
To:     =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, kernel@pengutronix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 18 Sep 2022 00:51:42 +0200 you wrote:
> Quite a few of the functions and other symbols defined in this driver had
> forward declarations. They can all be dropped after reordering them.
> 
> This saves a few lines of code and reduces code duplication.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - net: fjes: Reorder symbols to get rid of a few forward declarations
    https://git.kernel.org/netdev/net-next/c/fa2aee653663

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


