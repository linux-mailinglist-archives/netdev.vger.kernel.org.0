Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5EC330809
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 07:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhCHGWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 01:22:12 -0500
Received: from mga06.intel.com ([134.134.136.31]:59554 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234856AbhCHGVp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 01:21:45 -0500
IronPort-SDR: zcuPS3D57P+DwNV/0YwRkmM+7DMFZpAZRmo7xszQmI7SB7t/WqhDCuFcBIE4Jd5ZYE0m10yced
 SXsuRLatg0qg==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="249354282"
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="249354282"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 22:21:41 -0800
IronPort-SDR: gCg4Bklf77IAVK8ZQLJLWqgFnNrw7iUpK+XKXYeiu+0dFww0TM2t48/F7X7g70lDK5S+tZ51KA
 A5Z1YS3YBXgQ==
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="409180330"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 22:21:39 -0800
Received: by lahna (sSMTP sendmail emulation); Mon, 08 Mar 2021 08:21:36 +0200
Date:   Mon, 8 Mar 2021 08:21:36 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Jax Jiang <jax.jiang.007@gmail.com>
Cc:     michael.jamet@intel.com, YehezkelShB@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [BUG] Thunderbolt network package forward speed problem.
Message-ID: <20210308062136.GB2542@lahna.fi.intel.com>
References: <CAGCQqYbjG5_jxsC3+ONTRg=ow8BqWvkau2j4k=Fs+-hzsyYFjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGCQqYbjG5_jxsC3+ONTRg=ow8BqWvkau2j4k=Fs+-hzsyYFjQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Mar 06, 2021 at 11:33:57PM +0800, Jax Jiang wrote:
> Hi!
> Authors of Linux thunderbolt-network driver:
> 
> Problem:
> 
> Thunderbolt network <- Software Router(NUC 11) <- 10G NIC   Speed is normal=
>  about 9-10Gbps
> Thunderbolt network -> Software Router(NUC 11) -> 10G NIC   Speed is super =
> slow about 1Mbps-100Kbps

Have you tried without the 10G NIC? I mean what is the speed you
observe on NUC 11 in both directions?

What the other host is that you connect to NUC 11 over Thunderbolt
cable?

> Thunderbolt network <- Software Router(NUC 11) <- 2.5G NIC(I225-V)   Speed =
> is normal about 2.3-2.4Gbps
> Thunderbolt network -> Software Router(NUC 11) -> 10G NIC   Speed is super =
> slow about 1Mbps-100Kbps
> 
> I have already tested:
> MAC<-> Thunderbolt network <-> Software Router(NUC11)     17Gpbs on both tw=
> o direction.
> 
> Hardware: Intel NUC11 I5
> CPU: Intel TigerLake 1135G7 4Core 8Thread
> OS:  OpenWRT 19.07
> Linux Kernel Version: 5.10.20
> Already Tested Software that have problem: iperf3 smb
> Network Layout:
> 
>  PC(With 2.5G NIC)
> 
>            ^
> 
>            |
> 
>            v
> [macbook pro] <-----thunderbolt 3------------> Software
> Router<---------------> NAS(With 10G NIC)
>                            thunderbolt network         (NUC11 With 10G NIC)
> 
> I met problem like this in some network switch which does not support flow =
> control.
> So I guess maybe thunderbolt-network driver miss flow control support.
> 
> I am try to build a software router with using latest NUC hardware. Use thu=
> nderbolt network to trans 10G NIC card or 2.5G NIC to latest having thunder=
> bolt port laptop or devices. Latest intel mobile chip had internal thunderb=
> olt controller, which is cheaper than previous devices. I think it=1B$B!G=
> =1B(Bs a chance to bring high speed network to general consumer.
> I am a coder but not familiar with Linux kernel source code.
> At same time I am a want to build a cool product geek.
> Any help would be great  ;-)
> 
> Thanks
> 
> A want to build a geek products geek.
> Jax
