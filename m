Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800A25071A3
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 17:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353849AbiDSP2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 11:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353814AbiDSP2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 11:28:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5BC13F6C
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 08:26:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ngpjr-0001JG-A8
        for netdev@vger.kernel.org; Tue, 19 Apr 2022 17:25:59 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5578866ACA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 15:25:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EC56266AAD;
        Tue, 19 Apr 2022 15:25:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0b875914;
        Tue, 19 Apr 2022 15:25:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/17] pull-request: can-next 2022-04-19
Date:   Tue, 19 Apr 2022 17:25:37 +0200
Message-Id: <20220419152554.2925353-1-mkl@pengutronix.de>
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

this is a pull request of 17 patches for net-next/master.

The first 2 patches are by me and target the CAN driver
infrastructure. One patch renames a function in the rx_offload helper
the other one updates the CAN bitrate calculation to prefer small bit
rate pre-scalers over larger ones, which is encouraged by the CAN in
Automation.

Kris Bahnsen contributes a patch to fix the links to Technologic
Systems web resources in the sja1000 driver.

Christophe Leroy's patch prepares the mpc5xxx_can driver for upcoming
powerpc header cleanup.

Minghao Chi's patch converts the flexcan driver to use
pm_runtime_resume_and_get().

The next 2 patches target the Xilinx CAN driver. Lukas Bulwahn's patch
fixes an entry in the MAINTAINERS file. A patch by me marks the bit
timing constants as const.

Wolfram Sang's patch documents r8a77961 support on the
renesas,rcar-canfd bindings document.

The next 2 patches are by me and add support for the mcp251863 chip to
the mcp251xfd driver.

The last 7 patches are by Pavel Pisa, Martin Jerabek et al. and add
the ctucanfd driver for the CTU CAN FD IP Core.

regards,
Marc

---

The following changes since commit cc4bdef26ecd56de16a04bc6d99aa10ff9076498:

  Merge branch 'rtnetlink-improve-alt_ifname-config-and-fix-dangerous-group-usage' (2022-04-19 13:39:01 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.19-20220419

for you to fetch changes up to cfdb2f365cb9de8f2fd1fb726d82b5bae5e042ab:

  MAINTAINERS: Add maintainers for CTU CAN FD IP core driver (2022-04-19 17:12:15 +0200)

----------------------------------------------------------------
linux-can-next-for-5.19-20220419

----------------------------------------------------------------
Christophe Leroy (1):
      can: mscan: mpc5xxx_can: Prepare cleanup of powerpc's asm/prom.h

Kris Bahnsen (1):
      can: Fix Links to Technologic Systems web resources

Lukas Bulwahn (1):
      MAINTAINERS: rectify entry for XILINX CAN DRIVER

Marc Kleine-Budde (5):
      can: rx-offload: rename can_rx_offload_queue_sorted() -> can_rx_offload_queue_timestamp()
      can: bittiming: can_calc_bittiming(): prefer small bit rate pre-scalers over larger ones
      can: xilinx_can: mark bit timing constants as const
      dt-binding: can: mcp251xfd: add binding information for mcp251863
      can: mcp251xfd: add support for mcp251863

Martin Jerabek (1):
      can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.

Minghao Chi (1):
      can: flexcan: using pm_runtime_resume_and_get instead of pm_runtime_get_sync

Pavel Pisa (6):
      dt-bindings: vendor-prefix: add prefix for the Czech Technical University in Prague.
      dt-bindings: net: can: binding for CTU CAN FD open-source IP core.
      can: ctucanfd: CTU CAN FD open-source IP core - PCI bus support.
      can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.
      docs: ctucanfd: CTU CAN FD open-source IP core documentation.
      MAINTAINERS: Add maintainers for CTU CAN FD IP core driver

Wolfram Sang (1):
      dt-bindings: can: renesas,rcar-canfd: document r8a77961 support

 .../devicetree/bindings/net/can/ctu,ctucanfd.yaml  |   63 +
 .../bindings/net/can/microchip,mcp251xfd.yaml      |   19 +-
 .../bindings/net/can/renesas,rcar-canfd.yaml       |    1 +
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 .../device_drivers/can/ctu/ctucanfd-driver.rst     |  639 +++++++++
 .../device_drivers/can/ctu/fsm_txt_buffer_user.svg |  151 ++
 MAINTAINERS                                        |   10 +-
 drivers/net/can/Kconfig                            |    1 +
 drivers/net/can/Makefile                           |    1 +
 drivers/net/can/ctucanfd/Kconfig                   |   34 +
 drivers/net/can/ctucanfd/Makefile                  |   10 +
 drivers/net/can/ctucanfd/ctucanfd.h                |   82 ++
 drivers/net/can/ctucanfd/ctucanfd_base.c           | 1490 ++++++++++++++++++++
 drivers/net/can/ctucanfd/ctucanfd_kframe.h         |   77 +
 drivers/net/can/ctucanfd/ctucanfd_kregs.h          |  325 +++++
 drivers/net/can/ctucanfd/ctucanfd_pci.c            |  304 ++++
 drivers/net/can/ctucanfd/ctucanfd_platform.c       |  132 ++
 drivers/net/can/dev/bittiming.c                    |    2 +-
 drivers/net/can/dev/rx-offload.c                   |    6 +-
 drivers/net/can/flexcan/flexcan-core.c             |   16 +-
 drivers/net/can/m_can/m_can.c                      |    2 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |    2 +
 drivers/net/can/sja1000/Kconfig                    |    2 +-
 drivers/net/can/sja1000/tscan1.c                   |    7 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   25 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c       |    2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   12 +-
 drivers/net/can/ti_hecc.c                          |    4 +-
 drivers/net/can/xilinx_can.c                       |    4 +-
 include/linux/can/rx-offload.h                     |    4 +-
 30 files changed, 3382 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
 create mode 100644 Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
 create mode 100644 Documentation/networking/device_drivers/can/ctu/fsm_txt_buffer_user.svg
 create mode 100644 drivers/net/can/ctucanfd/Kconfig
 create mode 100644 drivers/net/can/ctucanfd/Makefile
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd.h
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_base.c
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_kframe.h
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_kregs.h
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_pci.c
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_platform.c


