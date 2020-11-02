Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF152A2935
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgKBLYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbgKBLYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:50 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0FAC061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:50 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 205so1376802wma.4
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E25/s2pmN1jYHUWPVit1bHGpEi6jEbn1M/6HbkBpU14=;
        b=y/qfMlkxdFYqOzWrUJ9QNcoitDW3Ls+4vf94dQSMqWvfn4wwGRR2L5xdB8usA2XhFk
         3Wdhz6lNJyMizJWRaGYVClmom69SbhI1us6nc569hYPZ/PJrJXcmnAqKISI9ptls9mu3
         iXXLb0yD2oeeopOC02ORCoa06LltZ0znjUZCC2iZSlq6I3DwdYwxcHzLVkWh2RRrAq5n
         5QPuMNOuSNtDdd8cMDWj33wYmuQAnsMdRBkRQA9YsS2iH5+vjobysZA7syT11w0KLlGe
         eZ/keguqXtxten2A0rmJwXzbe27eVjeIJv7k12JWAhphViJ6ctJOFHZvJyUcL/wW3TvC
         0/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E25/s2pmN1jYHUWPVit1bHGpEi6jEbn1M/6HbkBpU14=;
        b=JQgviTT6CUWNCw+MOk8lpG8W2ehF3o2b/6HJbFAuf+f7YAoimb0rHpzWp1eS2PPV3/
         n2JsX9C456A5/z1UkHWeEdVt0F1sfPWq7fa+7wRiYZJZYxNMyOLgndLDZa5EApZ+UK0n
         GQgrBbpQZiTBLIj0o6A23HywtQk70T1rg7hDGCcrD5mT0Sn1/HAeWZ4e/KUu2ZBQnFKT
         +Wuw1ziYe1MInrpNM6hZwyEJPZ3bRKhYkMz3obJkafuepd/yP6CP1DE5gT22WmAyYdUF
         IQvWeZGgfmtHIURo9fMi/DOcE5yrbZGcDVG8wksi5K13pI5/lIJkNocnZXmIVzhTyKDN
         BEng==
X-Gm-Message-State: AOAM53364/wiq6QnyAC9qV4qV44pPIwmT+oVdjOU4nmUfjjCkSu3vXyh
        TK6bt6QPHFO8f3U93gaOFwaezA==
X-Google-Smtp-Source: ABdhPJxHeWN46kV3sURaqPANCEeiA/IS+Ig/W6m/olDUAvHUcPjp3HuGNwBjIBRHRhFI34Q+V5TZDA==
X-Received: by 2002:a1c:6856:: with SMTP id d83mr18118799wmc.13.1604316289023;
        Mon, 02 Nov 2020 03:24:49 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:48 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 22/41] ath: dfs_pri_detector: Demote zero/half completed kernel-doc headers
Date:   Mon,  2 Nov 2020 11:23:51 +0000
Message-Id: <20201102112410.1049272-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are only a couple of these and none of them are conformant.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/dfs_pri_detector.c:39: warning: Function parameter or member 'head' not described in 'pulse_elem'
 drivers/net/wireless/ath/dfs_pri_detector.c:46: warning: Function parameter or member 'val' not described in 'pde_get_multiple'
 drivers/net/wireless/ath/dfs_pri_detector.c:46: warning: Function parameter or member 'fraction' not described in 'pde_get_multiple'
 drivers/net/wireless/ath/dfs_pri_detector.c:46: warning: Function parameter or member 'tolerance' not described in 'pde_get_multiple'

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/dfs_pri_detector.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/dfs_pri_detector.c b/drivers/net/wireless/ath/dfs_pri_detector.c
index 05b0464c6b92c..d07c454c9c00d 100644
--- a/drivers/net/wireless/ath/dfs_pri_detector.c
+++ b/drivers/net/wireless/ath/dfs_pri_detector.c
@@ -29,18 +29,17 @@ struct ath_dfs_pool_stats global_dfs_pool_stats = {};
 	(MIN + PRI_TOLERANCE == MAX - PRI_TOLERANCE ? \
 	MIN + PRI_TOLERANCE : RUNTIME)
 
-/**
+/*
  * struct pulse_elem - elements in pulse queue
- * @ts: time stamp in usecs
  */
 struct pulse_elem {
 	struct list_head head;
 	u64 ts;
 };
 
-/**
+/*
  * pde_get_multiple() - get number of multiples considering a given tolerance
- * @return factor if abs(val - factor*fraction) <= tolerance, 0 otherwise
+ * Return value: factor if abs(val - factor*fraction) <= tolerance, 0 otherwise
  */
 static u32 pde_get_multiple(u32 val, u32 fraction, u32 tolerance)
 {
@@ -70,7 +69,7 @@ static u32 pde_get_multiple(u32 val, u32 fraction, u32 tolerance)
 	return factor;
 }
 
-/**
+/*
  * DOC: Singleton Pulse and Sequence Pools
  *
  * Instances of pri_sequence and pulse_elem are kept in singleton pools to
-- 
2.25.1

