Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECD23DFF49
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbhHDKSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbhHDKSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 06:18:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044BBC061798
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 03:18:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBDyI-00047J-G3
        for netdev@vger.kernel.org; Wed, 04 Aug 2021 12:17:58 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 501C2660795
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 10:17:57 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 69BB366078F;
        Wed,  4 Aug 2021 10:17:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ef98d73c;
        Wed, 4 Aug 2021 10:17:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-08-04
Date:   Wed,  4 Aug 2021 12:17:48 +0200
Message-Id: <20210804101753.23826-1-mkl@pengutronix.de>
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

this is a pull request of 5 patches for net-next/master.

The first patch is by me and fixes a typo in a comment in the CAN
J1939 protocol.

The next 2 patches are by Oleksij Rempel and update the CAN J1939
protocol to send RX status updates via the error queue mechanism.

The next patch is by me and adds a missing variable initialization to
the flexcan driver (the problem was introduced in the current net-next
cycle).

The last patch is by Aswath Govindraju and adds power-domains to the
Bosch m_can DT binding documentation.

regards,
Marc

---

The following changes since commit 7cdd0a89ec70ce6a720171f1f7817ee9502b134c:

  net/mlx4: make the array states static const, makes object smaller (2021-08-02 15:02:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.15-20210804

for you to fetch changes up to d85165b2381ce2638cfb8c8787a61b97b38251c2:

  dt-bindings: net: can: Document power-domains property (2021-08-04 12:11:57 +0200)

----------------------------------------------------------------
linux-can-next-for-5.15-20210804

----------------------------------------------------------------
Aswath Govindraju (1):
      dt-bindings: net: can: Document power-domains property

Marc Kleine-Budde (2):
      can: j1939: j1939_session_tx_dat(): fix typo
      can: flexcan: flexcan_clks_enable(): add missing variable initialization

Oleksij Rempel (2):
      can: j1939: rename J1939_ERRQUEUE_* to J1939_ERRQUEUE_TX_*
      can: j1939: extend UAPI to notify about RX status

 .../devicetree/bindings/net/can/bosch,m_can.yaml   |   6 +
 drivers/net/can/flexcan.c                          |   2 +-
 include/uapi/linux/can/j1939.h                     |   9 ++
 net/can/j1939/j1939-priv.h                         |  10 +-
 net/can/j1939/socket.c                             | 141 ++++++++++++++++-----
 net/can/j1939/transport.c                          |  28 +++-
 6 files changed, 152 insertions(+), 44 deletions(-)


