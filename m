Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CD95FADB3
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 09:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJKHsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 03:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJKHsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 03:48:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DA1876A3
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 00:48:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oi9zw-0007d3-JS
        for netdev@vger.kernel.org; Tue, 11 Oct 2022 09:48:20 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 01F69F9C95
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 07:48:19 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9DB50F9C8C;
        Tue, 11 Oct 2022 07:48:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 69173efa;
        Tue, 11 Oct 2022 07:48:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/4] pull-request: can 2022-10-11
Date:   Tue, 11 Oct 2022 09:48:11 +0200
Message-Id: <20221011074815.397301-1-mkl@pengutronix.de>
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

this is a pull request of 4 patches for net/main.

Anssi Hannula and Jimmy Assarsson contribute 4 patches for the
kvaser_usb driver. A check for actual received length of USB transfers
is added, the use of an uninitialized completion is fixed, the TX
queue is re-synced after restart, and the CAN state is fixed after
restart.

regards,
Marc

---

The following changes since commit b15e2e49bfc4965d86b9bc4a8426d53ec90a7192:

  nfp: flower: fix incorrect struct type in GRE key_size (2022-10-10 18:00:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.1-20221011

for you to fetch changes up to 8183602b8cbc4d865068c6c5705228760d30b003:

  Merge patch series "can: kvaser_usb: Various fixes" (2022-10-11 08:51:22 +0200)

----------------------------------------------------------------
linux-can-fixes-for-6.1-20221011

----------------------------------------------------------------
Anssi Hannula (4):
      can: kvaser_usb_leaf: Fix overread with an invalid command
      can: kvaser_usb: Fix use of uninitialized completion
      can: kvaser_usb_leaf: Fix TX queue out of sync after restart
      can: kvaser_usb_leaf: Fix CAN state after restart

Marc Kleine-Budde (1):
      Merge patch series "can: kvaser_usb: Various fixes"

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h       |  2 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  |  3 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |  2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 79 +++++++++++++++++++++++
 4 files changed, 84 insertions(+), 2 deletions(-)


