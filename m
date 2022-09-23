Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFE95E7950
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 13:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiIWLUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 07:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiIWLUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 07:20:52 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C930AC9977;
        Fri, 23 Sep 2022 04:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663932051; x=1695468051;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Qbcmzx6oXxdj+twPmsuaKBP/DBj7kMJ9vSNnRiPopw=;
  b=Jx09fmYbd3leCnsaK7ykSyCj+NtQm2vqBxCbKIFhFwrIvXHKKnnKkJC7
   MU3FGa38bsGuL+aZcslHi51Tb00obG1UATZM8ZBOQwVYf2pHR2jruHryr
   FljnNXG27tMWuO7Vzbq5Oq9DhohcYpHaDl3eYoHM3SS7aZyfQDJHBK9LI
   K5hUt7Qr0STjxYU90401nCgM2t3k87WgzuYIOu8HzzG29MgxoDgGPHakx
   7Ft51dckYCQlnaJCtO7dcYfuxJLTxuYG/DLci4O2Pcm3rCoYCSUQdykJt
   t+8kp+EXkOssGlDEqKOz2ne5Yp6skfC8cUjS5LMnqdLd1GOAt8CYVnJtA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="301453230"
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="301453230"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 04:20:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="622489619"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 23 Sep 2022 04:20:47 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1obgjf-0005c0-15;
        Fri, 23 Sep 2022 11:20:47 +0000
Date:   Fri, 23 Sep 2022 19:20:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>, jiri@mellanox.com,
        moshe@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com
Cc:     kbuild-all@lists.01.org, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huangguangbin2@huawei.com, lipeng321@huawei.com,
        chenhao418@huawei.com
Subject: Re: [PATCH net-next 2/2] net: hns3: PF add support setting
 parameters of congestion control algorithm by devlink param
Message-ID: <202209231935.JRvKASjh-lkp@intel.com>
References: <20220923013818.51003-3-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923013818.51003-3-huangguangbin2@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guangbin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Guangbin-Huang/net-hns3-add-support-setting-parameters-of-congestion-control-algorithm-by-devlink-param/20220923-094236
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git bcff1a37bafc144d67192f2f5e1f4b9c49b37bd6
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20220923/202209231935.JRvKASjh-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fc0ab8f22c924e963b0e0a2723cbb49acc1d3bb3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guangbin-Huang/net-hns3-add-support-setting-parameters-of-congestion-control-algorithm-by-devlink-param/20220923-094236
        git checkout fc0ab8f22c924e963b0e0a2723cbb49acc1d3bb3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/net/ethernet/hisilicon/hns3/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c: In function 'hclge_devlink_get_algo_param_value':
>> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c:418:35: warning: variable 'tmp' set but not used [-Wunused-but-set-variable]
     418 |         char *value, *value_tmp, *tmp;
         |                                   ^~~
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c: In function 'hclge_devlink_algo_param_set':
>> drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c:690:13: warning: variable 'cnt' set but not used [-Wunused-but-set-variable]
     690 |         int cnt = 0;
         |             ^~~
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c: In function 'hclge_devlink_is_algo_param_valid':
   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c:727:35: warning: variable 'tmp' set but not used [-Wunused-but-set-variable]
     727 |         char *value, *value_tmp, *tmp;
         |                                   ^~~


vim +/tmp +418 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c

   415	
   416	static int hclge_devlink_get_algo_param_value(const char *str, u64 *param_value)
   417	{
 > 418		char *value, *value_tmp, *tmp;
   419		int ret = 0;
   420		int i;
   421	
   422		value = kmalloc(sizeof(char) * __DEVLINK_PARAM_MAX_STRING_VALUE,
   423				GFP_KERNEL);
   424		if (!value)
   425			return -ENOMEM;
   426	
   427		strncpy(value, str, __DEVLINK_PARAM_MAX_STRING_VALUE);
   428		value_tmp = value;
   429	
   430		tmp = strsep(&value, "@");
   431	
   432		for (i = 0; i < strlen(value); i++) {
   433			if (!(value[i] >= '0' && value[i] <= '9')) {
   434				kfree(value_tmp);
   435				return -EINVAL;
   436			}
   437		}
   438	
   439		ret = kstrtou64(value, 0, param_value);
   440	
   441		kfree(value_tmp);
   442		return ret;
   443	}
   444	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
