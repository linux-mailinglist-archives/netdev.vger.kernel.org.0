Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D3C192E94
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgCYQq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:46:27 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44302 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgCYQq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:46:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id m17so3972194wrw.11
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2f4AbTH2eYllWVT08ck6WVI5RyavGyA5H6U+VR6ZbzM=;
        b=Q2I5YmBS2q/6lz4t9an6ZLdRvNrb1E34HYuxOVe530OrP4qqj0g/J2HBds0zRZ4kVY
         O4RjvOs1nnpVSfWKOs96NUyLXrlz6VTKOyTLPKHRgL/09LBHxMIDdeTSU117F5SFnjDX
         EAaOe+w56hQTT00LmRNWNvOMwTmJ88WFhiln2yurknlW1UD0zqLXP6fZMp1j+w/7MTpn
         hcomlsXTDD1NADyJHUuBuGWxreO05HX0MNa4uJobqeSsseKhAuiWoPRsH1kgT9ECOa0w
         olxx5xZkLn4b6h9diHaXGgQOPDEXVjdtVBzb/nu4YHGnRffSen/NmcWakHDweMwS/O04
         KUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2f4AbTH2eYllWVT08ck6WVI5RyavGyA5H6U+VR6ZbzM=;
        b=In73n2PjS+SxUvB0sEO2bhafdXOxICdmUH6iWKQ9i4zYJvPwfLoyUQr+1Lw5QJM6Q3
         H/zovgK/7Hp85ds8bbUbOhLZ2EsrvUyMD8z4hIEfJNWu9a5DuXLSFMme56o9uTZ2S2ya
         jzGq6vncVBSZ0Q2OM2Zn5wM9Auja0QV9N8zMdzO6Yp84lOwLKP/WsKaeprZB5Pf68prB
         62TwE37ROaFtZsZMI8By3eOyqNVcvsBXqXMDDKhehf51fYY6WhuA79l2K0nw89yUvv6M
         JHIrs5Fl+6x82UEZcty4oxKVG+gW4u3g6PWvEolEPoVhygBz9UJ8AbxXlTEJYoy5pcUx
         xD/Q==
X-Gm-Message-State: ANhLgQ00uUaqojYAAPAQjiYzS9y5klaEM7TaiCbVxEMwP5C0MfRgnEXr
        LwW25d41mpsvES4l9CF7rxvVj0n/GXc=
X-Google-Smtp-Source: ADFU+vu3jb0t/vqQqk48JEh2eII79SkBu+HYoIDPNENetPyzwQOfeRHhq7C9XfuABW+GmIPH9b4w/w==
X-Received: by 2002:adf:f3c5:: with SMTP id g5mr4418392wrp.230.1585154784172;
        Wed, 25 Mar 2020 09:46:24 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u13sm18399427wru.88.2020.03.25.09.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 09:46:23 -0700 (PDT)
Date:   Wed, 25 Mar 2020 17:46:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 08/10] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200325164622.GZ11304@nanopsycho.orion>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-9-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324223445.2077900-9-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 24, 2020 at 11:34:43PM CET, jacob.e.keller@intel.com wrote:
>Implement support for the DEVLINK_CMD_REGION_NEW command for creating
>snapshots. This new command parallels the existing
>DEVLINK_CMD_REGION_DEL.
>
>In order for DEVLINK_CMD_REGION_NEW to work for a region, the new
>".snapshot" operation must be implemented in the region's ops structure.
>
>The desired snapshot id must be provided. This helps avoid confusion on
>the purpose of DEVLINK_CMD_REGION_NEW, and keeps the API simpler.
>
>The requested id will be inserted into the xarray tracking the number of
>snapshots using each id. If this id is already used by another snapshot
>on any region, an error will be returned.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> .../networking/devlink/devlink-region.rst     |   8 ++
> include/net/devlink.h                         |   6 +
> net/core/devlink.c                            | 103 ++++++++++++++++++
> 3 files changed, 117 insertions(+)
>
>diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>index 8b46e8591fe0..9d2d4c95a5c4 100644
>--- a/Documentation/networking/devlink/devlink-region.rst
>+++ b/Documentation/networking/devlink/devlink-region.rst
>@@ -20,6 +20,11 @@ address regions that are otherwise inaccessible to the user.
> Regions may also be used to provide an additional way to debug complex error
> states, but see also :doc:`devlink-health`
> 
>+Regions may optionally support capturing a snapshot on demand via the
>+``DEVLINK_CMD_REGION_NEW`` netlink message. A driver wishing to allow
>+requested snapshots must implement the ``.snapshot`` callback for the region
>+in its ``devlink_region_ops`` structure.
>+
> example usage
> -------------
> 
>@@ -40,6 +45,9 @@ example usage
>     # Delete a snapshot using:
>     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
> 
>+    # Request an immediate snapshot, if supported by the region
>+    $ devlink region new pci/0000:00:05.0/cr-space snapshot 5
>+
>     # Dump a snapshot:
>     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
>     0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 30306e62fe73..ae894e073050 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -502,10 +502,16 @@ struct devlink_info_req;
>  * struct devlink_region_ops - Region operations
>  * @name: region name
>  * @destructor: callback used to free snapshot memory when deleting
>+ * @snapshot: callback to request an immediate snapshot. On success,
>+ *            the data variable must be updated to point to the snapshot data.
>+ *            The function will be called while the devlink instance lock is
>+ *            held.
>  */
> struct devlink_region_ops {
> 	const char *name;
> 	void (*destructor)(const void *data);
>+	int (*snapshot)(struct devlink *devlink, struct netlink_ext_ack *extack,
>+			u8 **data);
> };
> 
> struct devlink_fmsg;
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index b3698228a6ed..16129ec27913 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -3849,6 +3849,35 @@ static void __devlink_snapshot_id_decrement(struct devlink *devlink, u32 id)
> 	}
> }
> 
>+/**
>+ *	__devlink_snapshot_id_insert - Insert a specific snapshot ID
>+ *	@devlink: devlink instance
>+ *	@id: the snapshot id
>+ *
>+ *	Mark the given snapshot id as used by inserting a zero value into the
>+ *	snapshot xarray.
>+ *
>+ *	Returns zero on success, or an error code if the snapshot id could not
>+ *	be inserted.
>+ */
>+static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
>+{
>+	int err;
>+
>+	lockdep_assert_held(&devlink->lock);
>+
>+	/* Check to make sure it's empty first */
>+	if (xa_load(&devlink->snapshot_ids, id))

How this can happen? The entry was just allocated. WARN_ON.


>+		return -EBUSY;
>+
>+	err = xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(0),
>+			      GFP_KERNEL));

Just return and avoid err variable.


>+	if (err)
>+		return err;
>+
>+	return 0;
>+}
>+
> /**
>  *	__devlink_region_snapshot_id_get - get snapshot ID
>  *	@devlink: devlink instance
>@@ -4048,6 +4077,73 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
> 	return 0;
> }
> 
>+static int
>+devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
>+{
>+	struct devlink *devlink = info->user_ptr[0];
>+	struct devlink_region *region;
>+	const char *region_name;
>+	u32 snapshot_id;
>+	u8 *data;
>+	int err;
>+
>+	if (!info->attrs[DEVLINK_ATTR_REGION_NAME]) {
>+		NL_SET_ERR_MSG_MOD(info->extack, "No region name provided");
>+		return -EINVAL;
>+	}
>+
>+	if (!info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>+		NL_SET_ERR_MSG_MOD(info->extack, "No snapshot id provided");
>+		return -EINVAL;
>+	}
>+
>+	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
>+	region = devlink_region_get_by_name(devlink, region_name);
>+	if (!region) {
>+		NL_SET_ERR_MSG_MOD(info->extack, "The requested region does not exist");
>+		return -EINVAL;
>+	}
>+
>+	if (!region->ops->snapshot) {
>+		NL_SET_ERR_MSG_MOD(info->extack, "The requested region does not support taking an immediate snapshot");
>+		return -EOPNOTSUPP;
>+	}
>+
>+	if (region->cur_snapshots == region->max_snapshots) {
>+		NL_SET_ERR_MSG_MOD(info->extack, "The region has reached the maximum number of stored snapshots");
>+		return -ENOMEM;

Maybe ENOBUFS or ENOSPC? ENOMEM seems odd as it is related to memory
allocation fails which this is not.


>+	}
>+
>+	snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>+
>+	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>+		NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
>+		return -EEXIST;
>+	}
>+
>+	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>+	if (err) {
>+		NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in used");

Different message would be appropriate.


>+		return err;
>+	}
>+
>+	err = region->ops->snapshot(devlink, info->extack, &data);
>+	if (err)
>+		goto err_decrement_snapshot_count;
>+
>+	err = __devlink_region_snapshot_create(region, data, snapshot_id);
>+	if (err)
>+		goto err_free_snapshot_data;
>+
>+	return 0;
>+
>+err_decrement_snapshot_count:
>+	__devlink_snapshot_id_decrement(devlink, snapshot_id);
>+err_free_snapshot_data:

In devlink the error labers are named according to actions that failed.
Please align.


>+	region->ops->destructor(data);
>+	return err;
>+}
>+
> static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
> 						 struct devlink *devlink,
> 						 u8 *chunk, u32 chunk_size,
>@@ -6455,6 +6551,13 @@ static const struct genl_ops devlink_nl_ops[] = {
> 		.flags = GENL_ADMIN_PERM,
> 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
> 	},
>+	{
>+		.cmd = DEVLINK_CMD_REGION_NEW,
>+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>+		.doit = devlink_nl_cmd_region_new,
>+		.flags = GENL_ADMIN_PERM,
>+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
>+	},
> 	{
> 		.cmd = DEVLINK_CMD_REGION_DEL,
> 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>-- 
>2.24.1
>
