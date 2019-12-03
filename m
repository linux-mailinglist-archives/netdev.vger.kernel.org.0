Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491B310FBF0
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbfLCKrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:47:09 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53823 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfLCKrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:47:08 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ic5hy-0001BG-Lb; Tue, 03 Dec 2019 11:47:06 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Sriram Dash <sriram.dash@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 2/6] MAINTAINERS: add myself as maintainer of MCAN MMIO device driver
Date:   Tue,  3 Dec 2019 11:46:59 +0100
Message-Id: <20191203104703.14620-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203104703.14620-1-mkl@pengutronix.de>
References: <20191203104703.14620-1-mkl@pengutronix.de>
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

From: Sriram Dash <sriram.dash@samsung.com>

Since we are actively working on MMIO MCAN device driver,
as discussed with Marc, I am adding myself as a maintainer.

Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d700e27ebf41..ecc354f4b692 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10094,6 +10094,15 @@ W:	https://linuxtv.org
 S:	Maintained
 F:	drivers/media/radio/radio-maxiradio*
 
+MCAN MMIO DEVICE DRIVER
+M:	Sriram Dash <sriram.dash@samsung.com>
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/can/m_can.txt
+F:	drivers/net/can/m_can/m_can.c
+F:	drivers/net/can/m_can/m_can.h
+F:	drivers/net/can/m_can/m_can_platform.c
+
 MCP4018 AND MCP4531 MICROCHIP DIGITAL POTENTIOMETER DRIVERS
 M:	Peter Rosin <peda@axentia.se>
 L:	linux-iio@vger.kernel.org
-- 
2.24.0

