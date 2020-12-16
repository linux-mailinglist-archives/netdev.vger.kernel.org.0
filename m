Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3751A2DBFF3
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 12:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgLPL6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 06:58:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43651 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLPL6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 06:58:54 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kpVRY-0005He-ON; Wed, 16 Dec 2020 11:58:08 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] wilc1000: fix spelling mistake in Kconfig "devision" -> "division"
Date:   Wed, 16 Dec 2020 11:58:08 +0000
Message-Id: <20201216115808.12987-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in the Kconfig help text. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: remove another fix from the patch

---
 drivers/net/wireless/microchip/wilc1000/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/Kconfig b/drivers/net/wireless/microchip/wilc1000/Kconfig
index 80c92e8bf8a5..7f15e42602dd 100644
--- a/drivers/net/wireless/microchip/wilc1000/Kconfig
+++ b/drivers/net/wireless/microchip/wilc1000/Kconfig
@@ -44,4 +44,4 @@ config WILC1000_HW_OOB_INTR
 	  chipset. This OOB interrupt is intended to provide a faster interrupt
 	  mechanism for SDIO host controllers that don't support SDIO interrupt.
 	  Select this option If the SDIO host controller in your platform
-	  doesn't support SDIO time devision interrupt.
+	  doesn't support SDIO time division interrupt.
-- 
2.29.2

