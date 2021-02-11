Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8E531854E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhBKGpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBKGov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 01:44:51 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84B0C06178A
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:44 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id m7so4964584oiw.12
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lThbLDzbOYB7OPxXx1w2lY+QcS7QaN1y+3TBSn73CLE=;
        b=sxISHs3M+lYQVouoH3Rw5SxREkmHVXtpcixnOp5AQTptS4YZIacuZLw6eG0E5iABDc
         wipTXXuDlHjttIX3xt7D6Cj4DEJV8Yrl3HwO9RAOgxFZjGrXdQN42f061Br19ZUGTozx
         5ijudRAeZU2HY7Auy5Md50VcC18sc82n5uWqnHkElPXyxmqLlKFR9Mi0xSvKsxZlLB5L
         9b1R6mbOcYWpRSRLv0OsN4qZtZodpEKZqIFuJe4/WBFjxLyu34Qu+J01XOyymfkSbtGX
         u15dy/Ihuujp5fpwleKGV7oGVgvaBw2Thx8/Hf9YXaQiTjbkro8/DyXNm34R2MjycC52
         KjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lThbLDzbOYB7OPxXx1w2lY+QcS7QaN1y+3TBSn73CLE=;
        b=FCoP2hRe5gStcZllsGrq+PizPdQUwzBqe2Qvn9csD9/+6orrmafxsgwsqH81V7/71L
         jxQ1YxC1Bd/kQBXsd/GbAeUYGQwCfXn1rqnYEL34afHJiJkoAPrSKWeIhOVpfxMDVYqI
         ELV5KFRm37FYy9gRIg63TLG5x5SSHlNdTJWjT9nzssicYjhVai5ZlAnZDwe6viT8kW8b
         hZ7ubhf2OR5Dh55EUzYf8c4e3ZpqaG9cxK7URnTXLmIqkedHD/8mrwm6w3G9nf+MTGSp
         VM0C/EfxvO+sddDS2EJgyGJkVJUoPFRIceux9Jf12l8iyo7kyKlWYBeAnsKfI0zUusiK
         jJCQ==
X-Gm-Message-State: AOAM531wtJG9AfXpYMtBONnbyv1nJLTY0j/4uEMGOfjAAdaFqx+I+psX
        gersL8yBpZNXAXXJoPXkm/d7m83dFA0=
X-Google-Smtp-Source: ABdhPJyA6Ml++QKC9U9MEQ3qrVVjeD258ZDUWMHPaCQKBvKztcKzr1NTEUdqKQpyAOA9cPDyjubiZg==
X-Received: by 2002:aca:570d:: with SMTP id l13mr1766325oib.159.1613025824204;
        Wed, 10 Feb 2021 22:43:44 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:302d:c724:5317:9751])
        by smtp.gmail.com with ESMTPSA id y65sm993375oie.50.2021.02.10.22.43.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 22:43:43 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 6/8] ibmvnic: add comments for spinlock_t definitions
Date:   Thu, 11 Feb 2021 00:43:23 -0600
Message-Id: <20210211064325.80591-7-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210211064325.80591-1-lijunp213@gmail.com>
References: <20210211064325.80591-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several spinlock_t definitions without comments.
Add them.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/ibm/ibmvnic.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index c09c3f6bba9f..8f73a30a7593 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -845,6 +845,7 @@ struct ibmvnic_crq_queue {
 	union ibmvnic_crq *msgs;
 	int size, cur;
 	dma_addr_t msg_token;
+	/* Used for serialization of msgs, cur */
 	spinlock_t lock;
 	bool active;
 	char name[32];
@@ -876,6 +877,7 @@ struct ibmvnic_sub_crq_queue {
 	unsigned int irq;
 	unsigned int pool_index;
 	int scrq_num;
+	/* Used for serialization of msgs, cur */
 	spinlock_t lock;
 	struct sk_buff *rx_skb_top;
 	struct ibmvnic_adapter *adapter;
@@ -1080,9 +1082,12 @@ struct ibmvnic_adapter {
 
 	struct tasklet_struct tasklet;
 	enum vnic_state state;
+	/* Used for serializatin of state field */
+	spinlock_t state_lock;
 	enum ibmvnic_reset_reason reset_reason;
-	spinlock_t rwi_lock;
 	struct list_head rwi_list;
+	/* Used for serialization of rwi_list */
+	spinlock_t rwi_lock;
 	struct work_struct ibmvnic_reset;
 	struct delayed_work ibmvnic_delayed_reset;
 	unsigned long resetting;
@@ -1096,7 +1101,4 @@ struct ibmvnic_adapter {
 
 	struct ibmvnic_tunables desired;
 	struct ibmvnic_tunables fallback;
-
-	/* Used for serializatin of state field */
-	spinlock_t state_lock;
 };
-- 
2.23.0

