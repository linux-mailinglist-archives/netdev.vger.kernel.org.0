Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C8B2C8468
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 13:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgK3Mxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 07:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgK3Mxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 07:53:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22681C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 04:53:14 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjig4-00040Z-PG
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 13:53:12 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3D18859F8F4
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:53:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 612AB59F8E6;
        Mon, 30 Nov 2020 12:53:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 59e203ba;
        Mon, 30 Nov 2020 12:53:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-11-30
Date:   Mon, 30 Nov 2020 13:53:02 +0100
Message-Id: <20201130125307.218258-1-mkl@pengutronix.de>
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

here's a pull request of 5 patches for net/master.

The first patch is by me an target the tcan4x5x bindings for the m_can driver.
It fixes the error path in the tcan4x5x_can_probe() function.

The next two patches are by Jeroen Hofstee and makes the lost of arbitration
error counters of sja1000 and the sun4i drivers consistent with the other
drivers.

Zhang Qilong contributes two patch that clean up the error path in the c_can
and kvaser_pciefd drivers.

regards,
Marc

---

The following changes since commit 4d521943f76bd0d1e68ea5e02df7aadd30b2838a:

  dt-bindings: net: correct interrupt flags in examples (2020-11-28 14:47:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.10-20201130

for you to fetch changes up to 13a84cf37a4cf1155a41684236c2314eb40cd65c:

  can: kvaser_pciefd: kvaser_pciefd_open(): fix error handling (2020-11-30 12:43:55 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.10-20201130

----------------------------------------------------------------
Jeroen Hofstee (2):
      can: sja1000: sja1000_err(): don't count arbitration lose as an error
      can: sun4i_can: sun4i_can_err(): don't count arbitration lose as an error

Marc Kleine-Budde (1):
      can: m_can: tcan4x5x_can_probe(): fix error path: remove erroneous clk_disable_unprepare()

Zhang Qilong (2):
      can: c_can: c_can_power_up(): fix error handling
      can: kvaser_pciefd: kvaser_pciefd_open(): fix error handling

 drivers/net/can/c_can/c_can.c     | 18 ++++++++++++++----
 drivers/net/can/kvaser_pciefd.c   |  4 +++-
 drivers/net/can/m_can/tcan4x5x.c  | 11 +++--------
 drivers/net/can/sja1000/sja1000.c |  1 -
 drivers/net/can/sun4i_can.c       |  1 -
 5 files changed, 20 insertions(+), 15 deletions(-)


