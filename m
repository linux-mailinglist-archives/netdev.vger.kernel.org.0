Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64302257907
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 14:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgHaMPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 08:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgHaMPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 08:15:04 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66971C061575
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 05:15:04 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l9so1278303wme.3
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 05:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CXDVX0YGELPDSa9HVQRD/zIo3Ak3H4cRsj5762Lwo2k=;
        b=Suk9Hv4XqaEVcYgIX72xD9qy6GzEbaukryuo/LPaLlbBcQl0JfpaSVflC0+G/dhh+d
         EhDQLGm1HQjtbAzMnd9KvkCmMSrv3N1mYUpSdiHh7RJJX3h5QrrDUw7CksT9/aCb79Qa
         y0lp3CE8bhy9iInAcoJv+cD6xQyMwU45tqSyS1rNULkYizJNQfR8NHxwFVEO9/L3TGHy
         ePM9hcNTIrFbUrN2VGjNrXlnJLtZKYKtE7HJm6jwEAowPM1rq2gNUfuW32h5f0Z+Sjix
         VNjoDbV4CLRdKSdWaUaEkkgN7jHFGuw1vQlDdowhlQFTi7v9rRtq9q1tPWDf45CqZ22S
         f9fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CXDVX0YGELPDSa9HVQRD/zIo3Ak3H4cRsj5762Lwo2k=;
        b=BLPsIh/F6jS/fnGBlR/JztckaOu0kp1VxZWLe8oO5TOhL+e5dAhvqvk/oPCwatRF0K
         vY9DmHGRHtYrgHAdXwk9aOyx/ujCUu8MTzq35rfEs1guizdYvnD22dcjimAHZFDy08i8
         0X03lnwwyIj8W8WUlZWucy61DHKt5sVJ8bpvVHHOh4NQpI6yjZY0Yj+guVaMkSA6KwE0
         vPZwXvj96p1mXD4TnXeYBycNTbPO4mPIHknCa9YiRKt0kgVTAYXbGrv65aXcwqJ1Pzxy
         G/RYJ60zLCFUKIWrDx3L2NIltGGTdFfQFlnY8gd3h18FjjTaEiuoA4YZ6hSVRX3nywEE
         C2vg==
X-Gm-Message-State: AOAM530mwt+OVKFiSOuC5LDlSxXAoQvUn3SpZ4oQG+7Aim8NrguyMWVx
        TL7nWyO/jR7Igsg2H1zAAYl3YA==
X-Google-Smtp-Source: ABdhPJxI4FQAA9nLp+cBM2Zp8GbhP4AfLQr1AzKsa0RP42KutjwrSTnkJlyUuTOuzaS252dE0ZOpSg==
X-Received: by 2002:a1c:20d3:: with SMTP id g202mr1151473wmg.54.1598876103080;
        Mon, 31 Aug 2020 05:15:03 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id u16sm11347086wmc.7.2020.08.31.05.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 05:15:02 -0700 (PDT)
Date:   Mon, 31 Aug 2020 14:15:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v3 01/14] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200831121501.GD3794@nanopsycho.orion>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <1598801254-27764-2-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598801254-27764-2-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Aug 30, 2020 at 05:27:21PM CEST, moshe@mellanox.com wrote:
>Add devlink reload action to allow the user to request a specific reload
>action. The action parameter is optional, if not specified then devlink
>driver re-init action is used (backward compatible).
>Note that when required to do firmware activation some drivers may need
>to reload the driver. On the other hand some drivers may need to reset
>the firmware to reinitialize the driver entities. Therefore, the devlink
>reload command returns the actions which were actually done.
>However, in case fw_activate_no_reset action is selected, then no other
>reload action is allowed.
>Reload actions supported are:
>driver_reinit: driver entities re-initialization, applying devlink-param
>               and devlink-resource values.
>fw_activate: firmware activate.
>fw_activate_no_reset: Activate new firmware image without any reset.
>                      (also known as: firmware live patching).
>
>command examples:
>$devlink dev reload pci/0000:82:00.0 action driver_reinit
>reload_actions_done:
>  driver_reinit
>
>$devlink dev reload pci/0000:82:00.0 action fw_activate
>reload_actions_done:
>  driver_reinit fw_activate
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>---
>v2 -> v3:
>- Replace fw_live_patch action by fw_activate_no_reset
>- Devlink reload returns the actions done over netlink reply
>v1 -> v2:
>- Instead of reload levels driver,fw_reset,fw_live_patch have reload
>  actions driver_reinit,fw_activate,fw_live_patch
>- Remove driver default level, the action driver_reinit is the default
>  action for all drivers
>---

[...]


>diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
>index 08d101138fbe..c42b66d88884 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
>@@ -1113,7 +1113,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
> 
> static int
> mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>-					  bool netns_change,
>+					  bool netns_change, enum devlink_reload_action action,
> 					  struct netlink_ext_ack *extack)
> {
> 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>@@ -1126,15 +1126,23 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
> }
> 
> static int
>-mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
>-					struct netlink_ext_ack *extack)
>+mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
>+					struct netlink_ext_ack *extack, unsigned long *actions_done)
> {
> 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>+	int err;
> 
>-	return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
>-					      mlxsw_core->bus,
>-					      mlxsw_core->bus_priv, true,
>-					      devlink, extack);
>+	err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
>+					     mlxsw_core->bus,
>+					     mlxsw_core->bus_priv, true,
>+					     devlink, extack);
>+	if (err)
>+		return err;
>+	if (actions_done)
>+		*actions_done = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>+				BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
>+
>+	return 0;
> }
> 
> static int mlxsw_devlink_flash_update(struct devlink *devlink,
>@@ -1268,6 +1276,8 @@ mlxsw_devlink_trap_policer_counter_get(struct devlink *devlink,
> }
> 
> static const struct devlink_ops mlxsw_devlink_ops = {
>+	.supported_reload_actions	= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>+					  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),

This is confusing and open to interpretation. Does this mean that the
driver supports:
1) REINIT && FW_ACTIVATE
2) REINIT || FW_ACTIVATE
?

Because mlxsw supports only 1. I guess that mlx5 supports both. This
needs to be distinguished.

I think you need an array of combinations. Or perhaps rather to extend
the enum with combinations. You kind of have it already with
DEVLINK_RELOAD_ACTION_FW_ACTIVATE_NO_RESET

Maybe we can have something like:
DEVLINK_RELOAD_ACTION_DRIVER_REINIT
DEVLINK_RELOAD_ACTION_DRIVER_REINIT_FW_ACTIVATE_RESET
DEVLINK_RELOAD_ACTION_FW_ACTIVATE_RESET
DEVLINK_RELOAD_ACTION_FW_ACTIVATE (this is the original FW_ACTIVATE_NO_RESET)

Each has very clear meaning.

Also, then the "actions_done" would be a simple enum, directly returned
to the user. No bitfield needed.


> 	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
> 	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
> 	.port_type_set			= mlxsw_devlink_port_type_set,

[...]
