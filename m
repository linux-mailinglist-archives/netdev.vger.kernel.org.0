Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E097F64E
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 14:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfHBMAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 08:00:42 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57357 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfHBMAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 08:00:42 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1htWEi-0005tR-Gl; Fri, 02 Aug 2019 14:00:40 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2019-08-02
Date:   Fri,  2 Aug 2019 14:00:34 +0200
Message-Id: <20190802120038.18154-1-mkl@pengutronix.de>
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

this is a pull request of 4 patches for net/master.

The first two patches are by Wang Xiayang, they force that the string buffer
during a dev_info() is properly NULL terminated.

The last two patches are by Tomas Bortoli and fix both a potential info leak of
kernel memory to USB devices.

regards,
Marc

---

The following changes since commit 224c04973db1125fcebefffd86115f99f50f8277:

  net: usb: pegasus: fix improper read if get_registers() fail (2019-08-01 18:18:27 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.3-20190802

for you to fetch changes up to ead16e53c2f0ed946d82d4037c630e2f60f4ab69:

  can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices (2019-08-02 13:58:01 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.3-20190802

----------------------------------------------------------------
Tomas Bortoli (2):
      can: peak_usb: pcan_usb_fd: Fix info-leaks to USB devices
      can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices

Wang Xiayang (2):
      can: sja1000: force the string buffer NULL-terminated
      can: peak_usb: force the string buffer NULL-terminated

 drivers/net/can/sja1000/peak_pcmcia.c        | 2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   | 2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)



