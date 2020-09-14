Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A93E268C62
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 15:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgINNkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 09:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgINNjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 09:39:45 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDECC061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:39:42 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id r7so23263012ejs.11
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GFasB2K7R8ZSOSGRVKhFgfIN6nhjMFHPa6vWb6Sd2sg=;
        b=Z+DFg/UC/F02eEslAg1GggoQLJle+HByhyB/w2hE20SHWm6xNYRV40uCUVVYYLieS6
         JURyQ/FhSPKry7ObpDnQ4k0PB57TwH+/Vv+cvH+CLrTz+3z4xR0Hdogz1AJc9+l0Pzth
         TiiaTTUblalT57Ob/X/Tx4O2xzOL5O7vx9iHhe8fDJoEh+B3JT0ZugCqoN28I00zc0Bk
         woni2JAzc9Fwmsd4s8pE5Ow9PjrkIHXjQoj0/8wdLw3AfXHxrgQGVkS408CN1PGLvLC4
         1XZQpoiJlfWGjP5j00i0m+Tc6ruiS1hyKRwx1BqHIdymXsh0k8cJi5rTHnsoe5W/e7zJ
         EZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GFasB2K7R8ZSOSGRVKhFgfIN6nhjMFHPa6vWb6Sd2sg=;
        b=no6V9abClUDaI7oigbxo02N+iljvwhoYcV0ENDWoSqf8IuzOFW5kGxeLgtUBtfdN06
         Yggz/9EYPavM0Vj1FGh8LYlVYfv0xVSmHwQB7EwwkKIIgLeIQBm1JL3v3DxamDzH8XAc
         Vga1FckzJeNnq6cVWx2Ren8qeuiQgxdV7albu+h7XcJ4iN2WYtEnPfM0XTKl/J20++9r
         2mOMsY2MymRiIaNGBqNseOfOXviWqWsHxYkyj1Cj3X7kS24Fxo1UZs/lFMQCwCS6OiXv
         M+g6CalegWMCK22ekqGiSxhJvbegwSrxdyQCEC9+8V3PbuBDDGi4iC7EochrKK+ttwAC
         nhuA==
X-Gm-Message-State: AOAM530z7x3PUxFKpT93y3eq38ph9QVxAm2qkT3gKZS5LL1x4YBqU16m
        NCEycZs1mQTgGApB0iosbpRViw==
X-Google-Smtp-Source: ABdhPJwqBA3GajmyCQzgHV43g9Zw8M9RURyOEgmywA9X5KLm2su86kci9kQ6RIB3g/C1sauLMHXgZQ==
X-Received: by 2002:a17:906:1b11:: with SMTP id o17mr15598515ejg.67.1600090781196;
        Mon, 14 Sep 2020 06:39:41 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h64sm3455641edd.50.2020.09.14.06.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 06:39:40 -0700 (PDT)
Date:   Mon, 14 Sep 2020 15:39:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 03/15] devlink: Add reload action stats
Message-ID: <20200914133939.GG2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-4-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600063682-17313-4-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 14, 2020 at 08:07:50AM CEST, moshe@mellanox.com wrote:
>Add reload action stats to hold the history per reload action type and
>limit level.

Empty line missing.


>For example, the number of times fw_activate has been performed on this
>device since the driver module was added or if the firmware activation
>was performed with or without reset.
>Add devlink notification on stats update.
>
>The function devlink_reload_actions_implicit_actions_performed() is
>exported to enable also drivers update on reload actions performed,
>for example in case firmware activation with reset finished
>successfully but was initiated by remote host.
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>---
>v3 -> v4:
>- Renamed reload_actions_cnts to reload_action_stats
>- Add devlink notifications on stats update
>- Renamed devlink_reload_actions_implicit_actions_performed() and add
>  function comment in code
>v2 -> v3:
>- New patch
>---
> include/net/devlink.h |  7 ++++++
> net/core/devlink.c    | 58 ++++++++++++++++++++++++++++++++++++++++---
> 2 files changed, 62 insertions(+), 3 deletions(-)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index dddd9ee5b8a9..b4feb92e0269 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -20,6 +20,9 @@
> #include <uapi/linux/devlink.h>
> #include <linux/xarray.h>
> 
>+#define DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE \
>+	(__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX * __DEVLINK_RELOAD_ACTION_MAX)
>+
> struct devlink_ops;
> 
> struct devlink {
>@@ -38,6 +41,7 @@ struct devlink {
> 	struct list_head trap_policer_list;
> 	const struct devlink_ops *ops;
> 	struct xarray snapshot_ids;
>+	u32 reload_action_stats[DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE];
> 	struct device *dev;
> 	possible_net_t _net;
> 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
>@@ -1397,6 +1401,9 @@ void
> devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
> 
> bool devlink_is_reload_failed(const struct devlink *devlink);
>+void devlink_reload_implicit_actions_performed(struct devlink *devlink,
>+					       enum devlink_reload_action_limit_level limit_level,
>+					       unsigned long actions_performed);
> 
> void devlink_flash_update_begin_notify(struct devlink *devlink);
> void devlink_flash_update_end_notify(struct devlink *devlink);
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 60aa0c4a3726..cbf746966913 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -2981,11 +2981,58 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
> }
> EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
> 
>+static void
>+devlink_reload_action_stats_update(struct devlink *devlink,
>+				   enum devlink_reload_action_limit_level limit_level,
>+				   unsigned long actions_performed)
>+{
>+	int stat_idx;
>+	int action;
>+
>+	if (!actions_performed)
>+		return;
>+
>+	if (WARN_ON(limit_level > DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX))
>+		return;
>+	for (action = 0; action <= DEVLINK_RELOAD_ACTION_MAX; action++) {
>+		if (!test_bit(action, &actions_performed))
>+			continue;
>+		stat_idx = limit_level * __DEVLINK_RELOAD_ACTION_MAX + action;
>+		devlink->reload_action_stats[stat_idx]++;
>+	}
>+	devlink_notify(devlink, DEVLINK_CMD_NEW);
>+}
>+
>+/**
>+ *	devlink_reload_implicit_actions_performed - Update devlink on reload actions
>+ *	  performed which are not a direct result of devlink reload call.
>+ *
>+ *	This should be called by a driver after performing reload actions in case it was not
>+ *	a result of devlink reload call. For example fw_activate was performed as a result
>+ *	of devlink reload triggered fw_activate on another host.
>+ *	The motivation for this function is to keep data on reload actions performed on this
>+ *	function whether it was done due to direct devlink reload call or not.
>+ *
>+ *	@devlink: devlink
>+ *	@limit_level: reload action limit level
>+ *	@actions_performed: bitmask of actions performed
>+ */
>+void devlink_reload_implicit_actions_performed(struct devlink *devlink,
>+					       enum devlink_reload_action_limit_level limit_level,
>+					       unsigned long actions_performed)

What I'm a bit scarred of that the driver would call this from withing
reload_down()/up() ops. Perheps this could be WARN_ON'ed here (or in
devlink_reload())?


>+{
>+	if (!devlink_reload_supported(devlink))

Hmm. I think that the driver does not have to support the reload and can
still be reloaded by another instance and update the stats here. Why
not?


>+		return;
>+	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
>+}
>+EXPORT_SYMBOL_GPL(devlink_reload_implicit_actions_performed);
>+
> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> 			  enum devlink_reload_action action,
> 			  enum devlink_reload_action_limit_level limit_level,
>-			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>+			  struct netlink_ext_ack *extack, unsigned long *actions_performed_out)
> {
>+	unsigned long actions_performed;
> 	int err;
> 
> 	if (!devlink->reload_enabled)
>@@ -2998,9 +3045,14 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
> 		devlink_reload_netns_change(devlink, dest_net);
> 
>-	err = devlink->ops->reload_up(devlink, action, limit_level, extack, actions_performed);
>+	err = devlink->ops->reload_up(devlink, action, limit_level, extack, &actions_performed);
> 	devlink_reload_failed_set(devlink, !!err);
>-	return err;
>+	if (err)
>+		return err;
>+	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
>+	if (actions_performed_out)

Just make the caller to provide valid pointer, as I suggested in the
other patch review.


>+		*actions_performed_out = actions_performed;
>+	return 0;
> }
> 
> static int
>-- 
>2.17.1
>
