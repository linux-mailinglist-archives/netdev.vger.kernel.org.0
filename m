Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032595860BB
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbiGaTUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbiGaTUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA040A1B7
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUK-00076F-2M
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:32 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6FA01BEBF6
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:31 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D373DBEBF0;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7219b3d1;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/36] pull-request: can-next 2022-07-31
Date:   Sun, 31 Jul 2022 21:19:53 +0200
Message-Id: <20220731192029.746751-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 36 patches for net-next/master.

The 1st patch is by me and fixes a typo in the mcp251xfd driver.

Vincent Mailhol contributes a series of 9 patches, which clean up the
drivers to make use of KBUILD_MODNAME instead of hard coded names and
remove DRV_VERSION.

Followed by 3 patches by Vincent Mailhol that directly set the
ethtool_ops in instead of calling a function in the slcan, c_can and
flexcan driver.

Vincent Mailhol contributes a KBUILD_MODNAME and pr_fmt cleanup patch
for the slcan driver. Dario Binacchi contributes 6 patches to clean up
the driver and remove the legacy driver infrastructure.

The next 14 patches are by Vincent Mailhol and target the various
drivers, they add ethtool support and reporting of timestamping
capabilities.

Another patch by Vincent Mailhol for the etas_es58x driver to remove
useless calls to usb_fill_bulk_urb().

The last patch is by Christophe JAILLET and fixes a broken link to
Documentation in the can327 driver.

regards,
Marc

---

The following changes since commit 8e4372e617854a16d4ec549ba821aad78fd748a6:

  Merge branch 'add-mtu-change-with-stmmac-interface-running' (2022-07-25 19:39:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.20-20220731

for you to fetch changes up to 7b584fbb36362340a2d9cfe459e447619eecebea:

  can: can327: fix a broken link to Documentation (2022-07-31 20:53:50 +0200)

----------------------------------------------------------------
linux-can-next-for-5.20-20220731

----------------------------------------------------------------
Christophe JAILLET (1):
      can: can327: fix a broken link to Documentation

Dario Binacchi (6):
      can: slcan: remove useless header inclusions
      can: slcan: remove legacy infrastructure
      can: slcan: change every `slc' occurrence in `slcan'
      can: slcan: use the generic can_change_mtu()
      can: slcan: add support for listen-only mode
      MAINTAINERS: Add maintainer for the slcan driver

Marc Kleine-Budde (5):
      can: mcp251xfd: mcp251xfd_dump(): fix comment
      Merge patch series "can: remove litteral strings used for driver names and remove DRV_VERSION"
      Merge patch series "can: export export slcan_ethtool_ops and remove setter functions"
      Merge patch series "can: slcan: extend supported features (step 2)"
      Merge patch series "can: add ethtool support and reporting of timestamping capabilities"

Vincent Mailhol (28):
      can: can327: use KBUILD_MODNAME instead of hard coded names
      can: ems_usb: use KBUILD_MODNAME instead of hard coded names
      can: softing: use KBUILD_MODNAME instead of hard coded names
      can: esd_usb: use KBUILD_MODNAME instead of hard coded names
      can: gs_ubs: use KBUILD_MODNAME instead of hard coded names
      can: kvaser_usb: use KBUILD_MODNAME instead of hard coded names
      can: ubs_8dev: use KBUILD_MODNAME instead of hard coded names
      can: etas_es58x: replace ES58X_MODULE_NAME with KBUILD_MODNAME
      can: etas_es58x: remove DRV_VERSION
      can: slcan: export slcan_ethtool_ops and remove slcan_set_ethtool_ops()
      can: c_can: export c_can_ethtool_ops and remove c_can_set_ethtool_ops()
      can: flexcan: export flexcan_ethtool_ops and remove flexcan_set_ethtool_ops()
      can: slcan: use KBUILD_MODNAME and define pr_fmt to replace hardcoded names
      can: can327: add software tx timestamps
      can: janz-ican3: add software tx timestamp
      can: slcan: add software tx timestamps
      can: v(x)can: add software tx timestamps
      can: tree-wide: advertise software timestamping capabilities
      can: dev: add hardware TX timestamp
      can: dev: add generic function can_ethtool_op_get_ts_info_hwts()
      can: dev: add generic function can_eth_ioctl_hwts()
      can: mcp251xfd: advertise timestamping capabilities and add ioctl support
      can: etas_es58x: advertise timestamping capabilities and add ioctl support
      can: kvaser_pciefd: advertise timestamping capabilities and add ioctl support
      can: kvaser_usb: advertise timestamping capabilities and add ioctl support
      can: peak_canfd: advertise timestamping capabilities and add ioctl support
      can: peak_usb: advertise timestamping capabilities and add ioctl support
      can: etas_es58x: remove useless calls to usb_fill_bulk_urb()

 MAINTAINERS                                       |   6 +
 drivers/net/can/at91_can.c                        |   6 +
 drivers/net/can/c_can/c_can.h                     |   2 +-
 drivers/net/can/c_can/c_can_ethtool.c             |   8 +-
 drivers/net/can/c_can/c_can_main.c                |   2 +-
 drivers/net/can/can327.c                          |  13 +-
 drivers/net/can/cc770/cc770.c                     |   6 +
 drivers/net/can/ctucanfd/ctucanfd_base.c          |   6 +
 drivers/net/can/dev/dev.c                         |  50 +++
 drivers/net/can/dev/skb.c                         |   6 +
 drivers/net/can/flexcan/flexcan-core.c            |   2 +-
 drivers/net/can/flexcan/flexcan-ethtool.c         |   8 +-
 drivers/net/can/flexcan/flexcan.h                 |   2 +-
 drivers/net/can/grcan.c                           |   6 +
 drivers/net/can/ifi_canfd/ifi_canfd.c             |   6 +
 drivers/net/can/janz-ican3.c                      |   8 +
 drivers/net/can/kvaser_pciefd.c                   |   7 +
 drivers/net/can/m_can/m_can.c                     |   6 +
 drivers/net/can/mscan/mscan.c                     |   5 +
 drivers/net/can/pch_can.c                         |   6 +
 drivers/net/can/peak_canfd/peak_canfd.c           |  48 +++
 drivers/net/can/rcar/rcar_can.c                   |   6 +
 drivers/net/can/rcar/rcar_canfd.c                 |   6 +
 drivers/net/can/sja1000/sja1000.c                 |   6 +
 drivers/net/can/slcan/slcan-core.c                | 461 +++++++---------------
 drivers/net/can/slcan/slcan-ethtool.c             |   8 +-
 drivers/net/can/slcan/slcan.h                     |   3 +-
 drivers/net/can/softing/softing_main.c            |  10 +-
 drivers/net/can/spi/hi311x.c                      |   6 +
 drivers/net/can/spi/mcp251x.c                     |   6 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c    |   1 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c    |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c |   1 +
 drivers/net/can/sun4i_can.c                       |   6 +
 drivers/net/can/ti_hecc.c                         |   6 +
 drivers/net/can/usb/ems_usb.c                     |  10 +-
 drivers/net/can/usb/esd_usb.c                     |   8 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c       |  34 +-
 drivers/net/can/usb/gs_usb.c                      |   8 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h       |   1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  |  29 +-
 drivers/net/can/usb/mcba_usb.c                    |   6 +
 drivers/net/can/usb/peak_usb/pcan_usb.c           |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c      |  41 ++
 drivers/net/can/usb/peak_usb/pcan_usb_core.h      |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c        |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c       |   1 +
 drivers/net/can/usb/ucan.c                        |   6 +
 drivers/net/can/usb/usb_8dev.c                    |  10 +-
 drivers/net/can/vcan.c                            |   8 +
 drivers/net/can/vxcan.c                           |   8 +
 drivers/net/can/xilinx_can.c                      |   6 +
 include/linux/can/dev.h                           |   4 +
 53 files changed, 541 insertions(+), 379 deletions(-)


