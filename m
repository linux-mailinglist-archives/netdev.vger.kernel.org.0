Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1953455A9C9
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiFYMGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiFYMG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705B315802
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:19 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YL-0002WG-Mn
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:17 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6858A9F11C
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:03:49 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id F186B9F113;
        Sat, 25 Jun 2022 12:03:42 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c0178b3c;
        Sat, 25 Jun 2022 12:03:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/22] pull-request: can-next 2022-06-25
Date:   Sat, 25 Jun 2022 14:03:13 +0200
Message-Id: <20220625120335.324697-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 22 patches for net-next/master.

The first 2 patches target the xilinx driver. Srinivas Neeli's patch
adds Transmitter Delay Compensation (TDC) support, a patch by me fixes
a typo.

The next patch is by me and fixes a typo in the m_can driver.

Another patch by me allows the configuration of fixed bit rates
without need for do_set_bittiming callback.

The following 7 patches are by Vincent Mailhol and refactor the
can-dev module and Kbuild, de-inline the can_dropped_invalid_skb()
function, which has grown over the time, and drop outgoing skbs if the
controller is in listen only mode.

Max Staudt's patch fixes a reference in the networking/can.rst
documentation.

Vincent Mailhol provides 2 patches with cleanups for the etas_es58x
driver.

Conor Dooley adds bindings for the mpfs-can to the PolarFire SoC dtsi.

Another patch by me allows the configuration of fixed data bit rates
without need for do_set_data_bittiming callback.

The last 5 patches are by Frank Jungclaus. They prepare the esd_usb
driver to add support for the the CAN-USB/3 device in a later series.

regards,
Marc

---

The following changes since commit 27f2533bcc6e909b85d3c1b738fa1f203ed8a835:

  nfp: flower: support to offload pedit of IPv6 flowinto fields (2022-06-10 22:23:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.20-20220625

for you to fetch changes up to c3d396120d68c40cdf2a2da70eff3bf8806f0ff5:

  Merge branch 'preparation-for-supporting-esd-CAN-USB-3' (2022-06-25 13:08:41 +0200)

----------------------------------------------------------------
linux-can-next-for-5.20-20220625

----------------------------------------------------------------
Conor Dooley (2):
      dt-bindings: can: mpfs: document the mpfs CAN controller
      riscv: dts: microchip: add mpfs's CAN controllers

Frank Jungclaus (5):
      can/esd_usb2: Rename esd_usb2.c to esd_usb.c
      can/esd_usb: Add an entry to the MAINTAINERS file
      can/esd_usb: Rename all terms USB2 to USB
      can/esd_usb: Fixed some checkpatch.pl warnings
      can/esd_usb: Update to copyright, M_AUTHOR and M_DESCRIPTION

Marc Kleine-Budde (8):
      can: xilinx_can: fix typo prescalar -> prescaler
      can: m_can: fix typo prescalar -> prescaler
      can: netlink: allow configuring of fixed bit rates without need for do_set_bittiming callback
      Merge branch 'can-refactoring-of-can-dev-module-and-of-Kbuild'
      Merge branch 'can-etas_es58x-cleanups-on-struct-es58x_device'
      Merge branch 'document-polarfire-soc-can-controller'
      can: netlink: allow configuring of fixed data bit rates without need for do_set_data_bittiming callback
      Merge branch 'preparation-for-supporting-esd-CAN-USB-3'

Max Staudt (1):
      can: Break loopback loop on loopback documentation

Srinivas Neeli (1):
      can: xilinx_can: add Transmitter Delay Compensation (TDC) feature support

Vincent Mailhol (9):
      can: Kconfig: rename config symbol CAN_DEV into CAN_NETLINK
      can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using CAN_DEV
      can: bittiming: move bittiming calculation functions to calc_bittiming.c
      can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
      net: Kconfig: move the CAN device menu to the "Device Drivers" section
      can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid() to skb.c
      can: skb: drop tx skb if in listen only mode
      can: etas_es58x: replace es58x_device::rx_max_packet_size by usb_maxpacket()
      can: etas_es58x: fix signedness of USB RX and TX pipes

 .../bindings/net/can/microchip,mpfs-can.yaml       |  45 ++++
 Documentation/networking/can.rst                   |   2 +-
 MAINTAINERS                                        |   7 +
 arch/riscv/boot/dts/microchip/mpfs.dtsi            |  18 ++
 drivers/net/Kconfig                                |   2 +
 drivers/net/can/Kconfig                            |  55 ++++-
 drivers/net/can/dev/Makefile                       |  17 +-
 drivers/net/can/dev/bittiming.c                    | 197 ----------------
 drivers/net/can/dev/calc_bittiming.c               | 202 +++++++++++++++++
 drivers/net/can/dev/dev.c                          |   9 +-
 drivers/net/can/dev/netlink.c                      |   6 +-
 drivers/net/can/dev/skb.c                          |  72 ++++++
 drivers/net/can/m_can/Kconfig                      |   1 +
 drivers/net/can/m_can/m_can.c                      |   4 +-
 drivers/net/can/spi/mcp251xfd/Kconfig              |   1 +
 drivers/net/can/usb/Kconfig                        |  15 +-
 drivers/net/can/usb/Makefile                       |   2 +-
 drivers/net/can/usb/{esd_usb2.c => esd_usb.c}      | 250 ++++++++++-----------
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   5 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |   6 +-
 drivers/net/can/xilinx_can.c                       |  72 +++++-
 include/linux/can/skb.h                            |  59 +----
 net/can/Kconfig                                    |   5 +-
 23 files changed, 616 insertions(+), 436 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/microchip,mpfs-can.yaml
 create mode 100644 drivers/net/can/dev/calc_bittiming.c
 rename drivers/net/can/usb/{esd_usb2.c => esd_usb.c} (81%)


