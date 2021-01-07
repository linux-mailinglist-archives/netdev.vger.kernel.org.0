Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE80F2ECDFB
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 11:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbhAGKg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 05:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727746AbhAGKgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 05:36:21 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36762C061282
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 02:35:03 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxSdB-0008Ts-Oy
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 11:35:01 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6D72D5BBCB3
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 10:34:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B1CB35BBC85;
        Thu,  7 Jan 2021 10:34:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4f8d1a3e;
        Thu, 7 Jan 2021 10:34:52 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Sriram Dash <sriram.dash@samsung.com>,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 6/6] MAINTAINERS: Update MCAN MMIO device driver maintainer
Date:   Thu,  7 Jan 2021 11:34:51 +0100
Message-Id: <20210107103451.183477-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107103451.183477-1-mkl@pengutronix.de>
References: <20210107103451.183477-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriram Dash <sriram.dash@samsung.com>

Update Pankaj Sharma as maintainer for mcan mmio device driver as I
will be moving to a different role.

Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
Acked-by: Pankaj Sharma <pankj.sharma@samsung.com>
Link: https://lore.kernel.org/r/20210104123134.16930-1-sriram.dash@samsung.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c1e45c416b1..b15514a770e3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10847,7 +10847,7 @@ F:	drivers/media/radio/radio-maxiradio*
 
 MCAN MMIO DEVICE DRIVER
 M:	Dan Murphy <dmurphy@ti.com>
-M:	Sriram Dash <sriram.dash@samsung.com>
+M:	Pankaj Sharma <pankj.sharma@samsung.com>
 L:	linux-can@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
-- 
2.29.2


