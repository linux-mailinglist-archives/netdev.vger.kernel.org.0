Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DBF31C836
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhBPJlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhBPJk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 04:40:57 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACBEC061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 01:40:17 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id fa16so5353886pjb.1
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 01:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zL9s8JTAaSDRwWN4OXmU1ROilIQfKfzZVPnTeHHab7o=;
        b=ain3WCbyxh+JO3bqOV+wpzmhEyttcDNHlfdUsMep15oicyzb/ru7a2gIzSM5lbaAgP
         VuOdqxqWKnwpkNChHBC1FPRweI+Kqz+nUtx8mD8+xiSVJY+TtGFpO7dWTNIbkzxeNYZs
         fhNnk2u69MOo7JI8JZC9IZgV5xQ2EKMjWh9s6wyu9QqjR8Wa87n3yDf91F/FOukR0ACx
         LUOFNNhMGvDaRs04JagD8qzAj1J3xPqEP+LHKGaguxD7YJ2gu8sT6Fi2ZC4Vaq6wOjVN
         hc/jxVcjGLN6M37CqzDR8iS5mUv7ZyjQ0zoGZ7fvF6iqQGdcDdIf7EDaMpiB1nV7c8bV
         +oVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zL9s8JTAaSDRwWN4OXmU1ROilIQfKfzZVPnTeHHab7o=;
        b=e5IOokCjrOU/GED/VVURj4XtetIV9Zsg2+lKQLQRWA2ZGGQOPDgqAvAqZNF0EX1IHH
         2Gb0h/AR2+lYrIO3hnGWcwaUhM8VVbyC18kIVS70qbXE+XsonCkj604epFa1zxlbqXwH
         gxk7XIZdwvPrIPtmaso31RwpthqEiQCHOYxSUdDiwCH+mhqdFpkKB1J9YqEfbKRtLWxe
         3NFaGEiR+lp7e4ATdiDC1iAnDZc+Ada8EO6ruKUollAQLn+VHg7y2wjbIIIsbM6WDECV
         C8EFiZ/37UH7jGVelrOcdpSF9CcXFELa4togl00KUovtJa3mdS61NBaLpAnuXgm1bkcm
         ml8Q==
X-Gm-Message-State: AOAM530J2slOgnKOQq5hVPeCQbaahuozfdcVQNJZE/mLqwO9b1TR8EKk
        OxqQs9GM+F2zjplznpFTsRs=
X-Google-Smtp-Source: ABdhPJyU+CYT0bv8boOPQFHZO7YA2TXrYi9GWUDMihmzz2gkzSW3PutY8B6aCksL4sbtXqbA6ipwwQ==
X-Received: by 2002:a17:90a:df05:: with SMTP id gp5mr2360768pjb.163.1613468417012;
        Tue, 16 Feb 2021 01:40:17 -0800 (PST)
Received: from ThinkCentre-M83.c.infrastructure-904.internal ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id m10sm2202751pjn.33.2021.02.16.01.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 01:40:16 -0800 (PST)
From:   Du Cheng <ducheng2@gmail.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        Du Cheng <ducheng2@gmail.com>
Subject: [PATCH v4] staging: qlge: fix comment style in qlge_main.c
Date:   Tue, 16 Feb 2021 17:40:12 +0800
Message-Id: <20210216094012.183420-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

align * in block comments on each line

This series of patches is for Task 10 of the Eudyptula Challenge

Signed-off-by: Du Cheng <ducheng2@gmail.com>
---
changes v4:
- move "changes" after triple-tiret

changes v3:
- add SUBSYSTEM in subject line
- add explanation to past version of this patch

changes v2:
- move closing of comment to the same line

changes v1:
- align * in block comments

 drivers/staging/qlge/qlge_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 5516be3af898..2682a0e474bd 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3815,8 +3815,7 @@ static int qlge_adapter_down(struct qlge_adapter *qdev)
 
 	qlge_tx_ring_clean(qdev);
 
-	/* Call netif_napi_del() from common point.
-	*/
+	/* Call netif_napi_del() from common point. */
 	for (i = 0; i < qdev->rss_ring_count; i++)
 		netif_napi_del(&qdev->rx_ring[i].napi);
 
-- 
2.27.0

