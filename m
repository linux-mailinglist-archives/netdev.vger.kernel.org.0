Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2BD360608
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbhDOJkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbhDOJkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:40:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03365C061574;
        Thu, 15 Apr 2021 02:40:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso12375613pjh.2;
        Thu, 15 Apr 2021 02:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9R3f+tBaKWH0fO58cuLf8hfyC5v10OAnFBeJEdo2ghQ=;
        b=EDruGia5eWDwRiWxBWtWscWwBptpi2KyFfBdRW5V2J+MzdUshVRG/GtvcSn7ohfpUX
         bMrKayfjJ4+hwwKu1Xf9Y4rvZB/YWp8XWGsjX2G0HVeo55e89IQpSKJpy8maJHQRXkis
         avyI2ZKMrjyiW17s796c42qtYIoASEtyJ5GS1w5dqBoSnocjgjwde5+KoXvq3xTwAU/7
         U1RdtBQJkBu4ATbXswHdMDsUrrcIkrdlSoUBBYjisCQM62bdOqrvuMKd5136DtZIXyRh
         z548eQhQQEnV3tMr//u56rX+Iy8PdH2dJY0GVUihRrR1foXeYeolQEZd1txhCx9ZHWpS
         3xvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9R3f+tBaKWH0fO58cuLf8hfyC5v10OAnFBeJEdo2ghQ=;
        b=SWXQyHm+mzef5fL9M1SKkQiPqhFSHeRE7hDoYBtS98NOx3wTflrKbmRXMjtVwBXrK3
         5EVscOAinLnziyWr2+hjVNATDk0sKkMed9Mqs+hRyH+hxWMj2oydSZCPn5xpumCLUMvp
         aFTHOwIRj+lNXZbB8z+V2AxsofgSwA6uj2vtvLEEZM+aWPvv7tt0r91+zLyDZAUcP+J1
         47XV/POS0l48BJu27q248hs5CF4Fs+kWydCCo3GLmawzy4JHtDNtD24FHNAJTp/qRmd4
         R5jjbDr+t1X3EaE/CM2YqywntmHzsvpqdJYla0dfQy9brUPMttNjA+7/eWD+ITeEspvW
         5X5A==
X-Gm-Message-State: AOAM533f20nfqSCWu4QaaEKxi/ywOXbcm8p77TBQsSuwa3B8ERwJ+dx1
        c7FjlAZ/TW+JocteW3fAvx8=
X-Google-Smtp-Source: ABdhPJxJ35eJvUhSAcHylNTFoLVFIlGFbKUNz2CUi/2VuSsIYW9FE/0WXaScxDI4AjHU7dmZlBEZJA==
X-Received: by 2002:a17:90a:6c82:: with SMTP id y2mr2929579pjj.142.1618479613629;
        Thu, 15 Apr 2021 02:40:13 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id c4sm834754pfb.94.2021.04.15.02.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 02:40:12 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Alex Ryabchenko <d3adme4t@gmail.com>
Subject: [PATCH net-next] net: ethernet: mediatek: fix typo in offload code
Date:   Thu, 15 Apr 2021 17:40:05 +0800
Message-Id: <20210415094005.2673-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.key_offset was assigned to .head_offset instead. Fix the typo.

Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 4975106fbc42..f47f319f3ae0 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -43,7 +43,7 @@ struct mtk_flow_entry {
 
 static const struct rhashtable_params mtk_flow_ht_params = {
 	.head_offset = offsetof(struct mtk_flow_entry, node),
-	.head_offset = offsetof(struct mtk_flow_entry, cookie),
+	.key_offset = offsetof(struct mtk_flow_entry, cookie),
 	.key_len = sizeof(unsigned long),
 	.automatic_shrinking = true,
 };
-- 
2.25.1

