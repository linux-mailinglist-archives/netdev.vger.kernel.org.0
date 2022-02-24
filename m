Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A184C2A13
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiBXLAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiBXLAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:00:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A3127AA07;
        Thu, 24 Feb 2022 03:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F10A8616BB;
        Thu, 24 Feb 2022 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C690C340EB;
        Thu, 24 Feb 2022 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645700418;
        bh=AnnVq5c6p6dC9n9JQe1mQGwsddizXP0V8aCqa1cu3xM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BHqLEkcrrObbk2szVmmRjHm7Gr1kgYt/EIPMYkUlW44Mxk19HmZM7QPetJ51nF3c1
         U1Xu3jnLXCOQ6oB00Ev68DhR+v9LgGWH5MNE/cApPFpOK1MGRKwPqESYxhEzupnfVe
         c310uxkdcp7O5ZsuYpuCPrwm8g2nMOAZdUS2fRdTTTtlKhU6G1e6RwQN6r2yb48jVa
         hIxaoT024FlbmF+dgrsu28ctwoaCmCq7ZDW8vJov68hCoS4XdLtRsmaSscOuYuMxlr
         0IoXnaCyJhMVD97nN7mdA8NxndUCeCwfz0pjHwSRAgQGFVpfFo+x4NFjoL4p9C/Wer
         T6J+HgoMg0U/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3024EE5D09D;
        Thu, 24 Feb 2022 11:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/36] dt-binding: can: mcp251xfd: include common CAN
 controller bindings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164570041818.27281.14522433366383159924.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 11:00:18 +0000
References: <20220224082726.3000007-2-mkl@pengutronix.de>
In-Reply-To: <20220224082726.3000007-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de, mani@kernel.org,
        thomas.kopp@microchip.com, robh@kernel.org
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
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Thu, 24 Feb 2022 09:26:51 +0100 you wrote:
> Since commit
> 
> | 1f9234401ce0 ("dt-bindings: can: add can-controller.yaml")
> 
> there is a common CAN controller binding. Add this to the mcp251xfd
> binding.
> 
> [...]

Here is the summary with links:
  - [net-next,01/36] dt-binding: can: mcp251xfd: include common CAN controller bindings
    https://git.kernel.org/netdev/net-next/c/66224f6656d1
  - [net-next,02/36] dt-binding: can: sun4i_can: include common CAN controller bindings
    https://git.kernel.org/netdev/net-next/c/d931686dc21f
  - [net-next,03/36] dt-binding: can: m_can: list Chandrasekar Ramakrishnan as maintainer
    https://git.kernel.org/netdev/net-next/c/edd056a109ee
  - [net-next,04/36] dt-binding: can: m_can: fix indention of table in bosch,mram-cfg description
    https://git.kernel.org/netdev/net-next/c/bffd5217ca2e
  - [net-next,05/36] dt-binding: can: m_can: include common CAN controller bindings
    https://git.kernel.org/netdev/net-next/c/58212e03e5ec
  - [net-next,06/36] can: gw: use call_rcu() instead of costly synchronize_rcu()
    https://git.kernel.org/netdev/net-next/c/181d4447905d
  - [net-next,07/36] can: bittiming: can_validate_bitrate(): simplify bit rate checking
    https://git.kernel.org/netdev/net-next/c/5b60d334e42a
  - [net-next,08/36] can: bittiming: mark function arguments and local variables as const
    https://git.kernel.org/netdev/net-next/c/5597f082fcaf
  - [net-next,09/36] can: kvaser_usb: kvaser_usb_send_cmd(): remove redundant variable actual_len
    https://git.kernel.org/netdev/net-next/c/1c256e3a2c76
  - [net-next,10/36] can: c_can: ethtool: use default drvinfo
    https://git.kernel.org/netdev/net-next/c/8d0a82e1f42f
  - [net-next,11/36] can: softing: softing_netdev_open(): remove redundant ret variable
    https://git.kernel.org/netdev/net-next/c/51ae468aa7e4
  - [net-next,12/36] can: xilinx_can: Add check for NAPI Poll function
    https://git.kernel.org/netdev/net-next/c/2206fcbc1090
  - [net-next,13/36] can: etas_es58x: use BITS_PER_TYPE() instead of manual calculation
    https://git.kernel.org/netdev/net-next/c/2ae9856d70b6
  - [net-next,14/36] can: mcp251xfd: mcp251xfd_reg_invalid(): rename from mcp251xfd_osc_invalid()
    https://git.kernel.org/netdev/net-next/c/3f5c91b4ce8f
  - [net-next,15/36] can: mcp251xfd: mcp251xfd_regmap_crc_read(): ignore CRC error only if solely OSC register is read
    https://git.kernel.org/netdev/net-next/c/25386c9a0100
  - [net-next,16/36] can: mcp251xfd: mcp251xfd_unregister(): simplify runtime PM handling
    https://git.kernel.org/netdev/net-next/c/72362dcdf654
  - [net-next,17/36] can: mcp251xfd: mcp251xfd_chip_sleep(): introduce function to bring chip into sleep mode
    https://git.kernel.org/netdev/net-next/c/1ba3690fa2c6
  - [net-next,18/36] can: mcp251xfd: mcp251xfd_chip_stop(): convert to a void function
    https://git.kernel.org/netdev/net-next/c/13c54a1ee12f
  - [net-next,19/36] can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): factor out into separate function
    https://git.kernel.org/netdev/net-next/c/0445e5ff55cc
  - [net-next,20/36] can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): improve chip detection and error handling
    https://git.kernel.org/netdev/net-next/c/197656de8d1e
  - [net-next,21/36] can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): prepare for PLL support
    https://git.kernel.org/netdev/net-next/c/06db5dbc8ebf
  - [net-next,22/36] can: mcp251xfd: mcp251xfd_chip_softreset_check(): wait for OSC ready before accessing chip
    https://git.kernel.org/netdev/net-next/c/01a80d688a41
  - [net-next,23/36] can: mcp251xfd: mcp251xfd_chip_timestamp_init(): factor out into separate function
    https://git.kernel.org/netdev/net-next/c/14193ea2bfee
  - [net-next,24/36] can: mcp251xfd: mcp251xfd_chip_wake(): renamed from mcp251xfd_chip_clock_enable()
    https://git.kernel.org/netdev/net-next/c/1a4abba64011
  - [net-next,25/36] can: mcp251xfd: __mcp251xfd_chip_set_mode(): prepare for PLL support: improve error handling and diagnostics
    https://git.kernel.org/netdev/net-next/c/a10fd91e42e8
  - [net-next,26/36] can: mcp251xfd: mcp251xfd_chip_clock_init(): prepare for PLL support, wait for OSC ready
    https://git.kernel.org/netdev/net-next/c/e39ea1360ca7
  - [net-next,27/36] can: mcp251xfd: mcp251xfd_register(): prepare to activate PLL after softreset
    https://git.kernel.org/netdev/net-next/c/445dd72a6d63
  - [net-next,28/36] can: mcp251xfd: add support for internal PLL
    https://git.kernel.org/netdev/net-next/c/2a68dd8663ea
  - [net-next,29/36] can: mcp251xfd: introduce struct mcp251xfd_tx_ring::nr and ::fifo_nr and make use of it
    https://git.kernel.org/netdev/net-next/c/c912f19ee382
  - [net-next,30/36] can: mcp251xfd: mcp251xfd_ring_init(): split ring_init into separate functions
    https://git.kernel.org/netdev/net-next/c/d2d5397fcae1
  - [net-next,31/36] can: mcp251xfd: ring: prepare to change order of TX and RX FIFOs
    https://git.kernel.org/netdev/net-next/c/617283b9c4db
  - [net-next,32/36] can: mcp251xfd: ring: change order of TX and RX FIFOs
    https://git.kernel.org/netdev/net-next/c/62713f0d9a38
  - [net-next,33/36] can: mcp251xfd: ring: mcp251xfd_ring_init(): checked RAM usage of ring setup
    https://git.kernel.org/netdev/net-next/c/fa0b68df7c95
  - [net-next,34/36] can: mcp251xfd: ring: update FIFO setup debug info
    https://git.kernel.org/netdev/net-next/c/83daa863f16b
  - [net-next,35/36] can: mcp251xfd: prepare for multiple RX-FIFOs
    https://git.kernel.org/netdev/net-next/c/887e359d6cce
  - [net-next,36/36] can: mcp251xfd: mcp251xfd_priv: introduce macros specifying the number of supported TEF/RX/TX rings
    https://git.kernel.org/netdev/net-next/c/aada74220f00

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


