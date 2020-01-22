Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8A0145B83
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAVSXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:23:17 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54219 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:23:17 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so267760pjc.3
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NdDugV4RVuZnDJNXT9PvRvUKCb7vnZ8wbK7a4Kfzijc=;
        b=j0CM85Il7/7gnEnFxVOX8/xlAknRb6C4ejzmVsOD/RG02DdKaUQFDl+mAmsjywfENg
         duFyH4Jq916RiSV/4VrVAZi251uPM+TOU8Ld/YBLxVKQeN7IPBUJeMVLuqNSJzwbfxpe
         wFsfyaTH3lViqsBNc6fG+1eO0J5f8PeAzau5c+e68uYzOYg9KV/XzzFdKzba2613+CWY
         j9CFmCRmd8sVK9Lz2X8mNifJgRFOtGfGZ92FNdABJ1xn3Y8m3d2U2uk5D8SLREs9Prrx
         s1cTEoKc25OKxznfoI1sevLRU3z6kwgfqk1Z/rvk8mp1Bda9vSX5KpiiQ93MV99+UNuL
         yMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NdDugV4RVuZnDJNXT9PvRvUKCb7vnZ8wbK7a4Kfzijc=;
        b=W8ZsUr6pyO3mNPM6QQUvhEUX8Pxn6XCF2AR5EVl7VxMpOHrY0lOVxgySzO1olNfEso
         vgGO4ucEbnS3CmQQ3QepzgnJldcwHAdLhaZCrrx14gKf9o4BCNOyL44UONMLY9IKjtNp
         VHyeTM28w+FpUTeEDx3QN+Wlk/Eb/yD8fXvSmFcdg4v2PyN+V0oL6RrGXDziSovZRDnW
         HUyzMHciGPVvj0Gm+P/O0IIHpHM5LhQgDi274BQlsd7SWwfsLB4sgF+C8uPUTd1QkzRm
         6+UY4MV/v9EN5h80fP+WFrJl2xcLzjE+tWMvfNVXHgiv20DlkcDofaKnaHxa/YJuKKSp
         7QbA==
X-Gm-Message-State: APjAAAUPoPWy1Q9W1oL2vz1UDLselEtCLPjuH9kjYpWn3NaYsucmBMwn
        Uoqaahc+E5YqJvQdXYbCg83CyIAgDHBCdr2F
X-Google-Smtp-Source: APXvYqySkYuOyIaFRc4GKOmt71847Ja0N0cmr56Z8fNpBAFhbaKCWF5gTG+a72Ms+R6GdrUtHZtCqQ==
X-Received: by 2002:a17:90a:cb16:: with SMTP id z22mr4533098pjt.122.1579717396001;
        Wed, 22 Jan 2020 10:23:16 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id o17sm3996532pjq.1.2020.01.22.10.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 10:23:15 -0800 (PST)
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
Subject: [PATCH net-next v7 06/10] pie: improve comments and commenting style
Date:   Wed, 22 Jan 2020 23:52:29 +0530
Message-Id: <20200122182233.3940-7-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122182233.3940-1-gautamramk@gmail.com>
References: <20200122182233.3940-1-gautamramk@gmail.com>
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
index ec0fbe98ec2f..51a1984c2dce 100644
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
+ * @qdelay:			current queue delay
+ * @qdelay_old:			queue delay in previous qdelay calculation
+ * @burst_time:			burst time allowance
+ * @dq_tstamp:			timestamp at which dq rate was last calculated
+ * @prob:			drop probability
+ * @accu_prob:			accumulated drop probability
+ * @dq_count:			number of bytes dequeued in a measurement cycle
+ * @avg_dq_rate:		calculated average dq rate
+ * @qlen_old:			queue length during previous qdelay calculation
+ * @accu_prob_overflows:	number of times accu_prob overflows
+ */
 struct pie_vars {
 	psched_time_t qdelay;
 	psched_time_t qdelay_old;
 	psched_time_t burst_time;
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
+ * @ecn_mark:	packets marked with ECN
+ * @maxq:	maximum queue size
+ */
 struct pie_stats {
-	u32 packets_in;		/* total number of packets enqueued */
-	u32 dropped;		/* packets dropped due to pie_action */
-	u32 overlimit;		/* dropped due to lack of space in queue */
-	u32 ecn_mark;		/* packets marked with ECN */
-	u32 maxq;		/* maximum queue size */
+	u32 packets_in;
+	u32 dropped;
+	u32 overlimit;
+	u32 ecn_mark;
+	u32 maxq;
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

