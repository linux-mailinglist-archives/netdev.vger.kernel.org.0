Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA144263DC8
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 08:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbgIJG45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbgIJGzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:55:47 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA49C0617A3
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:00 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s12so5390916wrw.11
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w6TC3I8krKBM5ldX8StBAws3TwaUa2AMikeN8S5iGsY=;
        b=tKi1DbbONgqc92YD0S1ww47UtujnG25nG0BOwQtpRCPJJJHfFKCyBrufIfP/8ZC7Y/
         cXSmZ2XC3Ht5oH5798SuWIXjdUGdm8pGysfL1Rj26x9P5gyFqE5AQ+qsa0BjXQFY3t9m
         Ar34zpLJN2uL19dOBclt+m+CyVx7OxZ4+bNMlFQIt2JvUpjXIS1sHaMH+XcJb0gCXLDd
         X5JrVL8w6OOqEufD2ZUBszQiJ/FFAuRN5qAuULVE94PlxcEIHcHpQhR7EyarNt8kZLYY
         OBolizD008Pe4fy8cyHLUf+uGQWCT1LYeExoVf+dnWoFXIP6znwn56tN9F/VXXqoxRIP
         52dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w6TC3I8krKBM5ldX8StBAws3TwaUa2AMikeN8S5iGsY=;
        b=VCNu/3g2InkPEHrbe8snTKH526c0UPQV7BHMXlRDMw5trRIFgfBoYsOom5V3pBJ/4b
         vfnaX0qSnhATaoB7Mpn7Gxqcxk/fDxPNxKJAGT8yDRk1+MRfzN+qjbWXYxDXkiYNXTTc
         lWayExXx53ZSpYS5K33MJaUB+1VqMDk5klZ/D/Q48gGI0k2+Of/RmDO59L8yQ8/lOYIr
         V3g6tuh1ewOE7rV8NUH5gX4iGTIaSB/yU1PrA8S4E153djW86JVccc1mqH3xZ/yf3mQZ
         6tC3j6dmHUWiCBtqX/VSo1L2yiaZrvUmYG62kaT3WzKNSPIH0x5X/5iItbTahG6YCWXr
         sqww==
X-Gm-Message-State: AOAM531QXlNHVtTGV4KTWOo9fJj4hnk6ju5zOJjOd232fl7K0honU9ly
        A/Tqaoa9bSCERCbPOZJ/+gqXqg==
X-Google-Smtp-Source: ABdhPJz2BaCdtH12ngE070BKbbp6jnU3gYSb+cIdzh6Y6UBOphS1dAIRKVuPse5Bk/kZMkQzoBdZmw==
X-Received: by 2002:adf:8481:: with SMTP id 1mr6983624wrg.231.1599720899074;
        Wed, 09 Sep 2020 23:54:59 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:54:58 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 05/29] iwlwifi: calib: Demote seemingly unintentional kerneldoc header
Date:   Thu, 10 Sep 2020 07:54:07 +0100
Message-Id: <20200910065431.657636-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
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

