Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A500E52DE4A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244711AbiESUXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244692AbiESUXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:23:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FBDA2046
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:23:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nrmgB-0005Gx-Sc
        for netdev@vger.kernel.org; Thu, 19 May 2022 22:23:27 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5B2E38261C
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 20:23:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EF5FA82616;
        Thu, 19 May 2022 20:23:26 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 84ca56c7;
        Thu, 19 May 2022 20:23:26 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/4] pull-request: can-next 2022-05-19
Date:   Thu, 19 May 2022 22:23:04 +0200
Message-Id: <20220519202308.1435903-1-mkl@pengutronix.de>
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

this is a pull request of 4 patches for net-next/master.

Oliver Hartkopp contributes a patch for the ISO-TP CAN protocol to
update the validation of address information during bind.

The next patch is by Jakub Kicinski and converts the CAN network
drivers from netif_napi_add() to the netif_napi_add_weight() function.

Another patch by Oliver Hartkopp removes obsolete CAN specific LED
support.

Vincent Mailhol's patch for the mcp251xfd driver fixes a
-Wunaligned-access warning by clang-14.

regards,
Marc

---

The following changes since commit d7e6f5836038eeac561411ed7a74e2a225a6c138:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-05-19 11:23:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.19-20220519

for you to fetch changes up to 1a6dd9996699889313327be03981716a8337656b:

  can: mcp251xfd: silence clang's -Wunaligned-access warning (2022-05-19 22:15:51 +0200)

----------------------------------------------------------------
linux-can-next-for-5.19-20220519

----------------------------------------------------------------
Jakub Kicinski (1):
      can: can-dev: move to netif_napi_add_weight()

Oliver Hartkopp (2):
      can: isotp: isotp_bind(): do not validate unused address information
      can: can-dev: remove obsolete CAN LED support

Vincent Mailhol (1):
      can: mcp251xfd: silence clang's -Wunaligned-access warning

 MAINTAINERS                               |   1 -
 drivers/net/can/Kconfig                   |  17 ----
 drivers/net/can/at91_can.c                |  12 +--
 drivers/net/can/c_can/c_can_main.c        |  19 +---
 drivers/net/can/ctucanfd/ctucanfd_base.c  |  10 ---
 drivers/net/can/dev/Makefile              |   2 -
 drivers/net/can/dev/dev.c                 |   5 --
 drivers/net/can/dev/rx-offload.c          |   5 +-
 drivers/net/can/flexcan/flexcan-core.c    |   7 --
 drivers/net/can/grcan.c                   |   2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c     |   9 --
 drivers/net/can/janz-ican3.c              |   2 +-
 drivers/net/can/led.c                     | 140 ------------------------------
 drivers/net/can/m_can/m_can.c             |  11 ---
 drivers/net/can/m_can/m_can.h             |   1 -
 drivers/net/can/mscan/mscan.c             |   2 +-
 drivers/net/can/pch_can.c                 |   2 +-
 drivers/net/can/rcar/rcar_can.c           |  12 +--
 drivers/net/can/rcar/rcar_canfd.c         |  11 +--
 drivers/net/can/sja1000/sja1000.c         |  11 ---
 drivers/net/can/spi/hi311x.c              |   8 --
 drivers/net/can/spi/mcp251x.c             |  10 ---
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h |   2 +-
 drivers/net/can/sun4i_can.c               |   7 --
 drivers/net/can/ti_hecc.c                 |   8 --
 drivers/net/can/usb/mcba_usb.c            |   8 --
 drivers/net/can/usb/usb_8dev.c            |  11 ---
 drivers/net/can/xilinx_can.c              |  12 +--
 include/linux/can/dev.h                   |  10 ---
 include/linux/can/led.h                   |  51 -----------
 net/can/isotp.c                           |  29 ++++---
 31 files changed, 34 insertions(+), 403 deletions(-)
 delete mode 100644 drivers/net/can/led.c
 delete mode 100644 include/linux/can/led.h


