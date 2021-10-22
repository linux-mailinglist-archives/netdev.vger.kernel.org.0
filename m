Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7A4437515
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 11:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhJVJzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 05:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhJVJzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 05:55:45 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14896C061764;
        Fri, 22 Oct 2021 02:53:28 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id i5so2336818pla.5;
        Fri, 22 Oct 2021 02:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z6nOP1lwZ+z8CNapkxtzMDg1jYNFiKTrWl52nW3rMjE=;
        b=e7QddlBr7J8kMUrp83JvopWegDYKHDuy52p5f2Ato3Jx9MG5SdxlslMJNCGmn3UYD/
         nvBa4UTxxV07cShTGQdG/jpyHI9Md3ikZpO9heQ//qFGl7inpalwc927TYltgSSrbfcW
         Wm1wvCICw+8LoVUTbaWcN3B8i8ckXPSYl855ZBj8r9zhtKHFaeCyUuCE0VJ5Z9UOQqx/
         vgTIIi/JNG3fHuiPEp9lyYZykVCSpSM+6nfqiKqePAK8KhIfUfEQ6oIs0GkXyTnnt5j8
         K6cTlfajpsYKv2HCO44DKEnws/bzZZTtvIqL8CLCyQPV5GjgOmq5rG39I0RCmdX2z4mg
         YxvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z6nOP1lwZ+z8CNapkxtzMDg1jYNFiKTrWl52nW3rMjE=;
        b=wbzgO5BcXzQvNFrFVFC0gB92+MIMSlCfu65xoe2gXDg3PTRPNFx3N0deuoGbXIDq7J
         7QEXwqVOBpe8XZHipRhLu9nAYe2sPcEnD7XrQkhPZnDL0Y4ovRbibOCbu9lLOA5YPqw0
         Gv3v54ASJY48Z8POkD4Gfiz165mydBf5kt74vl1WANSWjJHrC+O7eMY1f62nL63ARYW5
         RB6K/p/tvLYJjT/cLtxNuxh5WdnmjBLw8ApheICiw1pg8gWEEKHpFApC3FLZwgtVeBmo
         YVoskip6Vp6zgGUyl2LqdFQFBhUX7F1SxG12OuKXDy/7zd/gFtJlmmPr/PG+6bBpPBKd
         OzCg==
X-Gm-Message-State: AOAM531PhdFzRy/qdkQLr+XRdGS0gOEjZ394J4X8XMeQ3O3nbzxUvi2v
        mTJURKrieFIUfuD9GpkOFBI=
X-Google-Smtp-Source: ABdhPJy0vlsKGUGlR07VwMx3HDLDnQdQTrUb+/JWV2e76pZ4fnLku9oWgRT4Fmtg4JQMRDMiy604GA==
X-Received: by 2002:a17:90b:20d2:: with SMTP id ju18mr12901632pjb.66.1634896407680;
        Fri, 22 Oct 2021 02:53:27 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p8sm9785747pfo.112.2021.10.22.02.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 02:53:27 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     SimonHorman <horms@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] octeontx2-af: Remove redundant assignment and parentheses
Date:   Fri, 22 Oct 2021 09:53:21 +0000
Message-Id: <20211022095321.1065922-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable err will be reassigned on subsequent branches, and this
assignment does not perform related value operations. This will cause
the double parentheses to be redundant, so the inner parentheses should
be deleted.

clang_analyzer complains as follows:

drivers/net/ethernet/marvell/sky2.c:4988: warning:

Although the value stored to 'err' is used in the enclosing expression,
the value is never actually read from 'err'.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 drivers/net/ethernet/marvell/sky2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 8b8bff5..33558aa 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4985,7 +4985,7 @@ static int sky2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_master(pdev);
 
 	if (sizeof(dma_addr_t) > sizeof(u32) &&
-	    !(err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))) {
+	    !dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
 		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
 		if (err < 0) {
-- 
2.15.2


