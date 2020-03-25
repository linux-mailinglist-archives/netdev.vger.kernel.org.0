Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82091192EAB
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgCYQuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:50:51 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40350 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbgCYQuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:50:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id u10so4029498wro.7
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VpeKL6Uz1ntiBRGe1GJP3Zl7Xbvl5YpfKSRL2G9DV0M=;
        b=MSybAzmB7Frc/f3sF8ASPiPNMWtwkSQ49T2/g80hAtzvhTgjQB6zmfXgs9gM0AK5cQ
         QUMnQcX12py8f+efiqPm5q3ebUjAJbX8Z2I4dQye2h4TGpgJcnqsXQD7PQGUawMoQ9CU
         uF5YKgffqRagSSCrBFlnNi84G0tqScRuNRzg0fcwY6lCi0lNxI8rD36Nl3ld0tyhmCx8
         edC4jn6gl1gGANusKy+TkYO5zYLrXbns/itr1ojq5PaFM9lcV92T0pxA4/+o+2LeJ4EV
         KOmz6RuM8TG8PPpaFDd+i2gRURxWlexce8Bs+3gPI7hGV3ELsbXJqpeIRb+wgkakCmcw
         86Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VpeKL6Uz1ntiBRGe1GJP3Zl7Xbvl5YpfKSRL2G9DV0M=;
        b=W+URZU3Mb8DQcPQYwNZ1+0TKgXOYJfwJMTAwvBVegliRj0gBuQYaONYJS6RGZ4uzS/
         eGbmy8EDlLY2XYGSW8zY/hz9bTffEysmcm5FefkYayixbeBfwdnofTugejucILv/vZ4L
         N9aw6003FACYpPpaWEvMUdsbzpKnT4/4wzZnHpb03s+RJH3NyUhf2JBTOLd0S29ZhQc0
         qbFBtZIHmIV6gOOTlB8VY81LQ0S+N9hJTNRDUxxOikVVcstCLOuRlmU9LWuqeCroxNDk
         6+a8pIbvi1NN1w/XP0atpfvB77cmf6O8mqFW4WkQ7gYlkabWGoUfYqGjpVbJhXraB9BJ
         AqmA==
X-Gm-Message-State: ANhLgQ0CaIJJL5SU/vMnqPGFAEWnx/Ohg3AkAOZSMeUZb1Y5s7e/mLWi
        5YkVOKi31KmlsbsG1kNotBJlop2ig4k=
X-Google-Smtp-Source: ADFU+vs3veyxIk8pxCpOBBEecPsbBqF8HUFyFyS0HXk+kc/SOVBJlon5ItNjTcWuW5bo/+YzkbDO0w==
X-Received: by 2002:adf:914e:: with SMTP id j72mr4468003wrj.109.1585155048753;
        Wed, 25 Mar 2020 09:50:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u131sm10425093wmg.41.2020.03.25.09.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 09:50:48 -0700 (PDT)
Date:   Wed, 25 Mar 2020 17:50:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 09/10] netdevsim: support taking immediate snapshot via
 devlink
Message-ID: <20200325165046.GA11304@nanopsycho.orion>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-10-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324223445.2077900-10-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 24, 2020 at 11:34:44PM CET, jacob.e.keller@intel.com wrote:
>Implement the .snapshot region operation for the dummy data region. This
>enables a region snapshot to be taken upon request via the new
>DEVLINK_CMD_REGION_SNAPSHOT command.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> drivers/net/netdevsim/dev.c                   | 27 +++++++++++++++----
> .../drivers/net/netdevsim/devlink.sh          | 15 +++++++++++
> 2 files changed, 37 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>index f9420b77e5fd..876efe71efff 100644
>--- a/drivers/net/netdevsim/dev.c
>+++ b/drivers/net/netdevsim/dev.c
>@@ -39,13 +39,11 @@ static struct dentry *nsim_dev_ddir;
> 
> #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
> 
>-static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>-					    const char __user *data,
>-					    size_t count, loff_t *ppos)
>+static int
>+nsim_dev_take_snapshot(struct devlink *devlink, struct netlink_ext_ack *extack,
>+		       u8 **data)
> {
>-	struct nsim_dev *nsim_dev = file->private_data;
> 	void *dummy_data;
>-	int err, id;
> 
> 	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
> 	if (!dummy_data)
>@@ -53,6 +51,24 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
> 
> 	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
> 
>+	*data = dummy_data;
>+
>+	return 0;
>+}
>+
>+static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>+					    const char __user *data,
>+					    size_t count, loff_t *ppos)
>+{
>+	struct nsim_dev *nsim_dev = file->private_data;
>+	u8 *dummy_data;
>+	int err, id;
>+
>+	err = nsim_dev_take_snapshot(priv_to_devlink(nsim_dev), NULL,
>+				     &dummy_data);
>+	if (err)
>+		return err;
>+
> 	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
> 	if (id < 0) {
> 		pr_err("Failed to get snapshot id\n");
>@@ -346,6 +362,7 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
> static const struct devlink_region_ops dummy_region_ops = {
> 	.name = "dummy",
> 	.destructor = &kfree,
>+	.snapshot = nsim_dev_take_snapshot,
> };
> 
> static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
>diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>index 025a84c2ab5a..f23383fd108c 100755
>--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>@@ -141,6 +141,21 @@ regions_test()
> 
> 	check_region_snapshot_count dummy post-first-delete 2
> 
>+	devlink region new $DL_HANDLE/dummy

Looks like you haven't run the selftest with the current patchset
version.


>+	check_err $? "Failed to create a new a snapshot"
>+
>+	check_region_snapshot_count dummy post-request 3
>+
>+	devlink region new $DL_HANDLE/dummy snapshot 25
>+	check_err $? "Failed to create a new snapshot with id 25"
>+
>+	check_region_snapshot_count dummy post-request 4
>+
>+	devlink region del $DL_HANDLE/dummy snapshot 25
>+	check_err $? "Failed to delete snapshot with id 25"
>+
>+	check_region_snapshot_count dummy post-request 3
>+
> 	log_test "regions test"
> }
> 
>-- 
>2.24.1
>
