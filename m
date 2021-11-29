Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF304616D5
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbhK2NqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhK2NoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:44:19 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3D5C08EC73;
        Mon, 29 Nov 2021 04:25:19 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id o29so14427177wms.2;
        Mon, 29 Nov 2021 04:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=daLDNYXL/+8eDPcdA0ml26iWQ6uJtsnOCHrovjJY9zo=;
        b=g37GH9ftRH5TvVPU1IClRbQBmN5akqHTDNIPDSE83SqcXQmSGWfIZfXNC+aTq9Busd
         bRS8wlydwG6TjfjOk9y8ztImKbbhLxC0d3ntBsZWg5uJUBuTQ5vgXmBs/IILxAm/ClkG
         aYx8ydN4PTdoDI8Fati0Fsc3f8JfhTXDQAkx4BTBZ5TrYGujymHk5HCALxD0nu763AxM
         EXgLGB6VsmXEv79/UZreDWSipYUDDU30Jn7RKYj6sHzRJQB0BQbQeTepB29kFkHVrh4s
         QfBYAHuA/LvJJFO6n6PG3mlqDAqgmoI39diLp1QdeRv9A9Mmb0ju65p9zbLKp//mEtlU
         4/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=daLDNYXL/+8eDPcdA0ml26iWQ6uJtsnOCHrovjJY9zo=;
        b=n4Cxq82wvdzhlLuI2bHxdXDk5MuhZPeIApgF/Qzzz2m0A5fXCVx7H2Z+yXUa6ApNwA
         o89+D6ezyQJOhVchGKTotwDvzT+zRQLxoFb/vTuMpDov7maoYEOCK+pdf5mEUe7TxP9A
         vNqb4Jb5BeNZAPkaPojNU8TPZvAwxjxFN/cX26TJVVcMRssczJmkpA65x0gkTylga244
         wml5JjsrjkNTpYDGO2aWi4FxJUBn7JdgxG8CFW1nEx4xb8JRu6tktOydEcFxUnfBcYQW
         kR77cFeL/1sAvJMwUfYlF/2AjUoFY1W4ZzHSxWczrQnIb68obeYDDD0N8j/G28hb18l6
         dCHA==
X-Gm-Message-State: AOAM5317Kg1l65aeEg3+TxdWtBsu3SL8BbN8nQ1cabvTc82asVB1Vmdd
        QT52qZaaCoUE8Q==
X-Google-Smtp-Source: ABdhPJyD9zLDN6DOnTyjldHl6D5gu9E+hSYDUF3RZj6yU9dzp6Qfp1JLd5D9Ew3LqCan3BPiEtKxkA==
X-Received: by 2002:a05:600c:22cb:: with SMTP id 11mr36210187wmg.181.1638188718455;
        Mon, 29 Nov 2021 04:25:18 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id v6sm19154992wmh.8.2021.11.29.04.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 04:25:17 -0800 (PST)
From:   Colin Ian King <colin.i.king@googlemail.com>
X-Google-Original-From: Colin Ian King <colin.i.king@gmail.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] iwlwifi: mei: Fix spelling mistakes in a devfs file and error message
Date:   Mon, 29 Nov 2021 12:25:17 +0000
Message-Id: <20211129122517.10424-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a dev_err message and also in a devfs
filename. Fix these.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index 112cc362e8e7..ed208f273289 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -209,7 +209,7 @@ static void iwl_mei_free_shared_mem(struct mei_cl_device *cldev)
 	struct iwl_mei *mei = mei_cldev_get_drvdata(cldev);
 
 	if (mei_cldev_dma_unmap(cldev))
-		dev_err(&cldev->dev, "Coudln't unmap the shared mem properly\n");
+		dev_err(&cldev->dev, "Couldn't unmap the shared mem properly\n");
 	memset(&mei->shared_mem, 0, sizeof(mei->shared_mem));
 }
 
@@ -1754,7 +1754,7 @@ static void iwl_mei_dbgfs_register(struct iwl_mei *mei)
 			     mei->dbgfs_dir, &iwl_mei_status);
 	debugfs_create_file("send_start_message", S_IWUSR, mei->dbgfs_dir,
 			    mei, &iwl_mei_dbgfs_send_start_message_ops);
-	debugfs_create_file("req_ownserhip", S_IWUSR, mei->dbgfs_dir,
+	debugfs_create_file("req_ownership", S_IWUSR, mei->dbgfs_dir,
 			    mei, &iwl_mei_dbgfs_req_ownership_ops);
 }
 
-- 
2.33.1

