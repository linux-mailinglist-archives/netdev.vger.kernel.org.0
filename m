Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099EE1453EA
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgAVLgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:36:39 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46614 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729261AbgAVLgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:36:39 -0500
Received: by mail-pg1-f195.google.com with SMTP id z124so3319103pgb.13
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SCmdNafV4LQw/RRGOXko1kH2Ydhm553VdaSsK52kHhw=;
        b=Lz9Rz24s/DVpr7do+6c4ojRbzXgVf7VLQebBG8tXIOsALI+KbEck90Ijp5iYD2yuvT
         76lhuAgGsdELJzT8CVlCKHE/DY6ICZUT8QocLW4Xzh38coZfi0Dziu5ULC46NjCvDGtK
         65Hfr2v5FRmti3a8mEmkSNLTpv3EZyIyjhO+CEEQLBu9pt3TAPxBbQt/GZlQwRK32rvS
         8eNYD2jbPQU4HdZBtzwWSq/rJYurk3xzxdK8MLJJVskdn5weQ9O7gYfDsmYZBmt7XQBA
         ij2gqhzOfl+kegtHIv91hmU6SZoUxq5MT4Hs+tJ8k+/tZB205XyF8b8OrAkP8+BzzFvF
         RUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SCmdNafV4LQw/RRGOXko1kH2Ydhm553VdaSsK52kHhw=;
        b=k8mVVFd7pjQNOefiZQJrnGKA/hHwCGHqnyBdgcq1oqaTBxcTfZ44OtVU2CpADgK6bM
         vSVY8r1XaLXmNjSe9QEQdgqAY+pFXeJaJhMO114Cu2J6s9R5+ijOvTkfpU+neij6eqFk
         Y4ywKb9ePjSeWbPAkBbLKVvgtF6EvKTYZrVSB8jXeanFf5jcLaiEWRc0Op0hhCfMjyz0
         rBLiyOke98SL4Cizv1O1MKEYa2YeK8//TtlH3EdGPNYipZyXgSJ1B6k+BBNazDh5zGBl
         VMKKG+L1vjBzFQ3ZadoL7mS0u4Q3/d0JU5cGj+2gE4riZi54D80cN0nJqH/VeYJaLkZA
         TZgg==
X-Gm-Message-State: APjAAAXpm/ObWNLP1acRshshCULaaHRI6Kay7Jm98dvsi84ty2/V/L59
        kyJDl6ehPvXLPjnkhXLG77fgJkE9Btst8pyO
X-Google-Smtp-Source: APXvYqzC2Yx+ugjO0eexEM+1zyDObtIfVGGLaY6A6G7npY0TOGvHCj/AofQC5Rd6AnGpdyKXkEvgcw==
X-Received: by 2002:aa7:9729:: with SMTP id k9mr2242374pfg.72.1579692997670;
        Wed, 22 Jan 2020 03:36:37 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id c6sm2145962pgk.78.2020.01.22.03.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 03:36:37 -0800 (PST)
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
Subject: [PATCH net-next v6 09/10] net: sched: pie: export symbols to be reused by FQ-PIE
Date:   Wed, 22 Jan 2020 17:05:32 +0530
Message-Id: <20200122113533.28128-10-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122113533.28128-1-gautamramk@gmail.com>
References: <20200122113533.28128-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

This patch makes the drop_early(), calculate_probability() and
pie_process_dequeue() functions generic enough to be used by
both PIE and FQ-PIE (to be added in a future commit). The major
change here is in the way the functions take in arguments. This
patch exports these functions and makes FQ-PIE dependent on
sch_pie.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h   |   9 +++
 net/sched/sch_pie.c | 173 ++++++++++++++++++++++----------------------
 2 files changed, 97 insertions(+), 85 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 51a1984c2dce..90f5db3d29e7 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -124,4 +124,13 @@ static inline void pie_set_enqueue_time(struct sk_buff *skb)
 	get_pie_cb(skb)->enqueue_time = psched_get_time();
 }
 
+bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
+		    struct pie_vars *vars, u32 qlen, u32 packet_size);
+
+void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
+			 struct pie_vars *vars, u32 qlen);
+
+void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
+			       u32 qlen);
+
 #endif
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index c65164659bca..915bcdb59a9f 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -30,64 +30,65 @@ struct pie_sched_data {
 	struct Qdisc *sch;
 };
 
-static bool drop_early(struct Qdisc *sch, u32 packet_size)
+bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
+		    struct pie_vars *vars, u32 qlen, u32 packet_size)
 {
-	struct pie_sched_data *q = qdisc_priv(sch);
 	u64 rnd;
-	u64 local_prob = q->vars.prob;
+	u64 local_prob = vars->prob;
 	u32 mtu = psched_mtu(qdisc_dev(sch));
 
 	/* If there is still burst allowance left skip random early drop */
-	if (q->vars.burst_time > 0)
+	if (vars->burst_time > 0)
 		return false;
 
 	/* If current delay is less than half of target, and
 	 * if drop prob is low already, disable early_drop
 	 */
-	if ((q->vars.qdelay < q->params.target / 2) &&
-	    (q->vars.prob < MAX_PROB / 5))
+	if ((vars->qdelay < params->target / 2) &&
+	    (vars->prob < MAX_PROB / 5))
 		return false;
 
-	/* If we have fewer than 2 mtu-sized packets, disable drop_early,
+	/* If we have fewer than 2 mtu-sized packets, disable pie_drop_early,
 	 * similar to min_th in RED
 	 */
-	if (sch->qstats.backlog < 2 * mtu)
+	if (qlen < 2 * mtu)
 		return false;
 
 	/* If bytemode is turned on, use packet size to compute new
 	 * probablity. Smaller packets will have lower drop prob in this case
 	 */
-	if (q->params.bytemode && packet_size <= mtu)
+	if (params->bytemode && packet_size <= mtu)
 		local_prob = (u64)packet_size * div_u64(local_prob, mtu);
 	else
-		local_prob = q->vars.prob;
+		local_prob = vars->prob;
 
 	if (local_prob == 0) {
-		q->vars.accu_prob = 0;
-		q->vars.accu_prob_overflows = 0;
+		vars->accu_prob = 0;
+		vars->accu_prob_overflows = 0;
 	}
 
-	if (local_prob > MAX_PROB - q->vars.accu_prob)
-		q->vars.accu_prob_overflows++;
+	if (local_prob > MAX_PROB - vars->accu_prob)
+		vars->accu_prob_overflows++;
 
-	q->vars.accu_prob += local_prob;
+	vars->accu_prob += local_prob;
 
-	if (q->vars.accu_prob_overflows == 0 &&
-	    q->vars.accu_prob < (MAX_PROB / 100) * 85)
+	if (vars->accu_prob_overflows == 0 &&
+	    vars->accu_prob < (MAX_PROB / 100) * 85)
 		return false;
-	if (q->vars.accu_prob_overflows == 8 &&
-	    q->vars.accu_prob >= MAX_PROB / 2)
+	if (vars->accu_prob_overflows == 8 &&
+	    vars->accu_prob >= MAX_PROB / 2)
 		return true;
 
 	prandom_bytes(&rnd, 8);
 	if (rnd < local_prob) {
-		q->vars.accu_prob = 0;
-		q->vars.accu_prob_overflows = 0;
+		vars->accu_prob = 0;
+		vars->accu_prob_overflows = 0;
 		return true;
 	}
 
 	return false;
 }
+EXPORT_SYMBOL_GPL(pie_drop_early);
 
 static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			     struct sk_buff **to_free)
@@ -100,7 +101,8 @@ static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		goto out;
 	}
 
-	if (!drop_early(sch, skb->len)) {
+	if (!pie_drop_early(sch, &q->params, &q->vars, sch->qstats.backlog,
+			    skb->len)) {
 		enqueue = true;
 	} else if (q->params.ecn && (q->vars.prob <= MAX_PROB / 10) &&
 		   INET_ECN_set_ce(skb)) {
@@ -212,26 +214,25 @@ static int pie_change(struct Qdisc *sch, struct nlattr *opt,
 	return 0;
 }
 
-static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
+void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
+			 struct pie_vars *vars, u32 qlen)
 {
-	struct pie_sched_data *q = qdisc_priv(sch);
-	int qlen = sch->qstats.backlog;	/* current queue size in bytes */
 	psched_time_t now = psched_get_time();
 	u32 dtime = 0;
 
 	/* If dq_rate_estimator is disabled, calculate qdelay using the
 	 * packet timestamp.
 	 */
-	if (!q->params.dq_rate_estimator) {
-		q->vars.qdelay = now - pie_get_enqueue_time(skb);
+	if (!params->dq_rate_estimator) {
+		vars->qdelay = now - pie_get_enqueue_time(skb);
 
-		if (q->vars.dq_tstamp != DTIME_INVALID)
-			dtime = now - q->vars.dq_tstamp;
+		if (vars->dq_tstamp != DTIME_INVALID)
+			dtime = now - vars->dq_tstamp;
 
-		q->vars.dq_tstamp = now;
+		vars->dq_tstamp = now;
 
 		if (qlen == 0)
-			q->vars.qdelay = 0;
+			vars->qdelay = 0;
 
 		if (dtime == 0)
 			return;
@@ -243,9 +244,9 @@ static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
 	 * we have enough packets to calculate the drain rate. Save
 	 * current time as dq_tstamp and start measurement cycle.
 	 */
-	if (qlen >= QUEUE_THRESHOLD && q->vars.dq_count == DQCOUNT_INVALID) {
-		q->vars.dq_tstamp = psched_get_time();
-		q->vars.dq_count = 0;
+	if (qlen >= QUEUE_THRESHOLD && vars->dq_count == DQCOUNT_INVALID) {
+		vars->dq_tstamp = psched_get_time();
+		vars->dq_count = 0;
 	}
 
 	/* Calculate the average drain rate from this value. If queue length
@@ -257,25 +258,25 @@ static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
 	 * in bytes, time difference in psched_time, hence rate is in
 	 * bytes/psched_time.
 	 */
-	if (q->vars.dq_count != DQCOUNT_INVALID) {
-		q->vars.dq_count += skb->len;
+	if (vars->dq_count != DQCOUNT_INVALID) {
+		vars->dq_count += skb->len;
 
-		if (q->vars.dq_count >= QUEUE_THRESHOLD) {
-			u32 count = q->vars.dq_count << PIE_SCALE;
+		if (vars->dq_count >= QUEUE_THRESHOLD) {
+			u32 count = vars->dq_count << PIE_SCALE;
 
-			dtime = now - q->vars.dq_tstamp;
+			dtime = now - vars->dq_tstamp;
 
 			if (dtime == 0)
 				return;
 
 			count = count / dtime;
 
-			if (q->vars.avg_dq_rate == 0)
-				q->vars.avg_dq_rate = count;
+			if (vars->avg_dq_rate == 0)
+				vars->avg_dq_rate = count;
 			else
-				q->vars.avg_dq_rate =
-				    (q->vars.avg_dq_rate -
-				     (q->vars.avg_dq_rate >> 3)) + (count >> 3);
+				vars->avg_dq_rate =
+				    (vars->avg_dq_rate -
+				     (vars->avg_dq_rate >> 3)) + (count >> 3);
 
 			/* If the queue has receded below the threshold, we hold
 			 * on to the last drain rate calculated, else we reset
@@ -283,10 +284,10 @@ static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
 			 * packet is dequeued
 			 */
 			if (qlen < QUEUE_THRESHOLD) {
-				q->vars.dq_count = DQCOUNT_INVALID;
+				vars->dq_count = DQCOUNT_INVALID;
 			} else {
-				q->vars.dq_count = 0;
-				q->vars.dq_tstamp = psched_get_time();
+				vars->dq_count = 0;
+				vars->dq_tstamp = psched_get_time();
 			}
 
 			goto burst_allowance_reduction;
@@ -296,18 +297,18 @@ static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
 	return;
 
 burst_allowance_reduction:
-	if (q->vars.burst_time > 0) {
-		if (q->vars.burst_time > dtime)
-			q->vars.burst_time -= dtime;
+	if (vars->burst_time > 0) {
+		if (vars->burst_time > dtime)
+			vars->burst_time -= dtime;
 		else
-			q->vars.burst_time = 0;
+			vars->burst_time = 0;
 	}
 }
+EXPORT_SYMBOL_GPL(pie_process_dequeue);
 
-static void calculate_probability(struct Qdisc *sch)
+void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
+			       u32 qlen)
 {
-	struct pie_sched_data *q = qdisc_priv(sch);
-	u32 qlen = sch->qstats.backlog;	/* queue size in bytes */
 	psched_time_t qdelay = 0;	/* in pschedtime */
 	psched_time_t qdelay_old = 0;	/* in pschedtime */
 	s64 delta = 0;		/* determines the change in probability */
@@ -316,17 +317,17 @@ static void calculate_probability(struct Qdisc *sch)
 	u32 power;
 	bool update_prob = true;
 
-	if (q->params.dq_rate_estimator) {
-		qdelay_old = q->vars.qdelay;
-		q->vars.qdelay_old = q->vars.qdelay;
+	if (params->dq_rate_estimator) {
+		qdelay_old = vars->qdelay;
+		vars->qdelay_old = vars->qdelay;
 
-		if (q->vars.avg_dq_rate > 0)
-			qdelay = (qlen << PIE_SCALE) / q->vars.avg_dq_rate;
+		if (vars->avg_dq_rate > 0)
+			qdelay = (qlen << PIE_SCALE) / vars->avg_dq_rate;
 		else
 			qdelay = 0;
 	} else {
-		qdelay = q->vars.qdelay;
-		qdelay_old = q->vars.qdelay_old;
+		qdelay = vars->qdelay;
+		qdelay_old = vars->qdelay_old;
 	}
 
 	/* If qdelay is zero and qlen is not, it means qlen is very small,
@@ -342,18 +343,18 @@ static void calculate_probability(struct Qdisc *sch)
 	 * probability. alpha/beta are updated locally below by scaling down
 	 * by 16 to come to 0-2 range.
 	 */
-	alpha = ((u64)q->params.alpha * (MAX_PROB / PSCHED_TICKS_PER_SEC)) >> 4;
-	beta = ((u64)q->params.beta * (MAX_PROB / PSCHED_TICKS_PER_SEC)) >> 4;
+	alpha = ((u64)params->alpha * (MAX_PROB / PSCHED_TICKS_PER_SEC)) >> 4;
+	beta = ((u64)params->beta * (MAX_PROB / PSCHED_TICKS_PER_SEC)) >> 4;
 
 	/* We scale alpha and beta differently depending on how heavy the
 	 * congestion is. Please see RFC 8033 for details.
 	 */
-	if (q->vars.prob < MAX_PROB / 10) {
+	if (vars->prob < MAX_PROB / 10) {
 		alpha >>= 1;
 		beta >>= 1;
 
 		power = 100;
-		while (q->vars.prob < div_u64(MAX_PROB, power) &&
+		while (vars->prob < div_u64(MAX_PROB, power) &&
 		       power <= 1000000) {
 			alpha >>= 2;
 			beta >>= 2;
@@ -362,14 +363,14 @@ static void calculate_probability(struct Qdisc *sch)
 	}
 
 	/* alpha and beta should be between 0 and 32, in multiples of 1/16 */
-	delta += alpha * (u64)(qdelay - q->params.target);
+	delta += alpha * (u64)(qdelay - params->target);
 	delta += beta * (u64)(qdelay - qdelay_old);
 
-	oldprob = q->vars.prob;
+	oldprob = vars->prob;
 
 	/* to ensure we increase probability in steps of no more than 2% */
 	if (delta > (s64)(MAX_PROB / (100 / 2)) &&
-	    q->vars.prob >= MAX_PROB / 10)
+	    vars->prob >= MAX_PROB / 10)
 		delta = (MAX_PROB / 100) * 2;
 
 	/* Non-linear drop:
@@ -380,12 +381,12 @@ static void calculate_probability(struct Qdisc *sch)
 	if (qdelay > (PSCHED_NS2TICKS(250 * NSEC_PER_MSEC)))
 		delta += MAX_PROB / (100 / 2);
 
-	q->vars.prob += delta;
+	vars->prob += delta;
 
 	if (delta > 0) {
 		/* prevent overflow */
-		if (q->vars.prob < oldprob) {
-			q->vars.prob = MAX_PROB;
+		if (vars->prob < oldprob) {
+			vars->prob = MAX_PROB;
 			/* Prevent normalization error. If probability is at
 			 * maximum value already, we normalize it here, and
 			 * skip the check to do a non-linear drop in the next
@@ -395,8 +396,8 @@ static void calculate_probability(struct Qdisc *sch)
 		}
 	} else {
 		/* prevent underflow */
-		if (q->vars.prob > oldprob)
-			q->vars.prob = 0;
+		if (vars->prob > oldprob)
+			vars->prob = 0;
 	}
 
 	/* Non-linear drop in probability: Reduce drop probability quickly if
@@ -405,10 +406,10 @@ static void calculate_probability(struct Qdisc *sch)
 
 	if (qdelay == 0 && qdelay_old == 0 && update_prob)
 		/* Reduce drop probability to 98.4% */
-		q->vars.prob -= q->vars.prob / 64u;
+		vars->prob -= vars->prob / 64;
 
-	q->vars.qdelay = qdelay;
-	q->vars.qlen_old = qlen;
+	vars->qdelay = qdelay;
+	vars->qlen_old = qlen;
 
 	/* We restart the measurement cycle if the following conditions are met
 	 * 1. If the delay has been low for 2 consecutive Tupdate periods
@@ -416,16 +417,17 @@ static void calculate_probability(struct Qdisc *sch)
 	 * 3. If average dq_rate_estimator is enabled, we have atleast one
 	 *    estimate for the avg_dq_rate ie., is a non-zero value
 	 */
-	if ((q->vars.qdelay < q->params.target / 2) &&
-	    (q->vars.qdelay_old < q->params.target / 2) &&
-	    q->vars.prob == 0 &&
-	    (!q->params.dq_rate_estimator || q->vars.avg_dq_rate > 0)) {
-		pie_vars_init(&q->vars);
+	if ((vars->qdelay < params->target / 2) &&
+	    (vars->qdelay_old < params->target / 2) &&
+	    vars->prob == 0 &&
+	    (!params->dq_rate_estimator || vars->avg_dq_rate > 0)) {
+		pie_vars_init(vars);
 	}
 
-	if (!q->params.dq_rate_estimator)
-		q->vars.qdelay_old = qdelay;
+	if (!params->dq_rate_estimator)
+		vars->qdelay_old = qdelay;
 }
+EXPORT_SYMBOL_GPL(pie_calculate_probability);
 
 static void pie_timer(struct timer_list *t)
 {
@@ -434,7 +436,7 @@ static void pie_timer(struct timer_list *t)
 	spinlock_t *root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 
 	spin_lock(root_lock);
-	calculate_probability(sch);
+	pie_calculate_probability(&q->params, &q->vars, sch->qstats.backlog);
 
 	/* reset the timer to fire after 'tupdate'. tupdate is in jiffies. */
 	if (q->params.tupdate)
@@ -523,12 +525,13 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 
 static struct sk_buff *pie_qdisc_dequeue(struct Qdisc *sch)
 {
+	struct pie_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *skb = qdisc_dequeue_head(sch);
 
 	if (!skb)
 		return NULL;
 
-	pie_process_dequeue(sch, skb);
+	pie_process_dequeue(skb, &q->params, &q->vars, sch->qstats.backlog);
 	return skb;
 }
 
-- 
2.17.1

