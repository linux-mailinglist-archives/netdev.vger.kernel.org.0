Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C100339C44
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 06:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhCMFsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 00:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbhCMFsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 00:48:01 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47028C061574;
        Fri, 12 Mar 2021 21:48:01 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id 73so5594116qtg.13;
        Fri, 12 Mar 2021 21:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jhBE4XOmy9QbuywTB4urIucmZY1A2K2OVeCfbE6T8Ns=;
        b=Jg6HoOGdN2/xZIHDcDgzh2/S1VatjGaf+mAuc4ryH4pJZ4bBwwp/NHall3wAeLIwah
         XyF+Zk07ozU98M2nuTt5T3QIjg/0f3EwINTR9RmYY3z6rlZpy1IP9g5IxaYuTArTblf2
         8eFLwdABSKWcGHLD8RGgHOPHgDSvkefJykn0sRftAI0NqlrioVflr54MHhdgDHiLg+/C
         YL9J+/F6Vk/zgn72fUBe2Oy/0EYunGwWc+QQAO1VWRfLDZ8k8+jRqXjPseJiYo9X+GTH
         nyaD6CTX/oFY5V5qV8iIrxKme7uSd5pLxKty0wf6UaQuQg6Sf98riDO4jqDpDn3TuC2J
         QgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jhBE4XOmy9QbuywTB4urIucmZY1A2K2OVeCfbE6T8Ns=;
        b=UWeSIO5ZMCf2mLZ8a7r2lnB2Ddx2g0zfJGOOHIxRgWQ7gvecaOANuKGjavWIaGtRGQ
         KsnXIq/18ay0pYfyqL0Nn9qkOdAbSAe3gZ53AoRfZFuB7pNs3nIhgzhyrpFhgzBcpKhf
         844iKD+sPgqYEJ8j//fH++B34UQgGZNFpf4SZefWf5GtdIBuq7Nbe2XoTBsGC3+azdln
         TBuXhq2IC+20Itped4651aYynJny8RsF3+i50wRKoHPy6a/Wl+N1xSbR+vaEE+7utjpg
         kHTFu5oDeThuRlJ31/ZACUIpCjZAsbIXooEmfNMXQ0EzoNMO+en0ViB2fRfsXWLM9eY1
         fyyw==
X-Gm-Message-State: AOAM5300lD4UYV0bksmqKPU6p8WcqreTB3V4OCT4iI13FR+z4umMhoda
        PfZb+6JEOu0EmeHEVSLg1YM=
X-Google-Smtp-Source: ABdhPJyZuUaLcZ6qaxwoU8eawp4JOlus36x2r3aBl4GfpOpAy6wc0PMgj+4rM8TbdBgC+gdis4Hwag==
X-Received: by 2002:ac8:6913:: with SMTP id e19mr14949861qtr.78.1615614480609;
        Fri, 12 Mar 2021 21:48:00 -0800 (PST)
Received: from localhost.localdomain ([37.19.198.104])
        by smtp.gmail.com with ESMTPSA id s6sm5533534qtn.15.2021.03.12.21.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 21:48:00 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: ethernet: marvell: Fixed typo in the file sky2.c
Date:   Sat, 13 Mar 2021 11:15:36 +0530
Message-Id: <20210313054536.1182-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/calclation/calculation/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/marvell/sky2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index ebe1406c6e64..18a3db2fd337 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4135,7 +4135,7 @@ static int sky2_set_coalesce(struct net_device *dev,
 /*
  * Hardware is limited to min of 128 and max of 2048 for ring size
  * and  rounded up to next power of two
- * to avoid division in modulus calclation
+ * to avoid division in modulus calculation
  */
 static unsigned long roundup_ring_size(unsigned long pending)
 {
--
2.26.2

