Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46974650F5D
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiLSPyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbiLSPxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:53:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C0913E2F
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 07:52:15 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p7IR4-0001vh-1Y
        for netdev@vger.kernel.org; Mon, 19 Dec 2022 16:52:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 15FC514321D
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 15:52:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 09481143209;
        Mon, 19 Dec 2022 15:52:12 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id aee6a442;
        Mon, 19 Dec 2022 15:52:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/3] pull-request: can 2022-12-19
Date:   Mon, 19 Dec 2022 16:52:07 +0100
Message-Id: <20221219155210.1143439-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 3 patches for net/master.

The first patch is by Vincent Mailhol and adds the etas_es58x devlink
documentation to the index.

Haibo Chen's patch for the flexcan driver fixes a unbalanced
pm_runtime_enable warning.

The last patch is by me, targets the kvaser_usb driver and fixes an
error occurring with gcc-13.

regards,
Marc

---

The following changes since commit 2856a62762c8409e360d4fd452194c8e57ba1058:

  mctp: serial: Fix starting value for frame check sequence (2022-12-19 12:38:45 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.2-20221219

for you to fetch changes up to f006229135b7debf4037adb1eb93e358559593db:

  can: kvaser_usb: hydra: help gcc-13 to figure out cmd_len (2022-12-19 16:08:27 +0100)

----------------------------------------------------------------
linux-can-fixes-for-6.2-20221219

----------------------------------------------------------------
Haibo Chen (1):
      can: flexcan: avoid unbalanced pm_runtime_enable warning

Marc Kleine-Budde (1):
      can: kvaser_usb: hydra: help gcc-13 to figure out cmd_len

Vincent Mailhol (1):
      Documentation: devlink: add missing toc entry for etas_es58x devlink doc

 Documentation/networking/devlink/index.rst        |  1 +
 drivers/net/can/flexcan/flexcan-core.c            | 12 ++++++---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 33 ++++++++++++++++-------
 3 files changed, 34 insertions(+), 12 deletions(-)


