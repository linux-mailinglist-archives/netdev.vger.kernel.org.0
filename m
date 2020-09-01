Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55691258E65
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgIAMn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIAM3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 08:29:12 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B053AC061246
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 05:29:11 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id j10so380516qvk.11
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 05:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IL4ANcGHFnhV074FMDrZQCU2Et6LC8FqWy2nOG6SQFo=;
        b=PZS/uFqozEDUNpBsHiobSKvrehQCGvRvjdh53/nzkQFkK1fJ8HZMHHs5axuxBnnH7G
         V0AGy42Fx97PyFunpgw6iVjSvRSQoh8lTL8F+OV3woYA4TMqUHi7DMBaML2tX5eX0vOi
         6o0VjF7HozvR8rALl+phck91q7ZhD4TmTJkTDoUa1Vc8cj0WinWgOrkxoDQiTg5+RqnB
         tYb6mZQ8K8/Wv5AB+e87GF1Jz1w8OAIWgyPtqOdl3NJ4l4EupajS6wFj//gCT2i1kkWG
         l8ABB27sjxl1iBIQ5AQvks6/xNkHnQAY54ajJu8v55g10hkzg/2yJH1nZyNODWP4e/sM
         Yo/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IL4ANcGHFnhV074FMDrZQCU2Et6LC8FqWy2nOG6SQFo=;
        b=g51zaKZ+5V4gS3StbZAStbIfEEyvb2oaj5BYajq46tFOzBY6zEfpxBFkSWlfZ6tjBd
         O4BFbJVNGpMi7iXkMMGadWxi97pB3wGVAAGbPiVNsJQfXe8K+JBv1Mcwu6Vr/M8Hk1J0
         P2sm6MgvfCUWS40mLQOXid4s3I/mixqtfs8pFq+xXEsyk/kgJK9Q4ZB24SXpPjS0rXez
         TzknjCNS6EEh7UQXcqfbTWqtTwbv34Px3yY1YhDYpQuvyX0JeNCCRPct7s1p5uCPTRo4
         /l6YYKdClAVfS7ke1haDLPBe6768dEhClMmWK4l14hEI4TEVlgzGzY/6RyYOI8VcABUR
         ligA==
X-Gm-Message-State: AOAM531qa5BAi6K8KXk3pdD35/z2Bo5DE6tQ8e3Ils1XzLkzRKJWXd44
        NQBnUZMmuR/5xexwKcGsrgY=
X-Google-Smtp-Source: ABdhPJwep+f4fCC1IUQ3PXaesp4mFUlpph7eolw3L2l0Yl8hG/xvUz+/4HnrBNyzIW4qWX40NLW/vA==
X-Received: by 2002:a0c:b51c:: with SMTP id d28mr1679576qve.71.1598963350903;
        Tue, 01 Sep 2020 05:29:10 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id q35sm1174220qtd.75.2020.09.01.05.29.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 05:29:10 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     sbrivio@redhat.com, davem@davemloft.net, pshelar@ovn.org,
        xiyou.wangcong@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 1/3] net: openvswitch: improve the coding style
Date:   Tue,  1 Sep 2020 20:26:12 +0800
Message-Id: <20200901122614.73464-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200901122614.73464-1-xiangxia.m.yue@gmail.com>
References: <20200901122614.73464-1-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Not change the logic, just improve the coding style.

Cc: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Acked-by: Pravin B Shelar <pshelar@ovn.org>
---
v4:
improve the codes suggested by Stefano
http://patchwork.ozlabs.org/project/netdev/patch/20200825050636.14153-2-xiangxia.m.yue@gmail.com
---
 net/openvswitch/actions.c    |  5 ++--
 net/openvswitch/datapath.c   | 38 ++++++++++++++++-------------
 net/openvswitch/flow_table.c | 46 ++++++++++++++++++++----------------
 net/openvswitch/vport.c      |  7 +++---
 4 files changed, 55 insertions(+), 41 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 2611657f40ca..573b9ad97e7d 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -742,7 +742,8 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	return 0;
 }
 
-static int ovs_vport_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+static int ovs_vport_output(struct net *net, struct sock *sk,
+			    struct sk_buff *skb)
 {
 	struct ovs_frag_data *data = this_cpu_ptr(&ovs_frag_data_storage);
 	struct vport *vport = data->vport;
@@ -925,7 +926,7 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
 	upcall.mru = OVS_CB(skb)->mru;
 
 	for (a = nla_data(attr), rem = nla_len(attr); rem > 0;
-		 a = nla_next(a, &rem)) {
+	     a = nla_next(a, &rem)) {
 		switch (nla_type(a)) {
 		case OVS_USERSPACE_ATTR_USERDATA:
 			upcall.userdata = a;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 6e47ef7ef036..bf701b7a394b 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -182,7 +182,7 @@ struct vport *ovs_lookup_vport(const struct datapath *dp, u16 port_no)
 
 	head = vport_hash_bucket(dp, port_no);
 	hlist_for_each_entry_rcu(vport, head, dp_hash_node,
-				lockdep_ovsl_is_held()) {
+				 lockdep_ovsl_is_held()) {
 		if (vport->port_no == port_no)
 			return vport;
 	}
@@ -254,7 +254,7 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
 	error = ovs_execute_actions(dp, skb, sf_acts, key);
 	if (unlikely(error))
 		net_dbg_ratelimited("ovs: action execution error on datapath %s: %d\n",
-							ovs_dp_name(dp), error);
+				    ovs_dp_name(dp), error);
 
 	stats_counter = &stats->n_hit;
 
@@ -302,7 +302,7 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
 static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 			     const struct sw_flow_key *key,
 			     const struct dp_upcall_info *upcall_info,
-				 uint32_t cutlen)
+			     uint32_t cutlen)
 {
 	unsigned int gso_type = skb_shinfo(skb)->gso_type;
 	struct sw_flow_key later_key;
@@ -1080,11 +1080,12 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 }
 
 /* Factor out action copy to avoid "Wframe-larger-than=1024" warning. */
-static noinline_for_stack struct sw_flow_actions *get_flow_actions(struct net *net,
-						const struct nlattr *a,
-						const struct sw_flow_key *key,
-						const struct sw_flow_mask *mask,
-						bool log)
+static noinline_for_stack
+struct sw_flow_actions *get_flow_actions(struct net *net,
+					 const struct nlattr *a,
+					 const struct sw_flow_key *key,
+					 const struct sw_flow_mask *mask,
+					 bool log)
 {
 	struct sw_flow_actions *acts;
 	struct sw_flow_key masked_key;
@@ -1383,7 +1384,8 @@ static int ovs_flow_cmd_del(struct sk_buff *skb, struct genl_info *info)
 
 			ovs_notify(&dp_flow_genl_family, reply, info);
 		} else {
-			netlink_set_err(sock_net(skb->sk)->genl_sock, 0, 0, PTR_ERR(reply));
+			netlink_set_err(sock_net(skb->sk)->genl_sock, 0, 0,
+					PTR_ERR(reply));
 		}
 	}
 
@@ -1513,7 +1515,7 @@ static int ovs_dp_cmd_fill_info(struct datapath *dp, struct sk_buff *skb,
 	int err;
 
 	ovs_header = genlmsg_put(skb, portid, seq, &dp_datapath_genl_family,
-				   flags, cmd);
+				 flags, cmd);
 	if (!ovs_header)
 		goto error;
 
@@ -1572,11 +1574,13 @@ static struct datapath *lookup_datapath(struct net *net,
 	return dp ? dp : ERR_PTR(-ENODEV);
 }
 
-static void ovs_dp_reset_user_features(struct sk_buff *skb, struct genl_info *info)
+static void ovs_dp_reset_user_features(struct sk_buff *skb,
+				       struct genl_info *info)
 {
 	struct datapath *dp;
 
-	dp = lookup_datapath(sock_net(skb->sk), info->userhdr, info->attrs);
+	dp = lookup_datapath(sock_net(skb->sk), info->userhdr,
+			     info->attrs);
 	if (IS_ERR(dp))
 		return;
 
@@ -2075,7 +2079,7 @@ static unsigned int ovs_get_max_headroom(struct datapath *dp)
 
 	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++) {
 		hlist_for_each_entry_rcu(vport, &dp->ports[i], dp_hash_node,
-					lockdep_ovsl_is_held()) {
+					 lockdep_ovsl_is_held()) {
 			dev = vport->dev;
 			dev_headroom = netdev_get_fwd_headroom(dev);
 			if (dev_headroom > max_headroom)
@@ -2093,10 +2097,11 @@ static void ovs_update_headroom(struct datapath *dp, unsigned int new_headroom)
 	int i;
 
 	dp->max_headroom = new_headroom;
-	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)
+	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++) {
 		hlist_for_each_entry_rcu(vport, &dp->ports[i], dp_hash_node,
-					lockdep_ovsl_is_held())
+					 lockdep_ovsl_is_held())
 			netdev_set_rx_headroom(vport->dev, new_headroom);
+	}
 }
 
 static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
@@ -2551,7 +2556,8 @@ static int __init dp_init(void)
 {
 	int err;
 
-	BUILD_BUG_ON(sizeof(struct ovs_skb_cb) > sizeof_field(struct sk_buff, cb));
+	BUILD_BUG_ON(sizeof(struct ovs_skb_cb) >
+		     sizeof_field(struct sk_buff, cb));
 
 	pr_info("Open vSwitch switching datapath\n");
 
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index e2235849a57e..441f68cf8a13 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -111,12 +111,16 @@ static void flow_free(struct sw_flow *flow)
 	if (ovs_identifier_is_key(&flow->id))
 		kfree(flow->id.unmasked_key);
 	if (flow->sf_acts)
-		ovs_nla_free_flow_actions((struct sw_flow_actions __force *)flow->sf_acts);
+		ovs_nla_free_flow_actions((struct sw_flow_actions __force *)
+					  flow->sf_acts);
 	/* We open code this to make sure cpu 0 is always considered */
-	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask))
+	for (cpu = 0; cpu < nr_cpu_ids;
+	     cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
 		if (flow->stats[cpu])
 			kmem_cache_free(flow_stats_cache,
 					(struct sw_flow_stats __force *)flow->stats[cpu]);
+	}
+
 	kmem_cache_free(flow_cache, flow);
 }
 
@@ -192,7 +196,7 @@ static void tbl_mask_array_reset_counters(struct mask_array *ma)
 	 * zero based counter we store the value at reset, and subtract it
 	 * later when processing.
 	 */
-	for (i = 0; i < ma->max; i++)  {
+	for (i = 0; i < ma->max; i++) {
 		ma->masks_usage_zero_cntr[i] = 0;
 
 		for_each_possible_cpu(cpu) {
@@ -273,7 +277,7 @@ static int tbl_mask_array_add_mask(struct flow_table *tbl,
 
 	if (ma_count >= ma->max) {
 		err = tbl_mask_array_realloc(tbl, ma->max +
-					      MASK_ARRAY_SIZE_MIN);
+						  MASK_ARRAY_SIZE_MIN);
 		if (err)
 			return err;
 
@@ -288,7 +292,7 @@ static int tbl_mask_array_add_mask(struct flow_table *tbl,
 	BUG_ON(ovsl_dereference(ma->masks[ma_count]));
 
 	rcu_assign_pointer(ma->masks[ma_count], new);
-	WRITE_ONCE(ma->count, ma_count +1);
+	WRITE_ONCE(ma->count, ma_count + 1);
 
 	return 0;
 }
@@ -309,10 +313,10 @@ static void tbl_mask_array_del_mask(struct flow_table *tbl,
 	return;
 
 found:
-	WRITE_ONCE(ma->count, ma_count -1);
+	WRITE_ONCE(ma->count, ma_count - 1);
 
-	rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
-	RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
+	rcu_assign_pointer(ma->masks[i], ma->masks[ma_count - 1]);
+	RCU_INIT_POINTER(ma->masks[ma_count - 1], NULL);
 
 	kfree_rcu(mask, rcu);
 
@@ -448,16 +452,17 @@ int ovs_flow_tbl_init(struct flow_table *table)
 
 static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
 {
-	struct table_instance *ti = container_of(rcu, struct table_instance, rcu);
+	struct table_instance *ti;
 
+	ti = container_of(rcu, struct table_instance, rcu);
 	__table_instance_destroy(ti);
 }
 
 static void table_instance_flow_free(struct flow_table *table,
-				  struct table_instance *ti,
-				  struct table_instance *ufid_ti,
-				  struct sw_flow *flow,
-				  bool count)
+				     struct table_instance *ti,
+				     struct table_instance *ufid_ti,
+				     struct sw_flow *flow,
+				     bool count)
 {
 	hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
 	if (count)
@@ -484,9 +489,9 @@ void table_instance_flow_flush(struct flow_table *table,
 		return;
 
 	for (i = 0; i < ti->n_buckets; i++) {
-		struct sw_flow *flow;
 		struct hlist_head *head = &ti->buckets[i];
 		struct hlist_node *n;
+		struct sw_flow *flow;
 
 		hlist_for_each_entry_safe(flow, n, head,
 					  flow_table.node[ti->node_ver]) {
@@ -661,7 +666,7 @@ static int flow_key_start(const struct sw_flow_key *key)
 		return 0;
 	else
 		return rounddown(offsetof(struct sw_flow_key, phy),
-					  sizeof(long));
+				 sizeof(long));
 }
 
 static bool cmp_key(const struct sw_flow_key *key1,
@@ -673,7 +678,7 @@ static bool cmp_key(const struct sw_flow_key *key1,
 	long diffs = 0;
 	int i;
 
-	for (i = key_start; i < key_end;  i += sizeof(long))
+	for (i = key_start; i < key_end; i += sizeof(long))
 		diffs |= *cp1++ ^ *cp2++;
 
 	return diffs == 0;
@@ -713,7 +718,7 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 	(*n_mask_hit)++;
 
 	hlist_for_each_entry_rcu(flow, head, flow_table.node[ti->node_ver],
-				lockdep_ovsl_is_held()) {
+				 lockdep_ovsl_is_held()) {
 		if (flow->mask == mask && flow->flow_table.hash == hash &&
 		    flow_cmp_masked_key(flow, &masked_key, &mask->range))
 			return flow;
@@ -897,7 +902,8 @@ static bool ovs_flow_cmp_ufid(const struct sw_flow *flow,
 	return !memcmp(flow->id.ufid, sfid->ufid, sfid->ufid_len);
 }
 
-bool ovs_flow_cmp(const struct sw_flow *flow, const struct sw_flow_match *match)
+bool ovs_flow_cmp(const struct sw_flow *flow,
+		  const struct sw_flow_match *match)
 {
 	if (ovs_identifier_is_ufid(&flow->id))
 		return flow_cmp_masked_key(flow, match->key, &match->range);
@@ -916,7 +922,7 @@ struct sw_flow *ovs_flow_tbl_lookup_ufid(struct flow_table *tbl,
 	hash = ufid_hash(ufid);
 	head = find_bucket(ti, hash);
 	hlist_for_each_entry_rcu(flow, head, ufid_table.node[ti->node_ver],
-				lockdep_ovsl_is_held()) {
+				 lockdep_ovsl_is_held()) {
 		if (flow->ufid_table.hash == hash &&
 		    ovs_flow_cmp_ufid(flow, ufid))
 			return flow;
@@ -1107,7 +1113,7 @@ void ovs_flow_masks_rebalance(struct flow_table *table)
 	if (!masks_and_count)
 		return;
 
-	for (i = 0; i < ma->max; i++)  {
+	for (i = 0; i < ma->max; i++) {
 		struct sw_flow_mask *mask;
 		unsigned int start;
 		int cpu;
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 0d44c5c013fa..82d801f063b7 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -98,7 +98,7 @@ struct vport *ovs_vport_locate(const struct net *net, const char *name)
 	struct vport *vport;
 
 	hlist_for_each_entry_rcu(vport, bucket, hash_node,
-				lockdep_ovsl_is_held())
+				 lockdep_ovsl_is_held())
 		if (!strcmp(name, ovs_vport_name(vport)) &&
 		    net_eq(ovs_dp_get_net(vport->dp), net))
 			return vport;
@@ -118,7 +118,7 @@ struct vport *ovs_vport_locate(const struct net *net, const char *name)
  * vport_free().
  */
 struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *ops,
-			  const struct vport_parms *parms)
+			      const struct vport_parms *parms)
 {
 	struct vport *vport;
 	size_t alloc_size;
@@ -397,7 +397,8 @@ int ovs_vport_get_upcall_portids(const struct vport *vport,
  *
  * Returns the portid of the target socket.  Must be called with rcu_read_lock.
  */
-u32 ovs_vport_find_upcall_portid(const struct vport *vport, struct sk_buff *skb)
+u32 ovs_vport_find_upcall_portid(const struct vport *vport,
+				 struct sk_buff *skb)
 {
 	struct vport_portids *ids;
 	u32 ids_index;
-- 
2.23.0

