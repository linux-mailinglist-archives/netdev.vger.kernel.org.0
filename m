Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97793176144
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 18:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgCBRlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 12:41:14 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37825 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbgCBRlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 12:41:13 -0500
Received: by mail-wm1-f67.google.com with SMTP id a141so186102wme.2
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 09:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qOPJy9MAf8v3I5g5ITEUZ6lFntRGVMdqw21SX6rA4Wk=;
        b=HafbtagQL9KWzXZNj5i1j6A0ax036gMUoqtIM61PN4rXKOKQe5yugHyUOk22kNSfzf
         EiRpUU3jmZu9U3XChpNe6wpMvvuFGD5pACvFnFzNKu1gl2ZFbWxKu15Do45+jOL8YVF5
         9pzNDwKMQNq7NglWPlP59CSEo81j1gXgixXal35QZdGSIcbPSupfs5v7xTHCQWoFJ4uA
         rZi3d9zmRiHAGOnL7I9S1IwmBIgJB1O1I+e+dYpmfBOUAkJlv8qPXZaXodb+1OKgD6/3
         rO0rlOU3V2yWdamG0jS7giAK1V63oNY/ZhKiou5wFEivbMo/1HLTlZOv4Z8UuHxL24cK
         B1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qOPJy9MAf8v3I5g5ITEUZ6lFntRGVMdqw21SX6rA4Wk=;
        b=ZOzEOiH6aKVLTBOPx97Pv4jRhEykstV8XMO8GcPptSuPW0FAYXS9DwV+q2MifFv1Cm
         3ai4hNemWzbbrbsXjjWkQUWjwEkEjH690VgXdYIIY71lFYE78KtkmWxCwclw1qCuXDEk
         AF7pre3B/tQy9QmxcUeuL7bKkl+d7uQ3l+GJQ6txzUzjKJBNZcr79zKY5RwJS+wmyJ3J
         dy1trUFLS+txY7unO92KrQtCYWdHuIJogqIVdw0R5GA+0dPYA44kju6R21IgJjFzNMMr
         AWNBrpjd62XeAKXyhCPM1H/DOtGM+w4VAI2bhPjXDF5PEhzTocUQH1X0Ong7XMeiUv34
         UyLg==
X-Gm-Message-State: ANhLgQ0r3et7EbGaMEzbeTp3K2ZiYEwKVcG8DZRvK5sAhKqNZyypAWbe
        iO9CpwlSmT4Xxq6gQs9cS5t8xg==
X-Google-Smtp-Source: ADFU+vtdrxY6+6O+m4sGs+TrMqfJMSIXTEMydHxoPHD1bPS4bsVC08v+PolTSmq+8fau+vimbPGlsg==
X-Received: by 2002:a1c:2786:: with SMTP id n128mr165937wmn.47.1583170871533;
        Mon, 02 Mar 2020 09:41:11 -0800 (PST)
Received: from localhost (78-136-133-133.client.nordic.tel. [78.136.133.133])
        by smtp.gmail.com with ESMTPSA id f15sm11378553wru.83.2020.03.02.09.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 09:41:11 -0800 (PST)
Date:   Mon, 2 Mar 2020 18:41:06 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200302174106.GC2168@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-15-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214232223.3442651-15-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 15, 2020 at 12:22:13AM CET, jacob.e.keller@intel.com wrote:
>Implement support for the DEVLINK_CMD_REGION_NEW command for creating
>snapshots. This new command parallels the existing
>DEVLINK_CMD_REGION_DEL.
>
>In order for DEVLINK_CMD_REGION_NEW to work for a region, the new
>".snapshot" operation must be implemented in the region's ops structure.
>
>The desired snapshot id may be provided. If the requested id is already
>in use, an error will be reported. If no id is provided one will be
>selected in the same way as a triggered snapshot.
>
>In either case, the reference count for that id will be incremented
>in the snapshot IDR.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> .../networking/devlink/devlink-region.rst     | 12 +++-
> include/net/devlink.h                         |  6 ++
> net/core/devlink.c                            | 72 +++++++++++++++++++
> 3 files changed, 88 insertions(+), 2 deletions(-)
>
>diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>index 1a7683e7acb2..a24faf2b6b7a 100644
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
>@@ -40,8 +45,11 @@ example usage
>     # Delete a snapshot using:
>     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
> 
>-    # Trigger (request) a snapshot be taken:
>-    $ devlink region trigger pci/0000:00:05.0/cr-space

Odd. It is actually "devlink region dump". There is no trigger.


>+    # Request an immediate snapshot, if supported by the region
>+    $ devlink region new pci/0000:00:05.0/cr-space

Without ID? I would personally require snapshot id always. Without it,
it looks like you are creating region.


>+
>+    # Request an immediate snapshot with a specific id
>+    $ devlink region new pci/0000:00:05.0/cr-space snapshot 5
> 
>     # Dump a snapshot:
>     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 3a5ff6bea143..3cd0ff2040b2 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -498,10 +498,16 @@ struct devlink_info_req;
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

Please have the same type here and for destructor. "u8 *" I guess.


> };
> 
> struct devlink_fmsg;
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 9571063846cc..b5d1b21e5178 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -4045,6 +4045,71 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
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
>+	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
>+	region = devlink_region_get_by_name(devlink, region_name);
>+	if (!region) {
>+		NL_SET_ERR_MSG_MOD(info->extack,

In devlink.c, please don't wrap here.


>+				   "The requested region does not exist");
>+		return -EINVAL;
>+	}
>+
>+	if (!region->ops->snapshot) {
>+		NL_SET_ERR_MSG_MOD(info->extack,
>+				   "The requested region does not support taking an immediate snapshot");
>+		return -EOPNOTSUPP;
>+	}
>+
>+	if (region->cur_snapshots == region->max_snapshots) {
>+		NL_SET_ERR_MSG_MOD(info->extack,
>+				   "The region has reached the maximum number of stored snapshots");
>+		return -ENOMEM;
>+	}
>+
>+	if (info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>+		/* __devlink_region_snapshot_create will take care of
>+		 * inserting the snapshot id into the IDR if necessary.
>+		 */
>+		snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>+
>+		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>+			NL_SET_ERR_MSG_MOD(info->extack,
>+					   "The requested snapshot id is already in use");
>+			return -EEXIST;
>+		}
>+	} else {
>+		snapshot_id = __devlink_region_snapshot_id_get(devlink);
>+	}
>+
>+	err = region->ops->snapshot(devlink, info->extack, &data);

Don't you put the "id"? Looks like a leak.


>+	if (err)
>+		return err;
>+
>+	err = __devlink_region_snapshot_create(region, data, snapshot_id);
>+	if (err)
>+		goto err_free_snapshot_data;
>+
>+	return 0;
>+
>+err_free_snapshot_data:
>+	region->ops->destructor(data);
>+	return err;
>+}
>+
> static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
> 						 struct devlink *devlink,
> 						 u8 *chunk, u32 chunk_size,
>@@ -6358,6 +6423,13 @@ static const struct genl_ops devlink_nl_ops[] = {
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
>2.25.0.368.g28a2d05eebfb
>
