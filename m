Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEA460DC95
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbiJZHzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiJZHz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:55:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B633CBDA
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:55:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onbG0-0000ZW-W7
        for netdev@vger.kernel.org; Wed, 26 Oct 2022 09:55:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7832F109FE3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:55:24 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 225EE109FD7;
        Wed, 26 Oct 2022 07:55:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5551b5ff;
        Wed, 26 Oct 2022 07:55:21 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/n] pull-request: can 2022-10-25
Date:   Wed, 26 Oct 2022 09:55:18 +0200
Message-Id: <20221026075520.1502520-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 2 patches for net/master.

Both patches are by Dongliang Mu.

The 1st patch adds a missing cleanup call in the error path of the
probe function in mpc5xxx glue code for the mscan driver.

The 2nd patch adds a missing cleanup call in the error path of the
probe function of the mcp251x driver.

regards,
Marc

---

The following changes since commit baee5a14ab2c9a8f8df09d021885c8f5de458a38:

  Merge tag 'ieee802154-for-net-2022-10-24' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan (2022-10-24 21:17:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.1-20221025

for you to fetch changes up to b1a09b63684cea56774786ca14c13b7041ffee63:

  can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in error path (2022-10-25 09:13:14 +0200)

----------------------------------------------------------------
linux-can-fixes-for-6.1-20221025

----------------------------------------------------------------
Dongliang Mu (2):
      can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path
      can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in error path

 drivers/net/can/mscan/mpc5xxx_can.c | 8 +++++---
 drivers/net/can/spi/mcp251x.c       | 5 ++++-
 2 files changed, 9 insertions(+), 4 deletions(-)


