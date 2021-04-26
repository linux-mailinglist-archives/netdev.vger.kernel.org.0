Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B98736AC72
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 08:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhDZGzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 02:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbhDZGzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 02:55:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E647C061756
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 23:54:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lav8y-0003yl-SB
        for netdev@vger.kernel.org; Mon, 26 Apr 2021 08:54:56 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C2443616F72
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 06:54:54 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 198F1616F67;
        Mon, 26 Apr 2021 06:54:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 22b96167;
        Mon, 26 Apr 2021 06:54:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-04-26
Date:   Mon, 26 Apr 2021 08:54:48 +0200
Message-Id: <20210426065452.3411360-1-mkl@pengutronix.de>
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

this is a pull request of 4 patches for net-next/master.

the first two patches are from Colin Ian King and target the
etas_es58x driver, they add a missing NULL pointer check and fix some
typos.

The next two patches are by Erik Flodin. The first one updates the CAN
documentation regarding filtering, the other one fixes the header
alignment in CAN related proc output on 64 bit systems.

regards,
Marc

---

The following changes since commit b2f0ca00e6b34bd57c9298a869ea133699e8ec39:

  phy: nxp-c45-tja11xx: add interrupt support (2021-04-23 14:13:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.13-20210426

for you to fetch changes up to e6b031d3c37f79d135c642834bdda7233a29db8d:

  can: proc: fix rcvlist_* header alignment on 64-bit system (2021-04-25 19:43:00 +0200)

----------------------------------------------------------------
linux-can-next-for-5.13-20210426

----------------------------------------------------------------
Colin Ian King (2):
      can: etas_es58x: Fix missing null check on netdev pointer
      can: etas_es58x: Fix a couple of spelling mistakes

Erik Flodin (2):
      can: add a note that RECV_OWN_MSGS frames are subject to filtering
      can: proc: fix rcvlist_* header alignment on 64-bit system

 Documentation/networking/can.rst            | 2 ++
 drivers/net/can/usb/etas_es58x/es58x_core.c | 4 ++--
 drivers/net/can/usb/etas_es58x/es58x_core.h | 2 +-
 net/can/proc.c                              | 6 ++++--
 4 files changed, 9 insertions(+), 5 deletions(-)


