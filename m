Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226C84C4B78
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242748AbiBYQ5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243358AbiBYQ46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:56:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7B31EE9D8
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:56:26 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nNdtI-0004DU-KQ
        for netdev@vger.kernel.org; Fri, 25 Feb 2022 17:56:24 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 972253D879
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 16:56:23 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5CE8D3D86C;
        Fri, 25 Feb 2022 16:56:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c16792c5;
        Fri, 25 Feb 2022 16:56:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/3] pull-request: can 2022-02-25
Date:   Fri, 25 Feb 2022 17:56:19 +0100
Message-Id: <20220225165622.3231809-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 3 patches for net/master.

The first 2 patches are by Vincent Mailhol and fix the error handling
of the ndo_open callbacks of the etas_es58x and the gs_usb CAN USB
drivers.

The last patch is by Lad Prabhakar and fixes a small race condition in
the rcar_canfd's rcar_canfd_channel_probe() function.

regards,
Marc

---

The following changes since commit a6df953f0178c8a11fb2de95327643b622077018:

  Merge branch 'mptcp-fixes-for-5-17' (2022-02-24 21:54:57 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.17-20220225

for you to fetch changes up to c5048a7b2c23ab589f3476a783bd586b663eda5b:

  can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready (2022-02-25 17:46:54 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.17-20220225

----------------------------------------------------------------
Lad Prabhakar (1):
      can: rcar_canfd: rcar_canfd_channel_probe(): register the CAN device when fully ready

Vincent Mailhol (2):
      can: etas_es58x: change opened_channel_cnt's type from atomic_t to u8
      can: gs_usb: change active_channels's type from atomic_t to u8

 drivers/net/can/rcar/rcar_canfd.c           |  6 +++---
 drivers/net/can/usb/etas_es58x/es58x_core.c |  9 +++++----
 drivers/net/can/usb/etas_es58x/es58x_core.h |  8 +++++---
 drivers/net/can/usb/gs_usb.c                | 10 +++++-----
 4 files changed, 18 insertions(+), 15 deletions(-)


