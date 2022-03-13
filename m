Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1EA4D73C9
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 09:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbiCMIww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 04:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiCMIwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 04:52:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1223B635B
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 00:51:42 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nTJwy-0000Pn-Cd
        for netdev@vger.kernel.org; Sun, 13 Mar 2022 09:51:40 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3218C49B24
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:51:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id F059149B1C;
        Sun, 13 Mar 2022 08:51:38 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8667d1ad;
        Sun, 13 Mar 2022 08:51:38 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/13] pull-request: can-next 2022-03-13
Date:   Sun, 13 Mar 2022 09:51:25 +0100
Message-Id: <20220313085138.507062-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 13 patches for net-next/master.

The 1st patch is by me and fixes the freeing of a skb in the vxcan
driver (initially added in this net-next window).

The remaining 12 patches are also by me and target the mcp251xfd
driver. The first patch fixes a printf modifier (initially added in
this net-next window). The remaining patches add ethtool based ring
and RX/TX IRQ coalescing support to the driver.

regards,
Marc

---

The following changes since commit 97aeb877de7f14f819fc2cf8388d7a2d8090489d:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2022-03-12 11:54:29 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.18-20220313

for you to fetch changes up to aa66ae9b241eadd5d31077f869f298444c98a85f:

  can: mcp251xfd: ring: increase number of RX-FIFOs to 3 and increase max TX-FIFO depth to 16 (2022-03-13 09:45:36 +0100)

----------------------------------------------------------------
linux-can-next-for-5.18-20220313

----------------------------------------------------------------
Marc Kleine-Budde (13):
      can: vxcan: vxcan_xmit(): use kfree_skb() instead of kfree() to free skb
      can: mcp251xfd: mcp251xfd_ring_init(): use %d to print free RAM
      can: mcp251xfd: ram: add helper function for runtime ring size calculation
      can: mcp251xfd: ram: coalescing support
      can: mcp251xfd: ethtool: add support
      can: mcp251xfd: ring: prepare support for runtime configurable RX/TX ring parameters
      can: mcp251xfd: update macros describing ring, FIFO and RAM layout
      can: mcp251xfd: ring: add support for runtime configurable RX/TX ring parameters
      can: mcp251xfd: add RX IRQ coalescing support
      can: mcp251xfd: add RX IRQ coalescing ethtool support
      can: mcp251xfd: add TX IRQ coalescing support
      can: mcp251xfd: add TX IRQ coalescing ethtool support
      can: mcp251xfd: ring: increase number of RX-FIFOs to 3 and increase max TX-FIFO depth to 16

 drivers/net/can/spi/mcp251xfd/Makefile            |   2 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c    |   7 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c | 143 +++++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c     | 153 ++++++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h     |  62 ++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c    | 244 ++++++++++++++++++----
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c      |  12 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c     |   6 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h         |  71 +++++--
 drivers/net/can/vxcan.c                           |   2 +-
 10 files changed, 644 insertions(+), 58 deletions(-)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h


