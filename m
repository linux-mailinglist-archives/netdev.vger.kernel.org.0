Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1945B5E6EA9
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiIVVkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiIVVkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:40:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FAC10F72D;
        Thu, 22 Sep 2022 14:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A83C063299;
        Thu, 22 Sep 2022 21:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 018A9C43143;
        Thu, 22 Sep 2022 21:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663882850;
        bh=6HVl8SGe/EDQwAAYwGcRPcx03Stc2S5pnbVit6qv7O8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ALB0ltPmPi7VuomJQXAjJy2dfciPfaqomZjuvi1Ds0ppsqeRHR0q2z6/A00sGRn+U
         raOyK4bzYEDhjnYgIZzL3J3bVJlssC5LxUQzefM6Z7eN07jbyDLPXC9vvT8BptH/yj
         1KDHCXqSDZ2CIdl3kwvsR3dLjcEWgr30jN+yuqXwCJB+Y4oT/8D0XK/gBeOFfs1QPw
         KV/oZ5nhNQziPcW0ZM4kRNlYqMIKvDFSSw3+G5uxBqx3+YInzIgahDus4OcHMRLqV2
         4+J/fsksF+nA7mxj8323l5DloN4SsgFy3kguZGvQYccwLWTAEURR7u4YHVUHDm2wbb
         xJdXNRUzZdrwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4D25E4D03E;
        Thu, 22 Sep 2022 21:40:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: micrel: Fix double spaces inside
 lan8814_config_intr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166388284986.5692.9563993810587153824.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 21:40:49 +0000
References: <20220921065444.637067-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220921065444.637067-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
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

On Wed, 21 Sep 2022 08:54:44 +0200 you wrote:
> Inside the function lan8814_config_intr, there are double spaces when
> assigning the return value of phy_write to err.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: micrel: Fix double spaces inside lan8814_config_intr
    https://git.kernel.org/netdev/net-next/c/f8b2cce430d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


