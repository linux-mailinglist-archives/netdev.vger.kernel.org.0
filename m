Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A5A60D7CC
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 01:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiJYXUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 19:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiJYXUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 19:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFBB3F1F9;
        Tue, 25 Oct 2022 16:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C028861BEC;
        Tue, 25 Oct 2022 23:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CF21C433B5;
        Tue, 25 Oct 2022 23:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666740017;
        bh=ne3U+oQfV5sNsgWjdiKzZ6svPdsA2np8PE8E18nZQi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cL+OWZkQVcBqHdgXAJ2ep6G38PNv5qwT9uJil6CEOBqWyrHMwflCzfKIPL/F6E8hQ
         nsE/2ba9iYtK7+czRDPcyO7VSj5oSe2cqsn6aYDy035CAR8d5b3NPQdRy3nMeMBQtX
         WydyMuxOrK3PvP51xvjRT5wWfvF+5uoUIC4W0p6M7IVxla+RGky0k2L7mBQwyvatTE
         mAkkn2AtDntHblHDa8trJSpGyfOT729uSS16peRktY4ZqbY4lJtqsJ9kgl3syzw3d6
         rJgZuwI8UpkMl5i2C/Iv1DoKpD2tVrU8ljtkzNjD/Aurbnk/8GD4nHLJ99c6uxaFXm
         QMN+0ENw3e0WA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F33D4E45192;
        Tue, 25 Oct 2022 23:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V1 0/2] net: lan743x: PCI11010 / PCI11414 devices
 Enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166674001698.2407.17199010916093041489.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 23:20:16 +0000
References: <20221024082516.661199-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20221024082516.661199-1-Raju.Lakkaraju@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        hkallweit1@gmail.com, pabeni@redhat.com, edumazet@google.com,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, Ian.Saturley@microchip.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Oct 2022 13:55:14 +0530 you wrote:
> This patch series continues with the addition of supported features for the
> Ethernet function of the PCI11010 / PCI11414 devices to the LAN743x driver.
> 
> Raju Lakkaraju (2):
>   net: lan743x: Add support for get_pauseparam and set_pauseparam
>   net: phy: micrel: Add PHY Auto/MDI/MDI-X set driver for KSZ9131
> 
> [...]

Here is the summary with links:
  - [net-next,V1,1/2] net: lan743x: Add support for get_pauseparam and set_pauseparam
    https://git.kernel.org/netdev/net-next/c/cdc045402594
  - [net-next,V1,2/2] net: phy: micrel: Add PHY Auto/MDI/MDI-X set driver for KSZ9131
    https://git.kernel.org/netdev/net-next/c/b64e6a8794d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


