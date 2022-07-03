Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7235646AA
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiGCK0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiGCK0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:26:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6B0634D
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 03:26:09 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7wnn-0006A8-VR
        for netdev@vger.kernel.org; Sun, 03 Jul 2022 12:26:08 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 55852A6921
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 10:14:32 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D740EA691B;
        Sun,  3 Jul 2022 10:14:31 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id af6f6b42;
        Sun, 3 Jul 2022 10:14:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/15] pull-request: can-next 2022-07-03
Date:   Sun,  3 Jul 2022 12:14:14 +0200
Message-Id: <20220703101430.1306048-1-mkl@pengutronix.de>
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

this is a pull request of 15 patches for net-next/master.

The first 2 patches are by Max Staudt and add the can327 serial CAN
driver along with a new line discipline ID.

The next patch is by me an fixes a typo in the ctucanfd driver.

The last 12 patches are by Dario Binacchi and integrate slcan CAN
serial driver better into the existing CAN driver API.

regards,
Marc

---
The following changes since commit 0fcae3c8b1b32d79cb4bbf841023757358fb0413:

  ipmr: fix a lockdep splat in ipmr_rtm_dumplink() (2022-06-27 12:01:01 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.20-20220703

for you to fetch changes up to 0ebd5529d2ddab76a46681991d350b82c62ef13e:

  Merge branch 'can-slcan-extend-supported-features' (2022-07-03 11:37:05 +0200)

----------------------------------------------------------------
linux-can-next-for-5.20-20220703

----------------------------------------------------------------
Dario Binacchi (12):
      can: slcan: use the BIT() helper
      can: slcan: use netdev helpers to print out messages
      can: slcan: use the alloc_can_skb() helper
      can: netlink: dump bitrate 0 if can_priv::bittiming.bitrate is -1U
      can: slcan: use CAN network device driver API
      can: slcan: allow to send commands to the adapter
      can: slcan: set bitrate by CAN device driver API
      can: slcan: send the open/close commands to the adapter
      can: slcan: move driver into separate sub directory
      can: slcan: add ethtool support to reset adapter errors
      can: slcan: extend the protocol with error info
      can: slcan: extend the protocol with CAN state info

Marc Kleine-Budde (3):
      Merge branch 'can327-CAN-ldisc-driver-for-ELM327-based-OBD-II-adapters'
      can: ctucanfd: ctucan_interrupt(): fix typo
      Merge branch 'can-slcan-extend-supported-features'

Max Staudt (2):
      tty: Add N_CAN327 line discipline ID for ELM327 based CAN driver
      can: can327: CAN/ldisc driver for ELM327 based OBD-II adapters

 .../networking/device_drivers/can/can327.rst       |  331 ++++++
 .../networking/device_drivers/can/index.rst        |    1 +
 MAINTAINERS                                        |    7 +
 drivers/net/can/Kconfig                            |   58 +-
 drivers/net/can/Makefile                           |    3 +-
 drivers/net/can/can327.c                           | 1137 ++++++++++++++++++++
 drivers/net/can/ctucanfd/ctucanfd_base.c           |    2 +-
 drivers/net/can/dev/netlink.c                      |    3 +-
 drivers/net/can/slcan/Makefile                     |    7 +
 drivers/net/can/{slcan.c => slcan/slcan-core.c}    |  504 +++++++--
 drivers/net/can/slcan/slcan-ethtool.c              |   65 ++
 drivers/net/can/slcan/slcan.h                      |   18 +
 include/linux/can/bittiming.h                      |    2 +
 include/uapi/linux/tty.h                           |    3 +-
 14 files changed, 2034 insertions(+), 107 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/can/can327.rst
 create mode 100644 drivers/net/can/can327.c
 create mode 100644 drivers/net/can/slcan/Makefile
 rename drivers/net/can/{slcan.c => slcan/slcan-core.c} (65%)
 create mode 100644 drivers/net/can/slcan/slcan-ethtool.c
 create mode 100644 drivers/net/can/slcan/slcan.h


