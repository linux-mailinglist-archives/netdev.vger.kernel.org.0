Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EE94CD47A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 13:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiCDMvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 07:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiCDMvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 07:51:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FC31B1DDB;
        Fri,  4 Mar 2022 04:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3447CB828B8;
        Fri,  4 Mar 2022 12:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC339C340F1;
        Fri,  4 Mar 2022 12:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646398211;
        bh=l0J5xgqUZGcLIBLvnQhSe2xXGsnJIhFBO7T9W729//A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sBRoTu/kKf0IxPY97/5YEiQGGO/6VeomZ+pWNq5Vpg3g2W6JI7VuY5Xj6wsTOWQMx
         5uYr2AT/NvxnNrnIzdMtVAP/eGilgwy8XBTaCQK5PcOUEZqNxq8/QkLysE9k+a1FR5
         SSSPeqkhbvUcsrYFxLrdNJPVLWbppFVXtzF9WC+lrPi+Fon9BGZ5/pFvbGYMcDCvJw
         9SNezTuirPd2pXinyk/o2hqg7X5XJfP+eGhtZz4AGo2zgO8bMS25vx7dk7szj3fND2
         pNHbMs/YdusXvoCjfCybi7g+lVMxZ0qCAi4F6NgLpqbEzGJu0+3kgOWncEHEWATEzi
         h+Wh74stupRMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A0103E6D4BB;
        Fri,  4 Mar 2022 12:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] Add support for LAN937x T1 Phy Driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164639821165.27302.4276838745317071459.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 12:50:11 +0000
References: <20220304094401.31375-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220304094401.31375-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 4 Mar 2022 15:13:55 +0530 you wrote:
> LAN937x is a Multi-port 100Base-T1 Switch and it internally uses LAN87xx
> T1 Phy.  This series of patch update the initialization routine for the
> LAN87xx phy and also add LAN937x part support. Added the T1 Phy
> master-slave configuration through ethtool.
> 
> Arun Ramadoss (6):
>   net: phy: used genphy_soft_reset for phy reset in LAN87xx
>   net: phy: used the PHY_ID_MATCH_MODEL macro for LAN87XX
>   net: phy: removed empty lines in LAN87XX
>   net: phy: updated the initialization routine for LAN87xx
>   net: phy: added the LAN937x phy support
>   net: phy: added ethtool master-slave configuration support
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: phy: used genphy_soft_reset for phy reset in LAN87xx
    https://git.kernel.org/netdev/net-next/c/8eee3d353626
  - [net-next,2/6] net: phy: used the PHY_ID_MATCH_MODEL macro for LAN87XX
    https://git.kernel.org/netdev/net-next/c/79cea9a9c93a
  - [net-next,3/6] net: phy: removed empty lines in LAN87XX
    https://git.kernel.org/netdev/net-next/c/ccc8cc5badde
  - [net-next,4/6] net: phy: updated the initialization routine for LAN87xx
    https://git.kernel.org/netdev/net-next/c/8637034bc63f
  - [net-next,5/6] net: phy: added the LAN937x phy support
    https://git.kernel.org/netdev/net-next/c/680baca546f2
  - [net-next,6/6] net: phy: added ethtool master-slave configuration support
    https://git.kernel.org/netdev/net-next/c/8a1b415d70b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


