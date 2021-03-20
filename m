Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90100342F4D
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 20:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhCTThf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 15:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhCTThP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 15:37:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BE3C061762
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 12:37:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lNhPN-0000R8-Tf
        for netdev@vger.kernel.org; Sat, 20 Mar 2021 20:37:13 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 414965FB3E3
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 19:37:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 43C315FB3D5;
        Sat, 20 Mar 2021 19:37:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7c602c88;
        Sat, 20 Mar 2021 19:37:10 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-03-20
Date:   Sat, 20 Mar 2021 20:37:06 +0100
Message-Id: <20210320193708.348503-1-mkl@pengutronix.de>
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

this is a pull request of 2 patches for net/master.

The first patch is by Oliver Hartkopp. He fixes the TX-path in the
ISO-TP protocol by properly initializing the outgoing CAN frames.

The second patch is by me and reverts a patch from my previous pull
request which added MODULE_SUPPORTED_DEVICE to the peak_usb driver. In
the mean time in Linus's tree the entirely MODULE_SUPPORTED_DEVICE was
removed. So this reverts the adding of the new MODULE_SUPPORTED_DEVICE
to avoid the merge conflict.

If you prefer to resolve the merge conflict by hand, I'll send a new
pull request without that patch.

regards,
Marc

---

The following changes since commit 5aa3c334a449bab24519c4967f5ac2b3304c8dcf:

  selftests: forwarding: vxlan_bridge_1d: Fix vxlan ecn decapsulate value (2021-03-19 13:54:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.12-20210320

for you to fetch changes up to 5d7047ed6b7214fbabc16d8712a822e256b1aa44:

  can: peak_usb: Revert "can: peak_usb: add forgotten supported devices" (2021-03-20 20:28:45 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.12-20210320

----------------------------------------------------------------
Marc Kleine-Budde (1):
      can: peak_usb: Revert "can: peak_usb: add forgotten supported devices"

Oliver Hartkopp (1):
      can: isotp: tx-path: zero initialize outgoing CAN frames

 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 2 --
 net/can/isotp.c                            | 6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)


