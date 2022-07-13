Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE21573838
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbiGMOAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbiGMOAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74722CE22;
        Wed, 13 Jul 2022 07:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6635D61D07;
        Wed, 13 Jul 2022 14:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C940AC341C6;
        Wed, 13 Jul 2022 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657720814;
        bh=jfilC1VNUmruSbGkjrBE30vAhFqdqN43Wtm9py6OQbA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JEO4n3+//ibStF4eFaGgddKx4JNWa04MUgkaHN0Wdsz8ttTBJ0CDSum0SxkHudysD
         f3brtvSjU3WZ872U04EFr3dAV566MG4F/Clw6xmF8aIX0E37N+MdVWxDni2zFVus4d
         lzCJAkoHs7juBLX7iyukNiCYwwfdSfoAUP7h2uyekkibSNkxLYaVUB9WC7zeGSLtVo
         4lzsLARMsvwi0YkrQNpwEkVvtiiX9//Zs+SQopZ/Lw0FcixeEosTGWM3d9tY2NmtEl
         U0FqB/hXxt0w+emXWBuUYA8ZZBVnEdDuciwu2XXCS0nG2cz2v2TEUqr+p1QE/I2CnC
         FBOf10faYUtKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A537AE4522E;
        Wed, 13 Jul 2022 14:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sunhme: output link status with a single print.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165772081466.13863.8313977574853526275.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 14:00:14 +0000
References: <20220713015835.23580-1-nbowler@draconx.ca>
In-Reply-To: <20220713015835.23580-1-nbowler@draconx.ca>
To:     Nick Bowler <nbowler@draconx.ca>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Jul 2022 21:58:35 -0400 you wrote:
> This driver currently prints the link status using four separate
> printk calls, which these days gets presented to the user as four
> distinct messages, not exactly ideal:
> 
>   [   32.582778] eth0: Link is up using
>   [   32.582828] internal
>   [   32.582837] transceiver at
>   [   32.582888] 100Mb/s, Full Duplex.
> 
> [...]

Here is the summary with links:
  - net: sunhme: output link status with a single print.
    https://git.kernel.org/netdev/net/c/b11e5f6a3a5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


