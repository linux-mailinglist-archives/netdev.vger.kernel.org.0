Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC9F689411
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbjBCJkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbjBCJkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:40:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7404125BB5;
        Fri,  3 Feb 2023 01:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF33761E53;
        Fri,  3 Feb 2023 09:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21BBDC433EF;
        Fri,  3 Feb 2023 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675417221;
        bh=neCkk228oMwxeg8nbr7zQ6d1aWhdjIHRs5WNALS+Nlo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UiQcxCPL7Pm5LiQyVCSKL0VdA+T83c6w5yVMEEdd+nN3ziq1Cr326u1qsYB1Vczkv
         /6L2dSI5cb6qaA5IkmlGG4GOS9Ms46m4jQYHuj+WhZPPa88DfljyHbEHdPtgmfLAd1
         rjKaZ3m3/GEtDSRYEywK3QriU8oEhNunF3M5iSLR56xP46UZROy33d3LhO9UEgls3X
         xw4nN3LWuetF1/qCkYmyZcmICLgMXvn8hBgbStgh+bVattuOKkIVprqgqJX0r2sios
         aOFDat+5jFr2boXuQtn8SRcch9IGl1a7wpHX4bx06cgeBWTSDiJySK5bOBubFYdkuH
         7JTspykPdrlYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01DECE270CB;
        Fri,  3 Feb 2023 09:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Add VCAP debugFS support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167541722100.18212.15632360857861253388.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Feb 2023 09:40:21 +0000
References: <20230202145337.234086-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230202145337.234086-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 2 Feb 2023 15:53:37 +0100 you wrote:
> Enable debugfs for vcap for lan966x. This will allow to print all the
> entries in the VCAP and also the port information regarding which keys
> are configured.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/Makefile   |  2 +
>  .../ethernet/microchip/lan966x/lan966x_main.c |  4 +
>  .../ethernet/microchip/lan966x/lan966x_main.h | 26 +++++
>  .../microchip/lan966x/lan966x_vcap_debugfs.c  | 94 +++++++++++++++++++
>  .../microchip/lan966x/lan966x_vcap_impl.c     | 26 ++---
>  5 files changed, 136 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c

Here is the summary with links:
  - [net-next] net: lan966x: Add VCAP debugFS support
    https://git.kernel.org/netdev/net-next/c/942814840127

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


