Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6988817B69C
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 07:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgCFGQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 01:16:49 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51100 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgCFGQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 01:16:48 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so1054612wmb.0
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 22:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZsyFni4ZSCxbVjVzRoR+tOHD8Z76Ke5hUpHbmgLlVgQ=;
        b=MheA55DjWCmo1kTHuFfzMgJz2rrAwXKsXBfgvqxvkd0aK74f5AXD1zBPj5UuTbF8sF
         nI1s/cYfOq5BXXOwfnFZNtphm1iPzoRuCHUkq1/b7Ck8F9CcPpzIf8NiGUuPE27iFwGO
         Zd07yQBs3R2e+A5bPi84UNTfGFzF376GyRLn6x9sw9H9/qjbZmWgnblpQgKBEPPhRdnu
         zgM34S1QaiObL5Oi46Wl3dvHA/cKYU8mFqHgTujpd9+KWbaCeeQD2JL5yRzesI6xv7jf
         sWAp8Kp7XwGL5jlWFr7uaI2T5LuTlWn3kAF+HCcMoko4Y4AGMosP1f6LyVODbVCjojyy
         ZGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZsyFni4ZSCxbVjVzRoR+tOHD8Z76Ke5hUpHbmgLlVgQ=;
        b=H6tPnqpU/5RD+O4hZU/MNNSozeWjzbylyfmhAACNS4autk8iE/oXZA7VASwQE+HqZe
         4DMsZcuHf4S0Kdq9EXJYqvhhiZFNw/mqrK3liuORcjR80cc9a190SJPOV3Eo/3nsZlZA
         tiEkw1W1ZayFUQx3jvVslHZl4hqp4DrCI13dRwN1TnFnFl9Zuakp6Zz6ddmYw14XxOKE
         iAwx1v30xdeseXzrWwASMxCsn9t6aUyXQUKhgka3m/3+TRJpb2PPuOHI3FQ8OY0EvPja
         et3P2ZvpPfA1S4F5F8kUSJsmdZ5sg5Z12kEPcJpeJjyudENZpbLM6XCdp3kDsmsX1TG5
         RFYg==
X-Gm-Message-State: ANhLgQ2RBfAyWBKsfo/JEw48R4Rl9+tfROzUqZzj7U8V0i+xsOhB3ROv
        Op0h754blRA2HDeoK1X3jGShl1mRbeI=
X-Google-Smtp-Source: ADFU+vsw24VzpPfjhF/Qr7npCrQR42yQfOQ1fBikDtFgldIi9gssRABaIqjRY/mCfiOFTvzIcbGWxg==
X-Received: by 2002:a05:600c:224e:: with SMTP id a14mr2036497wmm.58.1583475406659;
        Thu, 05 Mar 2020 22:16:46 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a7sm11552803wmj.12.2020.03.05.22.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 22:16:45 -0800 (PST)
Date:   Fri, 6 Mar 2020 07:16:44 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200306061644.GA2260@nanopsycho.orion>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-15-jacob.e.keller@intel.com>
 <20200302174106.GC2168@nanopsycho>
 <6f0023d0-a151-87f0-db3a-df01b7e6c045@intel.com>
 <20200303093043.GB2178@nanopsycho>
 <861a914b-1e3c-fdb6-a452-96a0b5a5c2c0@intel.com>
 <20200304115818.GA4558@nanopsycho>
 <7bd8a09e-0e6f-afd3-f6a1-3a52d93d2720@intel.com>
 <20200305064103.GA7305@nanopsycho.orion>
 <3c593821-2123-9756-fc53-7c61fece015a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c593821-2123-9756-fc53-7c61fece015a@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 05, 2020 at 11:33:17PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 3/4/2020 10:41 PM, Jiri Pirko wrote:
>> Wed, Mar 04, 2020 at 06:43:02PM CET, jacob.e.keller@intel.com wrote:
>>>
>>>
>>> On 3/4/2020 3:58 AM, Jiri Pirko wrote:
>>>> Tue, Mar 03, 2020 at 06:51:37PM CET, jacob.e.keller@intel.com wrote:
>>>>>
>>>>> Hm. The flow here was about supporting both with and without snapshot
>>>>> IDs. That will be gone in the next revision and should make the code clear.
>>>>>
>>>>> The IDs are stored in the IDR with either a NULL, or a pointer to a
>>>>> refcount of the number of snapshots currently using them.
>>>>>
>>>>> On devlink_region_snapshot_create, the id must have been allocated by
>>>>> the devlink_region_snapshot_id_get ahead of time by the driver.
>>>>>
>>>>> When devlink_region_snapshot_id_get is called, a NULL is inserted into
>>>>> the IDR at a suitable ID number (i.e. one that does not yet have a
>>>>> refcount).
>>>>>
>>>>> On devlink_region_snapshot_new, the callback for the new command, the ID
>>>>> must be specified by userspace.
>>>>>
>>>>> Both cases, the ID is confirmed to not be in use for that region by
>>>>> looping over all snapshots and checking to see if one can be found that
>>>>> has the ID.
>>>>>
>>>>> In __devlink_region_snapshot_create, the IDR is checked to see if it is
>>>>> already used. If so, the refcount is incremented. If there is no
>>>>> refcount (i.e. the IDR returns NULL), a new refcount is created, set to
>>>>> 1, and inserted.
>>>>>
>>>>> The basic idea is the refcount is "how many snapshots are actually using
>>>>> this ID". Use of devlink_region_snapshot_id_get can "pre-allocate" an ID
>>>>> value so that future calls to devlink_region_id_get won't re-use the
>>>>> same ID number even if no snapshot with that ID has yet been created.
>>>>>
>>>>> The refcount isn't actually incremented until the snapshot is created
>>>>> with that ID.
>>>>>
>>>>> Userspace never uses devlink_region_snapshot_id_get now, since it always
>>>>> requires an ID to be chosen.
>>>>>
>>>>> On snapshot delete, the id refcount is reduced, and when it hits zero
>>>>> the ID is released from the IDR. This way, IDs can be re-used as long as
>>>>> no remaining snapshots on any region point to them.
>>>>>
>>>>> This system enables userspace to simply treat snapshot ids as unique to
>>>>> each region, and to provide their own values on the command line. It
>>>>> also preserves the behavior that devlink_region_snapshot_id_get will
>>>>> never select an ID that is used by any region on that devlink, so that
>>>>> the id can be safely used for multiple snapshots triggered at the same time.
>>>>>
>>>>> This will hopefully be more clear in the next revision.
>>>>
>>>> Okay, I see. The code is a bit harder to follow.
>>>>
>>>
>>> I'm open to suggestions for better alternatives, or ways to improve code
>>> legibility.
>>>
>>> I want to preserve the following properties:
>>>
>>> * devlink_region_snapshot_id_get must choose IDs globally for the whole
>>> devlink, so that the ID can safely be re-used across multiple regions.
>>>
>>> * IDs must be reusable once all snapshots associated with the IDs have
>>> been removed
>>>
>>> * the new DEVLINK_CMD_REGION_NEW must allow userspace to select IDs
>>>
>>> * selecting IDs via DEVLINK_CMD_REGION_NEW should not really require the
>>> user to check more than the current interested snapshot
>>>
>>> * userspace should be able to re-use the same ID across multiple regions
>>> just like devlink_region_snapshot_id_get and driver triggered snapshots
>> 
>> Nope. I believe this is not desired. The point of having the same id for
>> the multiple regions is that the driver can obtain multiple region
>> snapshots during single FW event. For user, that it not the case.
>> For user, it would be 2 separate snapshots in 2 separate times. They
>> should not have the same ID.
>> 
>
>So users would have to pick an ID that's unique across all regions. Ok.
>
>I think we still need a reference count of how many snapshots are using
>an ID (so that it can be released once all region snapshots using that
>ID are destroyed).
>
>We basically add this complexity even in cases where regions are totally
>independent and never taken together.
>
>One alternative would be to instead create some sort of grouping system,
>but that has even more complication.
>
>Ok. So I think we still need to track IDs using something like the IDR
>with a reference count or similar structure.

I agree.

>
>Using only an IDA doesn't give us the ability to release previously used
>IDs. Because on snapshot delete it has no idea whether another region
>used that ID, so it can't remove it.
>
>Maybe something like IDR with a refcount.. but we'd really like
>something that can exist for some time with a refcount of zero. That's
>what I basically used the NULL trick for in this version.
>
>We can first check if the IDR has the ID when responding to
>DEVLINK_CMD_REGION_NEW, and bail if so. That would enforce that users
>must specify IDs which are unused by any region on the device.

Yes, that I believe is the correct behaviour.


>
>Thanks,
>Jake
