Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B068718B72F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgCSNQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:16:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45390 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729584AbgCSNQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:16:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id m15so1244582pgv.12;
        Thu, 19 Mar 2020 06:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nqJw5vg4Nil/Y9pZjcpy6DTelU/teueaanPhC3c5U58=;
        b=T+cYXbZAHaDkG0GNHDjApa0wSTlshXtBKTVMP29hon48mbyn2rSVvYi8nKMBRhYv9j
         MaKesS8Pu3GoCeHrmfoHRCXKVwIARQ+N1VF8r9mMjrHKehag+deLDFwHqy1/FTUkY05S
         sVFv9NZdiGYRSgp05pOjM0JIVbyLu+ZxdRZxdviw9Je8WpmC/i2tyZNZz+Te2KvU9QW8
         kdwYoB2a2CEZcw/nAJpp1R7rHtdDIZKpe9p5irMpWk6Wzn/6LtM5AysvML1Dnh/9sa3O
         Kr6n9MBkKJjOY7RyLAJSwa7bpppLJSIOzc7Ly3KI+uiKWassksQrMsoh1gxvZTIgRr/o
         pY3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nqJw5vg4Nil/Y9pZjcpy6DTelU/teueaanPhC3c5U58=;
        b=mRFmk+aj2hWGaRIfsxl1SlHTG7xILVvQOW1MX56m29lCcG1f2BSjYjBhZJaKC6Dbm6
         n+pJKY6vx9p2FqpzOHTJJkNxnS3aeQvsoNm6kLqCEvXMdeFGuV0BaRsd2bbAfVd5VpW8
         j7qEzC3g0LP3ST3JgFf83F69+C22i6tkSdCg/ylp6rP+BuSpyYVxZAbeWeBmolGA7LNo
         jxfkqAs5yiPhoA3iKlQb4weVMFzf2XBtiTZe/qUUoyLFr2l1mFSxnjgSmW9CbmvQCxY4
         8JDuQbvjuINghO5aoo3ePmHCqLxACwHR1X5XMjs79c+ffwDgE7rvA7YGj06l+2OYniZ/
         t63A==
X-Gm-Message-State: ANhLgQ0dnfrclRn8/Q46u7sETT+fXd8VC5eug8eICwYBxoozTsS/sjUQ
        sqtPCM5Q1573bVL19JcKVRRk1FOg
X-Google-Smtp-Source: ADFU+vsVUcop1IJD5Y5GJDWMkZo9mIv9UFBUlK2kkpeO2PwWiaR6FToo9iw+OWXW3qnKj5G8oMYMrA==
X-Received: by 2002:a63:fd0d:: with SMTP id d13mr2905382pgh.302.1584623806046;
        Thu, 19 Mar 2020 06:16:46 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id j38sm2383940pgi.51.2020.03.19.06.16.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 06:16:45 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org
Cc:     linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2] net: stmmac: dwmac_lib: remove unnecessary checks in dwmac_dma_reset()
Date:   Thu, 19 Mar 2020 21:16:38 +0800
Message-Id: <20200319131638.12936-1-zhengdejin5@gmail.com>
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
v1 -> v2:
	changed subject-prefix to [PATCH net-next v2] from [PATCH]

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

