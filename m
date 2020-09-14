Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389B8268BD6
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 15:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgINNKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 09:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgINNKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 09:10:10 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1D3C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:10:03 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id i22so23153559eja.5
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KXJemS6gUd2VCQJZx24w6S0gEN32dmmcaw1hB8Y1Gkk=;
        b=Ilz4J8qCbNqVwPAErH7xIsChZupedpJQyuGNhuJRGm/VYsbwgYUyFGsu2IdLv8NkGR
         paXCm+/NBoLDWQjivCtRmOWjfLQNpX/m9bY9yY/jZr2wxLM+z0yNS0+S0j+IhGuVmxdJ
         B3L1hyPU9RVxriMJ/5q8PqtJYLPeCdO5DIAMMLjFGeir+6z3hsDCZwxBGgUbCWB921TI
         fY2i/ecLZD180fc6ZS4nVduNiSaIHeJSPk3nHDISco11WLnOe8Zsdzcu+bcDnYg+DQNE
         cPqQtVVWKmZeRivzPuWMMoFpIXL4hV0jiwswcoZo2xNxyBPEYu4PPfl2pp7GY9dGSagj
         Fa9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KXJemS6gUd2VCQJZx24w6S0gEN32dmmcaw1hB8Y1Gkk=;
        b=tINRAcUd6G4PfJerPchooRPcnvoGW+YKPqSXhvXqSXDSeluT9dvvdvlX2+dfvXnC6U
         b3yUpv3IcFBUOaC6QN4V+z2OACj09ZsONweuEfC5QSvYEMiSSwPTUL6l4HWELxlXMLT4
         Ue3jRTCYRAooqv/kVfCkjYOlXYiQFxYLG2QTNCIFvoo604mSF4blwxMZD0hewme3UFiN
         9hNOsRrBu+hNhCu6uKrpnGrRYleItrXRltpBF+n5VAsKomsCjZVX1rb6ue5bKmWU2/CS
         CEjZXHzZ4OBxWDi6K/A85lwiWvLsOrZDYTkXueO+BX5nkHnLQt7ZmkUoQ1iNeyycGZjL
         jMnA==
X-Gm-Message-State: AOAM532pdoOAlO0AQq7CvLdQakvLa7JdGZAUz1d46Cm9/60LqbKFAdCE
        KVkJdL8hCFd5AYJypwY5M2jrgA==
X-Google-Smtp-Source: ABdhPJynCHdL3rzDjaFyqT5j1E8FdxI7Avt70OG5/ShmxT7RgAhLnwhG+v1JFKLhs59wpVbwr0DYdg==
X-Received: by 2002:a17:906:d14e:: with SMTP id br14mr13650774ejb.299.1600089001854;
        Mon, 14 Sep 2020 06:10:01 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i17sm7711099ejy.79.2020.09.14.06.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 06:10:01 -0700 (PDT)
Date:   Mon, 14 Sep 2020 15:10:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 02/15] devlink: Add reload action limit
 level
Message-ID: <20200914131000.GF2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-3-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600063682-17313-3-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 14, 2020 at 08:07:49AM CEST, moshe@mellanox.com wrote:
		
[..]

	 
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index b09db891db04..dddd9ee5b8a9 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1012,9 +1012,13 @@ enum devlink_trap_group_generic_id {
> 
> struct devlink_ops {
> 	unsigned long supported_reload_actions;
>+	unsigned long supported_reload_action_limit_levels;
> 	int (*reload_down)(struct devlink *devlink, bool netns_change,
>-			   enum devlink_reload_action action, struct netlink_ext_ack *extack);
>+			   enum devlink_reload_action action,
>+			   enum devlink_reload_action_limit_level limit_level,
>+			   struct netlink_ext_ack *extack);
> 	int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
>+			 enum devlink_reload_action_limit_level limit_level,
> 			 struct netlink_ext_ack *extack, unsigned long *actions_performed);
> 	int (*port_type_set)(struct devlink_port *devlink_port,
> 			     enum devlink_port_type port_type);
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index a6f64db0bdf3..b19686fd80ff 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -287,6 +287,22 @@ enum devlink_reload_action {
> 	DEVLINK_RELOAD_ACTION_MAX = __DEVLINK_RELOAD_ACTION_MAX - 1
> };
> 
>+/**
>+ * enum devlink_reload_action_limit_level - Reload action limit level.
>+ * @DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE: No constrains on action. Action may include
>+ *                                          reset or downtime as needed.
>+ * @DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET: No reset allowed, no down time allowed,
>+ *                                              no link flap and no configuration is lost.
>+ */
>+enum devlink_reload_action_limit_level {
>+	DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
>+	DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET,
>+
>+	/* Add new reload actions limit level above */
>+	__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX,
>+	DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX = __DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX - 1
>+};
>+
> enum devlink_attr {
> 	/* don't change the order or add anything between, this is ABI! */
> 	DEVLINK_ATTR_UNSPEC,
>@@ -478,6 +494,7 @@ enum devlink_attr {
> 
> 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
> 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* nested */
>+	DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL,	/* u8 */
> 
> 	/* add new attributes above here, update the policy in devlink.c */
> 
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index f4be1e1bf864..60aa0c4a3726 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -468,6 +468,13 @@ devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_
> 	return test_bit(action, &devlink->ops->supported_reload_actions);
> }
> 
>+static bool
>+devlink_reload_action_limit_level_is_supported(struct devlink *devlink,
>+					       enum devlink_reload_action_limit_level limit_level)
>+{
>+	return test_bit(limit_level, &devlink->ops->supported_reload_action_limit_levels);
>+}
>+
> static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
> 			   enum devlink_command cmd, u32 portid,
> 			   u32 seq, int flags)
>@@ -2975,22 +2982,23 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
> EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
> 
> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>-			  enum devlink_reload_action action, struct netlink_ext_ack *extack,
>-			  unsigned long *actions_performed)
>+			  enum devlink_reload_action action,
>+			  enum devlink_reload_action_limit_level limit_level,
>+			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
> {
> 	int err;
> 
> 	if (!devlink->reload_enabled)
> 		return -EOPNOTSUPP;
> 
>-	err = devlink->ops->reload_down(devlink, !!dest_net, action, extack);
>+	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit_level, extack);
> 	if (err)
> 		return err;
> 
> 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
> 		devlink_reload_netns_change(devlink, dest_net);
> 
>-	err = devlink->ops->reload_up(devlink, action, extack, actions_performed);
>+	err = devlink->ops->reload_up(devlink, action, limit_level, extack, actions_performed);
> 	devlink_reload_failed_set(devlink, !!err);
> 	return err;
> }
>@@ -3036,6 +3044,7 @@ devlink_nl_reload_actions_performed_fill(struct sk_buff *msg,
> 
> static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
> {
>+	enum devlink_reload_action_limit_level limit_level;
> 	struct devlink *devlink = info->user_ptr[0];
> 	enum devlink_reload_action action;
> 	unsigned long actions_performed;
>@@ -3073,7 +3082,20 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
> 		return -EOPNOTSUPP;
> 	}
> 
>-	err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
>+	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL])
>+		limit_level = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL]);
>+	else
>+		limit_level = DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE;
>+
>+	if (limit_level > DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX) {

Again, not needed, devlink_reload_action_limit_level_is_supported() will
take case of it.

>+		NL_SET_ERR_MSG_MOD(info->extack, "Invalid limit level");
>+		return -EINVAL;
>+	} else if (!devlink_reload_action_limit_level_is_supported(devlink, limit_level)) {
>+		NL_SET_ERR_MSG_MOD(info->extack, "Requested limit level is not supported");

"..by the driver"?


>+		return -EOPNOTSUPP;
>+	}
>+	err = devlink_reload(devlink, dest_net, action, limit_level, info->extack,
>+			     &actions_performed);
> 
> 	if (dest_net)
> 		put_net(dest_net);
>@@ -7126,6 +7148,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
> 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
> 	[DEVLINK_ATTR_RELOAD_ACTION] = { .type = NLA_U8 },
>+	[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL] = { .type = NLA_U8 },
> };
> 
> static const struct genl_ops devlink_nl_ops[] = {
>@@ -7462,6 +7485,10 @@ static int devlink_reload_actions_verify(struct devlink *devlink)
> 	if (WARN_ON(ops->supported_reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX) ||
> 		    ops->supported_reload_actions <= BIT(DEVLINK_RELOAD_ACTION_UNSPEC)))
> 		return -EINVAL;
>+	if (WARN_ON(!ops->supported_reload_action_limit_levels ||
>+		    ops->supported_reload_action_limit_levels >=
>+		    BIT(__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX)))
>+		return -EINVAL;

I think that you can check some insane driver combinations like:
supports only driver-reinit, supports LEVEL_NO_RESET - that is
impossible and should be refused here.

Same goes to the actual user command call. If the user calls for
driver-reinit with LEVEL_NO_RESET, devlink should refuse with proper
extack


> 	return 0;
> }
> 
>@@ -9756,7 +9783,8 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
> 			if (WARN_ON(!devlink_reload_supported(devlink)))
> 				continue;
> 			err = devlink_reload(devlink, &init_net,
>-					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT, NULL, NULL);
>+					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>+					     DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE, NULL, NULL);
> 			if (err && err != -EOPNOTSUPP)
> 				pr_warn("Failed to reload devlink instance into init_net\n");
> 		}
>-- 
>2.17.1
>
