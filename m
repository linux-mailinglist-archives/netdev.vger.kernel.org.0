Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4193327BF4F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgI2I0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:26:07 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41015 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgI2I0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 04:26:06 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 04:26:05 EDT
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D707D5807B5;
        Tue, 29 Sep 2020 04:17:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 29 Sep 2020 04:17:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=4jg1JOk0QjgJwuBxNX8ifu+RiWrwoQDoUk3EVg9VD80=; b=XuvS0ov7
        mgIaFjbiyCt6HyeAZCPZlEe3htGrfYSieyVARjRL80+WMArnNKnmpuP53QGXtpNm
        Q7RIDGcms5frqLFNm928Rtpyl1i+UEURwxI72OwL1xg/N34yXA4yRmeEBwUsDAgi
        vC0MQoUgoRn/DI6yXE+u4rCEm93v2a03cZFIqEV6fplZdn8sy5qvk9Dj+96uyJfB
        xKZNiGKNtsVsfV1PKyxDTg4I9B5cJv56nwBJp/U/miC1Xp/GubJ7SYrADMLIB/cg
        mwU5dRvGvQqM0StOmWOWDTJCdVeyq++YzHY3bGaNlhvp9ARq2SrfKNO7qZtYagfB
        uqBI891rpzIAdQ==
X-ME-Sender: <xms:f-1yX0TZsY3Fn5FZcxwoev4JK3Xdu83d6WWtf5ivpTXca297wJ6ZUw>
    <xme:f-1yXxy2kqhaGC_zaul_QSDqDHl2LXY1RJZOybUjd9q4oqpRSd_4HtWdZpy0wjwOq
    Xhagy2-vs16tVE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudegkeen
    ucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:f-1yXx0KRbdTgItw9l5LldnBsW6lh-Nuz3Ot_hp43ZLoU44b9stDgA>
    <xmx:f-1yX4DIGs1blEKsXA6nKg8rIxJgWGpfTSTqm6pSZR7SDaPuCTv7pg>
    <xmx:f-1yX9giznZ_GCJyqU-aQ_MYCDj2coM1DdF2xNZIMkSo2eawlY3QAQ>
    <xmx:f-1yX1j_xenO3OGGRBliMeiN6N0wlPxHc3QJCK1rYUpwHHYDkcGCWQ>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id C78B73280059;
        Tue, 29 Sep 2020 04:17:01 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@nvidia.com, roopa@nvidia.com, aroulin@nvidia.com,
        ayal@nvidia.com, masahiroy@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/7] drop_monitor: Remove no longer used functions
Date:   Tue, 29 Sep 2020 11:15:53 +0300
Message-Id: <20200929081556.1634838-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200929081556.1634838-1-idosch@idosch.org>
References: <20200929081556.1634838-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The old probe functions that were invoked by drop monitor code are no
longer called and can thus be removed. They were replaced by actual
probe functions that are registered on the recently introduced
'devlink_trap_report' tracepoint.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/drop_monitor.c | 142 ----------------------------------------
 1 file changed, 142 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index c14278fd6405..db6d87ddde8d 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -122,8 +122,6 @@ struct net_dm_alert_ops {
 				int work, int budget);
 	void (*work_item_func)(struct work_struct *work);
 	void (*hw_work_item_func)(struct work_struct *work);
-	void (*hw_probe)(struct sk_buff *skb,
-			 const struct net_dm_hw_metadata *hw_metadata);
 	void (*hw_trap_probe)(void *ignore, const struct devlink *devlink,
 			      struct sk_buff *skb,
 			      const struct devlink_trap_metadata *metadata);
@@ -442,49 +440,6 @@ static void net_dm_hw_summary_work(struct work_struct *work)
 	kfree(hw_entries);
 }
 
-static void
-net_dm_hw_summary_probe(struct sk_buff *skb,
-			const struct net_dm_hw_metadata *hw_metadata)
-{
-	struct net_dm_hw_entries *hw_entries;
-	struct net_dm_hw_entry *hw_entry;
-	struct per_cpu_dm_data *hw_data;
-	unsigned long flags;
-	int i;
-
-	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
-	spin_lock_irqsave(&hw_data->lock, flags);
-	hw_entries = hw_data->hw_entries;
-
-	if (!hw_entries)
-		goto out;
-
-	for (i = 0; i < hw_entries->num_entries; i++) {
-		hw_entry = &hw_entries->entries[i];
-		if (!strncmp(hw_entry->trap_name, hw_metadata->trap_name,
-			     NET_DM_MAX_HW_TRAP_NAME_LEN - 1)) {
-			hw_entry->count++;
-			goto out;
-		}
-	}
-	if (WARN_ON_ONCE(hw_entries->num_entries == dm_hit_limit))
-		goto out;
-
-	hw_entry = &hw_entries->entries[hw_entries->num_entries];
-	strlcpy(hw_entry->trap_name, hw_metadata->trap_name,
-		NET_DM_MAX_HW_TRAP_NAME_LEN - 1);
-	hw_entry->count = 1;
-	hw_entries->num_entries++;
-
-	if (!timer_pending(&hw_data->send_timer)) {
-		hw_data->send_timer.expires = jiffies + dm_delay * HZ;
-		add_timer(&hw_data->send_timer);
-	}
-
-out:
-	spin_unlock_irqrestore(&hw_data->lock, flags);
-}
-
 static void
 net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
 			     struct sk_buff *skb,
@@ -534,7 +489,6 @@ static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
 	.napi_poll_probe	= trace_napi_poll_hit,
 	.work_item_func		= send_dm_alert,
 	.hw_work_item_func	= net_dm_hw_summary_work,
-	.hw_probe		= net_dm_hw_summary_probe,
 	.hw_trap_probe		= net_dm_hw_trap_summary_probe,
 };
 
@@ -866,54 +820,6 @@ static int net_dm_hw_packet_report_fill(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
-static struct net_dm_hw_metadata *
-net_dm_hw_metadata_clone(const struct net_dm_hw_metadata *hw_metadata)
-{
-	const struct flow_action_cookie *fa_cookie;
-	struct net_dm_hw_metadata *n_hw_metadata;
-	const char *trap_group_name;
-	const char *trap_name;
-
-	n_hw_metadata = kzalloc(sizeof(*hw_metadata), GFP_ATOMIC);
-	if (!n_hw_metadata)
-		return NULL;
-
-	trap_group_name = kstrdup(hw_metadata->trap_group_name, GFP_ATOMIC);
-	if (!trap_group_name)
-		goto free_hw_metadata;
-	n_hw_metadata->trap_group_name = trap_group_name;
-
-	trap_name = kstrdup(hw_metadata->trap_name, GFP_ATOMIC);
-	if (!trap_name)
-		goto free_trap_group;
-	n_hw_metadata->trap_name = trap_name;
-
-	if (hw_metadata->fa_cookie) {
-		size_t cookie_size = sizeof(*fa_cookie) +
-				     hw_metadata->fa_cookie->cookie_len;
-
-		fa_cookie = kmemdup(hw_metadata->fa_cookie, cookie_size,
-				    GFP_ATOMIC);
-		if (!fa_cookie)
-			goto free_trap_name;
-		n_hw_metadata->fa_cookie = fa_cookie;
-	}
-
-	n_hw_metadata->input_dev = hw_metadata->input_dev;
-	if (n_hw_metadata->input_dev)
-		dev_hold(n_hw_metadata->input_dev);
-
-	return n_hw_metadata;
-
-free_trap_name:
-	kfree(trap_name);
-free_trap_group:
-	kfree(trap_group_name);
-free_hw_metadata:
-	kfree(n_hw_metadata);
-	return NULL;
-}
-
 static struct net_dm_hw_metadata *
 net_dm_hw_metadata_copy(const struct devlink_trap_metadata *metadata)
 {
@@ -1027,53 +933,6 @@ static void net_dm_hw_packet_work(struct work_struct *work)
 		net_dm_hw_packet_report(skb);
 }
 
-static void
-net_dm_hw_packet_probe(struct sk_buff *skb,
-		       const struct net_dm_hw_metadata *hw_metadata)
-{
-	struct net_dm_hw_metadata *n_hw_metadata;
-	ktime_t tstamp = ktime_get_real();
-	struct per_cpu_dm_data *hw_data;
-	struct sk_buff *nskb;
-	unsigned long flags;
-
-	if (!skb_mac_header_was_set(skb))
-		return;
-
-	nskb = skb_clone(skb, GFP_ATOMIC);
-	if (!nskb)
-		return;
-
-	n_hw_metadata = net_dm_hw_metadata_clone(hw_metadata);
-	if (!n_hw_metadata)
-		goto free;
-
-	NET_DM_SKB_CB(nskb)->hw_metadata = n_hw_metadata;
-	nskb->tstamp = tstamp;
-
-	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
-
-	spin_lock_irqsave(&hw_data->drop_queue.lock, flags);
-	if (skb_queue_len(&hw_data->drop_queue) < net_dm_queue_len)
-		__skb_queue_tail(&hw_data->drop_queue, nskb);
-	else
-		goto unlock_free;
-	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
-
-	schedule_work(&hw_data->dm_alert_work);
-
-	return;
-
-unlock_free:
-	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
-	u64_stats_update_begin(&hw_data->stats.syncp);
-	hw_data->stats.dropped++;
-	u64_stats_update_end(&hw_data->stats.syncp);
-	net_dm_hw_metadata_free(n_hw_metadata);
-free:
-	consume_skb(nskb);
-}
-
 static void
 net_dm_hw_trap_packet_probe(void *ignore, const struct devlink *devlink,
 			    struct sk_buff *skb,
@@ -1127,7 +986,6 @@ static const struct net_dm_alert_ops net_dm_alert_packet_ops = {
 	.napi_poll_probe	= net_dm_packet_trace_napi_poll_hit,
 	.work_item_func		= net_dm_packet_work,
 	.hw_work_item_func	= net_dm_hw_packet_work,
-	.hw_probe		= net_dm_hw_packet_probe,
 	.hw_trap_probe		= net_dm_hw_trap_packet_probe,
 };
 
-- 
2.26.2

