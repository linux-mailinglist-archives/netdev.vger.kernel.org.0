Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93DE177267
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgCCJar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:30:47 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53010 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbgCCJar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:30:47 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so2261827wmc.2
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 01:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tzWGaVJ5ck4wpI0D7zsUdS61Lh4ViewxNwnckp1goRo=;
        b=xwY8SFj5JlQA+mo8sQkpbN1I14uovNBMHwLWKjy0X13GtA1iinLN9TVEj0HPL8yYBB
         uYaT3pG+eszOrree0K6f9Ym6Rj8+6YlKUWBtWOnYDQNswSnsvjYuXrUBlHRk/AQe5sYV
         SmoPG09VZO8KhNbAWTEcMOVf6pUAv86lItps4TA9hx8KScA+bfi/LNh2L24cD2rhTCgf
         csX9hC6rdkVCZZGFaTp6m8/LC7k2D/Io1WfiNS/H849uSQRt9a6zanzJ0AMIICN3YlUe
         VQSVv6y7l58dbnsduYBZKuoEJ+rlTDH1sQTZkXit/LP/6fLYUe25LE8JFxDGIkNDe7Pp
         Kdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tzWGaVJ5ck4wpI0D7zsUdS61Lh4ViewxNwnckp1goRo=;
        b=YP4v7Rjkxd3Lgvz6pDOM8wppyf7hJLM0LJmww0bCBDIWMXagETx9+70dOxn7di886X
         zQHipuMpe9r6329mh98S9meLJSL2KXhQuCRfZ6/H3lYh0EfsMvJoYSkUG7N04Vs7a6K6
         INlflPk6CpWRaVorbTtvb/JCfIGsjz5kVxaIIee1a6cluVXrMyyDSP6WkfHf9oaGMMGP
         K+86O+GF+yuVFGgpUhJ0G2CiiVv2DBLjeKY5qOsrfKU8LDMcS4YiQ7e7x4pKppUA20fC
         eRjExNKMX5tZ8WIpKXIbI0HRd5oab1tQkDTIcIhibGSao/ZpMEV4SDXJCwzTCpvOC6y4
         /4JQ==
X-Gm-Message-State: ANhLgQ0UykjxqfwjnpXDC9lQ1m+051dMwhYimpT/EdsfV/Bj87ZBW7q3
        g03pQWzR2nszzIgEVGu9QRcU5Q==
X-Google-Smtp-Source: ADFU+vu6zH6iBrVi4yXPXCMbCotFPqWy0nhJPnygA5lt9wJeLIlS3THD/bm+QvssR4y+U4XLqsyBAg==
X-Received: by 2002:a1c:7f87:: with SMTP id a129mr3559859wmd.156.1583227845091;
        Tue, 03 Mar 2020 01:30:45 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id n8sm31389781wrm.46.2020.03.03.01.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 01:30:44 -0800 (PST)
Date:   Tue, 3 Mar 2020 10:30:43 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200303093043.GB2178@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-15-jacob.e.keller@intel.com>
 <20200302174106.GC2168@nanopsycho>
 <6f0023d0-a151-87f0-db3a-df01b7e6c045@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f0023d0-a151-87f0-db3a-df01b7e6c045@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 02, 2020 at 08:38:12PM CET, jacob.e.keller@intel.com wrote:
>On 3/2/2020 9:41 AM, Jiri Pirko wrote:
>> Sat, Feb 15, 2020 at 12:22:13AM CET, jacob.e.keller@intel.com wrote:
>>> Implement support for the DEVLINK_CMD_REGION_NEW command for creating
>>> snapshots. This new command parallels the existing
>>> DEVLINK_CMD_REGION_DEL.
>>>
>>> In order for DEVLINK_CMD_REGION_NEW to work for a region, the new
>>> ".snapshot" operation must be implemented in the region's ops structure.
>>>
>>> The desired snapshot id may be provided. If the requested id is already
>>> in use, an error will be reported. If no id is provided one will be
>>> selected in the same way as a triggered snapshot.
>>>
>>> In either case, the reference count for that id will be incremented
>>> in the snapshot IDR.
>>>
>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>>> ---
>>> .../networking/devlink/devlink-region.rst     | 12 +++-
>>> include/net/devlink.h                         |  6 ++
>>> net/core/devlink.c                            | 72 +++++++++++++++++++
>>> 3 files changed, 88 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>>> index 1a7683e7acb2..a24faf2b6b7a 100644
>>> --- a/Documentation/networking/devlink/devlink-region.rst
>>> +++ b/Documentation/networking/devlink/devlink-region.rst
>>> @@ -20,6 +20,11 @@ address regions that are otherwise inaccessible to the user.
>>> Regions may also be used to provide an additional way to debug complex error
>>> states, but see also :doc:`devlink-health`
>>>
>>> +Regions may optionally support capturing a snapshot on demand via the
>>> +``DEVLINK_CMD_REGION_NEW`` netlink message. A driver wishing to allow
>>> +requested snapshots must implement the ``.snapshot`` callback for the region
>>> +in its ``devlink_region_ops`` structure.
>>> +
>>> example usage
>>> -------------
>>>
>>> @@ -40,8 +45,11 @@ example usage
>>>     # Delete a snapshot using:
>>>     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
>>>
>>> -    # Trigger (request) a snapshot be taken:
>>> -    $ devlink region trigger pci/0000:00:05.0/cr-space
>> 
>> Odd. It is actually "devlink region dump". There is no trigger.
>> 
>> 
>>> +    # Request an immediate snapshot, if supported by the region
>>> +    $ devlink region new pci/0000:00:05.0/cr-space
>> 
>> Without ID? I would personally require snapshot id always. Without it,
>> it looks like you are creating region.
>> 
>
>Not specifying an ID causes the ID to be auto-selected. I suppose
>support for that doesn't need to be kept.

Yeah, I would avoid it.


>
>> 
>>> +
>>> +    # Request an immediate snapshot with a specific id
>>> +    $ devlink region new pci/0000:00:05.0/cr-space snapshot 5
>>>
>>>     # Dump a snapshot:
>>>     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
>>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>>> index 3a5ff6bea143..3cd0ff2040b2 100644
>>> --- a/include/net/devlink.h
>>> +++ b/include/net/devlink.h
>>> @@ -498,10 +498,16 @@ struct devlink_info_req;
>>>  * struct devlink_region_ops - Region operations
>>>  * @name: region name
>>>  * @destructor: callback used to free snapshot memory when deleting
>>> + * @snapshot: callback to request an immediate snapshot. On success,
>>> + *            the data variable must be updated to point to the snapshot data.
>>> + *            The function will be called while the devlink instance lock is
>>> + *            held.
>>>  */
>>> struct devlink_region_ops {
>>> 	const char *name;
>>> 	void (*destructor)(const void *data);
>>> +	int (*snapshot)(struct devlink *devlink, struct netlink_ext_ack *extack,
>>> +			u8 **data);
>> 
>> Please have the same type here and for destructor. "u8 *" I guess.
>> 
>Sure. My only concern would be if that causes a compiler warning when
>passing kfree/vfree to the destructor pointer. Alternatively we could
>use void **data, but it's definitely interpreted as a byte stream by the
>devlink core code.

I see. Leave it as is then.


>
>> 
>>> };
>>>
>>> struct devlink_fmsg;
>>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>>> index 9571063846cc..b5d1b21e5178 100644
>>> --- a/net/core/devlink.c
>>> +++ b/net/core/devlink.c
>>> @@ -4045,6 +4045,71 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
>>> 	return 0;
>>> }
>>>
>>> +static int
>>> +devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
>>> +{
>>> +	struct devlink *devlink = info->user_ptr[0];
>>> +	struct devlink_region *region;
>>> +	const char *region_name;
>>> +	u32 snapshot_id;
>>> +	u8 *data;
>>> +	int err;
>>> +
>>> +	if (!info->attrs[DEVLINK_ATTR_REGION_NAME]) {
>>> +		NL_SET_ERR_MSG_MOD(info->extack, "No region name provided");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
>>> +	region = devlink_region_get_by_name(devlink, region_name);
>>> +	if (!region) {
>>> +		NL_SET_ERR_MSG_MOD(info->extack,
>> 
>> In devlink.c, please don't wrap here.
>> 
>
>For any of these?

Yep.


>
>> 
>>> +				   "The requested region does not exist");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (!region->ops->snapshot) {
>>> +		NL_SET_ERR_MSG_MOD(info->extack,
>>> +				   "The requested region does not support taking an immediate snapshot");
>>> +		return -EOPNOTSUPP;
>>> +	}
>>> +
>>> +	if (region->cur_snapshots == region->max_snapshots) {
>>> +		NL_SET_ERR_MSG_MOD(info->extack,
>>> +				   "The region has reached the maximum number of stored snapshots");
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	if (info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>>> +		/* __devlink_region_snapshot_create will take care of
>>> +		 * inserting the snapshot id into the IDR if necessary.
>>> +		 */
>>> +		snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>>> +
>>> +		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>>> +			NL_SET_ERR_MSG_MOD(info->extack,
>>> +					   "The requested snapshot id is already in use");
>>> +			return -EEXIST;
>>> +		}
>>> +	} else {
>>> +		snapshot_id = __devlink_region_snapshot_id_get(devlink);
>>> +	}
>>> +
>>> +	err = region->ops->snapshot(devlink, info->extack, &data);
>> 
>> Don't you put the "id"? Looks like a leak.
>> 
>
>The id is put into the devlink_region_snapshot_create, the driver code
>doesn't need to know about it as far as I can tell.
>
>Currently the ids are managed by an IDR which stores a reference count
>of how many snapshots use it.
>
>Use of "NULL" is done so that devlink_region_snapshot_id_get can
>"pre-allocate" the ID without assigning snapshots, assuming that a later
>call to the devlink_region_snapshot_create will find that id and create
>or increment it's refcount.
>
>This complexity comes from the fact that the current code requires the
>ability to re-use the same snapshot id for different regions in the same
>devlink. This devlink_region_snapshot_id_get must return IDs which are
>unique across all regions. If a user does DEVLINK_CMD_REGION_NEW with an
>ID, it would only be used by a single snapshot. We need to make sure
>that this doesn't confuse devlink_region_snapshot_id_get. Additionally,
>I wanted to make sure that the snapshot IDs could be re-used once the
>related snapshots have been deleted.

Okay, I see. I'm just worried about possible scenario when user does
alloc up to max of u32 and always hits the error path.


>
>> 
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	err = __devlink_region_snapshot_create(region, data, snapshot_id);
>>> +	if (err)
>>> +		goto err_free_snapshot_data;
>>> +
>>> +	return 0;
>>> +
>>> +err_free_snapshot_data:
>>> +	region->ops->destructor(data);
>>> +	return err;
>>> +}
>>> +
>>> static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
>>> 						 struct devlink *devlink,
>>> 						 u8 *chunk, u32 chunk_size,
>>> @@ -6358,6 +6423,13 @@ static const struct genl_ops devlink_nl_ops[] = {
>>> 		.flags = GENL_ADMIN_PERM,
>>> 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
>>> 	},
>>> +	{
>>> +		.cmd = DEVLINK_CMD_REGION_NEW,
>>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>>> +		.doit = devlink_nl_cmd_region_new,
>>> +		.flags = GENL_ADMIN_PERM,
>>> +		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
>>> +	},
>>> 	{
>>> 		.cmd = DEVLINK_CMD_REGION_DEL,
>>> 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>>> -- 
>>> 2.25.0.368.g28a2d05eebfb
>>>
