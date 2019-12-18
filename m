Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F6B1252BC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfLRUIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:08:43 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40841 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLRUIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:08:41 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihfcc-0004WQ-M4; Wed, 18 Dec 2019 21:08:38 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1ihfcb-0004bS-5d; Wed, 18 Dec 2019 21:08:37 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v2 0/4] microchip: add support for ksz88x3 driver family
Date:   Wed, 18 Dec 2019 21:08:27 +0100
Message-Id: <20191218200831.13796-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.24.0
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

This series adds support for the ksz88x3 driver family to the dsa based ksz
drivers. The driver is making use of the already available ksz8795 driver and
moves it to an generic driver for the ksz8 based chips which have similar
functions but an totaly different register layout.

Michael Grzeschik (4):
  micrel: fix config_aneg for ksz886x
  net: tag: ksz: Add KSZ8863 tag code
  ksz: Add Microchip KSZ8863 SMI based driver support
  dt-bindings: net: dsa: document additional Microchip KSZ8863/8873
    switch

 .../devicetree/bindings/net/dsa/ksz.txt       |   2 +
 drivers/net/dsa/microchip/Kconfig             |   9 +
 drivers/net/dsa/microchip/Makefile            |   1 +
 drivers/net/dsa/microchip/ksz8.h              |  68 ++
 drivers/net/dsa/microchip/ksz8795.c           | 875 ++++++++++++------
 drivers/net/dsa/microchip/ksz8795_reg.h       | 213 ++---
 drivers/net/dsa/microchip/ksz8795_spi.c       |   7 +-
 drivers/net/dsa/microchip/ksz8863_reg.h       | 121 +++
 drivers/net/dsa/microchip/ksz8863_smi.c       | 183 ++++
 drivers/net/dsa/microchip/ksz_common.h        |   1 +
 drivers/net/phy/micrel.c                      |  11 +
 include/net/dsa.h                             |   2 +
 net/dsa/tag_ksz.c                             |  57 ++
 13 files changed, 1173 insertions(+), 377 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c

-- 
2.24.0

