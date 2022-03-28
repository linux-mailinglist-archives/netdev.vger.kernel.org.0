Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9264EA39C
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 01:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiC1X0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 19:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiC1X0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 19:26:52 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F0FDF07;
        Mon, 28 Mar 2022 16:25:09 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so445627wmp.5;
        Mon, 28 Mar 2022 16:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W2+QnfDLI9bZuB4ejF4uihDFHRYkKKFrKgLbbWsABqo=;
        b=Cizk17/06JtJdVHd89UnYX6XuyelMuYjGc/F0qXSEg5VR3tOMHrG1aUjESEEm62VGy
         9ofWuXHOhFbIZI5/SvKK+eCJcOs7REHjmpXmq6Ylfo6yaYHyxnZTKRgab2Q1y7ZmSRB/
         XC46fCJxrNxB51030MdX3qTU/vLGd2duELlHoVlIDa8xywy579m5caUWJGR7c9QPzTa7
         oJVoJ0I09JDl3ohxL9YQC5bwexPlFN3TM8z44mTiLnGEm9l6eMV+GldjoDM3uPsLpA6M
         Ft13BmrkoNby4riW0U5KyGurYCLDH3gRDDsmq7IzWBzAjMY7hyRTUR7/ry3B5R/obTFp
         ZYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W2+QnfDLI9bZuB4ejF4uihDFHRYkKKFrKgLbbWsABqo=;
        b=0+ULnt9hqRr4FzHkkZUMB1evkOggb8DIMEvtNvqid9NuCjW+GaZaCp/YSEESFL4+B/
         /+X3mUv3ZJmEbZeOKkY0xLI1xv02eWpKYcnvEcXbn+i3r7rkNDni/n4PzufDbmKnEhu5
         W6cXMjrH1FTH5K1m3Kl+ExhG04cEfZKe4HoKCvtSK9vY+li3bj09H3O7+FOkyqe9wl7S
         lZoAj2/bZwe8DOktSs651QfmYWpaqGQduFRTR7WEFjSENhOt9T1hu4MRD99RWMq9i4ak
         nfcVJQFiCHUbtqrBMRKx8X9xq0ajyLLVrpLh0IulvhzdtUbEdWi+oMpFxTiD7gLWjKwC
         NXxw==
X-Gm-Message-State: AOAM532HAjJVyqBuGYX+d1BrGRqbhodsNAbKeJAr3Pz7oM1oqnfnCOHn
        Qgor7dMOzV+pkDZLChyglzz9dZnAbO2Dhw==
X-Google-Smtp-Source: ABdhPJyzqO0kh01/y3eCfZMQUE4yOSBWUcPimLlPZrb+yjgeieDaDEQFBuncHUjuEd5Dsj65Cya78g==
X-Received: by 2002:a7b:c452:0:b0:38c:9146:569 with SMTP id l18-20020a7bc452000000b0038c91460569mr2285041wmi.201.1648509907358;
        Mon, 28 Mar 2022 16:25:07 -0700 (PDT)
Received: from alaa-emad ([41.45.69.52])
        by smtp.gmail.com with ESMTPSA id i10-20020a0560001aca00b00203daf3759asm13945792wry.68.2022.03.28.16.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 16:25:07 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     outreachy@lists.linux.dev
Cc:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH] First Patch: Add Printk to pci.c
Date:   Tue, 29 Mar 2022 01:24:49 +0200
Message-Id: <20220328232449.132550-1-eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

This patch for adding Printk line to ath9k probe function as a task
for Outreachy internship

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index a074e23013c5..e16bdf343a2f 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -892,6 +892,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	int ret = 0;
 	char hw_name[64];
 	int msi_enabled = 0;
+	printk(KERN_DEBUG "I can modify the Linux kernel!\n");
 
 	if (pcim_enable_device(pdev))
 		return -EIO;
-- 
2.35.1

