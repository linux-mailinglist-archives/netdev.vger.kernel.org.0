Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C63194A45
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgCZVM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:12:57 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:51372 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbgCZVM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:12:57 -0400
Received: by mail-wm1-f48.google.com with SMTP id c187so8738570wme.1
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eXyl/kHCB4AZBmsn0VCd/WJI0vWSsyVV9UlFyNyWWcc=;
        b=uUEBpTMukbKnPrZePwQpi6eeoqSFDo6mbKNZyirZP1dsI7rTrsU606vDGgHF2idxai
         Oc16EipKFBNsvCe+qQ7kBalMaKWEpn7onkhLun85ATjX7kKv/NAbwcEy5mKmT/CTZqCS
         dxJWM4quonmj9+Gh8CPfSWroOn0SRadpllol/wGhzGu1Y067y1yZloTl1LQzoh/iAcYQ
         VBCORQNsm8yKX0r+J67+XouuFM2A5oK1HMpB5aP9AhaVpyYfyZx/OcvXmFQ9hJ3EVPEE
         sOCeqOhE+c39giPXsGv243bLdx0Kjb4SmF7ndyUxaFbp1nS44qzu1nEQo/0GTDMAaO1p
         bTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eXyl/kHCB4AZBmsn0VCd/WJI0vWSsyVV9UlFyNyWWcc=;
        b=VK9u+8I1NXFrx5W7TU/J5KaPUgnD04uEDimBz/eH99bcUeZYwb0ZvIVKdtaaSKl9xj
         XafAX4zNfOskHal3mFwck/9iTgUlncZRMHrc5ogMZMQ3HLZPWz1wQLHwYj8oeLV6HJLq
         eTTkdDrWlHWIJKW3g3tIBedifQsHCS4D2uVqDVJXdc/+Te3ScLXnqacFGtRnFuqBJD5c
         Y2ZcriP1myLZ34VFYl6z+Qq3G4UCyr5hazKMyK0XtDwrNFZcF6qjuZUBeRxZCZkSPUgl
         /0aw+UE81PZbd9CRjBWZhHRVZSIvpD80J99nwPA17PRZBAdVwUK/+nJmN92zfmXuV6Bd
         UZJg==
X-Gm-Message-State: ANhLgQ3jb5tIAMuyERptq88p+2J/9nvM6W61VGxaag1OwovoBQ48RPRv
        QtSB+WrEcEkt8ldu5ra+fv/ECDyQr9o=
X-Google-Smtp-Source: ADFU+vtXsJVUDvFnZki0jPXWGEtRrKue90uZBq2nN5Z/vmHr01Gxe+yLeQIBHuS16RJZACnMQHLW1w==
X-Received: by 2002:adf:e744:: with SMTP id c4mr1654642wrn.133.1585257174784;
        Thu, 26 Mar 2020 14:12:54 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v7sm3178604wrs.96.2020.03.26.14.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 14:12:54 -0700 (PDT)
Date:   Thu, 26 Mar 2020 22:12:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 00/11] implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200326211253.GC11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326075101.GK11304@nanopsycho.orion>
 <5fd22fe6-bdd6-33dd-126e-19b83f34297f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fd22fe6-bdd6-33dd-126e-19b83f34297f@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 05:15:05PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 3/26/2020 12:51 AM, Jiri Pirko wrote:
>>> Changes to patches since v1:
>>>
>>> * devlink: prepare to support region operations
>>>
>>>   No changes
>>>
>>> * devlink: convert snapshot destructor callback to region op
>>>
>>>   No changes
>>>
>>> * devlink: trivial: fix tab in function documentation
>>>
>>>   No changes
>>>
>>> * devlink: add function to take snapshot while locked
>>>
>>>   Added Jakub's Reviewed-by tag.
>>>
>>> * <NEW> devlink: use -ENOSPC to indicate no more room for snapshots
>>>
>>>   New patch added to convert confusing -ENOMEM to -ENOSPC, as suggested by
>>>   Jiri.
>>>
>>> * devlink: extract snapshot id allocation to helper function
>>>
>>>   No changes
>>>
>>> * devlink: convert snapshot id getter to return an error
>>>
>>>   Changed title to "devlink: report error once U32_MAX snapshot ids have
>>>   been used".
>>>
>>>   Refactored this patch to make devlink_region_snapshot_id_get take a
>>>   pointer to u32, so that the error value and id value are separated. This
>>>   means that we can remove the INT_MAX limitation on id values.
>>>
>>> * devlink: track snapshot id usage count using an xarray
>>>
>>>   Fixed the xa_init to use xa_init_flags with XA_FLAGS_ALLOC, so that
>>>   xa_alloc can properly be used.
>>>
>>>   Changed devlink_region_snapshot_id_get to use an initial count of 1
>>>   instead of 0. Added a new devlink_region_snapshot_id_put function, used
>>>   to release this initial count. This closes the race condition and issues
>>>   caused if the driver either doesn't create a snapshot, or if userspace
>>>   deletes the first snapshot before others are created.
>>>
>>>   Used WARN_ON in a few more checks that should not occur, such as if the
>>>   xarray entry is not a value, or when the id isn't yet in the xarray.
>>>
>>>   Removed an unnecessary if (err) { return err; } construction.
>>>
>>>   Use xa_limit_32b instead of xa_limit_31b now that we don't return the
>>>   snapshot id directly.
>>>
>>>   Cleanup the label used in __devlink_region_snapshot_create to indicate the
>>>   failure cause, rather than the cleanup step.
>>>
>>>   Removed the unnecessary locking around xa_destroy
>>>
>>> * devlink: implement DEVLINK_CMD_REGION_NEW
>>>
>>>   Added a WARN_ON to the check in snapshot_id_insert in case the id already
>>>   exists.
>>>
>>>   Removed an unnecessary "if (err) { return err; }" construction
>>>
>>>   Use -ENOSPC instead of -ENOMEM when max_snapshots is reached.
>>>
>>>   Cleanup label names to match style of the other labels in the file,
>>>   naming after the failure cause rather than the cleanup step. Also fix a
>>>   bug in the label ordering.
>>>
>>>   Call the new devlink_region_snapshot_id_put function in the mlx4 and
>>>   netdevsim drivers.
>>>
>>> * netdevsim: support taking immediate snapshot via devlink
>>>
>>>   Create a local devlink pointer instead of calling priv_to_devlink
>>>   multiple times.
>>>
>>>   Removed previous selftest for devlink region new without a snapshot id,
>>>   as this is no longer supported. Adjusted and verified that the tests pass
>>>   now.
>>>
>>> * ice: add a devlink region for dumping NVM contents
>>>
>>>   Use "dev_err" instead of "dev_warn" for a message about failure to create
>>>   the devlink region.
>> 
>> Could you please have the changelog per-patch, as I suggested for v1?
>> Much easier to review then.
>
>What do you mean? I already broke this into a description of the change
>for each patch, I thought that's what you wanted..
>
>Do you want me to move this into the individual commit emails?

Yes, that is what I mean. Much more convenient in my opinion.
