Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0AF65A9E7
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 13:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjAAMAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 07:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjAAMAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 07:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4227C26E6;
        Sun,  1 Jan 2023 04:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B38CE60DC7;
        Sun,  1 Jan 2023 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18E48C43396;
        Sun,  1 Jan 2023 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672574416;
        bh=03G23893obJXHd9u94ficDlaWgbgEq8qvL7fU2BFmfE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kTfR1AMxdEY0/la44WgmOmYI6eCzdHjgfl225FI2Y7AW8B6QieCQYIAYhPWCo8b3A
         k5eToQVdGx+4WUrhzwknVMr2wlFRheaobDlhkLaLyn/d2RvQ7AIZkTPCGtvX2ipX2P
         DAbWq1beUKoHh2SzX8rV29vfAgFa2Zw6SI6FVuSrGasCm312pF1uPCFGHfHHkOFAyD
         4aM378TjEMcKLaAzNMlMMgi7nHZTJV9zQHqdX9AtJ8h9522+8lf6hcwiV0eWIgzzzg
         b5dXX+uriYtSsAdYbxL52/mz5RVf/L2S0TGI+FDoi6YdToByARkYtt7wt/sFnSTbps
         M3KHb1/Lt9JBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E540BE5250A;
        Sun,  1 Jan 2023 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: Update documentation for get_rate_matching
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167257441593.10801.12314955236874636224.git-patchwork-notify@kernel.org>
Date:   Sun, 01 Jan 2023 12:00:15 +0000
References: <20221229202120.2774103-1-sean.anderson@seco.com>
In-Reply-To: <20221229202120.2774103-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 29 Dec 2022 15:21:20 -0500 you wrote:
> Now that phylink no longer calls phy_get_rate_matching with
> PHY_INTERFACE_MODE_NA, phys no longer need to support it. Remove the
> documentation mandating support.
> 
> Fixes: 7642cc28fd37 ("net: phylink: fix PHY validation with rate adaption")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> 
> [...]

Here is the summary with links:
  - [net] net: phy: Update documentation for get_rate_matching
    https://git.kernel.org/netdev/net/c/6d4cfcf97986

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


