Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA45D483CC9
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiADHbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:31:40 -0500
Received: from marcansoft.com ([212.63.210.85]:47272 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233595AbiADHbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 02:31:23 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id C917041F5D;
        Tue,  4 Jan 2022 07:31:13 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH v2 27/35] brcmfmac: pcie: Add IDs/properties for BCM4387
Date:   Tue,  4 Jan 2022 16:26:50 +0900
Message-Id: <20220104072658.69756-28-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This chip is present on Apple M1 Pro/Max (t600x) platforms:

* maldives   (apple,j314s): MacBook Pro (14-inch, M1 Pro, 2021)
* maldives   (apple,j314c): MacBook Pro (14-inch, M1 Max, 2021)
* madagascar (apple,j316s): MacBook Pro (16-inch, M1 Pro, 2021)
* madagascar (apple,j316c): MacBook Pro (16-inch, M1 Max, 2021)

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 8 ++++++++
 .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index cfa93e3ef1a1..3958fc4450ca 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -742,6 +742,8 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 		return 0x170000;
 	case BRCM_CC_4378_CHIP_ID:
 		return 0x352000;
+	case BRCM_CC_4387_CHIP_ID:
+		return 0x740000;
 	default:
 		brcmf_err("unknown chip: %s\n", ci->pub.name);
 		break;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index e4f2aff3c0d5..0d76440ec228 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -63,6 +63,7 @@ BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
 BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
 BRCMF_FW_CLM_DEF(4377B3, "brcmfmac4377b3-pcie");
 BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
+BRCMF_FW_CLM_DEF(4387C2, "brcmfmac4387c2-pcie");
 
 /* firmware config files */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
@@ -96,6 +97,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
 	BRCMF_FW_ENTRY(BRCM_CC_4377_CHIP_ID, 0xFFFFFFFF, 4377B3), /* 4 */
 	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* 3 */
+	BRCMF_FW_ENTRY(BRCM_CC_4387_CHIP_ID, 0xFFFFFFFF, 4387C2), /* 7 */
 };
 
 #define BRCMF_PCIE_FW_UP_TIMEOUT		5000 /* msec */
@@ -2064,6 +2066,11 @@ static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
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
@@ -2566,6 +2573,7 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4371_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4377_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4378_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4387_DEVICE_ID),
 	{ /* end: all zeroes */ }
 };
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 54d7ec515e1d..3d6c803fbec5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -53,6 +53,7 @@
 #define BRCM_CC_4371_CHIP_ID		0x4371
 #define BRCM_CC_4377_CHIP_ID		0x4377
 #define BRCM_CC_4378_CHIP_ID		0x4378
+#define BRCM_CC_4387_CHIP_ID		0x4387
 #define CY_CC_4373_CHIP_ID		0x4373
 #define CY_CC_43012_CHIP_ID		43012
 #define CY_CC_43752_CHIP_ID		43752
@@ -91,6 +92,7 @@
 #define BRCM_PCIE_4371_DEVICE_ID	0x440d
 #define BRCM_PCIE_4377_DEVICE_ID	0x4488
 #define BRCM_PCIE_4378_DEVICE_ID	0x4425
+#define BRCM_PCIE_4387_DEVICE_ID	0x4433
 
 
 /* brcmsmac IDs */
-- 
2.33.0

