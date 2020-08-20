Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD6624C4CF
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgHTRrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726745AbgHTRrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:47:47 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70020C061385;
        Thu, 20 Aug 2020 10:47:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r2so2873943wrs.8;
        Thu, 20 Aug 2020 10:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fk/SGva3wWZfGU3gf3Sv9kCw+jo4I9saj87ClFJhRJ0=;
        b=RMcUsxYzOS4wFYyb+sWGcbhU9tt8IJhVvuIa4+Bj1Y2fea3W4oYsGhz+07/yqcxNLR
         Bw1RXCUlpPzSxnWU7EtjR3lxTEbIVczNiMOBhHWK6AZugnwZJgzZwSigTbg5wPD5fyD4
         k492vxOqhMsjEoJn8HdEJ9T51FGjlhREqERbvyNstUWj5nVevQ4oEzt7r7MKyxzNzipU
         Z0f1fmO8UZFBgrVAEhTwndhP0VTyEJnRYM5U9b09Rk31ZnSt/2rZmMmrtDhI2CmlYdUO
         hx73sCmneCp8f9q6BN5JObY7TmMGOB4slNQFzBFqeMtOL+aN60HwfLCYa5W1evV1xlZ1
         OB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fk/SGva3wWZfGU3gf3Sv9kCw+jo4I9saj87ClFJhRJ0=;
        b=JtJ0YftLEZ3C1gmC6eCjvKareNrQlYhK7F3vgIADRBVJRvxepquWFYy7H/dkEBz2Vs
         q+6tBd3KrtqTdK52TIigfw6WMpQ2Vok50symQwfdzfaSb6Ux2CAW1a9JE08+fDcOt48x
         jolFCMlBPxXntEIopFH0UEh2XRX4aiHTCN5yF9ykgyZ/7nUHd4PT0pKw8HCVjSIsgYtO
         fKOG9PDdqUQQbwNI0Nb3zMgUEGx28Kp4n4h8f9//FX+jmxKHy/DkyXk2CHMoEi5DAv9C
         yDlSh83gJt1FN8WteeFSgGhaFRvhhnbADgSf6nBwXPuJCFvBgfeeuOruc9U/+28OyAt4
         G/RQ==
X-Gm-Message-State: AOAM530kBu+tO5wqWyt1BZuHH7fYOPeyKQolsj6A+QQ3ITDy4KuQygFy
        lAG6JtnOLA/AQGqdiTcciVQ=
X-Google-Smtp-Source: ABdhPJyOIFHOMkHKNMf3DG9SR12YnxRsY6B5NKFQmWsKkCYTchqUz4CTtGemsf1taqGwR7fE/V8Lcg==
X-Received: by 2002:a5d:6541:: with SMTP id z1mr4063117wrv.320.1597945665131;
        Thu, 20 Aug 2020 10:47:45 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id b123sm5373801wme.20.2020.08.20.10.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 10:47:44 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alex Dewar <alex.dewar90@gmail.com>
Subject: [PATCH] net: qed: Remove unnecessary cast
Date:   Thu, 20 Aug 2020 18:47:25 +0100
Message-Id: <20200820174725.823353-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In qed_rdma_destroy_cq() the result of dma_alloc_coherent() is cast from
void* unnecessarily. Remove cast.

Issue identified with Coccinelle.

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index a4bcde522cdf..4394a4d77224 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1151,7 +1151,6 @@ qed_rdma_destroy_cq(void *rdma_cxt,
 	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "icid = %08x\n", in_params->icid);
 
 	p_ramrod_res =
-	    (struct rdma_destroy_cq_output_params *)
 	    dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
 			       sizeof(struct rdma_destroy_cq_output_params),
 			       &ramrod_res_phys, GFP_KERNEL);
-- 
2.28.0

