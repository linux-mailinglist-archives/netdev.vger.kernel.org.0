Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACED66DDDB
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 13:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbjAQMke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 07:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236824AbjAQMkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 07:40:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ED236FD2
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 04:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0464261326
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B85CC433F0;
        Tue, 17 Jan 2023 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673959216;
        bh=2UDCkV0bgdIjdS7VhPD6yzF5PvsdrjfBfyOdObiLeE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HTXVpcPieARlFtCZoyp3He7Nq1gJXccMkAm9PWJ2X5cxof4fEQsi+I0QAf3sr6y+O
         EnF8WLu7qEQ4BN6HUg1oxkZHNmXBgGiEt5zFW9K+U5OdaZhOjUOYuxAJixWR3hMqhC
         AZJO8NDoynKspYjNpnBriZ0Rkb57sYeSi/pLilDFAVnNCeFaQpDXdCCQsfjmMnnQOq
         cl0G8xMon7yAXuPYPyGkfUG/Lxr8TOunIlCqdhrah5z7iPj0IuAf/JpD4AKNKXW1HN
         1mAJxvQ3FKE1bjozBI8XK1Yww9tnQY2m3fl3/onJ3tjkfrpTv3sgcgbsHobASEBpM7
         E18+6sWXsb18Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 357E3C43147;
        Tue, 17 Jan 2023 12:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: fix invalid call to mdiobus_get_phy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167395921621.25931.2279111710987726492.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Jan 2023 12:40:16 +0000
References: <669f9671-ecd1-a41b-2727-7b73e3003985@gmail.com>
In-Reply-To: <669f9671-ecd1-a41b-2727-7b73e3003985@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 15 Jan 2023 18:24:08 +0100 you wrote:
> In a number of cases the driver assigns a default value of -1 to
> priv->plat->phy_addr. This may result in calling mdiobus_get_phy()
> with addr parameter being -1. Therefore check for this scenario and
> bail out before calling mdiobus_get_phy().
> 
> Fixes: 42e87024f727 ("net: stmmac: Fix case when PHY handle is not present")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: fix invalid call to mdiobus_get_phy()
    https://git.kernel.org/netdev/net/c/1f3bd64ad921

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


