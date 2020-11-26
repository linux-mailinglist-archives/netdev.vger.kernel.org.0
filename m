Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF62F2C55B7
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390394AbgKZNco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389857AbgKZNcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:32:13 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99982C061A49
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:13 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id x22so2152031wmc.5
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O6+Wy4iFDi+o50ayVR/RzqW4RGQ8DgYcSYBAfri+vWM=;
        b=YznWFMVFnrL3SHRm/qzlOafIUlBxNuihoIkIF7OlhyVT4+9ZeyqW9cBmOoMgt7pLyw
         T7hKhHI/quPJlot8cNCu+3XvV04sD7ckvL4b5ap7US4iZezEuhlRmDYVJ7SoTvOp5qLO
         7xEHAZ4XtVDbwKVxICGgNttf3FdsRCRnwDnX9hvuMOXcBxi3c3uBNe/g9coM24UfPtcu
         K6yMTfbLfoEfj5XCdAEZJUvl9hNlWfTWyTwrBvrdPfpgoDLTKHB2/LFDnyF1GTiTZICM
         LqzrCSx4XukGOReSH+dhFXc+XF4vYzetV7RVAW1KexiAbrOKDlH6EAHyOsmRvV8BHtsZ
         cVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O6+Wy4iFDi+o50ayVR/RzqW4RGQ8DgYcSYBAfri+vWM=;
        b=k9LWcr8natEtiQxj6Aipeuw9ah7XPHb1vHP9pzGQsIJ1sFcV9VimYgv/BE2nVyc8I3
         M4wxY/6X0YiB8iqijDjtwO/SehioytNILZy/SLANvpL8Zgr2UN8z6FwSScdHKSrjpFyb
         Hme8wZ5XJPh/TljKZSetqScGqt+6WqlDyEnkThqByS5exxzkU90RxyiqU/9DIIl398qz
         pTKwfhAgwbF36rjiLySEWxyr3UR2b62c/cKgqVDf7Bfwfp/Tv38emnaoo/GVA6rdww6k
         NIsF8G7uGYMUr2DxiwRq2UmSRjY07qdeuqR7UECZfjVTkRbBvAUkBEZMbGWA/7MfX8MM
         CKBA==
X-Gm-Message-State: AOAM532UuBHERzjzIzn/T6KdNiCL8eM4XEveO9pONAgvARHufXP8EDZR
        +RB4D4rSv26bHsi1BORZIFTR/Q==
X-Google-Smtp-Source: ABdhPJyuWp5WvGRoZZgxkoG9Oq62kxy/bru//LJwk7blbiQxWqPZlJHwxTOooVtaPi4kfalsFWJUAQ==
X-Received: by 2002:a1c:ba0b:: with SMTP id k11mr3396548wmf.37.1606397532313;
        Thu, 26 Nov 2020 05:32:12 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id n10sm8701001wrv.77.2020.11.26.05.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:32:11 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 13/17] iwlwifi: iwl-phy-db: Add missing struct member description for 'trans'
Date:   Thu, 26 Nov 2020 13:31:48 +0000
Message-Id: <20201126133152.3211309-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133152.3211309-1-lee.jones@linaro.org>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c:97: warning: Function parameter or member 'trans' not described in 'iwl_phy_db'

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
index ae83cfdb750e6..c9ce270ceee07 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
@@ -79,11 +79,11 @@ struct iwl_phy_db_entry {
  *
  * @cfg: phy configuration.
  * @calib_nch: non channel specific calibration data.
- * @calib_ch: channel specific calibration data.
  * @n_group_papd: number of entries in papd channel group.
  * @calib_ch_group_papd: calibration data related to papd channel group.
  * @n_group_txp: number of entries in tx power channel group.
  * @calib_ch_group_txp: calibration data related to tx power chanel group.
+ * @trans: transport layer
  */
 struct iwl_phy_db {
 	struct iwl_phy_db_entry	cfg;
-- 
2.25.1

