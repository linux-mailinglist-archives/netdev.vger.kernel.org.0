Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9545030D9
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356182AbiDOVx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356190AbiDOVxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:53:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5250370040;
        Fri, 15 Apr 2022 14:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8B9EB82E4A;
        Fri, 15 Apr 2022 21:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73C31C385B0;
        Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650059413;
        bh=wiHRfR4XBuq7L9kiWTvnz4A64dWQ9/Qm05/TywKALGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kiJoaFXZnx/L/lmFoUBd1kE3lDQXhFDb1D8ymhw1ibDzJgb/DGy5J3sfQ8KO2vxYy
         SfSpUp8C3ARqFMKOfGy820b1xYaMxS89SWB9pfrYzC3ZBuYU4fZac/1Zu9h093ZMc4
         HOoJENstjF3SbwTETtyFP1Yhe+z2cCHbz67oZgu/ENo9a24dstSZ6g8w0QnPpxOJKi
         4GQ8owmt0G+8fhcT7z/J8ESxleSvPvmF6EHEXdjK5Y7ncjDVVgUOdI07xNQbPJO+xr
         RutAfX+M5P/ew382VyjFqLF7q2i8ylx+UJWdqnWYzXF5xysdmOIl0/PA6WM13QGPk7
         e5qIQpTdbvI3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4ADB9EAC09B;
        Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: Make sure to release ptp interrupt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165005941330.21261.13931158856633410128.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 21:50:13 +0000
References: <20220413195716.3796467-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220413195716.3796467-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Apr 2022 21:57:16 +0200 you wrote:
> When the lan966x driver is removed make sure to remove also the ptp_irq
> IRQ.
> 
> Fixes: e85a96e48e3309 ("net: lan966x: Add support for ptp interrupts")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - [net] net: lan966x: Make sure to release ptp interrupt
    https://git.kernel.org/netdev/net/c/d08ed852560e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


