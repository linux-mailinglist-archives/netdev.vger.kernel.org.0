Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C980C398D51
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 16:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhFBOpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230092AbhFBOpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 10:45:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7BF9613BF;
        Wed,  2 Jun 2021 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622644999;
        bh=6hYLmEtJfyj17Pk5FCyvFiZi3GRWNPANkuUiPoffKss=;
        h=From:To:Cc:Subject:Date:From;
        b=E5hNuZK0bX4AptxU9d0sWXEhSHtZZIajx7yEOTCqFhj2INqGeMoHeL8GYKtb2xunP
         K2oCd+TOa+cAmRsFfPaQvAXHCsNxvzat4jkXKqbo1/IwmWZhLE//coH4j7DtL5f6R7
         KQy9As2urUyiGBJdApPXHmQeyWBZ5sHlzJ/kfC4RZtK9I8YcstyU352/bSk/G80mUS
         OUx1AX0IXprm99gKWuP0fxDvTV7IlO9b5i20XHGLnBcjncX9mAEXaEYrYx4U/dCuFn
         YEbM39nbiQ7+ffWTB19KtoWt/s2iJhZ6ONq17a+4fIl8nhESZen1d8Qx+u3Oc/M0Z7
         n5f0fAa8wSIxA==
From:   matthias.bgg@kernel.org
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     brcm80211-dev-list.pdl@broadcom.com,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        netdev@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, Amar Shankar <amsr@cypress.com>,
        ivan.ivanov@suse.com, linux-kernel@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Wright Feng <wright.feng@infineon.com>,
        Remi Depommier <rde@setrix.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>, dmueller@suse.de,
        Matthias Brugger <mbrugger@suse.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] brcmfmac: Delete second brcm folder hierarchy
Date:   Wed,  2 Jun 2021 16:43:05 +0200
Message-Id: <20210602144305.4481-1-matthias.bgg@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

BRCMF_FW_DEFAULT_PATH already defines the brcm folder, delete the second
folder to match with Linux firmware repository layout.

Fixes: 75729e110e68 ("brcmfmac: expose firmware config files through modinfo")
Signed-off-by: Matthias Brugger <mbrugger@suse.com>

---

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 16ed325795a8..b8788d7090a4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -626,8 +626,8 @@ BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
 BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
 
 /* firmware config files */
-MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac*-sdio.*.txt");
-MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcm/brcmfmac*-pcie.*.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.txt");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txt");
 
 static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
-- 
2.31.1

