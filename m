Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B680210FBEF
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfLCKrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:47:07 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55033 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCKrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:47:07 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ic5hx-0001BG-Em; Tue, 03 Dec 2019 11:47:05 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2019-12-03
Date:   Tue,  3 Dec 2019 11:46:57 +0100
Message-Id: <20191203104703.14620-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

this is a pull request of 6 patches for net/master.

The first two patches are against the MAINTAINERS file and adds Appana
Durga Kedareswara rao as maintainer for the xilinx-can driver and Sriram
Dash for the m_can (mmio) driver.

The next patch is by Jouni Hogander and fixes a use-after-free in the
slcan driver.

Johan Hovold's patch for the ucan driver fixes the non-atomic allocation
in the completion handler.

The last two patches target the xilinx-can driver. The first one is by
Venkatesh Yadav Abbarapu and skips the error message on deferred probe,
the second one is by Srinivas Neeli and fixes the usage of the skb after
can_put_echo_skb().

regards,
Marc

---

The following changes since commit 040b5cfbcefa263ccf2c118c4938308606bb7ed8:

  Fixed updating of ethertype in function skb_mpls_pop (2019-12-02 13:03:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.5-20191203

for you to fetch changes up to 3d3c817c3a409ba51ad6e44dd8fde4cfc07c93fe:

  can: xilinx_can: Fix usage of skb memory (2019-12-03 11:15:08 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.5-20191203

----------------------------------------------------------------
Appana Durga Kedareswara rao (1):
      MAINTAINERS: add fragment for xilinx CAN driver

Johan Hovold (1):
      can: ucan: fix non-atomic allocation in completion handler

Jouni Hogander (1):
      can: slcan: Fix use-after-free Read in slcan_open

Srinivas Neeli (1):
      can: xilinx_can: Fix usage of skb memory

Sriram Dash (1):
      MAINTAINERS: add myself as maintainer of MCAN MMIO device driver

Venkatesh Yadav Abbarapu (1):
      can: xilinx_can: skip error message on deferred probe

 MAINTAINERS                  | 17 +++++++++++++++++
 drivers/net/can/slcan.c      |  1 +
 drivers/net/can/usb/ucan.c   |  2 +-
 drivers/net/can/xilinx_can.c | 28 +++++++++++++++-------------
 4 files changed, 34 insertions(+), 14 deletions(-)


