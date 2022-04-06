Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA324F648C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbiDFQAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbiDFQAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D292255AB7;
        Wed,  6 Apr 2022 06:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05226B823DD;
        Wed,  6 Apr 2022 13:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BD5AC385A7;
        Wed,  6 Apr 2022 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649251817;
        bh=r0Jkg5TINenFot4Tj/g1Ta9k+qUla3NNZ2acVa9ZqqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f2lALW/iqquEnYqMFl+Q8Bc3OucCzWmO9VeeJdHeu9Gv5ixZR2hQ6F/MlC68mHsQU
         k0rXAWLgr+Vg0RbCrj06h3WL7F5TtI9s9AKEMxxxNdfdnlfVhAceeqSXVb5DnDHRM6
         qYbJ5R9NvN+r+RsgLfKsEEGCbW9X05f4VK5eJzjjfKNmJRtUTYNFBr6dz0Oi7o2dl8
         kINPKBjoOCZr24mzDE1Txwx4Iqv1sebOSv1hIVltYDqgic9IuV2urjDjb/JgMRP9Qf
         EZ9Xb5d0WH+wa49QslmlrTEdftoUp+hgzPBPjChmNWdoxJeoxU7Y1r3OseVElFucho
         OXQ7xEAjLwdFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D7DDE85D15;
        Wed,  6 Apr 2022 13:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] net: phy: mscc-miim: add MDIO bus frequency
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925181750.19554.8207066606756390444.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 13:30:17 +0000
References: <20220405120951.4044875-1-michael@walle.cc>
In-Reply-To: <20220405120951.4044875-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        alexandre.belloni@bootlin.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  5 Apr 2022 14:09:48 +0200 you wrote:
> Introduce MDIO bus frequency support. This way the board can have a
> faster (or maybe slower) bus frequency than the hardware default.
> 
> changes since v2:
>  - resend, no RFC anymore, because net-next is open again
> 
> changes since v1:
>  - fail probe if clock-frequency is set, but not clock is given
>  - rename clk_freq to bus_freq
>  - add maxItems to interrupts property
>  - put compatible and reg first in the example
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] dt-bindings: net: convert mscc-miim to YAML format
    https://git.kernel.org/netdev/net-next/c/ed941f65da81
  - [net-next,v3,2/3] dt-bindings: net: mscc-miim: add clock and clock-frequency
    https://git.kernel.org/netdev/net-next/c/b0385d4c1fff
  - [net-next,v3,3/3] net: phy: mscc-miim: add support to set MDIO bus frequency
    https://git.kernel.org/netdev/net-next/c/bb2a1934ca01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


