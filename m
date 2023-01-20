Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6416754F6
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjATMs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbjATMs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:48:27 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2163D891DD
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674218885; x=1705754885;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LUBHi1ynB6nfqeRM3/q0ASSVR/uoti55AgThzFFaECE=;
  b=ZmKBCL/wDzUXs7EEj8OTta1vwxMOVjbpdC+IFtLsiyHDe7Qwwk9g7qRr
   lDmeoAHo6Zc9Kj/2WHSS8ZqC16WhFDLbyKXeciifB7vIPGyCLdsR85bwG
   VWCkfM30fJALXmgUaUVvpUXLGb9VqLoxrxLXmlPlQrZvCeEvGlzfh4iRP
   +iwXXrGfujZBkviizp/N4OQ9v7H8A60jsBDFYj2taCPXFmVVAAspVf90P
   UR2tYuKL5BXIxcgS0nMhsumn/m42uFoCBwWC49hclyGGIPDooNanFA17w
   ctOj77W7NMZ9S8e124ws9B9MBGJQcGVyezz6PhQkuijFV2Y4Pabp7WX0/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="313457287"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="313457287"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 04:48:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="660573932"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="660573932"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 20 Jan 2023 04:48:00 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIqoK-0002Ys-0E;
        Fri, 20 Jan 2023 12:48:00 +0000
Date:   Fri, 20 Jan 2023 20:47:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm@gmail.com, ecree.xilinx@gmail.com,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: Re: [PATCH net-next 2/7] sfc: enumerate mports in ef100
Message-ID: <202301202052.7U4BpPHW-lkp@intel.com>
References: <20230119113140.20208-3-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119113140.20208-3-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230119-193440
patch link:    https://lore.kernel.org/r/20230119113140.20208-3-alejandro.lucero-palau%40amd.com
patch subject: [PATCH net-next 2/7] sfc: enumerate mports in ef100
config: i386-randconfig-a015 (https://download.01.org/0day-ci/archive/20230120/202301202052.7U4BpPHW-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1542af777ce523b4aab61fcb7c17d63a68db4cea
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alejandro-lucero-palau-amd-com/sfc-add-devlink-support-for-ef100/20230119-193440
        git checkout 1542af777ce523b4aab61fcb7c17d63a68db4cea
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "efx_ef100_fini_reps" [drivers/net/ethernet/sfc/sfc.ko] undefined!
>> ERROR: modpost: "efx_fini_mae" [drivers/net/ethernet/sfc/sfc.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
