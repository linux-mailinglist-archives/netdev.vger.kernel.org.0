Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F7A2DF831
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 05:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgLUENu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 23:13:50 -0500
Received: from mga06.intel.com ([134.134.136.31]:53629 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgLUENu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Dec 2020 23:13:50 -0500
IronPort-SDR: xA+QjOxGXWbdUsxZjachEfi5Z6vhRkXW1rjp+26oivzwL8Vqi1pJ17HKQyokIaks2UWBMe8nqo
 FE4a+BjV50wg==
X-IronPort-AV: E=McAfee;i="6000,8403,9841"; a="237242128"
X-IronPort-AV: E=Sophos;i="5.78,436,1599548400"; 
   d="scan'208";a="237242128"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2020 20:13:09 -0800
IronPort-SDR: 2e6+EDVG09xs0KSwhSVwh5sUHxPtxNxR4F/gr9Nmmg7qdCXVAYPLifofn2ANDASWfGAS+Fxb2s
 QM7xdpt6x08Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,436,1599548400"; 
   d="scan'208";a="372175808"
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.159.39])
  by orsmga008.jf.intel.com with ESMTP; 20 Dec 2020 20:13:06 -0800
Date:   Mon, 21 Dec 2020 12:09:27 +0800
From:   Philip Li <philip.li@intel.com>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kernel test robot <lkp@intel.com>,
        kuba@kernel.org, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: Re: [kbuild-all] Re: [PATCH net 1/4] net-sysfs: take the rtnl lock
 when storing xps_cpus
Message-ID: <20201221040927.GA26736@intel.com>
References: <20201217162521.1134496-2-atenart@kernel.org>
 <202012182344.1bEcUiOJ-lkp@intel.com>
 <160830788823.3591.10049543791193131034@kwain.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160830788823.3591.10049543791193131034@kwain.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 05:11:28PM +0100, Antoine Tenart wrote:
> That build issue seems unrelated to the patch. The series as a whole
> builds fine according to the same report, and this code is not modified
> by later patches.
Hi Antoine, this is a false positive report, kindly ignore this.
Sorry for inconvenience.

> 
> It looks a lot like this report from yesterday:
> https://www.spinics.net/lists/netdev/msg709132.html
> 
> Which also seemed unrelated to the changes:
> https://www.spinics.net/lists/netdev/msg709264.html
> 
> Thanks!
> Antoine
> 
> Quoting kernel test robot (2020-12-18 16:27:46)
> > Hi Antoine,
> > 
> > I love your patch! Yet something to improve:
> > 
> > [auto build test ERROR on net/master]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Antoine-Tenart/net-sysfs-fix-race-conditions-in-the-xps-code/20201218-002852
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 3ae32c07815a24ae12de2e7838d9d429ba31e5e0
> > config: riscv-randconfig-r014-20201217 (attached as .config)
> > compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project cee1e7d14f4628d6174b33640d502bff3b54ae45)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install riscv cross compiling tool for clang build
> >         # apt-get install binutils-riscv64-linux-gnu
> >         # https://github.com/0day-ci/linux/commit/f989c3dcbe4d9abd1c6c48b34f08c6c0cd9d44b3
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Antoine-Tenart/net-sysfs-fix-race-conditions-in-the-xps-code/20201218-002852
> >         git checkout f989c3dcbe4d9abd1c6c48b34f08c6c0cd9d44b3
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=riscv 
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > Note: the linux-review/Antoine-Tenart/net-sysfs-fix-race-conditions-in-the-xps-code/20201218-002852 HEAD 563d144b47845dea594b409ecf22914b9797cd1e builds fine.
> >       It only hurts bisectibility.
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    /tmp/ics932s401-422897.s: Assembler messages:
> > >> /tmp/ics932s401-422897.s:260: Error: unrecognized opcode `zext.b a1,s11'
> >    /tmp/ics932s401-422897.s:362: Error: unrecognized opcode `zext.b a1,s11'
> >    /tmp/ics932s401-422897.s:518: Error: unrecognized opcode `zext.b a1,s11'
> >    /tmp/ics932s401-422897.s:637: Error: unrecognized opcode `zext.b a1,s11'
> >    /tmp/ics932s401-422897.s:774: Error: unrecognized opcode `zext.b a1,s11'
> >    /tmp/ics932s401-422897.s:893: Error: unrecognized opcode `zext.b a1,s11'
> >    /tmp/ics932s401-422897.s:1021: Error: unrecognized opcode `zext.b a1,s11'
> > >> /tmp/ics932s401-422897.s:1180: Error: unrecognized opcode `zext.b a1,s2'
> >    clang-12: error: assembler command failed with exit code 1 (use -v to see invocation)
> > 
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org
