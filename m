Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96934EAA67
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 11:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbiC2JVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 05:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiC2JVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 05:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BDB22511;
        Tue, 29 Mar 2022 02:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82AF760C68;
        Tue, 29 Mar 2022 09:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5033C34110;
        Tue, 29 Mar 2022 09:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648545610;
        bh=3+Xxf4ZeoxhFAkn2U86wP3Y1R0YdU8rlp9MCz1wnac0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rePH5s5VcHiHzuQV0oKPU7SSBxNgDrHMWIjcruEE3u947kchNkIl91n/99/oET0dN
         YRaTWsbyP8U7C9Sf5B6N+wFJ8iRhf7zjQL8UepZ3uxSqNC0SJFoLGqijnjN9UgzmwO
         u6RoCEzA5VHrL20ODxHJr1116CTVxxT/7qXypC1WgeKN7pkvGz84zUFkl4M6vy7l/l
         QyffH3sTv2h9CU87dYmHeJyt6ILb7q9dGfewOb/hy9jCDbifqBFknooKgEgSKTsKCS
         NqVvordxRkWD+rE7HbBGm2+zRYLqzpDth+AyQ4Gs1mlDfZudGFxhY3osYTUU+f9SM1
         iOE3NkccYW9RA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF22FF03848;
        Tue, 29 Mar 2022 09:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: lan966x: fix kernel oops on ioctl when I/F is
 down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164854561084.720.4654566732650137898.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Mar 2022 09:20:10 +0000
References: <20220328220350.3118969-1-michael@walle.cc>
In-Reply-To: <20220328220350.3118969-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     horatiu.vultur@microchip.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 29 Mar 2022 00:03:50 +0200 you wrote:
> ioctls handled by phy_mii_ioctl() will cause a kernel oops when the
> interface is down. Fix it by making sure there is a PHY attached.
> 
> Fixes: 735fec995b21 ("net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP")
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> changes since v1:
>  - reword commit message
>  - test for the presence of phydev instead of the interface state
>  - move the test just before phy_mii_ioctl()
> 
> [...]

Here is the summary with links:
  - [v2,net] net: lan966x: fix kernel oops on ioctl when I/F is down
    https://git.kernel.org/netdev/net/c/ad7da1ce5749

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


