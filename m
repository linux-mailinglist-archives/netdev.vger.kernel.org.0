Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941672753B4
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgIWIyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIWIyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14826C061755
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:24 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xe-0000uS-Di; Wed, 23 Sep 2020 10:54:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com
Subject: pull-request: can-next 2020-09-23
Date:   Wed, 23 Sep 2020 10:53:58 +0200
Message-Id: <20200923085418.2685858-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

this is a pull request of 20 patches for net-next.

The complete series target the flexcan driver and is created by Joakim Zhang
and me.

The first six patches are cleanup (sort include files alphabetically, remove
stray empty line, get rid of long lines) and adding more registers and
documentation (registers and wakeup interrupt).

Then in two patches the transceiver regulator is made optional, and a check for
maximum transceiver bitrate is added.

Then the ECC support for HW thats supports this is added.

The next three patches improve suspend and low power mode handling.

Followed by six patches that add CAN-FD support and CAN-FD related features.

The last two patches add support for the flexcan IP core on the imx8qm and
lx2160ar1.

regards,
Marc
---

The following changes since commit 92ec804f3dbf0d986f8e10850bfff14f316d7aaf:

  net: phy: bcm7xxx: Add an entry for BCM72113 (2020-09-21 17:16:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.10-20200923

for you to fetch changes up to 2c19bb43e5572929f00f186d43e99bfd6d7ee3b2:

  can: flexcan: add lx2160ar1 support (2020-09-22 16:55:34 +0200)

----------------------------------------------------------------
linux-can-next-for-5.10-20200923

----------------------------------------------------------------
Joakim Zhang (13):
      can: flexcan: Ack wakeup interrupt separately
      can: flexcan: Add check for transceiver maximum bitrate limitation
      can: flexcan: add correctable errors correction when HW supports ECC
      can: flexcan: flexcan_chip_stop(): add error handling and propagate error value
      can: flexcan: disable clocks during stop mode
      can: flexcan: add LPSR mode support
      can: flexcan: use struct canfd_frame for CAN classic frame
      can: flexcan: add CAN-FD mode support
      can: flexcan: add ISO CAN FD feature support
      can: flexcan: add CAN FD BRS support
      can: flexcan: add Transceiver Delay Compensation support
      can: flexcan: add imx8qm support
      can: flexcan: add lx2160ar1 support

Marc Kleine-Budde (7):
      can: flexcan: sort include files alphabetically
      can: flexcan: flexcan_exit_stop_mode(): remove stray empty line
      can: flexcan: more register names
      can: flexcan: struct flexcan_regs: document registers not affected by soft reset
      can: flexcan: quirks: get rid of long lines
      can: flexcan: flexcan_probe(): make regulator xceiver optional
      can: flexcan: flexcan_set_bittiming(): move setup of CAN-2.0 bitiming into separate function

 drivers/net/can/flexcan.c | 533 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 443 insertions(+), 90 deletions(-)


