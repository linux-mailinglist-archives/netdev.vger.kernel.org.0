Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58577564123
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiGBPkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 11:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiGBPkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 11:40:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B55DF73;
        Sat,  2 Jul 2022 08:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2B03CE04AE;
        Sat,  2 Jul 2022 15:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3AEBC341CE;
        Sat,  2 Jul 2022 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656776416;
        bh=Diq96nrWOBKg7Wrz2YAXiBc2T5ZMoP7GhQzYHOcbcX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NXOKK5kaSqbOxNBI++nVkS3i/f0hIU/c5TtR73AML466eClx9/JeT1f7/WScRF/i+
         HUYMxwJ6sxtvVKT+PhHRojpHt5fLSlkFo5i0qVgGQyidLGuqMpWD4d05qThFWSmX49
         HVDWUmQq89E0OctWydYlebZt3dSyMYhf7kPpjFo/8Bf/8L8HjvHDsYAnH6qG4q9tyR
         My3tDW4Q0rYRX3dgxi+SNz3crPhsAQuPuwcmuNWG0gkuSZ8fu5/wR4WrTYd5fXwVOX
         b4QOu+K9V/zllPBE8YUdfezxlAA1N/v5S0/7x6sSv6TPKqcEEWZZwc3N1dwLL8sSuE
         +C3iqjvdmnxwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C28D0E49FA1;
        Sat,  2 Jul 2022 15:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/2] LED feature for LAN8814 PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165677641578.21073.12338044854011096354.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 15:40:15 +0000
References: <20220701035709.10829-1-Divya.Koppera@microchip.com>
In-Reply-To: <20220701035709.10829-1-Divya.Koppera@microchip.com>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Madhuri.Sripada@microchip.com
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

On Fri, 1 Jul 2022 09:27:07 +0530 you wrote:
> Enable LED mode configuration for LAN8814 PHY
> 
> v2 -> v3:
> - Fixed compilation issues
> 
> v1 -> v2:
> - Updated dt-bindings for micrel,led-mode in LAN8814 PHY
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/2] dt-bindings: net: Updated micrel,led-mode for LAN8814 PHY
    https://git.kernel.org/netdev/net-next/c/eb566fc83920
  - [v3,net-next,2/2] net: phy: micrel: Adding LED feature for LAN8814 PHY
    https://git.kernel.org/netdev/net-next/c/a516b7f7ca53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


