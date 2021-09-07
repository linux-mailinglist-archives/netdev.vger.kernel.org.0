Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0F74023A0
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 08:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbhIGGyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 02:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbhIGGyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 02:54:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C48C061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 23:52:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mNUyW-00054c-Us
        for netdev@vger.kernel.org; Tue, 07 Sep 2021 08:52:57 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 21C47678849
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 06:52:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 578E867883E;
        Tue,  7 Sep 2021 06:52:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6f775eaa;
        Tue, 7 Sep 2021 06:52:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-09-07
Date:   Tue,  7 Sep 2021 08:52:50 +0200
Message-Id: <20210907065252.1061052-1-mkl@pengutronix.de>
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

The first patch is by my and silences a warning in the rcar_canfd
driver, if it's compiled with CONFIG_OF disabled.

Tong Zhang's patch fixes a null-ptr-deref in the c_can driver's
ethtool drvinfo function, for non platform bus based c_can devices.

regards,
Marc

---

The following changes since commit b539c44df067ac116ec1b58b956efda51b6a7fc1:

  net: wwan: iosm: Unify IO accessors used in the driver (2021-09-06 16:45:30 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.15-20210907

for you to fetch changes up to 644d0a5bcc3361170d84fb8d0b13943c354119db:

  can: c_can: fix null-ptr-deref on ioctl() (2021-09-07 08:46:58 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.15-20210907

----------------------------------------------------------------
Marc Kleine-Budde (1):
      can: rcar_canfd: add __maybe_unused annotation to silence warning

Tong Zhang (1):
      can: c_can: fix null-ptr-deref on ioctl()

 drivers/net/can/c_can/c_can_ethtool.c | 4 +---
 drivers/net/can/rcar/rcar_canfd.c     | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)


