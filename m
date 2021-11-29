Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A31E46179F
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239244AbhK2OPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhK2ONK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:13:10 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C089CC08EAD2;
        Mon, 29 Nov 2021 04:49:23 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id j140-20020a1c2392000000b003399ae48f58so16717226wmj.5;
        Mon, 29 Nov 2021 04:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F0poFPJsWt+35ZjTKPTDqAWquj99j6P21+mLO9eANjc=;
        b=I3hKvrFIpV9B6n8epfPsaPBOwhiF+v9Dqo0UZCSDDztmiIeVrboxg9Y/U8uVLCwsAf
         0bacUL33sAdOklbyi+Eq2rJDYyjrOrNI3KAKLIovfpRVlc9Iw1+HjnM6BF/uliFuRAph
         INeOzkQVrYEsqFem7A9d9kHDdHoFJ0h1rAhdbS23IZgZAJJArh/Yf6X5wRaUP98gWGMW
         LS9zqOgLMVrhSKAhf/GPt+KuVgI4Ra+vr0gg6v4BdddtvMxJ9OveMWOCJ5t4ozyv+OE7
         BJtfaVMD6ZFF46fH7tcAxb18+IH7maBtdmSp1pzLYPjVr3gdKaRKBDWH1ZdCU/vdFb+j
         zCoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F0poFPJsWt+35ZjTKPTDqAWquj99j6P21+mLO9eANjc=;
        b=HgtDXTKGbyQ+LzCq2UCoEI2F41jcrQzkNIpUnMqdHy95SopPMihfN4BJmn3ZP7ImsP
         pIwS3GEveqASk7kAnf7GP2Gof3I5F2OEW1+I+vpNAYQeJKQJ8tqQ/TrFbaL7wLydrbu2
         3TPCmTr6E/wZTL46aOdXAhlTdELodRB/K7Ryu91kB1PxQf7PKYE0Kz1hxzGQVYo6v5SE
         C4/lUXpzKpAFIzeBKr3xpzAJ+y1VMUEh2gh5Q2SRYfW+t8n0wJ1FHsdhyMk5K5ZfZDRo
         4uG7KpKi1yegQJQwE4q71EX+GKcDAf/p9E+3CDbtxHYKhKQMTjRVFti9QBc1lySApfW9
         uOaw==
X-Gm-Message-State: AOAM533lc0XxBVn7xp9tT3xL2DF/gAjmhuXfHROXmZaltHKEOejO6cIc
        kb0XALLoKbwcRw==
X-Google-Smtp-Source: ABdhPJwyDHDSWQ4+H0d8lJOqJyR6Q1Wjwp2YNIkTFYzwztVdV2R+f1sLmz7AX/uYwADPN+ki1fw22w==
X-Received: by 2002:a7b:c256:: with SMTP id b22mr10743444wmj.176.1638190162365;
        Mon, 29 Nov 2021 04:49:22 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id t11sm13926384wrz.97.2021.11.29.04.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 04:49:21 -0800 (PST)
From:   Colin Ian King <colin.i.king@googlemail.com>
X-Google-Original-From: Colin Ian King <colin.i.king@gmail.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next][V2] iwlwifi: mei: Fix spelling mistake "req_ownserhip" -> "req_ownership"
Date:   Mon, 29 Nov 2021 12:49:21 +0000
Message-Id: <20211129124921.11817-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a debugfs filename. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index 112cc362e8e7..0865e4fb25da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -1754,7 +1754,7 @@ static void iwl_mei_dbgfs_register(struct iwl_mei *mei)
 			     mei->dbgfs_dir, &iwl_mei_status);
 	debugfs_create_file("send_start_message", S_IWUSR, mei->dbgfs_dir,
 			    mei, &iwl_mei_dbgfs_send_start_message_ops);
-	debugfs_create_file("req_ownserhip", S_IWUSR, mei->dbgfs_dir,
+	debugfs_create_file("req_ownership", S_IWUSR, mei->dbgfs_dir,
 			    mei, &iwl_mei_dbgfs_req_ownership_ops);
 }
 
-- 
V2: Just fix the debugfs spelling mistake, the error message has already been fixed.
    Change commit message and subject line with correct information.
--

2.33.1

