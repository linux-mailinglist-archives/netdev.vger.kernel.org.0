Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B89B192DD4
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgCYQIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:08:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37433 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgCYQIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:08:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id d1so3365108wmb.2
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lgWWQsXq+CkksLYtikt1s6Uu2kbBFVAaLyr+NQmgOsY=;
        b=o53SlyMupbkENqwmqF9IgBGyjrs2FbV8TdfPGF3kbCffSDRYJcrn2hl09Xr5yj522l
         3vCiDwDTp9WohmGtpKJtPCCLRev5mTl2VE8auPVU+DCrrhpgD2ZA64WAcG0qBRY5wiLi
         idkJ6xiEDl2lGiDxRrBX+TMJUGuUe4KS7VZ1lITvGz7uMDEB7ux2+eziXkuqDe01WPy7
         fgG5Uj/OblBMtO5tRUKhphaYV67mNjNL2KQTgigBMIt4UaHLUqCHKkiT6R7n5i5+Spe1
         pkLLPppR/68M1uc78X24LaF6fbGfPl6cxxqTSSXuvgjpWNxJb1U7H3UngLqt4t6jLlky
         X7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lgWWQsXq+CkksLYtikt1s6Uu2kbBFVAaLyr+NQmgOsY=;
        b=tASLtmMSdieBBdNewZVKJSHLRVCLQENSe0iydW0Vk49FETR2eO6e8sZgaRMhZWhQWX
         zBxZ0AkvAyFCLOW6Y6vgq0farSXS1XmHjh3E5Scw2vZUUHRdQ2zsOZFFN8dqhkulIvmr
         TV29IxMa1MuzjzUJg2hdbNcPcXNGGDNGgRFxd4cTtfNp0oCBMHxQ84vTWdthxWW/Fqa2
         4FgHKrK23y0K9saUM3KMBGMJYYdnu7z4xtrxuzK85bg+q7D6isPaO+Kk0ZUcclu6/Y11
         A+Iv2iOfHrk3ss3UqN5KtG93zO0tALK+dQQbb3emPPsi0my75ggjfKUSK2yCZVJ5t+1t
         7zJw==
X-Gm-Message-State: ANhLgQ22g1lyA4w/MgArunHZOOCDYlN8dT8XmrmLuz4ij2mDiGzDxCdI
        eVkactJB/6QP6jx99FxsAUEE8ATCw9s=
X-Google-Smtp-Source: ADFU+vvLHGMpXYIggtQWeEzqTXz257oiMBrvyxj8LzUinjfBVff+ZtgG3xHGc9HjmAyKq/sjLCbJ+Q==
X-Received: by 2002:a1c:6885:: with SMTP id d127mr4189266wmc.33.1585152514032;
        Wed, 25 Mar 2020 09:08:34 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u5sm26515738wrq.85.2020.03.25.09.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 09:08:33 -0700 (PDT)
Date:   Wed, 25 Mar 2020 17:08:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] devlink: track snapshot id usage count using an xarray
Message-ID: <20200325160832.GY11304@nanopsycho.orion>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-8-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324223445.2077900-8-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You somehow missed "07/10" from the subject :O


Tue, Mar 24, 2020 at 11:34:42PM CET, jacob.e.keller@intel.com wrote:
>Each snapshot created for a devlink region must have an id. These ids
>are supposed to be unique per "event" that caused the snapshot to be
>created. Drivers call devlink_region_snapshot_id_get to obtain a new id
>to use for a new event trigger. The id values are tracked per devlink,
>so that the same id number can be used if a triggering event creates
>multiple snapshots on different regions.
>
>There is no mechanism for snapshot ids to ever be reused. Introduce an
>xarray to store the count of how many snapshots are using a given id,
>replacing the snapshot_id field previously used for picking the next id.
>
>The devlink_region_snapshot_id_get() function will use xa_alloc to
>insert a zero value at an available slot between 0 and INT_MAX.
>
>The new __devlink_snapshot_id_increment() and
>__devlink_snapshot_id_decrement() functions will be used to track how
>many snapshots currently use an id.
>
>By tracking the total number of snapshots using a given id, it is
>possible for the decrement() function to erase the id from the xarray
>when it is not in use.
>
>With this method, a snapshot id can become reused again once all
>snapshots that referred to it have been deleted via
>DEVLINK_CMD_REGION_DEL.
>
>This work also paves the way to introduce a mechanism for userspace to
>request a snapshot.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> include/net/devlink.h |   3 +-
> net/core/devlink.c    | 119 ++++++++++++++++++++++++++++++++++++++++--
> 2 files changed, 118 insertions(+), 4 deletions(-)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index df9f6ddf6c66..c366777c4f5c 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -18,6 +18,7 @@
> #include <net/net_namespace.h>
> #include <net/flow_offload.h>
> #include <uapi/linux/devlink.h>
>+#include <linux/xarray.h>
> 
> struct devlink_ops;
> 
>@@ -29,13 +30,13 @@ struct devlink {
> 	struct list_head resource_list;
> 	struct list_head param_list;
> 	struct list_head region_list;
>-	u32 snapshot_id;
> 	struct list_head reporter_list;
> 	struct mutex reporters_lock; /* protects reporter_list */
> 	struct devlink_dpipe_headers *dpipe_headers;
> 	struct list_head trap_list;
> 	struct list_head trap_group_list;
> 	const struct devlink_ops *ops;
>+	struct xarray snapshot_ids;
> 	struct device *dev;
> 	possible_net_t _net;
> 	struct mutex lock;
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 62a8566e9851..b3698228a6ed 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -3768,21 +3768,115 @@ static void devlink_nl_region_notify(struct devlink_region *region,
> 	nlmsg_free(msg);
> }
> 
>+/**
>+ * __devlink_snapshot_id_increment - Increment number of snapshots using an id
>+ *	@devlink: devlink instance
>+ *	@id: the snapshot id
>+ *
>+ *	Track when a new snapshot begins using an id. Load the count for the
>+ *	given id from the snapshot xarray, increment it, and store it back.
>+ *
>+ *	Called when a new snapshot is created with the given id.
>+ *
>+ *	The id *must* have been previously allocated by
>+ *	devlink_region_snapshot_id_get().
>+ *
>+ *	Returns 0 on success, or an error on failure.
>+ */
>+static int __devlink_snapshot_id_increment(struct devlink *devlink, u32 id)
>+{
>+	unsigned long count;
>+	int err;
>+	void *p;
>+
>+	lockdep_assert_held(&devlink->lock);
>+
>+	p = xa_load(&devlink->snapshot_ids, id);
>+	if (!p)
>+		return -EEXIST;

This is confusing. You should return rather -ENOTEXIST, if it existed :)
-EINVAL and WARN_ON. This should never happen


>+
>+	if (!xa_is_value(p))
>+		return -EINVAL;
>+
>+	count = xa_to_value(p);
>+	count++;
>+
>+	err = xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(count),
>+			      GFP_KERNEL));

Just return here and remove err variable.


>+	if (err)
>+		return err;
>+
>+	return 0;
>+}
>+
>+/**
>+ * __devlink_snapshot_id_decrement - Decrease number of snapshots using an id
>+ *	@devlink: devlink instance
>+ *	@id: the snapshot id
>+ *
>+ *	Track when a snapshot is deleted and stops using an id. Load the count
>+ *	for the given id from the snapshot xarray, decrement it, and store it
>+ *	back.
>+ *
>+ *	If the count reaches zero, erase this id from the xarray, freeing it
>+ *	up for future re-use by devlink_region_snapshot_id_get().
>+ *
>+ *	Called when a snapshot using the given id is deleted.
>+ */
>+static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
>+{
>+	unsigned long count;
>+	void *p;
>+
>+	lockdep_assert_held(&devlink->lock);
>+
>+	p = xa_load(&devlink->snapshot_ids, id);
>+	if (WARN_ON(!p))
>+		return;
>+
>+	if (WARN_ON(!xa_is_value(p)))
>+		return;
>+
>+	count = xa_to_value(p);
>+
>+	if (count > 1) {
>+		count--;
>+		xa_store(&devlink->snapshot_ids, id, xa_mk_value(count),
>+			 GFP_KERNEL);
>+	} else {
>+		/* If this was the last user, we can erase this id */
>+		xa_erase(&devlink->snapshot_ids, id);
>+	}
>+}
>+
> /**
>  *	__devlink_region_snapshot_id_get - get snapshot ID
>  *	@devlink: devlink instance
>  *
>  *	Returns a new snapshot id or a negative error code on failure. Must be
>  *	called while holding the devlink instance lock.
>+ *
>+ *	Snapshot IDs are tracked using an xarray which stores the number of
>+ *	snapshots currently using that index.
>+ *
>+ *	When getting a new id, there are no existing snapshots using it yet,
>+ *	so the count is initialized at zero. Use the associated increment and
>+ *	decrement functions when the number of snapshots using an id changes.
>  */
> static int __devlink_region_snapshot_id_get(struct devlink *devlink)
> {
>+	int err;
>+	u32 id;
>+
> 	lockdep_assert_held(&devlink->lock);
> 
>-	if (devlink->snapshot_id >= INT_MAX)
>-		return -ENOSPC;
>+	/* xa_limit_31b ensures the id will be between 0 and INT_MAX */

Well, currently the snapshot_id is u32. Even the netlink attr is u32.
I believe we should not limit it here.

Please have this as xa_limit_32b.


>+	err = xa_alloc(&devlink->snapshot_ids, &id, xa_mk_value(0),
>+		       xa_limit_31b, GFP_KERNEL);
>+	if (err)
>+		return err;
> 
>-	return ++devlink->snapshot_id;
>+	return id;
> }
> 
> /**
>@@ -3805,6 +3899,7 @@ __devlink_region_snapshot_create(struct devlink_region *region,
> {
> 	struct devlink *devlink = region->devlink;
> 	struct devlink_snapshot *snapshot;
>+	int err;
> 
> 	lockdep_assert_held(&devlink->lock);
> 
>@@ -3819,6 +3914,10 @@ __devlink_region_snapshot_create(struct devlink_region *region,
> 	if (!snapshot)
> 		return -ENOMEM;
> 
>+	err = __devlink_snapshot_id_increment(devlink, snapshot_id);
>+	if (err)
>+		goto err_free_snapshot;
>+
> 	snapshot->id = snapshot_id;
> 	snapshot->region = region;
> 	snapshot->data = data;
>@@ -3829,15 +3928,24 @@ __devlink_region_snapshot_create(struct devlink_region *region,
> 
> 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_NEW);
> 	return 0;
>+
>+err_free_snapshot:
>+	kfree(snapshot);
>+	return err;
> }
> 
> static void devlink_region_snapshot_del(struct devlink_region *region,
> 					struct devlink_snapshot *snapshot)
> {
>+	struct devlink *devlink = region->devlink;
>+
>+	lockdep_assert_held(&devlink->lock);
>+
> 	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_DEL);
> 	region->cur_snapshots--;
> 	list_del(&snapshot->list);
> 	region->ops->destructor(snapshot->data);
>+	__devlink_snapshot_id_decrement(devlink, snapshot->id);
> 	kfree(snapshot);
> }
> 
>@@ -6490,6 +6598,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
> 	if (!devlink)
> 		return NULL;
> 	devlink->ops = ops;
>+	xa_init(&devlink->snapshot_ids);
> 	__devlink_net_set(devlink, &init_net);
> 	INIT_LIST_HEAD(&devlink->port_list);
> 	INIT_LIST_HEAD(&devlink->sb_list);
>@@ -6582,6 +6691,10 @@ EXPORT_SYMBOL_GPL(devlink_reload_disable);
>  */
> void devlink_free(struct devlink *devlink)
> {
>+	mutex_lock(&devlink->lock);
>+	xa_destroy(&devlink->snapshot_ids);
>+	mutex_unlock(&devlink->lock);

I don't follow, why are you locking this?


>+
> 	mutex_destroy(&devlink->reporters_lock);
> 	mutex_destroy(&devlink->lock);
> 	WARN_ON(!list_empty(&devlink->trap_group_list));
>-- 
>2.24.1
>
