Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CD4575B69
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 08:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiGOGR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 02:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGOGR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 02:17:56 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7A02719;
        Thu, 14 Jul 2022 23:17:55 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s27so3549637pga.13;
        Thu, 14 Jul 2022 23:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=5MLxTGie+B4QdlEZJxtbc8CtA2pcH2E4OqHrrJEXotI=;
        b=E9f19W6WnC5o6tUo39/A3LDf0ge61zcqFRst/ixdwUQESK0Kf/5v7f1M0aK6twNDF7
         HfMWGqil3gsBqmL/cYph1jmoznV1o+eZ+Ypb0oOS+fvhn44oAxJxuW0RgMxb+prc3PjX
         KcVSrk4QypCpuWy8b1O2Z2N2fCPOXnsYjCSD2K6oZwRSaSLSpP1OrtG5Ik4hkldyTdTn
         aeDwolSqATu5jzFUNeFQ9anNJa81F4iSxYoOLFP1kWBuyIwUoUmVOaaxyKyXv8+eaKXl
         57lHL/zPjxLTVDARmFpaShxytqRztVZ9rC/p1HBR8tbtZzMkK2JVYZXK+ld9b+6+ARKo
         QrlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=5MLxTGie+B4QdlEZJxtbc8CtA2pcH2E4OqHrrJEXotI=;
        b=0GG2Suvd4OpkbQIVdjGdDrGTHcexouGhInQZS3OndFbdGcqMiSGxT0hkEHuHyQLq/Y
         ywe8xtsScYCUc802PApsFoq4L85nbUj3EW++fSJYkxXIyflET18WF0t0FqpnTyfRseGW
         y4vDwwECpvYokR0l5H9gTqW9jCPriPvpHlhTUn5fuqNSljoXYAEXifSpfSgtK3HqXRt1
         ao4pGFrnIKzOqgNfSBMzZeNQO4R7rdJ3n+QaZ8no89+kHLwrKR8ouAsAXAZxOzcPjG6m
         zCJvYcxL1zbKGsQsgJ91kfkLda3zf1Z6rXRdoCut4mKWVaLgla35td9yctHzu/f6XJkx
         ARPw==
X-Gm-Message-State: AJIora/zJW3c0FsrcJkcLMYZZYpEZxlgIflI0LokvaZJXysMuowbI90p
        AS+EHd3RGBUJCrql9sMR/IWvzjwSa8z7CQ==
X-Google-Smtp-Source: AGRyM1vbxon5umiGZ4oZkOf87BbF91J8zDMFcxF6hZr5E5G93STJ3G4ZdDmaxvWUtSOobzYBNx5BAQ==
X-Received: by 2002:a63:1a18:0:b0:419:aa0d:4f9c with SMTP id a24-20020a631a18000000b00419aa0d4f9cmr7545826pga.389.1657865874986;
        Thu, 14 Jul 2022 23:17:54 -0700 (PDT)
Received: from cloud-MacBookPro ([2601:646:8201:c2e0:310b:ff49:22f8:d171])
        by smtp.gmail.com with ESMTPSA id 77-20020a621950000000b005289627ae6asm2797161pfz.187.2022.07.14.23.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 23:17:54 -0700 (PDT)
Date:   Thu, 14 Jul 2022 23:17:54 -0700
From:   Binyi Han <dantengknight@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: refine variable name
Message-ID: <20220715061754.GA6657@cloud-MacBookPro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tmp as a variable name don't have much information, change tmp to dma.

Signed-off-by: Binyi Han <dantengknight@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 4b166c66cfc5..58d1920c4347 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2955,7 +2955,7 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 	void __iomem *doorbell_area =
 		qdev->doorbell_area + (DB_PAGE_SIZE * (128 + rx_ring->cq_id));
 	int err = 0;
-	u64 tmp;
+	u64 dma;
 	__le64 *base_indirect_ptr;
 	int page_entries;
 
@@ -3004,14 +3004,14 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 		FLAGS_LI;		/* Load irq delay values */
 	if (rx_ring->cq_id < qdev->rss_ring_count) {
 		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
-		tmp = (u64)rx_ring->lbq.base_dma;
+		dma = (u64)rx_ring->lbq.base_dma;
 		base_indirect_ptr = rx_ring->lbq.base_indirect;
 
 		for (page_entries = 0;
 		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
 		     page_entries++) {
-			base_indirect_ptr[page_entries] = cpu_to_le64(tmp);
-			tmp += DB_PAGE_SIZE;
+			base_indirect_ptr[page_entries] = cpu_to_le64(dma);
+			dma += DB_PAGE_SIZE;
 		}
 		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
 		cqicb->lbq_buf_size =
@@ -3021,14 +3021,14 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 		rx_ring->lbq.next_to_clean = 0;
 
 		cqicb->flags |= FLAGS_LS;	/* Load sbq values */
-		tmp = (u64)rx_ring->sbq.base_dma;
+		dma = (u64)rx_ring->sbq.base_dma;
 		base_indirect_ptr = rx_ring->sbq.base_indirect;
 
 		for (page_entries = 0;
 		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
 		     page_entries++) {
-			base_indirect_ptr[page_entries] = cpu_to_le64(tmp);
-			tmp += DB_PAGE_SIZE;
+			base_indirect_ptr[page_entries] = cpu_to_le64(dma);
+			dma += DB_PAGE_SIZE;
 		}
 		cqicb->sbq_addr =
 			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
-- 
2.25.1

