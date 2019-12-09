Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBF441171D9
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfLIQdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:33:39 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45809 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfLIQdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:33:04 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ieLy0-0001up-2S; Mon, 09 Dec 2019 17:33:00 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 01/13] MAINTAINERS: Add myself as a maintainer for MMIO m_can
Date:   Mon,  9 Dec 2019 17:32:44 +0100
Message-Id: <20191209163256.12000-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209163256.12000-1-mkl@pengutronix.de>
References: <20191209163256.12000-1-mkl@pengutronix.de>
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

From: Dan Murphy <dmurphy@ti.com>

Since I refactored the code to create a m_can framework and we
have a MMIO MCAN IP as well add myself to help maintain the code.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ecc354f4b692..1d50632f7662 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10095,6 +10095,7 @@ S:	Maintained
 F:	drivers/media/radio/radio-maxiradio*
 
 MCAN MMIO DEVICE DRIVER
+M:	Dan Murphy <dmurphy@ti.com>
 M:	Sriram Dash <sriram.dash@samsung.com>
 L:	linux-can@vger.kernel.org
 S:	Maintained
-- 
2.24.0

