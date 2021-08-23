Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0711D3F4699
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 10:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbhHWI3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 04:29:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:38800 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235442AbhHWI3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 04:29:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10084"; a="239194143"
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="239194143"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 01:29:10 -0700
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="514710673"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 01:29:08 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mI5KI-00CiB3-F8; Mon, 23 Aug 2021 11:29:02 +0300
Date:   Mon, 23 Aug 2021 11:29:02 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kbuild-all@lists.01.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 net-next 4/7] ptp_pch: Switch to use
 module_pci_driver() macro
Message-ID: <YSNcTkCMT5xw9k5v@smile.fi.intel.com>
References: <20210813122932.46152-4-andriy.shevchenko@linux.intel.com>
 <202108132237.jJSESPou-lkp@intel.com>
 <YRaMEfTvOCsi40Je@smile.fi.intel.com>
 <YRaSIp4ViWvMrCoP@smile.fi.intel.com>
 <20210813112312.62f4ac42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813112312.62f4ac42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 11:23:12AM -0700, Jakub Kicinski wrote:
> On Fri, 13 Aug 2021 18:39:14 +0300 Andy Shevchenko wrote:
> > On Fri, Aug 13, 2021 at 06:13:21PM +0300, Andy Shevchenko wrote:
> > > On Fri, Aug 13, 2021 at 10:34:17PM +0800, kernel test robot wrote:

> > > > If you fix the issue, kindly add following tag as appropriate
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > 
> > > Thanks!
> > > 
> > > Definitely I have compiled it in my local branch. I'll check what is the root
> > > cause of this.
> > 
> > Kconfig misses PCI dependency. I will send a separate patch, there is nothing
> > to do here.
> 
> That patch has to be before this one, tho. There is a static inline
> stub for pci_register_driver() etc. if !PCI, but there isn't for
> module_pci_driver(), meaning in builds without PCI this driver used
> to be harmlessly pointless, now it's breaking build.
> 
> Am I missing something?

Because the PCI dependency has been restored, can we now apply this series?

FYI, It was also reported that without PCI dependency and even w/o this path
the build can be broken on some architectures due to other reasons (PCI_IOBASE
is one of them IIRC).

-- 
With Best Regards,
Andy Shevchenko


