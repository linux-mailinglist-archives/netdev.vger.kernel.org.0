Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF80818B496
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgCSNLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:11:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40958 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbgCSNLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:11:05 -0400
Received: by mail-pg1-f195.google.com with SMTP id t24so1248927pgj.7;
        Thu, 19 Mar 2020 06:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B4nHSl+0pWGmInbe8FQHGu8YA5O/4e10+dn6tS8W63s=;
        b=gbLWcG94Hw5eFr5F713x2ZHuuzXvDsR7HTPfXMj/bIwF+d8ypI7MQ0pyYwa+09U5TZ
         NqzDcIq3rhIlQ4m3ktNvDy5fiWpyluuTk2aj13Vrd5xi/rvbzDOTKr5HnOlQqlMtqq2I
         M30MLa3Mre/tQuTekAAIEmcBZZtLSzzPQpAZxWmDu3aa4Zrs7fadQ+K7/FGUMgA0sb49
         PyYhYjlIHoob0v7+ijdGrXE0Gm8ie9bwPUlzDJXrH7xRsp8cxgd4KmLEzHO+mBmV/t2S
         jn7lhWtnvbAEt837OOgOCRB6KtNhzETY7bPO8q91avv2t4qOmYnjaaHLMF7/VWFOygUJ
         ukTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B4nHSl+0pWGmInbe8FQHGu8YA5O/4e10+dn6tS8W63s=;
        b=Gd/WnK5Id+0kOR8yUmlYcoz0mJ8rcqCJP+ZjVtF0X/hUSsnaLCkO+qvO8hwxO3/8th
         07OwE9rDhdQ1/KzXEzls8CDoPRTCPxt85rARLfpRxPmSgeohfHU0A5PbfrWT42ZCNTbG
         YRdSYkGxpF99JLgriqnDWoXIsYyecEQhmXi1/dPOh+lHsSVJ44YrvBQwV/m1kQ174tKA
         2zqtAKtxYBSuQVZD/tJqFXCrKkgTCsDVPtMSHAwhQ7Cnot3Re9f3C+Q+UNC05TJx7kQu
         CPjE20pQAcsvxLyH3QY/Lty4lK06hk9riHUIwBpW4SrZwLA6z6kb+Xg6Xykqji9wWnnO
         QSKA==
X-Gm-Message-State: ANhLgQ0XUm0vNu0GIZG2vUj7pDaXwWT/eAkoht907q9CN2urT509lFmb
        8Bm496jgDz1X4L6Eq0Whwt4=
X-Google-Smtp-Source: ADFU+vu6U87IPTR0D2iW/QPtoCB5nPrRdEyRPfJY+KBcojiba6nAoCyZgW5BQnWhYb7EwcPvHQuD8w==
X-Received: by 2002:aa7:81c1:: with SMTP id c1mr3943700pfn.236.1584623463897;
        Thu, 19 Mar 2020 06:11:03 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id lt11sm2087682pjb.2.2020.03.19.06.11.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 06:11:03 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org
Cc:     linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH] net: stmmac: dwmac_lib: remove unnecessary checks in dwmac_dma_reset()
Date:   Thu, 19 Mar 2020 21:10:19 +0800
Message-Id: <20200319131019.12829-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it will check the return value of dwmac_dma_reset() in the
stmmac_init_dma_engine() function and report an error if the
return value is not zero. so don't need check here.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
index 688d36095333..cb87d31a99df 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c
@@ -16,19 +16,14 @@
 int dwmac_dma_reset(void __iomem *ioaddr)
 {
 	u32 value = readl(ioaddr + DMA_BUS_MODE);
-	int err;
 
 	/* DMA SW reset */
 	value |= DMA_BUS_MODE_SFT_RESET;
 	writel(value, ioaddr + DMA_BUS_MODE);
 
-	err = readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
+	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
 				 !(value & DMA_BUS_MODE_SFT_RESET),
 				 10000, 100000);
-	if (err)
-		return -EBUSY;
-
-	return 0;
 }
 
 /* CSR1 enables the transmit DMA to check for new descriptor */
-- 
2.25.0

