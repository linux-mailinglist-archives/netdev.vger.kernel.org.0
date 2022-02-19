Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F784BC96C
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 17:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237566AbiBSQua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 11:50:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiBSQu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 11:50:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62635FF10
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 08:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D73060BA7
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 16:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B140AC340EC;
        Sat, 19 Feb 2022 16:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645289409;
        bh=IPDUAskJBqOfAzrer+VYvOkwNond7XQvyNtwHXG97Og=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qj23B914Qyw68JbDoJm1OnT8lKKYzd+yOaPegCnAMfjPoC4u/Vyam29bdmrrIaySw
         RS5ZNrgM7BXwOLZigcUcTqIyyQrTc8s9AFz1tEkk6lPwkV6vVvjaeCneiSkOlAGFM2
         BxxY0syL910CCWkj7IG331ttvJ9r6MZnRqqyE03NPSUxUCAqktf+8BSKejGCPyhn7s
         VhqpCvW/tbvrE3JUvVNmvG87vaTc+j1aJU/KYp5OlmB68h34br69xCjDK4qF7qly5e
         D7ZOD+WwYVER4zpl5JvhWx0stLgj79lXmp45m7279dWcvlaKrX4z+PEJ9bfjols0Xe
         fJLt3NiIZ0Njg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 978F9E5D07D;
        Sat, 19 Feb 2022 16:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: phylink: remove pcs_poll
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164528940961.11889.4326607907069613825.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 16:50:09 +0000
References: <YhDYpHEBHGCVo+2z@shell.armlinux.org.uk>
In-Reply-To: <YhDYpHEBHGCVo+2z@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, olteanv@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 19 Feb 2022 11:46:44 +0000 you wrote:
> Hi,
> 
> This small series removes the now unused pcs_poll members from DSA and
> phylink. "git grep pcs_poll drivers/net/ net/" on net-next confirms that
> the only places that reference this are in DSA core code and phylink
> code:
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: remove pcs_poll
    https://git.kernel.org/netdev/net-next/c/ccfbf44d4c7f
  - [net-next,2/2] net: phylink: remove phylink_config's pcs_poll
    https://git.kernel.org/netdev/net-next/c/64b4a0f8b51b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


