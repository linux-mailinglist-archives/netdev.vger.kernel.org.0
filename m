Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4186FF2CEF
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 12:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388171AbfKGLA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 06:00:56 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56079 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfKGLAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 06:00:53 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iSfX1-0004bS-26; Thu, 07 Nov 2019 12:00:51 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1iSfX0-0003eG-1r; Thu, 07 Nov 2019 12:00:50 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Tristram.Ha@microchip.com, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de
Subject: [PATCH v1 0/4] microchip: add support for ksz88x3 driver family
Date:   Thu,  7 Nov 2019 12:00:26 +0100
Message-Id: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the ksz88x3 driver family to the 
dsa based ksz drivers. For now the ksz8863 and ksz8873 are compatible.

The driver is based on the ksz8895 RFC patch from Tristam Ha: 

https://patchwork.ozlabs.org/patch/822712/

And the latest version of the ksz8863.h from Microchip:

https://raw.githubusercontent.com/Microchip-Ethernet/UNG8071_old_1.10/master/KSZ/linux-drivers/ksz8863/linux-3.14/drivers/net/ethernet/micrel/ksz8863.h

Michael Grzeschik (4):
  mdio-bitbang: add SMI0 mode support
  net: tag: ksz: Add KSZ8863 tag code
  ksz: Add Microchip KSZ8863 SMI-DSA driver
  dt-bindings: net: dsa: document additional Microchip KSZ8863/8873
    switch

 .../devicetree/bindings/net/dsa/ksz.txt       |    2 +
 drivers/net/dsa/microchip/Kconfig             |   16 +
 drivers/net/dsa/microchip/Makefile            |    2 +
 drivers/net/dsa/microchip/ksz8863.c           | 1038 +++++++++++++++++
 drivers/net/dsa/microchip/ksz8863_reg.h       |  605 ++++++++++
 drivers/net/dsa/microchip/ksz8863_smi.c       |  166 +++
 drivers/net/dsa/microchip/ksz_common.h        |    1 +
 drivers/net/phy/mdio-bitbang.c                |   21 +
 include/linux/phy.h                           |    2 +
 include/net/dsa.h                             |    2 +
 net/dsa/tag_ksz.c                             |   60 +
 11 files changed, 1915 insertions(+)
 create mode 100644 drivers/net/dsa/microchip/ksz8863.c
 create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c

-- 
2.24.0.rc1

