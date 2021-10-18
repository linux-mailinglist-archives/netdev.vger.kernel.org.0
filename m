Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B31C431314
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhJRJSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhJRJS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:18:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBA5C06161C;
        Mon, 18 Oct 2021 02:16:17 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id kk10so11792612pjb.1;
        Mon, 18 Oct 2021 02:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JEWEoZv6sG09goH0sj7RrT+ljFzU3IjCc2+Xvzt0KKQ=;
        b=mftqzN66xs83o46X0hTDP1k9SrsEIfVsvhqKk9/StpA/QVQT+2EF2ddmu+pSp3tdDD
         IKfMzLiK4km6fcTcpB1o7spCnjf0Wk7t05aHrOJvOzYXUQ90+lyYvT/8dHP0dV4IC/w/
         FA9Z8l011OFjo/nRxWbEya06/X8xDqeIUa0TpHiYIpZ4816MTNplQSTqJG+IUu2waDTD
         bAAvwt4QUs4mnw4BbGGnftCUQUM3juk6shGIPhvTb+yAy5nVK9ZVsCBCYl6mg2L+iElF
         IddcaWK7ENaXbMT3ecMz1C4QuYn1rU75lmSnB+O6g9BMaLhxUX88zmzMST2fv971Ww/W
         AGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JEWEoZv6sG09goH0sj7RrT+ljFzU3IjCc2+Xvzt0KKQ=;
        b=Th5eaU/UnQxfUhpsKgBouiiWTO1uXteSYZlGl2mBxWuWsLrNgPjNClZL1BOg3g8hVS
         ev7t+omz4IOqYcuX45TkWuPKl3Ufsy9OLEKVJnOOUvdIJYVrKCnw/5FaU0ZycBiX1lht
         MJ8h4e8JN1eYalXOWSTRN1jOTcZvFRvrITnEu7dumi7mU4SXEc5T4+HfjH8gnybJgYrh
         don5Igpmnlq1oTFfQGNViVSpYygJMSGEZHYqArTbMG0Ji3Pj7ooq+bFVunKhT4aOA6PF
         9JpNleE5VYBVnJnd1iuuF/eFq9yi5oGtpaEpzPlZ6vGT1Fvagu0JRPP9mccDy7z3zqAq
         qwWw==
X-Gm-Message-State: AOAM530/Wa7XFkD9SEtI6bCc+CGS1fSKLawp1o0GQZiJI/8afdt8HxCa
        heUm//6pZCZUTtvgCHYwc5U=
X-Google-Smtp-Source: ABdhPJyFUkmAT5Sy+FzX1OhwIDD9J3kQnq3J3Y8E5yhbFimcCDyz+WhKpBgEdRdb/meHZKn3400TSA==
X-Received: by 2002:a17:90a:930d:: with SMTP id p13mr29935602pjo.171.1634548576936;
        Mon, 18 Oct 2021 02:16:16 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g14sm11990489pgo.88.2021.10.18.02.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:16:16 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     Mirko Lindner <mlindner@marvell.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, penghao luo <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] octeontx2-af: Remove redundant assignment operations
Date:   Mon, 18 Oct 2021 09:16:12 +0000
Message-Id: <20211018091612.858462-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: penghao luo <luo.penghao@zte.com.cn>

the variable err will be reassigned on subsequent branches, and this
assignment does not perform related value operations.

clang_analyzer complains as follows:

drivers/net/ethernet/marvell/sky2.c:4988: warning:

Although the value stored to 'err' is used in the enclosing expression,
the value is never actually read from 'err'.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: penghao luo <luo.penghao@zte.com.cn>
---
 drivers/net/ethernet/marvell/sky2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 3cb9c12..6428ae5 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4907,7 +4907,7 @@ static int sky2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_master(pdev);
 
 	if (sizeof(dma_addr_t) > sizeof(u32) &&
-	    !(err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))) {
+	    !(dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))) {
 		using_dac = 1;
 		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
 		if (err < 0) {
-- 
2.15.2


