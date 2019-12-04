Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E58112A5F
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfLDLk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:40:26 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36479 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfLDLk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 06:40:26 -0500
Received: by mail-pl1-f195.google.com with SMTP id k20so3081441pls.3;
        Wed, 04 Dec 2019 03:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MiINZFBs6khm8b6mMvNgRfbiNCwT+6tcCMZMlP4kWDc=;
        b=Me/qyZBSUoJ5Yl8xik+dzd9PoLPKurXbWAK5IuDKz16oS33rkFiSIjiWXmBze6iCsM
         Jne5T9ATfzpHc0zuyNlxcV2tYKp2hGvA/Myv0d8Gvp5qbMUKaf+oOagxtRN1AoRl8h1s
         c4joqbPyJ052UENlBmxfA4VQ2/6uJWt0Gh9t5W+92GX0KaASvJlU8WhF0BgDhlYgfooM
         SgH7MMcdlpMUl5tFPFWAYynyVbZelnR8rpoBMOGouSryqhbGJjl3/1RzkPd4snbzGTf9
         QF2RjmVYtu8MJ/uNZjUBIrrTPQaJNY3r6ISAM1Uiwpd0+ckOtHBh0/erxbzJcJLSHcJy
         aQhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MiINZFBs6khm8b6mMvNgRfbiNCwT+6tcCMZMlP4kWDc=;
        b=ToIQl5DV/kDORP0dmg/isBqo7lF0RENvnjV18boivBhFm85GM+QrZNdRPydAgNKYj7
         vkZXpL5waWazawu9Fhcx68bSdoKt62JlcUXVZX6GJhSMTUqqcYoblVfWcps5V1Yyakpc
         +wldZ3G7TNne7m+MlrKF70A7eCFWFhuUwJdYVSHo+fB8qmFQL6Yxvx5XQ5PwqVNPtxiS
         e7qCicOh42mj7Wermi4D7WVLqyX4v9NTZvKIy6b/V7W+b71iQOL65QDGWkDwtvHUWkvj
         9+2ReDN82zLwjNMiLF+VTLZKxLBjb3x7KZbuOeLp+2ezeGMCGXpwwHtkWUPkAoowo7tX
         E4Ow==
X-Gm-Message-State: APjAAAUZqpTsEF3jnNTisy6bRcospF/4lgtuzq4sTNITeQhvrjx9lMEN
        2qq6LVhIFOT0ug0ubpcelzY=
X-Google-Smtp-Source: APXvYqxbyKEe4NNTHMvIbBya6nrH5aA6meS8Jca0dWLee3ljlkLjOW9+RLRsuqUHi4HkvCGin53VnA==
X-Received: by 2002:a17:902:aa49:: with SMTP id c9mr3007884plr.220.1575459625813;
        Wed, 04 Dec 2019 03:40:25 -0800 (PST)
Received: from localhost.localdomain ([2402:3a80:6ac:96e0:e497:614f:d1b6:6930])
        by smtp.googlemail.com with ESMTPSA id s2sm8162694pfb.109.2019.12.04.03.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 03:40:25 -0800 (PST)
From:   Jaskaran Singh <jaskaransingh7654321@gmail.com>
To:     aelior@marvell.com
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] drivers: net: qlogic: apply alloc_cast.cocci to qlogic/qed/qed_roce.c
Date:   Wed,  4 Dec 2019 17:10:13 +0530
Message-Id: <20191204114013.31726-1-jaskaransingh7654321@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

coccicheck reports that qlogic/qed/qed_roce.c can be patched with the
semantic patch alloc_cast.cocci. The casts on the function
dma_alloc_coherent can be removed. Apply the semantic patch and perform
formatting changes as required.

Signed-off-by: Jaskaran Singh <jaskaransingh7654321@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_roce.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index e49fada85410..5fbdab8b6fcd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -736,9 +736,9 @@ static int qed_roce_sp_destroy_qp_responder(struct qed_hwfn *p_hwfn,
 
 	p_ramrod = &p_ent->ramrod.roce_destroy_qp_resp;
 
-	p_ramrod_res = (struct roce_destroy_qp_resp_output_params *)
-	    dma_alloc_coherent(&p_hwfn->cdev->pdev->dev, sizeof(*p_ramrod_res),
-			       &ramrod_res_phys, GFP_KERNEL);
+	p_ramrod_res = dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+					  sizeof(*p_ramrod_res),
+					  &ramrod_res_phys, GFP_KERNEL);
 
 	if (!p_ramrod_res) {
 		rc = -ENOMEM;
@@ -790,8 +790,7 @@ static int qed_roce_sp_destroy_qp_requester(struct qed_hwfn *p_hwfn,
 	if (!qp->req_offloaded)
 		return 0;
 
-	p_ramrod_res = (struct roce_destroy_qp_req_output_params *)
-		       dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+	p_ramrod_res = dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
 					  sizeof(*p_ramrod_res),
 					  &ramrod_res_phys, GFP_KERNEL);
 	if (!p_ramrod_res) {
@@ -872,10 +871,10 @@ int qed_roce_query_qp(struct qed_hwfn *p_hwfn,
 	}
 
 	/* Send a query responder ramrod to FW to get RQ-PSN and state */
-	p_resp_ramrod_res = (struct roce_query_qp_resp_output_params *)
-	    dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
-			       sizeof(*p_resp_ramrod_res),
-			       &resp_ramrod_res_phys, GFP_KERNEL);
+	p_resp_ramrod_res =
+		dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+				   sizeof(*p_resp_ramrod_res),
+				   &resp_ramrod_res_phys, GFP_KERNEL);
 	if (!p_resp_ramrod_res) {
 		DP_NOTICE(p_hwfn,
 			  "qed query qp failed: cannot allocate memory (ramrod)\n");
@@ -920,8 +919,7 @@ int qed_roce_query_qp(struct qed_hwfn *p_hwfn,
 	}
 
 	/* Send a query requester ramrod to FW to get SQ-PSN and state */
-	p_req_ramrod_res = (struct roce_query_qp_req_output_params *)
-			   dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
+	p_req_ramrod_res = dma_alloc_coherent(&p_hwfn->cdev->pdev->dev,
 					      sizeof(*p_req_ramrod_res),
 					      &req_ramrod_res_phys,
 					      GFP_KERNEL);
-- 
2.21.0

