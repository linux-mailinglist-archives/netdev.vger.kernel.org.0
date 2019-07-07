Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E21615B0
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 19:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfGGR3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 13:29:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45643 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbfGGR3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 13:29:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so14553462wre.12
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 10:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F465llDp9ujZu7QBr2K8i2MbI3NU4KwdYrZ5miEiAtY=;
        b=GAVJNY3OQ04r1g7+GbnvywLESPw8a5o22z4kAcYA/00ffmRlgYFSwunhf6KOEBy6qy
         wDqPdlUZW6p+VlbZKEDAf/Hxri/iqbQLqNZySOrrQwcHYiz83c880OY5XAzdTtUvBpFc
         fb/zCXvRVhcB9ZqlgN8LAvSAueiGaSAqAOorWrK6rPiI4xRmHvLHpb6jqmw6E1/uLoPr
         1/EcjFMqazlk9Tl/OrjEpcsyGCcEpDzEGORoaO+Ds+U4I2Nuk2/A49PzGJNBHJw2EqsB
         8jt+cOOCy7zYxTnw7/kVIZ0rfXYqBA5/XFp76bUeZZgT/UMbkAETKMpec+T4cSf0tBSH
         xP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F465llDp9ujZu7QBr2K8i2MbI3NU4KwdYrZ5miEiAtY=;
        b=suhv9IlS3DXZPC+SIWi21TJk/Yb4eNKWGUR7MW6UnsjHDsl+9K99UiRP+5p0VBkfod
         1YQufkE7g+wcpYgocxYZ6+sMXZRzASg676nR92hHn4Sc9JxqiS3WXhH9tteP8PiR9a9H
         TSUKuUGxf6tB7qvbphmhjF5kuGIwVb2pA1HMQ5hv8sw8nsNhe1Wj/RnMJzR1V4P+XdSi
         3GuBkkTBOOrv5HvICSvsfcHN+rrhpa9RcV3TyCT+kZJt4ZrrZSky/QarcOXEq1Z3kdSk
         U+g+TIW0iIQxt1NECStsIa/7YifMacO4k7eQbNikz63LqPJJWoclrLekB4HuPsvoY3w+
         epyA==
X-Gm-Message-State: APjAAAVFxXD3mLVz47HvW02kfxV/QqDC4HiXT+H3hap2fkmYKKi0Eec/
        yi/8MiGugIRXERM30y/53q8=
X-Google-Smtp-Source: APXvYqyWxsq65BCKwU6NVvkQ/k9FuDEdZSu15B/POigkQvCE5nLHl5+2pYletCbFbvf9bpV2r6Gijg==
X-Received: by 2002:a5d:52cd:: with SMTP id r13mr14685701wrv.349.1562520574152;
        Sun, 07 Jul 2019 10:29:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id g14sm14280463wro.11.2019.07.07.10.29.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 10:29:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 1/6] Revert "Merge branch 'net-sched-Add-txtime-assist-support-for-taprio'"
Date:   Sun,  7 Jul 2019 20:29:16 +0300
Message-Id: <20190707172921.17731-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190707172921.17731-1-olteanv@gmail.com>
References: <20190707172921.17731-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0a7960c7922228ca975ca4c5595e5539fc8f8b79, reversing
changes made to 8747d82d3c32df488ea0fe9b86bdb53a8a04a7b8.

This returns the tc-taprio state to where it was when Voon Weifeng
<weifeng.voon@intel.com> had resent Vinicius Costa Gomes
<vinicius.gomes@intel.com>'s patch "taprio: Add support for hardware
offloading" (also resent by me in this series).

There are conflicts within the two that would otherwise propagate all
the way up to iproute2. I don't want to redefine yet a third userspace
interface, hence simply reverting the txtime-assist patches for review
purposes of taprio offload.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c |   1 -
 include/uapi/linux/pkt_sched.h            |   9 +-
 net/sched/sch_etf.c                       |  10 -
 net/sched/sch_taprio.c                    | 421 ++--------------------
 4 files changed, 36 insertions(+), 405 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f66dae72fe37..fc925adbd9fa 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -5688,7 +5688,6 @@ static void igb_tx_ctxtdesc(struct igb_ring *tx_ring,
 	 */
 	if (tx_ring->launchtime_enable) {
 		ts = ns_to_timespec64(first->skb->tstamp);
-		first->skb->tstamp = 0;
 		context_desc->seqnum_seed = cpu_to_le32(ts.tv_nsec / 32);
 	} else {
 		context_desc->seqnum_seed = 0;
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 390efb54b2e0..8b2f993cbb77 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -988,9 +988,8 @@ struct tc_etf_qopt {
 	__s32 delta;
 	__s32 clockid;
 	__u32 flags;
-#define TC_ETF_DEADLINE_MODE_ON	_BITUL(0)
-#define TC_ETF_OFFLOAD_ON	_BITUL(1)
-#define TC_ETF_SKIP_SOCK_CHECK	_BITUL(2)
+#define TC_ETF_DEADLINE_MODE_ON	BIT(0)
+#define TC_ETF_OFFLOAD_ON	BIT(1)
 };
 
 enum {
@@ -1159,8 +1158,6 @@ enum {
  *       [TCA_TAPRIO_ATTR_SCHED_ENTRY_INTERVAL]
  */
 
-#define TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST 0x1
-
 enum {
 	TCA_TAPRIO_ATTR_UNSPEC,
 	TCA_TAPRIO_ATTR_PRIOMAP, /* struct tc_mqprio_qopt */
@@ -1172,8 +1169,6 @@ enum {
 	TCA_TAPRIO_ATTR_ADMIN_SCHED, /* The admin sched, only used in dump */
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
-	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
-	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index cebfb65d8556..db0c2ba1d156 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -22,12 +22,10 @@
 
 #define DEADLINE_MODE_IS_ON(x) ((x)->flags & TC_ETF_DEADLINE_MODE_ON)
 #define OFFLOAD_IS_ON(x) ((x)->flags & TC_ETF_OFFLOAD_ON)
-#define SKIP_SOCK_CHECK_IS_SET(x) ((x)->flags & TC_ETF_SKIP_SOCK_CHECK)
 
 struct etf_sched_data {
 	bool offload;
 	bool deadline_mode;
-	bool skip_sock_check;
 	int clockid;
 	int queue;
 	s32 delta; /* in ns */
@@ -79,9 +77,6 @@ static bool is_packet_valid(struct Qdisc *sch, struct sk_buff *nskb)
 	struct sock *sk = nskb->sk;
 	ktime_t now;
 
-	if (q->skip_sock_check)
-		goto skip;
-
 	if (!sk)
 		return false;
 
@@ -97,7 +92,6 @@ static bool is_packet_valid(struct Qdisc *sch, struct sk_buff *nskb)
 	if (sk->sk_txtime_deadline_mode != q->deadline_mode)
 		return false;
 
-skip:
 	now = q->get_time();
 	if (ktime_before(txtime, now) || ktime_before(txtime, q->last))
 		return false;
@@ -391,7 +385,6 @@ static int etf_init(struct Qdisc *sch, struct nlattr *opt,
 	q->clockid = qopt->clockid;
 	q->offload = OFFLOAD_IS_ON(qopt);
 	q->deadline_mode = DEADLINE_MODE_IS_ON(qopt);
-	q->skip_sock_check = SKIP_SOCK_CHECK_IS_SET(qopt);
 
 	switch (q->clockid) {
 	case CLOCK_REALTIME:
@@ -480,9 +473,6 @@ static int etf_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (q->deadline_mode)
 		opt.flags |= TC_ETF_DEADLINE_MODE_ON;
 
-	if (q->skip_sock_check)
-		opt.flags |= TC_ETF_SKIP_SOCK_CHECK;
-
 	if (nla_put(skb, TCA_ETF_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 388750ddc57a..9ecfb8f5902a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -21,17 +21,12 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/sch_generic.h>
-#include <net/sock.h>
-#include <net/tcp.h>
 
 static LIST_HEAD(taprio_list);
 static DEFINE_SPINLOCK(taprio_list_lock);
 
 #define TAPRIO_ALL_GATES_OPEN -1
 
-#define FLAGS_VALID(flags) (!((flags) & ~TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST))
-#define TXTIME_ASSIST_IS_ENABLED(flags) ((flags) & TCA_TAPRIO_ATTR_FLAG_TXTIME_ASSIST)
-
 struct sched_entry {
 	struct list_head list;
 
@@ -40,7 +35,6 @@ struct sched_entry {
 	 * packet leaves after this time.
 	 */
 	ktime_t close_time;
-	ktime_t next_txtime;
 	atomic_t budget;
 	int index;
 	u32 gate_mask;
@@ -61,8 +55,6 @@ struct sched_gate_list {
 struct taprio_sched {
 	struct Qdisc **qdiscs;
 	struct Qdisc *root;
-	u32 flags;
-	enum tk_offsets tk_offset;
 	int clockid;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
 				    * speeds it's sub-nanoseconds per byte
@@ -73,9 +65,9 @@ struct taprio_sched {
 	struct sched_entry __rcu *current_entry;
 	struct sched_gate_list __rcu *oper_sched;
 	struct sched_gate_list __rcu *admin_sched;
+	ktime_t (*get_time)(void);
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
-	int txtime_delay;
 };
 
 static ktime_t sched_base_time(const struct sched_gate_list *sched)
@@ -86,20 +78,6 @@ static ktime_t sched_base_time(const struct sched_gate_list *sched)
 	return ns_to_ktime(sched->base_time);
 }
 
-static ktime_t taprio_get_time(struct taprio_sched *q)
-{
-	ktime_t mono = ktime_get();
-
-	switch (q->tk_offset) {
-	case TK_OFFS_MAX:
-		return mono;
-	default:
-		return ktime_mono_to_any(mono, q->tk_offset);
-	}
-
-	return KTIME_MAX;
-}
-
 static void taprio_free_sched_cb(struct rcu_head *head)
 {
 	struct sched_gate_list *sched = container_of(head, struct sched_gate_list, rcu);
@@ -130,263 +108,20 @@ static void switch_schedules(struct taprio_sched *q,
 	*admin = NULL;
 }
 
-/* Get how much time has been already elapsed in the current cycle. */
-static s32 get_cycle_time_elapsed(struct sched_gate_list *sched, ktime_t time)
-{
-	ktime_t time_since_sched_start;
-	s32 time_elapsed;
-
-	time_since_sched_start = ktime_sub(time, sched->base_time);
-	div_s64_rem(time_since_sched_start, sched->cycle_time, &time_elapsed);
-
-	return time_elapsed;
-}
-
-static ktime_t get_interval_end_time(struct sched_gate_list *sched,
-				     struct sched_gate_list *admin,
-				     struct sched_entry *entry,
-				     ktime_t intv_start)
-{
-	s32 cycle_elapsed = get_cycle_time_elapsed(sched, intv_start);
-	ktime_t intv_end, cycle_ext_end, cycle_end;
-
-	cycle_end = ktime_add_ns(intv_start, sched->cycle_time - cycle_elapsed);
-	intv_end = ktime_add_ns(intv_start, entry->interval);
-	cycle_ext_end = ktime_add(cycle_end, sched->cycle_time_extension);
-
-	if (ktime_before(intv_end, cycle_end))
-		return intv_end;
-	else if (admin && admin != sched &&
-		 ktime_after(admin->base_time, cycle_end) &&
-		 ktime_before(admin->base_time, cycle_ext_end))
-		return admin->base_time;
-	else
-		return cycle_end;
-}
-
-static int length_to_duration(struct taprio_sched *q, int len)
-{
-	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
-}
-
-/* Returns the entry corresponding to next available interval. If
- * validate_interval is set, it only validates whether the timestamp occurs
- * when the gate corresponding to the skb's traffic class is open.
- */
-static struct sched_entry *find_entry_to_transmit(struct sk_buff *skb,
-						  struct Qdisc *sch,
-						  struct sched_gate_list *sched,
-						  struct sched_gate_list *admin,
-						  ktime_t time,
-						  ktime_t *interval_start,
-						  ktime_t *interval_end,
-						  bool validate_interval)
-{
-	ktime_t curr_intv_start, curr_intv_end, cycle_end, packet_transmit_time;
-	ktime_t earliest_txtime = KTIME_MAX, txtime, cycle, transmit_end_time;
-	struct sched_entry *entry = NULL, *entry_found = NULL;
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	bool entry_available = false;
-	s32 cycle_elapsed;
-	int tc, n;
-
-	tc = netdev_get_prio_tc_map(dev, skb->priority);
-	packet_transmit_time = length_to_duration(q, qdisc_pkt_len(skb));
-
-	*interval_start = 0;
-	*interval_end = 0;
-
-	if (!sched)
-		return NULL;
-
-	cycle = sched->cycle_time;
-	cycle_elapsed = get_cycle_time_elapsed(sched, time);
-	curr_intv_end = ktime_sub_ns(time, cycle_elapsed);
-	cycle_end = ktime_add_ns(curr_intv_end, cycle);
-
-	list_for_each_entry(entry, &sched->entries, list) {
-		curr_intv_start = curr_intv_end;
-		curr_intv_end = get_interval_end_time(sched, admin, entry,
-						      curr_intv_start);
-
-		if (ktime_after(curr_intv_start, cycle_end))
-			break;
-
-		if (!(entry->gate_mask & BIT(tc)) ||
-		    packet_transmit_time > entry->interval)
-			continue;
-
-		txtime = entry->next_txtime;
-
-		if (ktime_before(txtime, time) || validate_interval) {
-			transmit_end_time = ktime_add_ns(time, packet_transmit_time);
-			if ((ktime_before(curr_intv_start, time) &&
-			     ktime_before(transmit_end_time, curr_intv_end)) ||
-			    (ktime_after(curr_intv_start, time) && !validate_interval)) {
-				entry_found = entry;
-				*interval_start = curr_intv_start;
-				*interval_end = curr_intv_end;
-				break;
-			} else if (!entry_available && !validate_interval) {
-				/* Here, we are just trying to find out the
-				 * first available interval in the next cycle.
-				 */
-				entry_available = 1;
-				entry_found = entry;
-				*interval_start = ktime_add_ns(curr_intv_start, cycle);
-				*interval_end = ktime_add_ns(curr_intv_end, cycle);
-			}
-		} else if (ktime_before(txtime, earliest_txtime) &&
-			   !entry_available) {
-			earliest_txtime = txtime;
-			entry_found = entry;
-			n = div_s64(ktime_sub(txtime, curr_intv_start), cycle);
-			*interval_start = ktime_add(curr_intv_start, n * cycle);
-			*interval_end = ktime_add(curr_intv_end, n * cycle);
-		}
-	}
-
-	return entry_found;
-}
-
-static bool is_valid_interval(struct sk_buff *skb, struct Qdisc *sch)
+static ktime_t get_cycle_time(struct sched_gate_list *sched)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct sched_gate_list *sched, *admin;
-	ktime_t interval_start, interval_end;
 	struct sched_entry *entry;
+	ktime_t cycle = 0;
 
-	rcu_read_lock();
-	sched = rcu_dereference(q->oper_sched);
-	admin = rcu_dereference(q->admin_sched);
-
-	entry = find_entry_to_transmit(skb, sch, sched, admin, skb->tstamp,
-				       &interval_start, &interval_end, true);
-	rcu_read_unlock();
+	if (sched->cycle_time != 0)
+		return sched->cycle_time;
 
-	return entry;
-}
+	list_for_each_entry(entry, &sched->entries, list)
+		cycle = ktime_add_ns(cycle, entry->interval);
 
-/* This returns the tstamp value set by TCP in terms of the set clock. */
-static ktime_t get_tcp_tstamp(struct taprio_sched *q, struct sk_buff *skb)
-{
-	unsigned int offset = skb_network_offset(skb);
-	const struct ipv6hdr *ipv6h;
-	const struct iphdr *iph;
-	struct ipv6hdr _ipv6h;
+	sched->cycle_time = cycle;
 
-	ipv6h = skb_header_pointer(skb, offset, sizeof(_ipv6h), &_ipv6h);
-	if (!ipv6h)
-		return 0;
-
-	if (ipv6h->version == 4) {
-		iph = (struct iphdr *)ipv6h;
-		offset += iph->ihl * 4;
-
-		/* special-case 6in4 tunnelling, as that is a common way to get
-		 * v6 connectivity in the home
-		 */
-		if (iph->protocol == IPPROTO_IPV6) {
-			ipv6h = skb_header_pointer(skb, offset,
-						   sizeof(_ipv6h), &_ipv6h);
-
-			if (!ipv6h || ipv6h->nexthdr != IPPROTO_TCP)
-				return 0;
-		} else if (iph->protocol != IPPROTO_TCP) {
-			return 0;
-		}
-	} else if (ipv6h->version == 6 && ipv6h->nexthdr != IPPROTO_TCP) {
-		return 0;
-	}
-
-	return ktime_mono_to_any(skb->skb_mstamp_ns, q->tk_offset);
-}
-
-/* There are a few scenarios where we will have to modify the txtime from
- * what is read from next_txtime in sched_entry. They are:
- * 1. If txtime is in the past,
- *    a. The gate for the traffic class is currently open and packet can be
- *       transmitted before it closes, schedule the packet right away.
- *    b. If the gate corresponding to the traffic class is going to open later
- *       in the cycle, set the txtime of packet to the interval start.
- * 2. If txtime is in the future, there are packets corresponding to the
- *    current traffic class waiting to be transmitted. So, the following
- *    possibilities exist:
- *    a. We can transmit the packet before the window containing the txtime
- *       closes.
- *    b. The window might close before the transmission can be completed
- *       successfully. So, schedule the packet in the next open window.
- */
-static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
-{
-	ktime_t transmit_end_time, interval_end, interval_start, tcp_tstamp;
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct sched_gate_list *sched, *admin;
-	ktime_t minimum_time, now, txtime;
-	int len, packet_transmit_time;
-	struct sched_entry *entry;
-	bool sched_changed;
-
-	now = taprio_get_time(q);
-	minimum_time = ktime_add_ns(now, q->txtime_delay);
-
-	tcp_tstamp = get_tcp_tstamp(q, skb);
-	minimum_time = max_t(ktime_t, minimum_time, tcp_tstamp);
-
-	rcu_read_lock();
-	admin = rcu_dereference(q->admin_sched);
-	sched = rcu_dereference(q->oper_sched);
-	if (admin && ktime_after(minimum_time, admin->base_time))
-		switch_schedules(q, &admin, &sched);
-
-	/* Until the schedule starts, all the queues are open */
-	if (!sched || ktime_before(minimum_time, sched->base_time)) {
-		txtime = minimum_time;
-		goto done;
-	}
-
-	len = qdisc_pkt_len(skb);
-	packet_transmit_time = length_to_duration(q, len);
-
-	do {
-		sched_changed = 0;
-
-		entry = find_entry_to_transmit(skb, sch, sched, admin,
-					       minimum_time,
-					       &interval_start, &interval_end,
-					       false);
-		if (!entry) {
-			txtime = 0;
-			goto done;
-		}
-
-		txtime = entry->next_txtime;
-		txtime = max_t(ktime_t, txtime, minimum_time);
-		txtime = max_t(ktime_t, txtime, interval_start);
-
-		if (admin && admin != sched &&
-		    ktime_after(txtime, admin->base_time)) {
-			sched = admin;
-			sched_changed = 1;
-			continue;
-		}
-
-		transmit_end_time = ktime_add(txtime, packet_transmit_time);
-		minimum_time = transmit_end_time;
-
-		/* Update the txtime of current entry to the next time it's
-		 * interval starts.
-		 */
-		if (ktime_after(transmit_end_time, interval_end))
-			entry->next_txtime = ktime_add(interval_start, sched->cycle_time);
-	} while (sched_changed || ktime_after(transmit_end_time, interval_end));
-
-	entry->next_txtime = transmit_end_time;
-
-done:
-	rcu_read_unlock();
-	return txtime;
+	return cycle;
 }
 
 static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
@@ -402,15 +137,6 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (unlikely(!child))
 		return qdisc_drop(skb, sch, to_free);
 
-	if (skb->sk && sock_flag(skb->sk, SOCK_TXTIME)) {
-		if (!is_valid_interval(skb, sch))
-			return qdisc_drop(skb, sch, to_free);
-	} else if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-		skb->tstamp = get_packet_txtime(skb, sch);
-		if (!skb->tstamp)
-			return qdisc_drop(skb, sch, to_free);
-	}
-
 	qdisc_qstats_backlog_inc(sch, skb);
 	sch->q.qlen++;
 
@@ -446,9 +172,6 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 		if (!skb)
 			continue;
 
-		if (TXTIME_ASSIST_IS_ENABLED(q->flags))
-			return skb;
-
 		prio = skb->priority;
 		tc = netdev_get_prio_tc_map(dev, prio);
 
@@ -461,6 +184,11 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 	return NULL;
 }
 
+static inline int length_to_duration(struct taprio_sched *q, int len)
+{
+	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
+}
+
 static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 {
 	atomic_set(&entry->budget,
@@ -504,13 +232,6 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 		if (unlikely(!child))
 			continue;
 
-		if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-			skb = child->ops->dequeue(child);
-			if (!skb)
-				continue;
-			goto skb_found;
-		}
-
 		skb = child->ops->peek(child);
 		if (!skb)
 			continue;
@@ -522,7 +243,7 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 			continue;
 
 		len = qdisc_pkt_len(skb);
-		guard = ktime_add_ns(taprio_get_time(q),
+		guard = ktime_add_ns(q->get_time(),
 				     length_to_duration(q, len));
 
 		/* In the case that there's no gate entry, there's no
@@ -541,7 +262,6 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 		if (unlikely(!skb))
 			goto done;
 
-skb_found:
 		qdisc_bstats_update(sch, skb);
 		qdisc_qstats_backlog_dec(sch, skb);
 		sch->q.qlen--;
@@ -804,22 +524,12 @@ static int parse_taprio_schedule(struct nlattr **tb,
 	if (err < 0)
 		return err;
 
-	if (!new->cycle_time) {
-		struct sched_entry *entry;
-		ktime_t cycle = 0;
-
-		list_for_each_entry(entry, &new->entries, list)
-			cycle = ktime_add_ns(cycle, entry->interval);
-		new->cycle_time = cycle;
-	}
-
 	return 0;
 }
 
 static int taprio_parse_mqprio_opt(struct net_device *dev,
 				   struct tc_mqprio_qopt *qopt,
-				   struct netlink_ext_ack *extack,
-				   u32 taprio_flags)
+				   struct netlink_ext_ack *extack)
 {
 	int i, j;
 
@@ -867,9 +577,6 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
 			return -EINVAL;
 		}
 
-		if (TXTIME_ASSIST_IS_ENABLED(taprio_flags))
-			continue;
-
 		/* Verify that the offset and counts do not overlap */
 		for (j = i + 1; j < qopt->num_tc; j++) {
 			if (last > qopt->offset[j]) {
@@ -891,14 +598,14 @@ static int taprio_get_start_time(struct Qdisc *sch,
 	s64 n;
 
 	base = sched_base_time(sched);
-	now = taprio_get_time(q);
+	now = q->get_time();
 
 	if (ktime_after(base, now)) {
 		*start = base;
 		return 0;
 	}
 
-	cycle = sched->cycle_time;
+	cycle = get_cycle_time(sched);
 
 	/* The qdisc is expected to have at least one sched_entry.  Moreover,
 	 * any entry must have 'interval' > 0. Thus if the cycle time is zero,
@@ -925,7 +632,7 @@ static void setup_first_close_time(struct taprio_sched *q,
 	first = list_first_entry(&sched->entries,
 				 struct sched_entry, list);
 
-	cycle = sched->cycle_time;
+	cycle = get_cycle_time(sched);
 
 	/* FIXME: find a better place to do this */
 	sched->cycle_close_time = ktime_add_ns(base, cycle);
@@ -1000,18 +707,6 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
 	return NOTIFY_DONE;
 }
 
-static void setup_txtime(struct taprio_sched *q,
-			 struct sched_gate_list *sched, ktime_t base)
-{
-	struct sched_entry *entry;
-	u32 interval = 0;
-
-	list_for_each_entry(entry, &sched->entries, list) {
-		entry->next_txtime = ktime_add_ns(base, interval);
-		interval += entry->interval;
-	}
-}
-
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
@@ -1020,7 +715,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_mqprio_qopt *mqprio = NULL;
-	u32 taprio_flags = 0;
 	int i, err, clockid;
 	unsigned long flags;
 	ktime_t start;
@@ -1033,21 +727,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	if (tb[TCA_TAPRIO_ATTR_PRIOMAP])
 		mqprio = nla_data(tb[TCA_TAPRIO_ATTR_PRIOMAP]);
 
-	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
-		taprio_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
-
-		if (q->flags != 0 && q->flags != taprio_flags) {
-			NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is not supported");
-			return -EOPNOTSUPP;
-		} else if (!FLAGS_VALID(taprio_flags)) {
-			NL_SET_ERR_MSG_MOD(extack, "Specified 'flags' are not valid");
-			return -EINVAL;
-		}
-
-		q->flags = taprio_flags;
-	}
-
-	err = taprio_parse_mqprio_opt(dev, mqprio, extack, taprio_flags);
+	err = taprio_parse_mqprio_opt(dev, mqprio, extack);
 	if (err < 0)
 		return err;
 
@@ -1106,18 +786,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	/* Protects against enqueue()/dequeue() */
 	spin_lock_bh(qdisc_lock(sch));
 
-	if (tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]) {
-		if (!TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-			NL_SET_ERR_MSG_MOD(extack, "txtime-delay can only be set when txtime-assist mode is enabled");
-			err = -EINVAL;
-			goto unlock;
-		}
-
-		q->txtime_delay = nla_get_s32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
-	}
-
-	if (!TXTIME_ASSIST_IS_ENABLED(taprio_flags) &&
-	    !hrtimer_active(&q->advance_timer)) {
+	if (!hrtimer_active(&q->advance_timer)) {
 		hrtimer_init(&q->advance_timer, q->clockid, HRTIMER_MODE_ABS);
 		q->advance_timer.function = advance_sched;
 	}
@@ -1137,16 +806,16 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 	switch (q->clockid) {
 	case CLOCK_REALTIME:
-		q->tk_offset = TK_OFFS_REAL;
+		q->get_time = ktime_get_real;
 		break;
 	case CLOCK_MONOTONIC:
-		q->tk_offset = TK_OFFS_MAX;
+		q->get_time = ktime_get;
 		break;
 	case CLOCK_BOOTTIME:
-		q->tk_offset = TK_OFFS_BOOT;
+		q->get_time = ktime_get_boottime;
 		break;
 	case CLOCK_TAI:
-		q->tk_offset = TK_OFFS_TAI;
+		q->get_time = ktime_get_clocktai;
 		break;
 	default:
 		NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
@@ -1160,35 +829,20 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		goto unlock;
 	}
 
-	if (TXTIME_ASSIST_IS_ENABLED(taprio_flags)) {
-		setup_txtime(q, new_admin, start);
-
-		if (!oper) {
-			rcu_assign_pointer(q->oper_sched, new_admin);
-			err = 0;
-			new_admin = NULL;
-			goto unlock;
-		}
-
-		rcu_assign_pointer(q->admin_sched, new_admin);
-		if (admin)
-			call_rcu(&admin->rcu, taprio_free_sched_cb);
-	} else {
-		setup_first_close_time(q, new_admin, start);
+	setup_first_close_time(q, new_admin, start);
 
-		/* Protects against advance_sched() */
-		spin_lock_irqsave(&q->current_entry_lock, flags);
+	/* Protects against advance_sched() */
+	spin_lock_irqsave(&q->current_entry_lock, flags);
 
-		taprio_start_sched(sch, start, new_admin);
+	taprio_start_sched(sch, start, new_admin);
 
-		rcu_assign_pointer(q->admin_sched, new_admin);
-		if (admin)
-			call_rcu(&admin->rcu, taprio_free_sched_cb);
+	rcu_assign_pointer(q->admin_sched, new_admin);
+	if (admin)
+		call_rcu(&admin->rcu, taprio_free_sched_cb);
+	new_admin = NULL;
 
-		spin_unlock_irqrestore(&q->current_entry_lock, flags);
-	}
+	spin_unlock_irqrestore(&q->current_entry_lock, flags);
 
-	new_admin = NULL;
 	err = 0;
 
 unlock:
@@ -1426,13 +1080,6 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (nla_put_s32(skb, TCA_TAPRIO_ATTR_SCHED_CLOCKID, q->clockid))
 		goto options_error;
 
-	if (q->flags && nla_put_u32(skb, TCA_TAPRIO_ATTR_FLAGS, q->flags))
-		goto options_error;
-
-	if (q->txtime_delay &&
-	    nla_put_s32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
-		goto options_error;
-
 	if (oper && dump_schedule(skb, oper))
 		goto options_error;
 
-- 
2.17.1

