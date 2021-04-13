Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B32335DBC7
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbhDMJw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbhDMJw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:52:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837E7C061756
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:52:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWFiJ-0002Il-3o
        for netdev@vger.kernel.org; Tue, 13 Apr 2021 11:52:07 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4F1BE60DA52
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:52:04 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0E1B560DA41;
        Tue, 13 Apr 2021 09:52:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id eb1209a4;
        Tue, 13 Apr 2021 09:52:02 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-04-13
Date:   Tue, 13 Apr 2021 11:51:47 +0200
Message-Id: <20210413095201.2409865-1-mkl@pengutronix.de>
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

this is a pull request of 14 patches for net-next/master.

The first patch is by Yoshihiro Shimoda and updates the DT bindings
for the rcar_can driver.

Vincent Mailhol contributes 3 patches that add support for several
ETAS USB CAN adapters.

The final 10 patches are by me and clean up the peak_usb CAN driver.

regards,
Marc

---

The following changes since commit 8ef7adc6beb2ef0bce83513dc9e4505e7b21e8c2:

  net: ethernet: ravb: Enable optional refclk (2021-04-12 14:09:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.13-20210413

for you to fetch changes up to bd573ea5720470d1ea70f3e39fb2e2efad219311:

  can: peak_usb: pcan_usb: replace open coded endianness conversion of unaligned data (2021-04-13 10:15:44 +0200)

----------------------------------------------------------------
linux-can-next-for-5.13-20210413

----------------------------------------------------------------
Marc Kleine-Budde (10):
      can: peak_usb: fix checkpatch warnings
      can: peak_usb: pcan_usb_pro.h: remove double space in indention
      can: peak_usb: remove unused variables from struct peak_usb_device
      can: peak_usb: remove write only variable struct peak_usb_adapter::ts_period
      can: peak_usb: peak_usb_probe(): make use of driver_info
      can: peak_usb: pcan_usb_{,pro}_get_device_id(): remove unneeded check for device_id
      can: peak_usb: pcan_usb_get_serial(): remove error message from error path
      can: peak_usb: pcan_usb_get_serial(): make use of le32_to_cpup()
      can: peak_usb: pcan_usb_get_serial(): unconditionally assign serial_number
      can: peak_usb: pcan_usb: replace open coded endianness conversion of unaligned data

Vincent Mailhol (3):
      can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces
      can: etas_es58x: add support for ETAS ES581.4 CAN USB interface
      can: etas_es58x: add support for the ETAS ES58X_FD CAN USB interfaces

Yoshihiro Shimoda (1):
      dt-bindings: net: can: rcar_can: Document r8a77961 support

 .../devicetree/bindings/net/can/rcar_can.txt       |    5 +-
 drivers/net/can/usb/Kconfig                        |   10 +
 drivers/net/can/usb/Makefile                       |    1 +
 drivers/net/can/usb/etas_es58x/Makefile            |    3 +
 drivers/net/can/usb/etas_es58x/es581_4.c           |  507 +++++
 drivers/net/can/usb/etas_es58x/es581_4.h           |  207 ++
 drivers/net/can/usb/etas_es58x/es58x_core.c        | 2301 ++++++++++++++++++++
 drivers/net/can/usb/etas_es58x/es58x_core.h        |  700 ++++++
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |  562 +++++
 drivers/net/can/usb/etas_es58x/es58x_fd.h          |  243 +++
 drivers/net/can/usb/peak_usb/pcan_usb.c            |   59 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   58 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |    7 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |    4 -
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |    6 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h        |   76 +-
 16 files changed, 4622 insertions(+), 127 deletions(-)
 create mode 100644 drivers/net/can/usb/etas_es58x/Makefile
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.h


