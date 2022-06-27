Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE8B55C7B6
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbiF0LAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbiF0LAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4B110FE;
        Mon, 27 Jun 2022 04:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A32DB810B6;
        Mon, 27 Jun 2022 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49A96C341C8;
        Mon, 27 Jun 2022 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656327618;
        bh=w6sVnVLYfWBRI1xBG22mxueRcw+YocJX2LQLQQ7RbH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UmDn0YW22Gf5nm5sZz28+1nuHXl6vLDupHHNn/Bldh983zwZAGxL/F/SxiubdK6g1
         jms1pMuNnkBj0CCDl95LLpg7J87b8A6SK5eS2Ja2+lTrI+L0nYx5U8kdLznIwFZZ0U
         QbSOwYfvTIbw5WRK+nLEsQ4rNmZqoKoivMC3jD9LOHD3MKaCUbetTUlS88LNfB/fGk
         H2dJi1m9ZDRUUc2zdd0O0HfMQ8+0iGb5wiXQnivrsEXjVimNzmb6HQsz80H5FsOIY9
         9nEPmZYLDIYwRCE+7Y+hlf6vSaqhXDmlvX6AK54Jz6CDMEJdsYi2aifPDaJTJ2FcsY
         A1JKZI0SFvOxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 341A0E49BBB;
        Mon, 27 Jun 2022 11:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/22] can: xilinx_can: add Transmitter Delay
 Compensation (TDC) feature support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165632761820.13770.5989881110779354208.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Jun 2022 11:00:18 +0000
References: <20220625120335.324697-2-mkl@pengutronix.de>
In-Reply-To: <20220625120335.324697-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        srinivas.neeli@xilinx.com, mailhol.vincent@wanadoo.fr
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
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sat, 25 Jun 2022 14:03:14 +0200 you wrote:
> From: Srinivas Neeli <srinivas.neeli@xilinx.com>
> 
> This patch adds Transmitter Delay Compensation (TDC) feature support.
> 
> In the case of higher measured loop delay with higher bit rates, bit
> stuff errors are observed. Enabling the TDC feature in CAN-FD
> controllers will compensate for the measured loop delay in the receive
> path.
> 
> [...]

Here is the summary with links:
  - [net-next,01/22] can: xilinx_can: add Transmitter Delay Compensation (TDC) feature support
    https://git.kernel.org/netdev/net-next/c/1010a8fa9608
  - [net-next,02/22] can: xilinx_can: fix typo prescalar -> prescaler
    https://git.kernel.org/netdev/net-next/c/b9b352e12c59
  - [net-next,03/22] can: m_can: fix typo prescalar -> prescaler
    https://git.kernel.org/netdev/net-next/c/c38fb5316756
  - [net-next,04/22] can: netlink: allow configuring of fixed bit rates without need for do_set_bittiming callback
    https://git.kernel.org/netdev/net-next/c/7e193a42c37c
  - [net-next,05/22] can: Kconfig: rename config symbol CAN_DEV into CAN_NETLINK
    https://git.kernel.org/netdev/net-next/c/df6ad5dd838e
  - [net-next,06/22] can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using CAN_DEV
    https://git.kernel.org/netdev/net-next/c/6a5286442fb6
  - [net-next,07/22] can: bittiming: move bittiming calculation functions to calc_bittiming.c
    https://git.kernel.org/netdev/net-next/c/0c7e11513883
  - [net-next,08/22] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
    https://git.kernel.org/netdev/net-next/c/bfe0092dc237
  - [net-next,09/22] net: Kconfig: move the CAN device menu to the "Device Drivers" section
    https://git.kernel.org/netdev/net-next/c/d7786af59860
  - [net-next,10/22] can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid() to skb.c
    https://git.kernel.org/netdev/net-next/c/ccd8a9351f7b
  - [net-next,11/22] can: skb: drop tx skb if in listen only mode
    https://git.kernel.org/netdev/net-next/c/a6d190f8c767
  - [net-next,12/22] can: Break loopback loop on loopback documentation
    https://git.kernel.org/netdev/net-next/c/a9cf02c6a671
  - [net-next,13/22] can: etas_es58x: replace es58x_device::rx_max_packet_size by usb_maxpacket()
    https://git.kernel.org/netdev/net-next/c/173d349ba0b7
  - [net-next,14/22] can: etas_es58x: fix signedness of USB RX and TX pipes
    https://git.kernel.org/netdev/net-next/c/e0e0cc54000e
  - [net-next,15/22] dt-bindings: can: mpfs: document the mpfs CAN controller
    https://git.kernel.org/netdev/net-next/c/c878d518d7b6
  - [net-next,16/22] riscv: dts: microchip: add mpfs's CAN controllers
    https://git.kernel.org/netdev/net-next/c/38a71fc04895
  - [net-next,17/22] can: netlink: allow configuring of fixed data bit rates without need for do_set_data_bittiming callback
    https://git.kernel.org/netdev/net-next/c/ec30c109391c
  - [net-next,18/22] can/esd_usb2: Rename esd_usb2.c to esd_usb.c
    https://git.kernel.org/netdev/net-next/c/5e910bdedc84
  - [net-next,19/22] can/esd_usb: Add an entry to the MAINTAINERS file
    https://git.kernel.org/netdev/net-next/c/f4a45ef328a2
  - [net-next,20/22] can/esd_usb: Rename all terms USB2 to USB
    https://git.kernel.org/netdev/net-next/c/4d54977fe3f4
  - [net-next,21/22] can/esd_usb: Fixed some checkpatch.pl warnings
    https://git.kernel.org/netdev/net-next/c/2244610050c8
  - [net-next,22/22] can/esd_usb: Update to copyright, M_AUTHOR and M_DESCRIPTION
    https://git.kernel.org/netdev/net-next/c/ce87c0f1b859

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


