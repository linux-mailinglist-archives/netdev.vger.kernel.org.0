Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1821C9802
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 07:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbfJCFh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 01:37:57 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44546 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfJCFh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 01:37:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id z9so1393332wrl.11
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 22:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MRYt00zkac+HtHKROrOtmgZ8k+FibDDn5uPp8JsyWJc=;
        b=qDshvGJrlmXJtdyWsLltpxVMimVfatKIdHly1+RQlpEsTd20J/0EX2/4T0xDa1cOI2
         SAyhtifTfGFtSzxX7KQLds9ojanm1A3Y+yGYmaJYBxdxPqOxR3fDd7AYp6Krg61ZKUNY
         lf8TLcjMLthWO/w40Q4CrYLngJFZpFhWc+qHIlYaS47Q/2qXYDh+hs/G5ZIQLu/Lw4rM
         r1u10tIXvG/7tMQzIvzVgpt68AEf1m6u4ZLEJpnpMvxJSL501lSPHs5cEYdhfLm+G3Rp
         M7x1hV5bMMC78Oqd2E/qxVVoQrAgiOCp5RV4YH7Gy9JwTWkN34FSM58OQwTznvb0An20
         mklw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MRYt00zkac+HtHKROrOtmgZ8k+FibDDn5uPp8JsyWJc=;
        b=UgF0ypZG0MfBP/bQ99okqXNlLdksJU49UwqmK62OZuKfQQ+5bKk49LQVpR3fwFDFbN
         g8lH0DTYr5qrhNQ4E+SMPss+YciT3jQIGgw/oMYE+KDkYlVLnMqfeS+FMK6RHfIDGqsX
         XJm9IuNfgf2yvsHvu4txzzCCQEA7TvPkRpfsx7CYJPeLp3BS4wU3rCj2nJmmApbabs/R
         mlJwrq2IWgJo6aONSEb0lWBCSTxqL0Hdear6AKHjGPfe1OAc6zS1/cCIjDrNOXqMJwVj
         G/UQgaSALtZ8UEUZh5zaP89EZBFUOtkVdK5zFj7Yun8b6NKJ3n/BYn9qKXh5cA94t4ka
         BYWw==
X-Gm-Message-State: APjAAAVlR6J1+81N7Gz4S4IpfXljr1WunXiLlL6zJqXucivNK59VFmGh
        uVUlE6OYGrPCmkG9enSgiF70Yw==
X-Google-Smtp-Source: APXvYqwAofsyFYV+JmoOzuzBj92NRCWmYjcLQwAmhNRnryoQx5pIc5StFO37x4YxkFLb9yO1fxEDMw==
X-Received: by 2002:a5d:66d2:: with SMTP id k18mr5372050wrw.7.1570081073441;
        Wed, 02 Oct 2019 22:37:53 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t123sm1582424wma.40.2019.10.02.22.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 22:37:52 -0700 (PDT)
Date:   Thu, 3 Oct 2019 07:37:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v2 11/15] netdevsim: implement proper devlink
 reload
Message-ID: <20191003053752.GH2279@nanopsycho>
References: <20191002161231.2987-1-jiri@resnulli.us>
 <20191002161231.2987-12-jiri@resnulli.us>
 <20191002173812.099d01f4@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002173812.099d01f4@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 03, 2019 at 02:38:12AM CEST, jakub.kicinski@netronome.com wrote:
>On Wed,  2 Oct 2019 18:12:27 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> During devlink reload, all driver objects should be reinstantiated with
>> the exception of devlink instance and devlink resources and params.
>> Move existing devlink_resource_size_get() calls into fib_create() just
>> before fib notifier is registered. Also, make sure that extack is
>> propagated down to fib_notifier_register() call.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> v1->v2:
>> - don't reinstantiate debugfs during reload.
>> ---
>>  drivers/net/netdevsim/dev.c       | 160 +++++++++++++++++-------------
>>  drivers/net/netdevsim/fib.c       |  53 +++++-----
>>  drivers/net/netdevsim/netdevsim.h |   8 +-
>>  3 files changed, 124 insertions(+), 97 deletions(-)
>> 
>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> index 3cc101aee991..c04312359e4f 100644
>> --- a/drivers/net/netdevsim/dev.c
>> +++ b/drivers/net/netdevsim/dev.c
>> @@ -469,37 +469,28 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
>>  	kfree(nsim_dev->trap_data);
>>  }
>>  
>> +static struct nsim_dev *
>> +nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, struct nsim_dev *nsim_dev,
>> +		struct netlink_ext_ack *extack);
>> +static void nsim_dev_destroy(struct nsim_dev *nsim_dev, bool reload);
>> +
>>  static int nsim_dev_reload_down(struct devlink *devlink,
>>  				struct netlink_ext_ack *extack)
>>  {
>> +	struct nsim_dev *nsim_dev = devlink_priv(devlink);
>> +
>> +	nsim_dev_destroy(nsim_dev, true);
>>  	return 0;
>>  }
>>  
>>  static int nsim_dev_reload_up(struct devlink *devlink,
>>  			      struct netlink_ext_ack *extack)
>> +
>
>Stray new line.

Oups.

>
>>  {
>>  	struct nsim_dev *nsim_dev = devlink_priv(devlink);
>> -	enum nsim_resource_id res_ids[] = {
>> -		NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
>> -		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES
>> -	};
>> -	int i;
>>  
>> -	for (i = 0; i < ARRAY_SIZE(res_ids); ++i) {
>> -		int err;
>> -		u64 val;
>> -
>> -		err = devlink_resource_size_get(devlink, res_ids[i], &val);
>> -		if (!err) {
>> -			err = nsim_fib_set_max(nsim_dev->fib_data,
>> -					       res_ids[i], val, extack);
>> -			if (err)
>> -				return err;
>> -		}
>> -	}
>> -	nsim_devlink_param_load_driverinit_values(devlink);
>> -
>> -	return 0;
>> +	nsim_dev = nsim_dev_create(nsim_dev->nsim_bus_dev, nsim_dev, extack);
>> +	return PTR_ERR_OR_ZERO(nsim_dev);
>>  }
>>  
>>  #define NSIM_DEV_FLASH_SIZE 500000
>> @@ -688,15 +679,21 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
>>  }
>>  
>>  static struct nsim_dev *
>> -nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
>> +nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, struct nsim_dev *nsim_dev,
>> +		struct netlink_ext_ack *extack)
>>  {
>> -	struct nsim_dev *nsim_dev;
>> +	bool reload = !!nsim_dev;
>>  	struct devlink *devlink;
>>  	int err;
>>  
>> -	devlink = devlink_alloc(&nsim_dev_devlink_ops, sizeof(*nsim_dev));
>> -	if (!devlink)
>> -		return ERR_PTR(-ENOMEM);
>> +	if (!reload) {
>> +		devlink = devlink_alloc(&nsim_dev_devlink_ops,
>> +					sizeof(*nsim_dev));
>> +		if (!devlink)
>> +			return ERR_PTR(-ENOMEM);
>> +	} else {
>> +		devlink = priv_to_devlink(nsim_dev);
>> +	}
>>  	nsim_dev = devlink_priv(devlink);
>>  	nsim_dev->nsim_bus_dev = nsim_bus_dev;
>>  	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
>> @@ -704,28 +701,35 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
>>  	INIT_LIST_HEAD(&nsim_dev->port_list);
>>  	mutex_init(&nsim_dev->port_list_lock);
>>  	nsim_dev->fw_update_status = true;
>> -	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
>> -	nsim_dev->test1 = NSIM_DEV_TEST1_DEFAULT;
>>  
>> -	err = nsim_dev_resources_register(devlink);
>> -	if (err)
>> -		goto err_devlink_free;
>> +	if (!reload) {
>> +		err = nsim_dev_resources_register(devlink);
>> +		if (err)
>> +			goto err_devlink_free;
>> +	}
>>  
>> -	nsim_dev->fib_data = nsim_fib_create(devlink);
>> +	nsim_dev->fib_data = nsim_fib_create(devlink, extack);
>>  	if (IS_ERR(nsim_dev->fib_data)) {
>>  		err = PTR_ERR(nsim_dev->fib_data);
>>  		goto err_resources_unregister;
>>  	}
>>  
>> -	err = devlink_register(devlink, &nsim_bus_dev->dev);
>> -	if (err)
>> -		goto err_fib_destroy;
>> +	if (!reload) {
>> +		nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
>> +		nsim_dev->test1 = NSIM_DEV_TEST1_DEFAULT;
>>  
>> -	err = devlink_params_register(devlink, nsim_devlink_params,
>> -				      ARRAY_SIZE(nsim_devlink_params));
>> -	if (err)
>> -		goto err_dl_unregister;
>> -	nsim_devlink_set_params_init_values(nsim_dev, devlink);
>> +		err = devlink_register(devlink, &nsim_bus_dev->dev);
>> +		if (err)
>> +			goto err_fib_destroy;
>> +
>> +		err = devlink_params_register(devlink, nsim_devlink_params,
>> +					      ARRAY_SIZE(nsim_devlink_params));
>> +		if (err)
>> +			goto err_dl_unregister;
>> +		nsim_devlink_set_params_init_values(nsim_dev, devlink);
>> +	} else {
>> +		nsim_devlink_param_load_driverinit_values(devlink);
>> +	}
>>  
>>  	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
>>  	if (err)
>> @@ -735,66 +739,86 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
>>  	if (err)
>>  		goto err_dummy_region_exit;
>>  
>> -	err = nsim_dev_debugfs_init(nsim_dev);
>> -	if (err)
>> -		goto err_traps_exit;
>> +	if (!reload) {
>> +		err = nsim_dev_debugfs_init(nsim_dev);
>> +		if (err)
>> +			goto err_traps_exit;
>>  
>> -	err = nsim_bpf_dev_init(nsim_dev);
>> -	if (err)
>> -		goto err_debugfs_exit;
>> +		err = nsim_bpf_dev_init(nsim_dev);
>> +		if (err)
>> +			goto err_debugfs_exit;
>> +	}
>>  
>>  	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
>>  	if (err)
>>  		goto err_bpf_dev_exit;
>>  
>> -	devlink_params_publish(devlink);
>> +	if (reload)
>> +		devlink_params_publish(devlink);
>>
>>  	return nsim_dev;
>>  
>>  err_bpf_dev_exit:
>> -	nsim_bpf_dev_exit(nsim_dev);
>> +	if (!reload) {
>> +		nsim_bpf_dev_exit(nsim_dev);
>>  err_debugfs_exit:
>> -	nsim_dev_debugfs_exit(nsim_dev);
>> +		nsim_dev_debugfs_exit(nsim_dev);
>> +	}
>>  err_traps_exit:
>>  	nsim_dev_traps_exit(devlink);
>>  err_dummy_region_exit:
>>  	nsim_dev_dummy_region_exit(nsim_dev);
>>  err_params_unregister:
>> -	devlink_params_unregister(devlink, nsim_devlink_params,
>> -				  ARRAY_SIZE(nsim_devlink_params));
>> +	if (!reload) {
>> +		devlink_params_unregister(devlink, nsim_devlink_params,
>> +					  ARRAY_SIZE(nsim_devlink_params));
>>  err_dl_unregister:
>> -	devlink_unregister(devlink);
>> +		devlink_unregister(devlink);
>> +	}
>>  err_fib_destroy:
>>  	nsim_fib_destroy(devlink, nsim_dev->fib_data);
>>  err_resources_unregister:
>> -	devlink_resources_unregister(devlink, NULL);
>> +	if (!reload) {
>> +		devlink_resources_unregister(devlink, NULL);
>>  err_devlink_free:
>> -	devlink_free(devlink);
>> +		devlink_free(devlink);
>> +	}
>>  	return ERR_PTR(err);
>
>All this if (reload) code looks pretty ugly :/
>
>I'd say create function should create, and destroy destroy, rather than
>do only half of the job based on some extra parameter :(

Okay. I wanted to avoid duplication. Will do.


>
>>  }
>>  
>> -static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
>> +static void nsim_dev_destroy(struct nsim_dev *nsim_dev, bool reload)
>>  {
>>  	struct devlink *devlink = priv_to_devlink(nsim_dev);
>>  
>> -	nsim_dev_port_del_all(nsim_dev);
>> -	nsim_bpf_dev_exit(nsim_dev);
>> -	nsim_dev_debugfs_exit(nsim_dev);
>> -	nsim_dev_traps_exit(devlink);
>> -	nsim_dev_dummy_region_exit(nsim_dev);
>> -	devlink_params_unregister(devlink, nsim_devlink_params,
>> -				  ARRAY_SIZE(nsim_devlink_params));
>> -	devlink_unregister(devlink);
>> -	nsim_fib_destroy(devlink, nsim_dev->fib_data);
>> -	devlink_resources_unregister(devlink, NULL);
>> -	mutex_destroy(&nsim_dev->port_list_lock);
>> -	devlink_free(devlink);
>> +	if (!devlink_is_reload_failed(devlink))
>> +		nsim_dev_port_del_all(nsim_dev);
>> +	if (!reload) {
>> +		nsim_bpf_dev_exit(nsim_dev);
>> +		nsim_dev_debugfs_exit(nsim_dev);
>> +	}
>> +	if (!devlink_is_reload_failed(devlink)) {
>> +		nsim_dev_traps_exit(devlink);
>> +		nsim_dev_dummy_region_exit(nsim_dev);
>> +		mutex_destroy(&nsim_dev->port_list_lock);
>> +	}
>> +	if (!reload) {
>> +		devlink_params_unregister(devlink, nsim_devlink_params,
>> +					  ARRAY_SIZE(nsim_devlink_params));
>> +		devlink_unregister(devlink);
>> +	}
>> +	if (!devlink_is_reload_failed(devlink))
>> +		nsim_fib_destroy(devlink, nsim_dev->fib_data);
>> +	if (!reload) {
>> +		devlink_resources_unregister(devlink, NULL);
>> +		mutex_destroy(&nsim_dev->port_list_lock);
>> +		devlink_free(devlink);
>> +	}
>>  }
>>  
>>  int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
>>  {
>>  	struct nsim_dev *nsim_dev;
>>  
>> -	nsim_dev = nsim_dev_create(nsim_bus_dev);
>> +	nsim_dev = nsim_dev_create(nsim_bus_dev, NULL, NULL);
>>  	if (IS_ERR(nsim_dev))
>>  		return PTR_ERR(nsim_dev);
>>  	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
>> @@ -806,7 +830,7 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
>>  {
>>  	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
>>  
>> -	nsim_dev_destroy(nsim_dev);
>> +	nsim_dev_destroy(nsim_dev, false);
>>  }
>>  
>>  static struct nsim_dev_port *
>> diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
>> index d2aeac0f4c2c..fdc682f3a09a 100644
>> --- a/drivers/net/netdevsim/fib.c
>> +++ b/drivers/net/netdevsim/fib.c
>> @@ -63,12 +63,10 @@ u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
>>  	return max ? entry->max : entry->num;
>>  }
>>  
>> -int nsim_fib_set_max(struct nsim_fib_data *fib_data,
>> -		     enum nsim_resource_id res_id, u64 val,
>> -		     struct netlink_ext_ack *extack)
>> +static void nsim_fib_set_max(struct nsim_fib_data *fib_data,
>> +			     enum nsim_resource_id res_id, u64 val)
>>  {
>>  	struct nsim_fib_entry *entry;
>> -	int err = 0;
>>  
>>  	switch (res_id) {
>>  	case NSIM_RESOURCE_IPV4_FIB:
>> @@ -84,20 +82,10 @@ int nsim_fib_set_max(struct nsim_fib_data *fib_data,
>>  		entry = &fib_data->ipv6.rules;
>>  		break;
>>  	default:
>> -		return 0;
>> -	}
>> -
>> -	/* not allowing a new max to be less than curren occupancy
>> -	 * --> no means of evicting entries
>> -	 */
>> -	if (val < entry->num) {
>> -		NL_SET_ERR_MSG_MOD(extack, "New size is less than current occupancy");
>> -		err = -EINVAL;
>> -	} else {
>> -		entry->max = val;
>> +		WARN_ON(1);
>> +		return;
>>  	}
>> -
>> -	return err;
>> +	entry->max = val;
>>  }
>>  
>>  static int nsim_fib_rule_account(struct nsim_fib_entry *entry, bool add,
>> @@ -239,7 +227,28 @@ static u64 nsim_fib_ipv6_rules_res_occ_get(void *priv)
>>  	return nsim_fib_get_val(data, NSIM_RESOURCE_IPV6_FIB_RULES, false);
>>  }
>>  
>> -struct nsim_fib_data *nsim_fib_create(struct devlink *devlink)
>> +static void nsim_fib_set_max_all(struct nsim_fib_data *data,
>> +				 struct devlink *devlink)
>> +{
>> +	enum nsim_resource_id res_ids[] = {
>> +		NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
>> +		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES
>> +	};
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(res_ids); i++) {
>> +		int err;
>> +		u64 val;
>> +
>> +		err = devlink_resource_size_get(devlink, res_ids[i], &val);
>> +		if (err)
>> +			val = (u64) -1;
>> +		nsim_fib_set_max(data, res_ids[i], val);
>> +	}
>> +}
>> +
>> +struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
>> +				      struct netlink_ext_ack *extack)
>>  {
>>  	struct nsim_fib_data *data;
>>  	int err;
>> @@ -248,15 +257,11 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink)
>>  	if (!data)
>>  		return ERR_PTR(-ENOMEM);
>>  
>> -	data->ipv4.fib.max = (u64)-1;
>> -	data->ipv4.rules.max = (u64)-1;
>> -
>> -	data->ipv6.fib.max = (u64)-1;
>> -	data->ipv6.rules.max = (u64)-1;
>> +	nsim_fib_set_max_all(data, devlink);
>>  
>>  	data->fib_nb.notifier_call = nsim_fib_event_nb;
>>  	err = register_fib_notifier(&init_net, &data->fib_nb,
>> -				    nsim_fib_dump_inconsistent, NULL);
>> +				    nsim_fib_dump_inconsistent, extack);
>>  	if (err) {
>>  		pr_err("Failed to register fib notifier\n");
>>  		goto err_out;
>> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
>> index ac506cf253b6..702d951fe160 100644
>> --- a/drivers/net/netdevsim/netdevsim.h
>> +++ b/drivers/net/netdevsim/netdevsim.h
>> @@ -173,13 +173,11 @@ int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
>>  int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
>>  		      unsigned int port_index);
>>  
>> -struct nsim_fib_data *nsim_fib_create(struct devlink *devlink);
>> -void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data);
>> +struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
>> +				      struct netlink_ext_ack *extack);
>> +void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *fib_data);
>>  u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
>>  		     enum nsim_resource_id res_id, bool max);
>> -int nsim_fib_set_max(struct nsim_fib_data *fib_data,
>> -		     enum nsim_resource_id res_id, u64 val,
>> -		     struct netlink_ext_ack *extack);
>>  
>>  #if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
>>  void nsim_ipsec_init(struct netdevsim *ns);
>
