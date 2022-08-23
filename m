Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDE359CDE8
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239314AbiHWBaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239132AbiHWBaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53D95A2CF;
        Mon, 22 Aug 2022 18:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71D91611DC;
        Tue, 23 Aug 2022 01:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C529CC433D7;
        Tue, 23 Aug 2022 01:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661218214;
        bh=XzZb29DVwzy20IIMZVX+5Zk6EASmCAI6RwoLxCMQ8eA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uD3aGzOTN771KzkaEByBhRKmWqjry7dGjRYZOqmFgA28ZLJdLbPoMfeJMnfrHH87w
         IlBmhx0wZ73S5Hl19lhYggj5MrjQxvbLcX1T05IZfGEPUF/sK2kn/JF/VpEP48PWhN
         GaLUlPEZMTtkfRGyT/rxRGWDOnJTSKmaG8rhMxZmm9/r0DgsB23DSovj85crq3KIfd
         sGIc5jOgvYXcMW9DotiO8pbgxrOfvqUXBA+WBDIAJqhCezzMxtA2KKLq2qjoeVaZmo
         Olq1jPL7k8BrUPqXOtHwVuBlNrKzdcgpETaKnw35YV+GMxiMcX04VE50OjFLzb70fY
         LunkuTQB1Ox1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA657E2A03D;
        Tue, 23 Aug 2022 01:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [v2][PATCH] net: phy: Don't WARN for PHY_READY state in
 mdio_bus_phy_resume()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166121821469.29630.864832018240851621.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 01:30:14 +0000
References: <20220819082451.1992102-1-xiaolei.wang@windriver.com>
In-Reply-To: <20220819082451.1992102-1-xiaolei.wang@windriver.com>
To:     Xiaolei Wang <xiaolei.wang@windriver.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 19 Aug 2022 16:24:51 +0800 you wrote:
> For some MAC drivers, they set the mac_managed_pm to true in its
> ->ndo_open() callback. So before the mac_managed_pm is set to true,
> we still want to leverage the mdio_bus_phy_suspend()/resume() for
> the phy device suspend and resume. In this case, the phy device is
> in PHY_READY, and we shouldn't warn about this. It also seems that
> the check of mac_managed_pm in WARN_ON is redundant since we already
> check this in the entry of mdio_bus_phy_resume(), so drop it.
> 
> [...]

Here is the summary with links:
  - [v2] net: phy: Don't WARN for PHY_READY state in mdio_bus_phy_resume()
    https://git.kernel.org/netdev/net/c/6dbe852c379f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


