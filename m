Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AAC649D95
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiLLLax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiLLLaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:30:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C95A60FC
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:30:51 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1F-0008Pd-R1
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:30:49 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BBB2E13CB3A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6BBEA13CB2D;
        Mon, 12 Dec 2022 11:30:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c3c03821;
        Mon, 12 Dec 2022 11:30:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/39] pull-request: can-next 2022-12-12
Date:   Mon, 12 Dec 2022 12:30:06 +0100
Message-Id: <20221212113045.222493-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 39 patches for net-next/master.

The first 2 patches are by me fix a warning and coding style in the
kvaser_usb driver.

Vivek Yadav's patch sorts the includes of the m_can driver.

Biju Das contributes 5 patches for the rcar_canfd driver improve the
support for different IP core variants.

Jean Delvare's patch for the ctucanfd drops the dependency on
COMPILE_TEST.

Vincent Mailhol's patch sorts the includes of the etas_es58x driver.

Haibo Chen's contributes 2 patches that add i.MX93 support to the
flexcan driver.

Lad Prabhakar's patch updates the dt-bindings documentation of the
rcar_canfd driver.

Minghao Chi's patch converts the c_can platform driver to
devm_platform_get_and_ioremap_resource().

In the next 7 patches Vincent Mailhol adds devlink support to the
etas_es58x driver to report firmware, bootloader and hardware version.

Xu Panda's patch converts a strncpy() -> strscpy() in the ucan driver.

Ye Bin's patch removes a useless parameter from the AF_CAN protocol.

The next 2 patches by Vincent Mailhol and remove unneeded or unused
pointers to struct usb_interface in device's priv struct in the ucan
and gs_usb driver.

Vivek Yadav's patch cleans up the usage of the RAM initialization in
the m_can driver.

A patch by me add support for SO_MARK to the AF_CAN protocol.

Geert Uytterhoeven's patch fixes the number of CAN channels in the
rcan_canfd bindings documentation.

In the last 11 patches Markus Schneider-Pargmann optimizes the
register access in the t_can driver and cleans up the tcan glue
driver.

regards,
Marc

---

The following changes since commit dd8b3a802b64adf059a49a68f1bdca7846e492fc:

  Merge tag 'ipsec-next-2022-12-09' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next (2022-12-09 20:06:35 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-6.2-20221212

for you to fetch changes up to 47bf2b2393ea1aacdefbe4e9d643599e057bb3a2:

  Merge patch series "can: m_can: Optimizations for tcan and peripheral chips" (2022-12-12 12:01:26 +0100)

----------------------------------------------------------------
linux-can-next-for-6.2-20221212

----------------------------------------------------------------
Biju Das (5):
      can: rcar_canfd: rcar_canfd_probe: Add struct rcar_canfd_hw_info to driver data
      can: rcar_canfd: Add max_channels to struct rcar_canfd_hw_info
      can: rcar_canfd: Add shared_global_irqs to struct rcar_canfd_hw_info
      can: rcar_canfd: Add postdiv to struct rcar_canfd_hw_info
      can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info

Geert Uytterhoeven (1):
      dt-bindings: can: renesas,rcar-canfd: Fix number of channels for R-Car V3U

Haibo Chen (2):
      can: flexcan: add auto stop mode for IMX93 to support wakeup
      dt-bindings: can: fsl,flexcan: add imx93 compatible

Jean Delvare (1):
      can: ctucanfd: Drop obsolete dependency on COMPILE_TEST

Lad Prabhakar (1):
      dt-bindings: can: renesas,rcar-canfd: Document RZ/Five SoC

Marc Kleine-Budde (7):
      can: kvaser_usb: kvaser_usb_set_bittiming(): fix redundant initialization warning for err
      can: kvaser_usb: kvaser_usb_set_{,data}bittiming(): remove empty lines in variable declaration
      Merge patch series "R-Car CAN FD driver enhancements"
      Merge patch series "can: etas_es58x: report firmware, bootloader and hardware version"
      Merge patch series "can: usb: remove pointers to struct usb_interface in device's priv structures"
      can: raw: add support for SO_MARK
      Merge patch series "can: m_can: Optimizations for tcan and peripheral chips"

Markus Schneider-Pargmann (11):
      can: m_can: Eliminate double read of TXFQS in tx_handler
      can: m_can: Avoid reading irqstatus twice
      can: m_can: Read register PSR only on error
      can: m_can: Count TXE FIFO getidx in the driver
      can: m_can: Count read getindex in the driver
      can: m_can: Batch acknowledge transmit events
      can: m_can: Batch acknowledge rx fifo
      can: tcan4x5x: Remove invalid write in clear_interrupts
      can: tcan4x5x: Fix use of register error status mask
      can: tcan4x5x: Fix register range of first two blocks
      can: tcan4x5x: Specify separate read/write ranges

Minghao Chi (1):
      can: c_can: use devm_platform_get_and_ioremap_resource()

Vincent Mailhol (10):
      can: etas_es58x: sort the includes by alphabetic order
      can: etas_es58x: add devlink support
      can: etas_es58x: add devlink port support
      USB: core: export usb_cache_string()
      net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
      can: etas_es58x: export product information through devlink_ops::info_get()
      can: etas_es58x: remove es58x_get_product_info()
      Documentation: devlink: add devlink documentation for the etas_es58x driver
      can: ucan: remove unused ucan_priv::intf
      can: gs_usb: remove gs_can::iface

Vivek Yadav (2):
      can: m_can: sort header inclusion alphabetically
      can: m_can: Call the RAM init directly from m_can_chip_config

Xu Panda (1):
      can: ucan: use strscpy() to instead of strncpy()

Ye Bin (1):
      net: af_can: remove useless parameter 'err' in 'can_rx_register()'

 .../devicetree/bindings/net/can/fsl,flexcan.yaml   |   1 +
 .../bindings/net/can/renesas,rcar-canfd.yaml       | 135 ++++++------
 Documentation/networking/devlink/devlink-info.rst  |   5 +
 Documentation/networking/devlink/etas_es58x.rst    |  36 ++++
 MAINTAINERS                                        |   1 +
 drivers/net/can/c_can/c_can_platform.c             |   3 +-
 drivers/net/can/ctucanfd/Kconfig                   |   2 +-
 drivers/net/can/flexcan/flexcan-core.c             |  37 +++-
 drivers/net/can/flexcan/flexcan.h                  |   2 +
 drivers/net/can/m_can/m_can.c                      | 130 ++++++++----
 drivers/net/can/m_can/m_can.h                      |  16 +-
 drivers/net/can/m_can/m_can_platform.c             |   6 +-
 drivers/net/can/m_can/tcan4x5x-core.c              |  18 +-
 drivers/net/can/m_can/tcan4x5x-regmap.c            |  47 ++++-
 drivers/net/can/rcar/rcar_canfd.c                  |  85 +++++---
 drivers/net/can/usb/Kconfig                        |   1 +
 drivers/net/can/usb/etas_es58x/Makefile            |   2 +-
 drivers/net/can/usb/etas_es58x/es581_4.c           |   4 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        | 104 ++++-----
 drivers/net/can/usb/etas_es58x/es58x_core.h        |  58 ++++-
 drivers/net/can/usb/etas_es58x/es58x_devlink.c     | 235 +++++++++++++++++++++
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |   4 +-
 drivers/net/can/usb/gs_usb.c                       |  29 +--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   4 +-
 drivers/net/can/usb/ucan.c                         |   7 +-
 drivers/usb/core/message.c                         |   1 +
 drivers/usb/core/usb.h                             |   1 -
 include/linux/usb.h                                |   1 +
 include/net/devlink.h                              |   2 +
 net/can/af_can.c                                   |   3 +-
 net/can/raw.c                                      |   1 +
 31 files changed, 696 insertions(+), 285 deletions(-)
 create mode 100644 Documentation/networking/devlink/etas_es58x.rst
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_devlink.c


