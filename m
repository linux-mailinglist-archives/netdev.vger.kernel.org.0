Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF878318547
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhBKGoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhBKGoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 01:44:15 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD3BC061756
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:35 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id g46so1081369ooi.9
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktYJYSGz8Vs7UFvmfdMVsRlIJMea6UNHml/3n4sjHRM=;
        b=oK8hFe1Gy9d39mTFrzOFpNDRO27MoXefE6wutBinLFw0TEs2NSzsyBZZXavkSYH3O2
         rXBW5I5zcvgjWdave36OGu1DF6P+b4pnlKXNxPkaL8Kr+iJnh1FIlWrRbJkvTXLrhChx
         ZYWV8cG/Zi7oOR+HO/mSj/oiRe0hdkh3g1F6+lxa8duEHi7Q5aIhn5yvnn+fYuBYtCHG
         nJQfoIJ5kmHBgKtEOT4ZSsKylZOJ6NiOBMOYInDceBc5NDwc8jkOlqOQUHCNYnWSVFMV
         x1bS4hr1KdzPrnpXnuS5s1MH+iQvQhdFA6SNvK7JsPAF2i0oe5OqJRHZ2DeQnBcW8UlA
         2C9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktYJYSGz8Vs7UFvmfdMVsRlIJMea6UNHml/3n4sjHRM=;
        b=Gtsbq3dPsZBpvZTRENEB4CA0a/rFOnaULfboy/v1reCnA7gvOcID8zi9c7R/R4ImSf
         /mAItDGu47ZdHmQELTk3TQZZqKg70dBl1oQBQDEQHYxs3fdGRyGuu2qDDyau+7ZbNEm6
         vbi1Ubk/50bH/b/VY58bXyA0ONrNkCn4w6QyM0yxO8SwLKQm8+O4bA3p6kw8Sf6ye+QU
         9NAqJXi/Dz25FuZBzJObLd7UPqcYUuCaPfotE8JFOTuS/5pNnFfaAovdZATcPSLLzpU8
         KW3gmem7RLStDAn6hPtCoTh+0Q/0BP9deAAvmz/SyD3cFfJIzjdR54eaXsTezla+TDHM
         af0w==
X-Gm-Message-State: AOAM530ytXbwFm2GW+vwZpOnDZgzLA1PrNs1Qp3lrUDKAwE0ofCcPvNb
        VphkW0whao/tf8XbClU3P25iVBigga0=
X-Google-Smtp-Source: ABdhPJyTUhXtDVWjEBJude+SufgOOyaydn0gYKfQVHBigDKmtpYBQxpR559UaHMabkDsAFuLxiw5Zg==
X-Received: by 2002:a4a:d136:: with SMTP id n22mr3056729oor.88.1613025814656;
        Wed, 10 Feb 2021 22:43:34 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:302d:c724:5317:9751])
        by smtp.gmail.com with ESMTPSA id y65sm993375oie.50.2021.02.10.22.43.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 22:43:34 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 2/8] ibmvnic: fix block comments
Date:   Thu, 11 Feb 2021 00:43:19 -0600
Message-Id: <20210211064325.80591-3-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210211064325.80591-1-lijunp213@gmail.com>
References: <20210211064325.80591-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checkpatch warning:
WARNING: networking block comments don't use an empty /* line, use /* Comment...

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 55970f02d9da..5c6f6a7b2e3f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1221,8 +1221,7 @@ static int ibmvnic_open(struct net_device *netdev)
 	rc = __ibmvnic_open(netdev);
 
 out:
-	/*
-	 * If open fails due to a pending failover, set device state and
+	/* If open fails due to a pending failover, set device state and
 	 * return. Device operation will be handled by reset routine.
 	 */
 	if (rc && adapter->failover_pending) {
@@ -1946,8 +1945,7 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 	if (!(adapter->reset_reason == VNIC_RESET_CHANGE_PARAM))
 		rtnl_lock();
 
-	/*
-	 * Now that we have the rtnl lock, clear any pending failover.
+	/* Now that we have the rtnl lock, clear any pending failover.
 	 * This will ensure ibmvnic_open() has either completed or will
 	 * block until failover is complete.
 	 */
@@ -2249,8 +2247,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
 
 		if (adapter->force_reset_recovery) {
-			/*
-			 * Since we are doing a hard reset now, clear the
+			/* Since we are doing a hard reset now, clear the
 			 * failover_pending flag so we don't ignore any
 			 * future MOBILITY or other resets.
 			 */
@@ -2322,8 +2319,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	unsigned long flags;
 	int ret;
 
-	/*
-	 * If failover is pending don't schedule any other reset.
+	/* If failover is pending don't schedule any other reset.
 	 * Instead let the failover complete. If there is already a
 	 * a failover reset scheduled, we will detect and drop the
 	 * duplicate reset when walking the ->rwi_list below.
-- 
2.23.0

