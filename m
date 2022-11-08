Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DD16206CB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiKHCa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiKHCaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02A3140B6;
        Mon,  7 Nov 2022 18:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97E06B8189A;
        Tue,  8 Nov 2022 02:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35E6AC43147;
        Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667874616;
        bh=1hYnMgfurIKVnqS2BSMFp3XJTtcvbl4vCIjx0mlf2hc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=corZkn9pLiTNJeebW0flJi865e5dD2UeDQ+8JGk7sNL3V2a4kHdhDOxRXG+71pGQh
         tCXiG+7o3v6mOeeLKPu/57tG+LrMlFVD7nqaY2jNgLYhnSBCgmww0rJG7PwT0mxFnQ
         DHxnQCH1iiCovuIwHQEB2ax8KYZE908axQ2TH0zhLT1QN+KgiKG+fXYAZln7wzSx1c
         xLSmupP5T9DNXlQ5kAQMlI+UjIri6aFHbnH8+eTsabgCIM0uqdp5Hnjozuz1polESL
         E6gbQ8xo0SfxSmjlEMum1OAGCuWMzRPfJ+fqvK6trB9aq3D6aY8DWf5B8RV3VZKAfR
         1cuX6y9Fyloug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1BC44C73FFC;
        Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: remove explicit phylink_generic_validate()
 references
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166787461610.16737.3952195755714134439.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 02:30:16 +0000
References: <E1or0FZ-001tRa-DI@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1or0FZ-001tRa-DI@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     joyce.ooi@intel.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, chris.snook@gmail.com,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        ioana.ciornei@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@nxp.com, thomas.petazzoni@bootlin.com,
        mw@semihalf.com, tchornyi@marvell.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com, horatiu.vultur@microchip.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, vladimir.oltean@nxp.com,
        alexandre.belloni@bootlin.com, s.shtylyov@omp.ru,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        radhey.shyam.pandey@xilinx.com, michal.simek@xilinx.com,
        andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 04 Nov 2022 17:13:01 +0000 you wrote:
> Virtually all conventional network drivers are now converted to use
> phylink_generic_validate() - only DSA drivers and fman_memac remain,
> so lets remove the necessity for network drivers to explicitly set
> this member, and default to phylink_generic_validate() when unset.
> This is possible as .validate must currently be set.
> 
> Any remaining instances that have not been addressed by this patch can
> be fixed up later.
> 
> [...]

Here is the summary with links:
  - [net-next] net: remove explicit phylink_generic_validate() references
    https://git.kernel.org/netdev/net-next/c/e1f4ecab1933

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


