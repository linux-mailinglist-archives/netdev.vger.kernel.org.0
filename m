Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1428C2822DF
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgJCJFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJCJFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:05:45 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2B0C0613E7
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 02:05:45 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so4316982wrm.2
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 02:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PXtBvwPlcuDjwSsxSPImY3z6WHPiXSWPjxcN7VcIbOU=;
        b=xWmUhcNwRVay4TOiYuqVk0ciV9jAYW2hkR/c5oSasXx6dlPSgDuoiEs5bQ2H1D+nK9
         bZGhbc0jEDonbh1M6ZUlJ9xL05Aju2FkN1pNaNzRlpvStuNr0ieVLlKVMznCdecfG4nl
         goQT6rHfdnxnr+qpIV+1svuUSVoY7D2nPXJMq4Cc8zpcvmiwCGB5ZKndgHSs6wxTyKi4
         OfMlsWISEzPQHdfFx5xqNUScJw6aMeIJxasV+V/+9qs/GsHFIOCAOfoyziZE9+IycSCH
         0tilHv+qVfHgbdxJvOcCDWst9h3KF6XVjfvsQgRusvQNjzYBrwgSAPDy3gFWMobbaiYs
         nQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PXtBvwPlcuDjwSsxSPImY3z6WHPiXSWPjxcN7VcIbOU=;
        b=PEvTqHc3dx7buJWmboibcJeaKieotks0DyCLk2U3nnNb+dnJQJ3Wrjz1uDNiHoXCKS
         NO4smMU5Du3T+tnafBCxwzsPSdxWdAH2n/fufcDZh/k9fj8pRSTsHGyGBUdvca70f9HD
         FgPh79jdLY3Di+rvIk+rm60FrR/qCTg3i35/1Sj0waX7anhgPpoOjnL/NS3gliPyea85
         tgsGT6JhvuNonh08FjMP5E68JFwNIQnVbhidvRNOQifUchZta4+86X9vqijFkz0MLLSC
         lxphspjeYzYcALTate12pcku3K31U9kAEalyJcbj0hCmjcoJgwT/sSYy/yHLYoXTsYg0
         G+zw==
X-Gm-Message-State: AOAM532XAljZYOPScy7alPic96kaLaIIB57n5r6JZIaewbUBFC+M1/2N
        +3JeHdP/RlbYiTi7deCfpGDiRw==
X-Google-Smtp-Source: ABdhPJyBBzbxZHxBxE5j7jMZDVBv8TTqmDz4UOFNGwqcAC3B7MxDDYCOXK8ytbNIrWF9XhciuA6NKg==
X-Received: by 2002:adf:cd0c:: with SMTP id w12mr67849wrm.305.1601715943753;
        Sat, 03 Oct 2020 02:05:43 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f14sm4873009wrt.53.2020.10.03.02.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 02:05:43 -0700 (PDT)
Date:   Sat, 3 Oct 2020 11:05:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 05/16] devlink: Add remote reload stats
Message-ID: <20201003090542.GF3159@nanopsycho.orion>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-6-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601560759-11030-6-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 01, 2020 at 03:59:08PM CEST, moshe@mellanox.com wrote:
>Add remote reload stats to hold the history of actions performed due
>devlink reload commands initiated by remote host. For example, in case
>firmware activation with reset finished successfully but was initiated
>by remote host.
>
>The function devlink_remote_reload_actions_performed() is exported to
>enable drivers update on remote reload actions performed as it was not
>initiated by their own devlink instance.
>
>Expose devlink remote reload stats to the user through devlink dev get
>command.
>
>Examples:
>$ devlink dev show
>pci/0000:82:00.0:
>  stats:
>      reload_stats:
>        driver_reinit 2
>        fw_activate 1
>        fw_activate_no_reset 0
>      remote_reload_stats:
>        driver_reinit 0
>        fw_activate 0
>        fw_activate_no_reset 0
>pci/0000:82:00.1:
>  stats:
>      reload_stats:
>        driver_reinit 1
>        fw_activate 0
>        fw_activate_no_reset 0
>      remote_reload_stats:
>        driver_reinit 1
>        fw_activate 1
>        fw_activate_no_reset 0
>
>$ devlink dev show -jp
>{
>    "dev": {
>        "pci/0000:82:00.0": {
>            "stats": {
>                "reload_stats": [ {
>                        "driver_reinit": 2
>                    },{
>                        "fw_activate": 1
>                    },{
>                        "fw_activate_no_reset": 0
>                    } ],
>                "remote_reload_stats": [ {
>                        "driver_reinit": 0
>                    },{
>                        "fw_activate": 0
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
>                    } ],
>                "remote_reload_stats": [ {
>                        "driver_reinit": 1
>                    },{
>                        "fw_activate": 1
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
>- Resplit this patch and the previous one by remote/local reload stats
>instead of set/get reload stats
>- Rename reload_action_stats to reload_stats
>RFCv4 -> RFCv5:
>- Add remote actions stats
>- If devlink reload is not supported, show only remote_stats
>RFCv3 -> RFCv4:
>- Renamed DEVLINK_ATTR_RELOAD_ACTION_CNT to
>  DEVLINK_ATTR_RELOAD_ACTION_STAT
>- Add stats per action per limit level
>RFCv2 -> RFCv3:
>- Add reload actions counters instead of supported reload actions
>  (reload actions counters are only for supported action so no need for
>   both)
>RFCv1 -> RFCv2:
>- Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
>- Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
>- Have actions instead of levels
>---
> include/net/devlink.h        |  1 +
> include/uapi/linux/devlink.h |  1 +
> net/core/devlink.c           | 49 +++++++++++++++++++++++++++++++-----
> 3 files changed, 45 insertions(+), 6 deletions(-)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 0f3bd23b6c04..a4ccb83bbd2c 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -42,6 +42,7 @@ struct devlink {
> 	const struct devlink_ops *ops;
> 	struct xarray snapshot_ids;
> 	u32 reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
>+	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];

Perhaps a nested struct  {} stats?


> 	struct device *dev;
> 	possible_net_t _net;
> 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index 97e0137f6201..f9887d8afdc7 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -530,6 +530,7 @@ enum devlink_attr {
> 	DEVLINK_ATTR_RELOAD_STATS,		/* nested */
> 	DEVLINK_ATTR_RELOAD_STATS_ENTRY,	/* nested */
> 	DEVLINK_ATTR_RELOAD_STATS_VALUE,	/* u32 */
>+	DEVLINK_ATTR_REMOTE_RELOAD_STATS,	/* nested */
> 
> 	/* add new attributes above here, update the policy in devlink.c */
> 
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 05516f1e4c3e..3b6bd3b4d346 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -523,28 +523,35 @@ static int devlink_reload_stat_put(struct sk_buff *msg, enum devlink_reload_acti
> 	return -EMSGSIZE;
> }
> 
>-static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink)
>+static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink, bool is_remote)
> {
> 	struct nlattr *reload_stats_attr;
> 	int i, j, stat_idx;
> 	u32 value;
> 
>-	reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS);
>+	if (!is_remote)
>+		reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS);
>+	else
>+		reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_REMOTE_RELOAD_STATS);
> 
> 	if (!reload_stats_attr)
> 		return -EMSGSIZE;
> 
> 	for (j = 0; j <= DEVLINK_RELOAD_LIMIT_MAX; j++) {
>-		if (j != DEVLINK_RELOAD_LIMIT_UNSPEC &&
>+		if (!is_remote && j != DEVLINK_RELOAD_LIMIT_UNSPEC &&

I don't follow the check "!is_remote" here,

> 		    !devlink_reload_limit_is_supported(devlink, j))
> 			continue;
> 		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
>-			if (!devlink_reload_action_is_supported(devlink, i) ||
>+			if ((!is_remote && !devlink_reload_action_is_supported(devlink, i)) ||

and here. Could you perhaps put in a comment to describe what are you
doing?



>+			    i == DEVLINK_RELOAD_ACTION_UNSPEC ||
> 			    devlink_reload_combination_is_invalid(i, j))
> 				continue;
> 
> 			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
>-			value = devlink->reload_stats[stat_idx];
>+			if (!is_remote)
>+				value = devlink->reload_stats[stat_idx];
>+			else
>+				value = devlink->remote_reload_stats[stat_idx];
> 			if (devlink_reload_stat_put(msg, i, j, value))
> 				goto nla_put_failure;
> 		}
>@@ -577,7 +584,9 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
> 	if (!dev_stats)
> 		goto nla_put_failure;
> 
>-	if (devlink_reload_stats_put(msg, devlink))
>+	if (devlink_reload_stats_put(msg, devlink, false))
>+		goto dev_stats_nest_cancel;
>+	if (devlink_reload_stats_put(msg, devlink, true))
> 		goto dev_stats_nest_cancel;
> 
> 	nla_nest_end(msg, dev_stats);
>@@ -3100,15 +3109,40 @@ devlink_reload_stats_update(struct devlink *devlink, enum devlink_reload_limit l
> 	__devlink_reload_stats_update(devlink, devlink->reload_stats, limit, actions_performed);
> }
> 
>+/**
>+ *	devlink_remote_reload_actions_performed - Update devlink on reload actions
>+ *	  performed which are not a direct result of devlink reload call.
>+ *
>+ *	This should be called by a driver after performing reload actions in case it was not
>+ *	a result of devlink reload call. For example fw_activate was performed as a result
>+ *	of devlink reload triggered fw_activate on another host.
>+ *	The motivation for this function is to keep data on reload actions performed on this
>+ *	function whether it was done due to direct devlink reload call or not.
>+ *
>+ *	@devlink: devlink
>+ *	@limit: reload limit
>+ *	@actions_performed: bitmask of actions performed
>+ */
>+void devlink_remote_reload_actions_performed(struct devlink *devlink,
>+					     enum devlink_reload_limit limit,
>+					     unsigned long actions_performed)
>+{
>+	__devlink_reload_stats_update(devlink, devlink->remote_reload_stats, limit,
>+				      actions_performed);
>+}
>+EXPORT_SYMBOL_GPL(devlink_remote_reload_actions_performed);
>+
> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> 			  enum devlink_reload_action action, enum devlink_reload_limit limit,
> 			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
> {
>+	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
> 	int err;
> 
> 	if (!devlink->reload_enabled)
> 		return -EOPNOTSUPP;
> 
>+	memcpy(remote_reload_stats, devlink->remote_reload_stats, sizeof(remote_reload_stats));
> 	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
> 	if (err)
> 		return err;
>@@ -3122,6 +3156,9 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> 		return err;
> 
> 	WARN_ON(!test_bit(action, actions_performed));
>+	/* Catch driver on updating the remote action within devlink reload */
>+	WARN_ON(memcmp(remote_reload_stats, devlink->remote_reload_stats,
>+		       sizeof(remote_reload_stats)));
> 	devlink_reload_stats_update(devlink, limit, *actions_performed);
> 	return 0;
> }
>-- 
>2.18.2
>
