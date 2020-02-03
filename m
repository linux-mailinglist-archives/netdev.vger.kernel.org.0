Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98CDC1511D1
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 22:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBCVbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 16:31:01 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43400 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgBCVbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 16:31:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id z9so8010114wrs.10
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 13:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xJzSlxyYdKNjxK3XP3gEc+vP/QE0xnB2lOPz0ti8Q/w=;
        b=YpNAiwA8DWFfU3WVBsu7UeXPf6ASA+fvrSnPa2sXptNO1dVQUrB4GslFR0693cUDKU
         K3Odzxv0r6LxAW6AiDMoXI9uqpR9TemHtdjiyYEUjF1GJf5y11JlhTagbNIOLL5z5VGd
         R/4TvvxQGgeUoTVjRXNifg4G7hQhYJS2nY7rxWw0eAH863BzP0aPO0QQSKDKfQH+BrhO
         cNkPgNnkhQ0pYO0eqpnlSIVPSOppO5M3sqgVSIvRKmddU3+w78GjZFEnCyTQRz5ojl7a
         zTRZuwl1wwDLmWcnfRW89kxZjIHyLJTkpJZSG6z/UpNnKE2IhvmGnWXoSpD/8WUVC9sf
         V4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xJzSlxyYdKNjxK3XP3gEc+vP/QE0xnB2lOPz0ti8Q/w=;
        b=LFeO5QroUwCojbnd8X+8uQIxplmn4c/N/+osy6NH3oeIGxO1qLIU5YszQ4IS0VMjjO
         chkH3QDUGIpUMbRtkhACJjJLm/PdwWHshjhdTNH4IqHWr64SIZKzlhMJa5pc1s+gktu3
         qLynkYuVA4fpARcNTtnQ43lQQd7WRDV9BwkEZpYbOttGHlz3FLAx4f2IO4xvbfWRd0z5
         WoTYeoVz05+belRZSFaYzNTmE3mitpAk7cXbEoxEffs5yqujzfw8XQU35zs/33hjoYNP
         ng2wj8OVBI2Ivt1pupLC7+oDhTPAWi+Jfzxp6+El+tVxDst5MzNtN7C15k+xAi3+VZFO
         woNw==
X-Gm-Message-State: APjAAAUlqKksE1aCVNfaYjblDWCnjwiMA+x2OhJ7xmlR3VrJUc6pL5un
        KGjXUYfOKbQTkH1q8foJsMFGow==
X-Google-Smtp-Source: APXvYqwjChqxiKFs2sdJIDXYKjcumeaBV7mDSZNx+HDJQz26sXSgMHbHL236yrypPF35dcCHVEu2cw==
X-Received: by 2002:a5d:61d1:: with SMTP id q17mr18052878wrv.156.1580765458708;
        Mon, 03 Feb 2020 13:30:58 -0800 (PST)
Received: from localhost (ip-89-177-6-126.net.upcbroadband.cz. [89.177.6.126])
        by smtp.gmail.com with ESMTPSA id s1sm18849359wro.66.2020.02.03.13.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 13:30:58 -0800 (PST)
Date:   Mon, 3 Feb 2020 22:30:57 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
Subject: Re: [PATCH 03/15] devlink: add operation to take an immediate
 snapshot
Message-ID: <20200203213057.GJ2260@nanopsycho>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-4-jacob.e.keller@intel.com>
 <20200203115001.GE2260@nanopsycho>
 <6b97b131-65a2-e6d0-779e-d8ab31d5c0ae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b97b131-65a2-e6d0-779e-d8ab31d5c0ae@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 03, 2020 at 08:32:36PM CET, jacob.e.keller@intel.com wrote:
>On 2/3/2020 3:50 AM, Jiri Pirko wrote:
>> Thu, Jan 30, 2020 at 11:58:58PM CET, jacob.e.keller@intel.com wrote:
>>> Add a new devlink command, DEVLINK_CMD_REGION_TAKE_SNAPSHOT. This
>>> command is intended to enable userspace to request an immediate snapshot
>>> of a region.
>>>
>>> Regions can enable support for requestable snapshots by implementing the
>>> snapshot callback function in the region's devlink_region_ops structure.
>>>
>>> Implementations of this function callback should capture an immediate
>>> copy of the data and return it and its destructor in the function
>>> parameters. The core devlink code will generate a snapshot ID and create
>>> the new snapshot while holding the devlink instance lock.
>>>
>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>>> ---
>>> .../networking/devlink/devlink-region.rst     |  9 +++-
>>> include/net/devlink.h                         |  7 +++
>>> include/uapi/linux/devlink.h                  |  2 +
>>> net/core/devlink.c                            | 46 +++++++++++++++++++
>>> 4 files changed, 62 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>>> index 1a7683e7acb2..262249e6c3fc 100644
>>> --- a/Documentation/networking/devlink/devlink-region.rst
>>> +++ b/Documentation/networking/devlink/devlink-region.rst
>>> @@ -20,6 +20,11 @@ address regions that are otherwise inaccessible to the user.
>>> Regions may also be used to provide an additional way to debug complex error
>>> states, but see also :doc:`devlink-health`
>>>
>>> +Regions may optionally support capturing a snapshot on demand via the
>>> +``DEVLINK_CMD_REGION_TAKE_SNAPSHOT`` netlink message. A driver wishing to
>>> +allow requested snapshots must implement the ``.snapshot`` callback for the
>>> +region in its ``devlink_region_ops`` structure.
>>> +
>>> example usage
>>> -------------
>>>
>>> @@ -40,8 +45,8 @@ example usage
>>>     # Delete a snapshot using:
>>>     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
>>>
>>> -    # Trigger (request) a snapshot be taken:
>>> -    $ devlink region trigger pci/0000:00:05.0/cr-space
>>> +    # Request an immediate snapshot, if supported by the region
>>> +    $ devlink region snapshot pci/0000:00:05.0/cr-space
>> 
>> 
>> Hmm, the shapshot is now removed by user calling:
>> 
>> $ devlink region del DEV/REGION snapshot SNAPSHOT_ID
>> That is using DEVLINK_CMD_REGION_DEL netlink command calling
>> devlink_nl_cmd_region_del()
>> 
>> I think the creation should be symmetric. Something like:
>> $ devlink region add DEV/REGION snapshot SNAPSHOT_ID
>> SNAPSHOT_ID is either exact number or "any" if user does not care.
>> The benefit of using user-passed ID value is that you can use this
>> easily in scripts.
>> 
>> The existing unused netlink command DEVLINK_CMD_REGION_NEW would be used
>> for this.
>> 
>
>So I have some concern trying to allow picking the snapshot id. I agree
>it is useful, but want to make sure we pick the best design for how to
>handle things.
>
>Currently regions support taking a snapshot across multiple regions with
>the same ID. this means that the region id value is stored per devlink
>instead of per region.
>
>If users can pick IDs, they can and probably will become sparse. This
>means that we now need to be able to handle this.
>
>If a user picks an ID, we want to ensure that the global region id
>number is incremented properly so that we skip the used IDs, otherwise
>those could accidentally collide.
>
>The simplest solution is to just force the global ID to be 1 larger at a
>minimum every time the userspace calls us with an ID.
>
>But now what happens if a user requests a really large ID (U32_MAX - 1)?
>and then we now overflow our region ID.
>
>This was previously a rare occurrence, but has now become possibly common.
>
>We could require/force the user to pick IDs within a limited range, and
>have the automatic regions come from another range..
>
>We could enhance ID selection to just pick "lowest number unused by any
>region". This would allow re-using ID numbers after they've been
>deleted.. I think this approach is the most robust but does require a
>bit of extra computation.

Check out "ida"

>
>Thanks,
>Jake
