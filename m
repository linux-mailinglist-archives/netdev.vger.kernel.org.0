Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E69E676308
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 03:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjAUCUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 21:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjAUCUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 21:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC1C7CCDB;
        Fri, 20 Jan 2023 18:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 427FBB82B65;
        Sat, 21 Jan 2023 02:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6920C433A0;
        Sat, 21 Jan 2023 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674267617;
        bh=y7M014lk2ucYfpZYK7TqpOQMfKJdndxwV/Xbmbc3ajM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CnDdZvkIowhY0c5wUZf47RObO9PPZANK2I1QmDStTRJAHmY9doWdiHtZb1FqVl6+B
         jlMiFNhigYJ3pwux+rrfhM0uzWUzGkM8ho7OAsX2WrqpsyL/akeHYXEAktPwQep3C7
         lyOMT6SnVOP8pvekYptS0RE9CYHj4ODIvjMivZuZL0lcdhi5tR9HJl5HKSkt6WI8Wo
         IGyi4/0uxcFxt3LD/51/05EY8YwL5BnYO7iaeHrQad97ZPtyRK9u4257ZuLJ55ji/m
         RKB1zTEcvGI/a+Le7ssOPUX9OVWImRXhWZAo5Wt2VY+5/a5KWSQmmxJE/1gTwxZqCW
         qOzjEI8CtoV2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BBB08C04E34;
        Sat, 21 Jan 2023 02:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next 0/4] net: mdio: Remove support for building
 C45 muxed addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167426761776.30830.16011679653553684585.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Jan 2023 02:20:17 +0000
References: <20230119130700.440601-1-michael@walle.cc>
In-Reply-To: <20230119130700.440601-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, clement.leger@bootlin.com, afaerber@suse.de,
        mani@kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo@kernel.org, matthias.bgg@gmail.com, wellslutw@gmail.com,
        jiawenwu@trustnetic.com, mengyuanlou@net-swift.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, tobias@waldekranz.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 19 Jan 2023 14:06:56 +0100 you wrote:
> [Russell told me that his mailserver rejected my mail because of
> an ill-formated "To:" header. Resending now with plain git-send-email
> instead of b4 send.]
> 
> I've picked this older series from Andrew up and rebased it onto
> the latest net-next.
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,1/4] net: phy: Remove fallback to old C45 method
    https://git.kernel.org/netdev/net-next/c/db1a63aed89c
  - [RESEND,net-next,2/4] net: ngbe: Drop mdiobus_c45_regad()
    https://git.kernel.org/netdev/net-next/c/45d564bf3625
  - [RESEND,net-next,3/4] net: Remove C45 check in C22 only MDIO bus drivers
    https://git.kernel.org/netdev/net-next/c/660a57046035
  - [RESEND,net-next,4/4] net: mdio: Remove support for building C45 muxed addresses
    https://git.kernel.org/netdev/net-next/c/99d5fe9c7f3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


