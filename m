Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303A0694D93
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjBMRCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjBMRCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:02:33 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1487193EB
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 09:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676307751; x=1707843751;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1gIDNPM5+Uhyw0Y+U+/MRFeoRenpsR2m285BwbGN7Go=;
  b=diMHA43dZXPrg142cqfAFBH6qp3qKYRw+BJj5tCTsQ46GC+9vsL+wDAQ
   la5nPazMsIbqH9mW3dtff9aUMdOu91vSOiXubma79FiX0n8HDBT6KFYNV
   Ym6ioHxtVn6lSTHJ2dp8mXaAK0KngVMOY7xpBYH1HyPFC7tY+qt/c9DPk
   pe+tYTCFraOJKj9XGgaGfY6ESBRsLrHeVfVjJ01FnNh0+4v/u+jS9fGaw
   /any02fgNrDsdFki85vhGob0lRO81l7J/3Wtz8K1rpwZ7MVHvaAXnlwst
   RaoZh+bAWJdlDRlo8kZiPkiFOVWGCups/5DTv5C6hFipHUc/eQH8u4L3U
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314579128"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="314579128"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 09:02:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="699225019"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="699225019"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 13 Feb 2023 09:02:27 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pRcDi-0007tB-20;
        Mon, 13 Feb 2023 17:02:26 +0000
Date:   Tue, 14 Feb 2023 01:02:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Harsh Jain <h.jain@amd.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        thomas.lendacky@amd.com, Raju.Rangoju@amd.com,
        Shyam-sundar.S-k@amd.com, harshjain.prof@gmail.com,
        abhijit.gangurde@amd.com, puneet.gupta@amd.com,
        nikhil.agarwal@amd.com, tarak.reddy@amd.com, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Harsh Jain <h.jain@amd.com>
Subject: Re: [PATCH  6/6]  net: ethernet: efct: Add maintainer, kconfig,
 makefile
Message-ID: <202302140042.eW1R48Z9-lkp@intel.com>
References: <20230210130321.2898-7-h.jain@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210130321.2898-7-h.jain@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harsh,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master horms-ipvs/master linus/master v6.2-rc8 next-20230213]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Harsh-Jain/net-ethernet-efct-New-X3-net-driver/20230210-210711
patch link:    https://lore.kernel.org/r/20230210130321.2898-7-h.jain%40amd.com
patch subject: [PATCH  6/6]  net: ethernet: efct: Add maintainer, kconfig, makefile
config: alpha-randconfig-s042-20230212 (https://download.01.org/0day-ci/archive/20230214/202302140042.eW1R48Z9-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/93ed306161ac0259bd72b14922a7f6af60b3748c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Harsh-Jain/net-ethernet-efct-New-X3-net-driver/20230210-210711
        git checkout 93ed306161ac0259bd72b14922a7f6af60b3748c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=alpha olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302140042.eW1R48Z9-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   drivers/net/ethernet/amd/efct/efct_pci.c: note: in included file:
>> drivers/net/ethernet/amd/efct/efct_io.h:48:54: sparse: sparse: cast removes address space '__iomem' of expression
>> drivers/net/ethernet/amd/efct/efct_io.h:48:63: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got unsigned char [usertype] * @@
   drivers/net/ethernet/amd/efct/efct_io.h:48:63: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/net/ethernet/amd/efct/efct_io.h:48:63: sparse:     got unsigned char [usertype] *
   drivers/net/ethernet/amd/efct/efct_io.h:49:54: sparse: sparse: cast removes address space '__iomem' of expression
   drivers/net/ethernet/amd/efct/efct_io.h:49:63: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got unsigned char [usertype] * @@
   drivers/net/ethernet/amd/efct/efct_io.h:49:63: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/net/ethernet/amd/efct/efct_io.h:49:63: sparse:     got unsigned char [usertype] *
   drivers/net/ethernet/amd/efct/efct_io.h:50:54: sparse: sparse: cast removes address space '__iomem' of expression
   drivers/net/ethernet/amd/efct/efct_io.h:50:63: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got unsigned char [usertype] * @@
   drivers/net/ethernet/amd/efct/efct_io.h:50:63: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/net/ethernet/amd/efct/efct_io.h:50:63: sparse:     got unsigned char [usertype] *
   drivers/net/ethernet/amd/efct/efct_io.h:51:54: sparse: sparse: cast removes address space '__iomem' of expression
   drivers/net/ethernet/amd/efct/efct_io.h:51:63: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got unsigned char [usertype] * @@
   drivers/net/ethernet/amd/efct/efct_io.h:51:63: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/net/ethernet/amd/efct/efct_io.h:51:63: sparse:     got unsigned char [usertype] *

vim +/__iomem +48 drivers/net/ethernet/amd/efct/efct_io.h

83f06a5b784384 Harsh Jain 2023-02-10  40  
83f06a5b784384 Harsh Jain 2023-02-10  41  /* Read a 128-bit CSR, locking as appropriate. */
83f06a5b784384 Harsh Jain 2023-02-10  42  static inline void efct_reado(struct efct_device *efct_dev,
83f06a5b784384 Harsh Jain 2023-02-10  43  			      union efct_oword *value, void __iomem *reg)
83f06a5b784384 Harsh Jain 2023-02-10  44  {
83f06a5b784384 Harsh Jain 2023-02-10  45  	unsigned long flags __maybe_unused;
83f06a5b784384 Harsh Jain 2023-02-10  46  
83f06a5b784384 Harsh Jain 2023-02-10  47  	spin_lock_irqsave(&efct_dev->biu_lock, flags);
83f06a5b784384 Harsh Jain 2023-02-10 @48  	value->u32[0] = (__force __le32)__raw_readl((u8 *)reg + 0);
83f06a5b784384 Harsh Jain 2023-02-10  49  	value->u32[1] = (__force __le32)__raw_readl((u8 *)reg + 4);
83f06a5b784384 Harsh Jain 2023-02-10  50  	value->u32[2] = (__force __le32)__raw_readl((u8 *)reg + 8);
83f06a5b784384 Harsh Jain 2023-02-10  51  	value->u32[3] = (__force __le32)__raw_readl((u8 *)reg + 12);
83f06a5b784384 Harsh Jain 2023-02-10  52  	spin_unlock_irqrestore(&efct_dev->biu_lock, flags);
83f06a5b784384 Harsh Jain 2023-02-10  53  }
83f06a5b784384 Harsh Jain 2023-02-10  54  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
