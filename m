Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B382327693E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 08:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgIXGuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 02:50:37 -0400
Received: from m17618.mail.qiye.163.com ([59.111.176.18]:24949 "EHLO
        m17618.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIXGuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 02:50:37 -0400
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m17618.mail.qiye.163.com (Hmail) with ESMTPA id 05ABC4E1010;
        Thu, 24 Sep 2020 14:50:31 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net/ethernet/broadcom: fix spelling typo
Date:   Thu, 24 Sep 2020 14:50:24 +0800
Message-Id: <1600930226-31320-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZHk1NT0tLTRhKQkxMVkpNS0tCSEtJSElITUlVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MQg6GCo*SD8aMANWOgtKAzMh
        EU5PCSNVSlVKTUtLQkhLSUhJQ0tNVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFPTkNONwY+
X-HM-Tid: 0a74bee0b7d99376kuws05abc4e1010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the comment typo: "compliment" -> "complement".

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
index bfc0e45..5caa75b
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h
@@ -284,12 +284,12 @@
 #define CCM_REG_GR_ARB_TYPE					 0xd015c
 /* [RW 2] Load (FIC0) channel group priority. The lowest priority is 0; the
    highest priority is 3. It is supposed; that the Store channel priority is
-   the compliment to 4 of the rest priorities - Aggregation channel; Load
+   the complement to 4 of the rest priorities - Aggregation channel; Load
    (FIC0) channel and Load (FIC1). */
 #define CCM_REG_GR_LD0_PR					 0xd0164
 /* [RW 2] Load (FIC1) channel group priority. The lowest priority is 0; the
    highest priority is 3. It is supposed; that the Store channel priority is
-   the compliment to 4 of the rest priorities - Aggregation channel; Load
+   the complement to 4 of the rest priorities - Aggregation channel; Load
    (FIC0) channel and Load (FIC1). */
 #define CCM_REG_GR_LD1_PR					 0xd0168
 /* [RW 2] General flags index. */
@@ -4489,11 +4489,11 @@
 #define TCM_REG_GR_ARB_TYPE					 0x50114
 /* [RW 2] Load (FIC0) channel group priority. The lowest priority is 0; the
    highest priority is 3. It is supposed that the Store channel is the
-   compliment of the other 3 groups. */
+   complement of the other 3 groups. */
 #define TCM_REG_GR_LD0_PR					 0x5011c
 /* [RW 2] Load (FIC1) channel group priority. The lowest priority is 0; the
    highest priority is 3. It is supposed that the Store channel is the
-   compliment of the other 3 groups. */
+   complement of the other 3 groups. */
 #define TCM_REG_GR_LD1_PR					 0x50120
 /* [RW 4] The number of double REG-pairs; loaded from the STORM context and
    sent to STORM; for a specific connection type. The double REG-pairs are
@@ -5020,11 +5020,11 @@
 #define UCM_REG_GR_ARB_TYPE					 0xe0144
 /* [RW 2] Load (FIC0) channel group priority. The lowest priority is 0; the
    highest priority is 3. It is supposed that the Store channel group is
-   compliment to the others. */
+   complement to the others. */
 #define UCM_REG_GR_LD0_PR					 0xe014c
 /* [RW 2] Load (FIC1) channel group priority. The lowest priority is 0; the
    highest priority is 3. It is supposed that the Store channel group is
-   compliment to the others. */
+   complement to the others. */
 #define UCM_REG_GR_LD1_PR					 0xe0150
 /* [RW 2] The queue index for invalidate counter flag decision. */
 #define UCM_REG_INV_CFLG_Q					 0xe00e4
@@ -5523,11 +5523,11 @@
 #define XCM_REG_GR_ARB_TYPE					 0x2020c
 /* [RW 2] Load (FIC0) channel group priority. The lowest priority is 0; the
    highest priority is 3. It is supposed that the Channel group is the
-   compliment of the other 3 groups. */
+   complement of the other 3 groups. */
 #define XCM_REG_GR_LD0_PR					 0x20214
 /* [RW 2] Load (FIC1) channel group priority. The lowest priority is 0; the
    highest priority is 3. It is supposed that the Channel group is the
-   compliment of the other 3 groups. */
+   complement of the other 3 groups. */
 #define XCM_REG_GR_LD1_PR					 0x20218
 /* [RW 1] Input nig0 Interface enable. If 0 - the valid input is
    disregarded; acknowledge output is deasserted; all other signals are
-- 
2.7.4

