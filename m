Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF4752629C
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 15:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380582AbiEMNI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 09:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354913AbiEMNIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 09:08:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF092AC64
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 06:08:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npV1q-00025p-O6
        for netdev@vger.kernel.org; Fri, 13 May 2022 15:08:22 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 309A17DA40
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 13:08:22 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C025A7DA3A;
        Fri, 13 May 2022 13:08:21 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a96644ba;
        Fri, 13 May 2022 13:08:21 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/2] pull-request: can 2022-05-13
Date:   Fri, 13 May 2022 15:08:17 +0200
Message-Id: <20220513130819.386012-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
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

this is a pull request of 2 patches for net/master.

Both patches are by Jarkko Nikula, target the m_can PCI driver
bindings, and fix usage of wrong bit timing constants for the Elkhart
Lake platform.

regards,
Marc

---

The following changes since commit f3f19f939c11925dadd3f4776f99f8c278a7017b:

  Merge tag 'net-5.18-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-05-12 11:51:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.18-20220513

for you to fetch changes up to 3ddd9ed84d8954afcdf7afacf8e142198c3803c3:

  can: m_can: remove support for custom bit timing, take #2 (2022-05-13 14:41:40 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.18-20220513

----------------------------------------------------------------
Jarkko Nikula (2):
      Revert "can: m_can: pci: use custom bit timings for Elkhart Lake"
      can: m_can: remove support for custom bit timing, take #2

 drivers/net/can/m_can/m_can.c     | 24 +++++---------------
 drivers/net/can/m_can/m_can.h     |  3 ---
 drivers/net/can/m_can/m_can_pci.c | 48 ++++-----------------------------------
 3 files changed, 10 insertions(+), 65 deletions(-)


