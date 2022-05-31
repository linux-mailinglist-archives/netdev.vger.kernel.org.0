Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D45538B9A
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 08:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244386AbiEaGxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 02:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244382AbiEaGxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 02:53:06 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7945D939FB
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 23:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653979982; x=1685515982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=geoRAX1J7UlLZ804yic3TUqIadkaJkALoS3bhYf2uSw=;
  b=idcfDtqLyAWF4/6Pmwbt+u+mlCMz2WLaOs+hX2l0259BkHV4G/jWirsh
   NCJJk1PVlFuVAICNe8vjJwJT4yt6Scn65JyqhZiQ1xnanLCiQ9U0NyghL
   llv1WOYf2jWD2AzevHG9i06ozP902nF4IJBwyPOqtwbCyQNoGU/Fe6AKD
   2NNlOtPBYlkzhO2J2WmM/JsDwHMSmMQ78T+zyZHe/8ZbLsZAe5Rg5bqD4
   cioR0xZZBa6RfoSTL998vFOUSN6M8FeiQ8a6wd3HbOZNlJTAwafwB2ctK
   o0mwQJwp+3d2S0nThv7Rs7butClnqJnvw/7V7w3NXAVC//PFEcl+sq9Fz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="338201716"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="338201716"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 23:53:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="580959499"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2022 23:53:00 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nvvkR-0002RV-7s;
        Tue, 31 May 2022 06:52:59 +0000
Date:   Tue, 31 May 2022 14:52:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next v4] net: txgbe: Add build support for txgbe
Message-ID: <202205311441.65SwYadh-lkp@intel.com>
References: <20220531032640.27678-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531032640.27678-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-txgbe-Add-build-support-for-txgbe/20220531-112035
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7e062cda7d90543ac8c7700fc7c5527d0c0f22ad
config: x86_64-randconfig-a014 (https://download.01.org/0day-ci/archive/20220531/202205311441.65SwYadh-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c825abd6b0198fb088d9752f556a70705bc99dfd)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/52085d783a4667549a5f4224135c71c0a643bec0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-txgbe-Add-build-support-for-txgbe/20220531-112035
        git checkout 52085d783a4667549a5f4224135c71c0a643bec0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/pci/quirks.c:5911:1: error: unterminated function-like macro invocation
   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID,
   ^
   include/linux/pci.h:2087:9: note: macro 'DECLARE_PCI_FIXUP_HEADER' defined here
   #define DECLARE_PCI_FIXUP_HEADER(vendor, device, hook)                  \
           ^
   1 error generated.


vim +5911 drivers/pci/quirks.c

  5898	
  5899	static void quirk_wangxun_set_read_req_size(struct pci_dev *pdev)
  5900	{
  5901		u16 ctl;
  5902	
  5903		pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &ctl);
  5904	
  5905		if (((ctl & PCI_EXP_DEVCTL_READRQ) != PCI_EXP_DEVCTL_READRQ_128B) &&
  5906		    ((ctl & PCI_EXP_DEVCTL_READRQ) != PCI_EXP_DEVCTL_READRQ_256B))
  5907			pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
  5908							   PCI_EXP_DEVCTL_READRQ,
  5909							   PCI_EXP_DEVCTL_READRQ_256B);
  5910	}
> 5911	DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID,

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
