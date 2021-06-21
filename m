Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D283AEA7D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFUNyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhFUNyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:54:23 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A63C061760;
        Mon, 21 Jun 2021 06:52:08 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v12so8593575plo.10;
        Mon, 21 Jun 2021 06:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GecS0/ehd6+JUFAcJrnC4SQJD8ZCoGcVouB3TgYaaMw=;
        b=qqkvx3EdQ8jAojsPlNTBSw6SapC3waBuxhu8qGo/sbsMrcvanDpY7oSUAr2ON/ORnW
         TdY9Uut89tDIXaOD/x5V8j5xYPE+ARcXmZiIBHS2GeAbjHYd11MqSAVOym+w9rDOKduB
         pAGStPjSfAB8y/cC4rqXZVSvyyo+w/YawcNluwBNUCI5jHuZBpeLivV+/IlCN2HBhcH1
         af1evMKETvSYljuyll2g/1R87b+/wTH/jPnhTmzgtq2qnpFiYtOe7jxM9RMWWIV9uaAe
         /G2epTPrgkPJiLtnWVbjjKLQN8VC22sMEroeAOMPsddpHOgCDW8KESzp7ZE6ZcuSxcBL
         rIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GecS0/ehd6+JUFAcJrnC4SQJD8ZCoGcVouB3TgYaaMw=;
        b=JOkMAje48hGoi8VUuDXY28EODt1f+SpMxrP892DrTPdhqNwlWleMJDN09ImuroxRbK
         fckynUZNUfXFvdTk2PgLo1lRIQ2tJE5gOE1UhdgvlZ8/VIlNcxh1YE/pkgRZmnpjmI4H
         bG0iyaTyp/GbiF/3npCvtCo+zc5XN6Vim6/Y97xlF3Sn4Kcmqd5tpTD02ahzQuJ/sdae
         fB4Jcw3lrGP1DRcDZ91MY8YEppPXypOwouGWIbMW61azuHAoOPfozUdBJlq+sWyMfIsI
         1FXB53jKSettVuSY6suLm0O6mImtSR5CHXOGuczF/VwpV/xCWlO/WXawKMc7HxXX3Hsq
         97Og==
X-Gm-Message-State: AOAM531zVG/UfQ0L7b7Th6Gg0KoW6A6+wBzxFnELOfCFTEttuJQBVcfe
        5+Bi7JH+Vj0l2Ca0yxpOlWw=
X-Google-Smtp-Source: ABdhPJwlEScElw9RbXC0NE4tPYBHMMj/4R4m2P6GWxgQLiqqhXYOGRJxmE63HWFoRstvQvdnUWyUDQ==
X-Received: by 2002:a17:90a:4d86:: with SMTP id m6mr26934502pjh.44.1624283527871;
        Mon, 21 Jun 2021 06:52:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x143sm8488178pfc.6.2021.06.21.06.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:52:07 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 18/19] staging: qlge: fix two indentation issues
Date:   Mon, 21 Jun 2021 21:49:01 +0800
Message-Id: <20210621134902.83587-19-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two indentation issues.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO        |  1 -
 drivers/staging/qlge/qlge_dbg.c  | 30 +++++++++++++++---------------
 drivers/staging/qlge/qlge_main.c |  4 ++--
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index b8def0c70614..7e466a0f7771 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -1,5 +1,4 @@
 * the driver has a habit of using runtime checks where compile time checks are
   possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
 * remove duplicate and useless comments
-* fix weird indentation (all over, ex. the for loops in qlge_get_stats())
 * fix checkpatch issues
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index d093e6c9f19c..d4d486f99549 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -353,21 +353,21 @@ static int qlge_get_xgmac_regs(struct qlge_adapter *qdev, u32 *buf,
 		 */
 		if ((i == 0x00000114) ||
 		    (i == 0x00000118) ||
-			(i == 0x0000013c) ||
-			(i == 0x00000140) ||
-			(i > 0x00000150 && i < 0x000001fc) ||
-			(i > 0x00000278 && i < 0x000002a0) ||
-			(i > 0x000002c0 && i < 0x000002cf) ||
-			(i > 0x000002dc && i < 0x000002f0) ||
-			(i > 0x000003c8 && i < 0x00000400) ||
-			(i > 0x00000400 && i < 0x00000410) ||
-			(i > 0x00000410 && i < 0x00000420) ||
-			(i > 0x00000420 && i < 0x00000430) ||
-			(i > 0x00000430 && i < 0x00000440) ||
-			(i > 0x00000440 && i < 0x00000450) ||
-			(i > 0x00000450 && i < 0x00000500) ||
-			(i > 0x0000054c && i < 0x00000568) ||
-			(i > 0x000005c8 && i < 0x00000600)) {
+		    (i == 0x0000013c) ||
+		    (i == 0x00000140) ||
+		    (i > 0x00000150 && i < 0x000001fc) ||
+		    (i > 0x00000278 && i < 0x000002a0) ||
+		    (i > 0x000002c0 && i < 0x000002cf) ||
+		    (i > 0x000002dc && i < 0x000002f0) ||
+		    (i > 0x000003c8 && i < 0x00000400) ||
+		    (i > 0x00000400 && i < 0x00000410) ||
+		    (i > 0x00000410 && i < 0x00000420) ||
+		    (i > 0x00000420 && i < 0x00000430) ||
+		    (i > 0x00000430 && i < 0x00000440) ||
+		    (i > 0x00000440 && i < 0x00000450) ||
+		    (i > 0x00000450 && i < 0x00000500) ||
+		    (i > 0x0000054c && i < 0x00000568) ||
+		    (i > 0x000005c8 && i < 0x00000600)) {
 			if (other_function)
 				status =
 				qlge_read_other_func_xgmac_reg(qdev, i, buf);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 21fb942c2595..7cec2d6c3fea 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -699,8 +699,8 @@ static int qlge_get_8000_flash_params(struct qlge_adapter *qdev)
 
 	status = qlge_validate_flash(qdev,
 				     sizeof(struct flash_params_8000) /
-				   sizeof(u16),
-				   "8000");
+				       sizeof(u16),
+				     "8000");
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev, "Invalid flash.\n");
 		status = -EINVAL;
-- 
2.32.0

