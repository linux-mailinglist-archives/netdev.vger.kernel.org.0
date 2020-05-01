Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FAE1C101A
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgEAI7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgEAI7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:59:11 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF6AC035495
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:59:10 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r26so5658195wmh.0
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WoSC48QlMioX73bdbZbMrdBzP8weaReyzyO3Xm3Ycyo=;
        b=iH83Ef8GERtwG/294wLxN7eWweikli7lHWN7jtpPv3NLOs5xru7TR0iE1tsSt7d8eA
         PT48cHh0xP1GvejIsgApiw0A9U4kEXQsJd3bhqlyHWNP0poIX+CQ3yVrPFkRj+pdWa5F
         YyBSpaiBZlPP5Zb+Um7QnGkjEssbALGB1yKwXjc34ARXoDfyZQdwfjYfNUbiioJTmNJX
         YmiNefcKbw1B2KDVzwOFR/bgWi6FhyaObXHhwN2b5IC5haMGsFsNvMUJwGXot6Kh9N9Z
         FWGj5pcMwFvzjFh7gI/YrbcvMh03wYGgazWsifXnfzIMhlkRXUiF/K/QlRHHboW/UVD6
         CPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WoSC48QlMioX73bdbZbMrdBzP8weaReyzyO3Xm3Ycyo=;
        b=W4QkWIhx1yFQap+LRlWpq3vqrPQOkQz/pOOdhJuNXZ9Gi+f89Q8CYYLThAa9kNXabB
         rk2Dpv+y5jnhLu1Uuoaz9+kOIGDftnRqu7Slf3DVBt1dDxm68aBQobpd3QuYIIUTFbyH
         xOemiYiZm1ZsxcivcZ1SnPPGq+XvYauYpSN7oEZLQeLNYDJpyTlZL5jqwawScV+PtC4n
         eX1I/Opj8/4TVobF4BtdC+mYmXH3E1e0SQH9BG6T6efn0hSiGoEVorgsfiaMDRNtWbDq
         r961Hg5oc1H75LGq+0x2NI2gregPDZvqR1MLpymiX2ekr90DMBbQC2vOaRjb/f9lCs8s
         WTug==
X-Gm-Message-State: AGi0PuZvuPFg5kqw3ubDpMkIpGvqpO8jhyzo92bBHINgj8uIcAWf1T2u
        YsqahuYsvhWOiDFNlsCcxw/Edg==
X-Google-Smtp-Source: APiQypJmSsRXpVawuH0NPOqkY9IprtiUkkE5EscRW5oan/w9VRcDZqJuedYiodaLtzQGcd1SB0Trqg==
X-Received: by 2002:a7b:cf27:: with SMTP id m7mr3124260wmg.183.1588323549366;
        Fri, 01 May 2020 01:59:09 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id m1sm3280378wro.64.2020.05.01.01.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:59:08 -0700 (PDT)
Date:   Fri, 1 May 2020 10:59:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v3 2/3] devlink: let kernel allocate region
 snapshot id
Message-ID: <20200501085908.GH6581@nanopsycho.orion>
References: <20200430175759.1301789-1-kuba@kernel.org>
 <20200430175759.1301789-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430175759.1301789-3-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Apr 30, 2020 at 07:57:57PM CEST, kuba@kernel.org wrote:
>Currently users have to choose a free snapshot id before
>calling DEVLINK_CMD_REGION_NEW. This is potentially racy
>and inconvenient.
>
>Make the DEVLINK_ATTR_REGION_SNAPSHOT_ID optional and try
>to allocate id automatically. Send a message back to the
>caller with the snapshot info.
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
>v3:
> - send the notification only once snapshot creation completed.
>v2:
> - don't wrap the line containing extack;
> - add a few sentences to the docs.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> .../networking/devlink/devlink-region.rst     |  7 +-
> net/core/devlink.c                            | 69 +++++++++++++++----
> .../drivers/net/netdevsim/devlink.sh          | 13 ++++
> 3 files changed, 74 insertions(+), 15 deletions(-)
>
>diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>index 04e04d1ff627..daf35427fce1 100644
>--- a/Documentation/networking/devlink/devlink-region.rst
>+++ b/Documentation/networking/devlink/devlink-region.rst
>@@ -23,7 +23,9 @@ states, but see also :doc:`devlink-health`
> Regions may optionally support capturing a snapshot on demand via the
> ``DEVLINK_CMD_REGION_NEW`` netlink message. A driver wishing to allow
> requested snapshots must implement the ``.snapshot`` callback for the region
>-in its ``devlink_region_ops`` structure.
>+in its ``devlink_region_ops`` structure. If snapshot id is not set in
>+the ``DEVLINK_CMD_REGION_NEW`` request kernel will allocate one and send
>+the snapshot information to user space.
> 
> example usage
> -------------
>@@ -45,7 +47,8 @@ example usage
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
>index 92afb85bad89..4df947fb90d9 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -4082,10 +4082,41 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
> 	return 0;
> }
> 
>+static int
>+devlink_nl_snapshot_id_notify(struct devlink *devlink, struct genl_info *info,
>+			      struct devlink_region *region, u32 snapshot_id)
>+{
>+	struct devlink_snapshot *snapshot;
>+	struct sk_buff *msg;
>+	int err;
>+
>+	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
>+	if (WARN_ON(!snapshot))
>+		return -EINVAL;
>+
>+	msg = devlink_nl_region_notify_build(region, snapshot,
>+					     DEVLINK_CMD_REGION_NEW,
>+					     info->snd_portid, info->snd_seq);
>+	err = PTR_ERR_OR_ZERO(msg);
>+	if (err)
>+		goto err_notify;
>+
>+	err = genlmsg_reply(msg, info);
>+	if (err)
>+		goto err_notify;
>+
>+	return 0;
>+
>+err_notify:
>+	devlink_region_snapshot_del(region, snapshot);

This is odd to have "del" in "notify helper". Could you please move the
"del" call to the caller so "create" and "del" are called from the same
function? I mean, that is the usual way to do cleanup, I don't see why
to do it differently here.

Otherwise the patch looks fine. Thanks!


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
>@@ -4097,11 +4128,6 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
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
>@@ -4119,16 +4145,25 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
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
>+		err = __devlink_region_snapshot_id_get(devlink, &snapshot_id);
>+		if (err) {
>+			NL_SET_ERR_MSG_MOD(info->extack, "Failed to allocate a new snapshot id");
>+			return err;
>+		}
>+	}
> 
> 	err = region->ops->snapshot(devlink, info->extack, &data);
> 	if (err)
>@@ -4138,6 +4173,14 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
> 	if (err)
> 		goto err_snapshot_create;
> 
>+	if (!snapshot_id_attr) {
>+		/* destroys the snapshot on failure */
>+		err = devlink_nl_snapshot_id_notify(devlink, info,
>+						    region, snapshot_id);
>+		if (err)
>+			return err;
>+	}
>+
> 	return 0;
> 
> err_snapshot_create:
>diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>index 1d15afd62941..de4b32fc4223 100755
>--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>@@ -166,6 +166,19 @@ regions_test()
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
