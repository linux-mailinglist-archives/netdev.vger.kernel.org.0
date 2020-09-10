Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BE526505A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbgIJUN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgIJUKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:10:49 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9535C061796
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:10:43 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id n22so7651247edt.4
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=92LUEpUZJvJ8CbMU0X6D9RFpqUSyWG561UdYO2bOIEk=;
        b=Rpv2y4UcitWQXsVYWboPmWStmUuG8WYxeT5IxQ1DmwtfHnTIiHt18ZZidsmFkYiuap
         3LGu+7w8trIyTJR3KtYBIkoI1Vp81g5pRXcqSG9MMp/0CnxJ1JyiobJ1+NN4aKfCcSh7
         AlVpd0cFWMZg1dGhN2y4h80MsbA72mJRx1HGiSHzJ6N/14+URtL4gUuH3Wl6x9S6optL
         WJGRQ6EzY6/rXR+Stvd37eczHXRYAzEDcQnC49x83issgWWOSfnqRE78/kmUvsVWDVqo
         At1wOgv2wwArOrZdwkIpGrQffv21eHbwIXjYbYC9zsZTzQdLhxIMojKu1gKNjP03uiZ6
         Vahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=92LUEpUZJvJ8CbMU0X6D9RFpqUSyWG561UdYO2bOIEk=;
        b=Gl5oPWM7l5qqGNdPAFPGVEsxodCf//MJ/MPuGuOAdDg9waZ0498PuEk+CsSrcs7Fcy
         hCAajrbmadKwYKmj+MNgaPsw0RGiYX3T6CiZLRQvorjTr2M1bpc55QMsJabcDNJa5Z7U
         l1p2Z5fT8O1bgSxbumHN79sg16YgBwXmQ0PjEID6sVCsdm4up0/l4/sQdzeFwH1eQwxE
         e4Fe/DwTY9A+RczZ7lq4gvPD8RHU2IKf0gr4RK3uynmDy1hB8qJguEaU/h57XsSuutal
         zWLuJFgLZ5rEuUezuqNbuxBABZ71T3/CIkkJO0R8//2ob0rVOY7WET9ORKQmI+qo9mN8
         GB3w==
X-Gm-Message-State: AOAM533EI19mq+74lPnCnRrgI2r6hwI55Z9IXZZ8WcF/0RvD/3+aLaYX
        3fxo3CPT5ICMw5wgCRE31jflcw==
X-Google-Smtp-Source: ABdhPJy4QAiGe6b04QYGYHE78vg+hFJa+0s/insXQ8xFSpNfQ9MWswEDZGZnhVcvmk+rBfNyAp3+/A==
X-Received: by 2002:aa7:dcc1:: with SMTP id w1mr10782483edu.360.1599768642495;
        Thu, 10 Sep 2020 13:10:42 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f4sm8134922edm.76.2020.09.10.13.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 13:10:42 -0700 (PDT)
Date:   Thu, 10 Sep 2020 22:10:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next v4 3/5] devlink: introduce flash update overwrite mask
Message-ID: <20200910201040.GU2997@nanopsycho.orion>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
 <20200909222653.32994-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909222653.32994-4-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 10, 2020 at 12:26:51AM CEST, jacob.e.keller@intel.com wrote:
>Sections of device flash may contain settings or device identifying
>information. When performing a flash update, it is generally expected
>that these settings and identifiers are not overwritten.
>
>However, it may sometimes be useful to allow overwriting these fields
>when performing a flash update. Some examples include, 1) customizing
>the initial device config on first programming, such as overwriting
>default device identifying information, or 2) reverting a device
>configuration to known good state provided in the new firmware image, or
>3) in case it is suspected that current firmware logic for managing the
>preservation of fields during an update is broken.
>
>Although some devices are able to completely separate these types of
>settings and fields into separate components, this is not true for all
>hardware.
>
>To support controlling this behavior, a new
>DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK is defined. This is an
>nla_bitfield32 which will define what subset of fields in a component
>should be overwritten during an update.
>
>If no bits are specified, or of the overwrite mask is not provided, then
>an update should not overwrite anything, and should maintain the
>settings and identifiers as they are in the previous image.
>
>If the overwrite mask has the DEVLINK_FLASH_OVERWRITE_SETTINGS bit set,
>then the device should be configured to overwrite any of the settings in
>the requested component with settings found in the provided image.
>
>Similarly, if the DEVLINK_FLASH_OVERWRITE_IDENTIFIERS bit is set, the
>device should be configured to overwrite any device identifiers in the
>requested component with the identifiers from the image.
>
>Multiple overwrite modes may be combined to indicate that a combination
>of the set of fields that should be overwritten.
>
>Drivers which support the new overwrite mask must set the
>DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK in the
>supported_flash_update_params field of their devlink_ops.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
>Changes since v3
>* split netdevsim driver changes to a new patch
>* fixed a double-the typo in the documentation
>
> .../networking/devlink/devlink-flash.rst      | 28 +++++++++++++++++++
> include/net/devlink.h                         |  4 ++-
> include/uapi/linux/devlink.h                  | 25 +++++++++++++++++
> net/core/devlink.c                            | 17 ++++++++++-
> 4 files changed, 72 insertions(+), 2 deletions(-)
>
>diff --git a/Documentation/networking/devlink/devlink-flash.rst b/Documentation/networking/devlink/devlink-flash.rst
>index 40a87c0222cb..603e732f00cc 100644
>--- a/Documentation/networking/devlink/devlink-flash.rst
>+++ b/Documentation/networking/devlink/devlink-flash.rst
>@@ -16,6 +16,34 @@ Note that the file name is a path relative to the firmware loading path
> (usually ``/lib/firmware/``). Drivers may send status updates to inform
> user space about the progress of the update operation.
> 
>+Overwrite Mask
>+==============
>+
>+The ``devlink-flash`` command allows optionally specifying a mask indicating
>+how the device should handle subsections of flash components when updating.
>+This mask indicates the set of sections which are allowed to be overwritten.
>+
>+.. list-table:: List of overwrite mask bits
>+   :widths: 5 95
>+
>+   * - Name
>+     - Description
>+   * - ``DEVLINK_FLASH_OVERWRITE_SETTINGS``
>+     - Indicates that the device should overwrite settings in the components
>+       being updated with the settings found in the provided image.
>+   * - ``DEVLINK_FLASH_OVERWRITE_IDENTIFIERS``
>+     - Indicates that the device should overwrite identifiers in the
>+       components being updated with the identifiers found in the provided
>+       image. This includes MAC addresses, serial IDs, and similar device
>+       identifiers.
>+
>+Multiple overwrite bits may be combined and requested together. If no bits
>+are provided, it is expected that the device only update firmware binaries
>+in the components being updated. Settings and identifiers are expected to be
>+preserved across the update. A device may not support every combination and
>+the driver for such a device must reject any combination which cannot be
>+faithfully implemented.
>+
> Firmware Loading
> ================
> 
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 3384e901bbf0..ff4638f7e547 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -543,9 +543,11 @@ enum devlink_param_generic_id {
> struct devlink_flash_update_params {
> 	const char *file_name;
> 	const char *component;
>+	u32 overwrite_mask;
> };
> 
>-#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT	BIT(0)
>+#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
>+#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
> 
> struct devlink_region;
> struct devlink_info_req;
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index 40d35145c879..19a573566359 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -228,6 +228,28 @@ enum {
> 	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
> };
> 
>+/* Specify what sections of a flash component can be overwritten when
>+ * performing an update. Overwriting of firmware binary sections is always
>+ * implicitly assumed to be allowed.
>+ *
>+ * Each section must be documented in
>+ * Documentation/networking/devlink/devlink-flash.rst
>+ *
>+ */
>+enum {
>+	DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT,
>+	DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT,
>+
>+	__DEVLINK_FLASH_OVERWRITE_MAX_BIT,
>+	DEVLINK_FLASH_OVERWRITE_MAX_BIT = __DEVLINK_FLASH_OVERWRITE_MAX_BIT - 1
>+};
>+
>+#define DEVLINK_FLASH_OVERWRITE_SETTINGS BIT(DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT)
>+#define DEVLINK_FLASH_OVERWRITE_IDENTIFIERS BIT(DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT)
>+
>+#define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
>+	(BIT(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
>+
> /**
>  * enum devlink_trap_action - Packet trap action.
>  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
>@@ -460,6 +482,9 @@ enum devlink_attr {
> 
> 	DEVLINK_ATTR_PORT_EXTERNAL,		/* u8 */
> 	DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,	/* u32 */
>+
>+	DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,	/* bitfield32 */
>+
> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index c61f9c8205f6..d0d38ca17ea8 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -3125,8 +3125,8 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 				       struct genl_info *info)
> {
> 	struct devlink_flash_update_params params = {};
>+	struct nlattr *nla_component, *nla_overwrite;
> 	struct devlink *devlink = info->user_ptr[0];
>-	struct nlattr *nla_component;
> 	u32 supported_params;
> 
> 	if (!devlink->ops->flash_update)
>@@ -3149,6 +3149,19 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 		params.component = nla_data(nla_component);
> 	}
> 
>+	nla_overwrite = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];

Just a nitpick, better to name this "nla_overwrite_mask" to follow the
name of the netlink attr.

Otherwise (extept the uapi BIT as Jakub pointed out) this looks fine to
me.


>+	if (nla_overwrite) {
>+		struct nla_bitfield32 sections;
>+
>+		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK)) {
>+			NL_SET_ERR_MSG_ATTR(info->extack, nla_overwrite,
>+					    "overwrite is not supported");
>+			return -EOPNOTSUPP;
>+		}
>+		sections = nla_get_bitfield32(nla_overwrite);
>+		params.overwrite_mask = sections.value & sections.selector;
>+	}
>+
> 	return devlink->ops->flash_update(devlink, &params, info->extack);
> }
> 
>@@ -7046,6 +7059,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
> 	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
> 	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
>+	[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK] =
>+		NLA_POLICY_BITFIELD32(DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS),
> 	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
> 	[DEVLINK_ATTR_TRAP_ACTION] = { .type = NLA_U8 },
> 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = { .type = NLA_NUL_STRING },
>-- 
>2.28.0.218.ge27853923b9d.dirty
>
