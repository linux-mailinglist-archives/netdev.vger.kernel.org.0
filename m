Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2EF6C0ED5
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjCTKbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCTKbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:31:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CBD18A9D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 03:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC0AAB80DD2
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60881C433D2;
        Mon, 20 Mar 2023 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679308219;
        bh=rXuSKwVwxX8rt7Sqws0Z+AcbgMjTP+lu21XR3bzS4Mo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BGrZzpodkdWz3pEVV71RiWhM1hhb8kEixc3CpWkxdgROOzfTHmeM277lNs6xl5jlw
         m8h8yizg8/NDMkWsiylK5HJTJpfV80MbZAjWdSSla4IPyjGI3IltuNUjlXn8XEY2J9
         MntGP7XiB/HGvrTL4909168OfwLMGBlrKO4+GXO27YlJPMcsI9K5WX3RqyTxx/8HTc
         8uSKeW7c8xPu5dccJNtAC4JD3qZJS438HLgKaGyvGckwwjdCQeGu+pxHbw3D6lvRi/
         iCXc/z5QoLefn10XipPhbkDPpo4AkieUxA4GHvADDTLJhmtOLq3ioLn8k/56g1PHPN
         T8U3ocfIkrN8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B6E8C395F4;
        Mon, 20 Mar 2023 10:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: phy: reuse SMSC PHY driver functionality in
 the meson-gxl PHY driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167930821930.19842.15095220443783373763.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Mar 2023 10:30:19 +0000
References: <683422c6-c1e1-90b9-59ed-75d0f264f354@gmail.com>
In-Reply-To: <683422c6-c1e1-90b9-59ed-75d0f264f354@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, neil.armstrong@linaro.org,
        khilman@baylibre.com, jbrunet@baylibre.com,
        martin.blumenstingl@googlemail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, cphealy@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 18 Mar 2023 21:30:01 +0100 you wrote:
> The Amlogic Meson internal PHY's have the same register layout as
> certain SMSC PHY's (also for non-c22-standard registers). This seems
> to be more than just coincidence. Apparently they also need the same
> workaround for EDPD mode (energy detect power down). Therefore let's
> reuse SMSC PHY driver functionality in the meson-gxl PHY driver.
> 
> Heiner Kallweit (2):
>   net: phy: smsc: export functions for use by meson-gxl PHY driver
>   net: phy: meson-gxl: reuse functionality of the SMSC PHY driver
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: phy: smsc: export functions for use by meson-gxl PHY driver
    https://git.kernel.org/netdev/net-next/c/a69e332b4ef9
  - [net-next,2/2] net: phy: meson-gxl: reuse functionality of the SMSC PHY driver
    https://git.kernel.org/netdev/net-next/c/be66fcc16ce6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


