Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DEF637FDB
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 20:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiKXT5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 14:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiKXT5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 14:57:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0CD91513
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 11:57:14 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyILQ-0004c6-OZ
        for netdev@vger.kernel.org; Thu, 24 Nov 2022 20:57:12 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1C62812895F
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 19:57:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E8C87128942;
        Thu, 24 Nov 2022 19:57:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f4d7d466;
        Thu, 24 Nov 2022 19:57:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/8] pull-request: can 2022-11-24
Date:   Thu, 24 Nov 2022 20:57:00 +0100
Message-Id: <20221124195708.1473369-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 8 patches for net/master.

Ziyang Xuan contributes a patch for the can327, fixing a potential SKB
leak when the netdev is down.

Heiko Schocher's patch for the sja1000 driver fixes the width of the
definition of the OCR_MODE_MASK.

Zhang Changzhong contributes 4 patches. In the sja1000_isa, cc770, and
m_can_pci drivers the error path in the probe() function and in case
of the etas_es58x a function that is called by probe() are fixed.

Jiasheng Jiang add a missing check for the return value of the
devm_clk_get() in the m_can driver.

Yasushi SHOJI's patch for the mcba_usb fixes setting of the external
termination resistor.

regards,
Marc

---

The following changes since commit ad17c2a3f11b0f6b122e7842d8f7d9a5fcc7ac63:

  octeontx2-af: Fix reference count issue in rvu_sdp_init() (2022-11-24 10:01:42 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.1-20221124

for you to fetch changes up to 1a8e3bd25f1e789c8154e11ea24dc3ec5a4c1da0:

  can: mcba_usb: Fix termination command argument (2022-11-24 16:26:48 +0100)

----------------------------------------------------------------
linux-can-fixes-for-6.1-20221124

----------------------------------------------------------------
Heiko Schocher (1):
      can: sja1000: fix size of OCR_MODE_MASK define

Jiasheng Jiang (1):
      can: m_can: Add check for devm_clk_get

Yasushi SHOJI (1):
      can: mcba_usb: Fix termination command argument

Zhang Changzhong (4):
      can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()
      can: cc770: cc770_isa_probe(): add missing free_cc770dev()
      can: etas_es58x: es58x_init_netdev(): free netdev when register_candev()
      can: m_can: pci: add missing m_can_class_free_dev() in probe/remove methods

Ziyang Xuan (1):
      can: can327: can327_feed_frame_to_netdev(): fix potential skb leak when netdev is down

 drivers/net/can/can327.c                    |  4 +++-
 drivers/net/can/cc770/cc770_isa.c           | 10 ++++++----
 drivers/net/can/m_can/m_can.c               |  2 +-
 drivers/net/can/m_can/m_can_pci.c           |  9 ++++++---
 drivers/net/can/sja1000/sja1000_isa.c       | 10 ++++++----
 drivers/net/can/usb/etas_es58x/es58x_core.c |  5 ++++-
 drivers/net/can/usb/mcba_usb.c              | 10 +++++++---
 include/linux/can/platform/sja1000.h        |  2 +-
 8 files changed, 34 insertions(+), 18 deletions(-)


