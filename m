Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B30D51FB2E
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 13:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiEILYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 07:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbiEILYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 07:24:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6619A1CA060;
        Mon,  9 May 2022 04:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02B7F61181;
        Mon,  9 May 2022 11:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66A17C385B0;
        Mon,  9 May 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652095213;
        bh=hxLPtFToauw/CypSw3PgRx03g+BtJcjhzt3UySK+NqY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iwXAgTgqnNjRgc2XeufwA34jE6Zu+gNg8x2zEMG/qMwfUD9IwAAO+6ycA9S3d9fLz
         yUMn3UPiWbUnonkyrJnOvim4DgiFm8LKgdwaE8CPodKA2CZ8VX9JxoulfPAH2uiQNn
         Ca29y47QK81l6I8CbkK8ZBMRsZpceCwseyx4QYX42MKQVWeLYivsjYmZ8u5lVYCXrQ
         vF+ioQKjI28MFxfY+WDFsTIQprmnE/bL2P/gfh9WZGLuPWLEyQNjLMxg6uu8gjJLPG
         NITydoI5jZ4TysOMGkwUcSM/YqLh26lls4qyj0TaEHxIB93VChQ31lMpxwiTNAlJkm
         0B/1V3vvgIGkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 419F0F03929;
        Mon,  9 May 2022 11:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/7] add ti dp83td510 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165209521326.15458.16390229009185175258.git-patchwork-notify@kernel.org>
Date:   Mon, 09 May 2022 11:20:13 +0000
References: <20220506042357.923026-1-o.rempel@pengutronix.de>
In-Reply-To: <20220506042357.923026-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  6 May 2022 06:23:50 +0200 you wrote:
> changes v4:
> - dp83td510: remove unused variables
> - s/base1/baset1
> - s/genphy_c45_baset1_read_master_slave/genphy_c45_pma_baset1_read_master_slave
> 
> changes v3:
> - export reusable code snippets and make use of it in the dp83td510
>   driver
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/7] net: phy: genphy_c45_baset1_an_config_aneg: do no set unknown configuration
    https://git.kernel.org/netdev/net-next/c/a7f0e4bea8ed
  - [net-next,v4,2/7] net: phy: introduce genphy_c45_pma_baset1_setup_master_slave()
    https://git.kernel.org/netdev/net-next/c/90532850eb21
  - [net-next,v4,3/7] net: phy: genphy_c45_pma_baset1_setup_master_slave: do no set unknown configuration
    https://git.kernel.org/netdev/net-next/c/a04dd88f77a4
  - [net-next,v4,4/7] net: phy: introduce genphy_c45_pma_baset1_read_master_slave()
    https://git.kernel.org/netdev/net-next/c/b9a366f3d874
  - [net-next,v4,5/7] net: phy: genphy_c45_pma_baset1_read_master_slave: read actual configuration
    https://git.kernel.org/netdev/net-next/c/acb8c5aec2b1
  - [net-next,v4,6/7] net: phy: export genphy_c45_baset1_read_status()
    https://git.kernel.org/netdev/net-next/c/2013ad8836ac
  - [net-next,v4,7/7] net: phy: dp83td510: Add support for the DP83TD510 Ethernet PHY
    https://git.kernel.org/netdev/net-next/c/165cd04fe253

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


