Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76285007FD
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 10:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239542AbiDNILM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 04:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiDNILE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 04:11:04 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FB747396;
        Thu, 14 Apr 2022 01:08:38 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w4so5774894wrg.12;
        Thu, 14 Apr 2022 01:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tx/zMBOLjddkHmbrwkzmuT+90GnJTCLZ7tgbeDO6umk=;
        b=D977sj3KXt6wL/UzY9DpO+6L8paeDsUe4BB7swuP+SiXlsPDeG9hgE9wq+GcnCXsDK
         10Kgak5i0a1f4MMp4k9qytrGgUROPl62y8PlxKe9FLJO82goNThADT6LGSR48SJ7F6/t
         88MDIwKp36FEUww8eiOLFDTk8kGPRNJeQU2fyNZNu6FD+P8QuyIsvvFyQrnd0AS9FKpj
         1DnzG1GnEv7s2Zc1955SVZwRWTOyJOKqD6QqcMTRQK82Tz+PKs+rGjw+w4rysh35qmsd
         ZggISr7aJf3UE+wOQzmY+GL1aBpgqM2mNNi/mt7C3F9WXELtF/ARWXKs9mJa9fu8SVBn
         J0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tx/zMBOLjddkHmbrwkzmuT+90GnJTCLZ7tgbeDO6umk=;
        b=16i+xxQNUrXfKubxyLh8tTK00WoB8frneZteMiGHMyci3w/HT/0LW9RKyrxFDWUbtU
         u8B/Bud+lal2Y3WgXyRbqsQBt5POab5HoShUle3hnDWXyIV0oMImqq2U8hEfdsjbYYsN
         6PgGa6dKOUoldDLFOwlTMdu1UYjYmhBrH7amK+Do0F6y0abP55TEEAAkV/GFmBhi0MUj
         igijla5ThKSO2X4mLq6drsDmLZW9EOJIYLwnvfZmuSLAGs3AfAQKcbIEps3/MXSxQjWO
         rKJGz1CbTB3fa5eCzJ3xp6TGlGA43ppeUW0ukYGrVLjb0YKSoBBSwqGtCMhTbVtdnfJU
         fp0g==
X-Gm-Message-State: AOAM533LfqkxkkNmCEyWkVAAbB/wO1+NOHihDz0dP1QHRu2T8ybKTDW+
        zkSUhFvEP/OxpRnPcayFJAg=
X-Google-Smtp-Source: ABdhPJzH2Wv1o3UrZyadfbu/jCeujblFCffDU03I3Nhk3ovr+BkF6vAwwoLhaGD7M5hAZPhhXCWTeg==
X-Received: by 2002:a05:6000:1a85:b0:205:a234:d0a5 with SMTP id f5-20020a0560001a8500b00205a234d0a5mr1182485wry.126.1649923716182;
        Thu, 14 Apr 2022 01:08:36 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d588a000000b002052e4aaf89sm1101992wrf.80.2022.04.14.01.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 01:08:35 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Veerasenareddy Burru <vburru@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeon_ep: Fix spelling mistake "inerrupts" -> "interrupts"
Date:   Thu, 14 Apr 2022 09:08:34 +0100
Message-Id: <20220414080834.290840-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a dev_info message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index 1e47143c596d..6ad88d0fe43f 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
@@ -487,7 +487,7 @@ static irqreturn_t octep_non_ioq_intr_handler_cn93_pf(void *dev)
 		goto irq_handled;
 	}
 
-	dev_info(&pdev->dev, "Reserved inerrupts raised; Ignore\n");
+	dev_info(&pdev->dev, "Reserved interrupts raised; Ignore\n");
 irq_handled:
 	return IRQ_HANDLED;
 }
-- 
2.35.1

