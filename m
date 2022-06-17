Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276B154EFEC
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 06:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbiFQEAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 00:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiFQEAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 00:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A628466693
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 21:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FA3361DD4
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 04:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F9C4C3411C;
        Fri, 17 Jun 2022 04:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655438413;
        bh=7LoGj4QHDrOG7McfRfEcvpyilJxnf1DqsixuY34wPJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RBtC+spX1Jr0GtJc4AaOaFo7pcKlNe0ekZLtisT8/cSXlXTPw4DUdhhPzTkoYmMVp
         9RFbmVLKNhzW8zwifir08BCa12tlQI0ANRLAt8w5dOSbR8mIfTHJalRI8UWYV94GK6
         tTMqYUUjWURwgLMFW6s6BiWYa8fdw0xGKQMovZrQZGnUkMHKevBm+bFpO1qHt5Ssb3
         euqIjEMH6Gs/KeilcIUwBVY7D7arptNLpqhb2OVAy+YolGPS2QG/T+/e3N60kmWHkX
         GfpvjQj3B7BMTML5OTL5NdDLWDKB+fy7oh1BRqXW0WW+GD6nToboh4XhJP3ARxIk9E
         2pGy+kTPhsuUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67A5DE73858;
        Fri, 17 Jun 2022 04:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH,
 net] phy: aquantia: Fix AN when higher speeds than 1G are not advertised
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165543841341.6232.3167995297931505011.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 04:00:13 +0000
References: <20220610084037.7625-1-claudiu.manoil@nxp.com>
In-Reply-To: <20220610084037.7625-1-claudiu.manoil@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, ondrej.spacek@nxp.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Jun 2022 11:40:37 +0300 you wrote:
> Even when the eth port is resticted to work with speeds not higher than 1G,
> and so the eth driver is requesting the phy (via phylink) to advertise up
> to 1000BASET support, the aquantia phy device is still advertising for 2.5G
> and 5G speeds.
> Clear these advertising defaults when requested.
> 
> Cc: Ondrej Spacek <ondrej.spacek@nxp.com>
> Fixes: 09c4c57f7bc41 ("net: phy: aquantia: add support for auto-negotiation configuration")
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] phy: aquantia: Fix AN when higher speeds than 1G are not advertised
    https://git.kernel.org/netdev/net/c/9b7fd1670a94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


