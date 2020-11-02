Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A932A2941
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgKBL05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbgKBLY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:56 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB37C061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:55 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id k10so12798841wrw.13
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=phz21+N6URi4CcT/YO1+niu4iFcUjLLHLqxB18E2o5Y=;
        b=QfadVdOy9Fl9zbkh80hfIPvPz3gNyuDG3E8PgTyr3iJ6FgsbshhFOmkBOLkPJRM+cS
         EbKUFWAfKl+jS9COFsJZ8VEzm3Ljt/H3BTbFUiAEX8SpXLdLujSUmWNlOOaR996bjO5X
         ZpwGzWoAYJQNQF4ErEXvUD0iJGRGMHnvrO7wF6dkvOHyfE7kMjCF4zK+LHNuOkOZxpep
         pPxsA2NYaA/RjVWsM1+QVNNr25GTO1iv0QHGgOO31mXvatibCudIkTu4BBuclSsU5BKh
         oncw3u9nBbEhDE2UaEnT5Z4Da0r6mOP0590VFKMAGPFGegyvCA0O5p0uOGggx6X0A8k4
         BN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=phz21+N6URi4CcT/YO1+niu4iFcUjLLHLqxB18E2o5Y=;
        b=LOjjV0xWXEadIizwC7PYsn3YBnx/N5TrvBVtmHaATbu8/P9HAl5BH8yDaakMIPpH31
         amJ9Q+gpzgSmv+T05w6ICdT6aeV5fLQ9zwiNWSetZJTpZswxbAQbqeIRRRs9vPbou2cX
         TOAELfY8yu+pyn5Ex0oQthmtxRrU1a/lIrmqia9E0Iqtjkpqo9985/nja/1cu91lwN6U
         rv2E6uvM0HC6fErxZeo6+gRaErHL88KS7OSZ7mtxh5hBiZFkWk5y4SJIMbQjhwhVYRFX
         4SqGaaUHu20PslLTKydf8Ud19bCJf9NpipfmMCOQE0g0JD1YvCUC2Ef1MZb4zyGMAnni
         /1UA==
X-Gm-Message-State: AOAM533tvlXhWaOMPlfOvC/7hUHn1Hf54U0pN9a4gkXO5Lyfz4AH01YY
        TjSFGZVwDAgY4sYWCMscwv04/A==
X-Google-Smtp-Source: ABdhPJzNF5spMxVcMYFSeCHg8D9zRR3jAaylmqt+JUIJZ1DX9Vnz69yq3266Tb3tLFRcshxVfdp2yg==
X-Received: by 2002:adf:9361:: with SMTP id 88mr18815974wro.37.1604316293800;
        Mon, 02 Nov 2020 03:24:53 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:53 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 26/41] rtlwifi: phy: Remove set but unused variable 'bbvalue'
Date:   Mon,  2 Nov 2020 11:23:55 +0000
Message-Id: <20201102112410.1049272-27-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c: In function ‘_rtl8723e_phy_iq_calibrate’:
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c:1150:6: warning: variable ‘bbvalue’ set but not used [-Wunused-but-set-variable]

Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index fa0eed434d4f6..fe9b407dc2aff 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -1147,10 +1147,8 @@ static void _rtl8723e_phy_iq_calibrate(struct ieee80211_hw *hw,
 
 	const u32 retrycount = 2;
 
-	u32 bbvalue;
-
 	if (t == 0) {
-		bbvalue = rtl_get_bbreg(hw, 0x800, MASKDWORD);
+		rtl_get_bbreg(hw, 0x800, MASKDWORD);
 
 		rtl8723_save_adda_registers(hw, adda_reg,
 					    rtlphy->adda_backup, 16);
-- 
2.25.1

