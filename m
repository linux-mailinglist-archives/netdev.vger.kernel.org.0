Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BCB64267F
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 11:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiLEKMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 05:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiLEKMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 05:12:53 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AE8659E
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 02:12:51 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id i15so6855037edf.2
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 02:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ItDf+0gOEhZ0m7Vhc5wRiUlNBUcx10CQrUiNZ90stM=;
        b=UaKBQYoUt+Ln+rrqbUWVIxWbpWJ9U98ChFlBNwu9jSKRtQC2xZbRW8o0ajwHrKUYr2
         xTYjnNAXj2FkNVfxeCXoMnTwioabFNGapE5vEEXu9uSdtm8MTc/FTAECroJaex/cgTc3
         OK0qnBV9oyPQXVCRhVCKWXFJQ7Bdrqq0HGVpmbFEKZCJHoDXUVu/uhunOa+Df0spshlY
         xfFI4rzcW5BEjilGPynsjIBn6bPtmV0jY2d9V6x2i7VVK30Px+9x8mfUXJAJVrZ/tkbd
         3H1rRNqBDm8ONYWMVreK9HNMDJUzU4yIO5RjjGva+/saufJ4KtfqTLQ5DgT2L/1qGFHx
         sZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ItDf+0gOEhZ0m7Vhc5wRiUlNBUcx10CQrUiNZ90stM=;
        b=cKiQ6L+kBWb0WKu67yRRmxNTMXu+j2UszHluG2W/Tp2LNsBVGy2MBjbyHVDp+nnT9P
         yES8HqM4kXTiTOpbCkhFhVvH0lfdqcs+tONkBWHMBy+FDF0Bx6xOvZgL8AKOwJ54kQ75
         p1MI9/s3YZaQ0i7d39I/KfRW3v61Wj4MF1s3GlmjXrIt2ucn+qr3gqapNYYUaLr124uW
         nn3ePozvzoyrStd7wYeXjBY+e9SSqFmnOcMzWBDsgEQwFlwPpthTm2HbE9fMpVDN3Gkv
         XeLuzxJCq22H1oWNFlX8my2aW+Z4+vqnJdsvsNj0CTo1M1xJfuEyuC7mRURo10NdNHgI
         tFpw==
X-Gm-Message-State: ANoB5pmJelDxsLPPQqHjqYfGxvfKVp7eQjudC2ca2rxAUHl1BYGHrX0y
        u6UU51CAGJN5zxxMj3h+R4aH9VcjwqF5NlQxhFs=
X-Google-Smtp-Source: AA0mqf4sEd8C83nfSwC2ex+0BTGgATeRGvi/mq1oV/qpYGDHomFMEByrNqBmU+WMMhOFr44NpLeOdA==
X-Received: by 2002:a05:6402:1381:b0:468:5b78:6381 with SMTP id b1-20020a056402138100b004685b786381mr61468858edv.373.1670235169989;
        Mon, 05 Dec 2022 02:12:49 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id sb25-20020a1709076d9900b007ba46867e6asm6139199ejc.16.2022.12.05.02.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 02:12:49 -0800 (PST)
Date:   Mon, 5 Dec 2022 11:12:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shay Drory <shayd@nvidia.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        danielj@nvidia.com, yishaih@nvidia.com, jiri@nvidia.com,
        saeedm@nvidia.com, parav@nvidia.com
Subject: Re: [PATCH net-next V3 4/8] devlink: Expose port function commands
 to control RoCE
Message-ID: <Y43EIHJ8nlUz5HYK@nanopsycho>
References: <20221204141632.201932-1-shayd@nvidia.com>
 <20221204141632.201932-5-shayd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221204141632.201932-5-shayd@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Dec 04, 2022 at 03:16:28PM CET, shayd@nvidia.com wrote:
>Expose port function commands to enable / disable RoCE, this is used to
>control the port RoCE device capabilities.
>
>When RoCE is disabled for a function of the port, function cannot create
>any RoCE specific resources (e.g GID table).
>It also saves system memory utilization. For example disabling RoCE enable a
>VF/SF saves 1 Mbytes of system memory per function.
>
>Example of a PCI VF port which supports function configuration:
>Set RoCE of the VF's port function.
>
>$ devlink port show pci/0000:06:00.0/2
>pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
>vfnum 1
>    function:
>        hw_addr 00:00:00:00:00:00 roce enable
>
>$ devlink port function set pci/0000:06:00.0/2 roce disable
>
>$ devlink port show pci/0000:06:00.0/2
>pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
>vfnum 1
>    function:
>        hw_addr 00:00:00:00:00:00 roce disable
>
>Signed-off-by: Shay Drory <shayd@nvidia.com>
>Reviewed-by: Jiri Pirko <jiri@nvidia.com>

When you do changes in the patch, you should remove reviewed-by and
acked-by tags.


>---
>v2->v3:
> - change DEVLINK_PORT_FN_SET_CAP to devlink_port_fn_cap_fill.
> - move out DEVLINK_PORT_FN_CAPS_VALID_MASK from UAPI.
> - introduce DEVLINK_PORT_FN_CAP_ROCE and add _BIT suffix to
>   devlink_port_fn_attr_cap.
> - remove DEVLINK_PORT_FN_ATTR_CAPS_MAX
>---
> .../networking/devlink/devlink-port.rst       |  34 +++++-
> include/net/devlink.h                         |  19 +++
> include/uapi/linux/devlink.h                  |  10 ++
> net/core/devlink.c                            | 113 ++++++++++++++++++
> 4 files changed, 175 insertions(+), 1 deletion(-)
>
>diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
>index 2c637f4aae8e..c3302d23e480 100644
>--- a/Documentation/networking/devlink/devlink-port.rst
>+++ b/Documentation/networking/devlink/devlink-port.rst
>@@ -110,7 +110,7 @@ devlink ports for both the controllers.
> Function configuration
> ======================
> 
>-A user can configure the function attribute before enumerating the PCI
>+Users can configure one or more function attributes before enumerating the PCI
> function. Usually it means, user should configure function attribute
> before a bus specific device for the function is created. However, when
> SRIOV is enabled, virtual function devices are created on the PCI bus.
>@@ -122,6 +122,9 @@ A user may set the hardware address of the function using
> `devlink port function set hw_addr` command. For Ethernet port function
> this means a MAC address.
> 
>+Users may also set the RoCE capability of the function using
>+`devlink port function set roce` command.
>+
> Function attributes
> ===================
> 
>@@ -162,6 +165,35 @@ device created for the PCI VF/SF.
>       function:
>         hw_addr 00:00:00:00:88:88
> 
>+RoCE capability setup
>+---------------------
>+Not all PCI VFs/SFs require RoCE capability.
>+
>+When RoCE capability is disabled, it saves system memory per PCI VF/SF.
>+
>+When user disables RoCE capability for a VF/SF, user application cannot send or
>+receive any RoCE packets through this VF/SF and RoCE GID table for this PCI
>+will be empty.
>+
>+When RoCE capability is disabled in the device using port function attribute,
>+VF/SF driver cannot override it.
>+
>+- Get RoCE capability of the VF device::
>+
>+    $ devlink port show pci/0000:06:00.0/2
>+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
>+        function:
>+            hw_addr 00:00:00:00:00:00 roce enable
>+
>+- Set RoCE capability of the VF device::
>+
>+    $ devlink port function set pci/0000:06:00.0/2 roce disable
>+
>+    $ devlink port show pci/0000:06:00.0/2
>+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
>+        function:
>+            hw_addr 00:00:00:00:00:00 roce disable
>+
> Subfunction
> ============
> 
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 5f6eca5e4a40..20306fb8a1d9 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1451,6 +1451,25 @@ struct devlink_ops {
> 	int (*port_function_hw_addr_set)(struct devlink_port *port,
> 					 const u8 *hw_addr, int hw_addr_len,
> 					 struct netlink_ext_ack *extack);
>+	/**
>+	 * @port_function_roce_get: Port function's roce get function.
>+	 *
>+	 * Query RoCE state of a function managed by the devlink port.
>+	 * Return -EOPNOTSUPP if port function RoCE handling is not supported.
>+	 */
>+	int (*port_function_roce_get)(struct devlink_port *devlink_port,
>+				      bool *is_enable,
>+				      struct netlink_ext_ack *extack);
>+	/**
>+	 * @port_function_roce_set: Port function's roce set function.
>+	 *
>+	 * Enable/Disable the RoCE state of a function managed by the devlink
>+	 * port.
>+	 * Return -EOPNOTSUPP if port function RoCE handling is not supported.
>+	 */
>+	int (*port_function_roce_set)(struct devlink_port *devlink_port,
>+				      bool enable,
>+				      struct netlink_ext_ack *extack);
> 	/**
> 	 * port_new() - Add a new port function of a specified flavor
> 	 * @devlink: Devlink instance
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index 70191d96af89..6cc2925bd478 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -658,11 +658,21 @@ enum devlink_resource_unit {
> 	DEVLINK_RESOURCE_UNIT_ENTRY,
> };
> 
>+enum devlink_port_fn_attr_cap {
>+	DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT,
>+
>+	/* Add new caps above */
>+	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,

Well this is not needed in uapi too, but I don't see any good way to
maintain this internally :/ No harm to expose.

Looks good,
Reviewed-by: Jiri Pirko <jiri@nvidia.com>




>+};
>+
>+#define DEVLINK_PORT_FN_CAP_ROCE _BITUL(DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT)
>+
> enum devlink_port_function_attr {
> 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
> 	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
> 	DEVLINK_PORT_FN_ATTR_STATE,	/* u8 */
> 	DEVLINK_PORT_FN_ATTR_OPSTATE,	/* u8 */
>+	DEVLINK_PORT_FN_ATTR_CAPS,	/* bitfield32 */
> 
> 	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
> 	DEVLINK_PORT_FUNCTION_ATTR_MAX = __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 2b6e11277837..5c4d3abd7677 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -195,11 +195,16 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwmsg);
> EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_hwerr);
> EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_trap_report);
> 
>+#define DEVLINK_PORT_FN_CAPS_VALID_MASK \
>+	(_BITUL(__DEVLINK_PORT_FN_ATTR_CAPS_MAX) - 1)
>+
> static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] = {
> 	[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] = { .type = NLA_BINARY },
> 	[DEVLINK_PORT_FN_ATTR_STATE] =
> 		NLA_POLICY_RANGE(NLA_U8, DEVLINK_PORT_FN_STATE_INACTIVE,
> 				 DEVLINK_PORT_FN_STATE_ACTIVE),
>+	[DEVLINK_PORT_FN_ATTR_CAPS] =
>+		NLA_POLICY_BITFIELD32(DEVLINK_PORT_FN_CAPS_VALID_MASK),
> };
> 
> static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {
>@@ -692,6 +697,60 @@ devlink_sb_tc_index_get_from_attrs(struct devlink_sb *devlink_sb,
> 	return 0;
> }
> 
>+static void devlink_port_fn_cap_fill(struct nla_bitfield32 *caps,
>+				     u32 cap, bool is_enable)
>+{
>+	caps->selector |= cap;
>+	if (is_enable)
>+		caps->value |= cap;
>+}
>+
>+static int devlink_port_fn_roce_fill(const struct devlink_ops *ops,
>+				     struct devlink_port *devlink_port,
>+				     struct nla_bitfield32 *caps,
>+				     struct netlink_ext_ack *extack)
>+{
>+	bool is_enable;
>+	int err;
>+
>+	if (!ops->port_function_roce_get)
>+		return 0;
>+
>+	err = ops->port_function_roce_get(devlink_port, &is_enable, extack);
>+	if (err) {
>+		if (err == -EOPNOTSUPP)
>+			return 0;
>+		return err;
>+	}
>+
>+	devlink_port_fn_cap_fill(caps, DEVLINK_PORT_FN_CAP_ROCE, is_enable);
>+	return 0;
>+}
>+
>+static int devlink_port_fn_caps_fill(const struct devlink_ops *ops,
>+				     struct devlink_port *devlink_port,
>+				     struct sk_buff *msg,
>+				     struct netlink_ext_ack *extack,
>+				     bool *msg_updated)
>+{
>+	struct nla_bitfield32 caps = {};
>+	int err;
>+
>+	err = devlink_port_fn_roce_fill(ops, devlink_port, &caps, extack);
>+	if (err)
>+		return err;
>+
>+	if (!caps.selector)
>+		return 0;
>+	err = nla_put_bitfield32(msg, DEVLINK_PORT_FN_ATTR_CAPS, caps.value,
>+				 caps.selector);
>+	if (err)
>+		return err;
>+
>+	*msg_updated = true;
>+	return 0;
>+}
>+
> static int
> devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
> 				  struct genl_info *info,
>@@ -1275,6 +1334,35 @@ static int devlink_port_fn_state_fill(const struct devlink_ops *ops,
> 	return 0;
> }
> 
>+static int
>+devlink_port_fn_roce_set(struct devlink_port *devlink_port, bool enable,
>+			 struct netlink_ext_ack *extack)
>+{
>+	const struct devlink_ops *ops = devlink_port->devlink->ops;
>+
>+	return ops->port_function_roce_set(devlink_port, enable, extack);
>+}
>+
>+static int devlink_port_fn_caps_set(struct devlink_port *devlink_port,
>+				    const struct nlattr *attr,
>+				    struct netlink_ext_ack *extack)
>+{
>+	struct nla_bitfield32 caps;
>+	u32 caps_value;
>+	int err;
>+
>+	caps = nla_get_bitfield32(attr);
>+	caps_value = caps.value & caps.selector;
>+	if (caps.selector & DEVLINK_PORT_FN_CAP_ROCE) {
>+		err = devlink_port_fn_roce_set(devlink_port,
>+					       caps_value & DEVLINK_PORT_FN_CAP_ROCE,
>+					       extack);
>+		if (err)
>+			return err;
>+	}
>+	return 0;
>+}
>+
> static int
> devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
> 				   struct netlink_ext_ack *extack)
>@@ -1293,6 +1381,10 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
> 					   &msg_updated);
> 	if (err)
> 		goto out;
>+	err = devlink_port_fn_caps_fill(ops, port, msg, extack,
>+					&msg_updated);
>+	if (err)
>+		goto out;
> 	err = devlink_port_fn_state_fill(ops, port, msg, extack, &msg_updated);
> out:
> 	if (err || !msg_updated)
>@@ -1665,6 +1757,7 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
> 					  struct netlink_ext_ack *extack)
> {
> 	const struct devlink_ops *ops = devlink_port->devlink->ops;
>+	struct nlattr *attr;
> 
> 	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
> 	    !ops->port_function_hw_addr_set) {
>@@ -1677,6 +1770,18 @@ static int devlink_port_function_validate(struct devlink_port *devlink_port,
> 				   "Function does not support state setting");
> 		return -EOPNOTSUPP;
> 	}
>+	attr = tb[DEVLINK_PORT_FN_ATTR_CAPS];
>+	if (attr) {
>+		struct nla_bitfield32 caps;
>+
>+		caps = nla_get_bitfield32(attr);
>+		if (caps.selector & DEVLINK_PORT_FN_CAP_ROCE &&
>+		    !ops->port_function_roce_set) {
>+			NL_SET_ERR_MSG_ATTR(extack, attr,
>+					    "Port doesn't support RoCE function attribute");
>+			return -EOPNOTSUPP;
>+		}
>+	}
> 	return 0;
> }
> 
>@@ -1704,6 +1809,14 @@ static int devlink_port_function_set(struct devlink_port *port,
> 		if (err)
> 			return err;
> 	}
>+
>+	attr = tb[DEVLINK_PORT_FN_ATTR_CAPS];
>+	if (attr) {
>+		err = devlink_port_fn_caps_set(port, attr, extack);
>+		if (err)
>+			return err;
>+	}
>+
> 	/* Keep this as the last function attribute set, so that when
> 	 * multiple port function attributes are set along with state,
> 	 * Those can be applied first before activating the state.
>-- 
>2.38.1
>
