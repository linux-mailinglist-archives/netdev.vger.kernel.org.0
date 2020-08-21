Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D6024CECF
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgHUHSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728210AbgHUHSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:18:00 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F40C061376
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:16 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c19so686043wmd.1
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QBwZYByjjh942d4ggJkaITmm4qS6KFDbT+209YIFm2k=;
        b=yZCyYlGZPQ1MpWsar88f0Kj65T7DKm8G0Wa7HonVhN5aQGd+Vq+7PVb/SFeOGmi92G
         hHV44x78U8WMcfXbgh2b8JwCdhbc/Rsijg6D5HWjJmXliAPJzLye/S8TORjUjoCeFwMO
         9QYGIsJ4bcQpLqYQlW8G5D5N4o3s6GqVxd7s3Uscz8qkSrRi6ejw0vXhM6XOAcHR+DJg
         yVncHBseIPKm73fGZ6+F84E6/X66kZVos1vJdfVHRFKXKdjEyQFduxXqTYmZMbPeRHj6
         2NEwqfOv3PkdCdCWWD7BeX9s7IzW7Kuk00mGlyy7gNAWeOH0WwD7lN/mg0o01WyekcYb
         dOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QBwZYByjjh942d4ggJkaITmm4qS6KFDbT+209YIFm2k=;
        b=nFOUFI/51Re2UEp5hkV0YBgGbnfIRbnsKQZnNFnVgn7BH2mHxGmBUW1kk3w0mX1KXf
         j27SaY4fnYqLzQlZsYGwaw45kX2N6It5EfcolPWKxZYPmErlT2IJrtkUkZoux9Z6ZqJ1
         deUcuobJn7bwH7gip4VTNVLJOOBNp2V7kj8O7euteCmJ15F6OipikoEJJv0qq2pthOs2
         pSQ0Y5WFaGK0K3fmy4TtyZGqdr4V5J1/qQFKxFUg32J2keLu0MdpJCwPPk+r9jYFhVLE
         88kxZEkIIuFAqATbyJFGJb6McBrjN93WGUhy9H1GO08e9FjXQCLIW1B/cbs+FkiQ2Vyi
         KTbg==
X-Gm-Message-State: AOAM533PaFpz/Aouj9d0Nz0AKc+Uvtkfc34xwijbTB3sbxQCDpltxWJE
        SVlSFJ+1Z4h9xFdQLrO2x3TykA==
X-Google-Smtp-Source: ABdhPJzEikq6XpGtpcWzp71avWyyFdi9ckss9ceBu+daG5QjQTOHDdhnluXUKmFNjNCwxgkBDH31tg==
X-Received: by 2002:a1c:7702:: with SMTP id t2mr1630905wmi.169.1597994234474;
        Fri, 21 Aug 2020 00:17:14 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 21/32] wireless: intel: iwlwifi: iwl-drv: Provide descriptions debugfs dentries
Date:   Fri, 21 Aug 2020 08:16:33 +0100
Message-Id: <20200821071644.109970-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
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

