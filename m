Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCC2263DD7
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 08:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgIJG7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730189AbgIJG5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:57:10 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06843C061343
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:11 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c18so5397365wrm.9
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bsXVZlb3+RPh6wsFFLtZip9Xh8c8BRLlYFokPA0kQU8=;
        b=GGGwrmHVuW8tISGSbeUd6+mreB0TqZjr9Mv60GpNUIJGeEQFdPjdrvKI61DszWVfu5
         /ePSPwlEdTcxWdmnKD2tESH2TihMllXcQ//mkE1jmvx99vxjyjlpq/KsDdwjpbmrSFBo
         AhMzCPngkCrNSXGtbyJkCO1uh/786/ZD3Ylu6VKSDpJ/T9C8mLUgC4IuehgIvq+CBLqm
         7ZhR+09i4ueLroX6DN3hk+WG6/yHvABcg4BSrBCgxkLwOTtwLZnJYc/8U5tqlGi3664M
         TC76zw5b6tNpsKxQvg5ZG8TQ4TrDOT4WtdLFk+gy1A8GObfa9vHHpoEMvhkcKxBIvhnu
         mHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bsXVZlb3+RPh6wsFFLtZip9Xh8c8BRLlYFokPA0kQU8=;
        b=Z1B/7ussymkwaDrJHrej7LRVqVc+Dhc6NAxIbYgZCu8SKmExiNIKZJLTJJj2ZPC/rO
         6ufDGH2CIEXu082Vl8U+ZYC2MW6TXoPAJuTVTLS1qY3A1ddQ1nalf19wMNLs9SMGIa/y
         pDafTmNYewDUj3Y7xATWcTuQy8fQNSmX5pvUBqIfG/oWfYtHsWJhPQTzLrwNenGgRPxd
         d79t6llJCw0CZbymd77sxmmPguqApKbwMOWdorXdzmuPWIeMvi3crin1pWxM07Bf3P1O
         MB7t2nq+NhMtgtK9YVHx1OiAFyAHVpY52ttS/5aIIaTWXQpSruQiccj/y1cOVA2gnHF5
         9bnw==
X-Gm-Message-State: AOAM531hdtvhRouzQWzQMJkUTQa03kXl0jzKtCZ15V3tU8pbM8Ga2wqK
        SxQ45WCYM/0MC13fTQds2YgHgXzUBz41Mw==
X-Google-Smtp-Source: ABdhPJxoUTZ1Udl2ny0TNt6ZIhuZJ1WFgFfyd6N+SZnahKFXarkH1ysEOelqKAFlQAPjLUd1rJSx9g==
X-Received: by 2002:a5d:56c1:: with SMTP id m1mr7002737wrw.87.1599720909708;
        Wed, 09 Sep 2020 23:55:09 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 14/29] iwlwifi: dvm: devices: Fix function documentation formatting issues
Date:   Thu, 10 Sep 2020 07:54:16 +0100
Message-Id: <20200910065431.657636-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kerneldoc expects attributes/parameters to be in '@*.: ' format and
gets confused if the variable does not follow the type/attribute
definitions.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/dvm/devices.c:66: warning: Function parameter or member 'priv' not described in 'iwl_beacon_time_mask_low'
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c:66: warning: Function parameter or member 'tsf_bits' not described in 'iwl_beacon_time_mask_low'
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c:77: warning: Function parameter or member 'priv' not described in 'iwl_beacon_time_mask_high'
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c:77: warning: Function parameter or member 'tsf_bits' not described in 'iwl_beacon_time_mask_high'

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
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
index d42bc46fe5662..c3e25885d1943 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/devices.c
@@ -58,8 +58,8 @@ static void iwl1000_nic_config(struct iwl_priv *priv)
 
 /**
  * iwl_beacon_time_mask_low - mask of lower 32 bit of beacon time
- * @priv -- pointer to iwl_priv data structure
- * @tsf_bits -- number of bits need to shift for masking)
+ * @priv: pointer to iwl_priv data structure
+ * @tsf_bits: number of bits need to shift for masking)
  */
 static inline u32 iwl_beacon_time_mask_low(struct iwl_priv *priv,
 					   u16 tsf_bits)
@@ -69,8 +69,8 @@ static inline u32 iwl_beacon_time_mask_low(struct iwl_priv *priv,
 
 /**
  * iwl_beacon_time_mask_high - mask of higher 32 bit of beacon time
- * @priv -- pointer to iwl_priv data structure
- * @tsf_bits -- number of bits need to shift for masking)
+ * @priv: pointer to iwl_priv data structure
+ * @tsf_bits: number of bits need to shift for masking)
  */
 static inline u32 iwl_beacon_time_mask_high(struct iwl_priv *priv,
 					    u16 tsf_bits)
-- 
2.25.1

