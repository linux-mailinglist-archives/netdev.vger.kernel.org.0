Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FF9529218
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348139AbiEPUwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348531AbiEPUvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:51:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D738E2A705
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 13:26:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nqhIa-00066V-IF
        for netdev@vger.kernel.org; Mon, 16 May 2022 22:26:36 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 00D1C7FB29
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 20:26:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8C31A7FB23;
        Mon, 16 May 2022 20:26:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a16a4d1f;
        Mon, 16 May 2022 20:26:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/9] pull-request: can-next 2022-05-16
Date:   Mon, 16 May 2022 22:26:16 +0200
Message-Id: <20220516202625.1129281-1-mkl@pengutronix.de>
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

this is a pull request of 9 patches for net-next/master.

the first 2 patches are by me and target the CAN raw protocol. The 1st
removes an unneeded assignment, the other one adds support for
SO_TXTIME/SCM_TXTIME.

Oliver Hartkopp contributes 2 patches for the ISOTP protocol. The 1st
adds support for transmission without flow control, the other let's
bind() return an error on incorrect CAN ID formatting.

Geert Uytterhoeven contributes a patch to clean up ctucanfd's Kconfig
file.

Vincent Mailhol's patch for the slcan driver uses the proper function
to check for invalid CAN frames in the xmit callback.

The next patch is by Geert Uytterhoeven and makes the interrupt-names
of the renesas,rcar-canfd dt bindings mandatory.

A patch by my update the ctucanfd dt bindings to include the common
CAN controller bindings.

The last patch is by Akira Yokosawa and fixes a breakage the
ctucanfd's documentation.

regards,
Marc

---

The following changes since commit d887ae3247e022183f244cb325dca1dfbd0a9ed0:

  octeontx2-pf: Remove unnecessary synchronize_irq() before free_irq() (2022-05-16 11:47:22 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.19-20220516

for you to fetch changes up to ba3e2eaef1ae5019775989aeec3be8e9df83baa5:

  docs: ctucanfd: Use 'kernel-figure' directive instead of 'figure' (2022-05-16 22:11:11 +0200)

----------------------------------------------------------------
linux-can-next-for-5.19-20220516

----------------------------------------------------------------
Akira Yokosawa (1):
      docs: ctucanfd: Use 'kernel-figure' directive instead of 'figure'

Geert Uytterhoeven (2):
      can: ctucanfd: Let users select instead of depend on CAN_CTUCANFD
      dt-bindings: can: renesas,rcar-canfd: Make interrupt-names required

Marc Kleine-Budde (3):
      can: raw: raw_sendmsg(): remove not needed setting of skb->sk
      can: raw: add support for SO_TXTIME/SCM_TXTIME
      dt-bindings: can: ctucanfd: include common CAN controller bindings

Oliver Hartkopp (2):
      can: isotp: add support for transmission without flow control
      can: isotp: isotp_bind(): return -EINVAL on incorrect CAN ID formatting

Vincent Mailhol (1):
      can: slcan: slc_xmit(): use can_dropped_invalid_skb() instead of manual check

 .../devicetree/bindings/net/can/ctu,ctucanfd.yaml  |   3 +
 .../bindings/net/can/renesas,rcar-canfd.yaml       |   3 +-
 .../device_drivers/can/ctu/ctucanfd-driver.rst     |   4 +-
 drivers/net/can/ctucanfd/Kconfig                   |   6 +-
 drivers/net/can/slcan.c                            |   4 +-
 include/uapi/linux/can/isotp.h                     |  25 ++---
 net/can/isotp.c                                    | 105 ++++++++++++++++-----
 net/can/raw.c                                      |  12 ++-
 8 files changed, 119 insertions(+), 43 deletions(-)


