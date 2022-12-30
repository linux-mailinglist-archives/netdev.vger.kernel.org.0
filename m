Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161B86595CB
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 08:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiL3Hk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 02:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbiL3HkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 02:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DDE62EB
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 23:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B1B561A78
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 07:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83A55C433D2;
        Fri, 30 Dec 2022 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672386018;
        bh=/Ngwj4cmXxIHhlLBmn1wWLrOE4lV2TMePqidwk2FVkQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EKXdvaCel9f0oxu7bC2sykEQTXKEuabKLYrlhhMmbQ0pB2pT6+NVmN4lpElNOdAEx
         KBhtsit+L16Fw4UeP7Llz0zWdaUuyHk8dJQG7L9JYn5y2VC6RMBPCylkoYbVhXLkC4
         7lkwrS8guBeqWnUCZPaxWkjcz2kmCjSY7bVxXi0OzkMbv9N9znpSpk8zehqicc2eUP
         FS2faUHLgNA7Ld/c7cO7M5eeXTG27hp2imKZuG61hUXdYAGnDbOQ4KWCL+b+ApvPfX
         K5T8bBlXTwuX1Di9HN8Jfs44BXHyGtFgNHf6Ns275T/xP+BaKtQRz7O4Gb9NX/K9XH
         npJOCRNskQvfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 664BEE5250A;
        Fri, 30 Dec 2022 07:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] net: ethernet: Drop empty platform remove function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167238601841.1408.17445024603756261367.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Dec 2022 07:40:18 +0000
References: <20221227214508.1576719-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20221227214508.1576719-1-u.kleine-koenig@pengutronix.de>
To:     =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        kernel@pengutronix.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 27 Dec 2022 22:45:06 +0100 you wrote:
> Hello,
> 
> this series drops all empty remove callbacks from platform drivers. A
> callback that only returns zero is equivalent to no callback at all, so
> use this simpler approach.
> 
> Best regards
> Uwe
> 
> [...]

Here is the summary with links:
  - [1/2] net: ethernet: broadcom: bcm63xx_enet: Drop empty platform remove function
    https://git.kernel.org/netdev/net/c/6b57bffa5f67
  - [2/2] net: ethernet: freescale: enetc: Drop empty platform remove function
    https://git.kernel.org/netdev/net/c/af691c94d022

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


