Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE8857B309
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbiGTIg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiGTIg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:36:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7A250045
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:36:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE5Bw-0005lx-UX
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:36:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 54982B5B81
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:36:24 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EE03EB5B7B;
        Wed, 20 Jul 2022 08:36:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id beddd37d;
        Wed, 20 Jul 2022 08:36:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/2] pull-request: can 2022-07-20
Date:   Wed, 20 Jul 2022 10:36:19 +0200
Message-Id: <20220720083621.3294548-1-mkl@pengutronix.de>
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

The first patch is by me and fixes the detection of the mcp251863 in
the mcp251xfd driver.

The last patch is by Liang He and adds a missing of_node_put() in the
rcar_canfd driver.

regards,
Marc

---

The following changes since commit 48ea8ea32dbf3231882e9bc0b297fe1400785219:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2022-07-19 17:43:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.19-20220720

for you to fetch changes up to 7b66dfcc6e1e1f018492619c3d0fc432b6b54272:

  can: rcar_canfd: Add missing of_node_put() in rcar_canfd_probe() (2022-07-20 10:20:19 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.19-20220720

----------------------------------------------------------------
Liang He (1):
      can: rcar_canfd: Add missing of_node_put() in rcar_canfd_probe()

Marc Kleine-Budde (1):
      can: mcp251xfd: fix detection of mcp251863

 drivers/net/can/rcar/rcar_canfd.c              |  1 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)


