Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A0F2577A1
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 12:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgHaKsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 06:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgHaKsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 06:48:30 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE4FC061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 03:48:30 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id s13so4912900wmh.4
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 03:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oko5+c/dibPeBB6wBwJp/K5eZaK7OHUWNL23/h49n1s=;
        b=mbe2O9q7cQpGUCXxyyPedwG7vr9ZHbbh2URFehbp1STci1Q+vxWAiQm+3ZeTdRT1JI
         BPrKM7510MtndMOtf7oUosMazslwYYlv05sFqzwy4pwAbCnY6KFwzX4iWiXhmA/MBvwC
         3N+cbQbkWoBKaRFGVrXSyWJrmRve8+Y2Fv2XN6e9zJpkj+yOkqrSFuR1eH2EjOGvIdaz
         iT4ZdhMyXpNuKY3GBqTgpnVGZN6oi2vXbbhwmFxCyHsD9zGtW3jt4XHaTSPUTtNP98Ax
         t+a6Rb5HzOtZIS5wb47oBVUmLkSnR4WGUJTRfVqIRcGzhV/uWv4F6rx5ELcYwg0VuHx8
         rt5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oko5+c/dibPeBB6wBwJp/K5eZaK7OHUWNL23/h49n1s=;
        b=jzcxlfHxurTjT0aPSmKok4nBJXVNIjPKjRaPb+Z+L3W0fOHGrPq0ktvyYfDLOz+Lml
         52wNwNzCnr78HF2xxd9amSQL0TMjRIzpGiAsdNM3UIqeNtlNu/nV+llmqdrC/47U5jgS
         9zyJqGETvUo4dFcxiGXct81MZcNq5Sc8p6CkPH9tCHhLGWb3nUc0vab+miAON/mD+4XK
         5oXe9egU7pdyhsaenOh3EkL9C9S9W/5XZC5IZ0VKDtpEINK791i7GplB2fwW4raVjaJS
         BT4BCHTFjAJCwk7T8iBv/d3SAykIJoam53JCzhMv2xlSx/aLQYUhHVoqYjyFB7CSyP6l
         QLJQ==
X-Gm-Message-State: AOAM532qyL8VUtXREBCT2c3NAWDNp9wwweu/ploV66RoYxSAQ3Nu3N9g
        93MVKoz8ZIxa1w1pnWGbMAWg1Q==
X-Google-Smtp-Source: ABdhPJwHrzumBs1OPAJmMwh0nKF53fSksqNTY9/EKUOAlxNMd0B/eay2kFUaQ8gbvUEZ5jsnIuLuiw==
X-Received: by 2002:a7b:cf13:: with SMTP id l19mr763110wmg.115.1598870908729;
        Mon, 31 Aug 2020 03:48:28 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g9sm11837912wrw.63.2020.08.31.03.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 03:48:28 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:48:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v3 02/14] devlink: Add reload actions
 counters
Message-ID: <20200831104827.GB3794@nanopsycho.orion>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <1598801254-27764-3-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598801254-27764-3-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Aug 30, 2020 at 05:27:22PM CEST, moshe@mellanox.com wrote:
>Add reload actions counters to hold the history per reload action type.
>For example, the number of times fw_activate has been done on this
>device since the driver module was added or if the firmware activation
>was done with or without reset.
>The function devlink_reload_actions_cnts_update() is exported to enable
>also drivers update on reload actions done, for example in case firmware
>activation with reset finished successfully but was initiated by remote
>host.
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>---
>v2 -> v3:
>- New patch
>---
> include/net/devlink.h |  2 ++
> net/core/devlink.c    | 24 +++++++++++++++++++++---
> 2 files changed, 23 insertions(+), 3 deletions(-)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index b8f0152a1fff..0547f0707d92 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -38,6 +38,7 @@ struct devlink {
> 	struct list_head trap_policer_list;
> 	const struct devlink_ops *ops;
> 	struct xarray snapshot_ids;
>+	u32 reload_actions_cnts[DEVLINK_RELOAD_ACTION_MAX];
> 	struct device *dev;
> 	possible_net_t _net;
> 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
>@@ -1372,6 +1373,7 @@ void
> devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
> 
> bool devlink_is_reload_failed(const struct devlink *devlink);
>+void devlink_reload_actions_cnts_update(struct devlink *devlink, unsigned long actions_done);
> 
> void devlink_flash_update_begin_notify(struct devlink *devlink);
> void devlink_flash_update_end_notify(struct devlink *devlink);
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 8d4137ad40db..20a29c34ff71 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -2969,10 +2969,23 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
> }
> EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
> 
>+void devlink_reload_actions_cnts_update(struct devlink *devlink, unsigned long actions_done)
>+{
>+	int action;
>+
>+	for (action = 0; action < DEVLINK_RELOAD_ACTION_MAX; action++) {
>+		if (!test_bit(action, &actions_done))
>+			continue;
>+		devlink->reload_actions_cnts[action]++;
>+	}
>+}
>+EXPORT_SYMBOL_GPL(devlink_reload_actions_cnts_update);

I don't follow why this is an exported symbol if you only use it from
this .c. Looks like a leftover...


>+
> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> 			  enum devlink_reload_action action, struct netlink_ext_ack *extack,
>-			  unsigned long *actions_done)
>+			  unsigned long *actions_done_out)
> {
>+	unsigned long actions_done;
> 	int err;
> 
> 	if (!devlink->reload_enabled)
>@@ -2985,9 +2998,14 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
> 		devlink_reload_netns_change(devlink, dest_net);
> 
>-	err = devlink->ops->reload_up(devlink, action, extack, actions_done);
>+	err = devlink->ops->reload_up(devlink, action, extack, &actions_done);
> 	devlink_reload_failed_set(devlink, !!err);
>-	return err;
>+	if (err)
>+		return err;
>+	devlink_reload_actions_cnts_update(devlink, actions_done);
>+	if (actions_done_out)
>+		*actions_done_out = actions_done;

Why don't you just use the original actions_done directly without having
extra local variable?


>+	return 0;
> }
> 
> static int
>-- 
>2.17.1
>
