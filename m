Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2546C9C18
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjC0HeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbjC0HeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:34:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73951B8
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:34:00 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pghMd-0000Ei-D2
        for netdev@vger.kernel.org; Mon, 27 Mar 2023 09:33:59 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8D65719CDC7
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:33:58 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EA8D719CDBE;
        Mon, 27 Mar 2023 07:33:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f0b6339b;
        Mon, 27 Mar 2023 07:33:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/11] pull-request: can-next 2023-03-27
Date:   Mon, 27 Mar 2023 09:33:43 +0200
Message-Id: <20230327073354.1003134-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev-team,

this is a pull request of 11 patches for net-next/master.

The first 2 patches by Geert Uytterhoeven add transceiver support and
improve the error messages in the rcar_canfd driver.

Cai Huoqing contributes 3 patches which remove a redundant call to
pci_clear_master() in the c_can, ctucanfd and kvaser_pciefd driver.

Frank Jungclaus's patch replaces the struct esd_usb_msg with a union
in the esd_usb driver to improve readability.

Markus Schneider-Pargmann contributes 5 patches to improve the
performance in the m_can driver, especially for SPI attached
controllers like the tcan4x5x.

regards,
Marc

---

The following changes since commit 323fe43cf9aef79159ba8937218a3f076bf505af:

  net: phy: Improved PHY error reporting in state machine (2023-03-24 09:18:19 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-6.4-20230327

for you to fetch changes up to db88681c4885b8f2f07241c6f3f1fcf2d773754e:

  Merge patch series "can: m_can: Optimizations for m_can/tcan part 2" (2023-03-24 19:14:02 +0100)

----------------------------------------------------------------
linux-can-next-for-6.4-20230327

----------------------------------------------------------------
Cai Huoqing (3):
      can: c_can: Remove redundant pci_clear_master
      can: ctucanfd: Remove redundant pci_clear_master
      can: kvaser_pciefd: Remove redundant pci_clear_master

Frank Jungclaus (1):
      can: esd_usb: Improve code readability by means of replacing struct esd_usb_msg with a union

Geert Uytterhoeven (2):
      can: rcar_canfd: Add transceiver support
      can: rcar_canfd: Improve error messages

Marc Kleine-Budde (3):
      Merge patch series "can: rcar_canfd: Add transceiver support"
      Merge patch series "can: remove redundant pci_clear_master()"
      Merge patch series "can: m_can: Optimizations for m_can/tcan part 2"

Markus Schneider-Pargmann (5):
      can: m_can: Remove repeated check for is_peripheral
      can: m_can: Always acknowledge all interrupts
      can: m_can: Remove double interrupt enable
      can: m_can: Disable unused interrupts
      can: m_can: Keep interrupts enabled during peripheral read

 drivers/net/can/c_can/c_can_pci.c       |   2 -
 drivers/net/can/ctucanfd/ctucanfd_pci.c |   8 +-
 drivers/net/can/kvaser_pciefd.c         |   1 -
 drivers/net/can/m_can/m_can.c           |  37 +++----
 drivers/net/can/rcar/rcar_canfd.c       |  71 +++++++++-----
 drivers/net/can/usb/esd_usb.c           | 166 ++++++++++++++++----------------
 6 files changed, 148 insertions(+), 137 deletions(-)


