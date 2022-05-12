Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B6852419C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245386AbiELAjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbiELAjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:39:46 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB8D21010D
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652315982; x=1683851982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eH9evj/mXJilD/C9nQjBDzAwef7ApufBYWG8mNnJSXs=;
  b=Lg9i1yQMivyZggwCVZHc57eYpTuc0SFbMaVzKGDs89U7ywL7B6yJ7X8z
   I+7fe5oQ0rrlOZ69ICU9Sw0+M0/oqZ+PhSqe06//iGjbM36cAw5TnEtC+
   Q9cJQz1NREsrz6h4MHABvxdMAlFCTqY0vIaz7dgRaZPDTuUItFxKfa0xS
   NHTrURkI0pLaNdC+pgMVNzb7cLhHeXk9HPCSv6yJsF7zQyWBx5fvpKc1y
   IovS5ADbH/I4Wt2Kskir7+9ghGj/cSK0U9GO5FSRMjb8cB0BkYhknydZ1
   70m/waTNjhV+CvZK5fWVqer6Dv1uBIt2Z048IJuFTelNmvH30nfldoGV9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="268684509"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="268684509"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 17:39:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="624175318"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 11 May 2022 17:39:41 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nowrk-000Jjo-Nd;
        Thu, 12 May 2022 00:39:40 +0000
Date:   Thu, 12 May 2022 08:38:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next 01/14] net: txgbe: Add build support for txgbe
 ethernet driver
Message-ID: <202205120837.ym9aTQJ0-lkp@intel.com>
References: <20220511032659.641834-2-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511032659.641834-2-jiawenwu@trustnetic.com>
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

I love your patch! Perhaps something to improve:

[auto build test WARNING on horms-ipvs/master]
[cannot apply to net-next/master net/master linus/master v5.18-rc6 next-20220511]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/Wangxun-10-Gigabit-Ethernet-Driver/20220511-113032
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220512/202205120837.ym9aTQJ0-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/63bf477b5f111995b0ea1fcf839b7e6b0c06ca55
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/Wangxun-10-Gigabit-Ethernet-Driver/20220511-113032
        git checkout 63bf477b5f111995b0ea1fcf839b7e6b0c06ca55
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:47:6: warning: no previous prototype for 'txgbe_service_event_schedule' [-Wmissing-prototypes]
      47 | void txgbe_service_event_schedule(struct txgbe_adapter *adapter)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c: In function 'txgbe_probe':
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:148:18: warning: variable 'pci_using_dac' set but not used [-Wunused-but-set-variable]
     148 |         int err, pci_using_dac;
         |                  ^~~~~~~~~~~~~


vim +/txgbe_service_event_schedule +47 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c

    46	
  > 47	void txgbe_service_event_schedule(struct txgbe_adapter *adapter)
    48	{
    49		if (!test_bit(__TXGBE_DOWN, &adapter->state) &&
    50		    !test_bit(__TXGBE_REMOVING, &adapter->state) &&
    51		    !test_and_set_bit(__TXGBE_SERVICE_SCHED, &adapter->state))
    52			queue_work(txgbe_wq, &adapter->service_task);
    53	}
    54	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
