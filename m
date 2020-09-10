Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB721263E48
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbgIJHPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbgIJG44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:56:56 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95DDC06138E
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:09 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id w2so4475617wmi.1
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UFEv542Lhp8Q0f61EAB5CHsxrkFJGeJ0ctv6xlXdr9A=;
        b=PKx+JXyKX6oNJ99FSi8jIpQx1PBRxa50KrYhj3ZbAsKzw5r4J6yMp99KeO9WcPFB8c
         Ceceo6MnvArOwhTkJxPQXGShN/2HzVNXnJwyGmbROSYiv+l4qdxh92n/WtlKUSGL4PzO
         I4V7/mu+d/TlApnB0zv0n0RWo2Wf4r6mk3pEueiHLdFzA1m1LBd3gizya+K8Q7zFVx/b
         6EoLYVG3XkxF1RHCyOqAOMo3/V1yLm3UW3V4MNcJ/8RMC0wW5a1zinqsSE+SMjhTsZeJ
         oHUEBLEIe6t2SoaD466VF37n2SXfzhQS8z+1379EkeJp6Oe3m+DmSea4CteDsobRPWxB
         ZY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UFEv542Lhp8Q0f61EAB5CHsxrkFJGeJ0ctv6xlXdr9A=;
        b=uIOrE3z7/YnqlwAF+yLv7ddxGl7OXKJ96oftD8N4FSt6O7c8vQSHqb0pyQkanoV6HX
         Gs5ukoAnC5q7KyhE9vqOgGFApkjE20U6CKPHbL+C2AE+rg+CCHQO0yq5CGal3aW21fK8
         5nZ0ndJuj1iehspDINn+fuZRCi/JdtNBEMnoIHTOF/x73e/tp9g4N/xzGqlOS0z0kHBc
         +796CFNBmOqqcrKHQ7bf7ZUesL9RBxJ9RxH6uTtOdvluO2Y7x8LOXMWqqP2IlmRU+uHU
         3w+5M2eKCxGoQsk5CUli/fnBUl0uPMNtUDEIQJm9ZBJoL298mGizJTJkd/21baT3kjpd
         1FfQ==
X-Gm-Message-State: AOAM532xADDHf7yJnxUsOQWTaYdxZ6S7ZVCJ5LIAnhl8y12XYlGvYnl+
        fnLvUeqEu7lwbXvAqSF7You4hg==
X-Google-Smtp-Source: ABdhPJwglt/9uW5KPkunmXazmtb24J49GEPBxD3Bb9hG8tmIdx9pCeW1n4r7+1K7+lnSzxSbiVjn3g==
X-Received: by 2002:a7b:c3da:: with SMTP id t26mr6622241wmj.23.1599720908553;
        Wed, 09 Sep 2020 23:55:08 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 13/29] iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
Date:   Thu, 10 Sep 2020 07:54:15 +0100
Message-Id: <20200910065431.657636-14-lee.jones@linaro.org>
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

 drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1379: warning: Function parameter or member 'rate_n_flags' not described in 'iwl_mvm_hwrate_to_tx_status'
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1379: warning: Function parameter or member 'info' not described in 'iwl_mvm_hwrate_to_tx_status'
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1431: warning: Function parameter or member 'mvm' not described in 'iwl_mvm_get_scd_ssn'

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
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 2f6484e0d726c..82ebf264de397 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1371,7 +1371,7 @@ void iwl_mvm_hwrate_to_tx_rate(u32 rate_n_flags,
 	}
 }
 
-/**
+/*
  * translate ucode response to mac80211 tx status control values
  */
 static void iwl_mvm_hwrate_to_tx_status(u32 rate_n_flags,
@@ -1413,7 +1413,7 @@ static void iwl_mvm_tx_status_check_trigger(struct iwl_mvm *mvm,
 	}
 }
 
-/**
+/*
  * iwl_mvm_get_scd_ssn - returns the SSN of the SCD
  * @tx_resp: the Tx response from the fw (agg or non-agg)
  *
-- 
2.25.1

