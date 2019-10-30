Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633C4E977A
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 08:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfJ3H71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 03:59:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40157 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfJ3H71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 03:59:27 -0400
Received: from [91.217.168.176] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iPit1-0007ci-20; Wed, 30 Oct 2019 07:59:23 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qed: fix spelling mistake "queuess" -> "queues"
Date:   Wed, 30 Oct 2019 08:59:22 +0100
Message-Id: <20191030075922.11047-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling misake in a DP_NOTICE message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 78f77b712b10..dcb5c917f373 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -2005,7 +2005,7 @@ static void qed_iov_vf_mbx_stop_vport(struct qed_hwfn *p_hwfn,
 	    (qed_iov_validate_active_txq(p_hwfn, vf))) {
 		vf->b_malicious = true;
 		DP_NOTICE(p_hwfn,
-			  "VF [%02x] - considered malicious; Unable to stop RX/TX queuess\n",
+			  "VF [%02x] - considered malicious; Unable to stop RX/TX queues\n",
 			  vf->abs_vf_id);
 		status = PFVF_STATUS_MALICIOUS;
 		goto out;
-- 
2.20.1

