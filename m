Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707352A5DB5
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 06:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbgKDFYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 00:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgKDFYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 00:24:10 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAA4C061A4D;
        Tue,  3 Nov 2020 21:24:10 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id r186so15604609pgr.0;
        Tue, 03 Nov 2020 21:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=91u4hMKCioER+EVyR6ml/jbfnIzrfjbmRinIZZGx/xk=;
        b=YdrYyZxcjjJt9mRl+pDu6vYGZ6X9OdzKmF9UISwtxNdI1+2wRyPND+EdZsLzMB1eQb
         gPY5BgFTUC8tdjVSathNHE44d2ZYqfAQrViiN+xFKaAXh8Aaim88RGUtvczEd6p3DNWJ
         rVbM9lSgpcgkoYkswuWi7gxMH0VPMZuJu1G0uvtYOUXYeSBzqjkRO9XNY+2BwKgG/60l
         he1PlENgTcr4NyVbAVScMSuh7zOa4ix2a1HA0baZr8aIsdbju959GzbWZKLIg0MiQQzb
         KKkm0p+nGVAWoNHmDRdtT0wnzvN1wUnkgKmhpEYN7ixV0dBbrCop+IHxOT/HsCjwOAWX
         ZIqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=91u4hMKCioER+EVyR6ml/jbfnIzrfjbmRinIZZGx/xk=;
        b=DUbnxZ6k6jqEh38EqZGGw0nOa2Xt66W2N6HfR6gtpc/Io8DrEPRTFH0o5Ls+sHbM8K
         pNPa9/NaErKlG2XZDI+qMRAaQojPbrcUp25kb69ETNF6TNSF+2n9EchZFCN4ty2Ky4gt
         ozwHjSCp2BxlBBxGZcm4WB8lf9TBtcIIJTJ38iO1/GLMKsrOC6bTMeeKPYr/Ef7wBJyw
         a2svu5jOWlutCjkx7OsSh8O2sQBi4YmSclTxm4HOA5+qVO/z+YSZDMUy0xnOLK6oiXd2
         qKIwnEP1+83PJJs93Xi/EV3HhWcRV02oxOS6pUNe1IuSEAFugRHNaLS49IddND+pJbkW
         T/sw==
X-Gm-Message-State: AOAM5319wtvfCI6ckAWztHA3caa4ikj/ttRV8d0Z2anNNx5Bg0evyCux
        rBXlB8qM4cbLt6CnHOSLlg==
X-Google-Smtp-Source: ABdhPJwu0/AM5hs9TYJFACJ9YsbS/FKUL3zVeZ9X/vgkQ8dMsKbSWVHHFANUcPZsDkfjPjp8OMzJVQ==
X-Received: by 2002:aa7:80d9:0:b029:164:be9b:2b13 with SMTP id a25-20020aa780d90000b0290164be9b2b13mr26917386pfn.12.1604467449919;
        Tue, 03 Nov 2020 21:24:09 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id b6sm701778pgq.58.2020.11.03.21.24.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 21:24:09 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     vishal@chelsio.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] cxgb4: Fix the -Wmisleading-indentation warning
Date:   Wed,  4 Nov 2020 13:24:04 +0800
Message-Id: <1604467444-23043-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix the gcc warning:

drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c:2673:9: warning: this 'for' clause does not guard... [-Wmisleading-indentation]
 2673 |         for (i = 0; i < n; ++i) \

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 0273f40b85f7..c24d34a937c8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2671,7 +2671,7 @@ do { \
 	seq_printf(seq, "%-12s", s); \
 	for (i = 0; i < n; ++i) \
 		seq_printf(seq, " %16" fmt_spec, v); \
-		seq_putc(seq, '\n'); \
+	seq_putc(seq, '\n'); \
 } while (0)
 #define S(s, v) S3("s", s, v)
 #define T3(fmt_spec, s, v) S3(fmt_spec, s, tx[i].v)
-- 
2.20.0

