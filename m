Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551D43550FC
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237740AbhDFKgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbhDFKgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 06:36:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FCBC061756
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 03:36:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lTj46-0003p2-29
        for netdev@vger.kernel.org; Tue, 06 Apr 2021 12:36:10 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4375560864B
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 10:36:08 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9DECE608641;
        Tue,  6 Apr 2021 10:36:07 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 721e6f1f;
        Tue, 6 Apr 2021 10:36:07 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-04-06
Date:   Tue,  6 Apr 2021 12:36:05 +0200
Message-Id: <20210406103606.1847506-1-mkl@pengutronix.de>
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

this is a pull request of 1 patch for net/master.

The patch is by me and fixes the SPI half duplex support in the
mcp251x CAN driver.

regards,
Marc

---

The following changes since commit 08c27f3322fec11950b8f1384aa0f3b11d028528:

  batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field (2021-04-05 15:06:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.12-20210406

for you to fetch changes up to 617085fca6375e2c1667d1fbfc6adc4034c85f04:

  can: mcp251x: fix support for half duplex SPI host controllers (2021-04-06 12:31:21 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.12-20210406

----------------------------------------------------------------
Marc Kleine-Budde (1):
      can: mcp251x: fix support for half duplex SPI host controllers

 drivers/net/can/spi/mcp251x.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)


