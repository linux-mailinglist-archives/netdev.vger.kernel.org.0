Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2352564120
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 17:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiGBPkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 11:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiGBPkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 11:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA776DECE;
        Sat,  2 Jul 2022 08:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FBF260F84;
        Sat,  2 Jul 2022 15:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C82F5C341CB;
        Sat,  2 Jul 2022 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656776415;
        bh=UOxg5grFLnvv0/PiESstgBIltLpmrZ2+w1OXDuPpnRU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uCO3dLdXYtC6XFt/qoS2h0ZjN6rwCAeqxEgo0MA184fKcQ1z8qJ+YK38g/tcA7Sx1
         I3u1usuuhTjIJ47KwC6gSGbDLNHlCxW3WZ2ZLNIGmfpTzv4pEJRUstTPdj7Dt5rwNY
         Z4uDyDk+0fXrS3lCfvb/nJzjdjDUfY9YqRKvJyZvP7NmogSoj/D6BRTsZtFEARv12F
         9r6dqO8jpB3kY4yMNGb1hnPaJwa7xx2fU++wMvH5XXgo5wsUfnDR946R688t2LW0M4
         j5CCl+RCoPzh0zW1rCjgG1KrA6w8qtvA644Iwk5iUk7WyNYWRWnENA68L3/RZLW7ob
         KnYXcVaxDGyAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD521E49F61;
        Sat,  2 Jul 2022 15:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next v15 00/13] net: dsa: microchip: DSA Driver support
 for LAN937x
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165677641570.21073.132055092852251986.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 15:40:15 +0000
References: <20220701144652.10526-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220701144652.10526-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux@armlinux.org.uk,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
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

On Fri, 1 Jul 2022 20:16:39 +0530 you wrote:
> LAN937x is a Multi-Port 100BASE-T1 Ethernet Physical Layer switch
> compliant with the IEEE 802.3bw-2015 specification. The device provides
> 100 Mbit/s transmit and receive capability over a single Unshielded
> Twisted Pair (UTP) cable. LAN937x is successive revision of KSZ series
> switch.
> This series of patches provide the DSA driver support for
> Microchip LAN937X switch through MII/RMII interface. The RGMII interface
> support will be added in the follow up series.  LAN937x uses the most of
> functionality of KSZ9477.
> 
> [...]

Here is the summary with links:
  - [net-next,v15,01/13] dt-bindings: net: make internal-delay-ps based on phy-mode
    https://git.kernel.org/netdev/net-next/c/528f7f1fadf1
  - [net-next,v15,02/13] dt-bindings: net: dsa: dt bindings for microchip lan937x
    https://git.kernel.org/netdev/net-next/c/8926d94e5c50
  - [net-next,v15,03/13] net: dsa: tag_ksz: add tag handling for Microchip LAN937x
    https://git.kernel.org/netdev/net-next/c/092f875131dc
  - [net-next,v15,04/13] net: dsa: microchip: generic access to ksz9477 static and reserved table
    https://git.kernel.org/netdev/net-next/c/457c182af597
  - [net-next,v15,05/13] net: dsa: microchip: add DSA support for microchip LAN937x
    https://git.kernel.org/netdev/net-next/c/55ab6ffaf378
  - [net-next,v15,06/13] net: dsa: microchip: lan937x: add dsa_tag_protocol
    https://git.kernel.org/netdev/net-next/c/99b16df0cd52
  - [net-next,v15,07/13] net: dsa: microchip: lan937x: add phy read and write support
    https://git.kernel.org/netdev/net-next/c/ffaf1de2f62d
  - [net-next,v15,08/13] net: dsa: microchip: lan937x: register mdio-bus
    https://git.kernel.org/netdev/net-next/c/a50b35366c64
  - [net-next,v15,09/13] net: dsa: microchip: lan937x: add MTU and fast_age support
    https://git.kernel.org/netdev/net-next/c/ab8823688f9e
  - [net-next,v15,10/13] net: dsa: microchip: lan937x: add phylink_get_caps support
    https://git.kernel.org/netdev/net-next/c/c14e878d4a4f
  - [net-next,v15,11/13] net: dsa: microchip: lan937x: add phylink_mac_link_up support
    https://git.kernel.org/netdev/net-next/c/f597d3ad75b8
  - [net-next,v15,12/13] net: dsa: microchip: lan937x: add phylink_mac_config support
    https://git.kernel.org/netdev/net-next/c/a0cb1aa43825
  - [net-next,v15,13/13] net: dsa: microchip: add LAN937x in the ksz spi probe
    https://git.kernel.org/netdev/net-next/c/c8fac9d0aa5a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


