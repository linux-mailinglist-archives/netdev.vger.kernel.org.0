Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2424D315F
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 16:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbiCIPBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 10:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiCIPBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 10:01:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CC015134D;
        Wed,  9 Mar 2022 07:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 430A4611EE;
        Wed,  9 Mar 2022 15:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1864C340F9;
        Wed,  9 Mar 2022 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646838014;
        bh=Fuz/TOJZtdnCc1h3t/uL3fSq6MITPPNkm56HXLDyVNY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nmdDEIPKY2mpOzW6LkO0367ipFbQAPf1TLl4k68SATj6yGcLBUfozqD/MrKw3xJWs
         7Xp2G5Mqo+aC2++iHs1QXJAxCUUF1qJ+mhhCH8+9ZKyxoYIQYB2byUjmK5reqbcDr1
         k5fY0rdd5GQ5Uqlnb/pGqMZ9po6Ttx7ULSYDGTEtdDJTlDIgzyjFLnoujaiQCLk/Y4
         1gg6QpC+swCldhGhYDf3qaqncRAC+6JtENY54mU1bYlvZZEHJOMWtqGoajCrO08EeN
         YMuWlJyyD8S4/Zeq/gzCOO993+hNJs3TmnTD8ErTyVS/U4EybIIrjLVSJ+N+ULMjwk
         XzDFOjfFWX//Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A91DE73C2D;
        Wed,  9 Mar 2022 15:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Add spinlock for frame transmission
 from CPU.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164683801456.7970.18419622051031308474.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 15:00:14 +0000
References: <20220308102904.3978779-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220308102904.3978779-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue, 8 Mar 2022 11:29:04 +0100 you wrote:
> The registers used to inject a frame to one of the ports is shared
> between all the net devices. Therefore, there can be race conditions for
> accessing the registers when two processes send frames at the same time
> on different ports.
> 
> To fix this, add a spinlock around the function
> 'lan966x_port_ifh_xmit()'.
> 
> [...]

Here is the summary with links:
  - [net-next] net: lan966x: Add spinlock for frame transmission from CPU.
    https://git.kernel.org/netdev/net-next/c/0dbdf819f4c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


