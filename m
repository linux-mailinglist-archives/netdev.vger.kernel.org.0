Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC2C32FFC9
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 10:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhCGJBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 04:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhCGJBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 04:01:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58F7F65135;
        Sun,  7 Mar 2021 09:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615107691;
        bh=abXeTeaXxmOHy8DJsqq2BXjgblFyPZwhgbDWIQERDoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p/TyveCmSOwGkLJUNk1316yo1ByvCPSsLEjPaDvz+YRqLp34PGudsBfIktybVupk4
         afm0rOnM892gt5BE0jMWnCf0CcA17uDlIH2Yg05bQCNJjaHEFt9cPIEfuVKHEQKXBO
         yiBuyTXP4jhoeqPhX2gj8HtHznup8sqkeapWIclVhRm9XPOVcLHLbiEcu2TBt0s4op
         HCVGXW1QHbBnJnb4uO1bl+dryCA33Hq5noHwOm4xTiSIliG0W5AD3myVVmivCh6FkP
         306Xpagy+8IK062+OsI+86fy+xM9Dz5HZjf7Bu03zYFNec7RkxbEz0S5NsA2uMDtIj
         uB2qUxkaYuY+A==
Date:   Sun, 7 Mar 2021 11:01:27 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] vDPA/ifcvf: bump version string to 1.0
Message-ID: <YESWZ0Sjj1YMKETG@unreal>
References: <20210305142000.18521-1-lingshan.zhu@intel.com>
 <20210305142000.18521-4-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305142000.18521-4-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 05, 2021 at 10:20:00PM +0800, Zhu Lingshan wrote:
> This commit bumps ifcvf driver version string to 1.0
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index fd5befc5cbcc..56a0974cf93c 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -14,7 +14,7 @@
>  #include <linux/sysfs.h>
>  #include "ifcvf_base.h"
>
> -#define VERSION_STRING  "0.1"
> +#define VERSION_STRING  "1.0"

Please delete it instead of bumping it.
We are not supposed to use in-kernel version for years already.
https://lore.kernel.org/ksummit-discuss/20170625072423.GR1248@mtr-leonro.local/

Thanks
