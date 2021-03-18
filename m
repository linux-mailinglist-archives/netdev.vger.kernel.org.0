Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3B1340F41
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 21:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhCRUhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 16:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhCRUhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 16:37:01 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BC9C06174A;
        Thu, 18 Mar 2021 13:37:01 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id y2so2725458qtw.13;
        Thu, 18 Mar 2021 13:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4KfRMmqBXGMzstF08CYRcyhbe6VbnCZEYFoVoFEOpYs=;
        b=mLJCdXjyS3Ej1b167PhD7u4HuEpYHtYzgdR5dS9CPbztVfk6+PZaO2fN18QACA5aRb
         sjqca8yu2w+MxK6rkUEylNAR8bNPkulyyCXY7uH0F6uAjo+fkgp14VQChGkOtYN/ZqNq
         V+vPttPfTNURKnzuCZ7pirS51tcCry8rSL02bve4CvZ//C3Q1EhErCkzaDLeCh74coI6
         Fxa11EyGGwKjZLrcqpU0/zgUWBEgehSXSaoZQqJ/rktXsNsJ3n+fl3Z4pIpoHw53RAWh
         dDx1pho9nbRfRSVRoaREaZ86d7D6hB1ovVmeQMQthqb+hN17ZIu1dedlsNeuuqmtSN6P
         dYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4KfRMmqBXGMzstF08CYRcyhbe6VbnCZEYFoVoFEOpYs=;
        b=lr/stJeegieWLP4pkYexHKPahEh3aV09dNhlsQarfar8AxVPswTOM47rCoAaI2x+wP
         mlpOXxtZxEAUPkVJfDuK74fJYnbv25hr5SMzMtq0nkV/8dWcWHnrV7ySE1mfEFcKgpfE
         D2CKDaVJEBQSLH/E0/bCOp7/cRC4p57veEutW6G2V+/GYkEZFvBu9jyCjDPVGgfr/A2L
         kU34JXZmBjCxFUgpQIL5o7Xnjx9TUPdl9EoC7ciSZvPYdaGKU2OiXjCCgs1dByqZtvNz
         z7XfgctHsR1VUE+UVBnwef9PmRgkBquriPNF4eywnQ79a9EyGPsrnoqQqIs2yfU6eHzJ
         Km1g==
X-Gm-Message-State: AOAM533na9Ka3MKgksWTDMMGJyyAI7vbHi13Wh+qfxuHmKXWSa/IV7yK
        BmymcNF0faiLKCtVaR/CUQA=
X-Google-Smtp-Source: ABdhPJwfPqdsaYkexMn4Jp5RzGg9P6QDTkDCzjJuuYsUNx8mI03N9GXHmeK5g0SzpGwsuVCtAEhN8g==
X-Received: by 2002:aed:2f65:: with SMTP id l92mr5447244qtd.193.1616099820923;
        Thu, 18 Mar 2021 13:37:00 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.63])
        by smtp.gmail.com with ESMTPSA id f186sm2661320qkj.106.2021.03.18.13.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 13:36:59 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, unixbhaskar@gmail.com,
        gustavoars@kernel.org, yuehaibing@huawei.com,
        vaibhavgupta40@gmail.com, christophe.jaillet@wanadoo.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH V3] ethernet: sun: Fix a typo
Date:   Fri, 19 Mar 2021 02:04:43 +0530
Message-Id: <20210318203443.21708-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/serisouly/seriously/

...plus the sentence construction for better readability.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
  Changes from V2:
  Missed the subject line labeling ..so added

 drivers/net/ethernet/sun/sungem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 58f142ee78a3..9790656cf970 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -1674,8 +1674,8 @@ static void gem_init_phy(struct gem *gp)
 	if (gp->pdev->vendor == PCI_VENDOR_ID_APPLE) {
 		int i;

-		/* Those delay sucks, the HW seem to love them though, I'll
-		 * serisouly consider breaking some locks here to be able
+		/* Those delays sucks, the HW seems to love them though, I'll
+		 * seriously consider breaking some locks here to be able
 		 * to schedule instead
 		 */
 		for (i = 0; i < 3; i++) {
--
2.26.2

