Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278E0215711
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgGFMMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:12:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53870 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727896AbgGFMMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:12:46 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jsPzE-0001Vk-J1; Mon, 06 Jul 2020 12:12:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] bnx2x: fix spelling mistake "occurd" -> "occurred"
Date:   Mon,  6 Jul 2020 13:12:40 +0100
Message-Id: <20200706121240.486132-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are spelling mistakes in various literal strings. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c
index 48f63ef2e6ea..3f8bdad3351c 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_self_test.c
@@ -2218,31 +2218,31 @@ static struct st_record st_database[ST_DB_LINES] = {
 /*line 352*/{(0x1E), 1, MISC_REG_AEU_SYS_KILL_OCCURRED,
 	NA, NA, NA, pneq,
 	NA, IDLE_CHK_ERROR,
-	"MISC: system kill occurd;",
+	"MISC: system kill occurred;",
 	{NA, NA, 0, NA, NA, NA} },
 
 /*line 353*/{(0x1E), 1, MISC_REG_AEU_SYS_KILL_STATUS_0,
 	NA, NA, NA, pneq,
 	NA, IDLE_CHK_ERROR,
-	"MISC: system kill occurd; status_0 register",
+	"MISC: system kill occurred; status_0 register",
 	{NA, NA, 0, NA, NA, NA} },
 
 /*line 354*/{(0x1E), 1, MISC_REG_AEU_SYS_KILL_STATUS_1,
 	NA, NA, NA, pneq,
 	NA, IDLE_CHK_ERROR,
-	"MISC: system kill occurd; status_1 register",
+	"MISC: system kill occurred; status_1 register",
 	{NA, NA, 0, NA, NA, NA} },
 
 /*line 355*/{(0x1E), 1, MISC_REG_AEU_SYS_KILL_STATUS_2,
 	NA, NA, NA, pneq,
 	NA, IDLE_CHK_ERROR,
-	"MISC: system kill occurd; status_2 register",
+	"MISC: system kill occurred; status_2 register",
 	{NA, NA, 0, NA, NA, NA} },
 
 /*line 356*/{(0x1E), 1, MISC_REG_AEU_SYS_KILL_STATUS_3,
 	NA, NA, NA, pneq,
 	NA, IDLE_CHK_ERROR,
-	"MISC: system kill occurd; status_3 register",
+	"MISC: system kill occurred; status_3 register",
 	{NA, NA, 0, NA, NA, NA} },
 
 /*line 357*/{(0x1E), 1, MISC_REG_PCIE_HOT_RESET,
-- 
2.27.0

