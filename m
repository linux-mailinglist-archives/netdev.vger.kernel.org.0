Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF6A46E3EA
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbhLIIRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbhLIIQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:16:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0348DC061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 00:13:25 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mvEYM-0001hU-4B
        for netdev@vger.kernel.org; Thu, 09 Dec 2021 09:13:22 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 85A656C0651
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 08:13:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A899B6C0645;
        Thu,  9 Dec 2021 08:13:19 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2a011003;
        Thu, 9 Dec 2021 08:13:19 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/2] pull-request: can 2021-12-09
Date:   Thu,  9 Dec 2021 09:13:10 +0100
Message-Id: <20211209081312.301036-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
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

Both patches are by Jimmy Assarsson. The first one fixes the
incrementing of the rx/tx error counters in the Kvaser PCIe FD driver.
The second one fixes the Kvaser USB driver by using the CAN clock
frequency provided by the device instead of using a hard coded value.

regards,
Marc

---
The following changes since commit a50e659b2a1be14784e80f8492aab177e67c53a2:

  net: mvpp2: fix XDP rx queues registering (2021-12-08 18:29:37 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.16-20211209

for you to fetch changes up to fb12797ab1fef480ad8a32a30984844444eeb00d:

  can: kvaser_usb: get CAN clock frequency from device (2021-12-09 09:01:43 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.16-20211209

----------------------------------------------------------------
Jimmy Assarsson (2):
      can: kvaser_pciefd: kvaser_pciefd_rx_error_frame(): increase correct stats->{rx,tx}_errors counter
      can: kvaser_usb: get CAN clock frequency from device

 drivers/net/can/kvaser_pciefd.c                  |   8 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c | 101 ++++++++++++++++-------
 2 files changed, 80 insertions(+), 29 deletions(-)


