Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F516B204E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjCIJkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 04:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCIJkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 04:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FBCE6FE6
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 01:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46D9EB81EBC
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 09:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01D04C433EF;
        Thu,  9 Mar 2023 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678354819;
        bh=Mm7vjJuCjPksuPI/SCzqU1/CD4qW+sVNOhnbWN2J/nA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ms4qVvZrJSYjju+jgFSP4PoasOtU+KI2GM1kP6vYSRHJqQi32KNMvp/uKn7a62EQ7
         vcoSLrhf83K2/ycpHkX2HB/KCDBYxtuIsVMHwVLybJ5yzsC7qtIregHVlwBVJWlYHg
         XyrvqMws0nEqIVxEqhHaAPTW5Vi9owrG/g8Ypb2Vz4in+UPgzTXuSI+unUmP1Jrlb/
         yatY+oQp9USgQ5A5kr0k1eLelmMbJeZIWqxmtI7ry01RiZ6fqtVLOYwqgvvAbGSCU0
         n1m1P2gND99ErSJkB1CXPKRwegf2NDwGPbJINus2thNmEo4XMhbXX40isLIovba8fz
         2vA1hjP0j7b3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7D0DE61B60;
        Thu,  9 Mar 2023 09:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] Various mtk_eth_soc cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167835481887.13872.13425175568351731683.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 09:40:18 +0000
References: <ZAdj9qUXcHUsK7Gt@shell.armlinux.org.uk>
In-Reply-To: <ZAdj9qUXcHUsK7Gt@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     daniel@makrotopia.org, nbd@nbd.name, john@phrozen.org,
        Mark-MC.Lee@mediatek.com, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, angelogioacchino.delregno@collabora.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, lorenzo@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 7 Mar 2023 16:19:02 +0000 you wrote:
> Here are a number of patches that do a bit of cleanup to mtk_eth_soc.
> 
> The first patch cleans up mtk_gmac0_rgmii_adjust(), which is the
> troublesome function preventing the driver becoming a post-March2020
> phylink driver. It doesn't solve that problem, merely makes the code
> easier to follow by getting rid of repeated tenary operators.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: mtk_eth_soc: tidy mtk_gmac0_rgmii_adjust()
    https://git.kernel.org/netdev/net-next/c/04eb3d1cede0
  - [net-next,2/4] net: mtk_eth_soc: move trgmii ddr2 check to probe function
    https://git.kernel.org/netdev/net-next/c/7910898e1b2a
  - [net-next,3/4] net: mtk_eth_soc: remove unnecessary checks in mtk_mac_config()
    https://git.kernel.org/netdev/net-next/c/c9f9e3a3289f
  - [net-next,4/4] net: mtk_eth_soc: remove support for RMII and REVMII modes
    https://git.kernel.org/netdev/net-next/c/8cd9de08ccf6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


