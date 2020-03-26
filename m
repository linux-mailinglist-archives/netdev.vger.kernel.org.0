Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E92A193B64
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgCZJAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:00:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32871 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgCZJAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:00:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so6763800wrd.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 02:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PEPJgHyv1rvJnNLvQiI6aobst+Z/Dl7dPZHUq2QYiyw=;
        b=AxHztun3D0lloT11fvvoaRErqmzAeD7R3UQHGtRtSd0h0dtpyYYVfD8AJXKMZtZU6n
         D6/PPZ2DYg3pRhZQ4Mi1aOUfZjxXUwo0DQaH++qYKdIF1MTbXVWIlOKZasMUt/JktDRG
         9dae4mBswtqLk7ws/vIkzAMeAVBK+zX+ZfITemgDlTmJqtESDGYPM2SryjjSiE+E/j60
         vwa1NuP7QgAfsv4Q0iiaMh+yiMWN/ZiUHkhp/VUpkXixm0SvYoyFsirzpnGALzZ1hyGT
         1q9Xd352lDAauJaVxFjD4m/9x8/kPgQG5G7OGKdCUjnXqKItpX4DQY7thrYXXBn1yQpe
         ydiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PEPJgHyv1rvJnNLvQiI6aobst+Z/Dl7dPZHUq2QYiyw=;
        b=Fbwr0/iSZBrRKKzA3PwWSFZHem1U1+HJfSvZO7an21wmdsBo+Zujy4JJi+Hjo1kWHa
         cejbJGHl5bYE/vvvd44IF62K32rQc7vQcPG5iG6yWLK0yTvRKxyzHg6BQCaLk1Ql6B7o
         /TYy3tYZQ+BWe/zSP7yqGDswZTZXRBlrI+6/TCN/nbMrGfsFRpd/NXdntoerGETk6MLH
         tMUenkm38ic8jIddVoeDE93KsmUM95n6jJc9cKnL4Jxpnqtpggd1e4iZvDD7hInilvMO
         N3Pk/qRUSShQSVoQEUFx4FCnJa+NwMeifvF9Uh67biyCf0h5XjYmreIAq1usasmDOfgX
         Gvrg==
X-Gm-Message-State: ANhLgQ0XRp7xuN6epTscgIgf8gx0idqxkhw30WiWUixEFzZhB1szKs6R
        UmMNLIqu2N/854yBL/0v4FV8og==
X-Google-Smtp-Source: ADFU+vuwD/pQt3Ei4wZkXMuiILzpfaGjlUbUP5X2RnzBzvmvXNI7XtwlwwOeHJB80/y4ge1SOMsedw==
X-Received: by 2002:adf:f812:: with SMTP id s18mr7525414wrp.380.1585213229209;
        Thu, 26 Mar 2020 02:00:29 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g2sm2733842wrs.42.2020.03.26.02.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 02:00:28 -0700 (PDT)
Date:   Thu, 26 Mar 2020 10:00:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 10/11] netdevsim: support taking immediate snapshot
 via devlink
Message-ID: <20200326090027.GP11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-11-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326035157.2211090-11-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 04:51:56AM CET, jacob.e.keller@intel.com wrote:
>Implement the .snapshot region operation for the dummy data region. This
>enables a region snapshot to be taken upon request via the new
>DEVLINK_CMD_REGION_SNAPSHOT command.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> drivers/net/netdevsim/dev.c                   | 30 ++++++++++++++-----
> .../drivers/net/netdevsim/devlink.sh          | 10 +++++++
> 2 files changed, 33 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>index 53ec891659eb..ffc295c7653e 100644
>--- a/drivers/net/netdevsim/dev.c
>+++ b/drivers/net/netdevsim/dev.c
>@@ -39,24 +39,39 @@ static struct dentry *nsim_dev_ddir;
> 
> #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
> 
>+static int
>+nsim_dev_take_snapshot(struct devlink *devlink, struct netlink_ext_ack *extack,
>+		       u8 **data)
>+{
>+	void *dummy_data;
>+
>+	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
>+	if (!dummy_data)
>+		return -ENOMEM;
>+
>+	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
>+
>+	*data = dummy_data;
>+
>+	return 0;
>+}
>+
> static ssize_t nsim_dev_take_snapshot_write(struct file *file,
> 					    const char __user *data,
> 					    size_t count, loff_t *ppos)
> {
> 	struct nsim_dev *nsim_dev = file->private_data;
> 	struct devlink *devlink = priv_to_devlink(nsim_dev);
>-	void *dummy_data;
>+	u8 *dummy_data;
> 	int err;
> 	u32 id;
> 
>-	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
>-	if (!dummy_data)
>-		return -ENOMEM;
>-
>-	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
>+	err = nsim_dev_take_snapshot(devlink, NULL, &dummy_data);
>+	if (err)
>+		return err;
> 
> 	err = devlink_region_snapshot_id_get(devlink, &id);
>-	if (err)
>+	if (err) {

Hmm, this looks odd. How does the code compile before this patch is
applied?


> 		pr_err("Failed to get snapshot id\n");
> 		return err;
> 	}
>@@ -350,6 +365,7 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
> static const struct devlink_region_ops dummy_region_ops = {
> 	.name = "dummy",
> 	.destructor = &kfree,
>+	.snapshot = nsim_dev_take_snapshot,
> };
> 
> static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
>diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>index 025a84c2ab5a..32cb2a159c70 100755
>--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>@@ -141,6 +141,16 @@ regions_test()
> 
> 	check_region_snapshot_count dummy post-first-delete 2
> 
>+	devlink region new $DL_HANDLE/dummy snapshot 25
>+	check_err $? "Failed to create a new snapshot with id 25"
>+
>+	check_region_snapshot_count dummy post-first-request 3
>+
>+	devlink region del $DL_HANDLE/dummy snapshot 25
>+	check_err $? "Failed to delete snapshot with id 25"
>+
>+	check_region_snapshot_count dummy post-second-delete 2
>+
> 	log_test "regions test"
> }
> 
>-- 
>2.24.1
>
