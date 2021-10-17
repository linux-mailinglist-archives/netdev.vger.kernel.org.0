Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C45E430C1A
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhJQVEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbhJQVEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:04:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84044C061765
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 14:01:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcDHx-0000By-Sy
        for netdev@vger.kernel.org; Sun, 17 Oct 2021 23:01:49 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5CBAF695ECB
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 21:01:46 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5E46F695EAD;
        Sun, 17 Oct 2021 21:01:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c7c6d3fa;
        Sun, 17 Oct 2021 21:01:43 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-10-17
Date:   Sun, 17 Oct 2021 23:01:31 +0200
Message-Id: <20211017210142.2108610-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
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

this is a pull request of 11 patches for net/master.

The first 4 patches are by Ziyang Xuan and Zhang Changzhong and fix 1
use after free and 3 standard conformance problems in the j1939 CAN
stack.

The next 2 patches are by Ziyang Xuan and fix 2 concurrency problems
in the ISOTP CAN stack.

Yoshihiro Shimoda's patch for the rcar_can fix suspend/resume on not
running CAN interfaces.

Aswath Govindraju's patch for the m_can driver fixes access for MMIO
devices.

Zheyu Ma contributes a patch for the peak_pci driver to fix a use
after free.

Stephane Grosjean's 2 patches fix CAN error state handling in the
peak_usb driver.

regards,
Marc

---

The following changes since commit fac3cb82a54a4b7c49c932f96ef196cf5774344c:

  net: bridge: mcast: use multicast_membership_interval for IGMPv3 (2021-10-16 15:05:58 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.15-20211017

for you to fetch changes up to 553715feaa9e0453bc59f6ba20e1c69346888bd5:

  can: peak_usb: pcan_usb_fd_decode_status(): remove unnecessary test on the nullity of a pointer (2021-10-17 22:51:51 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.15-20211017

----------------------------------------------------------------
Aswath Govindraju (1):
      can: m_can: fix iomap_read_fifo() and iomap_write_fifo()

Stephane Grosjean (2):
      can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification
      can: peak_usb: pcan_usb_fd_decode_status(): remove unnecessary test on the nullity of a pointer

Yoshihiro Shimoda (1):
      can: rcar_can: fix suspend/resume

Zhang Changzhong (2):
      can: j1939: j1939_xtp_rx_dat_one(): cancel session if receive TP.DT with error length
      can: j1939: j1939_xtp_rx_rts_session_new(): abort TP less than 9 bytes

Zheyu Ma (1):
      can: peak_pci: peak_pci_remove(): fix UAF

Ziyang Xuan (4):
      can: j1939: j1939_tp_rxtimer(): fix errant alert in j1939_tp_rxtimer
      can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv
      can: isotp: isotp_sendmsg(): add result check for wait_event_interruptible()
      can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()

 drivers/net/can/m_can/m_can_platform.c     | 14 +++++++--
 drivers/net/can/rcar/rcar_can.c            | 20 ++++++++-----
 drivers/net/can/sja1000/peak_pci.c         |  9 +++---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c |  8 ++---
 net/can/isotp.c                            | 48 ++++++++++++++++++++----------
 net/can/j1939/j1939-priv.h                 |  1 +
 net/can/j1939/main.c                       |  7 +++--
 net/can/j1939/transport.c                  | 14 +++++----
 8 files changed, 79 insertions(+), 42 deletions(-)



