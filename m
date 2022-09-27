Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B215EBDED
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 11:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiI0JAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 05:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiI0JAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 05:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716F8BF55
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 02:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B87361736
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BAEDC433B5;
        Tue, 27 Sep 2022 09:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664269216;
        bh=e7QtIrtYBjlr8nslaX3mE2mcmcffKHg2cBzWh3DcwW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bfwyM488uHaW5SEWQMeIJfZ/gJMapBnx3H+fjK7SQyBrMsAF2Z41TYVOUTzFPqHQz
         G1sAVEiQqKNWp28zVQtsm/byupCFQRzaViGuN+9CUyhunkMfAf5Kv9RrZdijxlrF1E
         ZR0T88uyZemyygIYo1Kn7zA2XD9rgjc1Kxa8fvfvKhJ3AvGR42nlKjxeVY6exsK4Uq
         r9TF5FyESgpjWSK91snl0XH2AvW8kH0IGJSRWPySFZBm6B5JngUU98kvX0lwDwSDPV
         RN3ERJ8OyqIoZv6Zi1jcN0ZhEAQMNVQhivpTtK+JrJbPl+qYgTwSkyyu3xd1viV209
         fzEvGHw0c6stA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4DA59E21EC2;
        Tue, 27 Sep 2022 09:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: Don't WARN for PHY_UP state in
 mdio_bus_phy_resume()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166426921631.22762.7317829989157057472.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 09:00:16 +0000
References: <8128fdb51eeebc9efbf3776a4097363a1317aaf1.1663905575.git.lukas@wunner.de>
In-Reply-To: <8128fdb51eeebc9efbf3776a4097363a1317aaf1.1663905575.git.lukas@wunner.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        m.szyprowski@samsung.com, f.fainelli@gmail.com,
        xiaolei.wang@windriver.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 23 Sep 2022 06:09:52 +0200 you wrote:
> Commit 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume()
> state") introduced a WARN() on resume from system sleep if a PHY is not
> in PHY_HALTED state.
> 
> Commit 6dbe852c379f ("net: phy: Don't WARN for PHY_READY state in
> mdio_bus_phy_resume()") added an exemption for PHY_READY state from
> the WARN().
> 
> [...]

Here is the summary with links:
  - [net] net: phy: Don't WARN for PHY_UP state in mdio_bus_phy_resume()
    https://git.kernel.org/netdev/net/c/ea64cdfad124

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


