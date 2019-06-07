Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8893977C
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbfFGVPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:15:48 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58303 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730700AbfFGVPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:15:48 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <mkl@pengutronix.de>)
        id 1hZMDC-00006I-Ak; Fri, 07 Jun 2019 23:15:46 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Alexander Dahl <ada@thorsis.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 1/9] can: usb: Kconfig: Remove duplicate menu entry
Date:   Fri,  7 Jun 2019 23:15:33 +0200
Message-Id: <20190607211541.16095-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607211541.16095-1-mkl@pengutronix.de>
References: <20190607211541.16095-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Dahl <ada@thorsis.com>

This seems to have slipped in by accident when sorting the entries.

Fixes: ffbdd9172ee2f53020f763574b4cdad8d9760a4f
Signed-off-by: Alexander Dahl <ada@thorsis.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index ac3522b77303..4b3d0ddcda79 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -102,12 +102,6 @@ config CAN_PEAK_USB
 
 	  (see also http://www.peak-system.com).
 
-config CAN_MCBA_USB
-	tristate "Microchip CAN BUS Analyzer interface"
-	---help---
-	  This driver supports the CAN BUS Analyzer interface
-	  from Microchip (http://www.microchip.com/development-tools/).
-
 config CAN_UCAN
 	tristate "Theobroma Systems UCAN interface"
 	---help---
-- 
2.20.1

