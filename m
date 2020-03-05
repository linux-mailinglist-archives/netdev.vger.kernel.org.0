Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1150917A010
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 07:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgCEGlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 01:41:08 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51601 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgCEGlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 01:41:08 -0500
Received: by mail-wm1-f68.google.com with SMTP id a132so4883909wme.1
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 22:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jbQEXbmAd05Rc3vTqXbAj0GnK3PN1THoqKHs56B0a70=;
        b=pTF0/MBiPm+LIRN1JSw9NlgLMafs2huEV+nJYgNl9tIki+4fKrES4ZTy3P+hPaFpyq
         3jDd7EktLA50nyfQk7U+tCPZetrBH67yZcszdCbh+KpND2IfdGakJg7q0wYCsbJVK4xc
         gKUtc9S3ND06alnQsCfroHx0iExq/BUAFFF3tfevK+FlEWrlJyJ3qyEwwx3k1m+8rscu
         DQduwiGHUo/taY3VkPFgvyy7/1N9EOX4Ab+hr1DNyFe7O0ptLJyYylYy/MfXA3dDCBjy
         PYfbk/5UTO8Z4UGG6IXKGmv/EsAN+phC23yfqsBL8sY8givWmx5cSAP5y5vcy8SfJtSk
         C7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jbQEXbmAd05Rc3vTqXbAj0GnK3PN1THoqKHs56B0a70=;
        b=caleMVZO7xMYv3xUuZem2WnVR1SA846nJzidMnum9BtKZM2ZmjISl/YU5aqvXXE7vT
         oJA1q+VhP1LYGCgU4n37tj63m2By4I1oTntwh8cDTEtwdHOByNDJShvvH+O09fooOa5y
         9QmRuud+vD4dxXRx4taSNFy/V851YBmxAZvqreCZXkGS155XbsACyqUkQS+S4r7+7fK3
         T9KHNP7ukC01C29VV2/Uyf01hnOhqwg/f6r23LgJ23ZFqSjAnbA+uVZlzUoNtS2JruNS
         T5h1Fu5SBZw8ibC7N+q+miLDTW6FP1j1oCVAblocdV3kkYJYQD4Vh0ChI+Xqyaz4fFiy
         Wlgw==
X-Gm-Message-State: ANhLgQ25efowa8IxkTlqXbXp39T+PZOgMsRJDbOmK+ZbF6w6CzpBg5Wh
        v7hZaNAJQ4gYzHLjfvvOjNeanKTgps0=
X-Google-Smtp-Source: ADFU+vtLB1L6/0hPmHsWp3Ly15Wq9JoppTwrtvqUAkUqBpJeOYboRdm5a8e5THsyl4M4gCsmOLq5Yw==
X-Received: by 2002:a05:600c:22d6:: with SMTP id 22mr7830963wmg.102.1583390465924;
        Wed, 04 Mar 2020 22:41:05 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l8sm7869087wmj.2.2020.03.04.22.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 22:41:05 -0800 (PST)
Date:   Thu, 5 Mar 2020 07:41:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200305064103.GA7305@nanopsycho.orion>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-15-jacob.e.keller@intel.com>
 <20200302174106.GC2168@nanopsycho>
 <6f0023d0-a151-87f0-db3a-df01b7e6c045@intel.com>
 <20200303093043.GB2178@nanopsycho>
 <861a914b-1e3c-fdb6-a452-96a0b5a5c2c0@intel.com>
 <20200304115818.GA4558@nanopsycho>
 <7bd8a09e-0e6f-afd3-f6a1-3a52d93d2720@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bd8a09e-0e6f-afd3-f6a1-3a52d93d2720@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 04, 2020 at 06:43:02PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 3/4/2020 3:58 AM, Jiri Pirko wrote:
>> Tue, Mar 03, 2020 at 06:51:37PM CET, jacob.e.keller@intel.com wrote:
>>>
>>> Hm. The flow here was about supporting both with and without snapshot
>>> IDs. That will be gone in the next revision and should make the code clear.
>>>
>>> The IDs are stored in the IDR with either a NULL, or a pointer to a
>>> refcount of the number of snapshots currently using them.
>>>
>>> On devlink_region_snapshot_create, the id must have been allocated by
>>> the devlink_region_snapshot_id_get ahead of time by the driver.
>>>
>>> When devlink_region_snapshot_id_get is called, a NULL is inserted into
>>> the IDR at a suitable ID number (i.e. one that does not yet have a
>>> refcount).
>>>
>>> On devlink_region_snapshot_new, the callback for the new command, the ID
>>> must be specified by userspace.
>>>
>>> Both cases, the ID is confirmed to not be in use for that region by
>>> looping over all snapshots and checking to see if one can be found that
>>> has the ID.
>>>
>>> In __devlink_region_snapshot_create, the IDR is checked to see if it is
>>> already used. If so, the refcount is incremented. If there is no
>>> refcount (i.e. the IDR returns NULL), a new refcount is created, set to
>>> 1, and inserted.
>>>
>>> The basic idea is the refcount is "how many snapshots are actually using
>>> this ID". Use of devlink_region_snapshot_id_get can "pre-allocate" an ID
>>> value so that future calls to devlink_region_id_get won't re-use the
>>> same ID number even if no snapshot with that ID has yet been created.
>>>
>>> The refcount isn't actually incremented until the snapshot is created
>>> with that ID.
>>>
>>> Userspace never uses devlink_region_snapshot_id_get now, since it always
>>> requires an ID to be chosen.
>>>
>>> On snapshot delete, the id refcount is reduced, and when it hits zero
>>> the ID is released from the IDR. This way, IDs can be re-used as long as
>>> no remaining snapshots on any region point to them.
>>>
>>> This system enables userspace to simply treat snapshot ids as unique to
>>> each region, and to provide their own values on the command line. It
>>> also preserves the behavior that devlink_region_snapshot_id_get will
>>> never select an ID that is used by any region on that devlink, so that
>>> the id can be safely used for multiple snapshots triggered at the same time.
>>>
>>> This will hopefully be more clear in the next revision.
>> 
>> Okay, I see. The code is a bit harder to follow.
>> 
>
>I'm open to suggestions for better alternatives, or ways to improve code
>legibility.
>
>I want to preserve the following properties:
>
>* devlink_region_snapshot_id_get must choose IDs globally for the whole
>devlink, so that the ID can safely be re-used across multiple regions.
>
>* IDs must be reusable once all snapshots associated with the IDs have
>been removed
>
>* the new DEVLINK_CMD_REGION_NEW must allow userspace to select IDs
>
>* selecting IDs via DEVLINK_CMD_REGION_NEW should not really require the
>user to check more than the current interested snapshot
>
>* userspace should be able to re-use the same ID across multiple regions
>just like devlink_region_snapshot_id_get and driver triggered snapshots

Nope. I believe this is not desired. The point of having the same id for
the multiple regions is that the driver can obtain multiple region
snapshots during single FW event. For user, that it not the case.
For user, it would be 2 separate snapshots in 2 separate times. They
should not have the same ID.


>
>So, in a sense, the IDs must be a combination of both global and local
>to the region. When using an ID, the region must ensure that no more
>than one snapshot on that region uses the id.
>
>However, when selecting a new ID for use via the
>devlink_region_snapshot_id_get(), it must select one that is not yet
>used by *any* region.
>
>That's where the IDR came into use. I'm not a huge fan of this, so maybe
>there's something simpler.
>
>We could just do a brute force search across all regions to find an ID
>that isn't in use by any region snapshot....
>
>Thanks,
>Jake
