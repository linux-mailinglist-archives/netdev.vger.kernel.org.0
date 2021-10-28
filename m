Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5323843D9BF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 05:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhJ1DS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 23:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhJ1DS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 23:18:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E073BC061570;
        Wed, 27 Oct 2021 20:16:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so6870390pje.0;
        Wed, 27 Oct 2021 20:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQFH6LpwUVgQz3kdbCMnzkuHN/OwYSwPtbUfSLUuNFY=;
        b=WjiZgL17+2uBuK14CiicqiXU0j7MygUmgn059rnhDNcFBzlhMR1umKvuqxOyf9LVH8
         ofIL+u7rfhM6PzlnXOJJONawu2Vibvw9d0zDmGyyMNExU6jdqV/8TEJk4cLsLe21OjlB
         VWurTjeISFd2xf5OxTJE0w7b0OoXiqrlVQLjTUmymQnLrQ7ksPjHgz7g3EPX7WvEsakH
         EaHCeLhJA6U1DvwRkNcQxePJgfOc0Sw1pvR3JldA1BYTs7O5PSdizBRFOnxBXxd1JPEO
         0wPi9mcRrgsUStSmYYfzu9x2V6RlpMmskF812sTuxugSWe4ho8dykDtkep0xLmEqzSOL
         QQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GQFH6LpwUVgQz3kdbCMnzkuHN/OwYSwPtbUfSLUuNFY=;
        b=tqZbN09yu4VrivDi5sJG+jX/SAahAb0rPoj7LishQWHwpk9pW0vNjd13NtT299rCEC
         Ya8l3pdFX3wN0iH6BNcmmwP1MFRThhbry2yQOezgDBW9lZFNP2sjCFgRjKHTeF7OaLRP
         qectVXJbw/iIx4akDgICj2GZ/qK4Wf0xsJfH37DrEVAZa0tupj/QsqQLJh6cmAhZENSV
         4ZBKi5rkXmMcdhMzV+DpYVNMH5oSjzNs598JryaL5Zqb4WK1keJV7jUfPFKDMORyHkWJ
         Mxw0cQ9kgvwelWF5ZlYnAMyQGRetS08Otntcgg2MPR5siEVbqTP9w+FonbvLD2rkidXa
         O/zw==
X-Gm-Message-State: AOAM532PF9MGcHY8a41Ntqusi6IR+bIxOz41nMZgQ+MNKdBOOk9atCPr
        sFjRbEh/0fuDpS6/Yrjtlk4=
X-Google-Smtp-Source: ABdhPJx1iYljgq7f4n077sGS0zwAMJYLUVXXwm5FM6o0BWuNtQzT80Cu4l81BNSBLUQmOJRak61U3w==
X-Received: by 2002:a17:90a:ff91:: with SMTP id hf17mr1779002pjb.50.1635390960313;
        Wed, 27 Oct 2021 20:16:00 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id v13sm1032201pgt.7.2021.10.27.20.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 20:16:00 -0700 (PDT)
From:   luo penghao <cgel.zte@gmail.com>
X-Google-Original-From: luo penghao <luo.penghao@zte.com.cn>
To:     Mirko Lindner <mlindner@marvell.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH ipsec-next v2] sky2: Remove redundant assignment and parentheses
Date:   Thu, 28 Oct 2021 03:15:51 +0000
Message-Id: <20211028031551.11209-1-luo.penghao@zte.com.cn>
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

Changes in v2:

modify title category:octeontx2-af to sky2.
delete the inner parentheses.

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


