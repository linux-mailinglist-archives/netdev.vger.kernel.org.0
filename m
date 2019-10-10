Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90D6D2249
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 10:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733102AbfJJIJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 04:09:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36080 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732947AbfJJIJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 04:09:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id y19so6632273wrd.3
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 01:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SjMRbyYa9rj9p4UNxBNyHnO+PKKPdWRw8jfjsKYVM3Q=;
        b=141NdkG1rBRgLuNeiPsnZiZM/yGNDROb7mUKoDq+5TyCQ8/f5gSMGs8lgoWNpAky8z
         sWL3sFZnjKLrClPBpQBbJfg/DN9DTnY8QU5cm/7Y8rqp8TYvBDHJjIyoINlGVShScT9o
         WbOdlL8IPb7fqyFMSyGSN6qPXjoJLO4yXSEdQgx/Vw6Bzg859lp96AUIowfOT/jkWjOM
         R7b2JO/eQoGlF0U7EBd8Ce2LAsjxiBSTUyD7mDfcPdc6+4NMsZRRvwZJMEGwW1YKY62P
         jbQsS16HmeJljhh5ugR8NzQzRSQ8VzM8thx+gE1l2ikqlm385ffe6tJO6YQ2w8MFr7Pg
         IVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SjMRbyYa9rj9p4UNxBNyHnO+PKKPdWRw8jfjsKYVM3Q=;
        b=sReBal4hpQl5YTdPN/5Qe8Ri9Cy7YYLMmw4q+4AnSU9hu9kMdwYEycsJxu/hO8P+NO
         VDzRDUbUC1sfCZ6pOmM9k5iyubNNi/XjkOUYa8Nmql1xwj0s1QtMU/fZe5cHW9Y8kqFe
         oQNeRhMqGgHnnMmnbuP4fjCgI5QDzXN+EvSu0hBzMNQ8v/7JlCMLiO4GTxdmcH4SM+wV
         E0FgkPaTDaB2QAqfa573iKuZdaj5AaQ0VfM7zkANNXteBTKwgHrCUn9Tc/SVXu/QViPa
         VR+q6BXvVW5f3uprpwT6ReGd+y6LXjxNB5sPtxysYQl5sk3ssnvoelka3jUaa2pcVPx/
         6LbQ==
X-Gm-Message-State: APjAAAWom5Xfi9KKrh7ATN5MQN/ZmtFdgUtz49hAH+ETxsnZgdDTt5iT
        expJ/qCudOlW8Dw/W+C21f2izXgJBvA=
X-Google-Smtp-Source: APXvYqypvpLiNwNkFXga4GfyWDv+MIaT7ZlDnx7jracD9/qWDfbhCsp6YQOsOkHdg0YlsikfuYWMxQ==
X-Received: by 2002:adf:dbce:: with SMTP id e14mr7509054wrj.49.1570694958485;
        Thu, 10 Oct 2019 01:09:18 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id s1sm7080479wrg.80.2019.10.10.01.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 01:09:18 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:09:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ayal@mellanox.com,
        moshe@mellanox.com, eranbe@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 3/4] netdevsim: implement couple of testing
 devlink health reporters
Message-ID: <20191010080917.GC2223@nanopsycho>
References: <20191009110445.23237-1-jiri@resnulli.us>
 <20191009110445.23237-4-jiri@resnulli.us>
 <20191009205351.5ae47731@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009205351.5ae47731@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 10, 2019 at 05:53:51AM CEST, jakub.kicinski@netronome.com wrote:
>On Wed,  9 Oct 2019 13:04:44 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Implement "empty" and "dummy" reporters. The first one is really simple
>> and does nothing. The other one has debugfs files to trigger breakage
>> and it is able to do recovery. The ops also implement dummy fmsg
>> content.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>> diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
>> new file mode 100644
>> index 000000000000..088ae8fd89fc
>> --- /dev/null
>> +++ b/drivers/net/netdevsim/health.c
>
>> +static int
>> +nsim_dev_dummy_reporter_recover(struct devlink_health_reporter *reporter,
>> +				void *priv_ctx,
>> +				struct netlink_ext_ack *extack)
>> +{
>> +	struct nsim_dev_health *health = devlink_health_reporter_priv(reporter);
>> +	struct nsim_dev_dummy_reporter_ctx *ctx = priv_ctx;
>> +
>> +	if (health->fail_recover) {
>> +		/* For testing purposes, user set debugfs fail_recover
>> +		 * value to true. Fail right away.
>> +		 */
>> +		NL_SET_ERR_MSG_MOD(extack, "User setup the recover to fail for testing purposes");
>> +		return -EINVAL;
>> +	}
>> +	if (ctx) {
>> +		health->recovered_break_msg = kstrdup(ctx->break_msg,
>
>Can't there already be a message there? wouldn't this leak it?

It would. Will fix.

>
>> +						      GFP_KERNEL);
>> +		if (!health->recovered_break_msg)
>> +			return -ENOMEM;
>> +	}
>> +	return 0;
>> +}
>
>> +static ssize_t nsim_dev_health_break_write(struct file *file,
>> +					   const char __user *data,
>> +					   size_t count, loff_t *ppos)
>> +{
>> +	struct nsim_dev_health *health = file->private_data;
>> +	struct nsim_dev_dummy_reporter_ctx ctx;
>> +	char *break_msg;
>> +	int err;
>> +
>> +	break_msg = kmalloc(count + 1, GFP_KERNEL);
>> +	if (!break_msg)
>> +		return -ENOMEM;
>> +
>> +	if (copy_from_user(break_msg, data, count)) {
>> +		err = -EFAULT;
>> +		goto out;
>> +	}
>> +	break_msg[count] = '\0';
>> +	if (break_msg[count - 1] == '\n')
>> +		break_msg[count - 1] = '\0';
>> +
>> +	ctx.break_msg = break_msg;
>> +	err = devlink_health_report(health->dummy_reporter, break_msg, &ctx);
>> +	if (err)
>> +		goto out;
>> +
>> +out:
>> +	kfree(break_msg);
>> +	return err ? err : count;
>
>nit: ?: works here, like you used below

Ok.


>
>> +}
>> +
>> +static const struct file_operations nsim_dev_health_break_fops = {
>> +	.open = simple_open,
>> +	.write = nsim_dev_health_break_write,
>> +	.llseek = generic_file_llseek,
>> +};
>> +
>> +int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
>> +{
>> +	struct nsim_dev_health *health = &nsim_dev->health;
>> +	int err;
>> +
>> +	health->empty_reporter =
>> +		devlink_health_reporter_create(devlink,
>> +					       &nsim_dev_empty_reporter_ops,
>> +					       0, false, health);
>> +	if (IS_ERR(health->empty_reporter))
>> +		return PTR_ERR(health->empty_reporter);
>> +
>> +	health->dummy_reporter =
>> +		devlink_health_reporter_create(devlink,
>> +					       &nsim_dev_dummy_reporter_ops,
>> +					       0, false, health);
>> +	if (IS_ERR(health->dummy_reporter)) {
>> +		err = PTR_ERR(health->dummy_reporter);
>> +		goto err_empty_reporter_destroy;
>> +	}
>> +
>> +	health->ddir = debugfs_create_dir("health", nsim_dev->ddir);
>> +	if (IS_ERR_OR_NULL(health->ddir))
>> +		return PTR_ERR_OR_ZERO(health->ddir) ?: -EINVAL;
>
>goto err_dummy_reporter_destroy?

Right.


>
>> +	health->recovered_break_msg = NULL;
>> +	debugfs_create_file("break_health", 0200, health->ddir, health,
>> +			    &nsim_dev_health_break_fops);
>> +	health->binary_len = 16;
>> +	debugfs_create_u32("binary_len", 0600, health->ddir,
>> +			   &health->binary_len);
>> +	health->fail_recover = false;
>> +	debugfs_create_bool("fail_recover", 0600, health->ddir,
>> +			    &health->fail_recover);
>> +	return 0;
>> +
>> +err_empty_reporter_destroy:
>> +	devlink_health_reporter_destroy(health->empty_reporter);
>> +	return err;
>> +}
>> +
>> +void nsim_dev_health_exit(struct nsim_dev *nsim_dev)
>> +{
>> +	struct nsim_dev_health *health = &nsim_dev->health;
>> +
>> +	debugfs_remove_recursive(health->ddir);
>> +	kfree(health->recovered_break_msg);
>> +	devlink_health_reporter_destroy(health->dummy_reporter);
>> +	devlink_health_reporter_destroy(health->empty_reporter);
>> +}
>> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
>> index 24358385d869..657cbae50293 100644
>> --- a/drivers/net/netdevsim/netdevsim.h
>> +++ b/drivers/net/netdevsim/netdevsim.h
>> @@ -18,6 +18,7 @@
>>  #include <linux/list.h>
>>  #include <linux/netdevice.h>
>>  #include <linux/u64_stats_sync.h>
>> +#include <linux/debugfs.h>
>
>I don't think this include is needed? Forward declaration of 
>struct dentry, should be sufficient, if needed, no?

Right.


>
>>  #include <net/devlink.h>
>>  #include <net/xdp.h>
>>  
>> @@ -134,6 +135,18 @@ enum nsim_resource_id {
>>  	NSIM_RESOURCE_IPV6_FIB_RULES,
>>  };
>>  
>> +struct nsim_dev_health {
>> +	struct devlink_health_reporter *empty_reporter;
>> +	struct devlink_health_reporter *dummy_reporter;
>> +	struct dentry *ddir;
>> +	char *recovered_break_msg;
>> +	u32 binary_len;
>> +	bool fail_recover;
>> +};
>> +
>> +int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink);
>> +void nsim_dev_health_exit(struct nsim_dev *nsim_dev);
>> +
>>  struct nsim_dev_port {
>>  	struct list_head list;
>>  	struct devlink_port devlink_port;
>> @@ -164,6 +177,7 @@ struct nsim_dev {
>>  	bool dont_allow_reload;
>>  	bool fail_reload;
>>  	struct devlink_region *dummy_region;
>> +	struct nsim_dev_health health;
>>  };
>>  
>>  static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
>
