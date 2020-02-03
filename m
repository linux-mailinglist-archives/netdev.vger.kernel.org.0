Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6651505A1
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 12:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgBCLuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 06:50:05 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36233 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgBCLuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 06:50:05 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so16628902wma.1
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 03:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xTso3RQxUOn5T67KLSVEQEPJcvoqzX34xxW/K9/ZFp0=;
        b=xQa7AlUQKL1PC7QnfOMG1hIhRw3e/+O2tdKBEunkLWjdQut73zWEy8oyYdNCJok0vf
         ZDQKdvuQWuROxY9LRss0a9TNibBCEbsWebPSP5BQHtUALIK4NQloQ388Dy7rO2IBQ7M1
         WSGZhHUD5GL4VkdyRTXj+nMGO5b4Mmut/2Y21ynIeFr4hQC4kgWm972hOvqgBWle3Tsr
         MzpomlE71EPURLqtKM6PIzOxvtPzzFbJ7qXZxsv46sw1ufUz6h4TfMB3eIQP5pvXBevw
         m+nYQepmrJ6qT0vfspWlj/KBMXKAF+uF8+eaoiNMrsteGNEZvkbjhYHu709Z4yzYpOZu
         cqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xTso3RQxUOn5T67KLSVEQEPJcvoqzX34xxW/K9/ZFp0=;
        b=KEW24c0fd7408+ot+klhCKJ/vlIRyuc8ZDKXZY3WLEdataVCZMHvQNB1WGjYU/u9mc
         +8P2yFlgzhQV/G9Z3S387FlEn7b7GAL/tr2FdrwvRCsH6gZPKSGAhW2WJlb/5JfTb/1r
         RbWg6MwbgkchKrGiDiTeL7oKvJdAfCEfva15n59BxKRJyZKQUmuVgVFJfz1lIlEWCuLp
         z9wkiyakelWe7DWUN4l3NdVPR4do8fckjqOcZjja2dU+oiqaAIDQLwFUZ20WV341AMOR
         3cGT+E3uuIKGxOpX8CXyHHwWuLrV0oVr0kEFLD17P7rLHnE37CyxISsFHrxW/VuBi14y
         UQFg==
X-Gm-Message-State: APjAAAX+EVaVkPAguto6FJhf/RNQIUGQviw69QLKsVP2KHAfEKUk+j04
        duxVESOb1THtTBH2XTH+GVq2oDJPfGE=
X-Google-Smtp-Source: APXvYqzH1af8H/0uyUsWUg/ErbE1kyTZpCqU/y3UnEL4k4NjDqjTE+M3oq6Nl4pqgFuIE7yPF+JiZw==
X-Received: by 2002:a7b:c750:: with SMTP id w16mr28044856wmk.46.1580730602786;
        Mon, 03 Feb 2020 03:50:02 -0800 (PST)
Received: from localhost (ip-89-177-6-126.net.upcbroadband.cz. [89.177.6.126])
        by smtp.gmail.com with ESMTPSA id r5sm25187874wrt.43.2020.02.03.03.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 03:50:02 -0800 (PST)
Date:   Mon, 3 Feb 2020 12:50:01 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
Subject: Re: [PATCH 03/15] devlink: add operation to take an immediate
 snapshot
Message-ID: <20200203115001.GE2260@nanopsycho>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130225913.1671982-4-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 30, 2020 at 11:58:58PM CET, jacob.e.keller@intel.com wrote:
>Add a new devlink command, DEVLINK_CMD_REGION_TAKE_SNAPSHOT. This
>command is intended to enable userspace to request an immediate snapshot
>of a region.
>
>Regions can enable support for requestable snapshots by implementing the
>snapshot callback function in the region's devlink_region_ops structure.
>
>Implementations of this function callback should capture an immediate
>copy of the data and return it and its destructor in the function
>parameters. The core devlink code will generate a snapshot ID and create
>the new snapshot while holding the devlink instance lock.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> .../networking/devlink/devlink-region.rst     |  9 +++-
> include/net/devlink.h                         |  7 +++
> include/uapi/linux/devlink.h                  |  2 +
> net/core/devlink.c                            | 46 +++++++++++++++++++
> 4 files changed, 62 insertions(+), 2 deletions(-)
>
>diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>index 1a7683e7acb2..262249e6c3fc 100644
>--- a/Documentation/networking/devlink/devlink-region.rst
>+++ b/Documentation/networking/devlink/devlink-region.rst
>@@ -20,6 +20,11 @@ address regions that are otherwise inaccessible to the user.
> Regions may also be used to provide an additional way to debug complex error
> states, but see also :doc:`devlink-health`
> 
>+Regions may optionally support capturing a snapshot on demand via the
>+``DEVLINK_CMD_REGION_TAKE_SNAPSHOT`` netlink message. A driver wishing to
>+allow requested snapshots must implement the ``.snapshot`` callback for the
>+region in its ``devlink_region_ops`` structure.
>+
> example usage
> -------------
> 
>@@ -40,8 +45,8 @@ example usage
>     # Delete a snapshot using:
>     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
> 
>-    # Trigger (request) a snapshot be taken:
>-    $ devlink region trigger pci/0000:00:05.0/cr-space
>+    # Request an immediate snapshot, if supported by the region
>+    $ devlink region snapshot pci/0000:00:05.0/cr-space


Hmm, the shapshot is now removed by user calling:

$ devlink region del DEV/REGION snapshot SNAPSHOT_ID
That is using DEVLINK_CMD_REGION_DEL netlink command calling
devlink_nl_cmd_region_del()

I think the creation should be symmetric. Something like:
$ devlink region add DEV/REGION snapshot SNAPSHOT_ID
SNAPSHOT_ID is either exact number or "any" if user does not care.
The benefit of using user-passed ID value is that you can use this
easily in scripts.

The existing unused netlink command DEVLINK_CMD_REGION_NEW would be used
for this.


> 
>     # Dump a snapshot:
>     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1

[...]
