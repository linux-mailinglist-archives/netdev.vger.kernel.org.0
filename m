Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130D2674B32
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjATEto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjATEtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:49:16 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E23BD166
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 20:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674189803; x=1705725803;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rns6xuEzx+n8TPeRDars1+BGnGhs0bzC9HTAwJsnDd8=;
  b=YFGppXY3D3Uzodav0JoZAHkfoRLHCQ238z3xT6HRIdobXnsp/snDf2eY
   4/AdX4TztkhTsBCM15H8s5P564VEyNnuS57QLQ4qzcMuKOnIE/JIR+wkD
   IjQFMhkaoRFytMVHaCLrYlHzWJVhJKDCzyIfF9ofJe1tBLh+jQyvOoDs5
   5Bz8JA8ctMDTwvmPvf+2dOqa2HYkXGXmC4Z+d1Mj893gSSLBPc7okQQHQ
   9id5wfBbs9pt5giK4VrgCo1iPGH99cuOdGuxULhtEB/S98LNWClvP3mYo
   qzu2XShavmmqNlxCD+Lgjw51Yjk91QT5tKK8zJ/HdU3eA6rMBI96ZZ9YA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="387629879"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="387629879"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 05:38:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="610061797"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="610061797"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 19 Jan 2023 05:37:58 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIV72-0001Uc-1u;
        Thu, 19 Jan 2023 13:37:52 +0000
Date:   Thu, 19 Jan 2023 21:37:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        habetsm@gmail.com, ecree.xilinx@gmail.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH net-next 4/7] sfc: add devlink port support for ef100
Message-ID: <202301192118.a5QmN0m8-lkp@intel.com>
References: <20230119113140.20208-5-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119113140.20208-5-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230119-193440
patch link:    https://lore.kernel.org/r/20230119113140.20208-5-alejandro.lucero-palau%40amd.com
patch subject: [PATCH net-next 4/7] sfc: add devlink port support for ef100
config: ia64-allyesconfig (https://download.01.org/0day-ci/archive/20230119/202301192118.a5QmN0m8-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/5b06b1ae6605af55ed8127878054f8d69046b83c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230119-193440
        git checkout 5b06b1ae6605af55ed8127878054f8d69046b83c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/net/ethernet/sfc/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/sfc/ef100_rep.c:347:6: warning: no previous prototype for 'ef100_mport_is_pcie_vnic' [-Wmissing-prototypes]
     347 | bool ef100_mport_is_pcie_vnic(struct mae_mport_desc *mport_desc)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~


vim +/ef100_mport_is_pcie_vnic +347 drivers/net/ethernet/sfc/ef100_rep.c

   346	
 > 347	bool ef100_mport_is_pcie_vnic(struct mae_mport_desc *mport_desc)
   348	{
   349		return mport_desc->mport_type == MAE_MPORT_DESC_MPORT_TYPE_VNIC &&
   350		       mport_desc->vnic_client_type == MAE_MPORT_DESC_VNIC_CLIENT_TYPE_FUNCTION;
   351	}
   352	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
