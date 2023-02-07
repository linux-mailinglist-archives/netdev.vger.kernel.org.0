Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B482068DA13
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjBGOFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbjBGOFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:05:21 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3692244B6
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:05:20 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pPOb0-00081c-MF
        for netdev@vger.kernel.org; Tue, 07 Feb 2023 15:05:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 25E90172764
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 14:05:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1779817275A;
        Tue,  7 Feb 2023 14:05:17 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c3b613f4;
        Tue, 7 Feb 2023 14:05:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/1] pull-request: can 2023-02-07
Date:   Tue,  7 Feb 2023 15:05:13 +0100
Message-Id: <20230207140514.2885065-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
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

this is a pull request of 1 patch for net/master.

The patch is from Devid Antonio Filoni and fixes an address claiming
problem in the J1939 CAN protocol.

regards,
Marc

---
The following changes since commit 811d581194f7412eda97acc03d17fc77824b561f:

  net: USB: Fix wrong-direction WARNING in plusb.c (2023-02-06 09:59:35 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.2-20230207

for you to fetch changes up to 4ae5e1e97c44f4654516c1d41591a462ed62fa7b:

  can: j1939: do not wait 250 ms if the same addr was already claimed (2023-02-07 15:00:22 +0100)

----------------------------------------------------------------
linux-can-fixes-for-6.2-20230207

----------------------------------------------------------------
Devid Antonio Filoni (1):
      can: j1939: do not wait 250 ms if the same addr was already claimed

 net/can/j1939/address-claim.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


