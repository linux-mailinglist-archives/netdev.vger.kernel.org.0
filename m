Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B58F24972F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgHSH0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgHSHZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:25:28 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257CDC061376
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:30 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a14so20467129wra.5
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w6TC3I8krKBM5ldX8StBAws3TwaUa2AMikeN8S5iGsY=;
        b=oxyhz+i1i14swxFkRxoF7VNenqHo7Ry9oai3r53xO4WDCEUecyMI9XI+6S53RHp+Jn
         GtBzQnZJm1GCX3iKNtCHREc2KZBL0Mhnsjke28npScQnrEZuEaUmIaRUeN7fO/CEUL9T
         ff8XC9Li4ZIZn5oltwBgxxJpZR+c0o58yz/N08vwDQB8HaRm+tteMLrEkVxtibKSJV9U
         DvlNce4ZqMC19oHLUbHtuEhDyKz37+lMwwnVxW3Pr/J/VQtkAAT9nv90ay0zj/0lS0zC
         At0EQqEljSuHFrUM/Tq+GmX+wbmfAjOwqYAjdx+7PiqLFhoJD/lKzGh7qRJQpBC8BCAR
         FU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w6TC3I8krKBM5ldX8StBAws3TwaUa2AMikeN8S5iGsY=;
        b=fpg4ZcU8KfY+LXiZkX98aX6BAwFqP8F0CS6dVS8zwW83JUvY9OLiWmAmxKn3SGSFP9
         hXwBu1N1WcC2OWeAZfdCsuxHvaH3L6PFCPbEt1BPCRROxIt4Vdt0XL3K8jrD++upgjay
         oOLvtrv9TnXBoc9W+3HG0ookoGxxdmo2hAwseZkUwCXPS28p75LLmWM7EWDuOrTkmZUm
         Fmq6GFOO0K7LkWqDd1FFGTTBjbxSGZ/UTSPqS5l7lvVTyXpOgBgtPmfWLJ8XJY8jN+au
         bxO1v786GN6yoWM5m7iUktKaibHUyz6VyEzkhewPTrA9g1N0p/0yWvXU8+QQArzvWAES
         Bu4Q==
X-Gm-Message-State: AOAM531yxlxyXoVdMSD16aF1RnT8qYHFmE31Jya2IOqjqSdo8K+Ya2GS
        Mkj2wjGg390SmhyaWKwrvZKpzA==
X-Google-Smtp-Source: ABdhPJyEl16nd+ZKqidKrjUo+U/ht2oZwR9v2iwZ9pGaRgIKSkGVmtpgxS0vDlhFbO3YoXs+Xa/O3A==
X-Received: by 2002:adf:9e8b:: with SMTP id a11mr23050937wrf.309.1597821868784;
        Wed, 19 Aug 2020 00:24:28 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:28 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 19/28] wireless: intel: iwlwifi: calib: Demote seemingly unintentional kerneldoc header
Date:   Wed, 19 Aug 2020 08:23:53 +0100
Message-Id: <20200819072402.3085022-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the only use of kerneldoc in the sourcefile and no
descriptions are provided.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/dvm/calib.c:770: warning: Function parameter or member 'priv' not described in 'iwl_find_disconn_antenna'
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c:770: warning: Function parameter or member 'average_sig' not described in 'iwl_find_disconn_antenna'
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c:770: warning: Function parameter or member 'data' not described in 'iwl_find_disconn_antenna'

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
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c b/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
index 588b15697710d..974e1c324ca7c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
@@ -761,7 +761,7 @@ static inline u8 find_first_chain(u8 mask)
 	return CHAIN_C;
 }
 
-/**
+/*
  * Run disconnected antenna algorithm to find out which antennas are
  * disconnected.
  */
-- 
2.25.1

