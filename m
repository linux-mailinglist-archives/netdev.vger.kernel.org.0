Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7450B2F8147
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbhAOQyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbhAOQyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:54:45 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A2CC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:54:05 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id l9so8523079ejx.3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aJ+m+sOpZte8xrfxOC5cSwg+sTdfAj90eTeETOv4HS8=;
        b=BhwX+XfovN24Kqyq+VngERP+R90nhS/3QcVQAAM7fg80e3qGrcwJancI3lVTHYsvJW
         FWaaJQiv1QKjtQ74cIhvuuOB87VRhGNzLehC9MSv9bbI4vUwYUZNZEDpVVc0ZIZKzDw0
         a5E3pvZjCnsrfSFAiLmzRoCfhi1uc/+eu3wlSxs/5z+E7RyKvXQOAkyut8asF0FyW+4f
         m4+b0rgAmd6PrBhnGsDswF6VG6vtO/saNBHkC5wieiuyZTeEhSxV+V/dLvYiFasENe/C
         r6lzjK14Zvj9NecbhzIbRWqlqRF1a0oj2ciVKR5mYpWL9wPYzNm/Od84zItdMqtk/C34
         O8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aJ+m+sOpZte8xrfxOC5cSwg+sTdfAj90eTeETOv4HS8=;
        b=LTPCqLweHPR8eAvbuiFEjQg2hpA46hIrsP2/k8LRyhdX9809i9/e1kA3W0XYCTSQHt
         pdi96B9WasZy42ZrKzajZ3pSYUPU86tss33C7F2hbYKncBrUMn0Z6CHQ0A3OcL8WjlIh
         G2/QUP+IB7kVtqD1Rz5ZSeqQ9+GGe7eyGy2q6I0ln+4ltCzFSO1ErXWaTs3nuCN6XCpS
         lUnasycpnxfnxQMVjw2+4ZVAHFM4RWLfa2N8baMYBWfDpljhVnUO2UenJc+iI86dkm6I
         ZSht5GiF5XE2LtD13GM2IFM+p+cLvAD0DDQ118fAMh5iEsVYoIEy9MaRJRrPLc9/9ZJg
         LCjw==
X-Gm-Message-State: AOAM531hjSWZKQSOgXwQ+glmjSaQZwUgt1x9JEtzjUN9LCB/0GVC6YDx
        VJFoX1Dfhm1H9eCXHb4aAoWLQg==
X-Google-Smtp-Source: ABdhPJxH120xXOoLqsytXVdnVO9UO4TUuuCfTS0ThmIi1dpf1NQBiqXcRCyeLcfmzKnsaZ6a8BBngg==
X-Received: by 2002:a17:906:2b19:: with SMTP id a25mr6505421ejg.134.1610729643942;
        Fri, 15 Jan 2021 08:54:03 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id k22sm2483906eji.101.2021.01.15.08.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:54:03 -0800 (PST)
Date:   Fri, 15 Jan 2021 17:54:02 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 08/10] netdevsim: create devlink line card
 object and implement provisioning
Message-ID: <20210115165402.GR3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113121222.733517-9-jiri@resnulli.us>
 <20210115163058.GF2064789@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115163058.GF2064789@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 15, 2021 at 05:30:58PM CET, idosch@idosch.org wrote:
>On Wed, Jan 13, 2021 at 01:12:20PM +0100, Jiri Pirko wrote:
>> @@ -977,6 +1012,9 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
>>  	memcpy(attrs.switch_id.id, nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
>>  	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
>>  	devlink_port_attrs_set(devlink_port, &attrs);
>> +	if (nsim_dev_linecard)
>> +		devlink_port_linecard_set(devlink_port,
>> +					  nsim_dev_linecard->devlink_linecard);
>
>Should be fold into devlink_port_attrs_set()
>
>>  	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
>>  				    nsim_dev_port->port_index);
>>  	if (err)
>> @@ -1053,10 +1091,88 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
>>  	return err;
>>  }
>>  
>> +static void nsim_dev_linecard_provision_work(struct work_struct *work)
>> +{
>> +	struct nsim_dev_linecard *nsim_dev_linecard;
>> +	struct nsim_bus_dev *nsim_bus_dev;
>> +	int err;
>> +	int i;
>> +
>> +	nsim_dev_linecard = container_of(work, struct nsim_dev_linecard,
>> +					 provision_work);
>> +
>> +	nsim_bus_dev = nsim_dev_linecard->nsim_dev->nsim_bus_dev;
>> +	for (i = 0; i < nsim_dev_linecard_port_count(nsim_dev_linecard); i++) {
>> +		err = nsim_dev_port_add(nsim_bus_dev, nsim_dev_linecard, i);
>> +		if (err)
>> +			goto err_port_del_all;
>> +	}
>> +	nsim_dev_linecard->provisioned = true;
>> +	devlink_linecard_provision_set(nsim_dev_linecard->devlink_linecard,
>> +				       nsim_dev_linecard->type_index);
>> +	return;
>> +
>> +err_port_del_all:
>> +	for (i--; i >= 0; i--)
>> +		nsim_dev_port_del(nsim_bus_dev, nsim_dev_linecard, i);
>> +	devlink_linecard_provision_clear(nsim_dev_linecard->devlink_linecard);
>> +}
>> +
>> +static int nsim_dev_linecard_provision(struct devlink_linecard *linecard,
>> +				       void *priv, u32 type_index,
>> +				       struct netlink_ext_ack *extack)
>> +{
>> +	struct nsim_dev_linecard *nsim_dev_linecard = priv;
>> +
>> +	nsim_dev_linecard->type_index = type_index;
>> +	INIT_WORK(&nsim_dev_linecard->provision_work,
>> +		  nsim_dev_linecard_provision_work);
>> +	schedule_work(&nsim_dev_linecard->provision_work);
>> +
>> +	return 0;
>> +}
>> +
>> +static void nsim_dev_linecard_unprovision_work(struct work_struct *work)
>> +{
>> +	struct nsim_dev_linecard *nsim_dev_linecard;
>> +	struct nsim_bus_dev *nsim_bus_dev;
>> +	int i;
>> +
>> +	nsim_dev_linecard = container_of(work, struct nsim_dev_linecard,
>> +					 provision_work);
>> +
>> +	nsim_bus_dev = nsim_dev_linecard->nsim_dev->nsim_bus_dev;
>> +	nsim_dev_linecard->provisioned = false;
>> +	devlink_linecard_provision_clear(nsim_dev_linecard->devlink_linecard);
>> +	for (i = 0; i < nsim_dev_linecard_port_count(nsim_dev_linecard); i++)
>> +		nsim_dev_port_del(nsim_bus_dev, nsim_dev_linecard, i);
>> +}
>> +
>> +static int nsim_dev_linecard_unprovision(struct devlink_linecard *linecard,
>> +					 void *priv,
>> +					 struct netlink_ext_ack *extack)
>> +{
>> +	struct nsim_dev_linecard *nsim_dev_linecard = priv;
>> +
>> +	INIT_WORK(&nsim_dev_linecard->provision_work,
>> +		  nsim_dev_linecard_unprovision_work);
>> +	schedule_work(&nsim_dev_linecard->provision_work);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct devlink_linecard_ops nsim_dev_linecard_ops = {
>> +	.supported_types = nsim_dev_linecard_supported_types,
>> +	.supported_types_count = ARRAY_SIZE(nsim_dev_linecard_supported_types),
>> +	.provision = nsim_dev_linecard_provision,
>> +	.unprovision = nsim_dev_linecard_unprovision,
>> +};
>> +
>>  static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
>>  				   unsigned int linecard_index)
>>  {
>>  	struct nsim_dev_linecard *nsim_dev_linecard;
>> +	struct devlink_linecard *devlink_linecard;
>>  	int err;
>>  
>>  	nsim_dev_linecard = kzalloc(sizeof(*nsim_dev_linecard), GFP_KERNEL);
>> @@ -1066,14 +1182,27 @@ static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
>>  	nsim_dev_linecard->linecard_index = linecard_index;
>>  	INIT_LIST_HEAD(&nsim_dev_linecard->port_list);
>>  
>> +	devlink_linecard = devlink_linecard_create(priv_to_devlink(nsim_dev),
>> +						   linecard_index,
>> +						   &nsim_dev_linecard_ops,
>> +						   nsim_dev_linecard);
>> +	if (IS_ERR(devlink_linecard)) {
>> +		err = PTR_ERR(devlink_linecard);
>> +		goto err_linecard_free;
>> +	}
>> +
>> +	nsim_dev_linecard->devlink_linecard = devlink_linecard;
>> +
>>  	err = nsim_dev_linecard_debugfs_init(nsim_dev, nsim_dev_linecard);
>>  	if (err)
>> -		goto err_linecard_free;
>> +		goto err_dl_linecard_destroy;
>>  
>>  	list_add(&nsim_dev_linecard->list, &nsim_dev->linecard_list);
>>  
>>  	return 0;
>>  
>> +err_dl_linecard_destroy:
>> +	devlink_linecard_destroy(devlink_linecard);
>>  err_linecard_free:
>>  	kfree(nsim_dev_linecard);
>>  	return err;
>> @@ -1081,8 +1210,12 @@ static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
>>  
>>  static void __nsim_dev_linecard_del(struct nsim_dev_linecard *nsim_dev_linecard)
>>  {
>> +	struct devlink_linecard *devlink_linecard =
>> +					nsim_dev_linecard->devlink_linecard;
>> +
>>  	list_del(&nsim_dev_linecard->list);
>>  	nsim_dev_linecard_debugfs_exit(nsim_dev_linecard);
>
>What about the delayed work? I believe it can run while you are
>destroying the linecard, so cancel_delayed_work_sync() is needed

Sure, I missed that.


>
>> +	devlink_linecard_destroy(devlink_linecard);
>>  	kfree(nsim_dev_linecard);
>>  }
>>  
>> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
>> index 88b61b9390bf..ab217b361416 100644
>> --- a/drivers/net/netdevsim/netdevsim.h
>> +++ b/drivers/net/netdevsim/netdevsim.h
>> @@ -196,10 +196,14 @@ struct nsim_dev;
>>  
>>  struct nsim_dev_linecard {
>>  	struct list_head list;
>> +	struct devlink_linecard *devlink_linecard;
>>  	struct nsim_dev *nsim_dev;
>>  	struct list_head port_list;
>>  	unsigned int linecard_index;
>>  	struct dentry *ddir;
>> +	bool provisioned;
>> +	u32 type_index;
>> +	struct work_struct provision_work;
>>  };
>>  
>>  struct nsim_dev {
>> -- 
>> 2.26.2
>> 
