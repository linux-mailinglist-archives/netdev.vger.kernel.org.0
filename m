Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F915347AB
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 02:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344905AbiEZAop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 20:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344799AbiEZAoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 20:44:44 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471389EB44;
        Wed, 25 May 2022 17:44:43 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id w130so586216oig.0;
        Wed, 25 May 2022 17:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fdQx1Xtsb1NB3n1lN87I4lS/eYIeNFY3ILruUMYxFRA=;
        b=YiwttcKUK4K7UqDETF4xVavdYBIikP0ULvgqE0rFq+J5aEQb9aSE8wn0xTJUcmWkaq
         gLYOEzNUmiwEvhUCpEOPwOGFNDvWbTbZqQ0G0eMM5I/ED77qdpbXUtgsygT4qqIQCViq
         oGr8g8MgJSMDdofHyMZ1HwCoANgsmwYTJHJALDMQiEhuhx/nJXvlHfaEpNVvxzK/LamX
         8VeM1Z7v88cizrTqW7fU7CyHWt5r6FWVfYL8lL8xsSs5ZLaQsIv7BpOcyHqvrCLilSQs
         pesziZX+r27iTQlFwriDBZ8UiN7SRg0NNaOF9Nhc84Mym17kUbhLtyDCDoe3mbj5DErH
         CPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fdQx1Xtsb1NB3n1lN87I4lS/eYIeNFY3ILruUMYxFRA=;
        b=eU3sR1qxh0EmwSramaaBHsrrxkw2PLNeu5drfeG3ntfviwUIuY4HioeEM3CHqTrnv4
         QgLmwdWbEYOBPnXF8ImaOsKbr9fczWE/MX1hRwMoNIpM5mfNMwYEoppPz00aVSss9gt5
         gkpWI3zMEQ1tpFanSnQmBw7li8nzNwCHJ7XaXzP3J0kSKeT5MYrmuXsmiGoEqnJOeCJZ
         fQ8DDzc9o8rGCSni9ncb3jNEq3U2Lg898iW6z21nIS8Z+PK869zQYuWoyLpK1ZsPSDwT
         s9NRgFCrLV7WBfPlGREiyYI8JD/PBqkqW+jaDsYcTyxX6qaMl0sZ+qLhwRKKQ+4c9Y2g
         r4SQ==
X-Gm-Message-State: AOAM531V8MLEjIflgmRNb3UeA+3mSCgnPlUhOpnFg4xjwtIwsNbweRnp
        tYukTMi2n1Ypn5JGuhnHba15t72o1h5LOA==
X-Google-Smtp-Source: ABdhPJx/Lqk/KOVFzMeqLTwpaSehRx6dakGixoEkGDBivSaFPEjggnV8MoSchuw4GvPiRNvs5svxBQ==
X-Received: by 2002:a05:6808:1448:b0:326:e239:a490 with SMTP id x8-20020a056808144800b00326e239a490mr6750999oiv.253.1653525882521;
        Wed, 25 May 2022 17:44:42 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:8e74:fc8e:b11f:9d42])
        by smtp.gmail.com with ESMTPSA id d20-20020a056830139400b0060603221261sm70597otq.49.2022.05.25.17.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 17:44:42 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     johannes.berg@intel.com
Cc:     gregory.greenman@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] iwlwifi: pcie: Rename the CAUSE() macro
Date:   Wed, 25 May 2022 21:44:34 -0300
Message-Id: <20220526004434.1160267-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

arch/mips/include/uapi/asm/ptrace.h already defines CAUSE, which
causes a name clash:

drivers/net/wireless/intel/iwlwifi/pcie/trans.c:1093: warning: "CAUSE" redefined

Fix the problem by renaming it to IWLWIFI_CAUSE().

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c1918196427b ("iwlwifi: pcie: simplify MSI-X cause mapping")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 34 +++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 6fc69c42f36e..adc094d9847c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1090,7 +1090,7 @@ struct iwl_causes_list {
 	u8 addr;
 };
 
-#define CAUSE(reg, mask)						\
+#define IWLWIFI_CAUSE(reg, mask)					\
 	{								\
 		.mask_reg = reg,					\
 		.bit = ilog2(mask),					\
@@ -1101,28 +1101,28 @@ struct iwl_causes_list {
 	}
 
 static const struct iwl_causes_list causes_list_common[] = {
-	CAUSE(CSR_MSIX_FH_INT_MASK_AD, MSIX_FH_INT_CAUSES_D2S_CH0_NUM),
-	CAUSE(CSR_MSIX_FH_INT_MASK_AD, MSIX_FH_INT_CAUSES_D2S_CH1_NUM),
-	CAUSE(CSR_MSIX_FH_INT_MASK_AD, MSIX_FH_INT_CAUSES_S2D),
-	CAUSE(CSR_MSIX_FH_INT_MASK_AD, MSIX_FH_INT_CAUSES_FH_ERR),
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_ALIVE),
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_WAKEUP),
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_RESET_DONE),
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_CT_KILL),
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_RF_KILL),
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_PERIODIC),
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_SCD),
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_FH_TX),
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_HW_ERR),
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_HAP),
+	IWLWIFI_CAUSE(CSR_MSIX_FH_INT_MASK_AD, MSIX_FH_INT_CAUSES_D2S_CH0_NUM),
+	IWLWIFI_CAUSE(CSR_MSIX_FH_INT_MASK_AD, MSIX_FH_INT_CAUSES_D2S_CH1_NUM),
+	IWLWIFI_CAUSE(CSR_MSIX_FH_INT_MASK_AD, MSIX_FH_INT_CAUSES_S2D),
+	IWLWIFI_CAUSE(CSR_MSIX_FH_INT_MASK_AD, MSIX_FH_INT_CAUSES_FH_ERR),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_ALIVE),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_WAKEUP),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_RESET_DONE),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_CT_KILL),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_RF_KILL),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_PERIODIC),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_SCD),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_FH_TX),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_HW_ERR),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_HAP),
 };
 
 static const struct iwl_causes_list causes_list_pre_bz[] = {
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_SW_ERR),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_SW_ERR),
 };
 
 static const struct iwl_causes_list causes_list_bz[] = {
-	CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_SW_ERR_BZ),
+	IWLWIFI_CAUSE(CSR_MSIX_HW_INT_MASK_AD, MSIX_HW_INT_CAUSES_REG_SW_ERR_BZ),
 };
 
 static void iwl_pcie_map_list(struct iwl_trans *trans,
-- 
2.25.1

