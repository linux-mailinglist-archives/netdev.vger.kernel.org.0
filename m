Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A116DC080
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 17:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjDIPKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 11:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDIPKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 11:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BA13A8B;
        Sun,  9 Apr 2023 08:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D3166129B;
        Sun,  9 Apr 2023 15:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78890C4339B;
        Sun,  9 Apr 2023 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681053018;
        bh=Y3XnYkvTvitAUptLkNKbR5RSicvmDHt3b1Jbd032iMs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ru1isXrweGl8BajnnSnFvHm+Uq2cKlAT1leKWTeghi4IGfEuHXyiTm9oYQQrgMx4X
         gVLKzw3YdFaXseI077WSMO0svv393sf8M9jIWFXPLFxqxKcBjSJJZpcjEzJL1amShH
         TnHfOMAgrEtRIcAQIQOqXlIRe9X3mT9RQsYSaMrCXrIy9xvmRLlDXHuex7riW4VGQ4
         44K8zb9JX5k4r7Ru4ua1/9zBSVcIyy/CttmZfAE4MYCSdkfN8UM2KLk8xEyk+7ua9z
         BOhKdwT+wC5UIX2z3MzeiYiquIQKMMjeTyI82WFtBLXoWEZdZRCRfYBPJl4LPJGAfC
         PwcRBZ9W8Bl4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B0B8C41671;
        Sun,  9 Apr 2023 15:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] fix EEPROM read of absent SFP module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168105301836.30484.7699646579185070027.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Apr 2023 15:10:18 +0000
References: <20230406130833.32160-1-i.bornyakov@metrotek.ru>
In-Reply-To: <20230406130833.32160-1-i.bornyakov@metrotek.ru>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        system@metrotek.ru
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Apr 2023 16:08:31 +0300 you wrote:
> The patchset is to improve EEPROM read requests when SFP module is
> absent.
> 
> ChangeLog:
> v1:
> https://lore.kernel.org/netdev/20230405153900.747-1-i.bornyakov@metrotek.ru/
> v2:
>   * reword commit message of "net: sfp: initialize sfp->i2c_block_size
>     at sfp allocation"
>   * add second patch to eliminate excessive I2C transfers in
>     sfp_module_eeprom() and sfp_module_eeprom_by_page()
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: sfp: initialize sfp->i2c_block_size at sfp allocation
    https://git.kernel.org/netdev/net/c/813c2dd78618
  - [net,v2,2/2] net: sfp: avoid EEPROM read of absent SFP module
    https://git.kernel.org/netdev/net/c/bef227c1537c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


