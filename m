Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86D824CF3B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgHUHXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgHUHQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:16:53 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F63C061388
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:53 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id 88so1013062wrh.3
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jkJnqXxLKchHWxEQRJwgWXXCncTXSd4DzK09wyk1JRk=;
        b=imjQbPJVVZShA4Q+n/mfzt9cNHPoknvEEchPr3hoZ3sCDTX9LnvxrFnwqSUjtaMJib
         No6IK1zcjccFbBZN3v1Y/L1CN0IReoDTnYEweipYWzPK4GlUUHm1j2bviT9xJry9++Wp
         ksKRo/9pfxPPK69NLV3WeebLFmxi+8Z1K+teNTW2ZfuIqASqjLcIs9LkoaoMi2XqlYhZ
         QV2VW5ET78aYF6CAzVs1rM7ECwu8X5uy2b1r3ExlTtveoarvtIoZ79XhZ3PL8DYNTvVg
         EvzS5Y+VLRh+BIcdEcz6IzW28c/4LVlpfF9LlWJgLiFYQE765HOOr65IQ9IatBYAoDA2
         Oowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jkJnqXxLKchHWxEQRJwgWXXCncTXSd4DzK09wyk1JRk=;
        b=hGJIm7iYv1go+ykjsQ8cFdvkxkPobPXIiNWx1QDuINuZMiKftk1cHvNoDSCR5BAKXM
         hK3c6PMBGTd1HlHUf48sTIrgDlt0D8fY9WgmLdmwyxjxAowq/XbPk1RfIruu8NY9uISx
         Ua+NWoqpU7tN4MP57eEjocoyoH5oNxQIEdk8//+0rWk2+ZZo84pbMZJsI6QF6+Q44ju+
         zyh9qJ9tw+SRsgYgZPO1PQ8AeN2QAGlKIvdrL9AasoU0dNCQ2GHkA8YDe4MLb5iNXjrU
         DKvgUUM7hILgpybWxPvIIen05jrSn47YxXGX0v92orGYInwfnz7YvLln7kO1FT9McN5n
         ruQg==
X-Gm-Message-State: AOAM530dSHwVDaaELjLJHz+ok04+RSwVFArj2RrBg/2LdCYOhGFrBUrc
        wA3OEshDx5dDgcytmAfzZN0b/g==
X-Google-Smtp-Source: ABdhPJyOVV0ODNrXRXl4GTB1L8JglbkkcmT5s6PLzgeWhThPD84T4n78OmQCtqg3gE+tvn9EzvWdGA==
X-Received: by 2002:adf:e80a:: with SMTP id o10mr492035wrm.312.1597994212188;
        Fri, 21 Aug 2020 00:16:52 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:16:51 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 03/32] wireless: intel: iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
Date:   Fri, 21 Aug 2020 08:16:15 +0100
Message-Id: <20200821071644.109970-4-lee.jones@linaro.org>
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

