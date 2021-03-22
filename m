Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FFA343984
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 07:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCVGe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 02:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCVGdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 02:33:55 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D570CC061574;
        Sun, 21 Mar 2021 23:33:54 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id x14so9523357qki.10;
        Sun, 21 Mar 2021 23:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aMT9e9sXdarjd/tWbYJpfTGyoS9GYb67cpZF9NVE1QA=;
        b=oSOcPMIA/8KBiYfyxap5Nkz+Ffz8+boq4NGiivuVLzHOIAPZyljEEBFiR+O5hgeL65
         6Q4UD59KmRQsuTITTYj8jFPjH/5T2J23ZH3fKaPq4Y2ZJu3K5LL4LXal562GtPEIwep1
         rCNBy9UQKhJ8TY7Snuie/XGs3j/ZNKhJM3QTnjQwdLZxuV+5ABB32alP6fwerpW1b5BM
         qHpUsud1xPqUowahS0MyfuqAh9Q6MVQ/o7+ykVt5Wzdyhk9Rtizk4jhsgd5eTbcc2Ee9
         n7yrViKNsb8I62UZBEHl4ynvDRcDAg2AhpvNSv0EOFABX+bPMIWACmyibGQoASfwUZZb
         PbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aMT9e9sXdarjd/tWbYJpfTGyoS9GYb67cpZF9NVE1QA=;
        b=ZIbOs0l1e7g4oD46UKVOmzmCbLXR1YvA3mhJPh253D8mXZb6IxJiXtAg/ipjc3+b0X
         Xy7vah7E5Qn2XV+kK7OAxp2StY/BXSSkd+b5TUmDH2+FRTJPrdl3HKl+KHtsEKal3hIf
         Oke05uFRXEMV5CVBGEjVhq5VmKwxFHvG6LKfD8/DHPWr+y+jXLCpPdbubrZG61euSq/Y
         2OUOD0xRP2kuNVCbu562QR5RtWaU6my9Bq4GLJVa7BoKqKRrBAZq4lMbAeZ/Pwh0jku/
         geikD7BXFYVTvr3UsoZpJjJ6G4ZtreGwDvzG5mxp8PVKH22phLYeiswWupNcsq2pjej7
         /hzw==
X-Gm-Message-State: AOAM533fApKl8YDtsZlUlKwX2dgsi28zkTQns/Q1oag+UOpK0vlIP8rJ
        E9qQnD3TQ8Y87dRoUkSl7E4=
X-Google-Smtp-Source: ABdhPJzGrYCV2DbduDKOyH7Z5Vq04R2W3trl/1O2/kBRToGzC3C9smbHaa+dqRLkc59510W8+D10IA==
X-Received: by 2002:a37:9a05:: with SMTP id c5mr9358037qke.16.1616394834074;
        Sun, 21 Mar 2021 23:33:54 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.40])
        by smtp.gmail.com with ESMTPSA id c5sm10461969qkg.105.2021.03.21.23.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 23:33:53 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: ethernet: Fix a typo
Date:   Mon, 22 Mar 2021 12:03:39 +0530
Message-Id: <20210322063339.3489799-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/datastruture/"data structure"/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index fd3cec8f06ba..79c9c6bd2e4f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -908,7 +908,7 @@ struct mtk_eth {
  * @id:			The number of the MAC
  * @interface:		Interface mode kept for detecting change in hw settings
  * @of_node:		Our devicetree node
- * @hw:			Backpointer to our main datastruture
+ * @hw:			Backpointer to our main data structure
  * @hw_stats:		Packet statistics counter
  */
 struct mtk_mac {
--
2.31.0

