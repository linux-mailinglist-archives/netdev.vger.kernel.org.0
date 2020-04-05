Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F6B19EB93
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 15:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgDENtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 09:49:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56980 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgDENtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 09:49:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jL5eE-00041V-JO; Sun, 05 Apr 2020 13:49:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qed: remove redundant assignment to variable 'rc'
Date:   Sun,  5 Apr 2020 14:49:14 +0100
Message-Id: <20200405134914.382716-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable 'rc' is being assigned a value that is never read
and it is being updated later with a new value. The assignment
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/qlogic/qed/qed_l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 1a5fc2ae351c..29810a1aa210 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -369,8 +369,8 @@ int qed_sp_eth_vport_start(struct qed_hwfn *p_hwfn,
 	struct qed_spq_entry *p_ent =  NULL;
 	struct qed_sp_init_data init_data;
 	u8 abs_vport_id = 0;
-	int rc = -EINVAL;
 	u16 rx_mode = 0;
+	int rc;
 
 	rc = qed_fw_vport(p_hwfn, p_params->vport_id, &abs_vport_id);
 	if (rc)
-- 
2.25.1

