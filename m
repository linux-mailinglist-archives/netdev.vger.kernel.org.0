Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED3F272607
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgIUNqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgIUNqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C959C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:03 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8n-0003ED-My; Mon, 21 Sep 2020 15:46:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2020-09-21
Date:   Mon, 21 Sep 2020 15:45:19 +0200
Message-Id: <20200921134557.2251383-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

this is a pull request of 38 patches for net-next.

the first 5 patches are by Colin Ian King, Alexandre Belloni and me and they
fix various spelling mistakes.

The next patch is by me and fixes the indention in the CAN raw protocol
according to the kernel coding style.

Diego Elio Pettenò contributes two patches to fix dead links in CAN's Kconfig.

Masahiro Yamada's patch removes the "WITH Linux-syscall-note" from SPDX tag of
C files.

AThe next 4 patches are by me and target the CAN device infrastructure and add
error propagation and improve the output of various messages to ease driver
development and debugging.

YueHaibing's patch for the c_can driver removes an unused inline function.

Next follows another patch by Colin Ian King, which removes the unneeded
initialization of a variable in the mcba_usb driver.

A patch by me annotates a fallthrough in the mscan driver.

The ti_hecc driver is converted to use devm_platform_ioremap_resource_byname()
in a patch by Dejin Zheng.

Liu Shixin's patch converts the pcan_usb_pro driver to make use of
le32_add_cpu() instead of open coding it.

Wang Hai's patch for the peak_pciefd_main driver removes an unused makro.

Vaibhav Gupta's patch converts the pch_can driver to generic power management.

Stephane Grosjean improves the pcan_usb usb driver by first documenting the
commands sent to the device and by adding support of rxerr/txerr counters.

The next patch is by me and cleans up the Kconfig of the CAN SPI drivers.

The next 6 patches all target the mcp251x driver, they are by Timo Schlüßler,
Andy Shevchenko, Tim Harvey and me. They update the DT bindings documentation,
sort the include files alphabetically, add GPIO support, make use of the
readx_poll_timeout() helper, and add support for half duplex SPI-controllers.

Wolfram Sang contributes a patch to update the contact email address in the
mscan driver, while Zhang Changzhong updates the clock handling.

The next patch is by and updates the rx-offload infrastructure to support
callback less usage.

The last 6 patches add support for the mcp25xxfd CAN SPI driver. First the
dt-bindings are added by Oleksij Rempel, the regmap infrastructure and the main
driver is contributed by me. Kurt Van Dijck adds listen-only support,
Manivannan Sadhasivam adds himself as maintainer, and Thomas Kopp himself as a
reviewer.

regards,
Marc

---

The following changes since commit 3cec0369905d086a56a7515f3449982403057599:

  RDS: drop double zeroing (2020-09-20 19:09:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.10-20200921

for you to fetch changes up to 64fb587cfdc325e60903be85353c8a42219757b7:

  MAINTAINERS: Add reviewer entry for microchip mcp25xxfd SPI-CAN network driver (2020-09-21 10:13:20 +0200)

----------------------------------------------------------------
linux-can-next-for-5.10-20200921

----------------------------------------------------------------
Alexandre Belloni (1):
      can: flexcan: fix spelling mistake "reserverd" -> "reserved"

Andy Shevchenko (1):
      can: mcp251x: Use readx_poll_timeout() helper

Colin Ian King (2):
      can: grcan: fix spelling mistake "buss" -> "bus"
      can: mcba_usb: remove redundant initialization of variable err

Dejin Zheng (1):
      can: ti_hecc: convert to devm_platform_ioremap_resource_byname()

Diego Elio Pettenò (2):
      can: slcan: update dead link
      can: softing: update dead link

Kurt Van Dijck (1):
      can: mcp25xxfd: add listen-only mode

Liu Shixin (1):
      can: peak_usb: convert to use le32_add_cpu()

Manivannan Sadhasivam (1):
      MAINTAINERS: Add entry for Microchip MCP25XXFD SPI-CAN network driver

Marc Kleine-Budde (16):
      can: include: fix spelling mistakes
      can: net: fix spelling mistakes
      can: drivers: fix spelling mistakes
      can: raw: fix indention
      can: dev: can_put_echo_skb(): print number of echo_skb that is occupied
      can: dev: can_put_echo_skb(): propagate error in case of errors
      can: dev: can_change_state(): print human readable state change messages
      can: dev: can_bus_off(): print scheduling of restart if activated
      can: mscan: mark expected switch fall-through
      can: spi: Kconfig: remove unneeded dependencies form Kconfig symbols
      dt-bindings: can: mcp251x: change example interrupt type to IRQ_TYPE_LEVEL_LOW
      dt-bindings: can: mcp251x: document GPIO support
      can: mcp251x: sort include files alphabetically
      can: rx-offload: can_rx_offload_add_manual(): add new initialization function
      can: mcp25xxfd: add regmap infrastructure
      can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN

Masahiro Yamada (1):
      can: remove "WITH Linux-syscall-note" from SPDX tag of C files

Oleksij Rempel (1):
      dt-binding: can: mcp25xxfd: document device tree bindings

Stephane Grosjean (2):
      can: pcan_usb: Document the commands sent to the device
      can: pcan_usb: add support of rxerr/txerr counters

Thomas Kopp (1):
      MAINTAINERS: Add reviewer entry for microchip mcp25xxfd SPI-CAN network driver

Tim Harvey (1):
      can: mcp251x: add support for half duplex controllers

Timo Schlüßler (1):
      can: mcp251x: add GPIO support

Vaibhav Gupta (1):
      can: pch_can: use generic power management

Wang Hai (1):
      can: peak_canfd: Remove unused macros

Wolfram Sang (1):
      can: mscan: mpc5xxx_can: update contact email

YueHaibing (1):
      can: c_can: Remove unused inline function

Zhang Changzhong (1):
      can: mscan: simplify clock enable/disable

 .../bindings/net/can/microchip,mcp251x.txt         |    7 +-
 .../bindings/net/can/microchip,mcp25xxfd.yaml      |   79 +
 MAINTAINERS                                        |    9 +
 drivers/net/can/Kconfig                            |    4 +-
 drivers/net/can/at91_can.c                         |    8 +-
 drivers/net/can/c_can/c_can.c                      |    9 -
 drivers/net/can/cc770/cc770.c                      |    2 +-
 drivers/net/can/cc770/cc770.h                      |    2 +-
 drivers/net/can/dev.c                              |   45 +-
 drivers/net/can/flexcan.c                          |    2 +-
 drivers/net/can/grcan.c                            |    4 +-
 drivers/net/can/m_can/Kconfig                      |    2 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |    2 +-
 drivers/net/can/mscan/mscan.c                      |   29 +-
 drivers/net/can/pch_can.c                          |   67 +-
 drivers/net/can/peak_canfd/peak_pciefd_main.c      |    2 -
 drivers/net/can/rx-offload.c                       |   11 +
 drivers/net/can/sja1000/peak_pci.c                 |    2 +-
 drivers/net/can/sja1000/peak_pcmcia.c              |    2 +-
 drivers/net/can/softing/Kconfig                    |    6 +-
 drivers/net/can/softing/softing_fw.c               |    8 +-
 drivers/net/can/softing/softing_main.c             |    8 +-
 drivers/net/can/softing/softing_platform.h         |    2 +-
 drivers/net/can/spi/Kconfig                        |    4 +-
 drivers/net/can/spi/Makefile                       |    1 +
 drivers/net/can/spi/mcp251x.c                      |  345 ++-
 drivers/net/can/spi/mcp25xxfd/Kconfig              |   17 +
 drivers/net/can/spi/mcp25xxfd/Makefile             |    8 +
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c     | 2911 ++++++++++++++++++++
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-crc16.c    |   89 +
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-regmap.c   |  556 ++++
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h          |  835 ++++++
 drivers/net/can/ti_hecc.c                          |   29 +-
 drivers/net/can/usb/Kconfig                        |    2 +-
 drivers/net/can/usb/gs_usb.c                       |    4 +-
 drivers/net/can/usb/mcba_usb.c                     |    4 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  166 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |    4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |    4 +-
 drivers/net/can/usb/ucan.c                         |    4 +-
 drivers/net/can/usb/usb_8dev.c                     |    4 +-
 drivers/net/can/xilinx_can.c                       |    2 +-
 include/linux/can/core.h                           |    2 +-
 include/linux/can/dev.h                            |    6 +-
 include/linux/can/rx-offload.h                     |    3 +
 net/can/af_can.c                                   |    4 +-
 net/can/bcm.c                                      |    2 +-
 net/can/gw.c                                       |    2 +-
 net/can/proc.c                                     |    2 +-
 net/can/raw.c                                      |   26 +-
 50 files changed, 5116 insertions(+), 232 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml
 create mode 100644 drivers/net/can/spi/mcp25xxfd/Kconfig
 create mode 100644 drivers/net/can/spi/mcp25xxfd/Makefile
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-crc16.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-regmap.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h


