Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9FF2F2874
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387751AbhALGnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729059AbhALGnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:43:49 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242CAC061795
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:09 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id b24so1355002otj.0
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KEypS/w+0uMzjn2mKyuYC8fEY9WmEshHRe/FDISR2Ag=;
        b=LYYOBYAhmUhC5AHaUX61lFK5lwxDyoDbQXYOVjKjJiAJr7PvKm4Vw1Dy0m66RH8MqQ
         nOHRAWfn1ZfItA2KFZg2uk85ksKY/+0fuCa155U/PSn/VDmVjJt1IOEfG2pIvG89PNVj
         hJtK6RJjv/sp0jqWmJCtuhb/FNF8KVPGP+RlDmK2eqyrAeyUB34M3NF2i5b0OxbOX2z0
         dtkAgM8swNCYL8S86GBLOn2rZS9Rz3AzJS1csPKo/DSsN1UkOj+rV+PZSxYFURDXNPD9
         3CpRIx9dTfle30w+ENZmiEmHmXZVlqxVcq2LhOzs86/jm9Kek018PlkmfA5SnI5F8D2S
         oDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KEypS/w+0uMzjn2mKyuYC8fEY9WmEshHRe/FDISR2Ag=;
        b=bVh831fQyO0ua1ZpavN7weAEZK+qiOlW4eoOzmBjY6zjKChRCPr1Ih/BCDfC83oTwY
         hDuz0/4PQC+uCqVnBVaTcsN4NCwj2fyyjTFlD7ca0cgUyY5dK83JuEdBHkeKbNGokZlJ
         h5PUs1fdM+S+wVBX3G38vg+AWzyRJ+SKNOAPGaosE5zwmfA7x0Q9UCN1NnNJ8MjeB/pJ
         yHvdk5IRsvSDPBRNd90z4wYv2HdSSw4RQ6XCANDjF6Ab4c9V9vMTKVeMPmq/4cPiPxBW
         EuRLTB3iQxodscWmNwSPFHzT1WbmeBEAP2bLhi82ennvV0I1khG4b6DtfvE0GJ8TMreP
         C2YA==
X-Gm-Message-State: AOAM530l+U/RO78VoTe1X8elMagO4J5kA3VyoU/oH5WH1zz1z8Ig4vaE
        Widn8IPJ3le1F1bzbCG+H/nxTlOthVOs7Q==
X-Google-Smtp-Source: ABdhPJxQLTvGB5PMxF7QtUehpxobWANeRuk5+Ir2mSFVuZLshztAEx5vfoHBwL8gX1NP+kUUEpVVng==
X-Received: by 2002:a9d:4793:: with SMTP id b19mr1831089otf.193.1610433788396;
        Mon, 11 Jan 2021 22:43:08 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:ddc5:e91b:d3cf:e2ba])
        by smtp.gmail.com with ESMTPSA id 94sm482271otw.41.2021.01.11.22.43.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 22:43:08 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 2/7] ibmvnic: fix block comments
Date:   Tue, 12 Jan 2021 00:43:00 -0600
Message-Id: <20210112064305.31606-3-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210112064305.31606-1-lijunp213@gmail.com>
References: <20210112064305.31606-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checkpatch warning:
WARNING: networking block comments don't use an empty /* line, use /* Comment...

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d4ba5f5a2b08..fe08c5415b9e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1220,8 +1220,7 @@ static int ibmvnic_open(struct net_device *netdev)
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
@@ -2323,8 +2320,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
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

