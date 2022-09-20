Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679435BE9BA
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiITPKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiITPKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CEA17E1D;
        Tue, 20 Sep 2022 08:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F08CB82A8E;
        Tue, 20 Sep 2022 15:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DB2DC43144;
        Tue, 20 Sep 2022 15:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663686616;
        bh=oYSh/U3z7ijrPAXsY6krRv1Q6/5AWE1umds5AazKZHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=duVAJffRkEoV73sPoy3a5MPSkKK5mQ9g9Isq3CPRtfa6whfJTzJ/S4V9HF8wtJF15
         YkkmfKR9WAr1nHbmc19tVia8P6PQA1jJM61qtD7pey0bDuul42b6+SKDFD1f5gy987
         uguw3LMf2Xz1rl0e7o/3ww/N5TOLjBw5kfjtf4SZsJSv+R7fNG/lll8qpwqqLyNUo7
         CRGp8R/DaOLs9ZTI7Bz1bEG9HX2FjM5jWydk292B6mOiUbpQr3wOIjXB1n3QuoVVT9
         +4yK9tbSErU4NQ3FLqfB/B0d0DBMRktMRZEIk7F5NI6wnpV5ojcp6BgEr7w9sS7uln
         5Xg/3yhaypj5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03756E21EDF;
        Tue, 20 Sep 2022 15:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: micrel: Add interrupts support for
 LAN8804 PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368661600.24945.2457944521487534827.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 15:10:16 +0000
References: <20220913142926.816746-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220913142926.816746-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michael@walle.cc, UNGLinuxDriver@microchip.com
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

On Tue, 13 Sep 2022 16:29:26 +0200 you wrote:
> Add support for interrupts for LAN8804 PHY.
> 
> Tested-by: Michael Walle <michael@walle.cc> # on kontron-kswitch-d10
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> v1->v2:
> - add Tested-by and Reviewed-by tags
> - add better comments
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: micrel: Add interrupts support for LAN8804 PHY
    https://git.kernel.org/netdev/net-next/c/b324c6e5e099

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


