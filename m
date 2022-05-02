Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76FD516B88
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 09:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359084AbiEBICt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241351AbiEBICs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:02:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F0C19C0B
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 00:59:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlQxj-0002RG-3w
        for netdev@vger.kernel.org; Mon, 02 May 2022 09:59:19 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D0FE972E19
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 07:59:16 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 775D372E01;
        Mon,  2 May 2022 07:59:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b850bb86;
        Mon, 2 May 2022 07:59:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/9] pull-request: can-next 2022-05-02
Date:   Mon,  2 May 2022 09:59:05 +0200
Message-Id: <20220502075914.1905039-1-mkl@pengutronix.de>
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

The first patch is by Biju Das and documents renesas,r9a07g043-canfd
support in the renesas,rcar-canfd bindings document.

Jakub Kicinski's patch removes a copy of the NAPI_POLL_WEIGHT define
from the m_can driver.

The last 7 patches all target the ctucanfd driver. Pavel Pisa provides
2 patch which update the documentation. 2 patches by Jiapeng Chong
remove unneeded includes and error messages. And another 3 patches by
Pavel Pisa to further clean up the driver (remove inline keyword,
remove unneeded debug statements, and remove unneeded module parameters).

regards,
Marc

---

The following changes since commit 6e28f56c0d1d976a4940d13d7f27e446ce65cd0a:

  Merge branch 'adin1100-industrial-PHY-support' (2022-05-01 17:45:35 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.19-20220502

for you to fetch changes up to 28b250e070e9a45a814d13c4ae756aab1298ff27:

  can: ctucanfd: remove PCI module debug parameters (2022-05-02 09:24:41 +0200)

----------------------------------------------------------------
linux-can-next-for-5.19-20220502

----------------------------------------------------------------
Biju Das (1):
      dt-bindings: can: renesas,rcar-canfd: Document RZ/G2UL support

Jakub Kicinski (1):
      can: m_can: remove a copy of the NAPI_POLL_WEIGHT define

Jiapeng Chong (2):
      can: ctucanfd: remove unused including <linux/version.h>
      can: ctucanfd: ctucan_platform_probe(): remove unnecessary print function dev_err()

Pavel Pisa (5):
      docs: networking: device drivers: can: add ctucanfd to index
      docs: networking: device drivers: can: ctucanfd: update author e-mail
      can: ctucanfd: remove inline keyword from local static functions
      can: ctucanfd: remove debug statements
      can: ctucanfd: remove PCI module debug parameters

 .../bindings/net/can/renesas,rcar-canfd.yaml       |  1 +
 .../device_drivers/can/ctu/ctucanfd-driver.rst     |  2 +-
 .../networking/device_drivers/can/index.rst        |  1 +
 drivers/net/can/ctucanfd/ctucanfd_base.c           | 34 ++--------------------
 drivers/net/can/ctucanfd/ctucanfd_pci.c            | 22 ++++----------
 drivers/net/can/ctucanfd/ctucanfd_platform.c       |  1 -
 drivers/net/can/m_can/m_can.c                      |  9 ++----
 7 files changed, 15 insertions(+), 55 deletions(-)


