Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5965E8B91
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 12:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiIXKpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 06:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiIXKpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 06:45:31 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D6E40E09
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 03:45:30 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id e67so2416342pgc.12
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 03:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=XQtmD1kYTWA0kK4vzMRdQp3IUqgbZJuOpl78iMvfgJg=;
        b=FMUsbNfsXtj74D8HJndDTn6TS692PVwW3d6p0sSoEx+UEtDMfFYWc2AEMJwmq6TLp/
         hb9nL4mMgiykNavd2rynA2WQKac8HUBaZExB4LcKguID7eSbPRsbWOl0WF9zK67eIuLu
         b6lIj+XodMLxMnVwgEjloQ+gboSPa2K9P8P6/u5lHoDEpFUXYPlRSdeex9DhAXCOZ6a3
         D15w+ChL1erl4cZWFJ0M12xNRoMe3mVrd8k0upBkq9D5J+Q4YZhYb9tTUDuwRTs4ClK+
         fQ/lhmZBkwLXfiNROdsURFx9FHR8RMP7uB66jtLlXX+p/D5ftcVtNTQRUue8/wdj7q2Q
         E+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=XQtmD1kYTWA0kK4vzMRdQp3IUqgbZJuOpl78iMvfgJg=;
        b=boTD6Q16RsW7EQ5QeAXfjslxJZ78Jt9Xs7I7ZrdTNxlOBinDg1V9BAMCOqpV1jKD7n
         rPHoe0Usd7fb/JzuznJBEPGWH7OKeofivbBIWNsf3ApIiI4jaTNy1C8hfexbNp5duj5j
         SYCsLQwAbL0XxjADaWC4vd6IfVKTj5wiwE2q7n88qNx/yEpYdByho7lPwipwZMs2HCdR
         wNau+HhAJoIWAQYQlL/BVq57lnauIXR2OIuhnjdJkfEEKabx4yqVWJ0x4C1rEmpXrVhf
         hq0JQbeR4G7MyuMChPPMIqi1gRIT+heW7/B70keyTL4pwV5RUMb7ojVLen+C9a33Mg0h
         jTgA==
X-Gm-Message-State: ACrzQf0gI6R8KYPDzGuSM2XHDUJI1q6bRue9XxEEPs2A2vd2V2GFyYxi
        JD54Q2xP541lMyLVrGZC4t6ODpX63aFOyw==
X-Google-Smtp-Source: AMsMyM7qvV712FrkeRUD6TCJS1cYUAnq1jTj3wnHlMyE9YxVR+GO7upDWv3p6+85qxGdEP/C71OklA==
X-Received: by 2002:a05:6a00:c91:b0:540:f165:b049 with SMTP id a17-20020a056a000c9100b00540f165b049mr13643042pfv.76.1664016329392;
        Sat, 24 Sep 2022 03:45:29 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c61:8e50:8ba8:7ad7:f34c:2f5])
        by smtp.gmail.com with ESMTPSA id y18-20020aa78f32000000b0053e56165f42sm8336090pfr.146.2022.09.24.03.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 03:45:28 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     netdev@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, Biao Huang <biao.huang@mediatek.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH net-next] net: stmmac: Minor spell fix related to 'stmmac_clk_csr_set()'
Date:   Sat, 24 Sep 2022 16:15:14 +0530
Message-Id: <20220924104514.1666947-1-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor spell fix related to 'stmmac_clk_csr_set()' inside a
comment used in the 'stmmac_probe_config_dt()' function.

Cc: Biao Huang <biao.huang@mediatek.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 9f5cac4000da..b0b09c77711d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -440,7 +440,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	/* Default to phy auto-detection */
 	plat->phy_addr = -1;
 
-	/* Default to get clk_csr from stmmac_clk_crs_set(),
+	/* Default to get clk_csr from stmmac_clk_csr_set(),
 	 * or get clk_csr from device tree.
 	 */
 	plat->clk_csr = -1;
-- 
2.37.1

