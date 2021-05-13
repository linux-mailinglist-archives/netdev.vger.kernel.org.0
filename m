Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3953737F72A
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhEMLup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:50:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33067 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhEMLu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:50:27 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lh9q2-0000An-DP; Thu, 13 May 2021 11:49:10 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: qed: remove redundant initialization of variable rc
Date:   Thu, 13 May 2021 12:49:10 +0100
Message-Id: <20210513114910.57915-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable rc is being initialized with a value that is never read,
it is being updated later on.  The assignment is redundant and can be
removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
index 4eae4ee3538f..448567a1f520 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iscsi.c
@@ -453,7 +453,7 @@ static int qed_sp_iscsi_conn_update(struct qed_hwfn *p_hwfn,
 	struct iscsi_conn_update_ramrod_params *p_ramrod = NULL;
 	struct qed_spq_entry *p_ent = NULL;
 	struct qed_sp_init_data init_data;
-	int rc = -EINVAL;
+	int rc;
 	u32 dval;
 
 	/* Get SPQ entry */
-- 
2.30.2

