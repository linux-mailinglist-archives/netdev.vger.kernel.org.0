Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4963F71CA
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbhHYJgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239513AbhHYJgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:36:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9F5C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 02:35:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mIpJZ-000473-53
        for netdev@vger.kernel.org; Wed, 25 Aug 2021 11:35:21 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BFBE466F5A0
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:35:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D050A66F591;
        Wed, 25 Aug 2021 09:35:17 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b2780a62;
        Wed, 25 Aug 2021 09:35:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-08-25
Date:   Wed, 25 Aug 2021 11:35:12 +0200
Message-Id: <20210825093516.448231-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
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

this is a pull request of 4 patches for net-next/master.

The first patch is by Cai Huoqing, and enables COMPILE_TEST for the
rcar CAN drivers.

Lad Prabhakar contributes a patch for the rcar_canfd driver, fixing a
redundant assignment.

The last 2 patches are by Tang Bin, target the mscan driver, and clean
up the driver by converting it to of_device_get_match_data() and
removing a useless BUG_ON.

regards,
Marc

---
The following changes since commit a37c5c26693eadb3aa4101d8fe955e40d206b386:

  net: bridge: change return type of br_handle_ingress_vlan_tunnel (2021-08-24 16:51:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.15-20210825

for you to fetch changes up to cbe8cd7d83e251bff134a57ea4b6378db992ad82:

  can: mscan: mpc5xxx_can: mpc5xxx_can_probe(): remove useless BUG_ON() (2021-08-25 08:25:11 +0200)

----------------------------------------------------------------
linux-can-next-for-5.15-20210825

----------------------------------------------------------------
Cai Huoqing (1):
      can: rcar: Kconfig: Add helper dependency on COMPILE_TEST

Lad Prabhakar (1):
      can: rcar_canfd: rcar_canfd_handle_channel_tx(): fix redundant assignment

Tang Bin (2):
      can: mscan: mpc5xxx_can: mpc5xxx_can_probe(): use of_device_get_match_data to simplify code
      can: mscan: mpc5xxx_can: mpc5xxx_can_probe(): remove useless BUG_ON()

 drivers/net/can/mscan/mpc5xxx_can.c | 7 ++-----
 drivers/net/can/rcar/Kconfig        | 4 ++--
 drivers/net/can/rcar/rcar_canfd.c   | 2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)


