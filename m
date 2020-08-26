Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F5B252A38
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgHZJgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbgHZJfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:34 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863D1C06136A
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:43 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o4so1108029wrn.0
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EWWkC93UJ7xj7BkZ2b7U7Aw6lomOHNe1aGRj0IYiNWw=;
        b=Ajx7/Kr/e8GtU4LIIPcwjtWRUh0vF1emJA2VjOu2Gia+48u0R30etyRK1i63xNy7L5
         hMXIkmWto3dxWPN8FrOWpBl1pqjQ4dLkksZjPNfxFQVcXIlzVqQH+2wEkDf3NQRTgwJ1
         VU8abeFTBhMh0hlrVZhbR1ni0bThPfgm0f0QKIidxW2P9i7yEtiTPcKCU0bqCScTrdJl
         nxse+3AwcjpD7ic6ZCoxS6GYLOOaAEDg2uwmoAY1N3brpUTSEsFzJ2D3I5FCnyPV8ox1
         A+5T6/V5cMM2kr6bgevVjvMLYEjkqjoDNFOlGSuF/tKcGg5cfarQsONjK+8TnMoSEND/
         FGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EWWkC93UJ7xj7BkZ2b7U7Aw6lomOHNe1aGRj0IYiNWw=;
        b=GXSEJbKiVrwSM25bAfjcLTy8cdnIPkQFFDOXm1nsx63rUT5MSuddw6Ped0vPVPmG8L
         1ubRptfuHo6qLyuO3m1r9R3HCN0VaRRIt51+8S8NktJSncFEofv3m04PMLleU5GPO/ea
         7Iy55RpLyB9hck4l/w5yDCjT5/Qd2OznqaJ3MtVifP+5sDCsO57mHJBwPcZ+jeu30sbz
         jgpNVXjtlCFYganlqx9QyKLOE3/+6IuJ1126Z4vZAL91ai3va+1w1TW4pPcfoA3X8mnV
         T28GBegG/hiHWwCyNOrfk0rywX4Flk5C1q7oPjFl3P4UYhr+rF4fUcnn0+JGEAc0eVeX
         X/Tg==
X-Gm-Message-State: AOAM532kS4pavB5ZrDzJ4ci6wXJ7js5MzQuZju0Kb3b7n+miAIuqAuOT
        cAo1zBLj0PWLG+fnLrGC224YzA==
X-Google-Smtp-Source: ABdhPJyEEniXrXM8b6V6fPBEVaHRa3glrYLaPukKyjYAcSu/RiB5EgJ/+SOPvpFgOZOkfqNpKXLIAA==
X-Received: by 2002:adf:c453:: with SMTP id a19mr1604492wrg.179.1598434482172;
        Wed, 26 Aug 2020 02:34:42 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:41 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH 30/30] wireless: broadcom: brcm80211: phytbl_n: Remove a few unused arrays
Date:   Wed, 26 Aug 2020 10:34:01 +0100
Message-Id: <20200826093401.1458456-31-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_n.c:9218:18: warning: ‘papd_cal_scalars_tbl_core1_rev3’ defined but not used [-Wunused-const-variable=]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_n.c:9151:18: warning: ‘papd_comp_epsilon_tbl_core1_rev3’ defined but not used [-Wunused-const-variable=]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_n.c:9084:18: warning: ‘papd_cal_scalars_tbl_core0_rev3’ defined but not used [-Wunused-const-variable=]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_n.c:9017:18: warning: ‘papd_comp_epsilon_tbl_core0_rev3’ defined but not used [-Wunused-const-variable=]

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../brcm80211/brcmsmac/phy/phytbl_n.c         | 268 ------------------
 1 file changed, 268 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_n.c
index 7607e67d20c75..396d005f4d165 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phytbl_n.c
@@ -9014,274 +9014,6 @@ static const u16 papd_comp_rfpwr_tbl_core1_rev3[] = {
 	0x01d6,
 };
 
-static const u32 papd_comp_epsilon_tbl_core0_rev3[] = {
-	0x00000000,
-	0x00001fa0,
-	0x00019f78,
-	0x0001df7e,
-	0x03fa9f86,
-	0x03fd1f90,
-	0x03fe5f8a,
-	0x03fb1f94,
-	0x03fd9fa0,
-	0x00009f98,
-	0x03fd1fac,
-	0x03ff9fa2,
-	0x03fe9fae,
-	0x00001fae,
-	0x03fddfb4,
-	0x03ff1fb8,
-	0x03ff9fbc,
-	0x03ffdfbe,
-	0x03fe9fc2,
-	0x03fedfc6,
-	0x03fedfc6,
-	0x03ff9fc8,
-	0x03ff5fc6,
-	0x03fedfc2,
-	0x03ff9fc0,
-	0x03ff5fac,
-	0x03ff5fac,
-	0x03ff9fa2,
-	0x03ff9fa6,
-	0x03ff9faa,
-	0x03ff5fb0,
-	0x03ff5fb4,
-	0x03ff1fca,
-	0x03ff5fce,
-	0x03fcdfdc,
-	0x03fb4006,
-	0x00000030,
-	0x03ff808a,
-	0x03ff80da,
-	0x0000016c,
-	0x03ff8318,
-	0x03ff063a,
-	0x03fd8bd6,
-	0x00014ffe,
-	0x00034ffe,
-	0x00034ffe,
-	0x0003cffe,
-	0x00040ffe,
-	0x00040ffe,
-	0x0003cffe,
-	0x0003cffe,
-	0x00020ffe,
-	0x03fe0ffe,
-	0x03fdcffe,
-	0x03f94ffe,
-	0x03f54ffe,
-	0x03f44ffe,
-	0x03ef8ffe,
-	0x03ee0ffe,
-	0x03ebcffe,
-	0x03e8cffe,
-	0x03e74ffe,
-	0x03e4cffe,
-	0x03e38ffe,
-};
-
-static const u32 papd_cal_scalars_tbl_core0_rev3[] = {
-	0x05af005a,
-	0x0571005e,
-	0x05040066,
-	0x04bd006c,
-	0x047d0072,
-	0x04430078,
-	0x03f70081,
-	0x03cb0087,
-	0x03870091,
-	0x035e0098,
-	0x032e00a1,
-	0x030300aa,
-	0x02d800b4,
-	0x02ae00bf,
-	0x028900ca,
-	0x026400d6,
-	0x024100e3,
-	0x022200f0,
-	0x020200ff,
-	0x01e5010e,
-	0x01ca011e,
-	0x01b0012f,
-	0x01990140,
-	0x01830153,
-	0x016c0168,
-	0x0158017d,
-	0x01450193,
-	0x013301ab,
-	0x012101c5,
-	0x011101e0,
-	0x010201fc,
-	0x00f4021a,
-	0x00e6011d,
-	0x00d9012e,
-	0x00cd0140,
-	0x00c20153,
-	0x00b70167,
-	0x00ac017c,
-	0x00a30193,
-	0x009a01ab,
-	0x009101c4,
-	0x008901df,
-	0x008101fb,
-	0x007a0219,
-	0x00730239,
-	0x006d025b,
-	0x0067027e,
-	0x006102a4,
-	0x005c02cc,
-	0x005602f6,
-	0x00520323,
-	0x004d0353,
-	0x00490385,
-	0x004503bb,
-	0x004103f3,
-	0x003d042f,
-	0x003a046f,
-	0x003704b2,
-	0x003404f9,
-	0x00310545,
-	0x002e0596,
-	0x002b05f5,
-	0x00290640,
-	0x002606a4,
-};
-
-static const u32 papd_comp_epsilon_tbl_core1_rev3[] = {
-	0x00000000,
-	0x00001fa0,
-	0x00019f78,
-	0x0001df7e,
-	0x03fa9f86,
-	0x03fd1f90,
-	0x03fe5f8a,
-	0x03fb1f94,
-	0x03fd9fa0,
-	0x00009f98,
-	0x03fd1fac,
-	0x03ff9fa2,
-	0x03fe9fae,
-	0x00001fae,
-	0x03fddfb4,
-	0x03ff1fb8,
-	0x03ff9fbc,
-	0x03ffdfbe,
-	0x03fe9fc2,
-	0x03fedfc6,
-	0x03fedfc6,
-	0x03ff9fc8,
-	0x03ff5fc6,
-	0x03fedfc2,
-	0x03ff9fc0,
-	0x03ff5fac,
-	0x03ff5fac,
-	0x03ff9fa2,
-	0x03ff9fa6,
-	0x03ff9faa,
-	0x03ff5fb0,
-	0x03ff5fb4,
-	0x03ff1fca,
-	0x03ff5fce,
-	0x03fcdfdc,
-	0x03fb4006,
-	0x00000030,
-	0x03ff808a,
-	0x03ff80da,
-	0x0000016c,
-	0x03ff8318,
-	0x03ff063a,
-	0x03fd8bd6,
-	0x00014ffe,
-	0x00034ffe,
-	0x00034ffe,
-	0x0003cffe,
-	0x00040ffe,
-	0x00040ffe,
-	0x0003cffe,
-	0x0003cffe,
-	0x00020ffe,
-	0x03fe0ffe,
-	0x03fdcffe,
-	0x03f94ffe,
-	0x03f54ffe,
-	0x03f44ffe,
-	0x03ef8ffe,
-	0x03ee0ffe,
-	0x03ebcffe,
-	0x03e8cffe,
-	0x03e74ffe,
-	0x03e4cffe,
-	0x03e38ffe,
-};
-
-static const u32 papd_cal_scalars_tbl_core1_rev3[] = {
-	0x05af005a,
-	0x0571005e,
-	0x05040066,
-	0x04bd006c,
-	0x047d0072,
-	0x04430078,
-	0x03f70081,
-	0x03cb0087,
-	0x03870091,
-	0x035e0098,
-	0x032e00a1,
-	0x030300aa,
-	0x02d800b4,
-	0x02ae00bf,
-	0x028900ca,
-	0x026400d6,
-	0x024100e3,
-	0x022200f0,
-	0x020200ff,
-	0x01e5010e,
-	0x01ca011e,
-	0x01b0012f,
-	0x01990140,
-	0x01830153,
-	0x016c0168,
-	0x0158017d,
-	0x01450193,
-	0x013301ab,
-	0x012101c5,
-	0x011101e0,
-	0x010201fc,
-	0x00f4021a,
-	0x00e6011d,
-	0x00d9012e,
-	0x00cd0140,
-	0x00c20153,
-	0x00b70167,
-	0x00ac017c,
-	0x00a30193,
-	0x009a01ab,
-	0x009101c4,
-	0x008901df,
-	0x008101fb,
-	0x007a0219,
-	0x00730239,
-	0x006d025b,
-	0x0067027e,
-	0x006102a4,
-	0x005c02cc,
-	0x005602f6,
-	0x00520323,
-	0x004d0353,
-	0x00490385,
-	0x004503bb,
-	0x004103f3,
-	0x003d042f,
-	0x003a046f,
-	0x003704b2,
-	0x003404f9,
-	0x00310545,
-	0x002e0596,
-	0x002b05f5,
-	0x00290640,
-	0x002606a4,
-};
-
 const struct phytbl_info mimophytbl_info_rev3_volatile[] = {
 	{&ant_swctrl_tbl_rev3, ARRAY_SIZE(ant_swctrl_tbl_rev3), 9, 0, 16},
 };
-- 
2.25.1

