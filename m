Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BDC2B8712
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgKRWEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgKRWEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:04:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3D1C061A4F
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:04:14 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYg-00058r-Du; Wed, 18 Nov 2020 23:04:10 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYe-0000yX-9p; Wed, 18 Nov 2020 23:04:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH 00/11]  net: dsa: microchip: make ksz8795 driver more dynamic
Date:   Wed, 18 Nov 2020 23:03:46 +0100
Message-Id: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series changes the ksz8795 driver to use more dynamic variables
instead of static defines. The purpose is to prepare the driver to be
used with other microchip switches with a similar layout.

Michael Grzeschik (11):
  net: dsa: microchip: ksz8795: remove unused last_port variable
  net: dsa: microchip: ksz8795: remove superfluous port_cnt assignment
  net: dsa: microchip: ksz8795: move variable assignments from detect to init
  net: dsa: microchip: ksz8795: use reg_mib_cnt where possible
  net: dsa: microchip: ksz8795: use mib_cnt where possible
  net: dsa: microchip: ksz8795: use phy_port_cnt where possible
  net: dsa: microchip: remove superfluous num_ports asignment
  net: dsa: microchip: ksz8795: align port_cnt usage with other microchip drivers
  net: dsa: microchip: remove usage of mib_port_count
  net: dsa: microchip: ksz8795: dynamic allocate memory for flush_dyn_mac_table
  net: dsa: microchip: ksz8795: use num_vlans where possible

 drivers/net/dsa/microchip/ksz8795.c     | 74 ++++++++++++-------------
 drivers/net/dsa/microchip/ksz8795_reg.h | 10 ----
 drivers/net/dsa/microchip/ksz9477.c     | 14 ++---
 drivers/net/dsa/microchip/ksz_common.c  |  4 +-
 drivers/net/dsa/microchip/ksz_common.h  |  2 -
 5 files changed, 43 insertions(+), 61 deletions(-)

-- 
2.29.2

