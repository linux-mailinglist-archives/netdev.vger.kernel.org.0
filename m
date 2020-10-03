Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407362822C9
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgJCJAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJCJAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:00:15 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98891C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 02:00:15 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so4300589wrx.7
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 02:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FWvAgG6fLKNtWyrZkZOZJw2itYUdLGqH3xAcV+rybR0=;
        b=FpkRkc37maLjN/mwf6kt+GJwXuWQOSNgpkxoY2UtsLz9NH9JwuKHrLLn3QgMFSxRcv
         WycwzB3LYv81/xKZ0P4NZi/YnFavws6fns0nsyZr0VPM6M9ojVBUUVu3w+f8uBidTcgE
         uR+qORO2//jZg8iUirFYJLORxMvdiBpSo3gyU/Ir4MqS24Lml1ARrqC73bfA1u3i/lqa
         nkefx9wgFjfTXz033Ehq8N4btB084fDuQW//A+BjQRURedDSg8+ctpJCHurhRF+wFxie
         tHhELyHIxASVP9Wn6dgqIclp8gY7yAr7tMixhbQde+nwnXt2ejs0x6t0ZHJ0loLr5Z82
         SUew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FWvAgG6fLKNtWyrZkZOZJw2itYUdLGqH3xAcV+rybR0=;
        b=tWFUTxaaEt2uyMDU+4XPhlDbXTmjB7gQJJ8GaEINY+C55X/WpeGPGEFN+PRIT9G8P2
         MWW1o7EDj2zYUqvXtWkukBVodGvG++rrs0i0MuafJiRP75W6MjGnqMJ8x/Vs5rx5uzjI
         9zdOL0LbBE8pe9eBo+/OusBjKeiVRUEu4vyYuJj4hsgbqj82Rt0ZjxMmybXoluSKrWnr
         /J9guM3oOF4v11611+PK09D8FuJLGUI3dby7/JrRBrF3v2ZV/LL/bT/XL5QxvfHKie69
         bczK4Hil0sbEWp8Lfc5/G7GyrfmM+kGoADWYsoug71T+1Pf5diNYwCbIWbiec95I8BZ3
         JDVA==
X-Gm-Message-State: AOAM530T2kgM1y0Ee8RwI0oGciiRQG/hlnDm6uikQ9YzjvQkWDpx0kjA
        mWpeTPuwGCbDe+f6WkJ6oPpY1g==
X-Google-Smtp-Source: ABdhPJwA/FRsEwX5N0DjLeVkZPmCc3xaLpC9Yns0bnBJDKDENaZHq6zjL2lp2+BZMe0c+gUm+JMCmg==
X-Received: by 2002:adf:f643:: with SMTP id x3mr194188wrp.180.1601715614290;
        Sat, 03 Oct 2020 02:00:14 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z13sm4465628wro.97.2020.10.03.02.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 02:00:13 -0700 (PDT)
Date:   Sat, 3 Oct 2020 11:00:12 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 04/16] devlink: Add reload stats
Message-ID: <20201003090012.GE3159@nanopsycho.orion>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-5-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601560759-11030-5-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 01, 2020 at 03:59:07PM CEST, moshe@mellanox.com wrote:
>Add reload stats to hold the history per reload action type and limit.
>
>For example, the number of times fw_activate has been performed on this
>device since the driver module was added or if the firmware activation
>was performed with or without reset.
>
>Add devlink notification on stats update.
>
>Expose devlink reload stats to the user through devlink dev get command.
>
>Examples:
>$ devlink dev show
>pci/0000:82:00.0:
>  stats:
>      reload_stats:
>        driver_reinit 2
>        fw_activate 1
>        fw_activate_no_reset 0
>pci/0000:82:00.1:
>  stats:
>      reload_stats:
>        driver_reinit 1
>        fw_activate 0
>        fw_activate_no_reset 0
>
>$ devlink dev show -jp
>{
>    "dev": {
>        "pci/0000:82:00.0": {
>            "stats": {
>                "reload_stats": [ {

Just "reload". No need to repeat "stats" here.


>                        "driver_reinit": 2
>                    },{
>                        "fw_activate": 1
>                    },{
>                        "fw_activate_no_reset": 0
>                    } ]
>            }
>        },
>        "pci/0000:82:00.1": {
>            "stats": {
>                "reload_stats": [ {
>                        "driver_reinit": 1
>                    },{
>                        "fw_activate": 0
>                    },{
>                        "fw_activate_no_reset": 0
>                    } ]
>            }
>        }
>    }
>}
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>---
>RFCv5 -> v1:
>- Changed the stats output structure, have 2 stats, one for local and
>one for remote
>- Resplit this patch and the next one by remote/local reload stast
>instead of set/get reload stats
>- Add helper function devlink_reload_stats_put()
>RFCv4 -> RFCv5:
>- Add separate reload action stats for updating on remote actions
>- Protect  from updating remote actions stats during reload_down()/up()
>RFCv3 -> RFCv4:
>- Renamed reload_actions_cnts to reload_action_stats
>- Add devlink notifications on stats update
>- Renamed devlink_reload_actions_implicit_actions_performed() and add
>  function comment in code
>RFCv2 -> RFCv3:
>- New patch
>---
> include/net/devlink.h        |  7 +++
> include/uapi/linux/devlink.h |  5 ++
> net/core/devlink.c           | 97 ++++++++++++++++++++++++++++++++++++
> 3 files changed, 109 insertions(+)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 43dde69086e5..0f3bd23b6c04 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -20,6 +20,9 @@
> #include <uapi/linux/devlink.h>
> #include <linux/xarray.h>
> 
>+#define DEVLINK_RELOAD_STATS_ARRAY_SIZE \
>+	(__DEVLINK_RELOAD_LIMIT_MAX * __DEVLINK_RELOAD_ACTION_MAX)
>+
> struct devlink_ops;
> 
> struct devlink {
>@@ -38,6 +41,7 @@ struct devlink {
> 	struct list_head trap_policer_list;
> 	const struct devlink_ops *ops;
> 	struct xarray snapshot_ids;
>+	u32 reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
> 	struct device *dev;
> 	possible_net_t _net;
> 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
>@@ -1470,6 +1474,9 @@ void
> devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
> 
> bool devlink_is_reload_failed(const struct devlink *devlink);
>+void devlink_remote_reload_actions_performed(struct devlink *devlink,
>+					     enum devlink_reload_limit limit,
>+					     unsigned long actions_performed);

Leftover, please remove/move.


> 
> void devlink_flash_update_begin_notify(struct devlink *devlink);
> void devlink_flash_update_end_notify(struct devlink *devlink);
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index cc5dc4c07b4a..97e0137f6201 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -526,6 +526,11 @@ enum devlink_attr {
> 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* u64 */
> 	DEVLINK_ATTR_RELOAD_LIMIT,	/* u8 */
> 
>+	DEVLINK_ATTR_DEV_STATS,			/* nested */
>+	DEVLINK_ATTR_RELOAD_STATS,		/* nested */
>+	DEVLINK_ATTR_RELOAD_STATS_ENTRY,	/* nested */
>+	DEVLINK_ATTR_RELOAD_STATS_VALUE,	/* u32 */
>+
> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 6de7d6aa6ed1..05516f1e4c3e 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -500,10 +500,68 @@ devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_l
> 	return test_bit(limit, &devlink->ops->reload_limits);
> }
> 
>+static int devlink_reload_stat_put(struct sk_buff *msg, enum devlink_reload_action action,
>+				   enum devlink_reload_limit limit, u32 value)
>+{
>+	struct nlattr *reload_stats_entry;
>+
>+	reload_stats_entry = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS_ENTRY);
>+	if (!reload_stats_entry)
>+		return -EMSGSIZE;
>+
>+	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, action))
>+		goto nla_put_failure;
>+	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_LIMIT, limit))
>+		goto nla_put_failure;
>+	if (nla_put_u32(msg, DEVLINK_ATTR_RELOAD_STATS_VALUE, value))
>+		goto nla_put_failure;
>+	nla_nest_end(msg, reload_stats_entry);
>+	return 0;
>+
>+nla_put_failure:
>+	nla_nest_cancel(msg, reload_stats_entry);
>+	return -EMSGSIZE;
>+}
>+
>+static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink)
>+{
>+	struct nlattr *reload_stats_attr;
>+	int i, j, stat_idx;
>+	u32 value;
>+
>+	reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS);
>+
>+	if (!reload_stats_attr)
>+		return -EMSGSIZE;
>+
>+	for (j = 0; j <= DEVLINK_RELOAD_LIMIT_MAX; j++) {
>+		if (j != DEVLINK_RELOAD_LIMIT_UNSPEC &&

You should check limit_unspec during driver register, not here.


>+		    !devlink_reload_limit_is_supported(devlink, j))
>+			continue;
>+		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
>+			if (!devlink_reload_action_is_supported(devlink, i) ||
>+			    devlink_reload_combination_is_invalid(i, j))
>+				continue;
>+
>+			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
>+			value = devlink->reload_stats[stat_idx];
>+			if (devlink_reload_stat_put(msg, i, j, value))
>+				goto nla_put_failure;
>+		}
>+	}
>+	nla_nest_end(msg, reload_stats_attr);
>+	return 0;
>+
>+nla_put_failure:
>+	nla_nest_cancel(msg, reload_stats_attr);
>+	return -EMSGSIZE;
>+}
>+
> static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
> 			   enum devlink_command cmd, u32 portid,
> 			   u32 seq, int flags)
> {
>+	struct nlattr *dev_stats;
> 	void *hdr;
> 
> 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
>@@ -515,9 +573,19 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
> 	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
> 		goto nla_put_failure;
> 
>+	dev_stats = nla_nest_start(msg, DEVLINK_ATTR_DEV_STATS);

Avoid the "DEV". Just "DEVLINK_ATTR_STATS" is enough.


>+	if (!dev_stats)
>+		goto nla_put_failure;
>+
>+	if (devlink_reload_stats_put(msg, devlink))
>+		goto dev_stats_nest_cancel;
>+
>+	nla_nest_end(msg, dev_stats);
> 	genlmsg_end(msg, hdr);
> 	return 0;
> 
>+dev_stats_nest_cancel:
>+	nla_nest_cancel(msg, dev_stats);
> nla_put_failure:
> 	genlmsg_cancel(msg, hdr);
> 	return -EMSGSIZE;
>@@ -3004,6 +3072,34 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
> }
> EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
> 
>+static void
>+__devlink_reload_stats_update(struct devlink *devlink, u32 *reload_stats,
>+			      enum devlink_reload_limit limit, unsigned long actions_performed)
>+{
>+	int stat_idx;
>+	int action;
>+
>+	if (!actions_performed)
>+		return;
>+
>+	if (WARN_ON(limit > DEVLINK_RELOAD_LIMIT_MAX))

I don't understand the reason for this check and warn on. You should
sanitize this in the caller (I think you already do that).

>+		return;
>+	for (action = 0; action <= DEVLINK_RELOAD_ACTION_MAX; action++) {
>+		if (!test_bit(action, &actions_performed))
>+			continue;
>+		stat_idx = limit * __DEVLINK_RELOAD_ACTION_MAX + action;
>+		reload_stats[stat_idx]++;
>+	}
>+	devlink_notify(devlink, DEVLINK_CMD_NEW);
>+}
>+
>+static void
>+devlink_reload_stats_update(struct devlink *devlink, enum devlink_reload_limit limit,
>+			    unsigned long actions_performed)
>+{
>+	__devlink_reload_stats_update(devlink, devlink->reload_stats, limit, actions_performed);
>+}
>+
> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> 			  enum devlink_reload_action action, enum devlink_reload_limit limit,
> 			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>@@ -3026,6 +3122,7 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> 		return err;
> 
> 	WARN_ON(!test_bit(action, actions_performed));
>+	devlink_reload_stats_update(devlink, limit, *actions_performed);
> 	return 0;
> }
> 
>-- 
>2.18.2
>
