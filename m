Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338F868DD0D
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjBGPab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjBGPa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:30:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D67937F17;
        Tue,  7 Feb 2023 07:30:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23391B819CB;
        Tue,  7 Feb 2023 15:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3C6CC4339C;
        Tue,  7 Feb 2023 15:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675783824;
        bh=eDASrvectQyP2/Qh1NRcopTn6QSetNmShAywjjZ63GQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uY794UX5vVpTl1PYis/hYTGRfyKTPjIfSiqNzGE6rKbHK6SyZ4HX0cApdtM4/uRnS
         NgienNZpPkQlKJf8eqcAq1xy4tPfHzU0zo1V9iefS6mAvGqZXK1QzyCXC1OaNS3y/p
         ZkaaAJ84w9PV/ixzC1lnjFBkgfpxXtFq9kQPiBbZcHwLCO4CEX8k6euPE9E88SvyR0
         YupACm6g5YxmB0QxuyhKnEj5Jik9AyZ1NUU31HrNW6Zq6X9PREmpwWtm0yV5OTo14g
         JI0hAwHMeqgkkHFMccJSuz+oSOR4x25S1PQfLR1q/MVtE3xbUBTtcKP7BswXHMPTYv
         iep7tHUJQ6D9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91C1EE55EFD;
        Tue,  7 Feb 2023 15:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/47] can: gw: give feedback on missing
 CGW_FLAGS_CAN_IIF_TX_OK flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167578382457.8185.3396107310549823737.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 15:30:24 +0000
References: <20230206131620.2758724-2-mkl@pengutronix.de>
In-Reply-To: <20230206131620.2758724-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net, jannik.hartung@tu-bs.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Mon,  6 Feb 2023 14:15:34 +0100 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> To send CAN traffic back to the incoming interface a special flag has to
> be set. When creating a routing job for identical interfaces without this
> flag the rule is created but has no effect.
> 
> This patch adds an error return value in the case that the CAN interfaces
> are identical but the CGW_FLAGS_CAN_IIF_TX_OK flag was not set.
> 
> [...]

Here is the summary with links:
  - [net-next,01/47] can: gw: give feedback on missing CGW_FLAGS_CAN_IIF_TX_OK flag
    https://git.kernel.org/netdev/net-next/c/2a30b2bd01c2
  - [net-next,02/47] can: isotp: check CAN address family in isotp_bind()
    https://git.kernel.org/netdev/net-next/c/c6adf659a8ba
  - [net-next,03/47] can: mcp251xfd: regmap: optimizing transfer size for CRC transfers size 1
    https://git.kernel.org/netdev/net-next/c/2e8ca20b40e5
  - [net-next,04/47] dt-bindings: can: renesas,rcar-canfd: R-Car V3U is R-Car Gen4
    https://git.kernel.org/netdev/net-next/c/e8b98168761f
  - [net-next,05/47] dt-bindings: can: renesas,rcar-canfd: Document R-Car V4H support
    https://git.kernel.org/netdev/net-next/c/3e17dc91c8a3
  - [net-next,06/47] dt-bindings: can: renesas,rcar-canfd: Add transceiver support
    https://git.kernel.org/netdev/net-next/c/a707d44dfb47
  - [net-next,07/47] can: rcar_canfd: Fix R-Car V3U CAN mode selection
    https://git.kernel.org/netdev/net-next/c/0a016639ef92
  - [net-next,08/47] can: rcar_canfd: Fix R-Car V3U GAFLCFG field accesses
    https://git.kernel.org/netdev/net-next/c/9be8c5583581
  - [net-next,09/47] can: rcar_canfd: Abstract out DCFG address differences
    https://git.kernel.org/netdev/net-next/c/bbf6681d1f0f
  - [net-next,10/47] can: rcar_canfd: Add support for R-Car Gen4
    https://git.kernel.org/netdev/net-next/c/8716e6e79a14
  - [net-next,11/47] can: rcar_canfd: Fix R-Car Gen4 DCFG.DSJW field width
    https://git.kernel.org/netdev/net-next/c/0424281688f1
  - [net-next,12/47] can: rcar_canfd: Fix R-Car Gen4 CFCC.CFTML field width
    https://git.kernel.org/netdev/net-next/c/3e73d3df4d38
  - [net-next,13/47] can: rcar_canfd: Sort included header files
    https://git.kernel.org/netdev/net-next/c/d506b151bb95
  - [net-next,14/47] can: rcar_canfd: Add helper variable dev
    https://git.kernel.org/netdev/net-next/c/114246e81fc6
  - [net-next,15/47] can: ems_pci: Fix code style, copyright and email address
    https://git.kernel.org/netdev/net-next/c/2b9ed3b9aaee
  - [net-next,16/47] can: ems_pci: Add Asix AX99100 definitions
    https://git.kernel.org/netdev/net-next/c/f5ef4d4f5365
  - [net-next,17/47] can: ems_pci: Initialize BAR registers
    https://git.kernel.org/netdev/net-next/c/f94a4f97f001
  - [net-next,18/47] can: ems_pci: Add read/write register and post irq functions
    https://git.kernel.org/netdev/net-next/c/bb89159ce331
  - [net-next,19/47] can: ems_pci: Initialize CAN controller base addresses
    https://git.kernel.org/netdev/net-next/c/79ca81e700f4
  - [net-next,20/47] can: ems_pci: Add IRQ enable
    https://git.kernel.org/netdev/net-next/c/8b4339f76da7
  - [net-next,21/47] can: ems_pci: Deassert hardware reset
    https://git.kernel.org/netdev/net-next/c/946c4135fd48
  - [net-next,22/47] can: ems_pci: Add myself as module author
    https://git.kernel.org/netdev/net-next/c/d5cd5d7fbd8c
  - [net-next,23/47] can: peak_usb: rename device_id to CAN channel ID
    https://git.kernel.org/netdev/net-next/c/404ffaa95a3e
  - [net-next,24/47] can: peak_usb: add callback to read CAN channel ID of PEAK CAN-FD devices
    https://git.kernel.org/netdev/net-next/c/517ad5e6761f
  - [net-next,25/47] can: peak_usb: allow flashing of the CAN channel ID
    https://git.kernel.org/netdev/net-next/c/e7a7b3d22503
  - [net-next,26/47] can: peak_usb: replace unregister_netdev() with unregister_candev()
    https://git.kernel.org/netdev/net-next/c/e1bd88225243
  - [net-next,27/47] can: peak_usb: add ethtool interface to user-configurable CAN channel identifier
    https://git.kernel.org/netdev/net-next/c/36d007c6fc79
  - [net-next,28/47] can: peak_usb: export PCAN CAN channel ID as sysfs device attribute
    https://git.kernel.org/netdev/net-next/c/6d02f6daeb44
  - [net-next,29/47] can: peak_usb: align CAN channel ID format in log with sysfs attribute
    https://git.kernel.org/netdev/net-next/c/09ce908e50c9
  - [net-next,30/47] can: peak_usb: Reorder include directives alphabetically
    https://git.kernel.org/netdev/net-next/c/73019de17732
  - [net-next,31/47] can: bittiming(): replace open coded variants of can_bit_time()
    https://git.kernel.org/netdev/net-next/c/89cfa6356560
  - [net-next,32/47] can: bittiming: can_fixup_bittiming(): use CAN_SYNC_SEG instead of 1
    https://git.kernel.org/netdev/net-next/c/9cf670dbe69d
  - [net-next,33/47] can: bittiming: can_fixup_bittiming(): set effective tq
    https://git.kernel.org/netdev/net-next/c/52375446f2b5
  - [net-next,34/47] can: bittiming: can_get_bittiming(): use direct return and remove unneeded else
    https://git.kernel.org/netdev/net-next/c/8e0a0b32c4ff
  - [net-next,35/47] can: dev: register_candev(): ensure that bittiming const are valid
    https://git.kernel.org/netdev/net-next/c/d58ac89d0d38
  - [net-next,36/47] can: dev: register_candev(): bail out if both fixed bit rates and bit timing constants are provided
    https://git.kernel.org/netdev/net-next/c/a3db542410af
  - [net-next,37/47] can: netlink: can_validate(): validate sample point for CAN and CAN-FD
    https://git.kernel.org/netdev/net-next/c/73335cfab7fd
  - [net-next,38/47] can: netlink: can_changelink(): convert from netdev_err() to NL_SET_ERR_MSG_FMT()
    https://git.kernel.org/netdev/net-next/c/1494d27f64f0
  - [net-next,39/47] can: bittiming: can_changelink() pass extack down callstack
    https://git.kernel.org/netdev/net-next/c/286c0e09e8e0
  - [net-next,40/47] can: bittiming: factor out can_sjw_set_default() and can_sjw_check()
    https://git.kernel.org/netdev/net-next/c/5988bf737dee
  - [net-next,41/47] can: bittiming: can_fixup_bittiming(): report error via netlink and harmonize error value
    https://git.kernel.org/netdev/net-next/c/de82d6185b82
  - [net-next,42/47] can: bittiming: can_sjw_check(): report error via netlink and harmonize error value
    https://git.kernel.org/netdev/net-next/c/0c017f0910a7
  - [net-next,43/47] can: bittiming: can_sjw_check(): check that SJW is not longer than either Phase Buffer Segment
    https://git.kernel.org/netdev/net-next/c/b5a3d0864ee7
  - [net-next,44/47] can: bittiming: can_sjw_set_default(): use Phase Seg2 / 2 as default for SJW
    https://git.kernel.org/netdev/net-next/c/80bcf5ec9927
  - [net-next,45/47] can: bittiming: can_calc_bittiming(): clean up SJW handling
    https://git.kernel.org/netdev/net-next/c/c7650728a702
  - [net-next,46/47] can: bittiming: can_calc_bittiming(): convert from netdev_err() to NL_SET_ERR_MSG_FMT()
    https://git.kernel.org/netdev/net-next/c/06742086a3d2
  - [net-next,47/47] can: bittiming: can_validate_bitrate(): report error via netlink
    https://git.kernel.org/netdev/net-next/c/6d7934719f26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


