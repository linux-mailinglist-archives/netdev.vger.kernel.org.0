Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070AB4DC3B1
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiCQKL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbiCQKL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:11:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C64BF530;
        Thu, 17 Mar 2022 03:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA722617BF;
        Thu, 17 Mar 2022 10:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 518D7C340EC;
        Thu, 17 Mar 2022 10:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647511810;
        bh=BoXZ3Qb0hXldnHMBdCH4nRaa+Krj4pfwocF1BjxbIfI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E0hMCPrujEK9JWBqxeAno4lCOTIq2bZfpjjrHzcewk5VmpQjZJisjRSih5Z0E3xks
         TIM73rtATl9aoF26ppap9ILNcMGteJWFr+4rdKWBGkkwO4LTv4uu08zVDu9RmxG2qw
         BuK6ZVFddooKfG3Rr53bpADz57J89oMnX2qL2EyzTivegS6nUCCvpDbahdf9Q4Zzls
         ++3JagNxxqbmBDt2fSfLKbm4KLT+GtMj9RJspxQQhEcyGijTljSq/JcCdanKMs1BsX
         mimyKGhlD1X8eI/A0FKOQGmjwes5XVycQsKNukYhvbGK2OVO7QOTxZcyKk88tTiQqT
         eRks4aTEqvUoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34905F03841;
        Thu, 17 Mar 2022 10:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] net: mvneta: Armada 98DX2530 SoC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164751181021.10384.6185526581828131470.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 10:10:10 +0000
References: <20220315215207.2746793-1-chris.packham@alliedtelesis.co.nz>
In-Reply-To: <20220315215207.2746793-1-chris.packham@alliedtelesis.co.nz>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        thomas.petazzoni@bootlin.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 16 Mar 2022 10:52:05 +1300 you wrote:
> This is split off from [1] to let it go in via net-next rather than waiting for
> the rest of the series to land.
> 
> [1] - https://lore.kernel.org/lkml/20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz/
> 
> Chris Packham (2):
>   dt-bindings: net: mvneta: Add marvell,armada-ac5-neta
>   net: mvneta: Add support for 98DX2530 Ethernet port
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] dt-bindings: net: mvneta: Add marvell,armada-ac5-neta
    https://git.kernel.org/netdev/net-next/c/270a95966881
  - [net-next,v4,2/2] net: mvneta: Add support for 98DX2530 Ethernet port
    https://git.kernel.org/netdev/net-next/c/2d2a514c1d61

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


