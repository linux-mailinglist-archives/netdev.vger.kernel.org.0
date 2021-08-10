Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AA43E539B
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 08:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbhHJGhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 02:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhHJGha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 02:37:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16034C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 23:37:09 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mDLNq-0005wA-H8
        for netdev@vger.kernel.org; Tue, 10 Aug 2021 08:37:06 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 779BB663C85
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:37:05 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A7C1F663C7F;
        Tue, 10 Aug 2021 06:37:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d4e0be39;
        Tue, 10 Aug 2021 06:37:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-08-10
Date:   Tue, 10 Aug 2021 08:37:00 +0200
Message-Id: <20210810063702.350109-1-mkl@pengutronix.de>
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

Baruch Siach's patch fixes a typo for the Microchip CAN BUS Analyzer
Tool entry in the MAINTAINERS file.

Hussein Alasadi fixes the setting of the M_CAN_DBTP register in the
m_can driver. The regression git mainline in v5.14-rc1, so no backport
to stable is needed.

regards,
Marc

---
The following changes since commit 143a8526ab5fd4f8a0c4fe2a9cb28c181dc5a95f:

  bareudp: Fix invalid read beyond skb's linear data (2021-08-09 15:37:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.14-20210810

for you to fetch changes up to aae32b784ebdbda6f6055a8021c9fb8a0ab5bcba:

  can: m_can: m_can_set_bittiming(): fix setting M_CAN_DBTP register (2021-08-10 08:10:27 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.14-20210810

----------------------------------------------------------------
Baruch Siach (1):
      MAINTAINERS: fix Microchip CAN BUS Analyzer Tool entry typo

Hussein Alasadi (1):
      can: m_can: m_can_set_bittiming(): fix setting M_CAN_DBTP register

 MAINTAINERS                   | 2 +-
 drivers/net/can/m_can/m_can.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)


