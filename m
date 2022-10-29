Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EA2612050
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 07:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJ2FK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 01:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiJ2FKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 01:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B489D522
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 22:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56F7460B40
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A56DBC433B5;
        Sat, 29 Oct 2022 05:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667020218;
        bh=dkG+MWsOVG6uCKuC+bs1le4WjrEpASDocc6kILyn3gk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RGiPSy9I9y2SNTNvLexefz7CBbFUz3Ig42weAVXtx3rip2TAhIYDqhFJTKtadlqRk
         dHq+m6fE0gzBUY2FoMfHWlQWc/q2JGn/xCZdLqCIqIqJVIHYccGcvzfBlAgRZUl55L
         UlYt0yjVZvvVTB1SLswEFiFJHNglSVkhT3WlTln32U9p8Ct92hhyF03Hoiru1AU3zm
         AgdC7sF1GrieZArpd5NT8ayRqvWkS1xvDlQ1p3TItlXgfPLBn/cP4VwxjonND7w7ya
         UAeWSFI4ye+dDsmMH2M71oyYhApGqCrZN5+LtUlr4hcdHOwK69tsPci/ncs/01foNi
         otPwHMv9MyIUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 882EFC41677;
        Sat, 29 Oct 2022 05:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Clean up SFP register definitions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166702021855.21650.6992600473736103297.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 05:10:18 +0000
References: <Y1qFvaDlLVM1fHdG@shell.armlinux.org.uk>
In-Reply-To: <Y1qFvaDlLVM1fHdG@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Oct 2022 14:21:01 +0100 you wrote:
> Hi,
> 
> This two-part patch series cleans up the SFP register definitions by
> 1. converting them from hex to decimal, as all the definitions in the
>    documents use decimal, this makes it easier to cross-reference.
> 2. moving the bit definitions for each register along side their
>    register address definition
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: sfp: convert register indexes from hex to decimal
    https://git.kernel.org/netdev/net-next/c/17dd361119e5
  - [net-next,2/2] net: sfp: move field definitions along side register index
    https://git.kernel.org/netdev/net-next/c/d83845d224a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


