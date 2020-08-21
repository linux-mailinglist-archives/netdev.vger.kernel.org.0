Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBCD24CEF5
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgHUHUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728250AbgHUHSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:18:15 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B54C06137D
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:19 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id d16so989300wrq.9
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1SwOdl3qsamQLekmEElFc9JqMKayOsDgTAbLZhvVikk=;
        b=dnImnfFjiDNFfYpg8z5tV2sLsHw86tH7Jc+5orDMUB1MplgaOUwBUiMJ0coiV8t5Kd
         Or89x62EZ7WSqJVpjl7E99tdGFe+lsMtoIH10bCg02O6sO49kSY4rsdAdJVbVlh3TD0n
         DJyysjPrA0/1PGaxfT/LMg2NKe4hbmVZ+Yv9z6bnSvoFmfFGbGbwMYp1E6HayrUv2xtW
         HS9HkdRvxF/37JBgu/O0LgLDthdxhBLW/LweO6uEmAJCnyLhN5NGgZPAYZJvboD4IxOm
         LVzeDQJpHAr3qxOYXxUm78DPtzRAOJKYRfIJOQviyRNQq8V7nG85PDxgJkyPVNN9xHsL
         77cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1SwOdl3qsamQLekmEElFc9JqMKayOsDgTAbLZhvVikk=;
        b=svHjHd2MLCC6QqRdAsrMIdb4RCCuK13hC+q0JKvLGpSA7/sDAkGOaRIHdmfqP4/Az1
         yoBe5oCLDE7vOoM8fAOK229QP8zwg95dMpmv4DE7FuRZ+zYl+4dUVnDfAEG03sMpLRKy
         yu48Zd7PKk60YqRd3RGaHrcxqrjF3RdIF1h4pfXoIcL3Aa2D6npq3sTuX4zpMm9CBFxI
         4jObHsfeUtMESKKrctEnLXggyG/V/I/vWSHAZDcE9gky/Ypp1/33f4+LuNEAgzF6QXPv
         Jz6+4vRuGspHKR0rNeuPzUu0KfaJesFbQSdidF39HqQcZZyjtpXXmLrRRW4frrGEWbbS
         GzMg==
X-Gm-Message-State: AOAM5331fZTmCMEWla5+cUlHcoohho+swcj07NHP6q/Bv92pHjpmBdw8
        6pdEyI5Og1d5ZZnMCyJ/k9V7wQ==
X-Google-Smtp-Source: ABdhPJzJi0T0vD0alFijUDBN82QjCRhNnnHBSeBmNRlzlDy6K5aaLeA4aB21h/7nMVFAL/QHiEZKmA==
X-Received: by 2002:a5d:526d:: with SMTP id l13mr1324804wrc.279.1597994238166;
        Fri, 21 Aug 2020 00:17:18 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:17 -0700 (PDT)
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
Subject: [PATCH 24/32] wireless: brcmfmac: fwsignal: Remove unused variable 'brcmf_fws_prio2fifo'
Date:   Fri, 21 Aug 2020 08:16:36 +0100
Message-Id: <20200821071644.109970-25-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c:504:18: warning: ‘brcmf_fws_prio2fifo’ defined but not used [-Wunused-const-variable=]

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
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 2df6811c066ef..902b2f65d4605 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -498,20 +498,6 @@ struct brcmf_fws_info {
 	bool avoid_queueing;
 };
 
-/*
- * brcmf_fws_prio2fifo - mapping from 802.1d priority to firmware fifo index.
- */
-static const int brcmf_fws_prio2fifo[] = {
-	BRCMF_FWS_FIFO_AC_BE,
-	BRCMF_FWS_FIFO_AC_BK,
-	BRCMF_FWS_FIFO_AC_BK,
-	BRCMF_FWS_FIFO_AC_BE,
-	BRCMF_FWS_FIFO_AC_VI,
-	BRCMF_FWS_FIFO_AC_VI,
-	BRCMF_FWS_FIFO_AC_VO,
-	BRCMF_FWS_FIFO_AC_VO
-};
-
 #define BRCMF_FWS_TLV_DEF(name, id, len) \
 	case BRCMF_FWS_TYPE_ ## name: \
 		return len;
-- 
2.25.1

