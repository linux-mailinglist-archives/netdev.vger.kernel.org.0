Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A165F2EB7
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiJCKUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiJCKUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:20:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B902B29804
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 03:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72630B80EDD
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 10:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03B67C433D7;
        Mon,  3 Oct 2022 10:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664792418;
        bh=0SCRLD/qrY+QKGaW0tRpgNNS9uKNFj863QrPD2CuhXk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O64ttBsItHpVkYLWFIOT20nlr+L06DwfYVHDA7gdRIhJbNE4EHMHB02UCn2qhq7CK
         kXGoQVjJls9ujn+O0s0crLFNB/SLztIgwdTVy/taL627A/kzy9SOGlzXygjdPGwXdB
         yO6XE+ekGhlod3xKTGi7hvqmbfcgm6OVApiJP6PxMNlPubH+Rmu52sUskFUJTgHoaK
         6EJRgLyuiN7HcG5o6kdLKT5Jz/Rq1JFMYujrn8KO3CS+o7CHNPP3x+dAqE/x73W5Pg
         UMaI3C0EqsYteV5KJx8HnxaLJPLD0s8AUyVUyiFoKdGTpO7QvtEqkNhaJgwbKSml0q
         kszLXHhynyPWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDA59E49FA3;
        Mon,  3 Oct 2022 10:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] RollBall / Hilink / Turris 10G copper SFP
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166479241790.12231.13172944430102941044.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 10:20:17 +0000
References: <20220930142110.15372-1-kabel@kernel.org>
In-Reply-To: <20220930142110.15372-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rmk+kernel@armlinux.org.uk, andrew@lunn.ch, vladimir.oltean@nxp.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 30 Sep 2022 16:20:58 +0200 you wrote:
> Hello,
> 
> I am resurrecting my attempt to add support for RollBall / Hilink /
> Turris 10G copper SFPs modules.
> 
> The modules contain Marvell 88X3310 PHY, which can communicate with
> the system via sgmii, 2500base-x, 5gbase-r, 10gbase-r or usxgmii mode.
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] net: phylink: add ability to validate a set of interface modes
    https://git.kernel.org/netdev/net-next/c/1645f44dd5b8
  - [net-next,02/12] net: sfp: augment SFP parsing with phy_interface_t bitmap
    https://git.kernel.org/netdev/net-next/c/fd580c983031
  - [net-next,03/12] net: phylink: use phy_interface_t bitmaps for optical modules
    https://git.kernel.org/netdev/net-next/c/f81fa96d8a6c
  - [net-next,04/12] net: phylink: rename phylink_sfp_config()
    https://git.kernel.org/netdev/net-next/c/e60846370ca9
  - [net-next,05/12] net: phylink: pass supported host PHY interface modes to phylib for SFP's PHYs
    https://git.kernel.org/netdev/net-next/c/eca68a3c7d05
  - [net-next,06/12] net: phy: marvell10g: Use tabs instead of spaces for indentation
    https://git.kernel.org/netdev/net-next/c/3891569b2fc3
  - [net-next,07/12] net: phy: marvell10g: select host interface configuration
    https://git.kernel.org/netdev/net-next/c/d6d29292640d
  - [net-next,08/12] net: phylink: allow attaching phy for SFP modules on 802.3z mode
    https://git.kernel.org/netdev/net-next/c/31eb8907aa5b
  - [net-next,09/12] net: sfp: Add and use macros for SFP quirks definitions
    https://git.kernel.org/netdev/net-next/c/13c8adcf221f
  - [net-next,10/12] net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY release
    https://git.kernel.org/netdev/net-next/c/e85b1347ace6
  - [net-next,11/12] net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
    https://git.kernel.org/netdev/net-next/c/09bbedac72d5
  - [net-next,12/12] net: sfp: add support for multigig RollBall transceivers
    https://git.kernel.org/netdev/net-next/c/324e88cbe3b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


