Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817EF2F2878
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387969AbhALGoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729230AbhALGoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:44:05 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D74FC0617A4
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:12 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id x13so1327147oic.5
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xEeL2AfSTftv2OyiQ5Edzj9Z8sExSgX4UezpDOpi5PE=;
        b=TPPyLAUL+IQtoD6dFXSPCthl9lSdOd41rzTQx+7P0EK8JvWS1opHQq8yVruBTxvXxT
         7cpCWkZy9JkNhdbtmY4aOY3OrmNk3b9/e3cVrqH2x4Surk55eCllin1a0FxfmqGu1u2V
         fuSGfkdRBytqJizCYXtF913RY/zUbvvJULcUvTIW0Topg3z2/DpzCsVKqoRXZZIcDzox
         r2nd2zFqYN3pUVwxpQq0oN1hQaMkbA2M+bZ34SxyVeOoIqIhyE8MPGAEaEMgOh2JqnxZ
         0zKwpvXb7HHdwbJP+n2ovkC29Av2CaWsDbJcHdhyeE0lb2fGV9qVTKrMRXYsrpzy5bUM
         lVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xEeL2AfSTftv2OyiQ5Edzj9Z8sExSgX4UezpDOpi5PE=;
        b=CGVF7Q3Ty77kbNg+RntlbbAJfgJI7qGPqv/blv2sqgHjCHGW/gE3zTzuvmzHOjfx07
         fM7lg9OMs6YybcJL1otPkN9OFkFg1+YLAa3McfNEQS2Y2HayQcZTeAHtUCIcnQ1XWVNi
         V7RJ9Yu+D5jcGoAsTH4cFS35emk4mBIWJn/uPM7RkFFyB7cus9OC27rSzg19lvZBXn+7
         PTH0S9MaaZ6TSn8FqNFy/lfbwg0VYTM/99rNvpPJMYONroV5qhanNtnyfVUNoqpiKpTW
         cK+lFyREVkZagZscWtQmc2yLp1zSPhRvVWFVcge08rW/5hCVGobeLbOp3e2II92uEzkC
         07Sw==
X-Gm-Message-State: AOAM531gxCD1x10W5ssZVJNtO+y6QcjuqlvBTeJz33mUcgHfX5jRH+bS
        hEm/ugejKYipL9HoBdLpLzeKgyB8PRiRyw==
X-Google-Smtp-Source: ABdhPJxtS8IPAY7Qf7Tw4edgow+SLXoOAgpHRt8Q5BsOcVbzUq5wkja9zKQL79c0V7taCF/qlx8u2g==
X-Received: by 2002:aca:ebd0:: with SMTP id j199mr1504316oih.155.1610433791442;
        Mon, 11 Jan 2021 22:43:11 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:ddc5:e91b:d3cf:e2ba])
        by smtp.gmail.com with ESMTPSA id 94sm482271otw.41.2021.01.11.22.43.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 22:43:11 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 6/7] ibmvnic: add comments for spinlock_t definitions
Date:   Tue, 12 Jan 2021 00:43:04 -0600
Message-Id: <20210112064305.31606-7-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210112064305.31606-1-lijunp213@gmail.com>
References: <20210112064305.31606-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several spinlock_t definitions without comments.
Add them.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
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

