Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C576E7932
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjDSMA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjDSMAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:00:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EBF9EE7;
        Wed, 19 Apr 2023 05:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD40163E38;
        Wed, 19 Apr 2023 12:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26F76C4339B;
        Wed, 19 Apr 2023 12:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681905624;
        bh=kL7MXaHfZUb5tJRqat4CTB+HjhFYT3TLVG/TA9D/yOU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DyKJ7lZEgtxMcBtN3hFQTRgImJ0r78sfGAFkj0/1IpnBOGNsodsEKSA9n0/0u0zCO
         SgdGBFEnVUCVGNcpn/Ixzg07lTnEoadfHZM4weInv6uDSQC+j0CJ1RugD/nQc8zwmw
         E8PTmOC86u/lnpdLrK75GluGpZ9SrXGcd+dYzkcgt+yXotoUcyFs3p4hDqNpU5buzO
         qFucbkE1pCfekMm8Bs7nIlumeB8LyAjG71S9QQu5COc77iM+C+pK2Z+fnfnT+SnZi/
         MR0UaF2bXx6TEF5b74pA63/E6RUiJ9UPY/tCxKwchlVvt9AIQhuMjJgYRSAJ+b/fuz
         RRji8WNy9Cycw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00DF7E3309C;
        Wed, 19 Apr 2023 12:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v7 00/16] net: Add basic LED support for switch/phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168190562399.2268.16556585281655823731.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 12:00:23 +0000
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, corbet@lwn.net, gregory.clement@bootlin.com,
        sebastian.hesselbarth@gmail.com, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org, pavel@ucw.cz,
        lee@kernel.org, john@phrozen.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Apr 2023 17:17:22 +0200 you wrote:
> This is a continue of [1]. It was decided to take a more gradual
> approach to implement LEDs support for switch and phy starting with
> basic support and then implementing the hw control part when we have all
> the prereq done.
> 
> This series implements only the brightness_set() and blink_set() ops.
> An example of switch implementation is done with qca8k.
> 
> [...]

Here is the summary with links:
  - [net-next,v7,01/16] net: dsa: qca8k: move qca8k_port_to_phy() to header
    https://git.kernel.org/netdev/net-next/c/3e8b4d6277fd
  - [net-next,v7,02/16] net: dsa: qca8k: add LEDs basic support
    https://git.kernel.org/netdev/net-next/c/1e264f9d2918
  - [net-next,v7,03/16] net: dsa: qca8k: add LEDs blink_set() support
    https://git.kernel.org/netdev/net-next/c/91acadcc6e59
  - [net-next,v7,04/16] leds: Provide stubs for when CLASS_LED & NEW_LEDS are disabled
    https://git.kernel.org/netdev/net-next/c/e5029edd5393
  - [net-next,v7,05/16] net: phy: Add a binding for PHY LEDs
    https://git.kernel.org/netdev/net-next/c/01e5b728e9e4
  - [net-next,v7,06/16] net: phy: phy_device: Call into the PHY driver to set LED brightness
    https://git.kernel.org/netdev/net-next/c/684818189b04
  - [net-next,v7,07/16] net: phy: marvell: Add software control of the LEDs
    https://git.kernel.org/netdev/net-next/c/2d3960e58ef7
  - [net-next,v7,08/16] net: phy: phy_device: Call into the PHY driver to set LED blinking
    https://git.kernel.org/netdev/net-next/c/4e901018432e
  - [net-next,v7,09/16] net: phy: marvell: Implement led_blink_set()
    https://git.kernel.org/netdev/net-next/c/ea9e86485dec
  - [net-next,v7,10/16] dt-bindings: net: ethernet-controller: Document support for LEDs node
    https://git.kernel.org/netdev/net-next/c/57b6c752c5c0
  - [net-next,v7,11/16] dt-bindings: net: dsa: qca8k: add LEDs definition example
    https://git.kernel.org/netdev/net-next/c/ed617bc022f4
  - [net-next,v7,12/16] ARM: dts: qcom: ipq8064-rb3011: Drop unevaluated properties in switch nodes
    https://git.kernel.org/netdev/net-next/c/939595c79d12
  - [net-next,v7,13/16] ARM: dts: qcom: ipq8064-rb3011: Add Switch LED for each port
    https://git.kernel.org/netdev/net-next/c/09930f1fb875
  - [net-next,v7,14/16] dt-bindings: net: phy: Document support for LEDs node
    https://git.kernel.org/netdev/net-next/c/18a24b694a2b
  - [net-next,v7,15/16] arm: mvebu: dt: Add PHY LED support for 370-rd WAN port
    https://git.kernel.org/netdev/net-next/c/380a8fe1b2f4
  - [net-next,v7,16/16] Documentation: LEDs: Describe good names for network LEDs
    https://git.kernel.org/netdev/net-next/c/c693ea2fd6e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


