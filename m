Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EBD2D57A6
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgLJJzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgLJJzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:55:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4154C061793
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 01:55:13 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1knIfI-0000t2-HD
        for netdev@vger.kernel.org; Thu, 10 Dec 2020 10:55:12 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 102045AA1A7
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:55:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D34935AA194;
        Thu, 10 Dec 2020 09:55:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3b0c2f46;
        Thu, 10 Dec 2020 09:55:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2020-12-10
Date:   Thu, 10 Dec 2020 10:55:00 +0100
Message-Id: <20201210095507.1551220-1-mkl@pengutronix.de>
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

here's a pull request of 7 patches for net-next/master.

The first patch is by Oliver Hartkopp for the CAN ISOTP, which adds support for
functional addressing.

A patch by Antonio Quartulli removes an unneeded unlikely() annotation from the
rx-offload helper.

The next three patches target the m_can driver. Sean Nyekjaers's patch removes
a double clearing of clock stop request bit, Patrik Flykt's patch moves the
runtime PM enable/disable to m_can_platform and Jarkko Nikula's patch adds a
PCI glue code driver.

Fabio Estevam's patch converts the flexcan driver to DT only.

And Manivannan Sadhasivam's patchd for the mcp251xfd driver adds internal
loopback mode support.

regards,
Marc

---

The following changes since commit a7105e3472bf6bb3099d1293ea7d70e7783aa582:

  Merge branch 'hns3-next' (2020-12-09 20:33:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.11-20201210

for you to fetch changes up to ee42bedc85a6e87791d5c20da6f2d150188cde54:

  can: mcp251xfd: Add support for internal loopback mode (2020-12-10 10:40:10 +0100)

----------------------------------------------------------------
linux-can-next-for-5.11-20201210

----------------------------------------------------------------
Antonio Quartulli (1):
      can: rx-offload: can_rx_offload_offload_one(): avoid double unlikely() notation when using IS_ERR()

Fabio Estevam (1):
      can: flexcan: convert the driver to DT-only

Jarkko Nikula (1):
      can: m_can: add PCI glue driver for Intel Elkhart Lake

Manivannan Sadhasivam (1):
      can: mcp251xfd: Add support for internal loopback mode

Oliver Hartkopp (1):
      can: isotp: add SF_BROADCAST support for functional addressing

Patrik Flykt (1):
      can: m_can: move runtime PM enable/disable to m_can_platform

Sean Nyekjaer (1):
      can: m_can: m_can_config_endisable(): remove double clearing of clock stop request bit

 drivers/net/can/flexcan.c                      |  18 +--
 drivers/net/can/m_can/Kconfig                  |   7 +
 drivers/net/can/m_can/Makefile                 |   1 +
 drivers/net/can/m_can/m_can.c                  |  12 +-
 drivers/net/can/m_can/m_can_pci.c              | 186 +++++++++++++++++++++++++
 drivers/net/can/m_can/m_can_platform.c         |   9 +-
 drivers/net/can/rx-offload.c                   |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |  11 +-
 include/uapi/linux/can/isotp.h                 |   2 +-
 net/can/isotp.c                                |  42 ++++--
 10 files changed, 242 insertions(+), 48 deletions(-)
 create mode 100644 drivers/net/can/m_can/m_can_pci.c


