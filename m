Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10C734E685
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhC3LqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbhC3LqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7A2C061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCov-0005Xr-GN
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:05 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D3ECA603DD7
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:02 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id AB162603DBE;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2b038bb3;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-03-30
Date:   Tue, 30 Mar 2021 13:45:20 +0200
Message-Id: <20210330114559.1114855-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 39 patches for net-next/master.

The first two patches update the MAINTAINERS file. One is by me and
removes Dan Murphy from the from m_can and tcan4x5x. The other one is
by Pankaj Sharma and updates the maintainership of the m-can mmio
driver.

The next three patches are by me and update the CAN echo skb handling.

Vincent Mailhol provides 5 patches where Transmitter Delay
Compensation is added CAN bittiming calculation is cleaned up.

The next patch is by me and adds a missing HAS_IOMEM to the grcan
driver.

Michal Simek's patch for the xilinx driver add dev_err_probe()
support.

Arnd Bergmann's patch for the ucan driver fixes a compiler warning.

Stephane Grosjean provides 3 patches for the peak USB drivers, which
add ethtool set_phys_id and CAN one-shot mode.

Xulin Sun's patch removes a not needed return check in the m-can
driver. Torin Cooper-Bennun provides 3 patches for the m-can driver
that add rx-offload support to ensure that skbs are sent from softirq
context. Wan Jiabing's patch for the tcan4x5x driver removes a
duplicate include.

The next 6 patches are by me and target the mcp251xfd driver. They add
devcoredump support, simplify the UINC handling, and add HW timestamp
support.

The remaining 12 patches target the c_can driver. The first 6 are by
me and do generic checkpatch related cleanup work. Dario Binacchi's
patches bring some cleanups and increase the number of usable message
objects from 16 to 64.

regards,
Marc

---

The following changes since commit d0922bf7981799fd86e248de330fb4152399d6c2:

  hv_netvsc: Add error handling while switching data path (2021-03-29 16:35:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.13-20210330

for you to fetch changes up to 132f2d45fb2302a582aef617ea766f3fa52a084c:

  can: c_can: add support to 64 message objects (2021-03-30 11:14:53 +0200)

----------------------------------------------------------------
linux-can-next-for-5.13-20210330

----------------------------------------------------------------
Arnd Bergmann (1):
      can: ucan: fix alignment constraints

Dario Binacchi (6):
      can: c_can: remove unused code
      can: c_can: fix indentation
      can: c_can: add a comment about IF_RX interface's use
      can: c_can: use 32-bit write to set arbitration register
      can: c_can: prepare to up the message objects number
      can: c_can: add support to 64 message objects

Marc Kleine-Budde (17):
      MAINTAINERS: remove Dan Murphy from m_can and tcan4x5x
      can: dev: always create TX echo skb
      can: dev: can_free_echo_skb(): don't crash the kernel if can_priv::echo_skb is accessed out of bounds
      can: dev: can_free_echo_skb(): extend to return can frame length
      can: grcan: add missing Kconfig dependency to HAS_IOMEM
      can: mcp251xfd: add dev coredump support
      can: mcp251xfd: simplify UINC handling
      can: mcp251xfd: move netdevice.h to mcp251xfd.h
      can: mcp251xfd: mcp251xfd_get_timestamp(): move to mcp251xfd.h
      can: mcp251xfd: add HW timestamp infrastructure
      can: mcp251xfd: add HW timestamp to RX, TX and error CAN frames
      can: c_can: convert block comments to network style comments
      can: c_can: remove unnecessary blank lines and add suggested ones
      can: c_can: fix indention
      can: c_can: fix print formating string
      can: c_can: replace double assignments by two single ones
      can: c_can: fix remaining checkpatch warnings

Michal Simek (1):
      can: xilinx_can: Simplify code by using dev_err_probe()

Pankaj Sharma (1):
      MAINTAINERS: Update MCAN MMIO device driver maintainer

Stephane Grosjean (3):
      can: peak_usb: pcan_usb_pro_encode_msg(): use macros for flags instead of plain integers
      can: peak_usb: add support of ethtool set_phys_id()
      can: peak_usb: add support of ONE_SHOT mode

Torin Cooper-Bennun (3):
      can: m_can: add infrastructure for internal timestamps
      can: m_can: m_can_chip_config(): enable and configure internal timestamps
      can: m_can: fix periph RX path: use rx-offload to ensure skbs are sent from softirq context

Vincent Mailhol (5):
      can: add new CAN FD bittiming parameters: Transmitter Delay Compensation (TDC)
      can: dev: reorder struct can_priv members for better packing
      can: netlink: move '=' operators back to previous line (checkpatch fix)
      can: bittiming: add calculation for CAN FD Transmitter Delay Compensation (TDC)
      can: bittiming: add CAN_KBPS, CAN_MBPS and CAN_MHZ macros

Wan Jiabing (1):
      can: tcan4x5x: remove duplicate include of regmap.h

Xulin Sun (1):
      can: m_can: m_can_class_allocate_dev(): remove impossible error return judgment

 MAINTAINERS                                        |  10 +-
 drivers/net/can/Kconfig                            |   2 +-
 drivers/net/can/c_can/c_can.c                      | 153 +++++------
 drivers/net/can/c_can/c_can.h                      |  42 ++-
 drivers/net/can/c_can/c_can_pci.c                  |  31 ++-
 drivers/net/can/c_can/c_can_platform.c             |   6 +-
 drivers/net/can/dev/bittiming.c                    |  28 +-
 drivers/net/can/dev/netlink.c                      |  27 +-
 drivers/net/can/dev/skb.c                          |  27 +-
 drivers/net/can/grcan.c                            |   2 +-
 drivers/net/can/m_can/m_can.c                      | 160 ++++++++++--
 drivers/net/can/m_can/m_can.h                      |   2 +
 drivers/net/can/m_can/tcan4x5x.h                   |   1 -
 drivers/net/can/rcar/rcar_can.c                    |   2 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   2 +-
 drivers/net/can/sja1000/sja1000.c                  |   2 +-
 drivers/net/can/spi/hi311x.c                       |   2 +-
 drivers/net/can/spi/mcp251x.c                      |   2 +-
 drivers/net/can/spi/mcp251xfd/Kconfig              |   1 +
 drivers/net/can/spi/mcp251xfd/Makefile             |   3 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     | 104 ++++----
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c     | 285 +++++++++++++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.h     |  45 ++++
 .../net/can/spi/mcp251xfd/mcp251xfd-timestamp.c    |  71 +++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |  28 ++
 drivers/net/can/usb/ems_usb.c                      |   2 +-
 drivers/net/can/usb/esd_usb2.c                     |   4 +-
 drivers/net/can/usb/gs_usb.c                       |   2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   2 +-
 drivers/net/can/usb/mcba_usb.c                     |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  47 ++++
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   6 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |   2 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  46 +++-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |  46 +++-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h        |   6 +
 drivers/net/can/usb/ucan.c                         |   8 +-
 drivers/net/can/usb/usb_8dev.c                     |   2 +-
 drivers/net/can/xilinx_can.c                       |  10 +-
 include/linux/can/bittiming.h                      |  79 ++++++
 include/linux/can/dev.h                            |  14 +-
 include/linux/can/skb.h                            |   3 +-
 42 files changed, 1068 insertions(+), 251 deletions(-)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.h
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c


