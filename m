Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD0934E680
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhC3LqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbhC3LqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C243C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:07 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCov-0005Y8-R5
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:05 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4F22E603DDA
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:03 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C628B603DBF;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fa83cb28;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 01/39] MAINTAINERS: remove Dan Murphy from m_can and tcan4x5x
Date:   Tue, 30 Mar 2021 13:45:21 +0200
Message-Id: <20210330114559.1114855-2-mkl@pengutronix.de>
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

Dan Murphy's email address at ti.com doesn't work anymore, mails
bounce with:

| 550 Invalid recipient <dmurphy@ti.com> (#5.1.1)

For now remove all CAN related entries of Dan from the Maintainers
file.

Link: https://lore.kernel.org/r/20210228094218.40015-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 MAINTAINERS | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 11177892c373..45c400e9d5fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10910,7 +10910,6 @@ T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/radio/radio-maxiradio*
 
 MCAN MMIO DEVICE DRIVER
-M:	Dan Murphy <dmurphy@ti.com>
 M:	Pankaj Sharma <pankj.sharma@samsung.com>
 L:	linux-can@vger.kernel.org
 S:	Maintained
@@ -17983,13 +17982,6 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Odd Fixes
 F:	sound/soc/codecs/tas571x*
 
-TI TCAN4X5X DEVICE DRIVER
-M:	Dan Murphy <dmurphy@ti.com>
-L:	linux-can@vger.kernel.org
-S:	Maintained
-F:	Documentation/devicetree/bindings/net/can/tcan4x5x.txt
-F:	drivers/net/can/m_can/tcan4x5x*
-
 TI TRF7970A NFC DRIVER
 M:	Mark Greer <mgreer@animalcreek.com>
 L:	linux-wireless@vger.kernel.org

base-commit: d0922bf7981799fd86e248de330fb4152399d6c2
-- 
2.30.2


