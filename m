Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413465E64C3
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiIVOKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiIVOKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:10:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471886DF99;
        Thu, 22 Sep 2022 07:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84EA3B83728;
        Thu, 22 Sep 2022 14:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F1CFC43140;
        Thu, 22 Sep 2022 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663855816;
        bh=9hDz8LF/JtMzE3nSoq00qitxuaRTsvB+1P7XEjT47fE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aC9pr2fKfuQVogHD1G08KWVLMb20xq9+fMdzjF6BzhjyKo/YD/+UjiWWvBLr2JeKJ
         Yq1B2tEKzwHpNWo4s5+AdvPpBwxLSfTVNQKu+Lrv7IbqpPP28XUGwcDBX9dtxlBEq2
         TnPA4MK6yiGBxlW9hObYmPSykLRIQ4Ct4tQTQdxFGIlD3+COAfVWEF9qXNBoSTWJfb
         rxxzHJVAOVTzt/dmdjcpp4wH2YEZ0epAceve0KbFd1CmD+CDy5W9evvDbKA1foI2WZ
         aguq3y2Xqjpl+19K6iH3wLigYufQnqBLVAQo8lwHjBSfpNtgrL2FmgKSuWMaI6UyqP
         7rgUmCM+QmK4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2276FE50D6C;
        Thu, 22 Sep 2022 14:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: micrel: fix shared interrupt on LAN8814
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166385581613.2095.3356669328415563265.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 14:10:16 +0000
References: <20220920141619.808117-1-michael@walle.cc>
In-Reply-To: <20220920141619.808117-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 20 Sep 2022 16:16:19 +0200 you wrote:
> Since commit ece19502834d ("net: phy: micrel: 1588 support for LAN8814
> phy") the handler always returns IRQ_HANDLED, except in an error case.
> Before that commit, the interrupt status register was checked and if
> it was empty, IRQ_NONE was returned. Restore that behavior to play nice
> with the interrupt line being shared with others.
> 
> Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> [...]

Here is the summary with links:
  - [net] net: phy: micrel: fix shared interrupt on LAN8814
    https://git.kernel.org/netdev/net/c/2002fbac743b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


