Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C134BCA5D
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 20:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243017AbiBSTAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 14:00:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242406AbiBSTAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 14:00:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952CE59A53
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 11:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 787B3B80CC2
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 19:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 211E1C340EF;
        Sat, 19 Feb 2022 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645297210;
        bh=4s+pZ10VwmFAbBsa2+NYqWXuPVndw0ss0Iyzcbt4lHg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZzdEBXqxOKJ7XxVbuSQEolmUL1XgI19z6D4/yF1Vsf/Hd28arJ8jmrMUePkMGdSjF
         6brNNISseMMQd1dYDmegwITf1RFRoXRTeAn/e+Q1JzaSVDnTxwVU5uONmzg3xZQits
         TEfZgw6b1Zid6pSyTQBpMs73U2JdHIGXYhcL7h28cZwGyNPV0rtje/lwW30qeS91Jc
         V4xjGQL5JRaHJHTU2Pe5zX/gh4ZtFbEfaQgS8ZfUEWxh3/aj3M+kz4ojtkTPa49mB6
         3zn5bZPNdsgdY2T+GRrTn9ry9jLtYvsa8ZtEHnAGxN6yxhyzWZqcpOcahE3b/BFv2c
         cxY4hl81FmR6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A556E7BB08;
        Sat, 19 Feb 2022 19:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: microchip: add ksz8563 to ksz9477 I2C
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164529721003.31615.9708900588630714102.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 19:00:10 +0000
References: <20220218131540.1833838-1-a.fatoum@pengutronix.de>
In-Reply-To: <20220218131540.1833838-1-a.fatoum@pengutronix.de>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, kernel@pengutronix.de
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

On Fri, 18 Feb 2022 14:15:40 +0100 you wrote:
> The KSZ9477 SPI driver already has support for the KSZ8563. The same switch
> chip can also be managed via i2c and we have an KSZ9477 I2C driver, but
> that one lacks the relevant compatible entry. Add it.
> 
> DT bindings already describe this compatible.
> 
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: microchip: add ksz8563 to ksz9477 I2C driver
    https://git.kernel.org/netdev/net-next/c/173a272a9f17

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


