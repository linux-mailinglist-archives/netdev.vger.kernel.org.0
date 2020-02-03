Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569B2150565
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 12:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgBCLkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 06:40:00 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39012 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgBCLkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 06:40:00 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so17588044wrt.6
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 03:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n8Z5AGzVKjl8rsun90C/AQ3LkxsIVBY1JK5nOtfREqk=;
        b=ThzS5CSeK7dRZIVGSMA2Avc56OzqS1s/bwpz90IB0FkrA+SW9YhdSWcdyyvr+lqzPp
         wZ+xOmijxesnWvbnjexSBNXtJvwmVOfA6BTa0YLWDyunAU/IUmG8z8Loby0NbCQHd4fT
         b0HOWOPFV6CZYSjPz8JZ35Mksg3W4L85cVToybqkCIIpu+Tz8H3QkY92aGp5oFpLBoQk
         6c9ykVq8g5RJWaoTSLsZ0o+U67+kT39EIyxky9T/xUfBJ0u3Sn9UgHc0hWkRqliHgVHa
         KHa8BWngLZLT3Y84o3ama9vd59XiwtddEn3I66wB/CUzgoRtqC7b+gCR794nCBgd7nvP
         uqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n8Z5AGzVKjl8rsun90C/AQ3LkxsIVBY1JK5nOtfREqk=;
        b=uXonV9cxOkC2xo1ipi/RqZ2Fil+4f3pk93lN41aasrpX8bjz1T8GW7jNkUC4yOc6O3
         G9hbmodimi53783HMFMtnNlr77fe6W47KaTg+hVnWP6/gzFwRc6roZ/C6srVNG70h/k/
         9RW6uBE3NQilDq3u/Deayw6d0iKNMXd7HlK7cA2/QKEzGoxMVZ9avgw/I+W3Aq4IG7hx
         ZBSJKLnCVfXpPdxDNXBJ3H37r3Qa2mcLKTt03oZNLcx5Eh47WMikhwLMQGPTryawXkUE
         EwvH5BX07HcNbDbzvTIdp4D3wP3ZIOaIhMwVCrqAusHk/QJrl5CA5lZGLwoPv8VArBav
         SFIQ==
X-Gm-Message-State: APjAAAXlnOC2MS2e7HjA1EZRCF6RVw05KGo7ywwwdYQLiVg4fl1NlOao
        HxY1zqnJWRIoOmCzgcNuHiAyIw==
X-Google-Smtp-Source: APXvYqzMaszwhmr7Bn+XrGfumVQu7apvZHzWwGGtEVX6hd6VFk8Po+xqB3jRuVvQaRgm+jSF5PE7mA==
X-Received: by 2002:a5d:558c:: with SMTP id i12mr14688205wrv.315.1580729998043;
        Mon, 03 Feb 2020 03:39:58 -0800 (PST)
Received: from localhost (ip-89-177-6-126.net.upcbroadband.cz. [89.177.6.126])
        by smtp.gmail.com with ESMTPSA id t131sm23459773wmb.13.2020.02.03.03.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 03:39:57 -0800 (PST)
Date:   Mon, 3 Feb 2020 12:39:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
Subject: Re: [PATCH 02/15] devlink: add functions to take snapshot while
 locked
Message-ID: <20200203113956.GD2260@nanopsycho>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130225913.1671982-3-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 30, 2020 at 11:58:57PM CET, jacob.e.keller@intel.com wrote:
>A future change is going to add a new devlink command to request
>a snapshot on demand. This function will want to call the
>devlink_region_snapshot_id_get and devlink_region_snapshot_create
>functions while already holding the devlink instance lock.
>
>Extract the logic of these two functions into static functions with the
>_locked postfix. Modify the original functions to be implemented in
>terms of the new locked functions.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> net/core/devlink.c | 95 +++++++++++++++++++++++++++++-----------------
> 1 file changed, 61 insertions(+), 34 deletions(-)
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index d1f7bfbf81da..faf4f4c5c539 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -3761,6 +3761,63 @@ static void devlink_nl_region_notify(struct devlink_region *region,
> 	nlmsg_free(msg);
> }
> 
>+/**
>+ *	devlink_region_snapshot_id_get_locked - get snapshot ID
>+ *
>+ *	Returns a new snapshot id. Must be called while holding the
>+ *	devlink instance lock.
>+ */
>+static u32 devlink_region_snapshot_id_get_locked(struct devlink *devlink)

__devlink_region_snapshot_id_get()


>+{
>+	return ++devlink->snapshot_id;
>+}
>+
>+/**
>+ *	devlink_region_snapshot_create_locked - create a new snapshot
>+ *	This will add a new snapshot of a region. The snapshot
>+ *	will be stored on the region struct and can be accessed
>+ *	from devlink. This is useful for future	analyses of snapshots.
>+ *	Multiple snapshots can be created on a region.
>+ *	The @snapshot_id should be obtained using the getter function.
>+ *
>+ *	Must be called only while holding the devlink instance lock.
>+ *
>+ *	@region: devlink region of the snapshot
>+ *	@data: snapshot data
>+ *	@snapshot_id: snapshot id to be created
>+ *	@destructor: pointer to destructor function to free data
>+ */
>+static int
>+devlink_region_snapshot_create_locked(struct devlink_region *region,

__devlink_region_snapshot_create()


>+				      u8 *data, u32 snapshot_id,
>+				      devlink_snapshot_data_dest_t *destructor)
>+{
>+	struct devlink_snapshot *snapshot;
>+
>+	/* check if region can hold one more snapshot */
>+	if (region->cur_snapshots == region->max_snapshots)
>+		return -ENOMEM;
>+
>+	if (devlink_region_snapshot_get_by_id(region, snapshot_id))
>+		return -EEXIST;
>+
>+	snapshot = kzalloc(sizeof(*snapshot), GFP_KERNEL);
>+	if (!snapshot)
>+		return -ENOMEM;
>+
>+	snapshot->id = snapshot_id;
>+	snapshot->region = region;
>+	snapshot->data = data;
>+	snapshot->data_destructor = destructor;
>+
>+	list_add_tail(&snapshot->list, &region->snapshot_list);
>+
>+	region->cur_snapshots++;
>+
>+	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_NEW);
>+	return 0;
>+}
>+
> static void devlink_region_snapshot_del(struct devlink_region *region,
> 					struct devlink_snapshot *snapshot)
> {
>@@ -7611,7 +7668,7 @@ u32 devlink_region_snapshot_id_get(struct devlink *devlink)
> 	u32 id;
> 
> 	mutex_lock(&devlink->lock);
>-	id = ++devlink->snapshot_id;
>+	id = devlink_region_snapshot_id_get_locked(devlink);
> 	mutex_unlock(&devlink->lock);
> 
> 	return id;
>@@ -7622,7 +7679,7 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
>  *	devlink_region_snapshot_create - create a new snapshot
>  *	This will add a new snapshot of a region. The snapshot
>  *	will be stored on the region struct and can be accessed
>- *	from devlink. This is useful for future	analyses of snapshots.
>+ *	from devlink. This is useful for future analyses of snapshots.

What this hunk is about? :O



>  *	Multiple snapshots can be created on a region.
>  *	The @snapshot_id should be obtained using the getter function.
>  *
>@@ -7636,43 +7693,13 @@ int devlink_region_snapshot_create(struct devlink_region *region,
> 				   devlink_snapshot_data_dest_t *data_destructor)
> {
> 	struct devlink *devlink = region->devlink;
>-	struct devlink_snapshot *snapshot;
> 	int err;
> 
> 	mutex_lock(&devlink->lock);
>-
>-	/* check if region can hold one more snapshot */
>-	if (region->cur_snapshots == region->max_snapshots) {
>-		err = -ENOMEM;
>-		goto unlock;
>-	}
>-
>-	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>-		err = -EEXIST;
>-		goto unlock;
>-	}
>-
>-	snapshot = kzalloc(sizeof(*snapshot), GFP_KERNEL);
>-	if (!snapshot) {
>-		err = -ENOMEM;
>-		goto unlock;
>-	}
>-
>-	snapshot->id = snapshot_id;
>-	snapshot->region = region;
>-	snapshot->data = data;
>-	snapshot->data_destructor = data_destructor;
>-
>-	list_add_tail(&snapshot->list, &region->snapshot_list);
>-
>-	region->cur_snapshots++;
>-
>-	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_NEW);
>+	err = devlink_region_snapshot_create_locked(region, data, snapshot_id,
>+						    data_destructor);
> 	mutex_unlock(&devlink->lock);
>-	return 0;
> 
>-unlock:
>-	mutex_unlock(&devlink->lock);
> 	return err;
> }
> EXPORT_SYMBOL_GPL(devlink_region_snapshot_create);
>-- 
>2.25.0.rc1
>
