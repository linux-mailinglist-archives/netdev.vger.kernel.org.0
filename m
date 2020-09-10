Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0851F263E60
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbgIJHSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730073AbgIJG4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:56:22 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E108BC0617BC
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:03 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l9so4616052wme.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jkJnqXxLKchHWxEQRJwgWXXCncTXSd4DzK09wyk1JRk=;
        b=DYJqd1E6K+y9QXkHGAIL5L1tXb7g2KMB7ljmLob/AWKP/B3CE0VlYJ+ZmLnA1JsU+W
         XzeKdAFsy3l664YPEVaTMsQyAxViTd7y/szoEgOR3KBWpL4pzwKQAlvQV69no2+57iAO
         sBvvSBR2DbNxQ6bNR8Lzl1VEXxN5F6qC0fQHRQ5TFDTnBG5oX1mfdBa2iCtghm17AxG2
         1V8A2AfOYwH8cVYYPvNFSVtl154KCArcSZDn+zizPSCxWsvuJh+9xjvKibqeFwq8iOur
         LZ6006V9Brdrycp32HJO4D2kbIXGA4X8S9D03PGja1KroF6T4l90Ual4A97wbQRlGduW
         3ifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jkJnqXxLKchHWxEQRJwgWXXCncTXSd4DzK09wyk1JRk=;
        b=msaasam51sqFZH4V8f86eNLnWPznRK71FQhJ1/kWMsGR3jLfPk1GyAOH+QDNgaz5Lb
         N6EaLHiOgYr2lMJS/X1o18vFnpXoUT9dCFYPdmt0MFtwjczKa1lRXLP/6FbBBuG5GYNq
         Bnilo52NNYMfFDbMElCw5BsblpAJGENE5DerVBD/5C8BYeQPgHw+v+XgLM1OMsEta343
         Y//Sbwj+9IMK5axOI3EfC4dUxJ9Ksqmc07+jNXw12nFEexAAHE3Xupqzek60Ju9nihJ/
         9+bsfXWX9yZ1+xQed9exatXg9mB1bkWkoe+hzkGZ7zqLTtOufB8tTHAbr0bOgqRV21QW
         8ozg==
X-Gm-Message-State: AOAM530fZZSZecL9TqvZChwwwaN37cjvhtjoxJcHv68JVK4AZkkbuVfx
        PyJCFmJ/FFmLYUHaIWUjF1KMeA==
X-Google-Smtp-Source: ABdhPJyWZsjYvdkZU9EYL+wKFtSQo4POMqm+cW+4REdrJdO0d6J7tVdZDQUtki7PleCf2FTISfGwYQ==
X-Received: by 2002:a1c:c90d:: with SMTP id f13mr7063757wmb.25.1599720902615;
        Wed, 09 Sep 2020 23:55:02 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:02 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 08/29] iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
Date:   Thu, 10 Sep 2020 07:54:10 +0100
Message-Id: <20200910065431.657636-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks as if it's never been used.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/mvm/ops.c:466:36: warning: ‘iwl_mvm_debug_names’ defined but not used [-Wunused-const-variable=]

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
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d095ff847be92..8e1e9ffbbf59a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -460,15 +460,6 @@ static const struct iwl_hcmd_names iwl_mvm_data_path_names[] = {
 	HCMD_NAME(RX_QUEUES_NOTIFICATION),
 };
 
-/* Please keep this array *SORTED* by hex value.
- * Access is done through binary search
- */
-static const struct iwl_hcmd_names iwl_mvm_debug_names[] = {
-	HCMD_NAME(DBGC_SUSPEND_RESUME),
-	HCMD_NAME(BUFFER_ALLOCATION),
-	HCMD_NAME(MFU_ASSERT_DUMP_NTF),
-};
-
 /* Please keep this array *SORTED* by hex value.
  * Access is done through binary search
  */
-- 
2.25.1

