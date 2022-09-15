Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE75B961A
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiIOIUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiIOIUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:20:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF60979D9
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6d-0004AL-7I
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:19 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7D10AE3950
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:16 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5E44AE3928;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1d5ca748;
        Thu, 15 Sep 2022 08:20:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/23] pull-request: can-next 2022-09-15
Date:   Thu, 15 Sep 2022 10:19:50 +0200
Message-Id: <20220915082013.369072-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 23 patches for net-next/master.

the first 2 patches are by me and fix a typo in the rx-offload helper
and the flexcan driver.

Christophe JAILLET's patch cleans up the error handling in
rcar_canfd driver's probe function.

Kenneth Lee's patch converts the kvaser_usb driver from kcalloc() to
kzalloc().

Biju Das contributes 2 patches to the sja1000 driver which update the
DT bindings and support for the RZ/N1 SJA1000 CAN controller.

Jinpeng Cui provides 2 patches that remove redundant variables from
the sja1000 and kvaser_pciefd driver.

2 patches by John Whittington and me add hardware timestamp support to
the gs_usb driver.

Gustavo A. R. Silva's patch converts the etas_es58x driver to make use
of DECLARE_FLEX_ARRAY().

Krzysztof Kozlowski's patch cleans up the sja1000 DT bindings.

Dario Binacchi fixes his invalid email in the flexcan driver
documentation.

Ziyang Xuan contributes 2 patches that clean up the CAN RAW protocol.

Yang Yingliang's patch switches the flexcan driver to dev_err_probe().

The last 7 patches are by Oliver Hartkopp and add support for the next
generation of the CAN protocol: CAN with eXtended data Length (CAN XL).

regards,
Marc

---

The following changes since commit 96efd6d01461be234bfc4ca1048a3d5febf0c425:

  r8169: remove not needed net_ratelimit() check (2022-09-05 14:49:59 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-6.1-20220915

for you to fetch changes up to c337f103f7781bc8223c650e94492bf08df71482:

  Merge patch series "can: support CAN XL" (2022-09-15 09:13:31 +0200)

----------------------------------------------------------------
linux-can-next-for-6.1-20220915

----------------------------------------------------------------
Biju Das (2):
      dt-bindings: can: nxp,sja1000: Document RZ/N1 power-domains support
      can: sja1000: Add support for RZ/N1 SJA1000 CAN Controller

Christophe JAILLET (1):
      can: rcar_canfd: Use dev_err_probe() to simplify code and better handle -EPROBE_DEFER

Dario Binacchi (1):
      docs: networking: device drivers: flexcan: fix invalid email

Gustavo A. R. Silva (1):
      can: etas_es58x: Replace zero-length array with DECLARE_FLEX_ARRAY() helper

Jinpeng Cui (2):
      can: sja1000: remove redundant variable ret
      can: kvaser_pciefd: remove redundant variable ret

John Whittington (1):
      can: gs_usb: add RX and TX hardware timestamp support

Kenneth Lee (1):
      can: kvaser_usb: kvaser_usb_hydra: Use kzalloc for allocating only one element

Krzysztof Kozlowski (1):
      dt-bindings: net: can: nxp,sja1000: drop ref from reg-io-width

Marc Kleine-Budde (6):
      can: rx-offload: can_rx_offload_init_queue(): fix typo
      can: flexcan: fix typo: FLEXCAN_QUIRK_SUPPPORT_* -> FLEXCAN_QUIRK_SUPPORT_*
      can: gs_usb: use common spelling of GS_USB in macros
      Merge patch series "can: gs_usb: hardware timestamp support"
      Merge patch series "can: raw: random optimizations"
      Merge patch series "can: support CAN XL"

Oliver Hartkopp (7):
      can: skb: unify skb CAN frame identification helpers
      can: skb: add skb CAN frame data length helpers
      can: set CANFD_FDF flag in all CAN FD frame structures
      can: canxl: introduce CAN XL data structure
      can: canxl: update CAN infrastructure for CAN XL frames
      can: dev: add CAN XL support to virtual CAN
      can: raw: add CAN XL support

Yang Yingliang (1):
      can: flexcan: Switch to use dev_err_probe() helper

Ziyang Xuan (2):
      can: raw: process optimization in raw_init()
      can: raw: use guard clause to optimize nesting in raw_rcv()

 .../devicetree/bindings/net/can/nxp,sja1000.yaml   |   6 +-
 .../device_drivers/can/freescale/flexcan.rst       |   2 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |   1 -
 drivers/net/can/dev/rx-offload.c                   |   4 +-
 drivers/net/can/dev/skb.c                          | 113 +++++++----
 drivers/net/can/flexcan/flexcan-core.c             |  59 +++---
 drivers/net/can/flexcan/flexcan.h                  |  20 +-
 drivers/net/can/kvaser_pciefd.c                    |   7 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  26 +--
 drivers/net/can/sja1000/sja1000.c                  |   6 +-
 drivers/net/can/sja1000/sja1000_platform.c         |  38 +++-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |   2 +-
 drivers/net/can/usb/gs_usb.c                       | 215 +++++++++++++++++++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  20 +-
 drivers/net/can/vcan.c                             |  12 +-
 drivers/net/can/vxcan.c                            |   8 +-
 include/linux/can/dev.h                            |   5 +
 include/linux/can/skb.h                            |  57 +++++-
 include/uapi/linux/can.h                           |  55 +++++-
 include/uapi/linux/can/raw.h                       |   1 +
 include/uapi/linux/if_ether.h                      |   1 +
 net/can/af_can.c                                   |  76 ++++----
 net/can/bcm.c                                      |   9 +-
 net/can/gw.c                                       |   4 +-
 net/can/isotp.c                                    |   2 +-
 net/can/j1939/main.c                               |   4 +
 net/can/raw.c                                      |  82 +++++---
 27 files changed, 616 insertions(+), 219 deletions(-)


