Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE118613A77
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiJaPoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbiJaPoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:44:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED72D11A2B
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:44:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1opWxO-0002mk-Et
        for netdev@vger.kernel.org; Mon, 31 Oct 2022 16:44:10 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4830510F430
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:44:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2641C10F40B;
        Mon, 31 Oct 2022 15:44:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7c444614;
        Mon, 31 Oct 2022 15:44:07 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/14] pull-request: can-next 2022-10-31
Date:   Mon, 31 Oct 2022 16:43:52 +0100
Message-Id: <20221031154406.259857-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 14 patches for net-next/master.

The first 7 patches are by Stephane Grosjean and Lukas Magel and
target the peak_usb driver. Support for flashing a user defined device
ID via the ethtool flash interface is added. A read only sysfs
attribute for that value is added to distinguish between devices via
udev.

The next 2 patches are by me an fix minor coding style issues in the
kvaser_usb driver.

The last 5 patches are by Biju Das, target the rcar_canfd driver and
clean up the support for different IP cores.

regards,
Marc

---

The following changes since commit 02a97e02c64fb3245b84835cbbed1c3a3222e2f1:

  Merge tag 'mlx5-updates-2022-10-24' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2022-10-28 22:07:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-6.2-20221031

for you to fetch changes up to 3755b56a9b8ff8f1a6a21a979cc215c220401278:

  Merge patch series "R-Car CAN FD driver enhancements" (2022-10-31 16:15:25 +0100)

----------------------------------------------------------------
linux-can-next-for-6.2-20221031

----------------------------------------------------------------
Biju Das (5):
      can: rcar_canfd: rcar_canfd_probe: Add struct rcar_canfd_hw_info to driver data
      can: rcar_canfd: Add max_channels to struct rcar_canfd_hw_info
      can: rcar_canfd: Add shared_global_irqs to struct rcar_canfd_hw_info
      can: rcar_canfd: Add postdiv to struct rcar_canfd_hw_info
      can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info

Lukas Magel (2):
      can: peak_usb: export PCAN user device ID as sysfs device attribute
      can: peak_usb: align user device id format in log with sysfs attribute

Marc Kleine-Budde (4):
      Merge patch series "can: peak_usb: Introduce configurable user dev id"
      can: kvaser_usb: kvaser_usb_set_bittiming(): fix redundant initialization warning for err
      can: kvaser_usb: kvaser_usb_set_{,data}bittiming(): remove empty lines in variable declaration
      Merge patch series "R-Car CAN FD driver enhancements"

Stephane Grosjean (5):
      can: peak_usb: rename device_id to a more explicit name
      can: peak_usb: add callback to read user value of CANFD devices
      can: peak_usb: allow flashing of the user device id
      can: peak_usb: replace unregister_netdev() with unregister_candev()
      can: peak_usb: add ethtool interface to user defined flashed device number

 Documentation/ABI/testing/sysfs-class-net-peak_usb |  15 +++
 drivers/net/can/rcar/rcar_canfd.c                  |  85 +++++++++------
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   4 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  43 ++++++--
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       | 119 +++++++++++++++++++--
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |  11 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  64 ++++++++++-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |  26 ++++-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h        |   1 +
 9 files changed, 306 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-peak_usb


