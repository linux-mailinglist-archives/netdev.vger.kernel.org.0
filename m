Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9329A280
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404578AbfHVWAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:00:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50197 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404199AbfHVWAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:00:30 -0400
Received: from cpc129250-craw9-2-0-cust139.know.cable.virginm.net ([82.43.126.140] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i0v85-0005ow-Si; Thu, 22 Aug 2019 22:00:25 +0000
From:   Colin King <colin.king@canonical.com>
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipw2x00: fix spelling mistake "initializationg" -> "initialization"
Date:   Thu, 22 Aug 2019 23:00:25 +0100
Message-Id: <20190822220025.5690-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in an IPW_DEBUG_INFO message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index fa55d2ccbfab..ed0f06532d5e 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -2721,7 +2721,7 @@ static void ipw_eeprom_init_sram(struct ipw_priv *priv)
 		/* Do not load eeprom data on fatal error or suspend */
 		ipw_write32(priv, IPW_EEPROM_LOAD_DISABLE, 0);
 	} else {
-		IPW_DEBUG_INFO("Enabling FW initializationg of SRAM\n");
+		IPW_DEBUG_INFO("Enabling FW initialization of SRAM\n");
 
 		/* Load eeprom data on fatal error or suspend */
 		ipw_write32(priv, IPW_EEPROM_LOAD_DISABLE, 1);
-- 
2.20.1

