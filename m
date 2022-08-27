Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3265A33E7
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbiH0CtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiH0CtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:49:23 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F52BE830C;
        Fri, 26 Aug 2022 19:49:20 -0700 (PDT)
Received: from tr.lan (ip-86-49-12-201.bb.vodafone.cz [86.49.12.201])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 358348403D;
        Sat, 27 Aug 2022 04:49:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1661568558;
        bh=CEBsRRBaXwUKr5l8q/KUj3kU5L6sDv5NF7J2tqYw7HM=;
        h=From:To:Cc:Subject:Date:From;
        b=S8opBmoiyDM+PAd08h7d4oqBRoJQzK4MDPlDBKQNh7CsVUT3pV+86Q6Qzy3Nk+qlR
         gYl44SIoItUCcIMKFUO09rpa1aRxUFAfAt1jeW1HVy/hIqAYU+dsQbBKqpKVLgoXz9
         apy8ii1UKKyhsW8gAFYiSTdqZLCW1/9Fdrlv+BAJy5mtJwNbOM1qnb/6VKqiYx/hUk
         +xnp/W5cxTuCy6uM7oMUaDg6QogdwoT/PmFNoASe0xkXneO/PAPtm38Ckadxlqk1iY
         trkRIIxpg36B+4JzQeEVjpF+nyJ3pojbn76nrPIrydRsbJT+LZhb+80SLHlFVbRftP
         GlJWShhRO6oJg==
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH] brcmfmac: add 43439 SDIO ids and initialization
Date:   Sat, 27 Aug 2022 04:49:03 +0200
Message-Id: <20220827024903.617294-1-marex@denx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add HW and SDIO ids for use with the muRata 1YN (Cypress CYW43439).
Add the firmware mapping structures for the CYW43439 chipset.
The 43439 needs some things setup similar to the 43430 chipset.

Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: Arend van Spriel <aspriel@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: SHA-cyfmac-dev-list@infineon.com
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: netdev@vger.kernel.org
To: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c    | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c      | 5 ++++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c   | 3 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c      | 2 ++
 .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h    | 1 +
 include/linux/mmc/sdio_ids.h                                 | 1 +
 6 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index d639bb8b51ae4..d0daef674e728 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -983,6 +983,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_4373),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43012),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_89359),
 	{ /* end: all zeroes */ }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 4ec7773b69064..23295fceb0621 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -641,6 +641,7 @@ static void brcmf_chip_socram_ramsize(struct brcmf_core_priv *sr, u32 *ramsize,
 			*srsize = (32 * 1024);
 		break;
 	case BRCM_CC_43430_CHIP_ID:
+	case CY_CC_43439_CHIP_ID:
 		/* assume sr for now as we can not check
 		 * firmware sr capability at this point.
 		 */
@@ -1258,7 +1259,8 @@ brcmf_chip_cm3_set_passive(struct brcmf_chip_priv *chip)
 	brcmf_chip_resetcore(core, 0, 0, 0);
 
 	/* disable bank #3 remap for this device */
-	if (chip->pub.chip == BRCM_CC_43430_CHIP_ID) {
+	if (chip->pub.chip == BRCM_CC_43430_CHIP_ID ||
+	    chip->pub.chip == CY_CC_43439_CHIP_ID) {
 		sr = container_of(core, struct brcmf_core_priv, pub);
 		brcmf_chip_core_write32(sr, SOCRAMREGOFFS(bankidx), 3);
 		brcmf_chip_core_write32(sr, SOCRAMREGOFFS(bankpda), 0);
@@ -1416,6 +1418,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 		reg = chip->ops->read32(chip->ctx, addr);
 		return (reg & pmu_cc3_mask) != 0;
 	case BRCM_CC_43430_CHIP_ID:
+	case CY_CC_43439_CHIP_ID:
 		addr = CORE_CC_REG(base, sr_control1);
 		reg = chip->ops->read32(chip->ctx, addr);
 		return reg != 0;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index d2ac844e1e9ff..2c2f3e026c136 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -249,7 +249,8 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	memset(&gscan_cfg, 0, sizeof(gscan_cfg));
 	if (drvr->bus_if->chip != BRCM_CC_43430_CHIP_ID &&
 	    drvr->bus_if->chip != BRCM_CC_4345_CHIP_ID &&
-	    drvr->bus_if->chip != BRCM_CC_43454_CHIP_ID)
+	    drvr->bus_if->chip != BRCM_CC_43454_CHIP_ID &&
+	    drvr->bus_if->chip != CY_CC_43439_CHIP_ID)
 		brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
 					  "pfn_gscan_cfg",
 					  &gscan_cfg, sizeof(gscan_cfg));
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 8968809399c7a..d7072009c47f1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -618,6 +618,7 @@ BRCMF_FW_DEF(43430A0, "brcmfmac43430a0-sdio");
 /* Note the names are not postfixed with a1 for backward compatibility */
 BRCMF_FW_CLM_DEF(43430A1, "brcmfmac43430-sdio");
 BRCMF_FW_DEF(43430B0, "brcmfmac43430b0-sdio");
+BRCMF_FW_CLM_DEF(43439, "brcmfmac43439-sdio");
 BRCMF_FW_CLM_DEF(43455, "brcmfmac43455-sdio");
 BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
 BRCMF_FW_CLM_DEF(4354, "brcmfmac4354-sdio");
@@ -657,6 +658,7 @@ static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
 	BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373),
 	BRCMF_FW_ENTRY(CY_CC_43012_CHIP_ID, 0xFFFFFFFF, 43012),
+	BRCMF_FW_ENTRY(CY_CC_43439_CHIP_ID, 0xFFFFFFFF, 43439),
 	BRCMF_FW_ENTRY(CY_CC_43752_CHIP_ID, 0xFFFFFFFF, 43752)
 };
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index ed0b707f0cdfc..1f225cdac9bdd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -53,6 +53,7 @@
 #define BRCM_CC_4371_CHIP_ID		0x4371
 #define CY_CC_4373_CHIP_ID		0x4373
 #define CY_CC_43012_CHIP_ID		43012
+#define CY_CC_43439_CHIP_ID		43439
 #define CY_CC_43752_CHIP_ID		43752
 
 /* USB Device IDs */
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index 53f0efa0bccf1..74f9d9a6d3307 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -74,6 +74,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_43362		0xa962
 #define SDIO_DEVICE_ID_BROADCOM_43364		0xa9a4
 #define SDIO_DEVICE_ID_BROADCOM_43430		0xa9a6
+#define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43439	0xa9af
 #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
 #define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752	0xaae8
 
-- 
2.35.1

