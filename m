Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A0652E1CC
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344378AbiETBUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239345AbiETBUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B00837002
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D162961B5F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 01:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E394C34114;
        Fri, 20 May 2022 01:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653009614;
        bh=6L9CqSKX6VWY4LurBhFqahVRnv4+eVItjVSEjLf4Jhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=txMQLsn1wTkzsH5xvl4Xh4UVJrgXNrBpu5AvchCo/6wDAMtNIto6H/weAiyZVNjHq
         Y5+56GS/TWFHwjiiEaDiVaTEZ7aOaB+AgsvgE7zO69nQEAX/UlgGfJobc2PHy9gIlE
         pEb7rzlMiEfPYI/3zK+UatJJkPE7BeCueEHHUdrmPvK74nDPudjwe2KNyzNZIHDicE
         /QoLOGwJ77ILZ6IDokzdFO8frwrMA3gkPEi1IL8rTMaG1XptfvDItczf0Z2YHGmavu
         TqQUGZKZvHKozYm97tykWrU0pgKNTaI0OkkW9VVF/MzijcXN7DlBrJBykeRFMkavWq
         TJshXph0o6JbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1360AF03935;
        Fri, 20 May 2022 01:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] mtk_eth_soc phylink updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165300961407.24775.3678775138075397311.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 01:20:14 +0000
References: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
In-Reply-To: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, kabel@kernel.org,
        nbd@nbd.name, john@phrozen.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com,
        sean.wang@mediatek.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 May 2022 15:53:19 +0100 you wrote:
> Hi,
> 
> This series ultimately updates mtk_eth_soc to use phylink_pcs, with some
> fixes along the way.
> 
> Previous attempts to update this driver (which is now marked as legacy)
> have failed due to lack of testing. I am hoping that this time will be
> different; Marek can test RGMII modes, but not SGMII. So all that we
> know is that this patch series probably doesn't break RGMII.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] net: mtk_eth_soc: remove unused mac->mode
    https://git.kernel.org/netdev/net-next/c/0600bdde1fae
  - [net-next,02/12] net: mtk_eth_soc: remove unused sgmii flags
    https://git.kernel.org/netdev/net-next/c/5a7a2f4b29d7
  - [net-next,03/12] net: mtk_eth_soc: add mask and update PCS speed definitions
    https://git.kernel.org/netdev/net-next/c/bc5e93e0cd22
  - [net-next,04/12] net: mtk_eth_soc: correct 802.3z speed setting
    https://git.kernel.org/netdev/net-next/c/7da3f901f8ec
  - [net-next,05/12] net: mtk_eth_soc: correct 802.3z duplex setting
    https://git.kernel.org/netdev/net-next/c/a459187390bb
  - [net-next,06/12] net: mtk_eth_soc: stop passing phylink state to sgmii setup
    https://git.kernel.org/netdev/net-next/c/4ce5a0bd3958
  - [net-next,07/12] net: mtk_eth_soc: provide mtk_sgmii_config()
    https://git.kernel.org/netdev/net-next/c/1ec619ee4a05
  - [net-next,08/12] net: mtk_eth_soc: add fixme comment for state->speed use
    https://git.kernel.org/netdev/net-next/c/650a49bc65df
  - [net-next,09/12] net: mtk_eth_soc: move MAC_MCR setting to mac_finish()
    https://git.kernel.org/netdev/net-next/c/0e37ad71b2ff
  - [net-next,10/12] net: mtk_eth_soc: move restoration of SYSCFG0 to mac_finish()
    https://git.kernel.org/netdev/net-next/c/21089867278d
  - [net-next,11/12] net: mtk_eth_soc: convert code structure to suit split PCS support
    https://git.kernel.org/netdev/net-next/c/901f3fbe13c3
  - [net-next,12/12] net: mtk_eth_soc: partially convert to phylink_pcs
    https://git.kernel.org/netdev/net-next/c/14a44ab0330d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


