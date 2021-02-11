Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4845131854F
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhBKGpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBKGox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 01:44:53 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE7BC06178B
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:48 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id u66so4981678oig.9
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7JOuhWvIWKqN8Se22XaC8yOwoXuCUjA+EBQMIgDHhow=;
        b=LFsA3uXIPHF0wqBcyf+NVb8olnwDwZ+A0Hh4+Jt9bSQVtpW19IVmYCA0thAs0/H5T7
         FaCdUYDpaVtFQORxrztyenA1eCCrtjManZ0iB/pd9vRtgB4yn40DHcb2Wp1AgdlrL99Z
         wiBuSD4r36RtDtXHnHknGlHltGqY4GAfXZXyRlAZb9T+OAvdy7xFYkwbPSYAdDkVI9Cl
         c508CqCiyaBHCcrtpIoitdTTn3/dD4GnxQ2pXWAq9fPHSC1Wytucbu8/HCSmpWPQQim2
         ZlvPAa1RVZ1dCJB2urbtMo0p5+isw5VogpKe2WEj4ln7M8kwfokGH8OtGqOPLwrY93i8
         OwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7JOuhWvIWKqN8Se22XaC8yOwoXuCUjA+EBQMIgDHhow=;
        b=CeH4X9L7Xu6bFAon7QpFj1jKxvTQc00HeF0JPv6u48gmv7MOMs7I+b+sZgz9FSjw1u
         aRs/yEgm1CDZYCQqawJQfbLhyGbPyh0RygvT2Knd0Wq8bYE+JsGr27o2DhuPZSFcfl+1
         viVk+AADo/B9NEWZAtNyDmjTsuSC0M7dx/cut8YTYh5kXAO0C/gBzvmmrkKTaGZtF7cb
         BgXv7iBXNkl6qkXg3yCx1jANh/BmUJSI/YH4mQKTCi61RSeSIudZcYBYI3jrsMF83Q4s
         Er/odhKjWzMBgESyrhfsjBGkFU8uwzDKDXS2Ph9KI0bdMpM5jnqRbekNMTA+YhGmg0Ue
         CQxw==
X-Gm-Message-State: AOAM530GFAhmtE8Jazcgp+nMGvVBPiEDE6vNowd0F8EXhQtbr0Kyj6Ex
        au/kwQEHeEmq6enKp0BwTbYIAWVR3IU=
X-Google-Smtp-Source: ABdhPJyUvZFZ6y+8MjOErjgZIkDDINJcf2X3kUZNnLWyM47KodaXVvCdIEW5NcRjCU+DiEZT+GrQ3g==
X-Received: by 2002:aca:230e:: with SMTP id e14mr1117719oie.6.1613025827639;
        Wed, 10 Feb 2021 22:43:47 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:302d:c724:5317:9751])
        by smtp.gmail.com with ESMTPSA id y65sm993375oie.50.2021.02.10.22.43.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 22:43:47 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 7/8] ibmvnic: remove unused spinlock_t stats_lock definition
Date:   Thu, 11 Feb 2021 00:43:24 -0600
Message-Id: <20210211064325.80591-8-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210211064325.80591-1-lijunp213@gmail.com>
References: <20210211064325.80591-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stats_lock is no longer used. So remove it.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 --
 drivers/net/ethernet/ibm/ibmvnic.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0c27a1f9663a..778e56e05cd7 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5295,8 +5295,6 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->ethtool_ops = &ibmvnic_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->dev);
 
-	spin_lock_init(&adapter->stats_lock);
-
 	INIT_WORK(&adapter->ibmvnic_reset, __ibmvnic_reset);
 	INIT_DELAYED_WORK(&adapter->ibmvnic_delayed_reset,
 			  __ibmvnic_delayed_reset);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 8f73a30a7593..270d1cac86a4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -987,7 +987,6 @@ struct ibmvnic_adapter {
 	struct ibmvnic_statistics stats;
 	dma_addr_t stats_token;
 	struct completion stats_done;
-	spinlock_t stats_lock;
 	int replenish_no_mem;
 	int replenish_add_buff_success;
 	int replenish_add_buff_failure;
-- 
2.23.0

