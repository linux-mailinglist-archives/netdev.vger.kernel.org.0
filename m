Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C932A4AA995
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 16:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349933AbiBEPKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 10:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244872AbiBEPKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 10:10:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5DDC061348;
        Sat,  5 Feb 2022 07:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 900A460F57;
        Sat,  5 Feb 2022 15:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F11A7C340F0;
        Sat,  5 Feb 2022 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644073810;
        bh=llh/LMG/LWC77c6+KJBB2VKDIL4BsfkIFb4rp3JFVB4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FxMFZ8bGQVEZpjjw8Ngi86ssIfDRR8IGnt68TM4GBc0IwtsWxBpLH3s8l0CMqFvR0
         EK5SOy57rG75BXmS7fB2IWOCdorr8/MQ6GmnXsUU4Bv6YD37tS13szJVeDp1G4zjyN
         v058yXEAihqLKRSzVKrZCrQuFKCYQvpjB9u/ujrPbckVrtZY/fmpntxFEnkOza+fFC
         KUCE+ZduPMhdNJzSkZ8COPGokpeYLpjPzNUkANMCY/xPbwXk4XUomDRMuQTriawzCx
         t8eVWYm22y1O7FYqHlB73F299nhNgDoyBTFkTIt7HhiMreibrIKUnWRtJcXh4kAuT+
         2DrLj0j7slLgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D97EDE6D3DE;
        Sat,  5 Feb 2022 15:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: qca8k: check correct variable in
 qca8k_phy_eth_command()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407380987.16413.8541377022113087007.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 15:10:09 +0000
References: <20220204100336.GA12539@kili>
In-Reply-To: <20220204100336.GA12539@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     andrew@lunn.ch, ansuelsmth@gmail.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 4 Feb 2022 13:03:36 +0300 you wrote:
> This is a copy and paste bug.  It was supposed to check "clear_skb"
> instead of "write_skb".
> 
> Fixes: 2cd548566384 ("net: dsa: qca8k: add support for phy read/write with mgmt Ethernet")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/dsa/qca8k.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: dsa: qca8k: check correct variable in qca8k_phy_eth_command()
    https://git.kernel.org/netdev/net-next/c/c3664d913dc1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


