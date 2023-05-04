Return-Path: <netdev+bounces-346-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FDD76F737C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0985F280DF5
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA5CEEA2;
	Thu,  4 May 2023 19:42:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D156EBA51
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D15C433D2;
	Thu,  4 May 2023 19:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229331;
	bh=eVObgVYGaBUCFFfzDGHorAtyuHFPD6PGbq0l1GO/YfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rokXvsmR8bHbP+H+0XYAsqPyazY/mqrgBtkhYiW4PBQCRbTAetgKalyxafw63iMjP
	 KxtyG7x10C7k20JcJo2lrtfCe/1vfAD17CCNSFFC4lD5bdrTlTRykZHMtYkZzKeHpc
	 G1eXufgmE5PII4AXAaXVHtfByzNP7GvJnMNyHPBzn+HYUk8F+3TCqRmk1x9nfYbywJ
	 EcT6jSRzas25Qax2dVMXPCEBwafLOtJsdc30aDnEeW4VwRnB5S0yx34OcFCkfj3YMy
	 UUsk184bticZKnDfMb7D8DMrxIxd2/9D59cE/m/do3oxn2qyN3YmBbkIZaOX6/x5TE
	 Tq3eaWrzkKxmQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Hector Martin <marcan@marcan.st>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	aspriel@gmail.com,
	franky.lin@broadcom.com,
	hante.meuleman@broadcom.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ian.lin@infineon.com,
	alep@cypress.com,
	marex@denx.de,
	rmk+kernel@armlinux.org.uk,
	wright.feng@cypress.com,
	linux-wireless@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com,
	SHA-cyfmac-dev-list@infineon.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 07/59] wifi: brcmfmac: pcie: Add IDs/properties for BCM4387
Date: Thu,  4 May 2023 15:40:50 -0400
Message-Id: <20230504194142.3805425-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 117ace4014cce3fb78b40eb8028bb0f4fc37dd6f ]

This chip is present on Apple M1 Pro/Max (t600x) platforms:

* maldives   (apple,j314s): MacBook Pro (14-inch, M1 Pro, 2021)
* maldives   (apple,j314c): MacBook Pro (14-inch, M1 Max, 2021)
* madagascar (apple,j316s): MacBook Pro (16-inch, M1 Pro, 2021)
* madagascar (apple,j316c): MacBook Pro (16-inch, M1 Max, 2021)

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230214092423.15175-7-marcan@marcan.st
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 8 ++++++++
 .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 8073f31be27d9..9cdbd8d438439 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -737,6 +737,8 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 		return 0x170000;
 	case BRCM_CC_4378_CHIP_ID:
 		return 0x352000;
+	case BRCM_CC_4387_CHIP_ID:
+		return 0x740000;
 	default:
 		brcmf_err("unknown chip: %s\n", ci->pub.name);
 		break;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 2835ef4edb18f..d2dad5414f396 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -67,6 +67,7 @@ BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
 BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
 BRCMF_FW_CLM_DEF(4377B3, "brcmfmac4377b3-pcie");
 BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
+BRCMF_FW_CLM_DEF(4387C2, "brcmfmac4387c2-pcie");
 
 /* firmware config files */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
@@ -101,6 +102,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
 	BRCMF_FW_ENTRY(BRCM_CC_4377_CHIP_ID, 0xFFFFFFFF, 4377B3), /* revision ID 4 */
 	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* revision ID 3 */
+	BRCMF_FW_ENTRY(BRCM_CC_4387_CHIP_ID, 0xFFFFFFFF, 4387C2), /* revision ID 7 */
 };
 
 #define BRCMF_PCIE_FW_UP_TIMEOUT		5000 /* msec */
@@ -2048,6 +2050,11 @@ static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
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
@@ -2662,6 +2669,7 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43596_DEVICE_ID, CYW),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4377_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4378_DEVICE_ID, WCC),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4387_DEVICE_ID, WCC),
 
 	{ /* end: all zeroes */ }
 };
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 896615f579522..44684bf1b9acc 100644
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
2.39.2


