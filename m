Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1C12CEED6
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbgLDNf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729891AbgLDNf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 08:35:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCC3C061A51
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 05:35:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1klBEw-0004dc-9Z
        for netdev@vger.kernel.org; Fri, 04 Dec 2020 14:35:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 721165A43A7
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 13:35:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6CC265A4398;
        Fri,  4 Dec 2020 13:35:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 03b56eae;
        Fri, 4 Dec 2020 13:35:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-12-04
Date:   Fri,  4 Dec 2020 14:35:05 +0100
Message-Id: <20201204133508.742120-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
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

here's a pull request of 3 patches for net/master.

Zhang Qilong contributes a patch for the softing driver, which fixes the error
handling in the softing_netdev_open() function.

Oliver Hartkopp has two patches for the ISOTP CAN protocol and says:

| This patch set contains a fix that showed up while implementing the
| functional addressing switch suggested by Thomas Wagner.
|
| Unfortunately the functional addressing switch came in very late but
| it is really very simple and already tested.
|
| I would like to leave it to the maintainers whether the second patch
| can still go into the 5.10-rc tree, which is intended for long-term.

regards,
Marc

---

The following changes since commit bbe2ba04c5a92a49db8a42c850a5a2f6481e47eb:

  Merge tag 'net-5.10-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-12-03 13:10:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.10-20201204

for you to fetch changes up to 2e15980d931afa2e51a067ff6adebf5d5b3929b1:

  can: isotp: add SF_BROADCAST support for functional addressing (2020-12-04 12:49:12 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.10-20201204

----------------------------------------------------------------
Oliver Hartkopp (2):
      can: isotp: isotp_setsockopt(): block setsockopt on bound sockets
      can: isotp: add SF_BROADCAST support for functional addressing

Zhang Qilong (1):
      can: softing: softing_netdev_open(): fix error handling

 drivers/net/can/softing/softing_main.c |  9 +++++++--
 include/uapi/linux/can/isotp.h         |  2 +-
 net/can/isotp.c                        | 32 +++++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 12 deletions(-)


