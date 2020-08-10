Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C653240EBD
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbgHJTPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730125AbgHJTO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 15:14:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA03A22CA1;
        Mon, 10 Aug 2020 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086898;
        bh=RYKXhrn6ZF+MK1Oo2SpdcneoS8H8JLGPx3YQJ8SZw50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShFxMi9gfXmxe9CFYsVdqJ/dFR2fnPvIQz/rTUI06wskmD9mY4yEVA93UuPVHVrqr
         bSJn1o0XdOUlapH+TWakMBd9p6heQKuZ5SISf9LkR8X2lZbyHUwrcr78St72Y0D8Hb
         kz/AENkrUpsQc3TjNhn7QXZk49vLbhDWUABkib/Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/16] brcmfmac: To fix Bss Info flag definition Bug
Date:   Mon, 10 Aug 2020 15:14:36 -0400
Message-Id: <20200810191443.3795581-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191443.3795581-1-sashal@kernel.org>
References: <20200810191443.3795581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>

[ Upstream commit fa3266541b13f390eb35bdbc38ff4a03368be004 ]

Bss info flag definition need to be fixed from 0x2 to 0x4
This flag is for rssi info received on channel.
All Firmware branches defined as 0x4 and this is bug in brcmfmac.

Signed-off-by: Prasanna Kerekoppa <prasanna.kerekoppa@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200604071835.3842-6-wright.feng@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 4320c4cae53e1..7eb9f31dde1a2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -30,7 +30,7 @@
 #define BRCMF_ARP_OL_PEER_AUTO_REPLY	0x00000008
 
 #define	BRCMF_BSS_INFO_VERSION	109 /* curr ver of brcmf_bss_info_le struct */
-#define BRCMF_BSS_RSSI_ON_CHANNEL	0x0002
+#define BRCMF_BSS_RSSI_ON_CHANNEL	0x0004
 
 #define BRCMF_STA_WME              0x00000002      /* WMM association */
 #define BRCMF_STA_AUTHE            0x00000008      /* Authenticated */
-- 
2.25.1

