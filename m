Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B5420F524
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388024AbgF3Mx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387913AbgF3Mx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:53:56 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38D5C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:53:55 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d15so16053404edm.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q7uU6h2qzsDhEItOQLqMFKclPEbfaZBh0YTJL6/f/hg=;
        b=lY2IyCj45rfHUcouSGBV6QHSKWamFc6DuzhaqLf9XwcR0lLJnXTUQZ1kcvY+8xfvGR
         SGLb0WOequRHMHqrLU0Cn3VDEyTJZ2mUdt+8/JzvbLUomNgHDKuGfmWxhY/lvb7uKUY0
         YsfDwbT7ZJuIyQHdfAkU7/PlMz7WgI9EAVWIRhRWytSEvHTrilwqkqSHr5BDnwDFvUtv
         3BsOv7tC930pujE8ZNRU/P2meXSygi4ybxPTxHNNhQ53s/acMkq1a+Ps2xPrWqm+wB6p
         NnRQyCT2LRfTYCYtulfH/0ylEsSlHVAlb952mSwO15QgbFKRHu0aTjbfH18YsYsdZMMo
         uSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q7uU6h2qzsDhEItOQLqMFKclPEbfaZBh0YTJL6/f/hg=;
        b=L289eZ2gar2SFrh0NgoKUZ3a2txWkO0MsRVzmW6wlTvvsn7qFSeovh59L4WxQNBx0Y
         kFreNIKWMkgMZ1B7/RpaLQ1+yE+7kwLKU4BA3T55SnAWmhpkA4YHIbj4+kOcmUuTfKl/
         fr+JoGYFrcXTzCtVhAZYxw7OtetKjSzD5ITBS3Ejex37TiV5Uj96LL8V8R6ZbOgYozVk
         6VsSsf93aFdt7rWatLSFOdHJLUQQoWlD/ie3M0hz/0ffkdD4Rbib59oaU03fCt14Wrrh
         r+II1BrUP8uwSEoPxvj4pHxl5AYgVoqZZ43tYenNutPdDjzEXzy+9z6G/+KOFPpAddTV
         7otw==
X-Gm-Message-State: AOAM532U7WaN4ERm8BDfFXVf+IR/NEIEBGh3CN+/Fx8l8Yc8wFPcDjJP
        SqMPHtqo829JwH+TiCa8sNXgog==
X-Google-Smtp-Source: ABdhPJxPh9bA98E5g8Gwb6n36UJWf7S1m/aWQDqwGFNr+2HTWyoEzfimzEyTRe0Ux83dROva39fJwg==
X-Received: by 2002:a05:6402:1803:: with SMTP id g3mr21889860edy.377.1593521634569;
        Tue, 30 Jun 2020 05:53:54 -0700 (PDT)
Received: from localhost (ip-89-176-225-229.net.upcbroadband.cz. [89.176.225.229])
        by smtp.gmail.com with ESMTPSA id q21sm1965969ejd.30.2020.06.30.05.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:53:53 -0700 (PDT)
Date:   Tue, 30 Jun 2020 14:53:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, kuba@kernel.org, jiri@mellanox.com,
        mkubecek@suse.cz
Subject: Re: [RFC v2 net-next] devlink: Add reset subcommand.
Message-ID: <20200630125353.GA2181@nanopsycho>
References: <1593516846-28189-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593516846-28189-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jun 30, 2020 at 01:34:06PM CEST, vasundhara-v.volam@broadcom.com wrote:
>Advanced NICs support live reset of some of the hardware
>components, that resets the device immediately with all the
>host drivers loaded.
>
>Add devlink reset subcommand to support live and deferred modes
>of reset. It allows to reset the hardware components of the
>entire device and supports the following fields:
>
>component:
>----------
>1. MGMT : Management processor.
>2. DMA : DMA engine.
>3. RAM : RAM shared between multiple components.
>4. AP : Application processor.
>5. ROCE : RoCE management processor.
>6. All : All possible components.
>
>Drivers are allowed to reset only a subset of requested components.

I don't understand why would user ever want to do this. He does not care
about some magic hw entities. He just expects the hw to work. I don't
undestand the purpose of exposing something like this. Could you please
explain in details? Thanks!


>
>width:
>------
>1. single - single host.
>2. multi  - Multi host.
>
>mode:
>-----
>1. deferred - Reset will happen after unloading all the host drivers
>              on the device. This is be default reset type, if user
>              does not specify the type.
>2. live - Reset will happen immediately with all host drivers loaded
>          in real time. If the live reset is not supported, driver
>          will return the error.
>
>This patch is a proposal in continuation to discussion to the
>following thread:
>
>"[PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and 'allow_live_dev_reset' generic devlink params."
>
>and here is the URL to the patch series:
>
>https://patchwork.ozlabs.org/project/netdev/list/?series=180426&state=*
>
>If the proposal looks good, I will re-send the whole patchset
>including devlink changes and driver usage.
>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Reviewed-by: Michael Chan <michael.chan@broadcom.com>
>---
>v2:
>- Switch RAM and AP component definitions.
>- Remove IRQ, FILTER, OFFLOAD, MAC, PHY components as they are port
>specific components.
>- Rename function to host in width parameter.
>---
> Documentation/networking/devlink/devlink-reset.rst | 50 +++++++++++++
> include/net/devlink.h                              |  2 +
> include/uapi/linux/devlink.h                       | 46 ++++++++++++
> net/core/devlink.c                                 | 85 ++++++++++++++++++++++
> 4 files changed, 183 insertions(+)
> create mode 100644 Documentation/networking/devlink/devlink-reset.rst
>
>diff --git a/Documentation/networking/devlink/devlink-reset.rst b/Documentation/networking/devlink/devlink-reset.rst
>new file mode 100644
>index 0000000..652800d
>--- /dev/null
>+++ b/Documentation/networking/devlink/devlink-reset.rst
>@@ -0,0 +1,50 @@
>+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>+
>+.. _devlink_reset:
>+
>+=============
>+Devlink reset
>+=============
>+
>+The ``devlink-reset`` API allows reset the hardware components of the device. After the reset,
>+device loads the pending updated firmware image.
>+Example use::
>+
>+  $ devlink dev reset pci/0000:05:00.0 components COMPONENTS
>+
>+Note that user can mention multiple components.
>+
>+================
>+Reset components
>+================
>+
>+List of available components::
>+
>+``DEVLINK_RESET_COMP_MGMT`` - Management processor.
>+``DEVLINK_RESET_COMP_DMA`` - DMA engine.
>+``DEVLINK_RESET_COMP_RAM`` - RAM shared between multiple components.
>+``DEVLINK_RESET_COMP_AP``   - Application processor.
>+``DEVLINK_RESET_COMP_ROCE`` - RoCE management processor.
>+``DEVLINK_RESET_COMP_ALL``  - All components.
>+
>+===========
>+Reset width
>+===========
>+
>+List of available widths::
>+
>+``DEVLINK_RESET_WIDTH_SINGLE`` - Device is used by single dedicated host.
>+``DEVLINK_RESET_WIDTH_MULTI``  - Device is shared across multiple hosts.
>+
>+Note that if user specifies DEVLINK_RESET_WIDTH_SINGLE in a multi-host environment, driver returns
>+error if it does not support resetting a single host.
>+
>+===========
>+Reset modes
>+===========
>+
>+List of available reset modes::
>+
>+``DEVLINK_RESET_MODE_DEFERRED``  - Reset happens after all host drivers are unloaded on the device.
>+``DEVLINK_RESET_MODE_LIVE``      - Reset happens immediately, with all loaded host drivers in real
>+                                   time.
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 428f55f..a71c8f5 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1129,6 +1129,8 @@ struct devlink_ops {
> 	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_port *port,
> 					 const u8 *hw_addr, int hw_addr_len,
> 					 struct netlink_ext_ack *extack);
>+	int (*reset)(struct devlink *devlink, u32 *components, u8 width, u8 mode,
>+		     struct netlink_ext_ack *extack);
> };
> 
> static inline void *devlink_priv(struct devlink *devlink)
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index 87c83a8..6f32c00 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -122,6 +122,9 @@ enum devlink_command {
> 	DEVLINK_CMD_TRAP_POLICER_NEW,
> 	DEVLINK_CMD_TRAP_POLICER_DEL,
> 
>+	DEVLINK_CMD_RESET,
>+	DEVLINK_CMD_RESET_STATUS,	/* notification only */
>+
> 	/* add new commands above here */
> 	__DEVLINK_CMD_MAX,
> 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
>@@ -265,6 +268,44 @@ enum devlink_trap_type {
> 	DEVLINK_TRAP_TYPE_CONTROL,
> };
> 
>+/**
>+ * enum devlink_reset_component - Reset components.
>+ * @DEVLINK_RESET_COMP_MGMT: Management processor.
>+ * @DEVLINK_RESET_COMP_DMA: DMA engine.
>+ * @DEVLINK_RESET_COMP_RAM: RAM shared between multiple components.
>+ * @DEVLINK_RESET_COMP_AP: Application processor.
>+ * @DEVLINK_RESET_COMP_ROCE: RoCE management processor.
>+ * @DEVLINK_RESET_COMP_ALL: All components.
>+ */
>+enum devlink_reset_component {
>+	DEVLINK_RESET_COMP_MGMT		= (1 << 0),
>+	DEVLINK_RESET_COMP_DMA		= (1 << 1),
>+	DEVLINK_RESET_COMP_RAM		= (1 << 2),
>+	DEVLINK_RESET_COMP_AP		= (1 << 3),
>+	DEVLINK_RESET_COMP_ROCE		= (1 << 4),
>+	DEVLINK_RESET_COMP_ALL		= 0xffffffff,
>+};
>+
>+/**
>+ * enum devlink_reset_width - Number of hosts effected by reset.
>+ * @DEVLINK_RESET_WIDTH_SINGLE: Device is used by single dedicated host.
>+ * @DEVLINK_RESET_WIDTH_MULTI: Device is shared across multiple hosts.
>+ */
>+enum devlink_reset_width {
>+	DEVLINK_RESET_WIDTH_SINGLE	= 0,
>+	DEVLINK_RESET_WIDTH_MULTI	= 1,
>+};
>+
>+/**
>+ * enum devlink_reset_mode - Modes of reset.
>+ * @DEVLINK_RESET_MODE_DEFERRED: Reset will happen after host drivers are unloaded.
>+ * @DEVLINK_RESET_MODE_LIVE: All host drivers also will be reset without reloading manually.
>+ */
>+enum devlink_reset_mode {
>+	DEVLINK_RESET_MODE_DEFERRED	= 0,
>+	DEVLINK_RESET_MODE_LIVE		= 1,
>+};
>+
> enum {
> 	/* Trap can report input port as metadata */
> 	DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT,
>@@ -455,6 +496,11 @@ enum devlink_attr {
> 
> 	DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,	/* string */
> 
>+	DEVLINK_ATTR_RESET_COMPONENTS,		/* u32 */
>+	DEVLINK_ATTR_RESET_WIDTH,		/* u8 */
>+	DEVLINK_ATTR_RESET_MODE,		/* u8 */
>+	DEVLINK_ATTR_RESET_STATUS_MSG,		/* string */
>+
> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 6ae3680..c0eebc5 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -6797,6 +6797,82 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
> 	return devlink_trap_policer_set(devlink, policer_item, info);
> }
> 
>+static int devlink_nl_reset_fill(struct sk_buff *msg, struct devlink *devlink,
>+				 const char *status_msg, u32 components)
>+{
>+	void *hdr;
>+
>+	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, DEVLINK_CMD_RESET_STATUS);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	if (devlink_nl_put_handle(msg, devlink))
>+		goto nla_put_failure;
>+
>+	if (status_msg && nla_put_string(msg, DEVLINK_ATTR_RESET_STATUS_MSG, status_msg))
>+		goto nla_put_failure;
>+
>+	if (nla_put_u32(msg, DEVLINK_ATTR_RESET_COMPONENTS, components))
>+		goto nla_put_failure;
>+
>+	genlmsg_end(msg, hdr);
>+	return 0;
>+
>+nla_put_failure:
>+	genlmsg_cancel(msg, hdr);
>+	return -EMSGSIZE;
>+}
>+
>+static void __devlink_reset_notify(struct devlink *devlink, const char *status_msg, u32 components)
>+{
>+	struct sk_buff *msg;
>+	int err;
>+
>+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>+	if (!msg)
>+		return;
>+
>+	err = devlink_nl_reset_fill(msg, devlink, status_msg, components);
>+	if (err)
>+		goto out;
>+
>+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink), msg, 0,
>+				DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
>+	return;
>+
>+out:
>+	nlmsg_free(msg);
>+}
>+
>+static int devlink_nl_cmd_reset(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct devlink *devlink = info->user_ptr[0];
>+	u32 components, req_comps;
>+	struct nlattr *nla_type;
>+	u8 width, mode;
>+	int err;
>+
>+	if (!devlink->ops->reset)
>+		return -EOPNOTSUPP;
>+
>+	if (!info->attrs[DEVLINK_ATTR_RESET_COMPONENTS])
>+		return -EINVAL;
>+	components = nla_get_u32(info->attrs[DEVLINK_ATTR_RESET_COMPONENTS]);
>+
>+	nla_type = info->attrs[DEVLINK_ATTR_RESET_WIDTH];
>+	width = nla_type ? nla_get_u8(nla_type) : DEVLINK_RESET_WIDTH_SINGLE;
>+
>+	nla_type = info->attrs[DEVLINK_ATTR_RESET_MODE];
>+	mode = nla_type ? nla_get_u8(nla_type) : DEVLINK_RESET_MODE_DEFERRED;
>+
>+	req_comps = components;
>+	__devlink_reset_notify(devlink, "Reset request", components);
>+	err = devlink->ops->reset(devlink, &components, width, mode, info->extack);
>+	__devlink_reset_notify(devlink, "Components reset", req_comps & ~components);
>+
>+	return err;
>+}
>+
> static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_UNSPEC] = { .strict_start_type =
> 		DEVLINK_ATTR_TRAP_POLICER_ID },
>@@ -6842,6 +6918,9 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
> 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
> 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
> 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
>+	[DEVLINK_ATTR_RESET_COMPONENTS] = { .type = NLA_U32 },
>+	[DEVLINK_ATTR_RESET_WIDTH] = { .type = NLA_U8 },
>+	[DEVLINK_ATTR_RESET_MODE] = { .type = NLA_U8 },
> };
> 
> static const struct genl_ops devlink_nl_ops[] = {
>@@ -7190,6 +7269,12 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
> 		.flags = GENL_ADMIN_PERM,
> 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
> 	},
>+	{
>+		.cmd = DEVLINK_CMD_RESET,
>+		.doit = devlink_nl_cmd_reset,
>+		.flags = GENL_ADMIN_PERM,
>+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
>+	},
> };
> 
> static struct genl_family devlink_nl_family __ro_after_init = {
>-- 
>1.8.3.1
>
