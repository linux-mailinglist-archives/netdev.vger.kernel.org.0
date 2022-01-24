Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5607A49876D
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244823AbiAXSAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244797AbiAXSAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:00:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6084DC06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:00:01 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nC3dG-00059h-D3
        for netdev@vger.kernel.org; Mon, 24 Jan 2022 18:59:58 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7DC9E21098
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4120421084;
        Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d1bae3cb;
        Mon, 24 Jan 2022 17:59:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/5] pull-request: can 2022-01-24
Date:   Mon, 24 Jan 2022 18:59:50 +0100
Message-Id: <20220124175955.3464134-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
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

this is a pull request of 5 patches for net/master. All patches are
by me.

The first patch updates the email address of Brian Silverman from his
former employer to his private address.

The next patch fixes DT bindings information for the tcan4x5x SPI CAN
driver.

The following patch targets the m_can driver and fixes the
introduction of FIFO bulk read support.

Another patch for the tcan4x5x driver, which fixes the max register
value for the regmap config.

The last patch for the flexcan driver marks the RX mailbox support for
the MCF5441X as support.

regards,
Marc

---

The following changes since commit c0bf3d8a943b6f2e912b7c1de03e2ef28e76f760:

  net/smc: Transitional solution for clcsock race issue (2022-01-24 12:06:08 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.17-20220124

for you to fetch changes up to f04aefd4659b7959e50e6d0d649936c6940f9d34:

  can: flexcan: mark RX via mailboxes as supported on MCF5441X (2022-01-24 18:27:43 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.17-20220124

----------------------------------------------------------------
Marc Kleine-Budde (5):
      mailmap: update email address of Brian Silverman
      dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config
      can: m_can: m_can_fifo_{read,write}: don't read or write from/to FIFO if length is 0
      can: tcan4x5x: regmap: fix max register value
      can: flexcan: mark RX via mailboxes as supported on MCF5441X

 .mailmap                                               | 1 +
 Documentation/devicetree/bindings/net/can/tcan4x5x.txt | 2 +-
 drivers/net/can/flexcan/flexcan-core.c                 | 1 +
 drivers/net/can/flexcan/flexcan.h                      | 2 +-
 drivers/net/can/m_can/m_can.c                          | 6 ++++++
 drivers/net/can/m_can/tcan4x5x-regmap.c                | 2 +-
 6 files changed, 11 insertions(+), 3 deletions(-)


