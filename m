Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF70944E086
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 03:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbhKLCxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 21:53:05 -0500
Received: from mga06.intel.com ([134.134.136.31]:42865 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhKLCxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 21:53:05 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="293886748"
X-IronPort-AV: E=Sophos;i="5.87,227,1631602800"; 
   d="scan'208";a="293886748"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 18:50:15 -0800
X-IronPort-AV: E=Sophos;i="5.87,227,1631602800"; 
   d="scan'208";a="504704447"
Received: from kgovindx-mobl.gar.corp.intel.com ([10.215.132.152])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 18:50:08 -0800
Message-ID: <3fc8f690b25cca5b86f23c8285fd9e90d76c9e96.camel@linux.intel.com>
Subject: Re: 32bit x86 build broken (was: Re: [GIT PULL] Networking for
 5.16-rc1)
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-can@vger.kernel.org
Date:   Thu, 11 Nov 2021 18:50:02 -0800
In-Reply-To: <20211111174654.3d1f83e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211111163301.1930617-1-kuba@kernel.org>
         <163667214755.13198.7575893429746378949.pr-tracker-bot@kernel.org>
         <20211111174654.3d1f83e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-11-11 at 17:46 -0800, Jakub Kicinski wrote:
> On Thu, 11 Nov 2021 23:09:07 +0000 pr-tracker-bot@kernel.org wrote:
> > The pull request you sent on Thu, 11 Nov 2021 08:33:01 -0800:
> > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> > > tags/net-5.16-rc1  
> > 
> > has been merged into torvalds/linux.git:
> > https://git.kernel.org/torvalds/c/f54ca91fe6f25c2028f953ce82f19ca2ea0f07bb
> 
> Rafael, Srinivas, we're getting 32 bit build failures after pulling
> back
> from Linus today.
> 
> make[1]: *** [/home/nipa/net/Makefile:1850: drivers] Error 2
> make: *** [Makefile:219: __sub-make] Error 2
> ../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c: In
> function ‘send_mbox_cmd’:
> ../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c:79:37
> : error: implicit declaration of function ‘readq’; did you mean
> ‘readl’? [-Werror=implicit-function-declaration]
>    79 |                         *cmd_resp = readq((void __iomem *)
> (proc_priv->mmio_base + MBOX_OFFSET_DATA));
>       |                                     ^~~~~
>       |                                     readl
> 
> Is there an ETA on getting this fixed?
There is already a patch submitted titled "thermal/drivers/int340x:
limit Kconfig to 64-bit""

Thanks,
Srinivas


> 


