Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBA2572FDF
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbiGMH7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbiGMH73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:59:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754E4E9201;
        Wed, 13 Jul 2022 00:59:27 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a15so10959552pjs.0;
        Wed, 13 Jul 2022 00:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0oTePMGkQusPxTfRasbq41OTlo/RPMc4DdWtmQ7rYdI=;
        b=O8GCZhQ349aaHWamz6zaHbfpvNnmflUWi62fHvlhrY50jV1agZAeymI0maX+F2vohX
         FECd9k1QS+PaQXMv8SS6N3WVnac/uGSSx24swNKV36DnP5RmFlw89TBw9e32h10533ov
         8lnFTdWHu4+TFb5OpWQPzcxA6rrJfEaQH135jcNb9KWG4Y4idC2Et10IlM4/XHR3HIYN
         Sm6fyui2jnID5QlQCUdajqbz2xHR8OUM5OqsC/Vak+r8sJsNVYeEPW1A9VqQNXK/F0+7
         urRt2+4hmw6eXZLmLLE09dDnjLJqvGSnsky+77sSdhGJs6jo+HNQmrGVAxN7o/+0Z5eJ
         A5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0oTePMGkQusPxTfRasbq41OTlo/RPMc4DdWtmQ7rYdI=;
        b=yBWnD6S5jPDUZu4keSzehGs/bFljiRYHwUVmXwU1pZDkOIWEPjHcBvm1lClXRrEepw
         mvG1sngPjWUQNCo7MUkLfazTmpvm90LSnCoLz6v+bZPRLkN+LwSov+4bKIzV1wz5f0sD
         6AlB7B/snsAieVUOz+9xqRxK2OaSZHKwmiNg3aVQzO2FJ1YhmxycDpWgz0HMRf94kliA
         a435sQXmMzX5HzHjrILVxIOfhKrv0V0bI0TMi/K1d8JjxvMtOfX3nRb2s6IIQBpWgBd8
         RZhnlKEwosDOyi+EvempbcINDcxcVoCFhA1diXNSsrFWoqHo3i873wDuqTeHgNlULVDF
         slVQ==
X-Gm-Message-State: AJIora9NBFzKhfl2t2IqmTr0+xdhNw7jcETA0RlJP7zHWmsFrqlHSXPv
        xEh2EJpJV4i+jtV+80S/sLPfMkVFOlRPIQ==
X-Google-Smtp-Source: AGRyM1uhYR1VY3zh1m4MvCqt2wsmgDDd5cu+pxgM0U3BEtEAeqoVJxqiwqD52J5wKnfYU3HGaM3zXA==
X-Received: by 2002:a17:903:1314:b0:16b:e832:7292 with SMTP id iy20-20020a170903131400b0016be8327292mr2047036plb.56.1657699166468;
        Wed, 13 Jul 2022 00:59:26 -0700 (PDT)
Received: from cloud-MacBookPro ([2601:646:8201:c2e0:5ee1:7060:fe1d:88a2])
        by smtp.gmail.com with ESMTPSA id i6-20020a056a00004600b00528bbf8245dsm8211507pfk.79.2022.07.13.00.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 00:59:26 -0700 (PDT)
Date:   Wed, 13 Jul 2022 00:59:25 -0700
From:   Binyi Han <dantengknight@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] staging: qlge: Fix indentation issue under long for
 loop
Message-ID: <4e18dabcce7f589386a33ceed59096aa049779f0.1657697683.git.dantengknight@gmail.com>
References: <cover.1657697683.git.dantengknight@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1657697683.git.dantengknight@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix indentation issue to adhere to Linux kernel coding style, issue
found by checkpatch. And change the long for loop into 3 lines.

Signed-off-by: Binyi Han <dantengknight@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 1a378330d775..5209456edc39 100644
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
+		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
+		     page_entries++)
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
+		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
+		     page_entries++)
+			base_indirect_ptr[page_entries] =
+				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
 		cqicb->sbq_addr =
 			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
-- 
2.25.1

