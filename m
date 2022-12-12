Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB17D649E90
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 13:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiLLMUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 07:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLLMU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 07:20:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF6162E5;
        Mon, 12 Dec 2022 04:20:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82212B80D1C;
        Mon, 12 Dec 2022 12:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 398C7C433F0;
        Mon, 12 Dec 2022 12:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670847622;
        bh=dtX9BD1qrn6uzx8UQymj3qYaFjbr4Lw89kmAGQozFig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LSICWdJ48SJVaaZBEBG6lcEaa0s/B2RCktwvIMQS/jxi7FSYTDl7Z9y8qyKZoCaPY
         3lPhbbwPC66stpnbbfhfjtGJh9MndF5TX5swoOgUEsKx6H0m1ty1xbfQNmq1QMXFW8
         T/ZASJYGlmGTwwzfADJSA+iR3STfqaswM9/xIumtOXmn3/UXFiA9+pqT5i1wVwL7oR
         lQSi8hwiCmjk/8fvyqcRAe5c3Gmz+UHCwGc3nOn+IQZmANxHDIjoorPkvJ8xOQ4miu
         CFaiXsztZzm9wZX+9lYHxUL17hpeNJLYkj0iEQlIHRLONAVAoSbg1ENEhaUjovNIVy
         g5DirrSE5QaZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23924C41612;
        Mon, 12 Dec 2022 12:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/39] can: kvaser_usb: kvaser_usb_set_bittiming():
 fix redundant initialization warning for err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167084762214.17523.9281498500254704296.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 12:20:22 +0000
References: <20221212113045.222493-2-mkl@pengutronix.de>
In-Reply-To: <20221212113045.222493-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de, extja@kvaser.com,
        anssi.hannula@bitwise.fi
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
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Mon, 12 Dec 2022 12:30:07 +0100 you wrote:
> The variable err is initialized, but the initialized value is
> Overwritten before it is read. Fix the warning by not initializing the
> variable err at all.
> 
> Fixes: 39d3df6b0ea8 ("can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming")
> Cc: Jimmy Assarsson <extja@kvaser.com>
> Cc: Anssi Hannula <anssi.hannula@bitwise.fi>
> Link: https://lore.kernel.org/all/20221031114513.81214-1-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/39] can: kvaser_usb: kvaser_usb_set_bittiming(): fix redundant initialization warning for err
    https://git.kernel.org/netdev/net-next/c/cce2d7d2abcc
  - [net-next,02/39] can: kvaser_usb: kvaser_usb_set_{,data}bittiming(): remove empty lines in variable declaration
    https://git.kernel.org/netdev/net-next/c/0bf582fc5168
  - [net-next,03/39] can: rcar_canfd: rcar_canfd_probe: Add struct rcar_canfd_hw_info to driver data
    https://git.kernel.org/netdev/net-next/c/ce7c5382758b
  - [net-next,04/39] can: m_can: sort header inclusion alphabetically
    https://git.kernel.org/netdev/net-next/c/09451f244eab
  - [net-next,05/39] can: rcar_canfd: Add max_channels to struct rcar_canfd_hw_info
    https://git.kernel.org/netdev/net-next/c/34f9e9852b90
  - [net-next,06/39] can: rcar_canfd: Add shared_global_irqs to struct rcar_canfd_hw_info
    https://git.kernel.org/netdev/net-next/c/841645cfc773
  - [net-next,07/39] can: rcar_canfd: Add postdiv to struct rcar_canfd_hw_info
    https://git.kernel.org/netdev/net-next/c/a1dcfbdfd1d0
  - [net-next,08/39] can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info
    https://git.kernel.org/netdev/net-next/c/ea6ff7792203
  - [net-next,09/39] can: ctucanfd: Drop obsolete dependency on COMPILE_TEST
    https://git.kernel.org/netdev/net-next/c/005c54278b3d
  - [net-next,10/39] can: etas_es58x: sort the includes by alphabetic order
    https://git.kernel.org/netdev/net-next/c/8fd9323ef721
  - [net-next,11/39] can: flexcan: add auto stop mode for IMX93 to support wakeup
    https://git.kernel.org/netdev/net-next/c/8cb53b485f18
  - [net-next,12/39] can: etas_es58x: add devlink support
    https://git.kernel.org/netdev/net-next/c/2c4a1efcf6ab
  - [net-next,13/39] dt-bindings: can: fsl,flexcan: add imx93 compatible
    https://git.kernel.org/netdev/net-next/c/a21cee59b416
  - [net-next,14/39] can: etas_es58x: add devlink port support
    https://git.kernel.org/netdev/net-next/c/594a25e1ffc5
  - [net-next,15/39] dt-bindings: can: renesas,rcar-canfd: Document RZ/Five SoC
    https://git.kernel.org/netdev/net-next/c/5237ff4e7d3d
  - [net-next,16/39] USB: core: export usb_cache_string()
    https://git.kernel.org/netdev/net-next/c/983055bf8397
  - [net-next,17/39] can: c_can: use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/74d95352bdfc
  - [net-next,18/39] net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
    https://git.kernel.org/netdev/net-next/c/01d80532295c
  - [net-next,19/39] can: etas_es58x: export product information through devlink_ops::info_get()
    https://git.kernel.org/netdev/net-next/c/9f06631c3f1f
  - [net-next,20/39] can: etas_es58x: remove es58x_get_product_info()
    https://git.kernel.org/netdev/net-next/c/d8f26fd689dd
  - [net-next,21/39] Documentation: devlink: add devlink documentation for the etas_es58x driver
    https://git.kernel.org/netdev/net-next/c/9f63f96aac92
  - [net-next,22/39] can: ucan: use strscpy() to instead of strncpy()
    https://git.kernel.org/netdev/net-next/c/7fdaf8966aae
  - [net-next,23/39] net: af_can: remove useless parameter 'err' in 'can_rx_register()'
    https://git.kernel.org/netdev/net-next/c/f793458bba54
  - [net-next,24/39] can: ucan: remove unused ucan_priv::intf
    https://git.kernel.org/netdev/net-next/c/f54b101ddeae
  - [net-next,25/39] can: gs_usb: remove gs_can::iface
    https://git.kernel.org/netdev/net-next/c/56c56a309e79
  - [net-next,26/39] can: m_can: Call the RAM init directly from m_can_chip_config
    https://git.kernel.org/netdev/net-next/c/eaacfeaca7ad
  - [net-next,27/39] can: raw: add support for SO_MARK
    https://git.kernel.org/netdev/net-next/c/0826e82b8a32
  - [net-next,28/39] dt-bindings: can: renesas,rcar-canfd: Fix number of channels for R-Car V3U
    https://git.kernel.org/netdev/net-next/c/3abcc01c38bc
  - [net-next,29/39] can: m_can: Eliminate double read of TXFQS in tx_handler
    https://git.kernel.org/netdev/net-next/c/c1eaf8b9bd31
  - [net-next,30/39] can: m_can: Avoid reading irqstatus twice
    https://git.kernel.org/netdev/net-next/c/577579379749
  - [net-next,31/39] can: m_can: Read register PSR only on error
    https://git.kernel.org/netdev/net-next/c/fac52bf786e5
  - [net-next,32/39] can: m_can: Count TXE FIFO getidx in the driver
    https://git.kernel.org/netdev/net-next/c/d4535b90a76a
  - [net-next,33/39] can: m_can: Count read getindex in the driver
    https://git.kernel.org/netdev/net-next/c/6355a3c983e6
  - [net-next,34/39] can: m_can: Batch acknowledge transmit events
    https://git.kernel.org/netdev/net-next/c/e3bff5256a0f
  - [net-next,35/39] can: m_can: Batch acknowledge rx fifo
    https://git.kernel.org/netdev/net-next/c/e2f1c8cb0202
  - [net-next,36/39] can: tcan4x5x: Remove invalid write in clear_interrupts
    https://git.kernel.org/netdev/net-next/c/40c9e4f676ab
  - [net-next,37/39] can: tcan4x5x: Fix use of register error status mask
    https://git.kernel.org/netdev/net-next/c/67727a17a6b3
  - [net-next,38/39] can: tcan4x5x: Fix register range of first two blocks
    https://git.kernel.org/netdev/net-next/c/ef5778f70841
  - [net-next,39/39] can: tcan4x5x: Specify separate read/write ranges
    https://git.kernel.org/netdev/net-next/c/39dbb21b6a29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


