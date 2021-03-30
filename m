Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9298A34E6A0
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhC3LrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhC3Lq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10226C061764
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpF-00060y-EU
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 96E06603E3D
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D42F3603DEA;
        Tue, 30 Mar 2021 11:46:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0eea0fd3;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        kernel test robot <lkp@intel.com>
Subject: [net-next 11/39] can: grcan: add missing Kconfig dependency to HAS_IOMEM
Date:   Tue, 30 Mar 2021 13:45:31 +0200
Message-Id: <20210330114559.1114855-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ARCHs without IOMEM support the grcan driver fails to link due to
missing iomem functionality. This patch adds the missing Kconfig
dependency to HAS_IOMEM.

Link: https://lore.kernel.org/r/20210309140424.3331010-1-mkl@pengutronix.de
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 1c28eade6bec..e355d3974977 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -103,7 +103,7 @@ config CAN_FLEXCAN
 
 config CAN_GRCAN
 	tristate "Aeroflex Gaisler GRCAN and GRHCAN CAN devices"
-	depends on OF && HAS_DMA
+	depends on OF && HAS_DMA && HAS_IOMEM
 	help
 	  Say Y here if you want to use Aeroflex Gaisler GRCAN or GRHCAN.
 	  Note that the driver supports little endian, even though little
-- 
2.30.2


