Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18ABB1BE05C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgD2OLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:11:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:1786 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbgD2OLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 10:11:52 -0400
IronPort-SDR: 9hzTE3qOC6J8OzotZq4ETF2ciOkUt6z4zcVfP7UH66EhTVf7YKDlNVUya4/IsdmuV0tavy/lyq
 gv6YIdF3KJ8A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 07:11:52 -0700
IronPort-SDR: mbk4Iuotqc8t3rqP74AkG+azCBzXay7W+dawZyl9tk89l5MLcUB/TfkM+ILtr/d4LbKl3V9b0F
 Y51Iupc4Z7OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="282514662"
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.159.39])
  by fmsmga004.fm.intel.com with ESMTP; 29 Apr 2020 07:11:49 -0700
Date:   Wed, 29 Apr 2020 22:09:54 +0800
From:   Philip Li <philip.li@intel.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     hui.xia@intel.com, Rong Chen <rong.a.chen@intel.com>,
        kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [kbuild-all] Re: [ipsec-next:testing 1/2]
 net/ipv6/esp6.c:144:15: error: implicit declaration of function
 'csum_ipv6_magic'; did you mean 'csum_tcpudp_magic'?
Message-ID: <20200429140954.GA10775@intel.com>
References: <202004232028.daosFvMI%lkp@intel.com>
 <20200427143234.GA113923@bistromath.localdomain>
 <019f7073-d423-8b42-bd76-ca1dba0e65e5@intel.com>
 <20200429132934.GA197315@bistromath.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429132934.GA197315@bistromath.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 03:29:34PM +0200, Sabrina Dubroca wrote:
> 2020-04-28, 08:21:13 +0800, Rong Chen wrote:
> > 
> > 
> > On 4/27/20 10:32 PM, Sabrina Dubroca wrote:
> > > 2020-04-23, 20:02:30 +0800, kbuild test robot wrote:
> > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git testing
> > > > head:   ce37981d9045220810dabcb9cf20a1d86202c76a
> > > > commit: 3fd2d6fdcbb7bcd1fd7110d997fb6ed6eb71dca3 [1/2] xfrm: add support for UDPv6 encapsulation of ESP
> > > > config: c6x-allyesconfig (attached as .config)
> > > > compiler: c6x-elf-gcc (GCC) 9.3.0
> > > > reproduce:
> > > >          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > > >          chmod +x ~/bin/make.cross
> > > >          git checkout 3fd2d6fdcbb7bcd1fd7110d997fb6ed6eb71dca3
> > > >          # save the attached .config to linux build tree
> > > >          COMPILER_INSTALL_PATH=$HOME/0day GCC_VERSION=9.3.0 make.cross ARCH=c6x
> > > This doesn't work for me :(
> > > 
> > > $HOME/0day/gcc-9.3.0-nolibc/c6x-elf/bin/../libexec/gcc/c6x-elf/9.3.0/cc1: error while loading shared libraries: libisl.so.19: cannot open shared object file: No such file or directory
> > > 
> > > 
> > 
> > Hi Sabrina,
> > 
> > You may need to install libisl19.
> 
> Yes, I could probably do that, but I expected those tools to work on
> any system, without having to install additional packages. If I have
> to install some extra stuff on my system (and none of the systems I
> have come with libisl19, so I'd have to mess around quite a bit), it
> makes those tools you provide a lot less convenient to use.
sorry for this, yes, we also notice this is not easy to use, and can't
simply make it work for different user environment. Thus we actually
work on to put libisl.so as part of package (same as you suggested below).

> 
> It would be great if you could rebuild them with libisl integrated, so
> that it doesn't depend on the system anymore.
Thanks for suggestion, we will provide new package tomorrow after member
had verified it.

> 
> Thanks,
> 
> -- 
> Sabrina
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org
