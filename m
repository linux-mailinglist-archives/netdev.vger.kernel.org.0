Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2D01BEF6F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 06:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgD3ExS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 00:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3ExS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 00:53:18 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15B4C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:53:17 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z6so341976wml.2
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qYkwTeJeU3eiUIqXBTDPGHir4TZmStX6ukl9C3El6MI=;
        b=MbHq+HmCiMiMtnEB8zQsQ8LadZz/PKiY2vuqiZ5wgHeRsbjdMcv+VatG395BqrobYa
         qHminBZ+R9ZkwRughd8slSecLVw2SPstRkOPz8qVDibVPzg96JTDcrqTr3URND/THdH/
         bnMtvQggnbf0vh81M4wq6R38svINowcmGdqXuuheA1/mlXXBH1RtAVfytA6yK+oO1Mmu
         b0Wc5I066ni1HoId/bsjpCL4Fb1QCnjxXkRR4+3itiqbk43kZIu8OobeLQ9l4kPxDSmV
         mO0SANh/c5ySfLC08k6vo72zAc/y7SfEC3+8GLKZZ+Tq21R6VvTUigix42UfkB/HqT1H
         21bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qYkwTeJeU3eiUIqXBTDPGHir4TZmStX6ukl9C3El6MI=;
        b=XWDT0xOyHC06PROW2xvQltmObXCdMrkywFipiT4s8NBUQWW9T55jCazkXYbf19vz6Y
         3MluBlhPcqtfUkoWSONCnQ0a4qZlIqe7ddMq2aIuCAOe6nUfLKzXUoC6HMy6NpgikO3Q
         44SGgSkFSarZPGvFUoWPyv/PElqg70LZt3RDoHqoU/1aKJaeWACjnDSleFcL4VmmX6QV
         haM9SEA7CsY0A0ebIs+P/GoWOFaUwMe4bfHOee4akAPlm/hwFoDDJf4L9VDEyCGApqT9
         rC/V8VWbZMss2OpnyQUVOgvxCytEG8cOvE7irIkANqSlBfiYPnC9Qyo4XtLnf97Z5KT4
         Um4Q==
X-Gm-Message-State: AGi0PuZbPlvG43ImUJS+BDwX673cc4s352biHgfeKYtEeBLC9KLpKRQu
        0WTWcCa0HhU7g5gWR4Y1300hxw==
X-Google-Smtp-Source: APiQypLGOcXdO+yZBKhd7RR7+QM5Ihwv31UoJX4lX7zHANGSXhshoxvEdU/sHhqgQy7MlcklJ5pfWQ==
X-Received: by 2002:a1c:b445:: with SMTP id d66mr764232wmf.187.1588222396293;
        Wed, 29 Apr 2020 21:53:16 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r5sm353759wrt.20.2020.04.29.21.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 21:53:15 -0700 (PDT)
Date:   Thu, 30 Apr 2020 06:53:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2] devlink: let kernel allocate region snapshot
 id
Message-ID: <20200430045315.GF6581@nanopsycho.orion>
References: <20200429233813.1137428-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429233813.1137428-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Apr 30, 2020 at 01:38:13AM CEST, kuba@kernel.org wrote:
>Currently users have to choose a free snapshot id before
>calling DEVLINK_CMD_REGION_NEW. This is potentially racy
>and inconvenient.
>
>Make the DEVLINK_ATTR_REGION_SNAPSHOT_ID optional and try
>to allocate id automatically. Send a message back to the
>caller with the snapshot info.
>
>The message carrying id gets sent immediately, but the
>allocation is only valid if the entire operation succeeded.
>This makes life easier, as sending the notification itself
>may fail.
>
>Example use:
>$ devlink region new netdevsim/netdevsim1/dummy
>netdevsim/netdevsim1/dummy: snapshot 1
>
>$ id=$(devlink -j region new netdevsim/netdevsim1/dummy | \
>       jq '.[][][][]')
>$ devlink region dump netdevsim/netdevsim1/dummy snapshot $id
>[...]
>$ devlink region del netdevsim/netdevsim1/dummy snapshot $id
>
>v2:
> - don't wrap the line containing extack;
> - add a few sentences to the docs.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> .../networking/devlink/devlink-region.rst     | 10 ++-
> net/core/devlink.c                            | 83 ++++++++++++++++---
> .../drivers/net/netdevsim/devlink.sh          | 13 +++
> 3 files changed, 91 insertions(+), 15 deletions(-)
>
>diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>index 04e04d1ff627..b163d09a3d0d 100644
>--- a/Documentation/networking/devlink/devlink-region.rst
>+++ b/Documentation/networking/devlink/devlink-region.rst
>@@ -23,7 +23,12 @@ states, but see also :doc:`devlink-health`
> Regions may optionally support capturing a snapshot on demand via the
> ``DEVLINK_CMD_REGION_NEW`` netlink message. A driver wishing to allow
> requested snapshots must implement the ``.snapshot`` callback for the region
>-in its ``devlink_region_ops`` structure.
>+in its ``devlink_region_ops`` structure. If snapshot id is not set in
>+the ``DEVLINK_CMD_REGION_NEW`` request kernel will allocate one and send
>+the snapshot information to user space. Note that receiving the snapshot
>+information does not guarantee that the snapshot creation completed
>+successfully, user space must check the status of the operation before
>+proceeding.
> 
> example usage
> -------------
>@@ -45,7 +50,8 @@ example usage
>     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
> 
>     # Request an immediate snapshot, if supported by the region
>-    $ devlink region new pci/0000:00:05.0/cr-space snapshot 5
>+    $ devlink region new pci/0000:00:05.0/cr-space
>+    pci/0000:00:05.0/cr-space: snapshot 5
> 
>     # Dump a snapshot:
>     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 1ec2e9fd8898..82703be1032e 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -4065,10 +4065,64 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
> 	return 0;
> }
> 
>+static int
>+devlink_nl_alloc_snapshot_id(struct devlink *devlink, struct genl_info *info,
>+			     struct devlink_region *region, u32 *snapshot_id)
>+{
>+	struct sk_buff *msg;
>+	void *hdr;
>+	int err;
>+
>+	err = __devlink_region_snapshot_id_get(devlink, snapshot_id);
>+	if (err) {
>+		NL_SET_ERR_MSG_MOD(info->extack, "Failed to allocate a new snapshot id");
>+		return err;
>+	}
>+
>+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>+	if (!msg) {
>+		err = -ENOMEM;
>+		goto err_msg_alloc;
>+	}
>+
>+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
>+			  &devlink_nl_family, 0, DEVLINK_CMD_REGION_NEW);
>+	if (!hdr) {
>+		err = -EMSGSIZE;
>+		goto err_put_failure;
>+	}
>+	err = devlink_nl_put_handle(msg, devlink);
>+	if (err)
>+		goto err_attr_failure;
>+	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->ops->name);
>+	if (err)
>+		goto err_attr_failure;
>+	err = nla_put_u32(msg, DEVLINK_ATTR_REGION_SNAPSHOT_ID, *snapshot_id);
>+	if (err)
>+		goto err_attr_failure;
>+	genlmsg_end(msg, hdr);
>+
>+	err = genlmsg_reply(msg, info);
>+	if (err)
>+		goto err_reply;
>+
>+	return 0;
>+
>+err_attr_failure:
>+	genlmsg_cancel(msg, hdr);
>+err_put_failure:
>+	nlmsg_free(msg);
>+err_msg_alloc:
>+err_reply:
>+	__devlink_snapshot_id_decrement(devlink, *snapshot_id);
>+	return err;
>+}
>+
> static int
> devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
> {
> 	struct devlink *devlink = info->user_ptr[0];
>+	struct nlattr *snapshot_id_attr;
> 	struct devlink_region *region;
> 	const char *region_name;
> 	u32 snapshot_id;
>@@ -4080,11 +4134,6 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
> 		return -EINVAL;
> 	}
> 
>-	if (!info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>-		NL_SET_ERR_MSG_MOD(info->extack, "No snapshot id provided");
>-		return -EINVAL;
>-	}
>-
> 	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
> 	region = devlink_region_get_by_name(devlink, region_name);
> 	if (!region) {
>@@ -4102,16 +4151,24 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
> 		return -ENOSPC;
> 	}
> 
>-	snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>+	snapshot_id_attr = info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
>+	if (snapshot_id_attr) {
>+		snapshot_id = nla_get_u32(snapshot_id_attr);
> 
>-	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>-		NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
>-		return -EEXIST;
>-	}
>+		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>+			NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
>+			return -EEXIST;
>+		}
> 
>-	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>-	if (err)
>-		return err;
>+		err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>+		if (err)
>+			return err;
>+	} else {
>+		err = devlink_nl_alloc_snapshot_id(devlink, info,
>+						   region, &snapshot_id);
>+		if (err)
>+			return err;
>+	}

Could you please send the snapshot id just before you return 0 in this
function, as you offered in v1? I think it would be great to do it like
that.

Thanks!


> 
> 	err = region->ops->snapshot(devlink, info->extack, &data);
> 	if (err)
>diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>index 9f9741444549..ad539eccddcb 100755
>--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>@@ -151,6 +151,19 @@ regions_test()
> 
> 	check_region_snapshot_count dummy post-second-delete 2
> 
>+	sid=$(devlink -j region new $DL_HANDLE/dummy | jq '.[][][][]')
>+	check_err $? "Failed to create a new snapshot with id allocated by the kernel"
>+
>+	check_region_snapshot_count dummy post-first-request 3
>+
>+	devlink region dump $DL_HANDLE/dummy snapshot $sid >> /dev/null
>+	check_err $? "Failed to dump a snapshot with id allocated by the kernel"
>+
>+	devlink region del $DL_HANDLE/dummy snapshot $sid
>+	check_err $? "Failed to delete snapshot with id allocated by the kernel"
>+
>+	check_region_snapshot_count dummy post-first-request 2
>+
> 	log_test "regions test"
> }
> 
>-- 
>2.25.4
>
