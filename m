Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E171505A3
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 12:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgBCLuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 06:50:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42201 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgBCLuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 06:50:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id k11so17613650wrd.9
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 03:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p8zeZwTOiMkq3biR5CEstWNRDEfRWIBP/Y87yUyyoOA=;
        b=JJvaH3dDUtIhHUm8jfilfGsPWqtrWkliggPkDLBrYc9aKobTe1KBd+V528x2fduaVa
         rC28bZLeOBialReNvoyVQLLGROIflNRdg5EzE7nXLqVfU+GfQkBbTmjqlK8XT1OpTCJm
         Su2pabknqcN5lclI0XP2OCPRQUewZ+nzLmeTqQkw1M6kmz3owTmf0iGRuwGPPMw14KrJ
         p4BDYRIYfmzKgqizbgGxXM/F9UvfzH7bpd8T7DEDJthn1RTN9eGxHKEbC1dNCAXgnSMm
         qNV+qg169MPJ+ojrNCfH5IhALFvUL6aYN1tbwozrXK6OpytVL5gd7D1uO8A+UXkyE7nH
         i8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p8zeZwTOiMkq3biR5CEstWNRDEfRWIBP/Y87yUyyoOA=;
        b=fgnSHdgYYbzyn42FX8M4RStvXkDNZSnHLDQ06VP5x/agYjoAPo8YAC7AE95raMHdyr
         YaREW2+KYoHLG13RcXH0fh7DKD/aTEAPXKOdBK0xQfJsh8G3FXegd+9Nbox8If6Jpa3l
         Pa2pWMI7v58WTovCkRrJwSVYcImu/I7+Y73piinQT58mVvkVY73QP1bpkrcm4RidYVeW
         +ikn/Hp9cEqV3ssEukVfVyM67FLxzcU1Dk6rqgVEwCp1Ms7x7Oy7l5DVCLSjtQsOlH2B
         3zJBD3D3Xuh8y7mpyezb5Ek8Ull9NYjvRNi7dUr58bsaniCX+jJr/RZqAmPSoq3zCT0P
         7GXA==
X-Gm-Message-State: APjAAAUZ5FReUnYFnKx0Ipu1FhJWuv1l0fGWvGCm18Q572ykylZ/OaYT
        pOGQKKyv3arDvQEBbNO/gC3EoA==
X-Google-Smtp-Source: APXvYqw8N/wmMYBcriMq4imA9mdr2sKers9g1zDu3dYNUhfF7nWosmHk+3WCcFgZ6yCPH2rYVO4F0Q==
X-Received: by 2002:a5d:4a06:: with SMTP id m6mr15099351wrq.155.1580730640101;
        Mon, 03 Feb 2020 03:50:40 -0800 (PST)
Received: from localhost (ip-89-177-6-126.net.upcbroadband.cz. [89.177.6.126])
        by smtp.gmail.com with ESMTPSA id s8sm23768362wrt.57.2020.02.03.03.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 03:50:39 -0800 (PST)
Date:   Mon, 3 Feb 2020 12:50:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        valex@mellanox.com, lihong.yang@intel.com
Subject: Re: [PATCH 03/15] devlink: add operation to take an immediate
 snapshot
Message-ID: <20200203115039.GF2260@nanopsycho>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-4-jacob.e.keller@intel.com>
 <274ca58e-02be-2f55-d83c-e0019f90a74d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <274ca58e-02be-2f55-d83c-e0019f90a74d@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 03, 2020 at 09:19:23AM CET, linyunsheng@huawei.com wrote:
>On 2020/1/31 6:58, Jacob Keller wrote:
>> Add a new devlink command, DEVLINK_CMD_REGION_TAKE_SNAPSHOT. This
>> command is intended to enable userspace to request an immediate snapshot
>> of a region.
>> 
>> Regions can enable support for requestable snapshots by implementing the
>> snapshot callback function in the region's devlink_region_ops structure.
>> 
>> Implementations of this function callback should capture an immediate
>> copy of the data and return it and its destructor in the function
>> parameters. The core devlink code will generate a snapshot ID and create
>> the new snapshot while holding the devlink instance lock.
>
>Does we need a new devlink command to clear the snapshot created by
>DEVLINK_CMD_REGION_TAKE_SNAPSHOT?
>
>It seems the snapshot of a region is only destroyed when unloading
>the driver.

There is existing command to handle this:
devlink region del DEV/REGION snapshot SNAPSHOT_ID

>
>> 
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>>  .../networking/devlink/devlink-region.rst     |  9 +++-
>>  include/net/devlink.h                         |  7 +++
>>  include/uapi/linux/devlink.h                  |  2 +
>>  net/core/devlink.c                            | 46 +++++++++++++++++++
>>  4 files changed, 62 insertions(+), 2 deletions(-)
>> 
>> diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>> index 1a7683e7acb2..262249e6c3fc 100644
>> --- a/Documentation/networking/devlink/devlink-region.rst
>> +++ b/Documentation/networking/devlink/devlink-region.rst
>> @@ -20,6 +20,11 @@ address regions that are otherwise inaccessible to the user.
>>  Regions may also be used to provide an additional way to debug complex error
>>  states, but see also :doc:`devlink-health`
>>  
>> +Regions may optionally support capturing a snapshot on demand via the
>> +``DEVLINK_CMD_REGION_TAKE_SNAPSHOT`` netlink message. A driver wishing to
>> +allow requested snapshots must implement the ``.snapshot`` callback for the
>> +region in its ``devlink_region_ops`` structure.
>> +
>>  example usage
>>  -------------
>>  
>> @@ -40,8 +45,8 @@ example usage
>>      # Delete a snapshot using:
>>      $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
>>  
>> -    # Trigger (request) a snapshot be taken:
>> -    $ devlink region trigger pci/0000:00:05.0/cr-space
>> +    # Request an immediate snapshot, if supported by the region
>> +    $ devlink region snapshot pci/0000:00:05.0/cr-space
>>  
>>      # Dump a snapshot:
>>      $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 4a0baa6903cb..63e954241404 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -498,9 +498,16 @@ typedef void devlink_snapshot_data_dest_t(const void *data);
>>  /**
>>   * struct devlink_region_ops - Region operations
>>   * @name: region name
>> + * @snapshot: callback to request an immediate snapshot. On success,
>> + *            the data and destructor variables must be updated. The function
>> + *            will be called while the devlink instance lock is held.
>>   */
>>  struct devlink_region_ops {
>>  	const char *name;
>> +	int (*snapshot)(struct devlink *devlink,
>> +			struct netlink_ext_ack *extack,
>> +			u8 **data,
>> +			devlink_snapshot_data_dest_t **destructor);
>>  };
>>  
>>  struct devlink_fmsg;
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index ae37fd4d194a..46643c4320b9 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -117,6 +117,8 @@ enum devlink_command {
>>  	DEVLINK_CMD_TRAP_GROUP_NEW,
>>  	DEVLINK_CMD_TRAP_GROUP_DEL,
>>  
>> +	DEVLINK_CMD_REGION_TAKE_SNAPSHOT,
>> +
>>  	/* add new commands above here */
>>  	__DEVLINK_CMD_MAX,
>>  	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index faf4f4c5c539..574008c536fa 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -4109,6 +4109,45 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>>  	return err;
>>  }
>>  
>> +static int devlink_nl_cmd_region_take_snapshot(struct sk_buff *skb,
>> +					       struct genl_info *info)
>> +{
>> +	struct devlink *devlink = info->user_ptr[0];
>> +	devlink_snapshot_data_dest_t *destructor;
>> +	struct devlink_region *region;
>> +	const char *region_name;
>> +	u32 snapshot_id;
>> +	u8 *data;
>> +	int err;
>> +
>> +	if (!info->attrs[DEVLINK_ATTR_REGION_NAME]) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "No region name provided");
>> +		return -EINVAL;
>> +	}
>> +
>> +	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
>> +	region = devlink_region_get_by_name(devlink, region_name);
>> +	if (!region) {
>> +		NL_SET_ERR_MSG_MOD(info->extack,
>> +				   "The requested region does not exist");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!region->ops->snapshot) {
>> +		NL_SET_ERR_MSG_MOD(info->extack,
>> +				   "The requested region does not support taking an immediate snapshot");
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	err = region->ops->snapshot(devlink, info->extack, &data, &destructor);
>> +	if (err)
>> +		return err;
>> +
>> +	snapshot_id = devlink_region_snapshot_id_get_locked(devlink);
>> +	return devlink_region_snapshot_create_locked(region, data, snapshot_id,
>> +						     destructor);
>> +}
>> +
>>  struct devlink_info_req {
>>  	struct sk_buff *msg;
>>  };
>> @@ -6249,6 +6288,13 @@ static const struct genl_ops devlink_nl_ops[] = {
>>  		.flags = GENL_ADMIN_PERM,
>>  		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
>>  	},
>> +	{
>> +		.cmd = DEVLINK_CMD_REGION_TAKE_SNAPSHOT,
>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> +		.doit = devlink_nl_cmd_region_take_snapshot,
>> +		.flags = GENL_ADMIN_PERM,
>> +		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
>> +	},
>>  	{
>>  		.cmd = DEVLINK_CMD_INFO_GET,
>>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> 
>
