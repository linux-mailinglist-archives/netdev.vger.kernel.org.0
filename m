Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A17FD1F1F
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 05:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732796AbfJJDyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 23:54:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36775 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfJJDyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 23:54:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id 23so2777433pgk.3
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 20:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=BQU6F4wcxnf3VJLCfNjEoZmflfwR3i1ukgtNtHF8z8c=;
        b=nXXPTy3mjiGyrt5Y1cf9MP3qst/UcDEslv4Un2wMi0S/a5SeVoBTcI5NHOcAhePcEi
         ezD6/7mwZa7dJCYwsvpY989yDPPFKSdDJGSZ+T9DTp9cDD6yI/clyKuLSOHVFxCG8V85
         yvyX0UCEYI7TiP7oNkPgM1ApdnIcCpk1IoB3C8s8rkWp9RfGWJM7+1sA+y/qgYrDaKbl
         ZvrGEvbRTPUJixdYKSdEePoqJKqVzwE1pvH0WOAc/dGhVKeNZD4FjC9dAeEY3DAR0/fI
         Cc1htNC1h70ZZB+f4R/YCP/vw//Qet6jf0xkImbMPXA6Wucd4FYXxofa3KUwv1LOgH2G
         keIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=BQU6F4wcxnf3VJLCfNjEoZmflfwR3i1ukgtNtHF8z8c=;
        b=roI9dQtXq8ZTGehCj5bTDOyMGeiTEtBARYLYGzpGZjv26huCsDb9bM95jey8XK81DR
         rw92EMggXdjt9zBGj17ngtW5TbsnYtl9IekUy9EQ6vkIwG3X58zQTsKzJLFF+g2zkTqZ
         uAJ2wYqI5wLMXIyAgnoTD0N6G0yU5m0g7sbWq7hYvh3F2kmTUaxVqK3uG0i6L3hbF7uE
         onrkhW+qms/UsAmUV5R0KdVL7spdR6AUiJIoBpJgn5Bmff+9YbFIkX+NWy7nnBqFMqV4
         nAu53lA+AxSgbSdEDU0rZRQ2GBwghkfqhvLNvRkcfkTZsjbLbLjbNRT9VQDR7B9Cv1hT
         wCpQ==
X-Gm-Message-State: APjAAAXISDBEml8vzypCrf+rOuMjfefLzr7Q05kOpizXoaSGebdPGlAN
        UkRbXpnQ/R5tA9ntK3V6s0KsBw==
X-Google-Smtp-Source: APXvYqy5a8n7tufPTLsSculm4j4FygTe0YMiUVBQ93Hz1/XUz8keoG0dUb9EbuC77TODLtmJeabwdg==
X-Received: by 2002:aa7:9715:: with SMTP id a21mr7807040pfg.144.1570679645358;
        Wed, 09 Oct 2019 20:54:05 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 62sm4286191pfg.164.2019.10.09.20.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 20:54:05 -0700 (PDT)
Date:   Wed, 9 Oct 2019 20:53:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ayal@mellanox.com,
        moshe@mellanox.com, eranbe@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 3/4] netdevsim: implement couple of testing
 devlink health reporters
Message-ID: <20191009205351.5ae47731@cakuba.netronome.com>
In-Reply-To: <20191009110445.23237-4-jiri@resnulli.us>
References: <20191009110445.23237-1-jiri@resnulli.us>
        <20191009110445.23237-4-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 13:04:44 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Implement "empty" and "dummy" reporters. The first one is really simple
> and does nothing. The other one has debugfs files to trigger breakage
> and it is able to do recovery. The ops also implement dummy fmsg
> content.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

> diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
> new file mode 100644
> index 000000000000..088ae8fd89fc
> --- /dev/null
> +++ b/drivers/net/netdevsim/health.c

> +static int
> +nsim_dev_dummy_reporter_recover(struct devlink_health_reporter *reporter,
> +				void *priv_ctx,
> +				struct netlink_ext_ack *extack)
> +{
> +	struct nsim_dev_health *health = devlink_health_reporter_priv(reporter);
> +	struct nsim_dev_dummy_reporter_ctx *ctx = priv_ctx;
> +
> +	if (health->fail_recover) {
> +		/* For testing purposes, user set debugfs fail_recover
> +		 * value to true. Fail right away.
> +		 */
> +		NL_SET_ERR_MSG_MOD(extack, "User setup the recover to fail for testing purposes");
> +		return -EINVAL;
> +	}
> +	if (ctx) {
> +		health->recovered_break_msg = kstrdup(ctx->break_msg,

Can't there already be a message there? wouldn't this leak it?

> +						      GFP_KERNEL);
> +		if (!health->recovered_break_msg)
> +			return -ENOMEM;
> +	}
> +	return 0;
> +}

> +static ssize_t nsim_dev_health_break_write(struct file *file,
> +					   const char __user *data,
> +					   size_t count, loff_t *ppos)
> +{
> +	struct nsim_dev_health *health = file->private_data;
> +	struct nsim_dev_dummy_reporter_ctx ctx;
> +	char *break_msg;
> +	int err;
> +
> +	break_msg = kmalloc(count + 1, GFP_KERNEL);
> +	if (!break_msg)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(break_msg, data, count)) {
> +		err = -EFAULT;
> +		goto out;
> +	}
> +	break_msg[count] = '\0';
> +	if (break_msg[count - 1] == '\n')
> +		break_msg[count - 1] = '\0';
> +
> +	ctx.break_msg = break_msg;
> +	err = devlink_health_report(health->dummy_reporter, break_msg, &ctx);
> +	if (err)
> +		goto out;
> +
> +out:
> +	kfree(break_msg);
> +	return err ? err : count;

nit: ?: works here, like you used below

> +}
> +
> +static const struct file_operations nsim_dev_health_break_fops = {
> +	.open = simple_open,
> +	.write = nsim_dev_health_break_write,
> +	.llseek = generic_file_llseek,
> +};
> +
> +int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
> +{
> +	struct nsim_dev_health *health = &nsim_dev->health;
> +	int err;
> +
> +	health->empty_reporter =
> +		devlink_health_reporter_create(devlink,
> +					       &nsim_dev_empty_reporter_ops,
> +					       0, false, health);
> +	if (IS_ERR(health->empty_reporter))
> +		return PTR_ERR(health->empty_reporter);
> +
> +	health->dummy_reporter =
> +		devlink_health_reporter_create(devlink,
> +					       &nsim_dev_dummy_reporter_ops,
> +					       0, false, health);
> +	if (IS_ERR(health->dummy_reporter)) {
> +		err = PTR_ERR(health->dummy_reporter);
> +		goto err_empty_reporter_destroy;
> +	}
> +
> +	health->ddir = debugfs_create_dir("health", nsim_dev->ddir);
> +	if (IS_ERR_OR_NULL(health->ddir))
> +		return PTR_ERR_OR_ZERO(health->ddir) ?: -EINVAL;

goto err_dummy_reporter_destroy?

> +	health->recovered_break_msg = NULL;
> +	debugfs_create_file("break_health", 0200, health->ddir, health,
> +			    &nsim_dev_health_break_fops);
> +	health->binary_len = 16;
> +	debugfs_create_u32("binary_len", 0600, health->ddir,
> +			   &health->binary_len);
> +	health->fail_recover = false;
> +	debugfs_create_bool("fail_recover", 0600, health->ddir,
> +			    &health->fail_recover);
> +	return 0;
> +
> +err_empty_reporter_destroy:
> +	devlink_health_reporter_destroy(health->empty_reporter);
> +	return err;
> +}
> +
> +void nsim_dev_health_exit(struct nsim_dev *nsim_dev)
> +{
> +	struct nsim_dev_health *health = &nsim_dev->health;
> +
> +	debugfs_remove_recursive(health->ddir);
> +	kfree(health->recovered_break_msg);
> +	devlink_health_reporter_destroy(health->dummy_reporter);
> +	devlink_health_reporter_destroy(health->empty_reporter);
> +}
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> index 24358385d869..657cbae50293 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -18,6 +18,7 @@
>  #include <linux/list.h>
>  #include <linux/netdevice.h>
>  #include <linux/u64_stats_sync.h>
> +#include <linux/debugfs.h>

I don't think this include is needed? Forward declaration of 
struct dentry, should be sufficient, if needed, no?

>  #include <net/devlink.h>
>  #include <net/xdp.h>
>  
> @@ -134,6 +135,18 @@ enum nsim_resource_id {
>  	NSIM_RESOURCE_IPV6_FIB_RULES,
>  };
>  
> +struct nsim_dev_health {
> +	struct devlink_health_reporter *empty_reporter;
> +	struct devlink_health_reporter *dummy_reporter;
> +	struct dentry *ddir;
> +	char *recovered_break_msg;
> +	u32 binary_len;
> +	bool fail_recover;
> +};
> +
> +int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink);
> +void nsim_dev_health_exit(struct nsim_dev *nsim_dev);
> +
>  struct nsim_dev_port {
>  	struct list_head list;
>  	struct devlink_port devlink_port;
> @@ -164,6 +177,7 @@ struct nsim_dev {
>  	bool dont_allow_reload;
>  	bool fail_reload;
>  	struct devlink_region *dummy_region;
> +	struct nsim_dev_health health;
>  };
>  
>  static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)

