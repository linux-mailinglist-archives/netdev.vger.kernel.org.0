Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAA5695F0E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjBNJ1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjBNJ02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:26:28 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4A324119;
        Tue, 14 Feb 2023 01:26:03 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id A8D6241A36;
        Tue, 14 Feb 2023 09:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366761; bh=wqr354dI74nhVTFrWWanYE2I7IO6ek9Aydrpl+q4X/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dCnhJz4POCXuyrTgMt2Br4wu47q4aO9rrxJwnyRWgZ2dI4Xqfw1a6QXttQShH70yu
         7N88sLajcdm4Eo8gCcp2k8SMNOp1EbPXj4gJDd1a24IPevonqRuMAwTY1eZa8WwQIN
         lgAeYw7EXImchmOyzKkRTKH9xyR7oXf8Ti3GgZdogfbOodViXOdiTncRcEd2Wf2QFD
         K0KcHkt9lClMkpAiXsJqs8tl85geYscGs7El0K7eM8DuzZvdykd/02+vLgdFYgG4Kk
         9d5zPCYKzhYJL+Fj6mwk2kPoqYBzZ1hpCaTCH6Zkr++O10rzKZqyY7fxSimkO4ncux
         nBkCDdhRflphQ==
From:   Hector Martin <marcan@marcan.st>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 07/10] brcmfmac: pcie: Add IDs/properties for BCM4387
Date:   Tue, 14 Feb 2023 18:24:20 +0900
Message-Id: <20230214092423.15175-7-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230214091651.10178-1-marcan@marcan.st>
References: <20230214091651.10178-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This chip is present on Apple M1 Pro/Max (t600x) platforms:

* maldives   (apple,j314s): MacBook Pro (14-inch, M1 Pro, 2021)
* maldives   (apple,j314c): MacBook Pro (14-inch, M1 Max, 2021)
* madagascar (apple,j316s): MacBook Pro (16-inch, M1 Pro, 2021)
* madagascar (apple,j316c): MacBook Pro (16-inch, M1 Max, 2021)

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 8 ++++++++
 .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 50e0c015cf43..9f9bf08a70bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -743,6 +743,8 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 		return 0x170000;
 	case BRCM_CC_4378_CHIP_ID:
 		return 0x352000;
+	case BRCM_CC_4387_CHIP_ID:
+		return 0x740000;
 	default:
 		brcmf_err("unknown chip: %s\n", ci->pub.name);
 		break;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index a9b9b2dc62d4..09076a3cc4de 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -66,6 +66,7 @@ BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
 BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
 BRCMF_FW_CLM_DEF(4377B3, "brcmfmac4377b3-pcie");
 BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
+BRCMF_FW_CLM_DEF(4387C2, "brcmfmac4387c2-pcie");
 
 /* firmware config files */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
@@ -100,6 +101,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
 	BRCMF_FW_ENTRY(BRCM_CC_4377_CHIP_ID, 0xFFFFFFFF, 4377B3), /* revision ID 4 */
 	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* revision ID 3 */
+	BRCMF_FW_ENTRY(BRCM_CC_4387_CHIP_ID, 0xFFFFFFFF, 4387C2), /* revision ID 7 */
 };
 
 #define BRCMF_PCIE_FW_UP_TIMEOUT		5000 /* msec */
@@ -2016,6 +2018,11 @@ static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
 		base = 0x1120;
 		words = 0x170;
 		break;
+	case BRCM_CC_4387_CHIP_ID:
+		coreid = BCMA_CORE_GCI;
+		base = 0x113c;
+		words = 0x170;
+		break;
 	default:
 		/* OTP not supported on this chip */
 		return 0;
@@ -2630,6 +2637,7 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43596_DEVICE_ID, CYW),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4377_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4378_DEVICE_ID, WCC),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4387_DEVICE_ID, WCC),
 
 	{ /* end: all zeroes */ }
 };
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 896615f57952..44684bf1b9ac 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -54,6 +54,7 @@
 #define BRCM_CC_4371_CHIP_ID		0x4371
 #define BRCM_CC_4377_CHIP_ID		0x4377
 #define BRCM_CC_4378_CHIP_ID		0x4378
+#define BRCM_CC_4387_CHIP_ID		0x4387
 #define CY_CC_4373_CHIP_ID		0x4373
 #define CY_CC_43012_CHIP_ID		43012
 #define CY_CC_43439_CHIP_ID		43439
@@ -95,6 +96,7 @@
 #define BRCM_PCIE_43596_DEVICE_ID	0x4415
 #define BRCM_PCIE_4377_DEVICE_ID	0x4488
 #define BRCM_PCIE_4378_DEVICE_ID	0x4425
+#define BRCM_PCIE_4387_DEVICE_ID	0x4433
 
 /* brcmsmac IDs */
 #define BCM4313_D11N2G_ID	0x4727	/* 4313 802.11n 2.4G device */
-- 
2.35.1

