Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7127167A8E1
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjAYCkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjAYCkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2BA48A10
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 18:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54E8C6143D
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8AFCC433A7;
        Wed, 25 Jan 2023 02:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674614417;
        bh=LmctKrvYULl/oFHzuqsPwROS+7DauHmcJUPTQc24Wsk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TndcJUKjo+LZTi0EXb9x4pXa7bPTg8ipt/eKQ7K3nvaepWNSY0foppm/ACdWOaqTM
         H36+8bbnX7iSfvFAWgTu1nlG/5/kAGkZMOHGiNivE/oeImYcJ2OH1U7bwPbN6C5q4m
         ASHUgSXecbYCT9B3zXsaj7HabTiiA/1h7gVjHbv7mrU2EUaqfVugEg6Z1TA9ati6tO
         xtjTBYkcM42H2R0hs3GeSq1IrvhJcEu3v9G91YaesogDB1gYQ/ngAER9Gl30pCm30N
         U3mE7TcE5guT+Ty6mIMW3ku7Ehq1zmm77SzceUy9g8Rxeu8sYXOtTvEHAIVETYu181
         5/5ZEJUcUxfiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92BA3F83ED2;
        Wed, 25 Jan 2023 02:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mscc: ocelot: fix incorrect verify_enabled
 reporting in ethtool get_mm()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167461441759.2895.13838018572966432967.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 02:40:17 +0000
References: <20230123184538.3420098-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230123184538.3420098-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com
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

On Mon, 23 Jan 2023 20:45:38 +0200 you wrote:
> We don't read the verify_enabled variable from hardware in the MAC Merge
> layer state GET operation, instead we always leave it set to "false".
> The user may think something is wrong if they set verify_enabled to
> true, then read it back and see it's still false, even though the
> configuration took place.
> 
> Fixes: 6505b6805655 ("net: mscc: ocelot: add MAC Merge layer support for VSC9959")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mscc: ocelot: fix incorrect verify_enabled reporting in ethtool get_mm()
    https://git.kernel.org/netdev/net-next/c/28113cfada8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


