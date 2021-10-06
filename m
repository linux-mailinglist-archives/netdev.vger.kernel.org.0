Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE944239CE
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 10:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbhJFIeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 04:34:12 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:51250
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237551AbhJFIeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 04:34:11 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 2ACBA3F045;
        Wed,  6 Oct 2021 08:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633509138;
        bh=i7pqd94h/7qZqSjsnCqUp64WqQ62M3udKtVgH1QlXY0=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=fIGo8D9Wb4Jk7Owrre+K9F6b7d8Zg67da3as0qK6DmFvoeQTgboIWbLvh3a+Owdrq
         XQ0L2XFdeNcV7jJRshKfACKxnoEV5hlB2PlqTxJcPkOZfsvivT5QV/Bt7szVwaSeb+
         /6g8cbSOfjLNQCDmRZP7gnjSULaF/SX5Dg+cNcSsX2W+2CYH8HVlWwzFAE3XLhyFsT
         MGA6siYJP6QJNG+PTD2hNOdfn1kbkx2CfEKaE1xVAcID0EY5jbEuVyTAAzqnwNekSc
         FbB0qWUYlsdTgzxG/TcVJWfnGHZcQZeazFoJfv4/viEcfeBBBXaaFxQV3N8x4Zz9Fz
         7bsmBI6NgyIhA==
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: Fix spelling mistake "incompaitiblity" -> "incompatibility"
Date:   Wed,  6 Oct 2021 09:32:17 +0100
Message-Id: <20211006083217.349596-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in an ath11k_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 31f0cfba5bf5..89ab2fa7557c 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -7081,7 +7081,7 @@ ath11k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 
 		if (!ath11k_mac_validate_vht_he_fixed_rate_settings(ar, band, mask))
 			ath11k_warn(ar->ab,
-				    "could not update fixed rate settings to all peers due to mcs/nss incompaitiblity\n");
+				    "could not update fixed rate settings to all peers due to mcs/nss incompatibility\n");
 		nss = min_t(u32, ar->num_tx_chains,
 			    max(max(ath11k_mac_max_ht_nss(ht_mcs_mask),
 				    ath11k_mac_max_vht_nss(vht_mcs_mask)),
-- 
2.32.0

