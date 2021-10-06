Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B827E4239FD
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 10:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237807AbhJFIvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:51:49 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:52646
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237593AbhJFIvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 04:51:48 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id D7F523F226;
        Wed,  6 Oct 2021 08:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633510195;
        bh=h9EtN4sARs+pZ7j+bbOMdD16anrHHdUQKy002WSlXfY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=sXs0o2dvxUe7dmE9q5ELqrVp2PkxLTtcBKflP3iuJN1qnOiw+OrEjXbxBa7tTlokv
         E5iB5q6UfGHoH6fkO0qr+Wfqc2KQEJmNlCdRdVNfq8h7jKIXbHsP/V9Try154ZYa8F
         +Phdx1hFLHiWGyLTUznHahYwJR0iR8P6VM9qh/IP/RgE9L4k3pVwZglL97jBhsHvbs
         5aWE0nJVN56zJP+iU+7Xem97qjcCs4D7VPAphqvE9rQ5mWmoQqcF2NRy9RIxpZ+F7S
         2oxhSGlStMmblVPwXy8y0YUbtOFYjG+4r4NCvWNJVoKPWq61BJxCGbyTI2+B55lYSU
         qjMuxaHDYC0Wg==
From:   Colin King <colin.king@canonical.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] qed: Fix spelling mistake "ctx_bsaed" -> "ctx_based"
Date:   Wed,  6 Oct 2021 09:49:55 +0100
Message-Id: <20211006084955.350530-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a DP_VERBOSE message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ll2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 69ffa4eb842f..3fedcefc36d8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -1654,7 +1654,7 @@ int qed_ll2_establish_connection(void *cxt, u8 connection_handle)
 
 	DP_VERBOSE(p_hwfn,
 		   QED_MSG_LL2,
-		   "Establishing ll2 queue. PF %d ctx_bsaed=%d abs qid=%d stats_id=%d\n",
+		   "Establishing ll2 queue. PF %d ctx_based=%d abs qid=%d stats_id=%d\n",
 		   p_hwfn->rel_pf_id,
 		   p_ll2_conn->input.rx_conn_type, qid, stats_id);
 
-- 
2.32.0

