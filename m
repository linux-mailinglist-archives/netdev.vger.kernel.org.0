Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD4A573767
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 15:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiGMNaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 09:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiGMNaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 09:30:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3BE5FB3;
        Wed, 13 Jul 2022 06:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C16D2B81F67;
        Wed, 13 Jul 2022 13:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6753DC341C0;
        Wed, 13 Jul 2022 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657719014;
        bh=70DM+t3VNVd08vk92Wi0LMZ0cOiZyno06vjU/P3PUkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LE9frzlchOu6e9V/HH+2Kn8Ug+AbfDM4BqNVN21yJIMjt4HnZTk7GoL5MOPGh/KQo
         DjuvaN805ltU76g+aEucqPq3L8c9V7+1oN6Ys8uEcS37xDprlsmsW9f2QnJCV4QVx7
         LLGYHKsa1Bl3sfIPMm3lp0qbsCtrsWa8EjZtTKhLswO9T/qhyO11bBkIsnRPDt4lsv
         gtdStjwlXAMXDGhiPOZgoGs7zdVjEtFaMgzkDa/gFt3tmfScHU3dFGuD+fN4+7n/Jn
         dt8Ydxfq9J9g2x2G+CfAZothKDsvY5BUfoonK/6ybLOtWqXnY8b6WGAxA2u1YKLogw
         YrX6oCa2Y+AYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43DD5E45227;
        Wed, 13 Jul 2022 13:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: phy: mxl-gpy: version fix and improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165771901427.29411.1670277861972120585.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 13:30:14 +0000
References: <20220712131554.2737792-1-michael@walle.cc>
In-Reply-To: <20220712131554.2737792-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     lxu@maxlinear.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Jul 2022 15:15:50 +0200 you wrote:
> Fix the version reporting which was introduced earlier. The version will
> not change during runtime, so cache it and save a PHY read on every auto
> negotiation. Also print the version in a human readable form.
> 
> Michael Walle (4):
>   net: phy: mxl-gpy: fix version reporting
>   net: phy: mxl-gpy: cache PHY firmware version
>   net: phy: mxl-gpy: rename the FW type field name
>   net: phy: mxl-gpy: print firmware in human readable form
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: phy: mxl-gpy: fix version reporting
    https://git.kernel.org/netdev/net-next/c/fc3dd0367e61
  - [net-next,2/4] net: phy: mxl-gpy: cache PHY firmware version
    https://git.kernel.org/netdev/net-next/c/1db858707850
  - [net-next,3/4] net: phy: mxl-gpy: rename the FW type field name
    https://git.kernel.org/netdev/net-next/c/1e9aa7baf096
  - [net-next,4/4] net: phy: mxl-gpy: print firmware in human readable form
    https://git.kernel.org/netdev/net-next/c/d523f2eb1dad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


