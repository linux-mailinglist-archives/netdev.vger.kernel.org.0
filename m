Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF195BE1FD
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiITJ30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiITJ3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:29:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427286CD3B
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:29:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oaZZB-0005WY-2t
        for netdev@vger.kernel.org; Tue, 20 Sep 2022 11:29:21 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 86D65E72BA
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 09:29:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 66090E7297;
        Tue, 20 Sep 2022 09:29:17 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5eb76275;
        Tue, 20 Sep 2022 09:29:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/17] pull-request: can 2022-09-20
Date:   Tue, 20 Sep 2022 11:28:58 +0200
Message-Id: <20220920092915.921613-1-mkl@pengutronix.de>
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

this is a pull request of 17 patches for net/master.

The 1st patch is by me, targets the flexcan driver and fixes a
potential system hang on single core systems under high CAN packet
rate.

The next patch is also by me and fixes the return value in the gs_usb
driver if the ethtool identify feature is not supported.

The next 15 patches are by Anssi Hannula and Jimmy Assarsson and fix
various problem in the kvaser_usb CAN driver.

regards,
Marc

---

The following changes since commit 8ccac4edc8da764389d4fc18b1df740892006557:

  gve: Fix GFP flags when allocing pages (2022-09-19 18:31:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.0-20220920

for you to fetch changes up to 5f93b3d804a2840053d44cb4bac6d376575acb69:

  Merge patch series "can: kvaser_usb: Various fixes" (2022-09-20 11:17:40 +0200)

----------------------------------------------------------------
linux-can-fixes-for-6.0-20220920

----------------------------------------------------------------
Anssi Hannula (10):
      can: kvaser_usb_leaf: Fix overread with an invalid command
      can: kvaser_usb: Fix use of uninitialized completion
      can: kvaser_usb: Fix possible completions during init_completion
      can: kvaser_usb_leaf: Set Warning state even without bus errors
      can: kvaser_usb_leaf: Fix TX queue out of sync after restart
      can: kvaser_usb_leaf: Fix CAN state after restart
      can: kvaser_usb_leaf: Fix improved state not being reported
      can: kvaser_usb_leaf: Fix wrong CAN state after stopping
      can: kvaser_usb_leaf: Ignore stale bus-off after start
      can: kvaser_usb_leaf: Fix bogus restart events

Jimmy Assarsson (5):
      can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
      can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event
      can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
      can: kvaser_usb: Add struct kvaser_usb_busparams
      can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming

Marc Kleine-Budde (3):
      can: flexcan: flexcan_mailbox_read() fix return value for drop = true
      can: gs_usb: gs_usb_set_phys_id(): return with error if identify is not supported
      Merge patch series "can: kvaser_usb: Various fixes"

 drivers/net/can/flexcan/flexcan-core.c            |  10 +-
 drivers/net/can/usb/gs_usb.c                      |  17 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h       |  32 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  | 118 ++++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 166 +++++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 543 ++++++++++++++++++++--
 6 files changed, 780 insertions(+), 106 deletions(-)


