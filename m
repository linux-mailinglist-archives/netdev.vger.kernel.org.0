Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCA52B816B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgKRQET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgKRQET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:04:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4573DC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:04:19 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kfPwP-0001km-Or; Wed, 18 Nov 2020 17:04:17 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-11-18
Date:   Wed, 18 Nov 2020 17:04:10 +0100
Message-Id: <20201118160414.2731659-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
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

here's a pull request for net/master consisting of 4 patches for net/master,

Jimmy Assarsson provides two patches for the kvaser_pciefd and kvaser_usb
drivers, where the can_bittiming_const are fixed.

The next patch is by me and fixes an erroneous flexcan_transceiver_enable()
during bus-off recovery in the flexcan driver.

Jarkko Nikula's patch for the m_can driver fixes the IRQ handler to only
process the interrupts if the device is not suspended.

regards,
Marc

P.S.: Can you merge net/master into net-next/master after merging this pull
request?

---

The following changes since commit c09c8a27b9baa417864b9adc3228b10ae5eeec93:

  ipv4: use IS_ENABLED instead of ifdef (2020-11-17 17:02:03 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.10-20201118

for you to fetch changes up to a1f634463aaf2c94dfa13001dbdea011303124cc:

  can: m_can: process interrupt only when not runtime suspended (2020-11-18 16:37:32 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.10-20201118

----------------------------------------------------------------
Jarkko Nikula (1):
      can: m_can: process interrupt only when not runtime suspended

Jimmy Assarsson (2):
      can: kvaser_pciefd: Fix KCAN bittiming limits
      can: kvaser_usb: kvaser_usb_hydra: Fix KCAN bittiming limits

Marc Kleine-Budde (1):
      can: flexcan: flexcan_chip_start(): fix erroneous flexcan_transceiver_enable() during bus-off recovery

 drivers/net/can/flexcan.c                         | 18 +++++++++---------
 drivers/net/can/kvaser_pciefd.c                   |  4 ++--
 drivers/net/can/m_can/m_can.c                     |  2 ++
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |  2 +-
 4 files changed, 14 insertions(+), 12 deletions(-)


