Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCDB72F3D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfGXMxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 08:53:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34493 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfGXMxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 08:53:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so46922285wrm.1
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 05:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YMCDOz7hVhLlIz3BN36SD+eqvnHDxVI4IZiONz8Mhgo=;
        b=b4N0Y1KIXi+LoQGgp5Uqxikm/+zJkHne6Ed7sXdVqRYv9mKeEQU41WrR38eLkhFmXr
         aUSkPVg+NzILShMgEOcCRnMrDBKQVAQQ4+0D2Sf6BeDDGyWVeIgTMjig/6uo9vbrmh8f
         kXCZ4qBsjzqmLK+KeaXTmQu1rJT3Ay+M40DFyasiT/OVqwHKu2k2U/hyhZxDUQPOZkIt
         0PJMOe4bl9dwXAB0gHCkPbL0Y1mJsmtp6pEj52ck1aCFAu8/7qqnVb6d40q8YLmNddWp
         fllmWEcim3T/unPV5NUgZcab5UWOrTM2meGGbfPeLzmEKe4Ldx6uw+oZMYWpk3FvgHTS
         rDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YMCDOz7hVhLlIz3BN36SD+eqvnHDxVI4IZiONz8Mhgo=;
        b=LA4pHdVDGjstzSnup66YFYTIWhw83iGyyNZKvN5m1PPGe5zffSgKHf07Cp1eplcjkI
         iZdNPgmh0kBVS3ggJbY3499VmZrYWDGvRYqBq3dLW2jlQWpQiWb1gKFqPj5LORc4sH/P
         LrPnNSZ4N1u3/AnBaHG8nnKqV6JnQ2a/s3G+kxW1AwpJIrCq5sXuOs2t0jagABES5jP4
         vDgZBQOr+rfblG3l8R1lCCqSZW81MsUE/Gt7FhJoDLJ3LbesVg5eWtCt4aG5ocNJGeuZ
         0m4TKHYfm1b3VLR5qCiI2zhEkWG0ZL8WJRREw3EtmRnN9fH5irNdJMNZCmnAYsiAM5jb
         rhsg==
X-Gm-Message-State: APjAAAU1HXM2wjV4Hv9MYHlUDdahvLKHZUchowP5ku6FnASaTFkKYFzh
        4SB9ffkpZJoq40jnThnuZzI=
X-Google-Smtp-Source: APXvYqwMjcSesxtMuPOAhq9zDKggjl0yXG4Im/q4XEUkrx1pXT0hHz/9iPTIIJlQL148i8/lRjIEeQ==
X-Received: by 2002:adf:b1d1:: with SMTP id r17mr88594879wra.273.1563972823001;
        Wed, 24 Jul 2019 05:53:43 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id i18sm60158021wrp.91.2019.07.24.05.53.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 05:53:42 -0700 (PDT)
Date:   Wed, 24 Jul 2019 14:53:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        toke@redhat.com, andy@greyhouse.net, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 10/12] drop_monitor: Add packet alert mode
Message-ID: <20190724125341.GB2225@nanopsycho>
References: <20190722183134.14516-1-idosch@idosch.org>
 <20190722183134.14516-11-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722183134.14516-11-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 22, 2019 at 08:31:32PM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>So far drop monitor supported only one alert mode in which a summary of
>locations in which packets were recently dropped was sent to user space.
>
>This alert mode is sufficient in order to understand that packets were
>dropped, but lacks information to perform a more detailed analysis.
>
>Add a new alert mode in which the dropped packet itself is passed to
>user space along with metadata: The drop location (as program counter
>and resolved symbol), ingress / egress netdevice and arrival / departure
>timestamp. More metadata can be added in the future.
>
>To avoid performing expensive operations in the context in which
>kfree_skb() is invoked (can be hard IRQ), the dropped skb is cloned and
>queued on per-CPU skb drop list. Then, in process context the netlink
>message is allocated, prepared and finally sent to user space.
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>---
> include/uapi/linux/net_dropmon.h |  29 ++++
> net/core/drop_monitor.c          | 287 ++++++++++++++++++++++++++++++-
> 2 files changed, 308 insertions(+), 8 deletions(-)
>
>diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
>index 5edbd0a675fd..7708c8a440a1 100644
>--- a/include/uapi/linux/net_dropmon.h
>+++ b/include/uapi/linux/net_dropmon.h
>@@ -53,6 +53,7 @@ enum {
> 	NET_DM_CMD_CONFIG,
> 	NET_DM_CMD_START,
> 	NET_DM_CMD_STOP,
>+	NET_DM_CMD_PACKET_ALERT,
> 	_NET_DM_CMD_MAX,
> };
> 
>@@ -62,4 +63,32 @@ enum {
>  * Our group identifiers
>  */
> #define NET_DM_GRP_ALERT 1
>+
>+enum net_dm_attr {
>+	NET_DM_ATTR_UNSPEC,
>+
>+	NET_DM_ATTR_ALERT_MODE,			/* u8 */
>+	NET_DM_ATTR_PC,				/* u64 */
>+	NET_DM_ATTR_SYMBOL,			/* string */
>+	NET_DM_ATTR_NETDEV_IFINDEX,		/* u32 */
>+	NET_DM_ATTR_NETDEV_NAME,		/* string */
>+	NET_DM_ATTR_TIMESTAMP,			/* struct timespec */
>+	NET_DM_ATTR_PAYLOAD,			/* binary */
>+	NET_DM_ATTR_PAD,
>+
>+	__NET_DM_ATTR_MAX,
>+	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
>+};
>+
>+/**
>+ * enum net_dm_alert_mode - Alert mode.
>+ * @NET_DM_ALERT_MODE_SUMMARY: A summary of recent drops is sent to user space.
>+ * @NET_DM_ALERT_MODE_PACKET: Each dropped packet is sent to user space along
>+ *                            with metadata.
>+ */
>+enum net_dm_alert_mode {
>+	NET_DM_ALERT_MODE_SUMMARY,
>+	NET_DM_ALERT_MODE_PACKET,
>+};
>+
> #endif
>diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
>index f441fb653567..512935fc235b 100644
>--- a/net/core/drop_monitor.c
>+++ b/net/core/drop_monitor.c
>@@ -54,6 +54,7 @@ static DEFINE_MUTEX(net_dm_mutex);
> struct per_cpu_dm_data {
> 	spinlock_t		lock;	/* Protects 'skb' and 'send_timer' */
> 	struct sk_buff		*skb;
>+	struct sk_buff_head	drop_queue;
> 	struct work_struct	dm_alert_work;
> 	struct timer_list	send_timer;
> };
>@@ -75,6 +76,22 @@ static int dm_delay = 1;
> static unsigned long dm_hw_check_delta = 2*HZ;
> static LIST_HEAD(hw_stats_list);
> 
>+static enum net_dm_alert_mode net_dm_alert_mode = NET_DM_ALERT_MODE_SUMMARY;
>+
>+struct net_dm_skb_cb {
>+	void *pc;
>+};
>+
>+#define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
>+
>+struct net_dm_alert_ops {
>+	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
>+				void *location);
>+	void (*napi_poll_probe)(void *ignore, struct napi_struct *napi,
>+				int work, int budget);
>+	void (*work_item_func)(struct work_struct *work);
>+};
>+
> static int net_dm_nl_pre_doit(const struct genl_ops *ops,
> 			      struct sk_buff *skb, struct genl_info *info)
> {
>@@ -255,10 +272,194 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi,
> 	rcu_read_unlock();
> }
> 
>+static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
>+	.kfree_skb_probe	= trace_kfree_skb_hit,
>+	.napi_poll_probe	= trace_napi_poll_hit,
>+	.work_item_func		= send_dm_alert,
>+};
>+
>+static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
>+					      struct sk_buff *skb,
>+					      void *location)
>+{
>+	struct per_cpu_dm_data *data;
>+	struct sk_buff *nskb;
>+	unsigned long flags;
>+
>+	nskb = skb_clone(skb, GFP_ATOMIC);
>+	if (!nskb)
>+		return;
>+
>+	NET_DM_SKB_CB(nskb)->pc = location;
>+	if (nskb->dev)
>+		dev_hold(nskb->dev);
>+
>+	data = this_cpu_ptr(&dm_cpu_data);
>+	spin_lock_irqsave(&data->drop_queue.lock, flags);
>+
>+	__skb_queue_tail(&data->drop_queue, nskb);
>+
>+	if (!timer_pending(&data->send_timer)) {
>+		data->send_timer.expires = jiffies + dm_delay * HZ;
>+		add_timer(&data->send_timer);
>+	}
>+
>+	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
>+}
>+
>+static void net_dm_packet_trace_napi_poll_hit(void *ignore,
>+					      struct napi_struct *napi,
>+					      int work, int budget)
>+{
>+}
>+
>+#define NET_DM_MAX_SYMBOL_LEN 40
>+
>+static size_t net_dm_packet_report_size(size_t payload_len)
>+{
>+	size_t size;
>+
>+	size = nlmsg_msg_size(GENL_HDRLEN + net_drop_monitor_family.hdrsize);
>+
>+	return NLMSG_ALIGN(size) +
>+	       /* NET_DM_ATTR_PC */
>+	       nla_total_size(sizeof(u64)) +
>+	       /* NET_DM_ATTR_SYMBOL */
>+	       nla_total_size(NET_DM_MAX_SYMBOL_LEN + 1) +
>+	       /* NET_DM_ATTR_NETDEV_IFINDEX */
>+	       nla_total_size(sizeof(u32)) +
>+	       /* NET_DM_ATTR_NETDEV_NAME */
>+	       nla_total_size(IFNAMSIZ + 1) +
>+	       /* NET_DM_ATTR_TIMESTAMP */
>+	       nla_total_size(sizeof(struct timespec)) +
>+	       /* NET_DM_ATTR_PAYLOAD */
>+	       nla_total_size(payload_len);
>+}
>+
>+static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>+				     size_t payload_len)
>+{
>+	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
>+	char buf[NET_DM_MAX_SYMBOL_LEN];
>+	struct nlattr *attr;
>+	struct timespec ts;
>+	void *hdr;
>+
>+	hdr = genlmsg_put(msg, 0, 0, &net_drop_monitor_family, 0,
>+			  NET_DM_CMD_PACKET_ALERT);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
>+		goto nla_put_failure;
>+
>+	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
>+	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
>+		goto nla_put_failure;
>+
>+	if (skb->dev &&
>+	    nla_put_u32(msg, NET_DM_ATTR_NETDEV_IFINDEX, skb->dev->ifindex))
>+		goto nla_put_failure;
>+
>+	if (skb->dev &&
>+	    nla_put_string(msg, NET_DM_ATTR_NETDEV_NAME, skb->dev->name))
>+		goto nla_put_failure;
>+
>+	if (ktime_to_timespec_cond(skb->tstamp, &ts) &&
>+	    nla_put(msg, NET_DM_ATTR_TIMESTAMP, sizeof(ts), &ts))
>+		goto nla_put_failure;
>+
>+	if (!payload_len)
>+		goto out;
>+
>+	attr = skb_put(msg, nla_total_size(payload_len));
>+	attr->nla_type = NET_DM_ATTR_PAYLOAD;
>+	attr->nla_len = nla_attr_size(payload_len);
>+	if (skb_copy_bits(skb, 0, nla_data(attr), payload_len))
>+		goto nla_put_failure;
>+
>+out:
>+	genlmsg_end(msg, hdr);
>+
>+	return 0;
>+
>+nla_put_failure:
>+	genlmsg_cancel(msg, hdr);
>+	return -EMSGSIZE;
>+}
>+
>+#define NET_DM_MAX_PACKET_SIZE (0xffff - NLA_HDRLEN - NLA_ALIGNTO)
>+
>+static void net_dm_packet_report(struct sk_buff *skb)
>+{
>+	struct sk_buff *msg;
>+	size_t payload_len;
>+	int rc;
>+
>+	/* Make sure we start copying the packet from the MAC header */
>+	if (skb->data > skb_mac_header(skb))
>+		skb_push(skb, skb->data - skb_mac_header(skb));
>+	else
>+		skb_pull(skb, skb_mac_header(skb) - skb->data);
>+
>+	/* Ensure packet fits inside a single netlink attribute */
>+	payload_len = min_t(size_t, skb->len, NET_DM_MAX_PACKET_SIZE);
>+
>+	msg = nlmsg_new(net_dm_packet_report_size(payload_len), GFP_KERNEL);
>+	if (!msg)
>+		goto out;
>+
>+	rc = net_dm_packet_report_fill(msg, skb, payload_len);
>+	if (rc) {
>+		nlmsg_free(msg);
>+		goto out;
>+	}
>+
>+	genlmsg_multicast(&net_drop_monitor_family, msg, 0, 0, GFP_KERNEL);
>+
>+out:
>+	if (skb->dev)
>+		dev_put(skb->dev);
>+	consume_skb(skb);
>+}
>+
>+static void net_dm_packet_work(struct work_struct *work)
>+{
>+	struct per_cpu_dm_data *data;
>+	struct sk_buff_head list;
>+	struct sk_buff *skb;
>+	unsigned long flags;
>+
>+	data = container_of(work, struct per_cpu_dm_data, dm_alert_work);
>+
>+	__skb_queue_head_init(&list);
>+
>+	spin_lock_irqsave(&data->drop_queue.lock, flags);
>+	skb_queue_splice_tail_init(&data->drop_queue, &list);
>+	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
>+
>+	while ((skb = __skb_dequeue(&list)))
>+		net_dm_packet_report(skb);
>+}
>+
>+static const struct net_dm_alert_ops net_dm_alert_packet_ops = {
>+	.kfree_skb_probe	= net_dm_packet_trace_kfree_skb_hit,
>+	.napi_poll_probe	= net_dm_packet_trace_napi_poll_hit,
>+	.work_item_func		= net_dm_packet_work,
>+};
>+
>+static const struct net_dm_alert_ops *net_dm_alert_ops_arr[] = {
>+	[NET_DM_ALERT_MODE_SUMMARY]	= &net_dm_alert_summary_ops,
>+	[NET_DM_ALERT_MODE_PACKET]	= &net_dm_alert_packet_ops,
>+};

Please split this patch into 2:
1) introducing the ops and modes (only summary)
2) introducing the packet mode


>+
> static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
> {
>+	const struct net_dm_alert_ops *ops;
> 	int cpu, rc;
> 
>+	ops = net_dm_alert_ops_arr[net_dm_alert_mode];
>+
> 	if (!try_module_get(THIS_MODULE)) {
> 		NL_SET_ERR_MSG_MOD(extack, "Failed to take reference on module");
> 		return -ENODEV;
>@@ -267,17 +468,17 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
> 	for_each_possible_cpu(cpu) {
> 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
> 
>-		INIT_WORK(&data->dm_alert_work, send_dm_alert);
>+		INIT_WORK(&data->dm_alert_work, ops->work_item_func);
> 		timer_setup(&data->send_timer, sched_send_work, 0);
> 	}
> 
>-	rc = register_trace_kfree_skb(trace_kfree_skb_hit, NULL);
>+	rc = register_trace_kfree_skb(ops->kfree_skb_probe, NULL);
> 	if (rc) {
> 		NL_SET_ERR_MSG_MOD(extack, "Failed to connect probe to kfree_skb() tracepoint");
> 		goto err_module_put;
> 	}
> 
>-	rc = register_trace_napi_poll(trace_napi_poll_hit, NULL);
>+	rc = register_trace_napi_poll(ops->napi_poll_probe, NULL);
> 	if (rc) {
> 		NL_SET_ERR_MSG_MOD(extack, "Failed to connect probe to napi_poll() tracepoint");
> 		goto err_unregister_trace;
>@@ -286,7 +487,7 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
> 	return 0;
> 
> err_unregister_trace:
>-	unregister_trace_kfree_skb(trace_kfree_skb_hit, NULL);
>+	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
> err_module_put:
> 	module_put(THIS_MODULE);
> 	return rc;
>@@ -295,10 +496,13 @@ static int net_dm_trace_on_set(struct netlink_ext_ack *extack)
> static void net_dm_trace_off_set(void)
> {
> 	struct dm_hw_stat_delta *new_stat, *temp;
>+	const struct net_dm_alert_ops *ops;
> 	int cpu;
> 
>-	unregister_trace_napi_poll(trace_napi_poll_hit, NULL);
>-	unregister_trace_kfree_skb(trace_kfree_skb_hit, NULL);
>+	ops = net_dm_alert_ops_arr[net_dm_alert_mode];
>+
>+	unregister_trace_napi_poll(ops->napi_poll_probe, NULL);
>+	unregister_trace_kfree_skb(ops->kfree_skb_probe, NULL);
> 
> 	tracepoint_synchronize_unregister();
> 
>@@ -307,9 +511,18 @@ static void net_dm_trace_off_set(void)
> 	 */
> 	for_each_possible_cpu(cpu) {
> 		struct per_cpu_dm_data *data = &per_cpu(dm_cpu_data, cpu);
>+		struct sk_buff *skb;
> 
> 		del_timer_sync(&data->send_timer);
> 		cancel_work_sync(&data->dm_alert_work);
>+		/* If we deactivated a pending timer, some packets are still
>+		 * queued and we need to free them.
>+		 */
>+		while ((skb = __skb_dequeue(&data->drop_queue))) {
>+			if (skb->dev)
>+				dev_put(skb->dev);
>+			consume_skb(skb);
>+		}
> 	}
> 
> 	list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
>@@ -351,12 +564,61 @@ static int set_all_monitor_traces(int state, struct netlink_ext_ack *extack)
> 	return rc;
> }
> 
>+static int net_dm_alert_mode_get_from_info(struct genl_info *info,
>+					   enum net_dm_alert_mode *p_alert_mode)
>+{
>+	u8 val;
>+
>+	val = nla_get_u8(info->attrs[NET_DM_ATTR_ALERT_MODE]);
>+
>+	switch (val) {
>+	case NET_DM_ALERT_MODE_SUMMARY: /* fall-through */
>+	case NET_DM_ALERT_MODE_PACKET:
>+		*p_alert_mode = val;
>+		break;
>+	default:
>+		return -EINVAL;
>+	}
>+
>+	return 0;
>+}
>+
>+static int net_dm_alert_mode_set(struct genl_info *info)
>+{
>+	struct netlink_ext_ack *extack = info->extack;
>+	enum net_dm_alert_mode alert_mode;
>+	int rc;
>+
>+	if (!info->attrs[NET_DM_ATTR_ALERT_MODE])
>+		return 0;
>+
>+	rc = net_dm_alert_mode_get_from_info(info, &alert_mode);
>+	if (rc) {
>+		NL_SET_ERR_MSG_MOD(extack, "Invalid alert mode");
>+		return -EINVAL;
>+	}
>+
>+	net_dm_alert_mode = alert_mode;

2 things:
1) Shouldn't you check if the tracing is on and return -EBUSY in case it is?
2) You setup the mode globally. I guess it is fine and it does not make
   sense to do it otherwise, right? Like per-net or something.


>+
>+	return 0;
>+}
>+
> static int net_dm_cmd_config(struct sk_buff *skb,
> 			struct genl_info *info)
> {
>-	NL_SET_ERR_MSG_MOD(info->extack, "Command not supported");
>+	struct netlink_ext_ack *extack = info->extack;
>+	int rc;
> 
>-	return -EOPNOTSUPP;
>+	if (trace_state == TRACE_ON) {
>+		NL_SET_ERR_MSG_MOD(extack, "Cannot configure drop monitor while tracing is on");
>+		return -EOPNOTSUPP;
>+	}
>+
>+	rc = net_dm_alert_mode_set(info);
>+	if (rc)
>+		return rc;
>+
>+	return 0;
> }
> 
> static int net_dm_cmd_trace(struct sk_buff *skb,
>@@ -411,6 +673,11 @@ static int dropmon_net_event(struct notifier_block *ev_block,
> 	return NOTIFY_DONE;
> }
> 
>+static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
>+	[NET_DM_ATTR_UNSPEC] = { .strict_start_type = NET_DM_ATTR_UNSPEC + 1 },
>+	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
>+};
>+
> static const struct genl_ops dropmon_ops[] = {
> 	{
> 		.cmd = NET_DM_CMD_CONFIG,
>@@ -434,6 +701,8 @@ static struct genl_family net_drop_monitor_family __ro_after_init = {
> 	.hdrsize        = 0,
> 	.name           = "NET_DM",
> 	.version        = 2,
>+	.maxattr	= NET_DM_ATTR_MAX,
>+	.policy		= net_dm_nl_policy,
> 	.pre_doit	= net_dm_nl_pre_doit,
> 	.post_doit	= net_dm_nl_post_doit,
> 	.module		= THIS_MODULE,
>@@ -479,6 +748,7 @@ static int __init init_net_drop_monitor(void)
> 		INIT_WORK(&data->dm_alert_work, send_dm_alert);
> 		timer_setup(&data->send_timer, sched_send_work, 0);
> 		spin_lock_init(&data->lock);
>+		skb_queue_head_init(&data->drop_queue);
> 		reset_per_cpu_data(data);
> 	}
> 
>@@ -509,6 +779,7 @@ static void exit_net_drop_monitor(void)
> 		 * to this struct and can free the skb inside it
> 		 */
> 		kfree_skb(data->skb);
>+		WARN_ON(!skb_queue_empty(&data->drop_queue));
> 	}
> 
> 	BUG_ON(genl_unregister_family(&net_drop_monitor_family));
>-- 
>2.21.0
>
