Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C3B263DD5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 08:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbgIJG73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729663AbgIJG5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:57:34 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E83C061345
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:12 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z9so4627927wmk.1
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QBwZYByjjh942d4ggJkaITmm4qS6KFDbT+209YIFm2k=;
        b=o/wDvUp3hJQejPqXu9BVpd4DAZVvxNEGCvwNBjgtKaCHOvkvK2PixeedyU+euKj3uM
         6RE7sSsFhFn7II5R/AT4j99dXRYjA64fISNqweLwk21m2ilur2CuKdp/ldA/0ExeQSGq
         diVFzJGZeH2I02ScPXSS9m+HBcHIDpVwWqSW1r9F9iwqMgVKVdY4b2m6LsXoe2I6Rhrd
         qtpxpuulD/8hye47v78oTqmg0QNkvrzcxD/6+noLrHjKzcw3SIkL670d75vQivrpQE5q
         T54i9iRRejeNy+G8gWYcBfd7RPfc2DxpwcbWyOpeX0qNDjoHkUvj6rD+YIlXhopr6css
         qhTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QBwZYByjjh942d4ggJkaITmm4qS6KFDbT+209YIFm2k=;
        b=oBrxUq6S9Ns+Pn4nsv/eXpFf2G96E6QX5hR6rOIxHHgGufhmyYF0zKm8ld4Ue+KWfs
         O2KBgFjkhEodAoO/qZPaAXYc+FXgJejaPoB7FI5/TweV68nIB4eht2gyUO2GLB61v0Q2
         vmO6j37iBRzlzKmwqd1hiL0WecCTGfk10qvdMW3YiPq3DsztIcr2e1e4iD0C6pgetaAD
         EQcjnFVDNPQis6Nt1OuUMlVUwZZPVzwUv2hc+pIGqJoSXlr9OOzD/xjqEIyel9loY88F
         nxPYBNZszieKvXt7WTR6sIAU3wGT2//6yrTADLZn6SCiUsCgpDNxkvuBrjTUtyJXwukv
         KZJg==
X-Gm-Message-State: AOAM532IzZXqZjecWEro25Ou8LiGJBYaDidGckNsMnmJsUnrT4ObOz0u
        eJrMEGxrdXf2vPpVilKdnGJFyQ==
X-Google-Smtp-Source: ABdhPJyzPwfgv9BHfQPFHkUwcAwFvGoFXu5+ZZChSk0rDJAdQiIj3E9ve0VgMnmySY7mUABMHevIVQ==
X-Received: by 2002:a7b:c5c1:: with SMTP id n1mr6617171wmk.125.1599720910831;
        Wed, 09 Sep 2020 23:55:10 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 15/29] iwlwifi: iwl-drv: Provide descriptions debugfs dentries
Date:   Thu, 10 Sep 2020 07:54:17 +0100
Message-Id: <20200910065431.657636-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also demote a non-conforming kernel-doc function header.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/iwl-drv.c:124: warning: Function parameter or member 'dbgfs_drv' not described in 'iwl_drv'
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c:124: warning: Function parameter or member 'dbgfs_trans' not described in 'iwl_drv'
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c:124: warning: Function parameter or member 'dbgfs_op_mode' not described in 'iwl_drv'
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1329: warning: Function parameter or member 'ucode_raw' not described in 'iwl_req_fw_callback'
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1329: warning: Function parameter or member 'context' not described in 'iwl_req_fw_callback'

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
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 04f14bfdd0914..2a9075b1b3747 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -102,6 +102,9 @@ static struct dentry *iwl_dbgfs_root;
  * @fw_index: firmware revision to try loading
  * @firmware_name: composite filename of ucode file to load
  * @request_firmware_complete: the firmware has been obtained from user space
+ * @dbgfs_drv: debugfs root directory entry
+ * @dbgfs_trans: debugfs transport directory entry
+ * @dbgfs_op_mode: debugfs op_mode directory entry
  */
 struct iwl_drv {
 	struct list_head list;
@@ -1319,7 +1322,7 @@ static void _iwl_op_mode_stop(struct iwl_drv *drv)
 	}
 }
 
-/**
+/*
  * iwl_req_fw_callback - callback when firmware was loaded
  *
  * If loaded successfully, copies the firmware into buffers
-- 
2.25.1

