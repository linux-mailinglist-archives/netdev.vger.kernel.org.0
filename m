Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD11024CF07
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgHUHVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728153AbgHUHRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:17:45 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D35C06136C
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 83so819700wme.4
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bsXVZlb3+RPh6wsFFLtZip9Xh8c8BRLlYFokPA0kQU8=;
        b=GlMRUCt0tk+ts8PiLe/psgZRUi46xqkZeg3YsyC3FR4geI5DPAC+Z3ksWqLHfcuETg
         C203xvi1zCzTgBG5JRdq5KLMOwrn4MwgT/luru6MwvDzIWOTv22d8NnO1kjCrbbLRxFL
         oHGGRX3igK0ZK5o8TFxdGMtir+lIaMP2c4dmh5PU5g4kURn1MyRx5wC274j8d37aLVFp
         yV8sAyeJec4NYastw6y5fzbnDfOYFbGJMxDnO8IYcqCOI/OX9IsAprz7+j8XQjWN2YGc
         LlB5fPm1IeR2+ywtO0dOrA2ndf9UiAsa8RZUc4Il6C1Ub3GtmSdchlzvWd7ujSR1U2nW
         gqeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bsXVZlb3+RPh6wsFFLtZip9Xh8c8BRLlYFokPA0kQU8=;
        b=lovxDPYKIEMzXD04ylltzNhnJQ1/+Ie2RCfube6hGu5n6AZUPS12bH1aj2ICETqh6X
         C0lyet0StmKdpeT8VqnGvXBr6zt8OgAiJyunaNTquMA1GZneOfwKYhV228w971kD87of
         mdB9wr2UUgxrgIRamje2rFag/kuqp5MPSz/yEiiUhN42Q6q8r1I8R3ZJ2EAbxdSxp1nH
         FVcfLgWVvT1u5CMP944E2o5PSjckTlFQ6pcEpuVm/qhfRhhTaW1PmwD/CR7saXKZC+pF
         YxBy9ivd7NXRMnmReiJyrURzRMOEet6H9vll1NcKQlenDeLV+l8RpHFeGaVHYgBzw6t9
         uDjQ==
X-Gm-Message-State: AOAM530cg2W/xmJMp9k5ieB7CAF6i5+okf6HUXl210f9eTFTQUNO6/38
        VAV/TuP7A5GGR/whGcXH3iJa3A==
X-Google-Smtp-Source: ABdhPJzCwMbOmP03tTO4spaAbus4rZY09WFAG3Mma7D8oDWodk5Tt/MzWrKwrCrpe5EVtzJu3ncCyw==
X-Received: by 2002:a1c:6555:: with SMTP id z82mr2359063wmb.67.1597994232048;
        Fri, 21 Aug 2020 00:17:12 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 19/32] wireless: intel: iwlwifi: dvm: devices: Fix function documentation formatting issues
Date:   Fri, 21 Aug 2020 08:16:31 +0100
Message-Id: <20200821071644.109970-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
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

