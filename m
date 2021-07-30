Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CE83DB42E
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 09:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237747AbhG3HFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 03:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbhG3HFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 03:05:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464DEC061765
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 00:05:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m9MaK-00061c-Ku
        for netdev@vger.kernel.org; Fri, 30 Jul 2021 09:05:32 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C75D465B79F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:05:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C93C265B78F;
        Fri, 30 Jul 2021 07:05:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8da5ee61;
        Fri, 30 Jul 2021 07:05:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-07-30
Date:   Fri, 30 Jul 2021 09:05:20 +0200
Message-Id: <20210730070526.1699867-1-mkl@pengutronix.de>
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

this is a pull request of 6 patches for net/master.

The first patch is by me and adds Yasushi SHOJI as a reviewer for the
Microchip CAN BUS Analyzer Tool driver.

Dan Carpenter's patch fixes a signedness bug in the hi311x driver.

Pavel Skripkin provides 4 patches, the first targets the mcba_usb
driver by adding the missing urb->transfer_dma initialization, which
was broken in a previous commit. The last 3 patches fix a memory leak
in the usb_8dev, ems_usb and esd_usb2 driver.

regards,
Marc

---

The following changes since commit fc16a5322ee6c30ea848818722eee5d352f8d127:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-07-29 00:53:32 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.14-20210730

for you to fetch changes up to 928150fad41ba16df7fcc9f7f945747d0f56cbb6:

  can: esd_usb2: fix memory leak (2021-07-30 08:47:34 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.14-20210730

----------------------------------------------------------------
Dan Carpenter (1):
      can: hi311x: fix a signedness bug in hi3110_cmd()

Marc Kleine-Budde (1):
      MAINTAINERS: add Yasushi SHOJI as reviewer for the Microchip CAN BUS Analyzer Tool driver

Pavel Skripkin (4):
      can: mcba_usb_start(): add missing urb->transfer_dma initialization
      can: usb_8dev: fix memory leak
      can: ems_usb: fix memory leak
      can: esd_usb2: fix memory leak

 MAINTAINERS                    |  6 ++++++
 drivers/net/can/spi/hi311x.c   |  2 +-
 drivers/net/can/usb/ems_usb.c  | 14 +++++++++++++-
 drivers/net/can/usb/esd_usb2.c | 16 +++++++++++++++-
 drivers/net/can/usb/mcba_usb.c |  2 ++
 drivers/net/can/usb/usb_8dev.c | 15 +++++++++++++--
 6 files changed, 50 insertions(+), 5 deletions(-)


