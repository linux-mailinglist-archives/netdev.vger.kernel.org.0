Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8E433EB3D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 09:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCQIRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 04:17:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:34626 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhCQIRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 04:17:03 -0400
IronPort-SDR: vS5HK3EkLj6IPBhT7afGLqcfEnwNtNCtPYwCpi2oODnqe02rlDIKif6EwJ+xkAgwZIMTWW2pxE
 qK7xDXX52Lag==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="250777314"
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="250777314"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 01:17:02 -0700
IronPort-SDR: e1PsqvAwC9dddgoN84+g4oj0/qAanFPE8+SBfYapaXmFVXe6hG+MSTOERmDRmdDH4HgW/qocrp
 JgAcDh9gH0Cw==
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="412552370"
Received: from chenyu-desktop.sh.intel.com (HELO chenyu-desktop) ([10.239.158.173])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 01:17:00 -0700
Date:   Wed, 17 Mar 2021 16:21:05 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20210317082105.GA163071@chenyu-desktop>
References: <20210317185605.3f9c70cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317185605.3f9c70cc@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,
On Wed, Mar 17, 2021 at 06:56:05PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (sparc64
> defconfig) produced this warning:
> 
> drivers/net/ethernet/intel/e1000e/netdev.c:6926:12: warning: 'e1000e_pm_prepare' defined but not used [-Wunused-function]
>  static int e1000e_pm_prepare(struct device *dev)
>             ^~~~~~~~~~~~~~~~~
> 
> Introduced by commit
> 
>   ccf8b940e5fd ("e1000e: Leverage direct_complete to speed up s2ram")
> 
> CONFIG_PM_SLEEP is not set for this build.
>
Thanks for reporting. I think we need to add the '__maybe_unused' attribute as in case
CONFIG_PM_SLEEP is not set. Tony, it seems that the original v1 patch should eliminate
this warning, could you please help double check and apply that version?

thanks,
Chenyu
 
> -- 
> Cheers,
> Stephen Rothwell


