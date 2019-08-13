Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5D38B08A
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfHMHQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:16:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38966 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfHMHQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:16:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id i63so492395wmg.4
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 00:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FTWV5t89sbEGbNN7khHORiFGsYj+vRxIrWHIraMW1EY=;
        b=jrPUODNjV/7rMiGAIce+YS9eFYzpGOBwdDstbV4PzcfyGkl0tBNUkTBliTLmEOCli5
         RSWobJVMF8DM7Q6mDka1/q8vq1eUpmTen+xHU6UfQbtWzDzF+2a3XxbnoUE9fOTf5WiX
         33IYyjMUtjPm9RvtEKCkULOyo2eNMLTXSYDgyl0zbapNIuieKFvC/i6XHWmYDiAiYrSx
         0F8yr5i3B6U3rL2vs+HivvXNe3ywn6CrwuL23/9DRJdSTSb0r4g2neh3+1BdI2zCE2XQ
         8wdVddVYgVYz3GzFK7EvXTzckoP0AUaiFwxzdPLsK98DOkZn0KNQE28arOrBFWLxdU04
         gSyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FTWV5t89sbEGbNN7khHORiFGsYj+vRxIrWHIraMW1EY=;
        b=rgPuX9/LUCLuYPk66JLAbc9XaBvLXAH3BprMen0E/PF84UsLLm7v5AQ90J5y/moUg+
         anHuBNP+xFOMpeypNybbpM2ouBl6zqRLEDfsDESV25wdCJxbl4noZVKrkZ67DYp4y6wD
         kmsR6moZUaiXCKNuvS+ljuG3tcFgAqQ2n25MtV+9SrDPuydqhuD1RIf9V6mAbfD/MN9A
         X7MtUDHZt74GB0hcWx1Mt060R5opWZquAAdYgil3ucPscfRVgbpU9dNon9KqVlw3JFtp
         O1KDRz960gP2TFXe5tbmdahv00TN9QjQVVJyjDKjJJ+FgGCk44Trtp15JCH25IeD6OEv
         o+wA==
X-Gm-Message-State: APjAAAVUkQuUTBYxmur6lirPv7t1JvQc0Mqn+9PaazzR8oJcFYqoBtyd
        YsE2ZxlVJHsjg2rtkdG57C1Yeg==
X-Google-Smtp-Source: APXvYqyMiPUB0kAAJHexriU2cf+fHn3R71VZrQB7HILC1vHVDL0rCPeGdRpNp2jNeKO0fJQDoYCEqw==
X-Received: by 2002:a05:600c:21c1:: with SMTP id x1mr1129423wmj.37.1565680576359;
        Tue, 13 Aug 2019 00:16:16 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id q19sm503922wmc.41.2019.08.13.00.16.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 00:16:15 -0700 (PDT)
Date:   Tue, 13 Aug 2019 09:16:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next] netdevsim: implement support for devlink region
 and snapshots
Message-ID: <20190813071615.GM2428@nanopsycho>
References: <20190812101620.7884-1-jiri@resnulli.us>
 <20190812175859.3e0275e3@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812175859.3e0275e3@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 02:58:59AM CEST, jakub.kicinski@netronome.com wrote:
>On Mon, 12 Aug 2019 12:16:20 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Implement dummy region of size 32K and allow user to create snapshots
>> or random data using debugfs file trigger.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>I'm nacking all the netdevsim patches unless the selftest 
>is posted at the same time :/
>
>You're leaking those features one by one what if you get distracted 
>and the tests never materialize :/
>
>This is all dead code.

Okay, fair enough. Will add it now.


>
>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> index 08ca59fc189b..e76ea6a3cb60 100644
>> --- a/drivers/net/netdevsim/dev.c
>> +++ b/drivers/net/netdevsim/dev.c
>> @@ -27,6 +27,41 @@
>>  
>>  static struct dentry *nsim_dev_ddir;
>>  
>> +#define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
>> +
>> +static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>> +					    const char __user *data,
>> +					    size_t count, loff_t *ppos)
>> +{
>> +	struct nsim_dev *nsim_dev = file->private_data;
>> +	void *dummy_data;
>> +	u32 id;
>> +	int err;
>> +
>> +	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
>> +	if (!dummy_data) {
>> +		pr_err("Failed to allocate memory for region snapshot\n");
>> +		goto out;
>> +	}
>> +
>> +	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
>> +
>> +	id = devlink_region_shapshot_id_get(priv_to_devlink(nsim_dev));
>> +	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
>> +					     dummy_data, id, kfree);
>> +	if (err)
>> +		pr_err("Failed to create region snapshot\n");
>> +
>> +out:
>> +	return count;
>
>why not return an error?

Okay.


>
>> +}
>> +
>> +static const struct file_operations nsim_dev_take_snapshot_fops = {
>> +	.open = simple_open,
>> +	.write = nsim_dev_take_snapshot_write,
>> +	.llseek = generic_file_llseek,
>> +};
>> +
>>  static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
>>  {
>>  	char dev_ddir_name[16];
>> @@ -44,6 +79,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
>>  			   &nsim_dev->max_macs);
>>  	debugfs_create_bool("test1", 0600, nsim_dev->ddir,
>>  			    &nsim_dev->test1);
>> +	debugfs_create_file("take_snapshot", 0200, nsim_dev->ddir, nsim_dev,
>> +			    &nsim_dev_take_snapshot_fops);
>>  	return 0;
>>  }
>>  
>> @@ -248,6 +285,26 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
>>  		nsim_dev->test1 = saved_value.vbool;
>>  }
>>  
>> +#define NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX 16
>> +
>> +static int nsim_dev_dummy_region_init(struct nsim_dev *nsim_dev,
>> +				      struct devlink *devlink)
>> +{
>> +	nsim_dev->dummy_region =
>> +		devlink_region_create(devlink, "dummy",
>> +				      NSIM_DEV_DUMMY_REGION_SNAPSHOT_MAX,
>> +				      NSIM_DEV_DUMMY_REGION_SIZE);
>> +	if (IS_ERR(nsim_dev->dummy_region))
>> +		return PTR_ERR(nsim_dev->dummy_region);
>> +
>> +	return 0;
>
>PTR_ERR_OR_ZERO()

Okay.


>
>> +}
>> +
>> +static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
>> +{
>> +	devlink_region_destroy(nsim_dev->dummy_region);
>> +}
>> +
>>  static int nsim_dev_reload(struct devlink *devlink,
>>  			   struct netlink_ext_ack *extack)
>>  {
>
