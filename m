Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872C81EB9C4
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 12:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgFBKo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 06:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgFBKo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 06:44:28 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B400C061A0E;
        Tue,  2 Jun 2020 03:44:24 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n9so1206018plk.1;
        Tue, 02 Jun 2020 03:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H05OVuwlBgrwjdIL249fOEZc54JAKac/tUGyHC08gQs=;
        b=Qv3Td0OKHbhrSjgPbGqNpIAKA6svKHpglY3/U1gOS8lKHtAGsEwtP7zDxMfz/TZiUL
         M6OrU7sdrP4rDUevsQ3bL8Nkj716L5v2mEMoTDF5LFU68rMRxh/q3rSyVZdLd+REmzpW
         oKqIIZ053AkrJwYi/CU67ypkZ7/GMlS3AGKybC0chI/z2EXothcEPyAPIKmkc3VcS3GG
         pxNrJkD7Je35YPJVyJPNN890Ud8VuF36LpGAyecDCYY7p4vwiz1gc9/yAV+EXB6Uehia
         eD8fuA9xFMaGdu5M9kmb2nb2M0Vt7nUxxHXKnWX9NyWu+oiLqbfJDwhR87ezKXjT0WTR
         9fOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H05OVuwlBgrwjdIL249fOEZc54JAKac/tUGyHC08gQs=;
        b=P+j7BHTNJkjKtFtRGA5/VnbM+kQQcjpaJgWTRIF5pUl373Kxzi8HS/YEdhh2lrqH/e
         qtjpJ4Fux4E7uHN4gZmr5At1x+ZrEkqlBAeysIbBV5C4M9rq4lZ3+4PuT9bWpkNbbMWP
         P6PJoUz27HQnNkJGDMrP/TT87BcS/cRjWMfwuZ2pMqRtyOfXGcOFUqmWubTFcwJuOmCc
         YSbHTdOzrNuwaVywftR/8t4m/+az7NkvfWRuInV0Q7E4KNa/Qf9s8cskq16JIUZfe0BM
         xQjL7aD0ZkA6h1klxnhyd15XU5gY+WTuXtl4GgsPn6lmHhJx8xTtUSXvtpJ4czckPaHe
         JwMg==
X-Gm-Message-State: AOAM533lMCQMF9NzSDEakLMVlL3hVICSbWcyUXPh/dKQ1oKFuUNN2aNI
        iZnhv80NSNa/4mVgMZ8uSBXvdjcopXM=
X-Google-Smtp-Source: ABdhPJzXuYCZSWZu64djI+B3rB1TLa7slAy257nEGuURgXUsCEyR63VaznbGh9DGgkKX8FEtRDW1vA==
X-Received: by 2002:a17:902:8204:: with SMTP id x4mr11259413pln.153.1591094663735;
        Tue, 02 Jun 2020 03:44:23 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:189:c86a:7149:74ab:b584:ecf8])
        by smtp.gmail.com with ESMTPSA id s98sm153046pjb.33.2020.06.02.03.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 03:44:23 -0700 (PDT)
From:   Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     aishwaryarj100@gmail.com
Subject: [PATCH] net: stmmac: Drop condition with no effect
Date:   Tue,  2 Jun 2020 16:14:04 +0530
Message-Id: <20200602104405.28851-1-aishwaryarj100@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the "else if" and "else" branch body are identical the
condition has no effect. So removing "else if" condition.

Signed-off-by: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index bcda49dcf619..f59813a0405c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -229,8 +229,6 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WFQ;
 	else if (of_property_read_bool(tx_node, "snps,tx-sched-dwrr"))
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_DWRR;
-	else if (of_property_read_bool(tx_node, "snps,tx-sched-sp"))
-		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;
 	else
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;
 
-- 
2.17.1

