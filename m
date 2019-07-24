Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B23572F65
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfGXND0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:03:26 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43819 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfGXND0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 09:03:26 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1hqGvU-0006gK-PE; Wed, 24 Jul 2019 15:03:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2019-07-24
Date:   Wed, 24 Jul 2019 15:03:15 +0200
Message-Id: <20190724130322.31702-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.20.1
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

this is a pull reqeust of 7 patches for net/master.

The first patch is by Rasmus Villemoes add a missing netif_carrier_off() to
register_candev() so that generic netdev trigger based LEDs are initially off.

Nikita Yushchenko's patch for the rcar_canfd driver fixes a possible IRQ storm
on high load.

The patch by Weitao Hou for the mcp251x driver add missing error checking to
the work queue allocation.

Both Wen Yang's and Joakim Zhang's patch for the flexcan driver fix a problem
with the stop-mode.

Stephane Grosjean contributes a patch for the peak_usb driver to fix a
potential double kfree_skb().

The last patch is by YueHaibing and fixes the error path in can-gw's
cgw_module_init() function.

regards,
Marc

---

The following changes since commit d86afb89305de205b0d2f20c2160adf039e9508d:

  net: thunderx: Use fwnode_get_mac_address() (2019-07-23 14:09:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.3-20190724

for you to fetch changes up to b7a14297f102b6e2ce6f16feffebbb9bde1e9b55:

  can: gw: Fix error path of cgw_module_init (2019-07-24 11:19:03 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.3-20190724

----------------------------------------------------------------
Joakim Zhang (1):
      can: flexcan: fix stop mode acknowledgment

Nikita Yushchenko (1):
      can: rcar_canfd: fix possible IRQ storm on high load

Rasmus Villemoes (1):
      can: dev: call netif_carrier_off() in register_candev()

Stephane Grosjean (1):
      can: peak_usb: fix potential double kfree_skb()

Weitao Hou (1):
      can: mcp251x: add error check when wq alloc failed

Wen Yang (1):
      can: flexcan: fix an use-after-free in flexcan_setup_stop_mode()

YueHaibing (1):
      can: gw: Fix error path of cgw_module_init

 drivers/net/can/dev.c                        |  2 ++
 drivers/net/can/flexcan.c                    | 39 ++++++++++++++++++----
 drivers/net/can/rcar/rcar_canfd.c            |  9 ++---
 drivers/net/can/spi/mcp251x.c                | 49 +++++++++++++---------------
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |  8 ++---
 net/can/gw.c                                 | 48 ++++++++++++++++++---------
 6 files changed, 98 insertions(+), 57 deletions(-)


