Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760AF34F1F9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhC3UKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232236AbhC3UKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CF71E619C5;
        Tue, 30 Mar 2021 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617135017;
        bh=prDQ4WChxgXm6AYtsYO1xInbwKCQf1G8q/BhJ4ekHks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vpi1r11JvT2CcQC44z+88hJyPNJYmflfs8ssTugmcXvLe6vOTA5fPN9ghiiTZDmEy
         f3bS20VkiOQuDQd2gJJnaRkOzHRDRmrGyM9PL8uLraJHPz3mnW9zKmdv6HHQ8+1mZX
         e4Kelz0g9kndXmiwjNAkbhb1BJOMexdK/bwMqZAd82Tq+kXYBOrTOmWlL/8wySsFQH
         eRqmtyhfpWipW4HREOPfMpaKeXfMhUgbElw+aZxJdvipuEkp9GsBs5s+ecuGTeGF2d
         7vuoN8t5L3KUzIDV2yqEIALK4l9RPwdmXJIgA9BrapSfn6q8WdBH1vCoRZK2HJ9N/0
         y7xeJVEmqDR7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C368960A5B;
        Tue, 30 Mar 2021 20:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/39] MAINTAINERS: remove Dan Murphy from m_can and
 tcan4x5x
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713501779.31227.14464001356080250095.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 20:10:17 +0000
References: <20210330114559.1114855-2-mkl@pengutronix.de>
In-Reply-To: <20210330114559.1114855-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 13:45:21 +0200 you wrote:
> Dan Murphy's email address at ti.com doesn't work anymore, mails
> bounce with:
> 
> | 550 Invalid recipient <dmurphy@ti.com> (#5.1.1)
> 
> For now remove all CAN related entries of Dan from the Maintainers
> file.
> 
> [...]

Here is the summary with links:
  - [net-next,01/39] MAINTAINERS: remove Dan Murphy from m_can and tcan4x5x
    https://git.kernel.org/netdev/net-next/c/8560b0e7633b
  - [net-next,02/39] MAINTAINERS: Update MCAN MMIO device driver maintainer
    https://git.kernel.org/netdev/net-next/c/ba23dc6dcab5
  - [net-next,03/39] can: dev: always create TX echo skb
    https://git.kernel.org/netdev/net-next/c/7119d7864bc5
  - [net-next,04/39] can: dev: can_free_echo_skb(): don't crash the kernel if can_priv::echo_skb is accessed out of bounds
    https://git.kernel.org/netdev/net-next/c/4168d079aa41
  - [net-next,05/39] can: dev: can_free_echo_skb(): extend to return can frame length
    https://git.kernel.org/netdev/net-next/c/f318482a1c57
  - [net-next,06/39] can: add new CAN FD bittiming parameters: Transmitter Delay Compensation (TDC)
    https://git.kernel.org/netdev/net-next/c/289ea9e4ae59
  - [net-next,07/39] can: dev: reorder struct can_priv members for better packing
    https://git.kernel.org/netdev/net-next/c/4c9258dd26fd
  - [net-next,08/39] can: netlink: move '=' operators back to previous line (checkpatch fix)
    https://git.kernel.org/netdev/net-next/c/cfd98c838cbe
  - [net-next,09/39] can: bittiming: add calculation for CAN FD Transmitter Delay Compensation (TDC)
    https://git.kernel.org/netdev/net-next/c/c25cc7993243
  - [net-next,10/39] can: bittiming: add CAN_KBPS, CAN_MBPS and CAN_MHZ macros
    https://git.kernel.org/netdev/net-next/c/1d7750760b70
  - [net-next,11/39] can: grcan: add missing Kconfig dependency to HAS_IOMEM
    https://git.kernel.org/netdev/net-next/c/51894cbae49e
  - [net-next,12/39] can: xilinx_can: Simplify code by using dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/a3497afbe926
  - [net-next,13/39] can: ucan: fix alignment constraints
    https://git.kernel.org/netdev/net-next/c/27868a8fc1d0
  - [net-next,14/39] can: peak_usb: pcan_usb_pro_encode_msg(): use macros for flags instead of plain integers
    https://git.kernel.org/netdev/net-next/c/cfe2a4ca1e06
  - [net-next,15/39] can: peak_usb: add support of ethtool set_phys_id()
    https://git.kernel.org/netdev/net-next/c/a7e8511ffda6
  - [net-next,16/39] can: peak_usb: add support of ONE_SHOT mode
    https://git.kernel.org/netdev/net-next/c/58b29aa9d471
  - [net-next,17/39] can: m_can: m_can_class_allocate_dev(): remove impossible error return judgment
    https://git.kernel.org/netdev/net-next/c/8fa12201b652
  - [net-next,18/39] can: m_can: add infrastructure for internal timestamps
    https://git.kernel.org/netdev/net-next/c/17447f08202d
  - [net-next,19/39] can: m_can: m_can_chip_config(): enable and configure internal timestamps
    https://git.kernel.org/netdev/net-next/c/df06fd678260
  - [net-next,20/39] can: m_can: fix periph RX path: use rx-offload to ensure skbs are sent from softirq context
    https://git.kernel.org/netdev/net-next/c/1be37d3b0414
  - [net-next,21/39] can: tcan4x5x: remove duplicate include of regmap.h
    https://git.kernel.org/netdev/net-next/c/6c23fe67e8dc
  - [net-next,22/39] can: mcp251xfd: add dev coredump support
    https://git.kernel.org/netdev/net-next/c/e0ab3dd5f98f
  - [net-next,23/39] can: mcp251xfd: simplify UINC handling
    https://git.kernel.org/netdev/net-next/c/eb94b74ccda6
  - [net-next,24/39] can: mcp251xfd: move netdevice.h to mcp251xfd.h
    https://git.kernel.org/netdev/net-next/c/ae2e99401120
  - [net-next,25/39] can: mcp251xfd: mcp251xfd_get_timestamp(): move to mcp251xfd.h
    https://git.kernel.org/netdev/net-next/c/dc09e7e37152
  - [net-next,26/39] can: mcp251xfd: add HW timestamp infrastructure
    https://git.kernel.org/netdev/net-next/c/efd8d98dfb90
  - [net-next,27/39] can: mcp251xfd: add HW timestamp to RX, TX and error CAN frames
    https://git.kernel.org/netdev/net-next/c/5f02a49c6605
  - [net-next,28/39] can: c_can: convert block comments to network style comments
    https://git.kernel.org/netdev/net-next/c/172f6d3a031b
  - [net-next,29/39] can: c_can: remove unnecessary blank lines and add suggested ones
    https://git.kernel.org/netdev/net-next/c/beb7e88a2650
  - [net-next,30/39] can: c_can: fix indention
    https://git.kernel.org/netdev/net-next/c/2de0ea97ade0
  - [net-next,31/39] can: c_can: fix print formating string
    https://git.kernel.org/netdev/net-next/c/0c1b0138d641
  - [net-next,32/39] can: c_can: replace double assignments by two single ones
    https://git.kernel.org/netdev/net-next/c/995380f3fbfb
  - [net-next,33/39] can: c_can: fix remaining checkpatch warnings
    https://git.kernel.org/netdev/net-next/c/dd477500c70b
  - [net-next,34/39] can: c_can: remove unused code
    https://git.kernel.org/netdev/net-next/c/f65735c203d5
  - [net-next,35/39] can: c_can: fix indentation
    https://git.kernel.org/netdev/net-next/c/c8a6b44388cb
  - [net-next,36/39] can: c_can: add a comment about IF_RX interface's use
    https://git.kernel.org/netdev/net-next/c/eddf67115040
  - [net-next,37/39] can: c_can: use 32-bit write to set arbitration register
    https://git.kernel.org/netdev/net-next/c/fcbded019855
  - [net-next,38/39] can: c_can: prepare to up the message objects number
    https://git.kernel.org/netdev/net-next/c/13831ce69c77
  - [net-next,39/39] can: c_can: add support to 64 message objects
    https://git.kernel.org/netdev/net-next/c/132f2d45fb23

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


