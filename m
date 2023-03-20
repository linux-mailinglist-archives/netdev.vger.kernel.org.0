Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B08A6C0D0D
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 10:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjCTJUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 05:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjCTJUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 05:20:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5C5AF20;
        Mon, 20 Mar 2023 02:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2328FB80DB5;
        Mon, 20 Mar 2023 09:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB099C4339B;
        Mon, 20 Mar 2023 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679304019;
        bh=aRfWzyfuMD/6LDTt48kesyPO7X9IlFJAhbBlvoIsV28=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZJnCPupcqPglYwWfYGoYPdwkoBIFV6ImH5xtJRdOe1+42ehZX/+VyoThZYrmNr5rk
         FpRlXbTTrbioNzykR0+8T2ACi4MVab1y6Azpczq4yJ1DkKQktK8q7fQtFhFHKr3yHg
         C96TsURdZOdpbTijCLHJYMofdnEQpro2d5BwuHJLLt2X4NmpQTNDxjVwzVoIJuLYKt
         jk2R4BHImjNl+3lzdQ+X4jUhMcNlSQQmHBPLmsURtEXvxfAokcyRUGBdPVU9d+JrI4
         Cmyb/QPWEF9kSA+3seyGDTLYNJ0DbICSEteFOEkggmoSGA0aA9NbqyxxJQJAt3xNyf
         Y4i1rDiJnkecA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C44D8C395F4;
        Mon, 20 Mar 2023 09:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/9] add support for ocelot external ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167930401979.16850.3612356547133103899.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Mar 2023 09:20:19 +0000
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
In-Reply-To: <20230317185415.2000564-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        kishon@kernel.org, vkoul@kernel.org, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, lee@kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Mar 2023 11:54:06 -0700 you wrote:
> This is the start of part 3 of what is hopefully a 3-part series to add
> Ethernet switching support to Ocelot chips.
> 
> Part 1 of the series (A New Chip) added general support for Ocelot chips
> that were controlled externally via SPI.
> https://lore.kernel.org/all/20220815005553.1450359-1-colin.foster@in-advantage.com/
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/9] phy: phy-ocelot-serdes: add ability to be used in a non-syscon configuration
    https://git.kernel.org/netdev/net-next/c/672faa7bbf60
  - [v2,net-next,2/9] mfd: ocelot: add ocelot-serdes capability
    https://git.kernel.org/netdev/net-next/c/c21ff0939d1d
  - [v2,net-next,3/9] net: mscc: ocelot: expose ocelot_pll5_init routine
    https://git.kernel.org/netdev/net-next/c/fec53f449458
  - [v2,net-next,4/9] net: mscc: ocelot: expose generic phylink_mac_config routine
    https://git.kernel.org/netdev/net-next/c/69f7f89c0db5
  - [v2,net-next,5/9] net: mscc: ocelot: expose serdes configuration function
    https://git.kernel.org/netdev/net-next/c/dfca93ed51a7
  - [v2,net-next,6/9] net: dsa: felix: attempt to initialize internal hsio plls
    https://git.kernel.org/netdev/net-next/c/3821fd0107b0
  - [v2,net-next,7/9] net: dsa: felix: allow configurable phylink_mac_config
    https://git.kernel.org/netdev/net-next/c/544435c9346a
  - [v2,net-next,8/9] net: dsa: felix: allow serdes configuration for dsa ports
    https://git.kernel.org/netdev/net-next/c/6865ecee385b
  - [v2,net-next,9/9] net: dsa: ocelot: add support for external phys
    https://git.kernel.org/netdev/net-next/c/4c05e5ceecbb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


