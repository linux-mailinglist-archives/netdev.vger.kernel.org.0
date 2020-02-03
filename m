Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C17150559
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 12:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgBCLff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 06:35:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34344 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgBCLfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 06:35:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id t2so17610513wrr.1
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 03:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jSFo0ML6L7SsBb2j5DY3vFj5UsOLOUQkPfcDGE/dOCk=;
        b=rURwkMRM5ehnVeyU2X0Fu88elIj6oesooAKBMzqyX+H/bYIKcbRq5oRlsL/8T6Fls8
         JAiOg1RLtHDWrLTtQ/QCdZ1qkAiAnG8J6ZdrH18nK/xNc2CrJEeVz4OcEPVPudFUSWYN
         IQMh9de+JyZB9mNs5Wot2iw8l7F3fYnpG0+1YFlAIfo3DX5B6XdnlQWSFGZzZf6Dtdp4
         JFaCQaCcqjhrSJlN70iNePtgr/FZ3IuBFpIBXqKAYchaFflll/34ypwxf8hCQp9Jg9x8
         vTID4NvALycvDz8biJmGEtud8DjLYmMbIbX4XdDZAay5RGm1lDSW5qLJ3cCirTvbpRUw
         reSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jSFo0ML6L7SsBb2j5DY3vFj5UsOLOUQkPfcDGE/dOCk=;
        b=HHLRddn/hqS/ytPi2SABxBf1T7TSoJzjbayrw38/d7AV0yd1It4XyVVmE5dLwUhoB9
         alO42hH9g/dXWcgrWY4qGFU30PY2bUUZ3OcRVn3oTchqyIow9uUt51nuqzfC/NfE/Vpk
         x5H9XfaLHUK7/nsAKFgp+UfJGjRIy7A6iH1asnO7JTOlw+OMxlPnHkVZ2VXtW/zDPio/
         xlQaGMmLdCiiplVVlNpPhryLtShza/V8dgN4ISMqQrDQ+RgzE+RZSG6xcjS41PwltpNE
         03G+9QCQvBBGLucPXz20gqy4yfd15lqgLZJwsT5fstluVe1/4jPARl+zx0JioUC3PLDB
         PTBA==
X-Gm-Message-State: APjAAAWp2lVb+9izlrKXcgdyiOJB+vmqY9J2JIddazJWC2HtzMtUBCgM
        0Ql4ICXIO+NX2I1n4VtcOJ8C/DUv5ws=
X-Google-Smtp-Source: APXvYqzARMKarRQ0Fifd+8hld9zetFPKclH+8wcZSS13VnLzK8Ig+bXs7YOm+2D2jxTuUHK2PKpJ3g==
X-Received: by 2002:adf:fac8:: with SMTP id a8mr14878761wrs.81.1580729730446;
        Mon, 03 Feb 2020 03:35:30 -0800 (PST)
Received: from localhost (ip-89-177-6-126.net.upcbroadband.cz. [89.177.6.126])
        by smtp.gmail.com with ESMTPSA id y139sm23348145wmd.24.2020.02.03.03.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 03:35:29 -0800 (PST)
Date:   Mon, 3 Feb 2020 12:35:29 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
Subject: Re: [PATCH 01/15] devlink: prepare to support region operations
Message-ID: <20200203113529.GC2260@nanopsycho>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130225913.1671982-2-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 30, 2020 at 11:58:56PM CET, jacob.e.keller@intel.com wrote:
>Modify the devlink region code in preparation for adding new operations
>on regions.
>
>Create a devlink_region_ops structure, and move the name pointer from
>within the devlink_region structure into the ops structure (similar to
>the devlink_health_reporter_ops).
>
>This prepares the regions to enable support of additional operations in
>the future such as requesting snapshots, or accessing the region
>directly without a snapshot.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> drivers/net/ethernet/mellanox/mlx4/crdump.c | 25 ++++++++++++---------
> drivers/net/netdevsim/dev.c                 |  6 ++++-
> include/net/devlink.h                       | 17 ++++++++++----
> net/core/devlink.c                          | 23 ++++++++++---------
> 4 files changed, 45 insertions(+), 26 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
>index 64ed725aec28..4cea64033919 100644
>--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
>+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
>@@ -38,8 +38,13 @@
> #define CR_ENABLE_BIT_OFFSET		0xF3F04
> #define MAX_NUM_OF_DUMPS_TO_STORE	(8)
> 
>-static const char *region_cr_space_str = "cr-space";
>-static const char *region_fw_health_str = "fw-health";

Just leave these as are and use in ops and messages. It is odd to use
ops.name in the message.


>+static const struct devlink_region_ops region_cr_space_ops = {
>+	.name = "cr-space",
>+};
>+
>+static const struct devlink_region_ops region_fw_health_ops = {
>+	.name = "fw-health",
>+};
> 
> /* Set to true in case cr enable bit was set to true before crdump */
> static bool crdump_enbale_bit_set;
>@@ -103,10 +108,10 @@ static void mlx4_crdump_collect_crspace(struct mlx4_dev *dev,
> 		if (err) {
> 			kvfree(crspace_data);
> 			mlx4_warn(dev, "crdump: devlink create %s snapshot id %d err %d\n",
>-				  region_cr_space_str, id, err);
>+				  region_cr_space_ops.name, id, err);
> 		} else {
> 			mlx4_info(dev, "crdump: added snapshot %d to devlink region %s\n",
>-				  id, region_cr_space_str);
>+				  id, region_cr_space_ops.name);
> 		}
> 	} else {
> 		mlx4_err(dev, "crdump: Failed to allocate crspace buffer\n");
>@@ -142,10 +147,10 @@ static void mlx4_crdump_collect_fw_health(struct mlx4_dev *dev,
> 		if (err) {
> 			kvfree(health_data);
> 			mlx4_warn(dev, "crdump: devlink create %s snapshot id %d err %d\n",
>-				  region_fw_health_str, id, err);
>+				  region_fw_health_ops.name, id, err);
> 		} else {
> 			mlx4_info(dev, "crdump: added snapshot %d to devlink region %s\n",
>-				  id, region_fw_health_str);
>+				  id, region_fw_health_ops.name);
> 		}
> 	} else {
> 		mlx4_err(dev, "crdump: Failed to allocate health buffer\n");
>@@ -205,23 +210,23 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
> 	/* Create cr-space region */
> 	crdump->region_crspace =
> 		devlink_region_create(devlink,
>-				      region_cr_space_str,
>+				      &region_cr_space_ops,
> 				      MAX_NUM_OF_DUMPS_TO_STORE,
> 				      pci_resource_len(pdev, 0));
> 	if (IS_ERR(crdump->region_crspace))
> 		mlx4_warn(dev, "crdump: create devlink region %s err %ld\n",
>-			  region_cr_space_str,
>+			  region_cr_space_ops.name,
> 			  PTR_ERR(crdump->region_crspace));
> 
> 	/* Create fw-health region */
> 	crdump->region_fw_health =
> 		devlink_region_create(devlink,
>-				      region_fw_health_str,
>+				      &region_fw_health_ops,
> 				      MAX_NUM_OF_DUMPS_TO_STORE,
> 				      HEALTH_BUFFER_SIZE);
> 	if (IS_ERR(crdump->region_fw_health))
> 		mlx4_warn(dev, "crdump: create devlink region %s err %ld\n",
>-			  region_fw_health_str,
>+			  region_fw_health_ops.name,
> 			  PTR_ERR(crdump->region_fw_health));
> 
> 	return 0;
>diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>index b53fbc06e104..d521b7bfe007 100644
>--- a/drivers/net/netdevsim/dev.c
>+++ b/drivers/net/netdevsim/dev.c
>@@ -242,11 +242,15 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
> 
> #define NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX 16
> 
>+static const struct devlink_region_ops dummy_region_ops = {
>+	.name = "dummy",
>+};
>+
> static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
> 				      struct devlink *devlink)
> {
> 	nsim_dev->dummy_region =
>-		devlink_region_create(devlink, "dummy",
>+		devlink_region_create(devlink, &dummy_region_ops,
> 				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
> 				      NSIM_DEV_DUMMY_REGION_SIZE);
> 	return PTR_ERR_OR_ZERO(nsim_dev->dummy_region);
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index ce5cea428fdc..4a0baa6903cb 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -495,6 +495,14 @@ struct devlink_info_req;
> 
> typedef void devlink_snapshot_data_dest_t(const void *data);
> 
>+/**
>+ * struct devlink_region_ops - Region operations
>+ * @name: region name
>+ */
>+struct devlink_region_ops {
>+	const char *name;
>+};
>+
> struct devlink_fmsg;
> struct devlink_health_reporter;
> 
>@@ -949,10 +957,11 @@ void devlink_port_param_value_changed(struct devlink_port *devlink_port,
> 				      u32 param_id);
> void devlink_param_value_str_fill(union devlink_param_value *dst_val,
> 				  const char *src);
>-struct devlink_region *devlink_region_create(struct devlink *devlink,
>-					     const char *region_name,
>-					     u32 region_max_snapshots,
>-					     u64 region_size);
>+struct devlink_region *
>+devlink_region_create(struct devlink *devlink,
>+		      const struct devlink_region_ops *ops,
>+		      u32 region_max_snapshots,

No need to wrap here.


>+		      u64 region_size);
> void devlink_region_destroy(struct devlink_region *region);
> u32 devlink_region_snapshot_id_get(struct devlink *devlink);
> int devlink_region_snapshot_create(struct devlink_region *region,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index ca1df0ec3c97..d1f7bfbf81da 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -344,7 +344,7 @@ devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
> struct devlink_region {
> 	struct devlink *devlink;
> 	struct list_head list;
>-	const char *name;
>+	const struct devlink_region_ops *ops;
> 	struct list_head snapshot_list;
> 	u32 max_snapshots;
> 	u32 cur_snapshots;
>@@ -365,7 +365,7 @@ devlink_region_get_by_name(struct devlink *devlink, const char *region_name)
> 	struct devlink_region *region;
> 
> 	list_for_each_entry(region, &devlink->region_list, list)
>-		if (!strcmp(region->name, region_name))
>+		if (!strcmp(region->ops->name, region_name))
> 			return region;
> 
> 	return NULL;
>@@ -3687,7 +3687,7 @@ static int devlink_nl_region_fill(struct sk_buff *msg, struct devlink *devlink,
> 	if (err)
> 		goto nla_put_failure;
> 
>-	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->name);
>+	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->ops->name);
> 	if (err)
> 		goto nla_put_failure;
> 
>@@ -3733,7 +3733,7 @@ static void devlink_nl_region_notify(struct devlink_region *region,
> 		goto out_cancel_msg;
> 
> 	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME,
>-			     region->name);
>+			     region->ops->name);
> 	if (err)
> 		goto out_cancel_msg;
> 
>@@ -7530,21 +7530,22 @@ EXPORT_SYMBOL_GPL(devlink_param_value_str_fill);
>  *	devlink_region_create - create a new address region
>  *
>  *	@devlink: devlink
>- *	@region_name: region name
>+ *	@ops: region operations and name
>  *	@region_max_snapshots: Maximum supported number of snapshots for region
>  *	@region_size: size of region
>  */
>-struct devlink_region *devlink_region_create(struct devlink *devlink,
>-					     const char *region_name,
>-					     u32 region_max_snapshots,
>-					     u64 region_size)
>+struct devlink_region *
>+devlink_region_create(struct devlink *devlink,
>+		      const struct devlink_region_ops *ops,
>+		      u32 region_max_snapshots,

No need to wrap here.


>+		      u64 region_size)
> {
> 	struct devlink_region *region;
> 	int err = 0;
> 
> 	mutex_lock(&devlink->lock);
> 
>-	if (devlink_region_get_by_name(devlink, region_name)) {
>+	if (devlink_region_get_by_name(devlink, ops->name)) {
> 		err = -EEXIST;
> 		goto unlock;
> 	}
>@@ -7557,7 +7558,7 @@ struct devlink_region *devlink_region_create(struct devlink *devlink,
> 
> 	region->devlink = devlink;
> 	region->max_snapshots = region_max_snapshots;
>-	region->name = region_name;
>+	region->ops = ops;
> 	region->size = region_size;
> 	INIT_LIST_HEAD(&region->snapshot_list);
> 	list_add_tail(&region->list, &devlink->region_list);
>-- 
>2.25.0.rc1
>
