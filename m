Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613133F829C
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 08:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhHZGpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 02:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238082AbhHZGps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 02:45:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A8EC061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 23:45:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mJ98F-0008KQ-Tk
        for netdev@vger.kernel.org; Thu, 26 Aug 2021 08:44:59 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2BE4866FF62
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:44:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BA5B266FF59;
        Thu, 26 Aug 2021 06:44:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f74fe350;
        Thu, 26 Aug 2021 06:44:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-08-26
Date:   Thu, 26 Aug 2021 08:44:55 +0200
Message-Id: <20210826064456.1427513-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of a single patch for net/master.

Stefan Mätje's patch fixes the interchange of RX and TX error counters
inthe esd_usb2 CAN driver.

regards,
Marc
---
The following changes since commit ec92e524ee91c98e6ee06807c7d69d9e2fd141bc:

  net: usb: asix: ax88772: fix boolconv.cocci warnings (2021-08-25 16:35:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.14-20210826

for you to fetch changes up to 044012b52029204900af9e4230263418427f4ba4:

  can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters (2021-08-26 08:37:13 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.14-20210826

----------------------------------------------------------------
Stefan Mätje (1):
      can: usb: esd_usb2: esd_usb2_rx_event(): fix the interchange of the CAN RX and TX error counters

 drivers/net/can/usb/esd_usb2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


