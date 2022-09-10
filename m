Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763A65B45AC
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 11:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiIJJaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 05:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIJJaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 05:30:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B162A26A;
        Sat, 10 Sep 2022 02:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662802198; x=1694338198;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5wlmV5aE837AvNzf0l+rcscxCvhVzY75vCwNE7YMGt0=;
  b=jX4MJYfrfmOSGKPJw9dhTW60TfFg9i5VZZvtulzhYvJtHdHLJc5VuyI7
   WHExgfPvtblQnB9nBtxg6MedJCXEbKOAAWx2BqNLHhSXDNc6CHAspudvt
   ykLRvb9RBgGWIxNzlsKttkEESq4RPeO52cZ5Bfy9XrJ2dybvsvTJXx2lu
   766bJOA/5fSHwNGONv3diKMQkR7Gt/UdkzIC1s2nEZz5n8/+LpRA/Vi8h
   jOXhtQurf9uKVJmmgabj7UZ7EAgUktmAcGb36uKDxMwyag/KGhRoU0V2x
   mQg+0oJ6N4YAf571sAITS5ETyhv90rbfQSz+v4fm/eHDBNxv0eZuhfLrn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10465"; a="277363710"
X-IronPort-AV: E=Sophos;i="5.93,305,1654585200"; 
   d="scan'208";a="277363710"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2022 02:29:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,305,1654585200"; 
   d="scan'208";a="757863952"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 10 Sep 2022 02:29:55 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWwoA-0002MH-0y;
        Sat, 10 Sep 2022 09:29:50 +0000
Date:   Sat, 10 Sep 2022 17:29:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] pci_ids: Add the various Microsoft PCI device IDs
Message-ID: <202209101746.0OMdsFGk-lkp@intel.com>
References: <1662749425-3037-3-git-send-email-eahariha@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1662749425-3037-3-git-send-email-eahariha@linux.microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Easwar,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on next-20220909]
[cannot apply to drm-misc/drm-misc-next helgaas-pci/next linus/master v6.0-rc4 v6.0-rc3 v6.0-rc2 v6.0-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Easwar-Hariharan/hv-Use-PCI_VENDOR_ID_MICROSOFT-for-better-discoverability/20220910-035101
base:    9a82ccda91ed2b40619cb3c10d446ae1f97bab6e
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220910/202209101746.0OMdsFGk-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/68683df33cefc1108eaa8a0a2857e2f2148231d1
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Easwar-Hariharan/hv-Use-PCI_VENDOR_ID_MICROSOFT-for-better-discoverability/20220910-035101
        git checkout 68683df33cefc1108eaa8a0a2857e2f2148231d1
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/hv/vmbus_drv.c: In function 'vmbus_reserve_fb':
>> drivers/hv/vmbus_drv.c:2278:39: error: 'PCI_DEVICE_ID_HYPERV_VIDEO' undeclared (first use in this function); did you mean 'PCI_DEVICE_ID_NS_GX_VIDEO'?
    2278 |                                       PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
         |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                       PCI_DEVICE_ID_NS_GX_VIDEO
   drivers/hv/vmbus_drv.c:2278:39: note: each undeclared identifier is reported only once for each function it appears in


vim +2278 drivers/hv/vmbus_drv.c

7f163a6fd957a8 Jake Oshins      2015-08-05  2265  
6d146aefbaa5c5 Jake Oshins      2016-04-05  2266  static void vmbus_reserve_fb(void)
6d146aefbaa5c5 Jake Oshins      2016-04-05  2267  {
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2268  	resource_size_t start = 0, size;
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2269  	struct pci_dev *pdev;
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2270  
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2271  	if (efi_enabled(EFI_BOOT)) {
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2272  		/* Gen2 VM: get FB base from EFI framebuffer */
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2273  		start = screen_info.lfb_base;
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2274  		size = max_t(__u32, screen_info.lfb_size, 0x800000);
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2275  	} else {
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2276  		/* Gen1 VM: get FB base from PCI */
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2277  		pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27 @2278  				      PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2279  		if (!pdev)
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2280  			return;
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2281  
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2282  		if (pdev->resource[0].flags & IORESOURCE_MEM) {
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2283  			start = pci_resource_start(pdev, 0);
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2284  			size = pci_resource_len(pdev, 0);
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2285  		}
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2286  
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2287  		/*
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2288  		 * Release the PCI device so hyperv_drm or hyperv_fb driver can
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2289  		 * grab it later.
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2290  		 */
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2291  		pci_dev_put(pdev);
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2292  	}
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2293  
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2294  	if (!start)
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2295  		return;
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2296  
6d146aefbaa5c5 Jake Oshins      2016-04-05  2297  	/*
6d146aefbaa5c5 Jake Oshins      2016-04-05  2298  	 * Make a claim for the frame buffer in the resource tree under the
6d146aefbaa5c5 Jake Oshins      2016-04-05  2299  	 * first node, which will be the one below 4GB.  The length seems to
6d146aefbaa5c5 Jake Oshins      2016-04-05  2300  	 * be underreported, particularly in a Generation 1 VM.  So start out
6d146aefbaa5c5 Jake Oshins      2016-04-05  2301  	 * reserving a larger area and make it smaller until it succeeds.
6d146aefbaa5c5 Jake Oshins      2016-04-05  2302  	 */
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2303  	for (; !fb_mmio && (size >= 0x100000); size >>= 1)
2a8a8afba0c305 Vitaly Kuznetsov 2022-08-27  2304  		fb_mmio = __request_region(hyperv_mmio, start, size, fb_mmio_name, 0);
6d146aefbaa5c5 Jake Oshins      2016-04-05  2305  }
6d146aefbaa5c5 Jake Oshins      2016-04-05  2306  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
