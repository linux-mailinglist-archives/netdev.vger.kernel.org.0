Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC07D587CA8
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236598AbiHBMvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiHBMvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:51:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10701DFC5;
        Tue,  2 Aug 2022 05:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659444682; x=1690980682;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OmAWyGmKcIghX+hLvGMM11Dgc6+5nsQXlAGINkiy/O0=;
  b=ja6gFipYJLXY7hm0g/493EYhCipbpSLAY6wJZ6oAS/as6KQKenxt6BHf
   WBD+rdGGc9+kstWnxu/gsYSA2c+FuSbFohprplVmjEmiBXtzjVQF+SqTU
   uFqinm7V1Y6hfyMkoV1+lkR5FRlOqrj4w74yAUuyblgYazK/rSQuORzah
   cnJiyidtctr9AafvAlHlf2Dcu3IFiNJj/+1ZiUBrDVq3TnOusy/MFObWW
   tj/PlKhOqrqzh+NRUMIxGk71uF0hw9Z5+XSacX62YjKfQo4RG+1VRi+bB
   6buR7X8TJrATH4rv0yhMS4OD+Glg2bHzYMbn2nFYMz+lPomAypxHEsFW7
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="289411276"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="289411276"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 05:51:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="691835530"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Aug 2022 05:51:18 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oIrMk-000G3b-11;
        Tue, 02 Aug 2022 12:51:18 +0000
Date:   Tue, 2 Aug 2022 20:50:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        michael.chan@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca,
        selvin.xavier@broadcom.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH 1/2] net/bnxt: Add auxiliary driver support
Message-ID: <202208022009.CPnSrR8H-lkp@intel.com>
References: <20220724231458.93830-2-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724231458.93830-2-ajit.khaparde@broadcom.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ajit,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master horms-ipvs/master linus/master v5.19 next-20220728]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ajit-Khaparde/Add-Auxiliary-driver-support/20220725-071610
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 502c6f8cedcce7889ccdefeb88ce36b39acd522f
config: riscv-randconfig-c043-20220801 (https://download.01.org/0day-ci/archive/20220802/202208022009.CPnSrR8H-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c93534ee352bf1888f05720b89a915f15d49fc51
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ajit-Khaparde/Add-Auxiliary-driver-support/20220725-071610
        git checkout c93534ee352bf1888f05720b89a915f15d49fc51
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   riscv32-linux-ld: drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.o: in function `.L0 ':
>> bnxt_ulp.c:(.text+0xed2): undefined reference to `auxiliary_device_init'
   riscv32-linux-ld: drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.o: in function `.L248':
>> bnxt_ulp.c:(.text+0xf12): undefined reference to `__auxiliary_device_add'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
