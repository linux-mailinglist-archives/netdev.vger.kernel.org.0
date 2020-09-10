Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029EA263E3F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgIJHOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbgIJG6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:58:45 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF027C06135A
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:17 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id s13so4475898wmh.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=urR5WKC0YHrLgprPWWXo12lMVDtV/KRxTWx7J20eMag=;
        b=Um8KwA1D4nIc4VA3tMizMDPtconF94POnFFEiyvMu3k4y7FSvoND21OeGbm+bAy1J8
         zCnYdcakCq3Jcls8OG7Y2VwajhWCpd9uGplZP7Iy5fdTFfsiU/zmqt5wiV2G/w0MawBz
         c/G2KJLf5RfnXlK7TrwVvC8l1kP98cVggxizpOz8NRXJ4DWpZwqZpxVMnZeIKE/6qlQ1
         j8weuOyLbe/0sPRZtPmPEO3j4sFEFDIgB1GhECyBdRWg3eCqRFp/EUwqOD+n9h5ta+LH
         w63dFMwCRoZ49GopwAJ0zBEgdGHCI9gh0n07yikSfxMDE4IPJK3ZaiTA0+Hjnu1kKcX9
         KUXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=urR5WKC0YHrLgprPWWXo12lMVDtV/KRxTWx7J20eMag=;
        b=YwHSiKxog/zt98WfeTfRBvsAlDP2LDLdejCZPt6gXOls2UfSj6dmNJnukWtDg9gNI3
         N2l+ErxK85V+tHBYk3tjoTZa2WaPX3E0e/WdVh2x/kWglbX5PbqHNM9ksPChpg1UBYtT
         jeYOcs5BX5CpyMrUP+8dVEjOWL9+6hXQKWN2bjBk2d5TiuuYXyG2fmW++Iw2LtCqzvmD
         MlqcslNZZg4IVJk/W67pzTVyrFD/+LXHq9kA6MG17qPIyKvcmzdP+tb9w4sebf1xOGro
         Hu9wufZo7unzKV7cztTOEXWRUOSjQOYBjRw2OtOW/e4hEtFN53AjXUyladqhHp+Dg6S5
         cRYg==
X-Gm-Message-State: AOAM532b/7l3jV1xL2MrbWECG4dAti4/7sPx4D0Qh3tCC1MZgzRimoro
        ypUDi0PHaq6lEcK4Ltv8RUiqGA==
X-Google-Smtp-Source: ABdhPJxYaZw0S2OykKWP/xi8aeTV3d3sGgb6/hcFDB5LlE77WFEV/lB7IJAOO1o93ip40+G7viM1bQ==
X-Received: by 2002:a1c:dd45:: with SMTP id u66mr7042690wmg.117.1599720916617;
        Wed, 09 Sep 2020 23:55:16 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:16 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: [PATCH 20/29] wil6210: pmc: Demote a few nonconformant kernel-doc function headers
Date:   Thu, 10 Sep 2020 07:54:22 +0100
Message-Id: <20200910065431.657636-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/wil6210/pmc.c:43: warning: Function parameter or member 'wil' not described in 'wil_pmc_alloc'
 drivers/net/wireless/ath/wil6210/pmc.c:43: warning: Function parameter or member 'num_descriptors' not described in 'wil_pmc_alloc'
 drivers/net/wireless/ath/wil6210/pmc.c:43: warning: Function parameter or member 'descriptor_size' not described in 'wil_pmc_alloc'
 drivers/net/wireless/ath/wil6210/pmc.c:229: warning: Function parameter or member 'wil' not described in 'wil_pmc_free'
 drivers/net/wireless/ath/wil6210/pmc.c:229: warning: Function parameter or member 'send_pmc_cmd' not described in 'wil_pmc_free'
 drivers/net/wireless/ath/wil6210/pmc.c:307: warning: Function parameter or member 'wil' not described in 'wil_pmc_last_cmd_status'
 drivers/net/wireless/ath/wil6210/pmc.c:320: warning: Function parameter or member 'filp' not described in 'wil_pmc_read'
 drivers/net/wireless/ath/wil6210/pmc.c:320: warning: Function parameter or member 'buf' not described in 'wil_pmc_read'
 drivers/net/wireless/ath/wil6210/pmc.c:320: warning: Function parameter or member 'count' not described in 'wil_pmc_read'
 drivers/net/wireless/ath/wil6210/pmc.c:320: warning: Function parameter or member 'f_pos' not described in 'wil_pmc_read'

Cc: Maya Erez <merez@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: wil6210@qti.qualcomm.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/pmc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pmc.c b/drivers/net/wireless/ath/wil6210/pmc.c
index 9b4ca6b256d26..a2f7b4c1da48d 100644
--- a/drivers/net/wireless/ath/wil6210/pmc.c
+++ b/drivers/net/wireless/ath/wil6210/pmc.c
@@ -29,8 +29,7 @@ void wil_pmc_init(struct wil6210_priv *wil)
 	mutex_init(&wil->pmc.lock);
 }
 
-/**
- * Allocate the physical ring (p-ring) and the required
+/* Allocate the physical ring (p-ring) and the required
  * number of descriptors of required size.
  * Initialize the descriptors as required by pmc dma.
  * The descriptors' buffers dwords are initialized to hold
@@ -221,8 +220,7 @@ void wil_pmc_alloc(struct wil6210_priv *wil,
 	mutex_unlock(&pmc->lock);
 }
 
-/**
- * Traverse the p-ring and release all buffers.
+/* Traverse the p-ring and release all buffers.
  * At the end release the p-ring memory
  */
 void wil_pmc_free(struct wil6210_priv *wil, int send_pmc_cmd)
@@ -299,8 +297,7 @@ void wil_pmc_free(struct wil6210_priv *wil, int send_pmc_cmd)
 	mutex_unlock(&pmc->lock);
 }
 
-/**
- * Status of the last operation requested via debugfs: alloc/free/read.
+/* Status of the last operation requested via debugfs: alloc/free/read.
  * 0 - success or negative errno
  */
 int wil_pmc_last_cmd_status(struct wil6210_priv *wil)
@@ -311,8 +308,7 @@ int wil_pmc_last_cmd_status(struct wil6210_priv *wil)
 	return wil->pmc.last_cmd_status;
 }
 
-/**
- * Read from required position up to the end of current descriptor,
+/* Read from required position up to the end of current descriptor,
  * depends on descriptor size configured during alloc request.
  */
 ssize_t wil_pmc_read(struct file *filp, char __user *buf, size_t count,
-- 
2.25.1

