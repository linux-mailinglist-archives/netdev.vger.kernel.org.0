Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E63B4D607A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 12:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245571AbiCKLVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 06:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbiCKLVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 06:21:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362182AC5;
        Fri, 11 Mar 2022 03:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C87F461B49;
        Fri, 11 Mar 2022 11:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B112C340EC;
        Fri, 11 Mar 2022 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646997610;
        bh=Rxfu0cswIO+qQGh9OO4iRX9Xy2FWrCarh4AekUQZwGY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r24EOsV6xnlTrAubJns9lcLAoj9aRhlfE1Qavvw00K64aY8HROSdzpMe6UM02I0zI
         Wkdc7BGi/20CNiwg7L1rrTzh97rHYAYCta0QRiQlVy5fhs4UWZ2SKRweBJsby94zPu
         eVMsnLUoF3DL+0gcCKqTpebmSfXe8cw6EfSBacUHRBxKmdjOo1vQ1IKMlwGWXUwctg
         HRHnCMxnNMYqLDUz6SuEHuQwF4c/LM2OVtIMbLih2EMAmO4UQvJ2PaDe9H3LDXXyZ7
         hyu9/DUAPb/V15oOMQFDB2ncW8k1FkJdT/ZVTJ2ca0ZmbeBY1gaav1kjnUzqfM3Mk1
         iOlSag1Z+7uZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DD20EAC095;
        Fri, 11 Mar 2022 11:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: lan966x: Improve the CPU TX bitrate.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164699761005.9005.4935359925915457985.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 11:20:10 +0000
References: <20220310084005.262551-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220310084005.262551-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        david.laight@aculab.com, andrew@lunn.ch
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

On Thu, 10 Mar 2022 09:40:05 +0100 you wrote:
> When doing manual injection of the frame, it is required to check if the
> TX FIFO is ready to accept the next word of the frame. For this we are
> using 'readx_poll_timeout_atomic', the only problem is that before it
> actually checks the status, is determining the time when to finish polling
> the status. Which seems to be an expensive operation.
> Therefore check the status of the TX FIFO before calling
> 'readx_poll_timeout_atomic'.
> Doing this will improve the TX bitrate by ~70%. Because 99% the FIFO is
> ready by that time. The measurements were done using iperf3.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: lan966x: Improve the CPU TX bitrate.
    https://git.kernel.org/netdev/net-next/c/fb9eb027fbc9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


