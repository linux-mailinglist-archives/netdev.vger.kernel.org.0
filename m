Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D0F3977B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbfFGVPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:15:48 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53269 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730373AbfFGVPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:15:47 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <mkl@pengutronix.de>)
        id 1hZMDB-00006I-FX; Fri, 07 Jun 2019 23:15:45 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2019-06-07
Date:   Fri,  7 Jun 2019 23:15:32 +0200
Message-Id: <20190607211541.16095-1-mkl@pengutronix.de>
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

this is a pull reqeust of 9 patches for net/master.

The first patch is by Alexander Dahl and removes a duplicate menu entry from
the Kconfig. The next patch by Joakim Zhang fixes the timeout in the flexcan
driver when setting small bit rates. Anssi Hannula's patch for the xilinx_can
driver fixes the bittiming_const for CAN FD core. The two patches by Sean
Nyekjaer bring mcp25625 to the existing mcp251x driver. The patch by Eugen
Hristev implements an errata for the m_can driver. YueHaibing's patch fixes the
error handling ing can_init(). The patch by Fabio Estevam for the flexcan
driver removes an unneeded registration message during flexcan_probe(). And the
last patch is by Willem de Bruijn and adds the missing purging the  socket
error queue on sock destruct.

regards,
Marc

---

The following changes since commit c7e3c93abbc1382923c7f4fe5ba9ea6aa0fa8d0e:

  Merge tag 'wireless-drivers-for-davem-2019-06-07' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers (2019-06-07 12:16:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.2-20190607

for you to fetch changes up to fd704bd5ee749d560e86c4f1fd2ef486d8abf7cf:

  can: purge socket error queue on sock destruct (2019-06-07 23:03:54 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.2-20190607

----------------------------------------------------------------
Alexander Dahl (1):
      can: usb: Kconfig: Remove duplicate menu entry

Anssi Hannula (1):
      can: xilinx_can: use correct bittiming_const for CAN FD core

Eugen Hristev (1):
      can: m_can: implement errata "Needless activation of MRAF irq"

Fabio Estevam (1):
      can: flexcan: Remove unneeded registration message

Joakim Zhang (1):
      can: flexcan: fix timeout when set small bitrate

Sean Nyekjaer (2):
      dt-bindings: can: mcp251x: add mcp25625 support
      can: mcp251x: add support for mcp25625

Willem de Bruijn (1):
      can: purge socket error queue on sock destruct

YueHaibing (1):
      can: af_can: Fix error path of can_init()

 .../bindings/net/can/microchip,mcp251x.txt         |  1 +
 drivers/net/can/flexcan.c                          |  5 +----
 drivers/net/can/m_can/m_can.c                      | 21 ++++++++++++++++++
 drivers/net/can/spi/Kconfig                        |  5 +++--
 drivers/net/can/spi/mcp251x.c                      | 25 ++++++++++++++--------
 drivers/net/can/usb/Kconfig                        |  6 ------
 drivers/net/can/xilinx_can.c                       |  2 +-
 net/can/af_can.c                                   | 25 +++++++++++++++++++---
 8 files changed, 65 insertions(+), 25 deletions(-)



