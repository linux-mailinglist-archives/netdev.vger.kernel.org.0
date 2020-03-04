Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81BA1178FF6
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 12:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387979AbgCDL6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 06:58:24 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35555 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbgCDL6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 06:58:23 -0500
Received: by mail-wm1-f65.google.com with SMTP id m3so1588751wmi.0
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 03:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pJHiqHOAOc4evIyPtwrTyNhlLTguq6UaSZT4FMZzYpc=;
        b=XjLJCLyzIzcO/fkSNn8zYDx0ygTOlSDvgnLf7I8rTQtHpf6+YK4iwHFH6UaJ9Vq/1f
         Ve+R10Ta1opsbzDMeHFblXeEDBpJIeZpYlfEtVsdaIYFOZd9NUqk1VZ+F0+3Pm/ZkYZf
         tKL05pN6LB0hvMZ6cPHnXam+g8p/rvD9y9us+U2qzD3E84+HTtJ8qYqjsdyJxijbvXxf
         7xJTLV9Kb+TlpgtI5ax90EeNFrG4fLsT9tDTza70OyeOwMIKD1UexnpUhJ7+npHam6LG
         LZO9ihHIQ2J6uoDH9OiOPdOdDgDMefPQxV5OEH05fV+ywbJG5DaTlBv0CHAbaCZcxlzS
         ylQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pJHiqHOAOc4evIyPtwrTyNhlLTguq6UaSZT4FMZzYpc=;
        b=Lqly/RCeSXAeSRV+6sTeo8wGZ/HXnsNaOkKW5gzvuApkdFclz78atcADb4WBy5JbAN
         M6pgNel88v28pnQj2oCinNa042U/VGRGmZdYUGfrqpjODdaJci5OPc7W5bj0OWMJYhuj
         gdp7cpGqbOvAafmTDF5eMNDyZojKXiV361qW8EIj8Fe/V6ZPS8l5FgXqg5RxumRzGaay
         Iw2xSmGFCHCDWpvVD0BEiZI6p2vWl+lGSymiN7wBsP7S2qv4QmbW02ydXastJmkUXMXg
         SSCm+Kmg/RWfbj3HmiajVSAsCxG6VR7xMZoEKYbHtgcPTpvIH2hzuRwvbVz2yzSHSM1s
         ciaw==
X-Gm-Message-State: ANhLgQ1IA8pz00jIQaayTg/aJc+8bCH67Q5pkuYFm2I2LGoq5n9Jtseq
        y+gdXCz0xQzYhX1kOKFlrSnHTg==
X-Google-Smtp-Source: ADFU+vugRKRy6b4Xt1PjoMYqMU1d2pzl8X5Zm+rL4em3tjCi2/4bmjSxWp8sV8Ksp5vf2et+dcqXeg==
X-Received: by 2002:a1c:7419:: with SMTP id p25mr3507476wmc.159.1583323099801;
        Wed, 04 Mar 2020 03:58:19 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id p17sm36247027wre.89.2020.03.04.03.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 03:58:19 -0800 (PST)
Date:   Wed, 4 Mar 2020 12:58:18 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200304115818.GA4558@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-15-jacob.e.keller@intel.com>
 <20200302174106.GC2168@nanopsycho>
 <6f0023d0-a151-87f0-db3a-df01b7e6c045@intel.com>
 <20200303093043.GB2178@nanopsycho>
 <861a914b-1e3c-fdb6-a452-96a0b5a5c2c0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861a914b-1e3c-fdb6-a452-96a0b5a5c2c0@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 03, 2020 at 06:51:37PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 3/3/2020 1:30 AM, Jiri Pirko wrote:
>> Mon, Mar 02, 2020 at 08:38:12PM CET, jacob.e.keller@intel.com wrote:
>>> On 3/2/2020 9:41 AM, Jiri Pirko wrote:
>>>> Without ID? I would personally require snapshot id always. Without it,
>>>> it looks like you are creating region.
>>>>
>>>
>>> Not specifying an ID causes the ID to be auto-selected. I suppose
>>> support for that doesn't need to be kept.
>> 
>> Yeah, I would avoid it.
>> 
>> 
>
>Done.
>
>>>> Please have the same type here and for destructor. "u8 *" I guess.
>>>>
>>> Sure. My only concern would be if that causes a compiler warning when
>>> passing kfree/vfree to the destructor pointer. Alternatively we could
>>> use void **data, but it's definitely interpreted as a byte stream by the
>>> devlink core code.
>> 
>> I see. Leave it as is then.
>> 
>
>Ok.
>
>
>>>> In devlink.c, please don't wrap here.
>>>>
>>>
>>> For any of these?
>> 
>> Yep.
>> 
>
>Done.
>
>> 
>>>
>>>>
>>>>> +				   "The requested region does not exist");
>>>>> +		return -EINVAL;
>>>>> +	}
>>>>> +
>>>>> +	if (!region->ops->snapshot) {
>>>>> +		NL_SET_ERR_MSG_MOD(info->extack,
>>>>> +				   "The requested region does not support taking an immediate snapshot");
>>>>> +		return -EOPNOTSUPP;
>>>>> +	}
>>>>> +
>>>>> +	if (region->cur_snapshots == region->max_snapshots) {
>>>>> +		NL_SET_ERR_MSG_MOD(info->extack,
>>>>> +				   "The region has reached the maximum number of stored snapshots");
>>>>> +		return -ENOMEM;
>>>>> +	}
>>>>> +
>>>>> +	if (info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>>>>> +		/* __devlink_region_snapshot_create will take care of
>>>>> +		 * inserting the snapshot id into the IDR if necessary.
>>>>> +		 */
>>>>> +		snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>>>>> +
>>>>> +		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>>>>> +			NL_SET_ERR_MSG_MOD(info->extack,
>>>>> +					   "The requested snapshot id is already in use");
>>>>> +			return -EEXIST;
>>>>> +		}
>>>>> +	} else {
>>>>> +		snapshot_id = __devlink_region_snapshot_id_get(devlink);
>>>>> +	}
>>>>> +
>>>>> +	err = region->ops->snapshot(devlink, info->extack, &data);
>>>>
>>>> Don't you put the "id"? Looks like a leak.
>>>>
>>>
>>> The id is put into the devlink_region_snapshot_create, the driver code
>>> doesn't need to know about it as far as I can tell.
>>>
>>> Currently the ids are managed by an IDR which stores a reference count
>>> of how many snapshots use it.
>>>
>>> Use of "NULL" is done so that devlink_region_snapshot_id_get can
>>> "pre-allocate" the ID without assigning snapshots, assuming that a later
>>> call to the devlink_region_snapshot_create will find that id and create
>>> or increment it's refcount.
>>>
>>> This complexity comes from the fact that the current code requires the
>>> ability to re-use the same snapshot id for different regions in the same
>>> devlink. This devlink_region_snapshot_id_get must return IDs which are
>>> unique across all regions. If a user does DEVLINK_CMD_REGION_NEW with an
>>> ID, it would only be used by a single snapshot. We need to make sure
>>> that this doesn't confuse devlink_region_snapshot_id_get. Additionally,
>>> I wanted to make sure that the snapshot IDs could be re-used once the
>>> related snapshots have been deleted.
>> 
>> Okay, I see. I'm just worried about possible scenario when user does
>> alloc up to max of u32 and always hits the error path.
>> 
>
>Hm. The flow here was about supporting both with and without snapshot
>IDs. That will be gone in the next revision and should make the code clear.
>
>The IDs are stored in the IDR with either a NULL, or a pointer to a
>refcount of the number of snapshots currently using them.
>
>On devlink_region_snapshot_create, the id must have been allocated by
>the devlink_region_snapshot_id_get ahead of time by the driver.
>
>When devlink_region_snapshot_id_get is called, a NULL is inserted into
>the IDR at a suitable ID number (i.e. one that does not yet have a
>refcount).
>
>On devlink_region_snapshot_new, the callback for the new command, the ID
>must be specified by userspace.
>
>Both cases, the ID is confirmed to not be in use for that region by
>looping over all snapshots and checking to see if one can be found that
>has the ID.
>
>In __devlink_region_snapshot_create, the IDR is checked to see if it is
>already used. If so, the refcount is incremented. If there is no
>refcount (i.e. the IDR returns NULL), a new refcount is created, set to
>1, and inserted.
>
>The basic idea is the refcount is "how many snapshots are actually using
>this ID". Use of devlink_region_snapshot_id_get can "pre-allocate" an ID
>value so that future calls to devlink_region_id_get won't re-use the
>same ID number even if no snapshot with that ID has yet been created.
>
>The refcount isn't actually incremented until the snapshot is created
>with that ID.
>
>Userspace never uses devlink_region_snapshot_id_get now, since it always
>requires an ID to be chosen.
>
>On snapshot delete, the id refcount is reduced, and when it hits zero
>the ID is released from the IDR. This way, IDs can be re-used as long as
>no remaining snapshots on any region point to them.
>
>This system enables userspace to simply treat snapshot ids as unique to
>each region, and to provide their own values on the command line. It
>also preserves the behavior that devlink_region_snapshot_id_get will
>never select an ID that is used by any region on that devlink, so that
>the id can be safely used for multiple snapshots triggered at the same time.
>
>This will hopefully be more clear in the next revision.

Okay, I see. The code is a bit harder to follow.
