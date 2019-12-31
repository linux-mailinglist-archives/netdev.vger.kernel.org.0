Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E3A12D721
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 09:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfLaIjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 03:39:47 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34660 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfLaIjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 03:39:47 -0500
Received: by mail-pj1-f65.google.com with SMTP id s94so739275pjc.1
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 00:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQtaeDD9iVM5+b30tZbRI2EHQA2GRCPLt5coFH0Hu7k=;
        b=QtFPBRgexpYA+27porJnxIo3FiID+P4q/uunZRO1911fhApxltA68KLt3FnSAPmSFg
         o3vDx3KQLkxMzc+YGjItwPwaa1bI3SccD7XL81cYet5UBwSk23N4Y7viJ7QZRzLkoQFf
         yDUUNPAO8r7K0glITDJkhKjbu+AYwXc+Digc/rjcCxzb87PeUOHNh2+Pa45hi2ep9t1i
         qmWznwyLzgGxDQJtw3q8xZTKSjka609jGyiKjnAJdw1sq78SjUUg31drO4vvVuEsRoXj
         WeLdMpnsodrBZJCTrolRCvvWA353118SUOGicN9U93xl4aZAQ/PCeW6ZDQBwCQOmaIfG
         eYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQtaeDD9iVM5+b30tZbRI2EHQA2GRCPLt5coFH0Hu7k=;
        b=FS29N4+nQGCRvOp79Jd0aq1jqYrE0blglMah0nWrd2S66PGLXa4LREla3R3h2ZjLO/
         JsCKDzYgJF0B3chOycBsCtacYWkkChR15GhKUNgUNTcUIdYW8P2k8u7i4irMMO1WXwyD
         Dvt8cQu9xGaN3aEOXirVEazGYnYnR21j677qJ5r1Hs9wqHPcibtLB4qqFbcMQeBCq62V
         o9Q3Gf1lFLsiX8llwtaMuHOFH82VUDQzecKTGn8K9sP4lI8S4l62Y7/AAneJ+yAonsgR
         ecHf7KE3KXkz+XvXk2AcxjPQkqWN8D2WXRkVC1uMFPBsgdNp+fbRbC5OS6C4fmv+455W
         M8Xg==
X-Gm-Message-State: APjAAAUDSshbRef3AILSIHWdZJj5FPlG8D38FYouiejHlT1oTfKVN8w+
        Q7XfvbrBeh1n5ZZIr+qIU+6/nA==
X-Google-Smtp-Source: APXvYqyogbKOzEE1A3fEkjBs2LajnnAHqltAyAdH5gr4gm+XpBJEB1ntQvC/9yctl9aSkv2SZI5teA==
X-Received: by 2002:a17:90b:258:: with SMTP id fz24mr4782140pjb.6.1577781586060;
        Tue, 31 Dec 2019 00:39:46 -0800 (PST)
Received: from starnight.8.8.8.8 (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id z30sm56896800pfq.154.2019.12.31.00.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Dec 2019 00:39:45 -0800 (PST)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Tova Mussai <tova.mussai@intel.com>,
        Ayala Beker <ayala.beker@intel.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH] iwlwifi: mvm: Revert "iwlwifi: mvm: fix scan config command size"
Date:   Tue, 31 Dec 2019 16:36:06 +0800
Message-Id: <20191231083604.5639-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Intel(R) Dual Band Wireless AC 9461 WiFi keeps restarting until
commit 06eb547c4ae4 ("wlwifi: mvm: fix scan config command size") is
reverted.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=206025
Fixes: commit 06eb547c4ae4 ("wlwifi: mvm: fix scan config command size")
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index a046ac9fa852..a5af8f4128b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1213,7 +1213,7 @@ static int iwl_mvm_legacy_config_scan(struct iwl_mvm *mvm)
 		cmd_size = sizeof(struct iwl_scan_config_v2);
 	else
 		cmd_size = sizeof(struct iwl_scan_config_v1);
-	cmd_size += num_channels;
+	cmd_size += mvm->fw->ucode_capa.n_scan_channels;
 
 	cfg = kzalloc(cmd_size, GFP_KERNEL);
 	if (!cfg)
-- 
2.24.1

