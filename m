Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA13F2CDC9E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 18:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbgLCRoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 12:44:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60849 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgLCRoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 12:44:04 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kksdQ-0002NT-S4; Thu, 03 Dec 2020 17:43:17 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] wilc1000: remove redundant assignment to pointer vif
Date:   Thu,  3 Dec 2020 17:43:16 +0000
Message-Id: <20201203174316.1071446-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The assignment to pointer vif is redundant as the assigned value
is never read, hence it can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 993ea7c03429..c12f27be9f79 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -685,7 +685,6 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 			if (!tqe_q[ac])
 				continue;
 
-			vif = tqe_q[ac]->vif;
 			ac_exist = 1;
 			for (k = 0; (k < num_pkts_to_add[ac]) &&
 			     (!max_size_over) && tqe_q[ac]; k++) {
-- 
2.29.2

