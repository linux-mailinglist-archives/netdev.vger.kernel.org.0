Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44B3193989
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgCZHXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:23:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52226 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgCZHXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:23:11 -0400
Received: by mail-wm1-f66.google.com with SMTP id z18so5346233wmk.2
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 00:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MNvXtnT+xyFwvIDr8hh1XE09R7z2fXEA7UA4Fkgmo8o=;
        b=crQm9199sS/27BZlMRJZHycTNRxXawLywgT2ZdApIgMMa/V3jNBvP1zpNEZikpaz/W
         8JZUz7cdVAMioh3XH+sL+tuLSSMdMUswKrsyKcZ25MdzDibWDWvpOSQbTeXmb/k5Et2d
         kZnQstsZTmEOpBqiP9UlqJmSsbDSxQH/jiU2OkSsTlZuy0YQTRVqXwmyrCTc+17lwYUS
         mIuVb+tvr3bKL3pOEYtg6rvHa2Twpr8BTccDkuBk6+CwJe13ARCT9pRGOTV80bEz4LXY
         kXDH2xmbMgjkG9GJ/GL/sTidtxdKHLln6pyQUcLZDq3p7FhgB7wZymmnoB5E6ESFDPif
         lfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MNvXtnT+xyFwvIDr8hh1XE09R7z2fXEA7UA4Fkgmo8o=;
        b=OvOkgiCpmeoblURE6MiQHgi4vd2mkzu4O6K9PiHElkzNY4jHABLiHszEPtKD+s3wHs
         NufvMwzKCGh0IuuHsj02mF+YyFKKoMUF8nZ5rBmsVEGrwHgXUPu68fyZSJX1RaSJIJiE
         zxBm6GhZBmwwa2m+bAMShcyLA6JJ38OS+joaXl+s54d94DxgTUNye9Su35lmIvQatXJO
         uazk60Ricu6uqOMwqFXBR2Su79s1KYj9PEVSLSmTo7TZffqXcIWhew3EuGoMN3dk8jks
         eJS5DL32SlODUjq33gSeQrDX2aEUVK7/ZECI/qT38hMpBrIQ2p23QTQ0YS0giCupriEr
         wXIg==
X-Gm-Message-State: ANhLgQ1faLgtRx91tjN3EUMuZMKs4+hTGjhECBsFZ3qWEHanuOqiyGio
        Yz5zYmQMKY/Xsy+SWocQVFDD1ZL/uG0=
X-Google-Smtp-Source: ADFU+vs6tumNeSZ/vY1mGhyjU7IKdvrXmC7lcV8FQkThVM4L0JF83z5AI5PHVJjrvXcSyFuFOxdQjQ==
X-Received: by 2002:a1c:4d0c:: with SMTP id o12mr1602753wmh.119.1585207389135;
        Thu, 26 Mar 2020 00:23:09 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r3sm2309841wrm.35.2020.03.26.00.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 00:23:08 -0700 (PDT)
Date:   Thu, 26 Mar 2020 08:23:07 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 00/11] implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200326072307.GG11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326035157.2211090-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 04:51:46AM CET, jacob.e.keller@intel.com wrote:
>This is a second revision of the previous series to implement the
>DEVLINK_CMD_REGION_NEW. The series can be viewed on lore.kernel.org at
>
>https://lore.kernel.org/netdev/20200324223445.2077900-1-jacob.e.keller@intel.com/
>
>This version includes the suggested cleanups from Jakub and Jiri on the
>list, including the following changes, broken out by the v1 patch title.

Jakob. You are missing the cover letter.

You need to include the cover letter in the same way as for v1. The only
thing that changes is that you add a changelog. Or you can just have
changelog per patch.

Please, keep the changelog complete. For v1 you had changelog from RFC.
Keep it.


I suggest to repost to include the cover letter.


>
>Changes to patches since v1:
>
> * devlink: prepare to support region operations
>
>   No changes
>
> * devlink: convert snapshot destructor callback to region op
>
>   No changes
>
> * devlink: trivial: fix tab in function documentation
>
>   No changes
>
> * devlink: add function to take snapshot while locked
>
>   Added Jakub's Reviewed-by tag.
>
> * <NEW> devlink: use -ENOSPC to indicate no more room for snapshots
>
>   New patch added to convert confusing -ENOMEM to -ENOSPC, as suggested by
>   Jiri.
>
> * devlink: extract snapshot id allocation to helper function
>
>   No changes
>
> * devlink: convert snapshot id getter to return an error
>
>   Changed title to "devlink: report error once U32_MAX snapshot ids have
>   been used".
>
>   Refactored this patch to make devlink_region_snapshot_id_get take a
>   pointer to u32, so that the error value and id value are separated. This
>   means that we can remove the INT_MAX limitation on id values.
>
> * devlink: track snapshot id usage count using an xarray
>
>   Fixed the xa_init to use xa_init_flags with XA_FLAGS_ALLOC, so that
>   xa_alloc can properly be used.
>
>   Changed devlink_region_snapshot_id_get to use an initial count of 1
>   instead of 0. Added a new devlink_region_snapshot_id_put function, used
>   to release this initial count. This closes the race condition and issues
>   caused if the driver either doesn't create a snapshot, or if userspace
>   deletes the first snapshot before others are created.
>
>   Used WARN_ON in a few more checks that should not occur, such as if the
>   xarray entry is not a value, or when the id isn't yet in the xarray.
>
>   Removed an unnecessary if (err) { return err; } construction.
>
>   Use xa_limit_32b instead of xa_limit_31b now that we don't return the
>   snapshot id directly.
>
>   Cleanup the label used in __devlink_region_snapshot_create to indicate the
>   failure cause, rather than the cleanup step.
>
>   Removed the unnecessary locking around xa_destroy
>
> * devlink: implement DEVLINK_CMD_REGION_NEW
>
>   Added a WARN_ON to the check in snapshot_id_insert in case the id already
>   exists.
>
>   Removed an unnecessary "if (err) { return err; }" construction
>
>   Use -ENOSPC instead of -ENOMEM when max_snapshots is reached.
>
>   Cleanup label names to match style of the other labels in the file,
>   naming after the failure cause rather than the cleanup step. Also fix a
>   bug in the label ordering.
>
>   Call the new devlink_region_snapshot_id_put function in the mlx4 and
>   netdevsim drivers.
>
> * netdevsim: support taking immediate snapshot via devlink
>
>   Create a local devlink pointer instead of calling priv_to_devlink
>   multiple times.
>
>   Removed previous selftest for devlink region new without a snapshot id,
>   as this is no longer supported. Adjusted and verified that the tests pass
>   now.
>
> * ice: add a devlink region for dumping NVM contents
>
>   Use "dev_err" instead of "dev_warn" for a message about failure to create
>   the devlink region.
>
>Jacob Keller (11):
>  devlink: prepare to support region operations
>  devlink: convert snapshot destructor callback to region op
>  devlink: trivial: fix tab in function documentation
>  devlink: add function to take snapshot while locked
>  devlink: use -ENOSPC to indicate no more room for snapshots
>  devlink: extract snapshot id allocation to helper function
>  devlink: report error once U32_MAX snapshot ids have been used
>  devlink: track snapshot id usage count using an xarray
>  devlink: implement DEVLINK_CMD_REGION_NEW
>  netdevsim: support taking immediate snapshot via devlink
>  ice: add a devlink region for dumping NVM contents
>
> .../networking/devlink/devlink-region.rst     |   8 +
> Documentation/networking/devlink/ice.rst      |  26 ++
> drivers/net/ethernet/intel/ice/ice.h          |   2 +
> drivers/net/ethernet/intel/ice/ice_devlink.c  |  99 +++++
> drivers/net/ethernet/intel/ice/ice_devlink.h  |   3 +
> drivers/net/ethernet/intel/ice/ice_main.c     |   4 +
> drivers/net/ethernet/mellanox/mlx4/crdump.c   |  36 +-
> drivers/net/netdevsim/dev.c                   |  46 ++-
> include/net/devlink.h                         |  33 +-
> net/core/devlink.c                            | 363 +++++++++++++++---
> .../drivers/net/netdevsim/devlink.sh          |  10 +
> 11 files changed, 550 insertions(+), 80 deletions(-)
>
>-- 
>2.24.1
>
