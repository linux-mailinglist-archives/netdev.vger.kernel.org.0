Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864093EB954
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbhHMPjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:39:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:11198 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236719AbhHMPjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 11:39:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="212462204"
X-IronPort-AV: E=Sophos;i="5.84,319,1620716400"; 
   d="scan'208";a="212462204"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 08:39:21 -0700
X-IronPort-AV: E=Sophos;i="5.84,319,1620716400"; 
   d="scan'208";a="447082976"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 08:39:20 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mEZH8-009Hgd-AE; Fri, 13 Aug 2021 18:39:14 +0300
Date:   Fri, 13 Aug 2021 18:39:14 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     kernel test robot <lkp@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@lists.01.org, Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 net-next 4/7] ptp_pch: Switch to use
 module_pci_driver() macro
Message-ID: <YRaSIp4ViWvMrCoP@smile.fi.intel.com>
References: <20210813122932.46152-4-andriy.shevchenko@linux.intel.com>
 <202108132237.jJSESPou-lkp@intel.com>
 <YRaMEfTvOCsi40Je@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRaMEfTvOCsi40Je@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 06:13:21PM +0300, Andy Shevchenko wrote:
> On Fri, Aug 13, 2021 at 10:34:17PM +0800, kernel test robot wrote:
> > Hi Andy,
> > 
> > I love your patch! Yet something to improve:
> > 
> > [auto build test ERROR on net-next/master]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Andy-Shevchenko/ptp_pch-use-mac_pton/20210813-203135
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b769cf44ed55f4b277b89cf53df6092f0c9082d0
> > config: nios2-randconfig-r023-20210813 (attached as .config)
> > compiler: nios2-linux-gcc (GCC) 11.2.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://github.com/0day-ci/linux/commit/6c1fff5c80fe8f1a12c20bac2d28ebfa5960bde7
> >         git remote add linux-review https://github.com/0day-ci/linux
> >         git fetch --no-tags linux-review Andy-Shevchenko/ptp_pch-use-mac_pton/20210813-203135
> >         git checkout 6c1fff5c80fe8f1a12c20bac2d28ebfa5960bde7
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross ARCH=nios2 
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> 
> Thanks!
> 
> Definitely I have compiled it in my local branch. I'll check what is the root
> cause of this.

Kconfig misses PCI dependency. I will send a separate patch, there is nothing
to do here.

-- 
With Best Regards,
Andy Shevchenko


