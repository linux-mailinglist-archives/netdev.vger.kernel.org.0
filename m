Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF7559CD82
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbiHWBBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238657AbiHWBAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:00:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECCB4D14F;
        Mon, 22 Aug 2022 18:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0616B81A28;
        Tue, 23 Aug 2022 01:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B702C4347C;
        Tue, 23 Aug 2022 01:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661216420;
        bh=gWjujOf60QddpJiQdhATU1Q8gucM3JgftAV6eUpRDts=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l5let+szPudRqPbXtAf25JgA08xX7DkSdR7swUlx0Ff1CbUmrzBmoLVx4NVHpIbXb
         oP11dsOQ+VwlxOWNUqgX/0Vql6HD2qqZVAyAWQ61CAnaZe69g58i3Vc9SWThaLS+Al
         S/7VkBjFXG3quvdykQYNHvQDWKdmaP/RLm+SZPTlmTTNQxvsi5CHEK3CvBpCOpRTud
         4DWFoFDflRGIhjCjIyCvl2cAlMLDrIuSYLSGVfGRg+X9VNzqqYhvL8o5VznHBO9k2n
         QFCKcbrIXj8sQzaJWoZ7nG4pku/kB3Vhio3HNlKs5UruSXejFayTJnv/78fpSF8vf9
         Mf1WkFqv/+tmw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62050C4166E;
        Tue, 23 Aug 2022 01:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 00/10] Validate OF nodes for DSA shared ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166121642039.14563.11985389088566730617.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 01:00:20 +0000
References: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux@rempel-privat.de,
        ansuelsmth@gmail.com, john@phrozen.org, kurt@linutronix.de,
        mans@mansr.com, arun.ramadoss@microchip.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        george.mccollister@gmail.com, dqfext@gmail.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        matthias.bgg@gmail.com, hauke@hauke-m.de,
        martin.blumenstingl@googlemail.com, olek2@wp.pl,
        alsi@bang-olufsen.dk, luizluca@gmail.com, linus.walleij@linaro.org,
        paweldembicki@gmail.com, clement.leger@bootlin.com,
        geert+renesas@glider.be, rmk+kernel@armlinux.org.uk,
        kabel@kernel.org, mw@semihalf.com, marex@denx.de,
        linux-renesas-soc@vger.kernel.org, linux@rasmusvillemoes.dk,
        frowand.list@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Aug 2022 14:54:50 +0300 you wrote:
> This is the first set of measures taken so that more drivers can be
> transitioned towards phylink on shared (CPU and DSA) ports some time in
> the future. It consists of:
> 
> - expanding the DT schema for DSA and related drivers to clarify the new
>   requirements.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,01/10] dt-bindings: net: dsa: xrs700x: add missing CPU port phy-mode to example
    https://git.kernel.org/netdev/net-next/c/b237676039d9
  - [v4,net-next,02/10] dt-bindings: net: dsa: hellcreek: add missing CPU port phy-mode/fixed-link to example
    https://git.kernel.org/netdev/net-next/c/b975b73425cd
  - [v4,net-next,03/10] dt-bindings: net: dsa: b53: add missing CPU port phy-mode to example
    https://git.kernel.org/netdev/net-next/c/526512f675c8
  - [v4,net-next,04/10] dt-bindings: net: dsa: microchip: add missing CPU port phy-mode to example
    https://git.kernel.org/netdev/net-next/c/2401bd9532fe
  - [v4,net-next,05/10] dt-bindings: net: dsa: rzn1-a5psw: add missing CPU port phy-mode to example
    https://git.kernel.org/netdev/net-next/c/f3c8168fdd02
  - [v4,net-next,06/10] dt-bindings: net: dsa: make phylink bindings required for CPU/DSA ports
    https://git.kernel.org/netdev/net-next/c/2ec2fb8331af
  - [v4,net-next,07/10] of: base: export of_device_compatible_match() for use in modules
    https://git.kernel.org/netdev/net-next/c/df55e317805f
  - [v4,net-next,08/10] net: dsa: avoid dsa_port_link_{,un}register_of() calls with platform data
    https://git.kernel.org/netdev/net-next/c/da2c398e59d6
  - [v4,net-next,09/10] net: dsa: rename dsa_port_link_{,un}register_of
    https://git.kernel.org/netdev/net-next/c/770375ff3311
  - [v4,net-next,10/10] net: dsa: make phylink-related OF properties mandatory on DSA and CPU ports
    https://git.kernel.org/netdev/net-next/c/e09e9873152e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


