Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DFB3929D6
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbhE0Itq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbhE0Itq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FB5C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgZ-0001v2-Nc
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:11 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 11C9062D3F2
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 64E7C62D3D8;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4ac409e1;
        Thu, 27 May 2021 08:45:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-05-27
Date:   Thu, 27 May 2021 10:45:11 +0200
Message-Id: <20210527084532.1384031-1-mkl@pengutronix.de>
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

this is a pull request of 21 patches for net-next/master. I hope
that's OK, as http://vger.kernel.org/~davem/net-next.html still says
closed.

The first 2 patches are by Geert Uytterhoeven and convert the rcan_can
and rcan_canfd device tree bindings to yaml.

The next 2 patches are by Oliver Hartkopp and me and update the CAN
uapi headers.

zuoqilin's patch removes an unnecessary variable from the CAN proc
code.

Patrick Menschel contributes 3 patches for CAN ISOTP to enhance the
error messages.

Jiapeng Chong's patch removes two dead stores from the softing driver.

The next 4 patches are by me and silence several warnings found by
clang compiler.

Jimmy Assarsson's patches for the kvaser_usb driver add support for
the Kvaser hydra devices.

Dario Binacchi provides 2 patches for the c_can driver, first removing
an unused variable, then adding basic ethtool support to query driver
and ring parameter info.

The last 4 patches are by Torin Cooper-Bennun and clean up the m_can
driver.

regards,
Marc

---

The following changes since commit 59c56342459a483d5e563ed8b5fdb77ab7622a73:

  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-05-26 18:33:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.14-20210527

for you to fetch changes up to 50fe7547b637b3cf51876ce9ec829e79d76e5de0:

  can: m_can: fix whitespace in a few comments (2021-05-27 09:42:24 +0200)

----------------------------------------------------------------
linux-can-next-for-5.14-20210527

----------------------------------------------------------------
Dario Binacchi (2):
      can: c_can: remove unused variable struct c_can_priv::rxmasked
      can: c_can: add ethtool support

Geert Uytterhoeven (2):
      dt-bindings: can: rcar_can: Convert to json-schema
      dt-bindings: can: rcar_canfd: Convert to json-schema

Jiapeng Chong (1):
      can: softing: Remove redundant variable ptr

Jimmy Assarsson (2):
      can: kvaser_usb: Rename define USB_HYBRID_{,PRO_}CANLIN_PRODUCT_ID
      can: kvaser_usb: Add new Kvaser hydra devices

Marc Kleine-Budde (5):
      can: uapi: update CAN-FD frame description
      can: hi311x: hi3110_can_probe(): silence clang warning
      can: mcp251x: mcp251x_can_probe(): silence clang warning
      can: mcp251xfd: silence clang warning
      can: at91_can: silence clang warning

Oliver Hartkopp (1):
      can: uapi: introduce CANFD_FDF flag for mixed content in struct canfd_frame

Patrick Menschel (3):
      can: isotp: change error format from decimal to symbolic error names
      can: isotp: add symbolic error message to isotp_module_init()
      can: isotp: Add error message if txqueuelen is too small

Torin Cooper-Bennun (4):
      can: m_can: use bits.h macros for all regmasks
      can: m_can: clean up CCCR reg defs, order by revs
      can: m_can: make TXESC, RXESC config more explicit
      can: m_can: fix whitespace in a few comments

zuoqilin (1):
      can: proc: remove unnecessary variables

 .../devicetree/bindings/net/can/rcar_can.txt       |  80 -------
 .../devicetree/bindings/net/can/rcar_canfd.txt     | 107 ---------
 .../bindings/net/can/renesas,rcar-can.yaml         | 139 ++++++++++++
 .../bindings/net/can/renesas,rcar-canfd.yaml       | 122 +++++++++++
 drivers/net/can/at91_can.c                         |   2 +-
 drivers/net/can/c_can/Makefile                     |   5 +
 drivers/net/can/c_can/c_can.h                      |   3 +-
 drivers/net/can/c_can/c_can_ethtool.c              |  43 ++++
 drivers/net/can/c_can/{c_can.c => c_can_main.c}    |   2 +-
 drivers/net/can/m_can/m_can.c                      | 244 ++++++++++-----------
 drivers/net/can/softing/softing_main.c             |   2 -
 drivers/net/can/spi/hi311x.c                       |   2 +-
 drivers/net/can/spi/mcp251x.c                      |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   2 +-
 drivers/net/can/usb/Kconfig                        |   2 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |  14 +-
 include/uapi/linux/can.h                           |  13 +-
 net/can/isotp.c                                    |  20 +-
 net/can/proc.c                                     |   6 +-
 19 files changed, 463 insertions(+), 347 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_can.txt
 delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_canfd.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-can.yaml
 create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
 create mode 100644 drivers/net/can/c_can/c_can_ethtool.c
 rename drivers/net/can/c_can/{c_can.c => c_can_main.c} (99%)



