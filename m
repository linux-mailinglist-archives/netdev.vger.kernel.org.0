Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8130756CC59
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 04:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiGJCQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 22:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiGJCQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 22:16:32 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B0E1144B;
        Sat,  9 Jul 2022 19:16:32 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q82so2050743pgq.6;
        Sat, 09 Jul 2022 19:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=IBkh7IsZmbFYLN06pIohD0sqXoNpFUpMtpF2eiWgC/c=;
        b=hJEfCZHCjmcvTVedYigK9MS4ZN5U7binqtqQQsqe6KRATruu9vEegw6jZ45Y78iGTM
         jzesCTpvkLZmURTrU5zaSrhUEHyaYtJsYgmDLUJ0cwT+r+yucYw9S1piZKW2L+JHnL7z
         uWI/ZA9n0/z3c2v+VdVTSMbKnwYEE0M6h8J/if/6h7TCTv1DSb+/sAW9lVDof4zKUC97
         jeMQ+T8ieG2c6/+652EthjFfw6NYb92AGJiomMOAV6eM5ZV2SjlIXW+WlurRXY8En7Nn
         fMKVyL1RJxkFYj9MgkQ4Oq6lYQgVr7reF+P5415rASo5Yo2GUbCU4h9wTFZnasmTo6tX
         7tuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=IBkh7IsZmbFYLN06pIohD0sqXoNpFUpMtpF2eiWgC/c=;
        b=40EHSQHk530/T5g8RU7mgqKSLp9LFCSz9xNd+HKw5IQUzlHWqAlmdRpamSWZqN11sP
         xqFwNl1xk3igtYNmbmbqVMLACs7r5qsgoNaAF7+DteUzqTXhYWdo3Dg6r1EFD58/XsTD
         S3ajLDsWmnLOajlSY3ba+ffSPqNS2OTx7Q3YDrBCw4rPlHb2jHGiBm5AKLnpGgDqGm9R
         FVCZIeMUepySHjwvsPXVjJwZlxhfXzyrB2BGOMDkyPOtj7sOgIyOHMQeawOXJnHEzE80
         BVWmBjXKltATDDmTQNlcfY6AjpCYwoF8bRHav2L7hQcBqQFoYH/JP0Kq6tREQbRNXvky
         9ksQ==
X-Gm-Message-State: AJIora9xnpoEcio2bv1m3PHXHovCBIN9VG7afMrbukzXAQMOHNRJDXBV
        jum0IERL8R2UHA0+SOXoMKit4zTSoVKF2w==
X-Google-Smtp-Source: AGRyM1t2Q/yjn10IfRmCt7ORJW55dNab68K9IiJI7QQKCrINWnSYQB5w79KBS22ZEIimzf0wCXUXcQ==
X-Received: by 2002:a05:6a00:188e:b0:52a:b545:559f with SMTP id x14-20020a056a00188e00b0052ab545559fmr8921660pfh.18.1657419391137;
        Sat, 09 Jul 2022 19:16:31 -0700 (PDT)
Received: from cloud-MacBookPro ([2601:646:8201:c2e0:4775:5e6e:8613:5b36])
        by smtp.gmail.com with ESMTPSA id iw5-20020a170903044500b0016bd72887fcsm1946645plb.59.2022.07.09.19.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jul 2022 19:16:30 -0700 (PDT)
Date:   Sat, 9 Jul 2022 19:16:29 -0700
From:   Binyi Han <dantengknight@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: Fix indentation issue under long for loop
Message-ID: <20220710021629.GA11852@cloud-MacBookPro>
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

Fix indentation issue to adhere to Linux kernel coding style.
Issue found by checkpatch.

Signed-off-by: Binyi Han <dantengknight@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 1a378330d775..60c796a64135 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3009,8 +3009,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 
 		for (page_entries = 0; page_entries <
 			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
-				base_indirect_ptr[page_entries] =
-					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
+			base_indirect_ptr[page_entries] =
+				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
 		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
 		cqicb->lbq_buf_size =
 			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
@@ -3024,8 +3024,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 
 		for (page_entries = 0; page_entries <
 			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
-				base_indirect_ptr[page_entries] =
-					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
+			base_indirect_ptr[page_entries] =
+				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
 		cqicb->sbq_addr =
 			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
-- 
2.25.1

