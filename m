Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B219675010
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjATJAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjATJAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E772E35A9;
        Fri, 20 Jan 2023 01:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 832DD61E71;
        Fri, 20 Jan 2023 09:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D70EFC4339E;
        Fri, 20 Jan 2023 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674205218;
        bh=XYwWfibzMqaOTMPJmOSyGrs30Nnfqge12Om0Go1KGi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JrkQXJHs9BK46+TkQp2kVLXIifwozNHtlyJ0RF4XVOijb2pQMIL1w2mY6Uw3Ob5YN
         xKyIQPu/DNQ0RGrGQ4njywrUrx5d1QYmGMj4c78UE06R/Kdsijnd2UQRRBGATUXmfT
         BbG5+VK1O4tbFJ56GIlER8dqUZ9CVfdeHSHI8zan01RElEyfn9Kfalg4F2RD0xwUiy
         lR/tkEb2tKd4I/00BBu0HtiosAR90UxdX4LkdHIeJUCgGqFW+x2vr6xIXMbtchHmC/
         WIPei0aX3n3AzScxOabJ7uV04yC3ZK8W79c9hROF7MaJXPbFPYPaQ3/bIIN1U19Y4N
         eLM+gFwa2lMAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9778C04E33;
        Fri, 20 Jan 2023 09:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next: PATCH v7 0/7] dsa: lan9303: Move to PHYLINK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167420521875.28394.1687143741537531165.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 09:00:18 +0000
References: <20230117205703.25960-1-jerry.ray@microchip.com>
In-Reply-To: <20230117205703.25960-1-jerry.ray@microchip.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, jbe@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 17 Jan 2023 14:56:56 -0600 you wrote:
> This patch series moves the lan9303 driver to use the phylink
> api away from phylib.
> 
> Migrating to phylink means removing the .adjust_link api. The
> functionality from the adjust_link is moved to the phylink_mac_link_up
> api.  The code being removed only affected the cpu port.  The other
> ports on the LAN9303 do not need anything from the phylink_mac_link_up
> api.
> 
> [...]

Here is the summary with links:
  - [net-next:,v7,1/7] dsa: lan9303: align dsa_switch_ops members
    https://git.kernel.org/netdev/net-next/c/9755126dc038
  - [net-next:,v7,2/7] dsa: lan9303: move Turbo Mode bit init
    https://git.kernel.org/netdev/net-next/c/1bcb5df81e4b
  - [net-next:,v7,3/7] dsa: lan9303: Add exception logic for read failure
    https://git.kernel.org/netdev/net-next/c/601f574a1b44
  - [net-next:,v7,4/7] dsa: lan9303: write reg only if necessary
    https://git.kernel.org/netdev/net-next/c/de375aa860fb
  - [net-next:,v7,5/7] dsa: lan9303: Port 0 is xMII port
    https://git.kernel.org/netdev/net-next/c/56e23d91bcfd
  - [net-next:,v7,6/7] dsa: lan9303: Migrate to PHYLINK
    https://git.kernel.org/netdev/net-next/c/332bc552a402
  - [net-next:,v7,7/7] dsa: lan9303: Add flow ctrl in link_up
    https://git.kernel.org/netdev/net-next/c/87523986570e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


