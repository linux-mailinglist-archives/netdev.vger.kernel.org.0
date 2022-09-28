Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0423C5ED86A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiI1JGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbiI1JGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:06:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F25E0C4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:06:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1odT1U-00074f-FY
        for netdev@vger.kernel.org; Wed, 28 Sep 2022 11:06:32 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D2FD0EF6A0
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:06:31 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8751DEF697;
        Wed, 28 Sep 2022 09:06:30 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d894233b;
        Wed, 28 Sep 2022 09:06:29 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/1] pull-request: can 2022-09-28
Date:   Wed, 28 Sep 2022 11:06:28 +0200
Message-Id: <20220928090629.1124190-1-mkl@pengutronix.de>
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

this is a pull request of 1 patch for net/main.

The patch is by me and targets the c_can driver. It disables an
optimization in the TX path of C_CAN cores which causes problems.

regards,
Marc

---

The following changes since commit 44d70bb561dac9363f45787aa93dfca36877ee01:

  Merge tag 'wireless-2022-09-27' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2022-09-27 16:52:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.0-20220928

for you to fetch changes up to 81d192c2ce74157e717e1fc4b68791f82f7499d4:

  can: c_can: don't cache TX messages for C_CAN cores (2022-09-28 10:34:04 +0200)

----------------------------------------------------------------
linux-can-fixes-for-6.0-20220928

----------------------------------------------------------------
Marc Kleine-Budde (1):
      can: c_can: don't cache TX messages for C_CAN cores

 drivers/net/can/c_can/c_can.h      | 17 +++++++++++++++--
 drivers/net/can/c_can/c_can_main.c | 11 +++++------
 2 files changed, 20 insertions(+), 8 deletions(-)


