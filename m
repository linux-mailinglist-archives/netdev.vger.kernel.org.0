Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71B7485A49
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 21:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244244AbiAEUyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 15:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244238AbiAEUyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 15:54:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5E4C061201
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 12:54:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n5DJ2-0000dh-R4
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 21:54:48 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9D4B66D1F0A
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 20:54:46 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 850606D1EFA;
        Wed,  5 Jan 2022 20:54:45 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 60e5b742;
        Wed, 5 Jan 2022 20:54:44 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/2] pull-request: can 2022-01-05
Date:   Wed,  5 Jan 2022 21:54:41 +0100
Message-Id: <20220105205443.1274709-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
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

It consists of 2 patches, both by me. The first one fixes the use of
an uninitialized variable in the gs_usb driver the other one a
skb_over_panic in the ISOTP stack in case of reception of too large
ISOTP messages.

regards,
Marc

---

The following changes since commit 1d5a474240407c38ca8c7484a656ee39f585399c:

  sfc: The RX page_ring is optional (2022-01-04 18:14:21 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.16-20220105

for you to fetch changes up to 5f33a09e769a9da0482f20a6770a342842443776:

  can: isotp: convert struct tpcon::{idx,len} to unsigned int (2022-01-05 21:49:47 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.16-20220105

----------------------------------------------------------------
Marc Kleine-Budde (2):
      can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
      can: isotp: convert struct tpcon::{idx,len} to unsigned int

 drivers/net/can/usb/gs_usb.c | 3 ++-
 net/can/isotp.c              | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)


