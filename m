Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD22143F09
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgAUONd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:13:33 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46165 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgAUONd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:13:33 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so1377895pll.13
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ab5exaHl+2Vc6g/PXwsk8pLa7T9uwuzuZY6A6qV1U2Y=;
        b=HsTP/W0d3EiAj37njpsAH/FZSqlOKgUkpzIorJiWvCo08r1599Rx/QucNhGvsmwIzK
         8gx/cphj3t6u029Ckd4p9sCPN/ooti6d5Qdn0FsQW1oIXbFJcJ2onPXbkpq91G95b/IP
         Fe0NqjkdY72tHk9VfQv+oaghWMi0YSBcCbO25kGQl3szYK8QR4x7haAuAKAWis4eb3cD
         Lh6oHiYa4tD4Yt0ouihSmOFYNFU/yZ61NFliu7FVWrgjdPvqhy47Cpj8Fa/P+yzyAtUH
         Fja8h1wFALr3dLKucjtK85h0z4HCqiDmQ8a2TKeS2kjSVddvnqWnFF1Tnx6mQ9cYX9vD
         tGhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ab5exaHl+2Vc6g/PXwsk8pLa7T9uwuzuZY6A6qV1U2Y=;
        b=Yv18HG6C/rsFPV1hDtxn1MsO0cAeJaDwMl0s5sjenuXN4//S0MfP6CggOzYs6XQmt8
         uQ1T95a9YkuYZVnpoLd2ksUnG0/h6GDETnyzaHuHAJ/MN/1OID79YLnVxQxIK6laDe2e
         BuVdp/jBDWnNbce4VN88d7CANjxbQE+SOrxO7Lzo3g2tnQoz/yufJuolCoO+h4sgCdO5
         0zrhrZqu4Cd8IZblkbYOoLQfUdVM7vZN2r1QMfXkY5YeKR+m/wUrM1AVvhTwzvi6enbV
         pW/djEJ3OHa7Q46WEs9z1lZtQxPjwLbIPcfvhfZwJ0+xmKXcvd5Jv9LQwBLycnJb8eLL
         9E6Q==
X-Gm-Message-State: APjAAAU44S5Gkxm7Th446cHkKoF4aJaGYsC83Nd2sN9uXW5hXjSxvZm3
        f9Dryh4llx+LcxBf2MxCMtuoHffdyNxcMQ==
X-Google-Smtp-Source: APXvYqz1BUeWtXRhrv29e5qHsEDE25A7EzY/dE1I+AffSgvToqORblun/baVjnsES6m3sFX3KSHe8Q==
X-Received: by 2002:a17:902:8c94:: with SMTP id t20mr5632151plo.170.1579616011832;
        Tue, 21 Jan 2020 06:13:31 -0800 (PST)
Received: from localhost.localdomain ([223.186.212.224])
        by smtp.gmail.com with ESMTPSA id y203sm44836443pfb.65.2020.01.21.06.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:13:31 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v4 06/10] pie: improve comments and commenting style
Date:   Tue, 21 Jan 2020 19:42:45 +0530
Message-Id: <20200121141250.26989-7-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121141250.26989-1-gautamramk@gmail.com>
References: <20200121141250.26989-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Improve the comments along with the commenting style used to
describe the members of the structures and their initial values
in the init functions.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h | 85 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 58 insertions(+), 27 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 54ba6c6a7514..65f0e8b2193a 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -14,42 +14,74 @@
 #define DQCOUNT_INVALID	-1
 #define PIE_SCALE	8
 
-/* parameters used */
+/**
+ * struct pie_params - contains pie parameters
+ * @target:		target delay in pschedtime
+ * @tudpate:		interval at which drop probability is calculated
+ * @limit:		total number of packets that can be in the queue
+ * @alpha:		parameter to control drop probability
+ * @beta:		parameter to control drop probability
+ * @ecn:		is ECN marking of packets enabled
+ * @bytemode:		is drop probability scaled based on pkt size
+ * @dq_rate_estimator:	is Little's law used for qdelay calculation
+ */
 struct pie_params {
-	psched_time_t target;	/* user specified target delay in pschedtime */
-	u32 tupdate;		/* timer frequency (in jiffies) */
-	u32 limit;		/* number of packets that can be enqueued */
-	u32 alpha;		/* alpha and beta are between 0 and 32 */
-	u32 beta;		/* and are used for shift relative to 1 */
-	u8 ecn;			/* true if ecn is enabled */
-	u8 bytemode;		/* to scale drop early prob based on pkt size */
-	u8 dq_rate_estimator;	/* to calculate delay using Little's law */
+	psched_time_t target;
+	u32 tupdate;
+	u32 limit;
+	u32 alpha;
+	u32 beta;
+	u8 ecn;
+	u8 bytemode;
+	u8 dq_rate_estimator;
 };
 
-/* variables used */
+/**
+ * struct pie_vars - contains pie variables
+ * @burst_time:		burst time allowance
+ * @qdelay:		current queue delay
+ * @qdelay_old:		queue delay in previous qdelay calculation
+ * @dq_tstamp:		timestamp at which dq rate was last calculated
+ * @prob:		drop probability
+ * @accu_prob:		accumulated drop probability
+ * @dq_count:		number of bytes dequeued in a measurement cycle
+ * @avg_dq_rate:	calculated average dq rate
+ * @qlen_old:		queue length during previous qdelay calculation
+ * @accu_prob_overflow:	number of times accu_prob overflows
+ */
 struct pie_vars {
 	psched_time_t burst_time;
 	psched_time_t qdelay;
 	psched_time_t qdelay_old;
-	psched_time_t dq_tstamp;	/* drain rate */
-	u64 prob;		/* probability but scaled by u64 limit. */
-	u64 accu_prob;		/* accumulated drop probability */
-	u64 dq_count;		/* measured in bytes */
-	u32 avg_dq_rate;	/* bytes per pschedtime tick,scaled */
-	u32 qlen_old;		/* in bytes */
-	u8 accu_prob_overflows;	/* overflows of accu_prob */
+	psched_time_t dq_tstamp;
+	u64 prob;
+	u64 accu_prob;
+	u64 dq_count;
+	u32 avg_dq_rate;
+	u32 qlen_old;
+	u8 accu_prob_overflows;
 };
 
-/* statistics gathering */
+/**
+ * struct pie_stats - contains pie stats
+ * @packets_in:	total number of packets enqueued
+ * @dropped:	packets dropped due to pie action
+ * @overlimit:	packets dropped due to lack of space in queue
+ * @maxq:	maximum queue size
+ * @ecn_mark:	packets marked with ECN
+ */
 struct pie_stats {
-	u32 packets_in;		/* total number of packets enqueued */
-	u32 dropped;		/* packets dropped due to pie_action */
-	u32 overlimit;		/* dropped due to lack of space in queue */
-	u32 maxq;		/* maximum queue size */
-	u32 ecn_mark;		/* packets marked with ECN */
+	u32 packets_in;
+	u32 dropped;
+	u32 overlimit;
+	u32 maxq;
+	u32 ecn_mark;
 };
 
-/* private skb vars */
+/**
+ * struct pie_skb_cb - contains private skb vars
+ * @enqueue_time:	timestamp when the packet is enqueued
+ */
 struct pie_skb_cb {
 	psched_time_t enqueue_time;
 };
@@ -58,7 +90,7 @@ static inline void pie_params_init(struct pie_params *params)
 {
 	params->target = PSCHED_NS2TICKS(15 * NSEC_PER_MSEC);	/* 15 ms */
 	params->tupdate = usecs_to_jiffies(15 * USEC_PER_MSEC);	/* 15 ms */
-	params->limit = 1000;	/* default of 1000 packets */
+	params->limit = 1000;
 	params->alpha = 2;
 	params->beta = 20;
 	params->ecn = false;
@@ -68,8 +100,7 @@ static inline void pie_params_init(struct pie_params *params)
 
 static inline void pie_vars_init(struct pie_vars *vars)
 {
-	/* default of 150 ms in pschedtime */
-	vars->burst_time = PSCHED_NS2TICKS(150 * NSEC_PER_MSEC);
+	vars->burst_time = PSCHED_NS2TICKS(150 * NSEC_PER_MSEC); /* 150 ms */
 	vars->dq_tstamp = DTIME_INVALID;
 	vars->accu_prob = 0;
 	vars->dq_count = DQCOUNT_INVALID;
-- 
2.17.1

