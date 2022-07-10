Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF16F56CDD5
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 10:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiGJIhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 04:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJIg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 04:36:59 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B53B13F26;
        Sun, 10 Jul 2022 01:36:59 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r22so2403990pgr.2;
        Sun, 10 Jul 2022 01:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=xgfLGyj+MHqel88Qroj0JT4kGTyFosjPxfxGSvsimrM=;
        b=fe1Y8UcF38yp8nkqFC42yUpEITrSdSwZC+mso+eprWYcqw3uXsiO2Xwbvu1kvxCXSw
         eRCcYPGiodo276ozuxx3kCxX3fLTSbRTjhZxFTMhfURGfe6f/Dq+ab5Dqptb81UeysY0
         tInyEEL3FtJOw/Bm9I8m1ya84f1MMJfb5M0JS9c83irrLwUQ7iLXCzED/3BmuX5Vj7FL
         VHFk2YkRsZ19ocHaiiqGBOm0HmAo9a6nM2I30xSHdjWNYrnMPpe+Q/vp2QenX8xKq6O/
         X0xTVqJ2LHW/hKM86/GV8KffFJFp8w7AtspCic393pj/U9lV90gF5YUl+OIk2lOmU8Ui
         rMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=xgfLGyj+MHqel88Qroj0JT4kGTyFosjPxfxGSvsimrM=;
        b=p0NUnC5ehz5yaYIgU29B21zyUPlTiwlmAkwDtGFD9Gi36giZHJcLwioOFvPGS9eoao
         yNsiEtl//tGHIYbZOTE8ziGpRCoyUJZcaniIHBo3m1FMdqSRNkR0vg7ZuKRI9nUsNGl5
         fHI9OgmBNvu2LpUkXAkF0EKfm3xBkdLIqeyLfzuO8irje1R9xkqmJ3vqrJbLlZGT7PH9
         zDZzrnfA5/ltUPA33jnlHP2ub18SDH5IvIi3mCGPLA1pc9mXaTAL7WZXDO5kVJni7GK/
         gnnOYbn63GMrOjvDoxX8Iknh8pDxK9usrzndVgELRjY7MQStMn2/OJSmUysNAKZ359Zn
         2vyQ==
X-Gm-Message-State: AJIora9CJChWnpiQhPNqKXla9qmlCSv1DVui7KR6GB9VupIEqB6m4pjv
        ehanI+uEHBIjHUjEQKnc+Mfq4U3U6VeSEA==
X-Google-Smtp-Source: AGRyM1vBZKUETO0vlrimK2WidWHyQw040TOD6YTdp3eOJGXVSJsvNfPQ5WpBLr8P+gyq9Gfn4iz7rQ==
X-Received: by 2002:a63:480b:0:b0:40d:d4d1:7daf with SMTP id v11-20020a63480b000000b0040dd4d17dafmr10933718pga.512.1657442218427;
        Sun, 10 Jul 2022 01:36:58 -0700 (PDT)
Received: from cloud-MacBookPro ([2601:646:8201:c2e0:b884:a80c:dca9:4492])
        by smtp.gmail.com with ESMTPSA id u5-20020a63d345000000b0041245ccb6b1sm2128311pgi.62.2022.07.10.01.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jul 2022 01:36:57 -0700 (PDT)
Date:   Sun, 10 Jul 2022 01:36:57 -0700
From:   Binyi Han <dantengknight@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: qlge: Fix indentation issue under long for loop
Message-ID: <20220710083657.GA3311@cloud-MacBookPro>
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

Fix indentation issue to adhere to Linux kernel coding style,
Issue found by checkpatch. And change the long for loop into 3 lines.

Signed-off-by: Binyi Han <dantengknight@gmail.com>
---
v2:
	- Change the long for loop into 3 lines.

 drivers/staging/qlge/qlge_main.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 1a378330d775..6e771d0e412b 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3007,10 +3007,11 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 		tmp = (u64)rx_ring->lbq.base_dma;
 		base_indirect_ptr = rx_ring->lbq.base_indirect;
 
-		for (page_entries = 0; page_entries <
-			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
-				base_indirect_ptr[page_entries] =
-					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
+		for (page_entries = 0;
+			page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
+			page_entries++)
+			base_indirect_ptr[page_entries] =
+				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
 		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
 		cqicb->lbq_buf_size =
 			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
@@ -3022,10 +3023,11 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 		tmp = (u64)rx_ring->sbq.base_dma;
 		base_indirect_ptr = rx_ring->sbq.base_indirect;
 
-		for (page_entries = 0; page_entries <
-			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
-				base_indirect_ptr[page_entries] =
-					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
+		for (page_entries = 0;
+			page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
+			page_entries++)
+			base_indirect_ptr[page_entries] =
+				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
 		cqicb->sbq_addr =
 			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
-- 
2.25.1

