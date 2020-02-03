Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF2F15079B
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 14:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgBCNo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 08:44:29 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43830 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgBCNo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 08:44:29 -0500
Received: by mail-wr1-f66.google.com with SMTP id z9so5990610wrs.10
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 05:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HGwFoVvnfG/LS2S/ummY1JJ/J7ajB757QhMHUvk2AR8=;
        b=ng+FOyg5OVLNDLzsm/XcgaPMgBTgRetLxdLOXlgGY4Z6qymRB3k64f2DuQzS/ohUkQ
         W7kOEcnSaYepneWg3r6QfHP7q+JJp2souCRyt6EtmX2jIo2E1fO0/LfJvxVIN5bwHdCA
         FKTDgexOYM7sHOG4Zj8LDflc6PucWJB7N5HWIho9bJZ1IBnoX8pZaVkBeGrApzAW06GR
         DuFdcJLhJX82RPTO/DOwSMHJFK+eEnMMXzFVs8Zke3y3LrDb/9bXZwk3/fhoHQnzy9Yp
         wXhLWn6CQG6+isdWb2gWN8EJiLi0El7FNxXP9SwEtQCVUEDi8b6BzxNUGaq6tiloVfsu
         MC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HGwFoVvnfG/LS2S/ummY1JJ/J7ajB757QhMHUvk2AR8=;
        b=AYie3RRRIyNWdsSAxzoTmMhjkacKnQWYemWjyOXlhetz07k6tPJD5KhczKk456cE+5
         neksbXUq5fp95CI302qN2AwBV2kUdYqaTP15LPchvIi0/pn6kJWOmKaGo9MC6mmf12o9
         97kkxUH96PoQ4cLSYMkULVkXHUN4MZudm+gdG3VO0WzrljlwTekekTF+2kpaL8Dze+Vg
         AwxCtecRWmyJHucG0FGx0XcQwIjJxOJqG53KT13gedzsG8ITXgnkLxBg0ldzWayFhOth
         2zUnSnaS6i045LTaqX8vvIMIJGMLRpJ5emH6PfQGGvc6S/o0c7BNDuk3rpgjs9fzmfnp
         KAmw==
X-Gm-Message-State: APjAAAU8ZF0r0qgMvFlVdAV8rDEaIQspTWUCuFG+LM9ljpiEhEvlGjtN
        jxMqIHN7NuM0B8ifbMYVi6srWg==
X-Google-Smtp-Source: APXvYqyS92Sn3zKHZLBJCqzWdWKitTiKjieEp80pjO4q1755kNdMqPOavCYmJVbMHAm943LqUcBxmg==
X-Received: by 2002:adf:f586:: with SMTP id f6mr15044865wro.46.1580737464771;
        Mon, 03 Feb 2020 05:44:24 -0800 (PST)
Received: from localhost (ip-89-177-6-126.net.upcbroadband.cz. [89.177.6.126])
        by smtp.gmail.com with ESMTPSA id n3sm24926956wrs.8.2020.02.03.05.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 05:44:24 -0800 (PST)
Date:   Mon, 3 Feb 2020 14:44:23 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
Subject: Re: [PATCH 13/15] devlink: support directly reading from region
 memory
Message-ID: <20200203134423.GG2260@nanopsycho>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-14-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130225913.1671982-14-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 30, 2020 at 11:59:08PM CET, jacob.e.keller@intel.com wrote:
>Add a new region operation for directly reading from a region, without
>taking a full snapshot.
>
>Extend the DEVLINK_CMD_REGION_READ to allow directly reading from
>a region, if supported. Instead of reporting a missing snapshot id as
>invalid, check to see if direct reading is implemented for the region.
>If so, use the direct read operation to grab the current contents of the
>region.
>
>This new behavior of DEVLINK_CMD_REGION_READ should be backwards
>compatible. Previously, all kernels rejected such
>a DEVLINK_CMD_REGION_READ with -EINVAL, and will now either accept the
>call or report -EOPNOTSUPP for regions which do not implement direct
>access.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> .../networking/devlink/devlink-region.rst     |  8 ++
> include/net/devlink.h                         |  4 +
> net/core/devlink.c                            | 82 +++++++++++++++++--
> 3 files changed, 87 insertions(+), 7 deletions(-)
>
>diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>index 262249e6c3fc..a543f5ee7a9e 100644
>--- a/Documentation/networking/devlink/devlink-region.rst
>+++ b/Documentation/networking/devlink/devlink-region.rst
>@@ -25,6 +25,10 @@ Regions may optionally support capturing a snapshot on demand via the
> allow requested snapshots must implement the ``.snapshot`` callback for the
> region in its ``devlink_region_ops`` structure.
> 
>+Regions may optionally allow directly reading from their contents without a
>+snapshot. A driver wishing to enable this for a region should implement the
>+``.read`` callback in the ``devlink_region_ops`` structure.
>+
> example usage
> -------------
> 
>@@ -60,6 +64,10 @@ example usage
>             length 16
>     0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
> 
>+    # Read from the region without a snapshot
>+    $ devlink region read pci/0000:00:05.0/fw-health address 16 length 16
>+    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
>+
> As regions are likely very device or driver specific, no generic regions are
> defined. See the driver-specific documentation files for information on the
> specific regions a driver supports.
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 1c3540280396..47ce1b5481de 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -508,6 +508,10 @@ struct devlink_region_ops {
> 			struct netlink_ext_ack *extack,
> 			u8 **data,
> 			devlink_snapshot_data_dest_t **destructor);
>+	int (*read)(struct devlink *devlink,
>+		    u64 curr_offset,
>+		    u32 data_size,
>+		    u8 *data);

Too much wrapping.


> };
> 
> struct devlink_fmsg;
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index b2b855d12a11..5831b7b78915 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -4005,6 +4005,56 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
> 	return err;
> }
> 
>+static int devlink_nl_region_read_direct_fill(struct sk_buff *skb,
>+					      struct devlink *devlink,
>+					      struct devlink_region *region,
>+					      struct nlattr **attrs,
>+					      u64 start_offset,
>+					      u64 end_offset,
>+					      bool dump,
>+					      u64 *new_offset)

Again.


>+{
>+	u64 curr_offset = start_offset;
>+	int err = 0;
>+	u8 *data;
>+
>+	/* Allocate and re-use a single buffer */
>+	data = kzalloc(DEVLINK_REGION_READ_CHUNK_SIZE, GFP_KERNEL);
>+	if (!data)
>+		return -ENOMEM;
>+
>+	*new_offset = start_offset;
>+
>+	if (end_offset > region->size || dump)
>+		end_offset = region->size;
>+
>+	while (curr_offset < end_offset) {
>+		u32 data_size;
>+
>+		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
>+			data_size = end_offset - curr_offset;
>+		else
>+			data_size = DEVLINK_REGION_READ_CHUNK_SIZE;
>+
>+		err = region->ops->read(devlink, curr_offset, data_size, data);

There is a lot of code duplication is this function. Perhap there could
be a cb and cb_priv here to distinguish shapshot and direct read?



>+		if (err)
>+			break;
>+
>+		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
>+							    data, data_size,
>+							    curr_offset);
>+		if (err)
>+			break;
>+
>+		curr_offset += data_size;
>+	}
>+	*new_offset = curr_offset;
>+
>+	kfree(data);
>+
>+	return err;
>+}
>+
> static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 					     struct netlink_callback *cb)
> {
>@@ -4016,6 +4066,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 	const char *region_name;
> 	struct devlink *devlink;
> 	bool dump = true;
>+	bool direct;
> 	void *hdr;
> 	int err;
> 
>@@ -4030,8 +4081,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 
> 	mutex_lock(&devlink->lock);
> 
>-	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
>-	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>+	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
> 		err = -EINVAL;
> 		goto out_unlock;
> 	}
>@@ -4043,6 +4093,17 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 		goto out_unlock;
> 	}
> 
>+	if (attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID])
>+		direct = false;
>+	else
>+		direct = true;

	direct = !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];


>+
>+	/* Region may not support direct read access */
>+	if (direct && !region->ops->read) {

extack msg please.


>+		err = -EOPNOTSUPP;
>+		goto out_unlock;
>+	}
>+
> 	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
> 			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI,
> 			  DEVLINK_CMD_REGION_READ);
>@@ -4076,11 +4137,18 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 		dump = false;
> 	}
> 
>-	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
>-						   region, attrs,
>-						   start_offset,
>-						   end_offset, dump,
>-						   &ret_offset);
>+	if (direct)
>+		err = devlink_nl_region_read_direct_fill(skb, devlink,
>+							 region, attrs,
>+							 start_offset,
>+							 end_offset, dump,
>+							 &ret_offset);
>+	else
>+		err = devlink_nl_region_read_snapshot_fill(skb, devlink,
>+							   region, attrs,
>+							   start_offset,
>+							   end_offset, dump,
>+							   &ret_offset);
> 
> 	if (err && err != -EMSGSIZE)
> 		goto nla_put_failure;
>-- 
>2.25.0.rc1
>
