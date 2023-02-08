Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238F768F95B
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 22:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjBHVBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 16:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjBHVB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 16:01:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E404C6F1
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 13:00:39 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pPrYA-00007J-4t
        for netdev@vger.kernel.org; Wed, 08 Feb 2023 22:00:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2E5ED173CE0
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:00:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 18BBA173CD1;
        Wed,  8 Feb 2023 21:00:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 498bdd38;
        Wed, 8 Feb 2023 21:00:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/2] pull-request: can-next 2023-02-08
Date:   Wed,  8 Feb 2023 22:00:12 +0100
Message-Id: <20230208210014.3169347-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
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

Hello netdev-team,

this is a pull request of 2 patches for net-next/master.

The 1st patch is by Oliver Hartkopp and cleans up the CAN_RAW's
raw_setsockopt() for CAN_RAW_FD_FRAMES.

The 2nd patch is by me and fixes the compilation if
CONFIG_CAN_CALC_BITTIMING is disabled. (Problem introduced in last
pull request to next-next.)

regards,
Marc

---
The following changes since commit e6ebe6c12355538e9238e2051bd6757b12dbfe9c:

  Merge branch 'taprio-auto-qmaxsdu-new-tx' (2023-02-08 09:48:53 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-6.3-20230208

for you to fetch changes up to 65db3d8b5231bd430c12150258125aca155aea97:

  can: bittiming: can_calc_bittiming(): add missing parameter to no-op function (2023-02-08 21:53:24 +0100)

----------------------------------------------------------------
linux-can-next-for-6.3-20230208

----------------------------------------------------------------
Marc Kleine-Budde (1):
      can: bittiming: can_calc_bittiming(): add missing parameter to no-op function

Oliver Hartkopp (1):
      can: raw: use temp variable instead of rolling back config

 include/linux/can/bittiming.h |  2 +-
 net/can/raw.c                 | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)


